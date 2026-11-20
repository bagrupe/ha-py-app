import { beforeEach, describe, expect, it, vi } from 'vitest'

type StoredDoc = {
  id: string
  regionalschluessel: string
  rect: unknown
  geojson: unknown
  abgerufenAm?: string
  quellHash?: string | null
}

type Bundled = {
  regionalschluessel: string
  rect: { minlat: number; minlon: number; maxlat: number; maxlon: number }
  geojson: { type: 'FeatureCollection'; features: unknown[] }
  abgerufenAm: string
  hash: string
}

const POLYGON = {
  type: 'Feature',
  properties: {},
  geometry: {
    type: 'Polygon',
    coordinates: [
      [
        [9, 52],
        [9.4, 52],
        [9.4, 52.2],
        [9, 52],
      ],
    ],
  },
}

const mocks = vi.hoisted(() => ({
  overpass: vi.fn(),
  gemeinden: [] as { id: string; name: string; regionalschluessel?: string }[],
  store: [] as StoredDoc[],
  bundled: new Map<string, unknown>(),
  features: [] as unknown[],
  find: vi.fn(),
  create: vi.fn(),
  update: vi.fn(),
  createError: undefined as Error | undefined,
}))

vi.mock('@payload-config', () => ({ default: {} }))
vi.mock('overpass-ts', () => ({ overpass: mocks.overpass }))
vi.mock('osmtogeojson', () => ({
  default: () => ({ type: 'FeatureCollection', features: mocks.features }),
}))
vi.mock('../import-veranstaltungen/utils/bundled-boundaries', () => ({
  getBundledBoundary: (key: string) => mocks.bundled.get(key),
}))
vi.mock('payload', () => ({
  getPayload: async () => ({
    find: async (args: {
      collection: string
      select?: { quellHash?: boolean }
      where?: { regionalschluessel?: { equals: string } }
    }) => {
      mocks.find(args)
      if (args.collection === 'untereinheit') return { docs: mocks.gemeinden }
      const key = args.where?.regionalschluessel?.equals
      const docs = mocks.store.filter((doc) => doc.regionalschluessel === key)
      return {
        docs: args.select ? docs.map(({ id, quellHash }) => ({ id, quellHash })) : docs,
      }
    },
    create: async ({ data }: { data: Omit<StoredDoc, 'id'> }) => {
      mocks.create(data)
      if (mocks.createError) {
        const error = mocks.createError
        mocks.createError = undefined
        throw error
      }
      mocks.store.push({ id: `doc-${mocks.store.length}`, ...data })
    },
    update: async ({ id, data }: { id: string; data: Partial<StoredDoc> }) => {
      mocks.update(id, data)
      const doc = mocks.store.find((d) => d.id === id)
      if (doc) Object.assign(doc, data)
    },
  }),
}))

import { CronJobItemFailures } from '../cron-job-item-failures'
import {
  getGemeindenBoundsForKommune,
  getLocationBoundsByRegionalKey,
} from '../import-veranstaltungen/utils/location-bounds-service'

const RECT = { minlat: 51.8, minlon: 9.0, maxlat: 52.2, maxlon: 9.6 }

const relationResponse = (bounds: Record<string, number> = RECT) => ({
  json: async () => ({ elements: [{ type: 'relation', bounds }] }),
})

const bundle = (key: string, hash = 'hash-1', rect = { ...RECT, minlat: 1 }): Bundled => {
  const entry = {
    regionalschluessel: key,
    rect,
    geojson: { type: 'FeatureCollection' as const, features: [POLYGON] },
    abgerufenAm: '2026-10-06T09:00:00.000Z',
    hash,
  }
  mocks.bundled.set(key, entry)
  return entry
}

beforeEach(() => {
  mocks.overpass.mockReset()
  mocks.find.mockReset()
  mocks.create.mockReset()
  mocks.update.mockReset()
  mocks.gemeinden = []
  mocks.store = []
  mocks.bundled = new Map()
  mocks.features = [POLYGON]
  mocks.createError = undefined
  vi.spyOn(console, 'info').mockImplementation(() => {})
  vi.spyOn(console, 'warn').mockImplementation(() => {})
  vi.spyOn(console, 'error').mockImplementation(() => {})
})

