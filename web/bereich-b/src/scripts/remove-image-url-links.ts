import {
  findDocsInBatches,
  resolveTargetCollection,
  type BulkWriteOperation,
  type MigrationAdapter,
  type MigrationTarget,
} from './migration-batches'
import { getNestedValue } from './slate-to-lexical'

type LexicalNode = Record<string, unknown> & { children?: LexicalNode[] }

const IMAGE_URL = /^https?:\/\/\S+\.(?:jpe?g|png|gif|webp|svg|avif)(?:\?\S*)?$/i

const textOf = (node: LexicalNode): string =>
  typeof node.text === 'string' ? node.text : (node.children ?? []).map(textOf).join('')

const fieldsOf = (link: LexicalNode): { newTab?: unknown; url?: unknown } =>
  typeof link.fields === 'object' && link.fields !== null ? link.fields : {}

const urlOf = (link: LexicalNode): string | undefined => {
  const { url } = fieldsOf(link)
  return typeof url === 'string' ? url : undefined
}

const isImageUrlLink = (link: LexicalNode): boolean => {
  const url = urlOf(link)
  return (
    url !== undefined &&
    IMAGE_URL.test(url) &&
    fieldsOf(link).newTab === true &&
    textOf(link).trim() === url
  )
}

const isEmptyUrlLink = (link: LexicalNode): boolean => urlOf(link)?.trim() === ''

const isBlankText = (node: LexicalNode): boolean =>
  node.type === 'text' && typeof node.text === 'string' && node.text.trim() === ''

/**
 * Removes the links the Slate -> Lexical catchup left behind for `img` nodes:
 * links whose visible text is their own image URL are dropped, links with an
 * empty url are replaced by their children. A parent emptied by that removal is
 * dropped too (v1 rendered nothing there), so no blank paragraph is left behind.
 */
export function removeImageUrlLinks(node: LexicalNode): {
  node: LexicalNode | undefined
  removed: number
} {
  if (!Array.isArray(node.children)) return { node, removed: 0 }

  let removed = 0
  const children = node.children.flatMap((child): LexicalNode[] => {
    const cleaned = removeImageUrlLinks(child)
    removed += cleaned.removed
    if (!cleaned.node) return []
    if (cleaned.node.type !== 'link') return [cleaned.node]
    if (isImageUrlLink(cleaned.node)) {
      removed++
      return []
    }
    if (isEmptyUrlLink(cleaned.node)) {
      removed++
      return cleaned.node.children ?? []
    }
    return [cleaned.node]
  })

  if (removed === 0) return { node, removed }
  const emptied = node.type !== 'root' && children.every(isBlankText)
  return { node: emptied ? undefined : { ...node, children }, removed }
}

type Logger = { info?: (obj: Record<string, unknown>, msg: string) => void }

const cleanContent = (content: unknown): { content: unknown; removed: number } => {
  const root = (content as { root?: LexicalNode } | null)?.root
  if (!root || typeof root !== 'object') return { content, removed: 0 }
  const cleaned = removeImageUrlLinks(root)
  return cleaned.removed === 0 || !cleaned.node
    ? { content, removed: 0 }
    : { content: { ...(content as object), root: cleaned.node }, removed: cleaned.removed }
}

export async function removeImageUrlLinksInTargets({
  adapter,
  batchSize,
  logger,
  session,
  targets,
}: {
  adapter: MigrationAdapter
  batchSize?: number
  logger: Logger
  session?: unknown
  targets: readonly MigrationTarget[]
}): Promise<void> {
  for (const target of targets) {
    const { collection, collectionName, field } = resolveTargetCollection(adapter, target)
    const pathKeys = field.split('.')
    let docsChanged = 0
    let linksRemoved = 0

    for await (const docs of findDocsInBatches(collection, field, { batchSize, session })) {
      const operations: BulkWriteOperation[] = []
      for (const doc of docs) {
        const value = getNestedValue(doc, pathKeys)
        let removed = 0
        let updated: unknown = value

        if (target.type === 'block' && Array.isArray(value)) {
          updated = value.map((block: Record<string, unknown>) => {
            if (block?.blockType !== 'rich-text') return block
            const cleaned = cleanContent(block.content)
            removed += cleaned.removed
            return cleaned.removed === 0 ? block : { ...block, content: cleaned.content }
          })
        } else if (target.type === 'inline') {
          const cleaned = cleanContent(value)
          removed = cleaned.removed
          updated = cleaned.content
        }

        if (removed > 0) {
          docsChanged++
          linksRemoved += removed
          operations.push({
            updateOne: { filter: { _id: doc._id }, update: { $set: { [field]: updated } } },
          })
        }
      }

      if (operations.length > 0) await collection.bulkWrite(operations, { session })
    }

    logger.info?.(
      { collection: collectionName, field, docsChanged, linksRemoved },
      'Removed image-url links',
    )
  }
}
