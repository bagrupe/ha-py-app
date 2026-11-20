import { type FeatureCollection, type GeoJsonProperties, type Geometry } from 'geojson'
import type { OverpassBbox } from 'overpass-ts'

const hasValidRect = ({ minlat, minlon, maxlat, maxlon }: OverpassBbox): boolean =>
  [minlat, minlon, maxlat, maxlon].every(Number.isFinite) && minlat < maxlat && minlon < maxlon

const hasArea = (geojson: FeatureCollection<Geometry, GeoJsonProperties>): boolean =>
  geojson.features.some(
    (feature) => feature.geometry?.type === 'Polygon' || feature.geometry?.type === 'MultiPolygon',
  )

export const isUsableBoundary = (
  rect: OverpassBbox,
  geojson: FeatureCollection<Geometry, GeoJsonProperties>,
): boolean => hasValidRect(rect) && hasArea(geojson)
