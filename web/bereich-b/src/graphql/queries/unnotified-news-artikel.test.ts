import * as GraphQL from 'graphql'
import type { GraphQLResolveInfo } from 'graphql'
import type { PayloadRequest } from 'payload'
import { describe, expect, it, vi } from 'vitest'
import type { GraphQLExtensionContext } from '../../utils/merge-queries'
import { unnotifiedNewsArtikel } from './unnotified-news-artikel'

const createResolver = () => {
  const context = {
    collections: {
      'news-artikel': {
        graphQL: { type: new GraphQL.GraphQLObjectType({ name: 'NewsArtikelTest', fields: {} }) },
      },
    },
  } as unknown as GraphQLExtensionContext
  return unnotifiedNewsArtikel(GraphQL, context).resolve
}

describe('unnotifiedNewsArtikel', () => {
  it('rejects anonymous requests before querying Payload', async () => {
    const find = vi.fn()
    const req = { payload: { find }, user: null } as unknown as PayloadRequest

    await expect(
      createResolver()(
        undefined,
        { from: '2026-01-01', until: '2026-01-02' },
        { req },
        {} as GraphQLResolveInfo,
      ),
    ).rejects.toMatchObject({ extensions: { code: 'UNAUTHENTICATED' } })
    expect(find).not.toHaveBeenCalled()
  })

  it('enforces access and selects only published, visible notification candidates', async () => {
    const find = vi.fn().mockResolvedValue({ docs: [{ id: 'news-1' }] })
    const req = { payload: { find }, user: { id: 'service-user' } } as unknown as PayloadRequest
    const from = '2026-01-01T00:00:00.000Z'
    const until = '2026-01-02T00:00:00.000Z'

    const result = await createResolver()(
      undefined,
      { from, until },
      { req },
      {} as GraphQLResolveInfo,
    )

    expect(result).toEqual([{ id: 'news-1' }])
    expect(find).toHaveBeenCalledWith({
      collection: 'news-artikel',
      draft: false,
      depth: 0,
      overrideAccess: false,
      req,
      where: {
        notified: { not_equals: true },
        and: [
          { _status: { equals: 'published' } },
          { visible: { equals: true } },
          { datum: { greater_than_equal: new Date(from) } },
          { datum: { less_than_equal: new Date(until) } },
        ],
      },
    })
  })
})
