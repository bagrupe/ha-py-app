/**
 * Slate -> Lexical conversion utilities used by native Payload migrations.
 */
import { convertSlateToLexical, defaultSlateConverters } from '@payloadcms/richtext-lexical/migrate'
import { z } from 'zod'
import {
  findDocsInBatches,
  resolveTargetCollection,
  type BatchOptions,
  type BulkWriteOperation,
  type CollectionLike,
  type DocumentWithId,
  type MigrationAdapter,
  type MigrationTarget,
} from './migration-batches'

type SlateNode = Record<string, unknown> & { children?: unknown[] }

const isSlateNode = (value: unknown): value is SlateNode =>
  typeof value === 'object' && value !== null && !Array.isArray(value)

// Slate `img` nodes are produced by the IKISS/RSS importers and have no Lexical
// equivalent. v1 rendered them as nothing (unknown node type, no children text),
// so they are dropped together with any element left without content.
export function pruneSlateImages(nodes: unknown[]): unknown[] {
  return nodes.flatMap((node) => {
    if (!isSlateNode(node)) return [node]
    if (node.type === 'img') return []
    if (!Array.isArray(node.children) || node.children.length === 0) return [node]

    const children = pruneSlateImages(node.children)
    return children.length === 0 ? [] : [{ ...node, children }]
  })
}

const slateNodeSchema: z.ZodType<Record<string, unknown> & { children: unknown[] }> = z
  .object({ children: z.array(z.unknown()) })
  .passthrough()

const slateArraySchema = z.array(slateNodeSchema).nonempty()

const lexicalRootSchema = z
  .object({
    root: z
      .object({
        type: z.literal('root'),
        children: z.array(z.unknown()),
      })
      .passthrough(),
  })
  .passthrough()

export const EMPTY_LEXICAL_ROOT = {
  root: {
    type: 'root',
    children: [
      { type: 'paragraph', children: [], direction: null, format: '', indent: 0, version: 1 },
    ],
    direction: null,
    format: '',
    indent: 0,
    version: 1,
  },
}

export type SlateToLexicalMigrationTarget = MigrationTarget
export type SlateToLexicalAdapter = MigrationAdapter

export type MigrationResult = { total: number; migrated: number; skipped: number; warnings: number }

type Logger = {
  error?: (obj: Record<string, unknown>, msg: string) => void
  info?: (obj: Record<string, unknown>, msg: string) => void
  warn: (obj: Record<string, unknown>, msg: string) => void
}

export function isSlateArray(value: unknown): value is z.infer<typeof slateArraySchema> {
  return slateArraySchema.safeParse(value).success
}

export function isLexicalRoot(value: unknown): boolean {
  return lexicalRootSchema.safeParse(value).success
}

export function convertContent(content: unknown): {
  converted: unknown
  status: 'migrated' | 'empty' | 'skipped'
} {
  if (content == null || isLexicalRoot(content)) {
    return { converted: content, status: 'skipped' }
  }
  if (Array.isArray(content) && content.length === 0) {
    return { converted: EMPTY_LEXICAL_ROOT, status: 'empty' }
  }

  const parsed = slateArraySchema.safeParse(content)
  if (parsed.success) {
    const slateData = pruneSlateImages(parsed.data)
    if (slateData.length === 0) {
      return { converted: EMPTY_LEXICAL_ROOT, status: 'migrated' }
    }
    return {
      converted: convertSlateToLexical({
        converters: defaultSlateConverters,
        slateData: slateData as Parameters<typeof convertSlateToLexical>[0]['slateData'],
      }),
      status: 'migrated',
    }
  }

  throw new Error('Expected Slate richText JSON, Lexical richText JSON, or an empty value')
}

export function getNestedValue(obj: Record<string, unknown>, path: readonly string[]): unknown {
  let current: unknown = obj
  for (const key of path) {
    if (current == null || typeof current !== 'object') return undefined
    current = (current as Record<string, unknown>)[key]
  }
  return current
}

