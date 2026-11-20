import { createHash } from 'node:crypto'
import { type FeatureCollection, type GeoJsonProperties, type Geometry } from 'geojson'
import type { OverpassBbox } from 'overpass-ts'

import boundaries from '../data/osm-grenzen.json'

export type BundledBoundary = {
  regionalschluessel: string
  rect: OverpassBbox
  geojson: FeatureCollection<Geometry, GeoJsonProperties>
  abgerufenAm: string
  hash: string
}

const bundled = new Map<string, BundledBoundary>(
  (boundaries as unknown as Omit<BundledBoundary, 'hash'>[]).map((entry) => [
    entry.regionalschluessel,
    {
      ...entry,
      hash: createHash('sha256')
        .update(JSON.stringify([entry.rect, entry.geojson]))
        .digest('hex'),
    },
  ]),
)

export const getBundledBoundary = (regionalschluessel: string): BundledBoundary | undefined =>
  bundled.get(regionalschluessel)
