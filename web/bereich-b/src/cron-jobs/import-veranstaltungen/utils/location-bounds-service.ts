import { type FeatureCollection, type GeoJsonProperties, type Geometry } from 'geojson'
import osmtogeojson from 'osmtogeojson'
import type { OverpassJson, OverpassRelation, OverpassBbox } from 'overpass-ts'
import { overpass } from 'overpass-ts'

import { getPayload, type Payload } from 'payload'
import config from '@payload-config'
import { type CronJobItemFailures } from '../../cron-job-item-failures'
import { isUsableBoundary } from './boundary-validation'
import { getBundledBoundary } from './bundled-boundaries'
import { isPointInAtLeastOnePoly } from './geojson-service'

export type LocationBounds = {
  rect: OverpassBbox
  geojson: FeatureCollection<Geometry, GeoJsonProperties>
}

// latitudes can range from -90 to 90 and longitudes from -180 to 180;
// therefore, we use these values as fallbacks
const rectOf = (relations: OverpassRelation[]): OverpassBbox => ({
  minlat: Math.min(...relations.map((relation) => relation.bounds?.minlat ?? 90)),
  minlon: Math.min(...relations.map((relation) => relation.bounds?.minlon ?? 180)),
  maxlat: Math.max(...relations.map((relation) => relation.bounds?.maxlat ?? -90)),
  maxlon: Math.max(...relations.map((relation) => relation.bounds?.maxlon ?? -180)),
})

const fetchFromOverpass = async (regionalschluessel: string) => {
  const overpassResponse = await overpass(
    `[out:json];
    area['admin_level'='2']['name'='Deutschland'];
    (relation["de:regionalschluessel"="${regionalschluessel}"](area););
    out geom;`,
  )

  const overpassJson = (await overpassResponse.json()) as OverpassJson

  // abgebrochene Abfragen kommen teils als Status 200 mit leerer Antwort zurück
  if (overpassJson.remark?.includes('runtime error')) {
    throw new Error(`Overpass: ${overpassJson.remark}`)
  }

  const relations = overpassJson.elements.filter(
    (element) => element.type === 'relation',
  ) as OverpassRelation[]

  const geojson = osmtogeojson(overpassJson)
  const rect = rectOf(relations)

  return { geojson, rect, found: relations.length > 0 && isUsableBoundary(rect, geojson) }
}

type StoredHash = { id: string; quellHash?: string | null }

const findStoredHash = async (
  payload: Payload,
  regionalschluessel: string,
): Promise<StoredHash | undefined> => {
  const { docs } = await payload.find({
    collection: 'osm-grenzen',
    depth: 0,
    limit: 1,
    pagination: false,
    select: { quellHash: true },
    where: { regionalschluessel: { equals: regionalschluessel } },
  })
  const doc = docs[0]
  return doc && { id: doc.id, quellHash: doc.quellHash }
}

const findStoredBounds = async (
  payload: Payload,
  regionalschluessel: string,
): Promise<LocationBounds | undefined> => {
  const { docs } = await payload.find({
    collection: 'osm-grenzen',
    depth: 0,
    limit: 1,
    pagination: false,
    where: { regionalschluessel: { equals: regionalschluessel } },
  })
  const doc = docs[0]
  if (!doc) return undefined

  return {
    rect: doc.rect as unknown as OverpassBbox,
    geojson: doc.geojson as unknown as FeatureCollection<Geometry, GeoJsonProperties>,
  }
}

const saveBoundary = async (
  payload: Payload,
  regionalschluessel: string,
  bounds: LocationBounds,
  extra: { abgerufenAm: string; quellHash?: string },
  existingId?: string,
) => {
  const data = {
    rect: { ...bounds.rect },
    geojson: bounds.geojson as unknown as Record<string, unknown>,
    abgerufenAm: extra.abgerufenAm,
    quellHash: extra.quellHash ?? null,
  }

  if (existingId) {
    await payload.update({ collection: 'osm-grenzen', id: existingId, data })
    return
  }

  try {
    await payload.create({ collection: 'osm-grenzen', data: { regionalschluessel, ...data } })
  } catch (error) {
    if (!(await findStoredHash(payload, regionalschluessel))) throw error
  }
}

export const getLocationBoundsByRegionalKey = async (
  regionalschluessel: string,
  options?: { required?: boolean },
): Promise<LocationBounds> => {
  const payload = await getPayload({ config })
  const bundled = getBundledBoundary(regionalschluessel)

  if (bundled) {
    try {
      const stored = await findStoredHash(payload, regionalschluessel)
      if (stored?.quellHash !== bundled.hash) {
        await saveBoundary(
          payload,
          regionalschluessel,
          bundled,
          { abgerufenAm: bundled.abgerufenAm, quellHash: bundled.hash },
          stored?.id,
        )
      }
    } catch (error) {
      console.warn(
        `Grenze für Regionalschlüssel ${regionalschluessel} nicht in osm-grenzen abgelegt: ${String(error)}`,
      )
    }
    return { rect: bundled.rect, geojson: bundled.geojson }
  }

  const stored = await findStoredBounds(payload, regionalschluessel)
  if (stored) return stored

  const { found, ...bounds } = await fetchFromOverpass(regionalschluessel)
  if (!found) {
    const message = `Overpass: keine brauchbare Grenze für Regionalschlüssel ${regionalschluessel} gefunden`
    if (options?.required) throw new Error(message)
    console.warn(message)
    return bounds
  }

  await saveBoundary(payload, regionalschluessel, bounds, {
    abgerufenAm: new Date().toISOString(),
  })
  console.info(`Overpass: Grenze für Regionalschlüssel ${regionalschluessel} gespeichert`)

  return bounds
}

export type GemeindeLocationBounds = {
  [key: string]: {
    gemeindeName: string
    rect: OverpassBbox
    geojson: FeatureCollection<Geometry, GeoJsonProperties>
  }
}

export async function getGemeindenBoundsForKommune(
  kommuneId: string,
  failures?: CronJobItemFailures,
) {
  const payload = await getPayload({ config })
  const gemeindenDocs = await payload.find({
    collection: 'untereinheit',
    pagination: false,
    where: {
      kommune: {
        equals: kommuneId,
      },
      isGemeinde: {
        equals: true,
      },
    },
  })

  const gemeinden = gemeindenDocs.docs
  const gemeindenBounds: GemeindeLocationBounds[] = []

  for (let i = 0; i < gemeinden.length; i++) {
    const regionalschluessel = gemeinden[i].regionalschluessel

    if (!regionalschluessel) continue

    try {
      const bounds = await getLocationBoundsByRegionalKey(regionalschluessel)
      gemeindenBounds.push({
        [gemeinden[i].id]: { gemeindeName: gemeinden[i].name, ...bounds },
      })
    } catch (error) {
      failures?.recordFailure()
      console.error(
        `Grenze der Gemeinde ${gemeinden[i].name} (${regionalschluessel}) nicht geladen: ${String(error)}`,
      )
    }
  }

  return gemeindenBounds
}

export function getUntereinheitIdByCoordinates(
  gemeindenBounds: GemeindeLocationBounds[],
  coordinates: [number, number],
) {
  for (let i = 0; i < gemeindenBounds.length; i++) {
    for (const key in gemeindenBounds[i]) {
      const features = gemeindenBounds[i][key].geojson.features
      const isInsideGemeinde = isPointInAtLeastOnePoly(features, coordinates)
      if (isInsideGemeinde) {
        return key
      }
    }
  }
}
