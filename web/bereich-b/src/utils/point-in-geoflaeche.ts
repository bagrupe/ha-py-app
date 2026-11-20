import { booleanPointInPolygon, point } from '@turf/turf'
import { type Feature, type FeatureCollection, type Point } from 'geojson'
import { getPayload, type PayloadRequest } from 'payload'
import config from '@payload-config'

export type IsPointInGeoflaecheResult = {
  isInside?: boolean
  message?: string
}

export const isPointInGeoflaeche = async (
  name: string,
  kommuneId: string,
  position: { lat: number; long: number },
  req?: PayloadRequest,
): Promise<IsPointInGeoflaecheResult> => {
  const payload = req?.payload ?? (await getPayload({ config }))
  const { docs } = await payload.find({
    collection: 'geo-flaechen',
    depth: 0,
    limit: 2,
    // Bewusst privilegiert: der Aufruf kommt über die Stitching-Delegation ohne Identität,
    // und `geo-flaechen` ist nur für authentifizierte Nutzer lesbar. Der Resolver gibt keine
    // Geometrie heraus, sondern nur das boolesche Ergebnis der Punktprüfung.
    overrideAccess: true,
    req,
    where: {
      and: [{ 'kommune.bereichAId': { equals: kommuneId } }, { name: { equals: name } }],
    },
  })

  if (docs.length != 1) {
    return { message: 'Found non or more than two geoflaechen' }
  }

  const doc = docs[0]
  const { lat, long } = position
  const featureBoxedPoint = point([long, lat])

  const isFeatureCollection = (input: unknown): input is FeatureCollection =>
    typeof input === 'object' && !!input && 'type' in input && input.type === 'FeatureCollection'
  const isFeature = (input: unknown): input is Feature =>
    typeof input === 'object' && !!input && 'type' in input && input.type === 'Feature'

  if (typeof doc.Geometry === 'object' && doc.Geometry !== null && !Array.isArray(doc.Geometry)) {
    if (isFeatureCollection(doc.Geometry)) {
      const isInside = booleanPointInFeatureCollection(featureBoxedPoint, doc.Geometry)
      return { isInside }
    } else if (isFeature(doc.Geometry)) {
      const isInside = booleanPointInFeature(featureBoxedPoint, doc.Geometry)
      return { isInside }
    }
  }
  return { message: 'Cant handle the found result.' }
}

export const booleanPointInFeatureCollection = (
  point: Feature<Point>,
  featureCollection: FeatureCollection,
): boolean => featureCollection.features.some((f) => booleanPointInFeature(point, f))

const booleanPointInFeature = (point: Feature<Point>, feature: Feature): boolean => {
  const geometry = feature.geometry

  if (geometry.type !== 'Polygon' && geometry.type !== 'MultiPolygon') {
    return false
  }

  return booleanPointInPolygon(point, geometry)
}
