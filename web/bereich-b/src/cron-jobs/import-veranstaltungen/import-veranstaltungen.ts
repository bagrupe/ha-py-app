import uniq from 'lodash/uniq'
import { scheduleWithMetrics } from '../metrics'
import { type CronJobItemFailures } from '../cron-job-item-failures'
import { type Payload, getPayload } from 'payload'
import config from '@payload-config'
import { findUrls } from '../../utils/find-urls'
import {
  type D4Veranstaltung,
  fetchAllVeranstaltungen as fetchAllVeranstaltungenInsideKommune,
} from './fetch-all-veranstaltungen'
import { ensureCategoriesExist, getCategoryIds } from './utils/category-service'
import {
  getEndpointIds,
  getEndpointsVeranstaltungen,
  upsertEndpoint,
} from './utils/endpoint-service'
import { isPointInAtLeastOnePoly } from './utils/geojson-service'
import {
  type GemeindeLocationBounds,
  type LocationBounds,
  getGemeindenBoundsForKommune,
  getLocationBoundsByRegionalKey,
  getUntereinheitIdByCoordinates,
} from './utils/location-bounds-service'
import { hasUntereinheiten } from './utils/untereinheiten-present-test'
import { uploadDefaultImage } from './utils/upload-default-image'
import { createVeranstaltungUpserter } from './utils/veranstaltung-upserter'
import { htmlToLexical, getDefaultEditorConfig } from '../../lib/html-to-lexical'
import { importIkissVeranstaltungen } from './ikiss/ikiss-sync'
import { type Kommune } from '../../payload-types'

export const importVeranstaltungenCronJob = async () => {
  const everyHour = '0 * * * *'

  scheduleWithMetrics(
    'import_veranstaltungen',
    everyHour,
    async (failures) => {
      const payload = await getPayload({ config })
      const maxRetries = 3
      let retries = 0
      let imported = false
      try {
        while (retries < maxRetries) {
          if (!(await hasUntereinheiten())) {
            payload.logger.error(
              'Could not import Veranstaltungen because Untereinheiten are not seeded',
            )
            await new Promise((resolve) => setTimeout(resolve, 30000))
            retries++
          } else {
            await importVeranstaltungen(failures, payload)
            imported = true
            break
          }
        }

        if (!imported) {
          failures.recordFailure()
        }
      } catch (error) {
        failures.recordFailure()
        payload.logger.error({ error: String(error) }, 'Veranstaltungen import failed')
      }
    },
    { runOnInit: true },
  )
}

const recordFailureOf = async (
  payload: Payload,
  failures: CronJobItemFailures,
  task: () => Promise<void>,
) => {
  try {
    await task()
  } catch (error) {
    failures.recordFailure()
    payload.logger.error({ error: String(error) }, 'Veranstaltungen import step failed')
  }
}

type Et4ImportContext = {
  payload: Payload
  kommune: Kommune
  kommuneLocationBounds: LocationBounds
  gemeindenLocationBounds: GemeindeLocationBounds[]
  endpointIds: string[]
  upsertVeranstaltung: ReturnType<typeof createVeranstaltungUpserter>
}