describe('getLocationBoundsByRegionalKey for a key that is not bundled', () => {
  it('fetches from Overpass on a miss and stores the result', async () => {
    mocks.overpass.mockResolvedValue(relationResponse())

    const bounds = await getLocationBoundsByRegionalKey('X')

    expect(bounds.rect).toEqual(RECT)
    expect(mocks.overpass).toHaveBeenCalledTimes(1)
    expect(mocks.store).toHaveLength(1)
    expect(mocks.store[0]).toMatchObject({ regionalschluessel: 'X', rect: RECT, quellHash: null })
  })

  it('asks Overpass only once per regional key across runs', async () => {
    mocks.overpass.mockResolvedValue(relationResponse())

    const first = await getLocationBoundsByRegionalKey('X')
    const second = await getLocationBoundsByRegionalKey('X')

    expect(mocks.overpass).toHaveBeenCalledTimes(1)
    expect(second).toEqual(first)
  })

  it('uses an already stored entry without calling Overpass', async () => {
    mocks.store.push({
      id: 'doc-0',
      regionalschluessel: 'X',
      rect: { minlat: 1, minlon: 2, maxlat: 3, maxlon: 4 },
      geojson: { type: 'FeatureCollection', features: [] },
    })

    const bounds = await getLocationBoundsByRegionalKey('X')

    expect(mocks.overpass).not.toHaveBeenCalled()
    expect(bounds.rect).toEqual({ minlat: 1, minlon: 2, maxlat: 3, maxlon: 4 })
  })

  it('stores nothing and rethrows when Overpass fails', async () => {
    mocks.overpass.mockRejectedValue(new Error('Overpass Error: 504 Gateway Timeout'))

    await expect(getLocationBoundsByRegionalKey('X')).rejects.toThrow('504')

    expect(mocks.store).toHaveLength(0)
  })

  it('treats a runtime error reported with status 200 as a failure', async () => {
    mocks.overpass.mockResolvedValue({
      json: async () => ({ elements: [], remark: 'runtime error: Query timed out' }),
    })

    await expect(getLocationBoundsByRegionalKey('X')).rejects.toThrow('runtime error')

    expect(mocks.store).toHaveLength(0)
  })

  it('does not store a missing boundary', async () => {
    mocks.overpass.mockResolvedValue({ json: async () => ({ elements: [] }) })
    mocks.features = []

    const bounds = await getLocationBoundsByRegionalKey('X')
    await getLocationBoundsByRegionalKey('X')

    expect(bounds.geojson.features).toEqual([])
    expect(mocks.store).toHaveLength(0)
    expect(mocks.overpass).toHaveBeenCalledTimes(2)
  })

  it('throws for a required boundary that cannot be found', async () => {
    mocks.overpass.mockResolvedValue({ json: async () => ({ elements: [] }) })
    mocks.features = []

    await expect(getLocationBoundsByRegionalKey('X', { required: true })).rejects.toThrow(
      'keine brauchbare Grenze',
    )
    expect(mocks.store).toHaveLength(0)
  })

  it('does not store a relation that has no polygon', async () => {
    mocks.overpass.mockResolvedValue(relationResponse())
    mocks.features = [{ type: 'Feature', properties: {}, geometry: { type: 'Point' } }]

    await getLocationBoundsByRegionalKey('X')

    expect(mocks.store).toHaveLength(0)
  })

  it('does not store a relation without usable bounds', async () => {
    mocks.overpass.mockResolvedValue({ json: async () => ({ elements: [{ type: 'relation' }] }) })

    await getLocationBoundsByRegionalKey('X')

    expect(mocks.store).toHaveLength(0)
  })

  it('returns the fetched boundary when a parallel run stored it first', async () => {
    mocks.overpass.mockImplementation(async () => {
      mocks.store.push({
        id: 'doc-parallel',
        regionalschluessel: 'X',
        rect: RECT,
        geojson: { type: 'FeatureCollection', features: [POLYGON] },
      })
      return relationResponse()
    })
    mocks.createError = new Error('E11000 duplicate key')

    const bounds = await getLocationBoundsByRegionalKey('X')

    expect(bounds.rect.minlat).toBe(51.8)
    expect(mocks.store).toHaveLength(1)
  })

  it('rethrows a failed save when nothing was stored by another run', async () => {
    mocks.overpass.mockResolvedValue(relationResponse())
    mocks.createError = new Error('database unavailable')

    await expect(getLocationBoundsByRegionalKey('X')).rejects.toThrow('database unavailable')
  })
})

