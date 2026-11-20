import type { Payload } from 'payload'
import { describe, expect, it, vi } from 'vitest'
import { upsert } from '../upsert'

describe('upsert', () => {
  it('uses a supplied Payload instance during startup', async () => {
    const find = vi.fn().mockResolvedValue({ docs: [], totalDocs: 0 })
    const create = vi.fn().mockResolvedValue({ id: 'created-user' })
    const payload = { create, find } as unknown as Payload

    await upsert(
      {
        collection: 'benutzer',
        key: 'email',
        data: { email: 'admin@example.com' },
      },
      { payload },
    )

    expect(find).toHaveBeenCalledOnce()
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({
        collection: 'benutzer',
        data: { email: 'admin@example.com' },
      }),
    )
  })
})

// Payload v3 stores relationship references as ObjectId (v1 used strings) and
// coerces relationship query operands to ObjectId. While migrated news-artikel
// still carried v1's string-typed `kommune`, the importer's prefetch query
// `{ kommune: { equals: <id> } }` matched nothing, so the de-dup cache handed to
// `upsert` was MISSING records that already existed. `upsert` then took the
// create branch and produced a duplicate per active feed article (the repeated
// news cards). These tests pin the contract that a cache MISS must never be
// treated as an authoritative "does not exist".
describe('upsert — cache miss must not duplicate an existing record (v3 regression)', () => {
  const makePayload = (existing?: Record<string, unknown>) => {
    const find = vi
      .fn()
      .mockResolvedValue(existing ? { docs: [existing], totalDocs: 1 } : { docs: [], totalDocs: 0 })
    const create = vi.fn().mockResolvedValue({ id: 'created' })
    const update = vi.fn().mockResolvedValue({ id: 'updated' })
    return {
      payload: { find, create, update } as unknown as Payload,
      find,
      create,
      update,
    }
  }

  it('does not create a duplicate when the record exists but is absent from the cache', async () => {
    const existing = { id: 'news-1', importId: 'A1', kommune: 'k1', titel: 'Old' }
    const { payload, find, create, update } = makePayload(existing)

    await upsert(
      {
        collection: 'news-artikel',
        key: ['importId', 'kommune'],
        data: { importId: 'A1', kommune: 'k1', titel: 'New' },
      },
      // empty cache = prefetch returned nothing for this (importId, kommune)
      { cache: new Map(), payload },
    )

    expect(find).toHaveBeenCalled()
    expect(create).not.toHaveBeenCalled()
    expect(update).toHaveBeenCalledWith(expect.objectContaining({ id: 'news-1' }))
  })

  it('still creates a genuinely new record that is absent from both cache and DB', async () => {
    const { payload, create } = makePayload(undefined)

    await upsert(
      {
        collection: 'news-artikel',
        key: ['importId', 'kommune'],
        data: { importId: 'NEW', kommune: 'k1', titel: 'Brand new' },
      },
      { cache: new Map(), payload },
    )

    expect(create).toHaveBeenCalledOnce()
  })
})
