import { describe, expect, it } from 'vitest'
import type { FeatureCollection } from 'geojson'

import { isUsableBoundary } from '../import-veranstaltungen/utils/boundary-validation'

const rect = { minlat: 51.9, minlon: 9.1, maxlat: 52.3, maxlon: 9.7 }

const collection = (...types: string[]) =>
  ({
    type: 'FeatureCollection',
    features: types.map((type) => ({ type: 'Feature', properties: {}, geometry: { type } })),
  }) as unknown as FeatureCollection

describe('isUsableBoundary', () => {
  it('accepts a valid rect with a polygon', () => {
    expect(isUsableBoundary(rect, collection('MultiPolygon', 'Point'))).toBe(true)
  })

  it('rejects a collection without any area', () => {
    expect(isUsableBoundary(rect, collection('Point'))).toBe(false)
    expect(isUsableBoundary(rect, collection())).toBe(false)
  })

  it('rejects the fallback rect used for a relation without bounds', () => {
    const fallback = { minlat: 90, minlon: 180, maxlat: -90, maxlon: -180 }

    expect(isUsableBoundary(fallback, collection('Polygon'))).toBe(false)
  })

  it('rejects a rect from an empty result', () => {
    const empty = { minlat: Infinity, minlon: Infinity, maxlat: -Infinity, maxlon: -Infinity }

    expect(isUsableBoundary(empty, collection('Polygon'))).toBe(false)
  })

  it('rejects a rect without extent', () => {
    expect(isUsableBoundary({ ...rect, maxlat: rect.minlat }, collection('Polygon'))).toBe(false)
  })
})