describe('getLocationBoundsByRegionalKey for a bundled key', () => {
  it('creates the entry from the bundled data without calling Overpass', async () => {
    const entry = bundle('B')

    const bounds = await getLocationBoundsByRegionalKey('B')

    expect(mocks.overpass).not.toHaveBeenCalled()
    expect(bounds.rect).toEqual(entry.rect)
    expect(mocks.store).toHaveLength(1)
    expect(mocks.store[0]).toMatchObject({ regionalschluessel: 'B', quellHash: 'hash-1' })
  })

  it('reads only the hash of the stored entry for a bundled key', async () => {
    bundle('B')

    await getLocationBoundsByRegionalKey('B')

    expect(mocks.find).toHaveBeenCalledWith(
      expect.objectContaining({ collection: 'osm-grenzen', select: { quellHash: true } }),
    )
  })

  it('still returns the bundled boundary when it cannot be saved', async () => {
    const entry = bundle('B')
    mocks.createError = new Error('database unavailable')

    const bounds = await getLocationBoundsByRegionalKey('B')

    expect(bounds.rect).toEqual(entry.rect)
    expect(mocks.overpass).not.toHaveBeenCalled()
    expect(console.warn).toHaveBeenCalledWith(expect.stringContaining('nicht in osm-grenzen'))
  })

  it('leaves an up-to-date entry untouched', async () => {
    bundle('B')
    await getLocationBoundsByRegionalKey('B')
    mocks.create.mockClear()

    await getLocationBoundsByRegionalKey('B')

    expect(mocks.create).not.toHaveBeenCalled()
    expect(mocks.update).not.toHaveBeenCalled()
  })

  it('restores a deleted entry from the bundled data, never from Overpass', async () => {
    bundle('B')
    await getLocationBoundsByRegionalKey('B')
    mocks.store = []

    const bounds = await getLocationBoundsByRegionalKey('B')

    expect(mocks.overpass).not.toHaveBeenCalled()
    expect(bounds.rect.minlat).toBe(1)
    expect(mocks.store).toHaveLength(1)
  })

  it('updates a stored entry when the bundled data changed', async () => {
    bundle('B', 'hash-1')
    await getLocationBoundsByRegionalKey('B')
    bundle('B', 'hash-2', { ...RECT, minlat: 7 })

    const bounds = await getLocationBoundsByRegionalKey('B')

    expect(bounds.rect.minlat).toBe(7)
    expect(mocks.update).toHaveBeenCalledTimes(1)
    expect(mocks.store).toHaveLength(1)
    expect(mocks.store[0]).toMatchObject({ quellHash: 'hash-2', rect: { minlat: 7 } })
  })

  it('replaces an entry that was fetched from Overpass before the key was bundled', async () => {
    mocks.store.push({
      id: 'doc-0',
      regionalschluessel: 'B',
      rect: { ...RECT, minlat: 99 },
      geojson: { type: 'FeatureCollection', features: [] },
      quellHash: null,
    })
    bundle('B')

    await getLocationBoundsByRegionalKey('B')

    expect(mocks.overpass).not.toHaveBeenCalled()
    expect(mocks.store[0]).toMatchObject({ quellHash: 'hash-1', rect: { minlat: 1 } })
  })
})

describe('getGemeindenBoundsForKommune', () => {
  beforeEach(() => {
    mocks.gemeinden = [
      { id: 'g1', name: 'Aerzen', regionalschluessel: 'G1' },
      { id: 'g2', name: 'Ohne Schluessel' },
      { id: 'g3', name: 'Hameln', regionalschluessel: 'G3' },
    ]
  })

  it('skips Gemeinden without a key', async () => {
    mocks.overpass.mockResolvedValue(relationResponse())

    const bounds = await getGemeindenBoundsForKommune('kommune-1')

    expect(bounds.map((entry) => Object.keys(entry)[0])).toEqual(['g1', 'g3'])
  })

  it('asks Overpass only on the first run', async () => {
    mocks.overpass.mockResolvedValue(relationResponse())

    const first = await getGemeindenBoundsForKommune('kommune-1')
    const second = await getGemeindenBoundsForKommune('kommune-1')

    expect(mocks.overpass).toHaveBeenCalledTimes(2)
    expect(second).toEqual(first)
  })

  it('skips a Gemeinde whose lookup fails, counts it and keeps the others', async () => {
    const failures = new CronJobItemFailures()
    mocks.overpass
      .mockRejectedValueOnce(new Error('Overpass Error: 429 Rate Limit Exceeded'))
      .mockResolvedValueOnce(relationResponse())

    const bounds = await getGemeindenBoundsForKommune('kommune-1', failures)

    expect(bounds.map((entry) => Object.keys(entry)[0])).toEqual(['g3'])
    expect(failures.getCount()).toBe(1)
  })

  it('keeps already fetched boundaries and resumes with the missing one on the next run', async () => {
    mocks.overpass
      .mockResolvedValueOnce(relationResponse())
      .mockRejectedValueOnce(new Error('Overpass Error: 504 Gateway Timeout'))

    const first = await getGemeindenBoundsForKommune('kommune-1')
    expect(first).toHaveLength(1)
    expect(mocks.store.map((doc) => doc.regionalschluessel)).toEqual(['G1'])

    mocks.overpass.mockResolvedValue(relationResponse())
    const second = await getGemeindenBoundsForKommune('kommune-1')

    expect(second).toHaveLength(2)
    expect(mocks.overpass).toHaveBeenCalledTimes(3)
    expect(mocks.store.map((doc) => doc.regionalschluessel)).toEqual(['G1', 'G3'])
  })

  it('makes no Overpass request for bundled keys', async () => {
    bundle('G1')
    bundle('G3')

    const bounds = await getGemeindenBoundsForKommune('kommune-1')

    expect(mocks.overpass).not.toHaveBeenCalled()
    expect(bounds).toHaveLength(2)
  })
})

describe('getLocationBoundsByRegionalKey for the Landkreis', () => {
  it('still fails the run when its boundary cannot be fetched', async () => {
    mocks.overpass.mockRejectedValue(new Error('Overpass Error: 504 Gateway Timeout'))

    await expect(getLocationBoundsByRegionalKey('LK')).rejects.toThrow('504')
  })
})