function formatError(error: unknown): string {
  return error instanceof Error ? error.message : String(error)
}

function describeValue(value: unknown): string {
  if (value === null) return 'null'
  if (Array.isArray(value)) return `array(length=${value.length})`
  return typeof value
}

export async function migrateCollection(
  logger: Logger,
  collection: CollectionLike,
  collectionName: string,
  fieldName: string,
  type: 'block' | 'inline',
  batchOptions: BatchOptions = {},
): Promise<MigrationResult> {
  const result: MigrationResult = { total: 0, migrated: 0, skipped: 0, warnings: 0 }
  const pathKeys = fieldName.split('.')

  const warnAndSkip = (
    doc: DocumentWithId,
    value: unknown,
    error: unknown,
    blockIndex?: number,
  ) => {
    result.skipped++
    result.warnings++
    logger.warn(
      {
        ...(blockIndex === undefined ? {} : { blockIndex }),
        collection: collectionName,
        error: formatError(error),
        field: fieldName,
        id: doc._id,
        valueType: describeValue(value),
      },
      'Slate -> Lexical migration skipped malformed content',
    )
  }

  for await (const docs of findDocsInBatches(collection, fieldName, batchOptions)) {
    result.total += docs.length
    const bulkOps: BulkWriteOperation[] = []

    for (const doc of docs) {
      const value = getNestedValue(doc, pathKeys)
      if (value == null) continue

      if (type === 'block') {
        if (!Array.isArray(value)) {
          warnAndSkip(doc, value, new Error(`Expected blocks array at ${fieldName}`))
          continue
        }

        let changed = false
        const updatedBlocks = value.map((block, blockIndex) => {
          if (block == null || typeof block !== 'object' || Array.isArray(block)) {
            warnAndSkip(doc, block, new Error(`Expected block object at ${fieldName}`), blockIndex)
            return block
          }

          const blockRecord = block as Record<string, unknown>
          if (blockRecord.blockType !== 'rich-text') return blockRecord

          try {
            const { converted, status } = convertContent(blockRecord.content)
            if (status === 'skipped') {
              result.skipped++
              return blockRecord
            }

            changed = true
            return { ...blockRecord, content: converted }
          } catch (error) {
            warnAndSkip(doc, blockRecord.content, error, blockIndex)
            return blockRecord
          }
        })

        if (changed) {
          bulkOps.push({
            updateOne: {
              filter: { _id: doc._id },
              update: { $set: { [fieldName]: updatedBlocks } },
            },
          })
          result.migrated++
        }
      } else {
        try {
          const { converted, status } = convertContent(value)
          if (status === 'skipped') {
            result.skipped++
            continue
          }

          bulkOps.push({
            updateOne: {
              filter: { _id: doc._id },
              update: { $set: { [fieldName]: converted } },
            },
          })
          result.migrated++
        } catch (error) {
          warnAndSkip(doc, value, error)
        }
      }
    }

    if (bulkOps.length > 0) {
      await collection.bulkWrite(bulkOps, { session: batchOptions.session })
    }
  }

  return result
}

export async function migrateTargets({
  adapter,
  batchSize,
  logger,
  session,
  targets,
}: {
  adapter: SlateToLexicalAdapter
  batchSize?: number
  logger: Logger
  session?: unknown
  targets: readonly SlateToLexicalMigrationTarget[]
}): Promise<void> {
  for (const target of targets) {
    const { collection, collectionName, field } = resolveTargetCollection(adapter, target)

    logger.info?.({ collection: collectionName, field }, 'Starting Slate -> Lexical migration')
    const result = await migrateCollection(logger, collection, collectionName, field, target.type, {
      batchSize,
      session,
    })
    logger.info?.(
      { collection: collectionName, field, ...result },
      'Finished Slate -> Lexical migration',
    )
    if (result.warnings > 0) {
      logger.error?.(
        { collection: collectionName, field, warnings: result.warnings },
        'Slate -> Lexical migration skipped unconvertible documents — repair manually (see warn logs above for ids)',
      )
    }
  }
}
