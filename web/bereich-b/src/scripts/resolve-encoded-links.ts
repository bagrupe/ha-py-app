import {
  findDocsInBatches,
  resolveTargetCollection,
  type BulkWriteOperation,
  type MigrationAdapter,
  type MigrationTarget,
} from './migration-batches'
import { getNestedValue } from './slate-to-lexical'

type LexicalNode = Record<string, unknown> & { children?: LexicalNode[] }

const ENCODED_RELATIVE_PATH = /^%2F/i

const resolveUrl = (url: string, baseUrl: string): string | undefined => {
  try {
    return new URL(decodeURIComponent(url), baseUrl).toString()
  } catch {
    return undefined
  }
}

/**
 * Payload's link hook URI-encoded relative hrefs that the importers used to pass through,
 * so `/redirect.phtml?...` was stored as `%2Fredirect.phtml%3F...`. Decoding and resolving
 * against the integration's base URL restores what the v1 importer produced.
 */
export function resolveEncodedLinks(
  node: LexicalNode,
  baseUrl: string,
): { node: LexicalNode; resolved: number } {
  let resolved = 0
  let changed = node

  const fields = node.fields as { url?: unknown } | undefined
  if (
    node.type === 'link' &&
    typeof fields?.url === 'string' &&
    ENCODED_RELATIVE_PATH.test(fields.url)
  ) {
    const url = resolveUrl(fields.url, baseUrl)
    if (url !== undefined) {
      resolved++
      changed = { ...node, fields: { ...fields, url } }
    }
  }

  if (!Array.isArray(node.children)) return { node: changed, resolved }

  const children = node.children.map((child) => {
    const result = resolveEncodedLinks(child, baseUrl)
    resolved += result.resolved
    return result.node
  })
  return resolved === 0 ? { node, resolved } : { node: { ...changed, children }, resolved }
}

type Logger = {
  info?: (obj: Record<string, unknown>, msg: string) => void
  warn: (obj: Record<string, unknown>, msg: string) => void
}

const resolveContent = (
  content: unknown,
  baseUrl: string,
): { content: unknown; resolved: number } => {
  const root = (content as { root?: LexicalNode } | null)?.root
  if (!root || typeof root !== 'object') return { content, resolved: 0 }
  const result = resolveEncodedLinks(root, baseUrl)
  return result.resolved === 0
    ? { content, resolved: 0 }
    : { content: { ...(content as object), root: result.node }, resolved: result.resolved }
}

const hasEncodedLink = (value: unknown): boolean => JSON.stringify(value).includes('"url":"%2F')

export async function loadIntegrationBaseUrls(
  adapter: MigrationAdapter,
  session?: unknown,
): Promise<Map<string, string>> {
  const { collection } = resolveTargetCollection(adapter, {
    collectionSlug: 'integration',
    field: 'url',
    type: 'inline',
  })
  const baseUrls = new Map<string, string>()
  for await (const docs of findDocsInBatches(collection, 'url', { session })) {
    for (const doc of docs) {
      if (typeof doc.url === 'string' && doc.url !== '') baseUrls.set(String(doc._id), doc.url)
    }
  }
  return baseUrls
}

export async function resolveEncodedLinksInTargets({
  adapter,
  baseUrlByIntegrationId,
  batchSize,
  logger,
  session,
  targets,
}: {
  adapter: MigrationAdapter
  baseUrlByIntegrationId: ReadonlyMap<string, string>
  batchSize?: number
  logger: Logger
  session?: unknown
  targets: readonly MigrationTarget[]
}): Promise<void> {
  for (const target of targets) {
    const { collection, collectionName, field } = resolveTargetCollection(adapter, target)
    const pathKeys = field.split('.')
    const integrationKeys = [...pathKeys.slice(0, -1), 'integration']
    let docsChanged = 0
    let linksResolved = 0
    let docsWithoutBaseUrl = 0

    for await (const docs of findDocsInBatches(collection, field, { batchSize, session })) {
      const operations: BulkWriteOperation[] = []
      for (const doc of docs) {
        const blocks = getNestedValue(doc, pathKeys)
        if (!Array.isArray(blocks) || !hasEncodedLink(blocks)) continue

        const integrationId = getNestedValue(doc, integrationKeys)
        const baseUrl =
          integrationId == null ? undefined : baseUrlByIntegrationId.get(String(integrationId))
        if (!baseUrl) {
          docsWithoutBaseUrl++
          logger.warn(
            { collection: collectionName, id: doc._id, integration: integrationId ?? null },
            'Encoded relative links left unchanged: no integration base url',
          )
          continue
        }

        let resolved = 0
        const updated = blocks.map((block: Record<string, unknown>) => {
          if (block?.blockType !== 'rich-text') return block
          const result = resolveContent(block.content, baseUrl)
          resolved += result.resolved
          return result.resolved === 0 ? block : { ...block, content: result.content }
        })

        if (resolved > 0) {
          docsChanged++
          linksResolved += resolved
          operations.push({
            updateOne: { filter: { _id: doc._id }, update: { $set: { [field]: updated } } },
          })
        }
      }

      if (operations.length > 0) await collection.bulkWrite(operations, { session })
    }

    logger.info?.(
      { collection: collectionName, field, docsChanged, linksResolved, docsWithoutBaseUrl },
      'Resolved encoded relative links',
    )
  }
}