const importEt4Veranstaltung = async (
  veranstaltung: D4Veranstaltung,
  {
    payload,
    kommune,
    kommuneLocationBounds,
    gemeindenLocationBounds,
    endpointIds,
    upsertVeranstaltung,
  }: Et4ImportContext,
) => {
  const coordinates: [number, number] = [
    veranstaltung.geo.main.latitude,
    veranstaltung.geo.main.longitude,
  ]

  const isOutsideOfKommune = !isPointInAtLeastOnePoly(
    kommuneLocationBounds.geojson.features,
    coordinates,
  )

  if (isOutsideOfKommune) return

  const categoryIds = await getCategoryIds(veranstaltung, kommune.id)
  const image = await uploadDefaultImage(veranstaltung, kommune.id)

  const untereinheitId = getUntereinheitIdByCoordinates(gemeindenLocationBounds, coordinates)

  const dates = veranstaltung.timeIntervals.map((date) => ({
    start: new Date(date.start).toISOString(),
    end: new Date(date.end).toISOString(),
  }))

  const teaser = veranstaltung.texts.find(
    (text) => text.type === 'text/plain' && text.rel === 'teaser',
  )?.value

  const ticketUrl = findUrls(teaser ?? '')[0]

  const content = veranstaltung.texts.find(
    (text) => text.type === 'text/html' && text.rel === 'details',
  )?.value

  const editorConfig = await getDefaultEditorConfig(payload.config)
  const contentRichText = content && htmlToLexical(content, editorConfig)

  // unfortunately need to handle the upsert semi-manually,
  // because we need to merge the contents of the 'source' attribute
  // with existing sources and can't just overwrite it
  const { docs: veranstaltungsDocs } = await payload.find({
    collection: 'veranstaltungskalender',
    where: {
      and: [
        {
          id: {
            equals: veranstaltung.id,
          },
        },
        {
          kommune: {
            equals: kommune.id,
          },
        },
      ],
    },
  })

  if (veranstaltungsDocs.length > 1) {
    throw new Error('Key is not unique')
  }

  const lockedForImport = veranstaltungsDocs[0]?.lockedForImport ?? false
  if (lockedForImport) {
    payload.logger.info(
      { id: veranstaltungsDocs[0].id },
      'Skipped Veranstaltung %s because it is locked for import',
      veranstaltungsDocs[0].id,
    )
    return
  }

  const alreadyAttachedSourcesIds =
    veranstaltungsDocs[0]?.source
      ?.map((c) => (typeof c === 'object' ? c.id : c?.toString()))
      .filter((c): c is string => !!c) ?? []

  const veranstalterAdresse = veranstaltung.addresses.find((a) => a.rel === 'organizer')

  const buchungsUrl =
    veranstaltung.media_objects.find((mo) => mo.rel === 'booking')?.url ||
    // Fallback für Feratel / Bad Pyrmont
    findUrls(veranstaltung.texts.find((t) => t.rel === 'PRICE_INFO')?.value ?? '')[0]

  const anbieterUrl =
    veranstaltung.media_objects.find((mo) => mo.rel === 'venuewebsite')?.url || veranstaltung.web

  await upsertVeranstaltung({
    collection: 'veranstaltungskalender',
    key: ['id', 'kommune'],
    data: {
      id: veranstaltung.id,
      titel: veranstaltung.title,
      teaser,
      subtitle: veranstaltung.name,
      category: categoryIds,
      titelbild: image && {
        external: false,
        internal: image.id,
      },
      source: uniq([...alreadyAttachedSourcesIds, ...endpointIds]),
      untereinheit: untereinheitId,
      timeAndLocation: {
        coordinates: coordinates,
        locationName: veranstaltung.city,
        address: `${veranstaltung.street}, ${veranstaltung.zip} ${veranstaltung.city}`,
        dates,
      },
      veranstalterAdresse: {
        name: veranstalterAdresse?.name,
        ort: veranstalterAdresse?.city,
        plz: veranstalterAdresse?.zip,
        strasse: veranstalterAdresse?.street,
        telefon: veranstalterAdresse?.phone,
        url: veranstalterAdresse?.web,
        email: veranstalterAdresse?.email,
      },
      buchungsUrl,
      ticketUrl,
      anbieterUrl,
      inhalte:
        content && contentRichText
          ? [
              {
                blockType: 'rich-text',
                content: contentRichText,
              },
            ]
          : undefined,
      kommune: kommune.id,
    },
  })
}

const importEt4Veranstaltungen = async (
  payload: Payload,
  kommune: Kommune,
  failures: CronJobItemFailures,
  upsertVeranstaltung: ReturnType<typeof createVeranstaltungUpserter>,
) => {
  const kommuneLocationBounds = await getLocationBoundsByRegionalKey(kommune.regionalschluessel, {
    required: true,
  })
  const gemeindenLocationBounds: GemeindeLocationBounds[] = await getGemeindenBoundsForKommune(
    kommune.id,
    failures,
  )

  for (const endpoint of getEndpointsVeranstaltungen()) {
    await recordFailureOf(payload, failures, async () => {
      await upsertEndpoint(kommune, endpoint)

      const veranstaltungen = await fetchAllVeranstaltungenInsideKommune(
        endpoint,
        kommuneLocationBounds.rect,
      )

      await ensureCategoriesExist(veranstaltungen, kommune.id)
      const endpointIds = await getEndpointIds(endpoint.name, kommune.id)
      const context: Et4ImportContext = {
        payload,
        kommune,
        kommuneLocationBounds,
        gemeindenLocationBounds,
        endpointIds,
        upsertVeranstaltung,
      }

      for (const veranstaltung of veranstaltungen) {
        await recordFailureOf(payload, failures, () =>
          importEt4Veranstaltung(veranstaltung, context),
        )
      }
    })
  }
}

export const importVeranstaltungen = async (failures: CronJobItemFailures, payload?: Payload) => {
  const upsertVeranstaltung = createVeranstaltungUpserter(failures)
  payload ??= await getPayload({ config })
  const kommunen = await payload.find({
    collection: 'kommunen',
    pagination: false,
  })

  for (const kommune of kommunen.docs) {
    payload.logger.info('Running import of Veranstaltungen for %s', kommune.name)
    await recordFailureOf(payload, failures, () =>
      importEt4Veranstaltungen(payload, kommune, failures, upsertVeranstaltung),
    )
    await recordFailureOf(payload, failures, () =>
      importIkissVeranstaltungen(payload, kommune, failures),
    )
  }

  payload.logger.info('Finished import of Veranstaltungen')
}
