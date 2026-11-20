import { describe, expect, it } from 'vitest'
import { featureCollectionSchema } from './geojson'

describe('featureCollectionSchema', () => {
  it('keeps properties.other on parse', () => {
    const result = featureCollectionSchema.parse({
      type: 'FeatureCollection',
      name: 'import',
      features: [
        {
          type: 'Feature',
          geometry: { type: 'Point', coordinates: [9.3, 52.1] },
          properties: {
            OBJECTID: 1,
            Name: 'Test POI',
            other: 'Zusätzlicher Beschreibungstext',
          },
        },
      ],
    })

    expect(result.features[0].properties.other).toBe('Zusätzlicher Beschreibungstext')
  })
})
