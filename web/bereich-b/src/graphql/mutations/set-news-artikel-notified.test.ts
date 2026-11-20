import * as GraphQL from 'graphql'
import type { GraphQLResolveInfo } from 'graphql'
import type { PayloadRequest } from 'payload'
import { describe, expect, it, vi } from 'vitest'
import type { GraphQLExtensionContext } from '../../utils/merge-queries'
import { setNewsArtikelNotified } from './set-news-artikel-notified'

describe('setNewsArtikelNotified', () => {
  it('enforces access control with the incoming request', async () => {
    const update = vi.fn().mockResolvedValue({ errors: [] })
    const req = { payload: { update } } as unknown as PayloadRequest
    const resolver = setNewsArtikelNotified(GraphQL, {} as GraphQLExtensionContext)

    await resolver.resolve(undefined, { ids: ['news-1'] }, { req }, {} as GraphQLResolveInfo)

    expect(update).toHaveBeenCalledWith({
      collection: 'news-artikel',
      where: { id: { in: ['news-1'] } },
      depth: 0,
      overrideAccess: false,
      req,
      data: { notified: true },
    })
  })
})
