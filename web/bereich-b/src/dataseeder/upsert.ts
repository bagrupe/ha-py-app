import { type CollectionSlug, type Payload, type Where, getPayload } from 'payload'
import config from '@payload-config'
import { type UpsertStats } from './upsert-stats'

const normalize = (value: unknown): unknown => {
  if (value instanceof Date) return value.toISOString()
  if (Array.isArray(value)) return value.map(normalize)
  if (value !== null && typeof value === 'object') {
    const result: Record<string, unknown> = {}
    const entries = Object.entries(value as Record<string, unknown>)
    entries.sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0))
    for (const [k, v] of entries) {
      if (k === 'id') continue
      result[k] = normalize(v)
    }
    return result
  }
  return value
}

const toComparable = (v: unknown): unknown => (v instanceof Date ? v.toISOString() : v)

const isPrimitive = (v: unknown): boolean =>
  v === null || v === undefined || typeof v !== 'object' || v instanceof Date

export const hasDocChanges = (
  incoming: Record<string, unknown>,
  existing: Record<string, unknown>,
): boolean => {
  const keys = Object.keys(incoming)
  const deferredKeys: string[] = []

  // Tier 1: cheap scalar comparison — short-circuit on first mismatch
  for (const k of keys) {
    const inc = incoming[k]
    const ext = existing[k]
    if (isPrimitive(inc) && isPrimitive(ext)) {
      if (toComparable(inc) !== toComparable(ext)) return true
    } else {
      deferredKeys.push(k)
    }
  }

  // Tier 2: complex fields — normalize then stringify
  for (const k of deferredKeys) {
    const inc = incoming[k]
    const ext = existing[k]
    if (JSON.stringify(normalize(inc)) !== JSON.stringify(normalize(ext))) {
      return true
    }
  }

  return false
}

export type UpsertCache = Map<string, Record<string, unknown>>

const DUPLICATE_SENTINEL: Record<string, unknown> = Object.freeze({
  __duplicate: true,
})

const buildCacheKey = (keys: string[], data: Record<string, unknown>): string =>
  keys.map((k) => String(data[k])).join('\0')

export const prefetchCollection = async (
  collection: CollectionSlug,
  where: Where,
  keys: string | string[],
): Promise<UpsertCache> => {
  const payload = await getPayload({ config })
  const { docs } = await payload.find({
    collection,
    where,
    pagination: false,
    depth: 0,
    overrideAccess: true,
  })
  const cache: UpsertCache = new Map()
  const keyArray = Array.isArray(keys) ? keys : [keys]
  for (const doc of docs) {
    const cacheKey = buildCacheKey(keyArray, doc as unknown as Record<string, unknown>)
    if (cache.has(cacheKey)) {
      payload.logger.warn(
        { collection, cacheKey },
        `prefetchCollection: duplicate key detected — falling back to DB lookup for this key`,
      )
      cache.set(cacheKey, DUPLICATE_SENTINEL)
    } else {
      cache.set(cacheKey, doc as unknown as Record<string, unknown>)
    }
  }
  return cache
}

export const upsert = async <T extends CollectionSlug>(
  optionsAndKey: {
    collection: T
    data: Record<string, unknown>
    key: string | string[]
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    file?: any
    overwriteExistingFiles?: boolean
  },
  opts?: {
    checkForImportLock?: boolean
    cache?: UpsertCache
    payload?: Payload
    stats?: UpsertStats
  },
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
): Promise<any> => {
  const { checkForImportLock, cache, payload: payloadArg, stats } = opts ?? {}
  const payload = payloadArg ?? (await getPayload({ config }))
  const { key, collection, data, file, overwriteExistingFiles } = optionsAndKey
  const keys = Array.isArray(key) ? key : [key]
  const cacheKey = buildCacheKey(keys, data)

  let totalDocs: number
  let firstDoc: Record<string, unknown> | undefined

  // A cache miss is NOT authoritative absence — the prefetch query can come up
  // empty for records that exist (e.g. v1-string vs v3-ObjectId relationship
  // values), so a miss must be re-checked against the DB before creating.
  const cached = cache?.get(cacheKey)
  if (cached && cached !== DUPLICATE_SENTINEL) {
    totalDocs = 1
    firstDoc = cached
  } else {
    const where: Where = {
      and: keys.map((k) => ({
        [k]: { equals: data[k] },
      })),
    }
    const result = await payload.find({
      collection,
      where,
      limit: 2,
      depth: 0,
      overrideAccess: true,
    })
    totalDocs = result.totalDocs
    firstDoc = result.docs[0] as unknown as Record<string, unknown>
  }

  if (totalDocs > 1) {
    throw new Error('Key is not unique')
  }
  if (totalDocs === 1 && firstDoc) {
    const id = firstDoc.id as string

    if (checkForImportLock) {
      const lockedForImport = 'lockedForImport' in firstDoc && firstDoc.lockedForImport
      if (lockedForImport) {
        stats?.track(collection as string, 'skipped')
        console.info(`${collection}: Skipped ${data[keys[0]]} because it is locked for import`)
        return
      }
    }

    if (!hasDocChanges(data, firstDoc)) {
      stats?.track(collection as string, 'unchanged')
      return firstDoc
    }

    const result = await payload.update({
      collection,
      id,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      data: data as any,
      file,
      overwriteExistingFiles,
      overrideAccess: true,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } as any)
    stats?.track(collection as string, 'updated')
    console.info(`${collection}: Updated ${data[keys[0]]}`)
    return result
  } else {
    const result = await payload.create({
      collection,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      data: data as any,
      file,
      overwriteExistingFiles,
      overrideAccess: true,
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
    } as any)
    stats?.track(collection as string, 'created')
    console.info(`${collection}: Created ${data[keys[0]]}`)
    return result
  }
}
