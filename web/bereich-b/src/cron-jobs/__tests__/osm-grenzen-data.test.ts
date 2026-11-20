import { describe, expect, it } from 'vitest'
import type { Feature } from 'geojson'

import { isPointInAtLeastOnePoly } from '../import-veranstaltungen/utils/geojson-service'
import boundaries from '../import-veranstaltungen/data/osm-grenzen.json'

const LANDKREIS = '03252'
const GEMEINDEN = {
  Aerzen: '032520001001',
  'Bad Münder am Deister': '032520002002',
  'Bad Pyrmont': '032520003003',
  Coppenbrügge: '032520004004',
  Emmerthal: '032520005005',
  Hameln: '032520006006',
  'Hessisch Oldendorf': '032520007007',
  Salzhemmendorf: '032520008008',
}

const featuresOf = (regionalschluessel: string) => {
  const entry = boundaries.find((b) => b.regionalschluessel === regionalschluessel)
  return ((entry?.geojson as { features?: Feature[] })?.features ?? []) as Feature[]
}

const HAMELN: [number, number] = [52.1036, 9.3597]
const BAD_PYRMONT: [number, number] = [51.9856, 9.2526]
const HANNOVER: [number, number] = [52.3759, 9.732]

describe('bundled osm-grenzen data', () => {
  it('contains the Landkreis and all eight Gemeinden exactly once', () => {
    const keys = boundaries.map((b) => b.regionalschluessel).sort()

    expect(keys).toEqual([LANDKREIS, ...Object.values(GEMEINDEN)].sort())
  })

  it.each(boundaries.map((b) => [b.regionalschluessel, b] as const))(
    '%s has a polygon feature and a consistent rect',
    (_key, entry) => {
      const features = (entry.geojson as { features: Feature[] }).features

      expect((entry.geojson as { type: string }).type).toBe('FeatureCollection')
      expect(features.length).toBeGreaterThan(0)
      expect(features.some((f) => ['Polygon', 'MultiPolygon'].includes(f.geometry.type))).toBe(true)
      expect(entry.rect.minlat).toBeLessThan(entry.rect.maxlat)
      expect(entry.rect.minlon).toBeLessThan(entry.rect.maxlon)
      expect(Number.isNaN(Date.parse(entry.abgerufenAm))).toBe(false)
    },
  )

  it('places well-known locations inside and outside the Landkreis', () => {
    const landkreis = featuresOf(LANDKREIS)

    expect(isPointInAtLeastOnePoly(landkreis, HAMELN)).toBe(true)
    expect(isPointInAtLeastOnePoly(landkreis, BAD_PYRMONT)).toBe(true)
    expect(isPointInAtLeastOnePoly(landkreis, HANNOVER)).toBeFalsy()
  })

  it('assigns Hameln and Bad Pyrmont to their own Gemeinde only', () => {
    const hameln = featuresOf(GEMEINDEN.Hameln)
    const badPyrmont = featuresOf(GEMEINDEN['Bad Pyrmont'])

    expect(isPointInAtLeastOnePoly(hameln, HAMELN)).toBe(true)
    expect(isPointInAtLeastOnePoly(hameln, BAD_PYRMONT)).toBeFalsy()
    expect(isPointInAtLeastOnePoly(badPyrmont, BAD_PYRMONT)).toBe(true)
    expect(isPointInAtLeastOnePoly(badPyrmont, HAMELN)).toBeFalsy()
  })

  it('keeps every Gemeinde rect inside the Landkreis rect', () => {
    const landkreis = boundaries.find((b) => b.regionalschluessel === LANDKREIS)!.rect
    const tolerance = 0.001

    for (const key of Object.values(GEMEINDEN)) {
      const rect = boundaries.find((b) => b.regionalschluessel === key)!.rect
      expect(rect.minlat).toBeGreaterThanOrEqual(landkreis.minlat - tolerance)
      expect(rect.minlon).toBeGreaterThanOrEqual(landkreis.minlon - tolerance)
      expect(rect.maxlat).toBeLessThanOrEqual(landkreis.maxlat + tolerance)
      expect(rect.maxlon).toBeLessThanOrEqual(landkreis.maxlon + tolerance)
    }
  })
})
