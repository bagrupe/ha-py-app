import { describe, expect, it } from 'vitest'
import { readArgs, mockOeUser } from '../access/__tests__/mock-factories'
import {
  publicNewsArtikelRead,
  publicPoiCategoryRead,
  publicPoiRead,
  publicVisibleRead,
} from './public-read-rules'

describe('public collection read access', () => {
  it('filters anonymous news to published and visible articles', async () => {
    const result = await publicNewsArtikelRead(readArgs(null))

    expect(result).toMatchObject({
      and: [
        { _status: { equals: 'published' } },
        { datum: { less_than_equal: expect.any(Date) } },
        { visible: { equals: true } },
      ],
    })
  })

  it('filters anonymous events by visibility', async () => {
    expect(await publicVisibleRead(readArgs(null))).toEqual({
      visible: { equals: true },
    })
  })

  it('filters anonymous POIs through the complete visible category hierarchy', async () => {
    expect(await publicPoiRead(readArgs(null))).toEqual({
      visible: { equals: true },
      'category.visible': { equals: true },
      'category.supercategory.visible': { equals: true },
    })
    expect(await publicPoiCategoryRead(readArgs(null))).toEqual({
      visible: { equals: true },
      'supercategory.visible': { equals: true },
    })
    expect(await publicVisibleRead(readArgs(null))).toEqual({
      visible: { equals: true },
    })
  })

  it('does not apply public visibility filters to authenticated reads', async () => {
    const args = readArgs(mockOeUser())

    expect(await publicNewsArtikelRead(args)).toBe(true)
    expect(await publicVisibleRead(args)).toBe(true)
    expect(await publicPoiRead(args)).toBe(true)
    expect(await publicPoiCategoryRead(args)).toBe(true)
  })
})
