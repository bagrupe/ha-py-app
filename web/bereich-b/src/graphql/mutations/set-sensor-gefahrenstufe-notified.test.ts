import * as GraphQL from 'graphql'
import type { GraphQLResolveInfo } from 'graphql'
import type { PayloadRequest } from 'payload'
import { describe, expect, it, vi } from 'vitest'
import type { GraphQLExtensionContext } from '../../utils/merge-queries'
import { setSensorGefahrenstufeNotified } from './set-sensor-gefahrenstufe-notified'

describe('setSensorGefahrenstufeNotified', () => {
  it('sets letzteBenachrichtigteGefahrenstufe and ausstehendeGefahrenstufe when confirmed', async () => {
    const update = vi.fn().mockResolvedValue({ errors: [] })
    const req = { payload: { update } } as unknown as PayloadRequest
    const resolver = setSensorGefahrenstufeNotified(GraphQL, {} as GraphQLExtensionContext)

    await resolver.resolve(
      undefined,
      { sensorId: 'sensor-1', gefahrenstufe: 'ROT', confirmed: true },
      { req },
      {} as GraphQLResolveInfo,
    )

    expect(update).toHaveBeenCalledWith({
      collection: 'sensoren',
      where: { id: { equals: 'sensor-1' } },
      depth: 0,
      overrideAccess: false,
      req,
      data: { letzteBenachrichtigteGefahrenstufe: 'ROT', ausstehendeGefahrenstufe: 'ROT' },
    })
  })

  it('only sets ausstehendeGefahrenstufe when not yet confirmed', async () => {
    const update = vi.fn().mockResolvedValue({ errors: [] })
    const req = { payload: { update } } as unknown as PayloadRequest
    const resolver = setSensorGefahrenstufeNotified(GraphQL, {} as GraphQLExtensionContext)

    await resolver.resolve(
      undefined,
      { sensorId: 'sensor-1', gefahrenstufe: 'ROT', confirmed: false },
      { req },
      {} as GraphQLResolveInfo,
    )

    expect(update).toHaveBeenCalledWith({
      collection: 'sensoren',
      where: { id: { equals: 'sensor-1' } },
      depth: 0,
      overrideAccess: false,
      req,
      data: { ausstehendeGefahrenstufe: 'ROT' },
    })
  })

  it('only accepts the 8 known Gefahrenstufe values as gefahrenstufe', () => {
    const resolver = setSensorGefahrenstufeNotified(GraphQL, {} as GraphQLExtensionContext)
    const gefahrenstufeArg = resolver.args as {
      gefahrenstufe: { type: GraphQL.GraphQLNonNull<GraphQL.GraphQLEnumType> }
    }
    const gefahrenstufeType = gefahrenstufeArg.gefahrenstufe.type.ofType

    expect(gefahrenstufeType.parseValue('ROT')).toBe('ROT')
    expect(() => gefahrenstufeType.parseValue('not-a-gefahrenstufe')).toThrow()
  })
})
