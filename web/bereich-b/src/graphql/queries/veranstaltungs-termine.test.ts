import { describe, expect, it, vi } from 'vitest'
import * as GraphQL from 'graphql'

import { veranstaltungsTermineQuery } from './veranstaltungs-termine'

const createResolver = () => {
  const query = veranstaltungsTermineQuery(GraphQL, {} as never)
  return query.resolve!
}

const createPayload = (aggregate = vi.fn().mockResolvedValue([{ docs: [], totalCount: [] }])) => ({
  db: {
    collections: {
      veranstaltungskalender: { aggregate },
    },
  },
  find: vi.fn(),
})

describe('veranstaltungsTermineQuery', () => {
  it('keeps untereinheit ids as strings', async () => {
    const aggregate = vi.fn().mockResolvedValue([{ docs: [], totalCount: [] }])
    const payload = createPayload(aggregate)

    const resolver = createResolver()

    await resolver(
      undefined,
      { untereinheiten: ['d8f8f1a3-1d44-4d92-94c9-8a329d7ad2f5'] },
      { req: { payload } } as unknown as Parameters<typeof resolver>[2],
      {} as GraphQL.GraphQLResolveInfo,
    )

    expect(aggregate).toHaveBeenCalledTimes(1)
    expect(aggregate.mock.calls[0][0][0]).toEqual({
      $match: {
        visible: true,
        untereinheit: { $in: ['d8f8f1a3-1d44-4d92-94c9-8a329d7ad2f5'] },
      },
    })
  })

  it('forces visible events for anonymous requests', async () => {
    const aggregate = vi.fn().mockResolvedValue([{ docs: [], totalCount: [] }])
    const payload = createPayload(aggregate)
    const resolver = createResolver()

    await resolver(
      undefined,
      { visible: false },
      { req: { payload, user: null } } as unknown as Parameters<typeof resolver>[2],
      {} as GraphQL.GraphQLResolveInfo,
    )

    expect(aggregate.mock.calls[0][0][0]).toEqual({ $match: { visible: true } })
  })

  it('allows authenticated requests to retrieve hidden events', async () => {
    const aggregate = vi.fn().mockResolvedValue([{ docs: [], totalCount: [] }])
    const payload = createPayload(aggregate)
    const resolver = createResolver()

    await resolver(
      undefined,
      { visible: false },
      { req: { payload, user: { id: 'user-1' } } } as unknown as Parameters<typeof resolver>[2],
      {} as GraphQL.GraphQLResolveInfo,
    )

    expect(aggregate.mock.calls[0][0][0]).toEqual({ $match: { visible: false } })
  })

  it('returns an empty page for malformed ObjectId filters', async () => {
    const aggregate = vi.fn()
    const payload = createPayload(aggregate)

    const resolver = createResolver()

    const result = await resolver(
      undefined,
      { kommune: 'not-an-object-id', page: 2, limit: 5 },
      { req: { payload } } as unknown as Parameters<typeof resolver>[2],
      {} as GraphQL.GraphQLResolveInfo,
    )

    expect(aggregate).not.toHaveBeenCalled()
    expect(result).toEqual({
      docs: [],
      totalDocs: 0,
      page: 2,
      limit: 5,
      totalPages: 0,
      hasNextPage: false,
    })
  })

  it('matches kommune ids stored as ObjectIds or legacy strings', async () => {
    const aggregate = vi.fn().mockResolvedValue([{ docs: [], totalCount: [] }])
    const payload = createPayload(aggregate)
    const resolver = createResolver()
    const kommune = '65ae4370f399a4b34dcd359c'

    await resolver(
      undefined,
      { kommune },
      { req: { payload } } as unknown as Parameters<typeof resolver>[2],
      {} as GraphQL.GraphQLResolveInfo,
    )

    const match = aggregate.mock.calls[0][0][0].$match
    expect(match.kommune.$in).toHaveLength(2)
    expect(match.kommune.$in[0].toString()).toBe(kommune)
    expect(match.kommune.$in[1]).toBe(kommune)
  })

  it('normalizes stored date values before applying the range filter', async () => {
    const aggregate = vi.fn().mockResolvedValue([{ docs: [], totalCount: [] }])
    const payload = createPayload(aggregate)
    const resolver = createResolver()
    const von = '2026-06-10T00:00:00.000Z'
    const bis = '2026-12-07T21:27:04.172650Z'

    await resolver(
      undefined,
      { von, bis },
      { req: { payload } } as unknown as Parameters<typeof resolver>[2],
      {} as GraphQL.GraphQLResolveInfo,
    )

    const pipeline = aggregate.mock.calls[0][0]
    expect(pipeline[2]).toEqual({
      $addFields: {
        __startDate: {
          $convert: {
            input: '$timeAndLocation.dates.start',
            to: 'date',
            onError: null,
            onNull: null,
          },
        },
        __endDate: {
          $convert: {
            input: '$timeAndLocation.dates.end',
            to: 'date',
            onError: null,
            onNull: null,
          },
        },
      },
    })
    expect(pipeline[3]).toEqual({
      $match: {
        __startDate: {
          $gte: new Date(von),
          $lte: new Date(bis),
        },
      },
    })
    expect(pipeline[4]).toEqual({ $sort: { __startDate: 1 } })
  })
})
