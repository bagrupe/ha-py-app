import * as GraphQL from 'graphql'
import type { GraphQLResolveInfo } from 'graphql'
import type { PayloadRequest } from 'payload'
import { describe, expect, it, vi } from 'vitest'
import type { GraphQLExtensionContext } from '../../utils/merge-queries'
import { kommuneByBereichAIdQuery } from './kommune-by-bereich-a-id'

describe('kommuneByBereichAIdQuery', () => {
  it('enforces access control with the incoming request', async () => {
    const find = vi.fn().mockResolvedValue({ docs: [{ id: 'kommune-1' }] })
    const req = { payload: { find } } as unknown as PayloadRequest
    const context = {
      collections: {
        kommunen: {
          graphQL: { type: new GraphQL.GraphQLObjectType({ name: 'KommuneTest', fields: {} }) },
        },
      },
    } as unknown as GraphQLExtensionContext
    const resolver = kommuneByBereichAIdQuery(GraphQL, context).resolve

    const result = await resolver(
      undefined,
      { kommuneId: 'bereich-a-1' },
      { req },
      {} as GraphQLResolveInfo,
    )

    expect(result).toEqual({ id: 'kommune-1' })
    expect(find).toHaveBeenCalledWith({
      collection: 'kommunen',
      depth: 0,
      overrideAccess: false,
      req,
      where: { bereichAId: { equals: 'bereich-a-1' } },
    })
  })
})
