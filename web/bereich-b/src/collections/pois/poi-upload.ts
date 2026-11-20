import { type FeatureCollection } from 'geojson'
import type { PayloadHandler } from 'payload'
import proj4 from 'proj4'
import { z } from 'zod'
import type { Benutzer, Config } from '../../payload-types'
import { hasFunktionsberechtigung } from '../../access/funktionsberechtigungen'
import { urnToEpsg } from '../../lib/crs'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import boundsCheck from '../../lib/geo/brd_vereinfacht.geo.json'
import { featureCollectionSchema } from '../../lib/geojson'
import { formatZodErrors } from '../../lib/zod'
import { booleanPointInFeatureCollection } from '../../utils/point-in-geoflaeche'

export const poiUpload: PayloadHandler = async (req) => {
  if (!req.user) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const userKommuneId =
    typeof req.user.kommune === 'object' && req.user.kommune
      ? req.user.kommune.id
      : (req.user.kommune as string)

  const body = await req.json?.()
  const { error: validationError, data } = inputSchema.safeParse(body)
  if (validationError) {
    return Response.json({ error: formatZodErrors(validationError) }, { status: 400 })
  }

  const [category, organisationseinheit] = await Promise.all([
    req.payload.find({
      collection: 'poi-categories',
      depth: 0,
      overrideAccess: false,
      req,
      where: { id: { equals: data.kategorieId } },
      pagination: false,
      limit: 1,
    }),
    req.payload.find({
      collection: 'untereinheit',
      depth: 0,
      overrideAccess: false,
      req,
      where: { id: { equals: data.organisationseinheitId } },
      pagination: false,
      limit: 1,
    }),
  ])

  if (category.docs.length !== 1) {
    return Response.json({ error: 'Kategorie nicht gefunden' }, { status: 400 })
  }

  const categoryId = category.docs[0].id

  if (organisationseinheit.docs.length !== 1) {
    return Response.json({ error: 'Organisationseinheit nicht gefunden' }, { status: 400 })
  }

  const organisationseinheitId = data.organisationseinheitId

  if (
    !hasFunktionsberechtigung(
      req.user as Benutzer,
      Funktionsberechtigung.InhaltspflegePois,
      organisationseinheitId,
    )
  ) {
    return Response.json(
      {
        error: `Fehlende Funktionsberechtigung: ${Funktionsberechtigung.InhaltspflegePois}`,
      },
      { status: 401 },
    )
  }

  for (const feature of data.featureCollection.features) {
    if (data.featureCollection.crs) {
      const fromProjection = urnToEpsg(data.featureCollection.crs.properties.name)
      feature.geometry.coordinates = proj4(
        fromProjection,
        'EPSG:4326',
        feature.geometry.coordinates,
      )
    } else {
      if (feature.geometry.coordinates.some((x) => x > 180)) {
        // Heuristik
        feature.geometry.coordinates = proj4(
          'EPSG:25832',
          'EPSG:4326',
          feature.geometry.coordinates,
        )
      }
    }
    if (!booleanPointInFeatureCollection(feature, boundsCheck as FeatureCollection)) {
      return Response.json(
        {
          error: `POI ${feature.properties.OBJECTID} "${feature.properties.Name}" ist außerhalb von Deutschland.`,
        },
        { status: 400 },
      )
    }
  }

  for (const feature of data.featureCollection.features) {
    const object_slug = data.featureCollection.name
    const objectId = `${object_slug}-${feature.properties.OBJECTID}`
    const coordinates = feature.geometry.coordinates

    const prevPois = await req.payload.find({
      collection: 'poi',
      depth: 0,
      overrideAccess: false,
      req,
      where: {
        and: [
          { objectId: { equals: objectId } },
          {
            kommune: {
              equals: userKommuneId,
            },
          },
        ],
      },
      limit: 1,
    })

    if (prevPois.docs.length > 1) {
      console.info(
        `Could not process objectId: ${objectId}, found multiple entries with same objectId.`,
      )
      continue
    }

    const { Telefonnummer, email, Homepage, other } = feature.properties

    const additionalInformationList: AdditionalInformation[] = []
    if (Homepage) {
      additionalInformationList.push({
        heading: 'Webseite',
        text: Homepage,
        kind: 'website',
      })
    }

    if (email) {
      additionalInformationList.push({
        heading: 'Email',
        text: email,
        kind: 'email',
      })
    }

    if (Telefonnummer) {
      additionalInformationList.push({
        heading: 'Telefonnummer',
        text: Telefonnummer,
        kind: 'phone',
      })
    }

    if (other) {
      additionalInformationList.push({
        heading: 'Sonstiges',
        text: other,
        kind: 'other',
      })
    }

    if (prevPois.docs.length === 1) {
      if (prevPois.docs[0].lockedForImport) {
        console.info(
          `poi: Skipped ${prevPois.docs[0].title} (${prevPois.docs[0].id}) because it is locked for import`,
        )
      } else {
        await req.payload.update({
          id: prevPois.docs[0].id,
          collection: 'poi',
          overrideAccess: false,
          req,
          data: {
            title: feature.properties.Name,
            position: [coordinates[1], coordinates[0]],
            category: categoryId,
            additionalInformation: additionalInformationList,
          },
        })
        console.info(`poi: Updated ${prevPois.docs[0].title} (${prevPois.docs[0].id})`)
      }
    } else {
      await req.payload.create({
        collection: 'poi',
        overrideAccess: false,
        req,
        data: {
          kommune: userKommuneId,
          objectId,
          title: feature.properties.Name,
          position: [coordinates[1], coordinates[0]],
          category: categoryId,
          additionalInformation: additionalInformationList,
          lockedForImport: false,
          untereinheit: organisationseinheitId,
        },
      })
      console.info(`poi: Created ${feature.properties.Name}`)
    }
  }

  return Response.json({ success: true }, { status: 200 })
}

const inputSchema = z.object({
  kategorieId: z.string(),
  organisationseinheitId: z.string(),
  featureCollection: featureCollectionSchema,
})

type AdditionalInformation = NonNullable<
  Config['collections']['poi']['additionalInformation']
>[number]
