export type MigrationTarget = {
  collectionSlug: string
  field: string
  type: 'block' | 'inline'
  versions?: boolean
}

export type MigrationAdapter = {
  collections: Record<string, { collection: unknown }>
  versions?: Record<string, { collection: unknown }>
}

export type DocumentWithId = Record<string, unknown> & { _id: unknown }

export type BulkWriteOperation = {
  updateOne: {
    filter: { _id: unknown }
    update: { $set: Record<string, unknown> }
  }
}

export type CollectionLike = {
  find: (
    filter: Record<string, unknown>,
    options?: { session?: unknown },
  ) => {
    sort: (sort: { _id: 1 }) => {
      limit: (limit: number) => {
        toArray: () => Promise<DocumentWithId[]>
      }
    }
  }
  bulkWrite: (operations: BulkWriteOperation[], options?: { session?: unknown }) => Promise<unknown>
}

export type BatchOptions = {
  batchSize?: number
  session?: unknown
}

export function resolveTargetCollection(
  adapter: MigrationAdapter,
  target: MigrationTarget,
): { collection: CollectionLike; collectionName: string; field: string } {
  const models = target.versions ? adapter.versions : adapter.collections
  const model = models?.[target.collectionSlug]
  if (!model) {
    throw new Error(
      `Cannot resolve ${target.versions ? 'versions' : 'collection'} model for ${target.collectionSlug}`,
    )
  }
  return {
    collection: model.collection as CollectionLike,
    collectionName: target.versions ? `${target.collectionSlug} versions` : target.collectionSlug,
    field: target.versions ? `version.${target.field}` : target.field,
  }
}

export async function* findDocsInBatches(
  collection: CollectionLike,
  fieldName: string,
  { batchSize = 250, session }: BatchOptions = {},
): AsyncGenerator<DocumentWithId[]> {
  let lastId: unknown
  while (true) {
    const query: Record<string, unknown> = { [fieldName]: { $exists: true, $ne: null } }
    if (lastId !== undefined) query._id = { $gt: lastId }

    const docs = await collection
      .find(query, { session })
      .sort({ _id: 1 })
      .limit(batchSize)
      .toArray()
    if (docs.length === 0) return

    yield docs
    lastId = docs[docs.length - 1]?._id
    if (lastId === undefined) throw new Error('Cannot paginate: document is missing _id')
  }
}
