import * as turf from '@turf/turf'
import { point } from '@turf/turf'
import { type Feature, type GeoJsonProperties, type Geometry, type Polygon } from 'geojson'

const isFeaturePolygon = (feature: Feature): feature is Feature<Polygon, GeoJsonProperties> =>
  feature.geometry.type === 'Polygon'
const isFeatureMultiPolygon = (feature: Feature): feature is Feature<Polygon, GeoJsonProperties> =>
  feature.geometry.type === 'MultiPolygon'

export const isPointInAtLeastOnePoly = (
  features: Feature<Geometry, GeoJsonProperties>[],
  coordinates: [number, number],
) => {
  // Note order: longitude, latitude.
  const coordinate = point([coordinates[1], coordinates[0]])
  for (let k = 0; k < features.length; k++) {
    const feature = features[k]
    if (isFeaturePolygon(feature) || isFeatureMultiPolygon(feature)) {
      const isInPolygon = turf.booleanPointInPolygon(coordinate, feature)
      if (isInPolygon) {
        return isInPolygon
      }
    }
  }
}
