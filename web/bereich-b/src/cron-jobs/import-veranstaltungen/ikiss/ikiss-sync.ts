import * as Sentry from '@sentry/nextjs'
import { type BasePayload } from 'payload'
import { type Kommune } from '../../../payload-types'
import { type CronJobItemFailures } from '../../cron-job-item-failures'
import {
  IKISS_NO_DATA_FOUND,
  IkissApiError,
  type IkissEvent,
  parseIkissEventsResponse,
} from '../../../integrations/ikiss/ikiss-events'
import {
  createIKissRequest,
  decodeIkissResponse,
  fetchIKissResponse,
} from '../../../integrations/ikiss/ikiss-client'
import { getImageById } from '../../../integrations/ikiss/ikiss-images'
import { type IkissIntegration } from '../../../integrations/ikiss/ikiss-integration'
import {
  type IKissFetchSettings,
  type IKissSearchSettings,
} from '../../../integrations/ikiss/ikiss-request-types'
import { ikissXmlBuilder } from '../../../integrations/ikiss/ikiss-xml'
import {
  type ImageCache,
  prefetchImages,
  updateIntegrationResult,
} from '../../../collections/news-artikel/integrations/common'
import { createVeranstaltungUpserter } from '../utils/veranstaltung-upserter'
import { getEndpointIds, upsertEndpoint } from '../utils/endpoint-service'
import { IKISS_TIME_ZONE } from './ikiss-dates'
import { isIkissEventVisible, mapIkissEventToVeranstaltung } from './ikiss-event-mapper'
import { selectUpstreamSet } from './ikiss-upstream-set'

const QUELLE_NAME = 'Landkreis Hameln-Pyrmont'
const SEARCH_RESULT_FORMAT =
  'object_id, title, datetime_from, datetime_to, release, update_date, area'
const FETCH_MASK_DEFAULT = 0

const findEventsIntegration = async (
  payload: BasePayload,
  kommune: Kommune,
): Promise<IkissIntegration | undefined> => {
  const { docs } = await payload.find({
    collection: 'integration',
    where: {
      and: [
        { integrationtype: { equals: 'IKISS_VERANSTALTUNGEN' } },
        { kommune: { equals: kommune.id } },
      ],
    },
    limit: 1,
    depth: 0,
  })
  const { zugangsdaten, ...rest } = docs[0] ?? {}
  if (!docs[0]) return undefined
  if (!zugangsdaten?.benutzername || !zugangsdaten.passwort) {
    throw new Error('iKISS integration is missing benutzername or passwort')
  }
  return {
    ...rest,
    benutzername: zugangsdaten.benutzername,
    passwort: zugangsdaten.passwort,
  } as IkissIntegration
}

const requestEvents = async (
  integration: IkissIntegration,
  action: 'search' | 'fetch',
  specificQuery: IKissSearchSettings | IKissFetchSettings,
): Promise<IkissEvent[]> => {
  const query = createIKissRequest(
    action,
    'events',
    'full',
    { name: integration.benutzername, password: integration.passwort },
    specificQuery,
  )
  const response = await fetchIKissResponse(integration.url, ikissXmlBuilder.build(query))
  if (!response.ok) {
    throw new Error(`iKISS ${action} failed with HTTP ${response.status}`)
  }
  return parseIkissEventsResponse(await decodeIkissResponse(response))
}

const searchPublicEvents = async (integration: IkissIntegration): Promise<IkissEvent[]> => {
  try {
    return await requestEvents(integration, 'search', {
      set_language: 'de',
      set_include_sub_categories: 1,
      set_search_params: { area: 'internet' },
      search_result_format: SEARCH_RESULT_FORMAT,
    })
  } catch (error) {
    if (error instanceof IkissApiError && error.errorNumber === IKISS_NO_DATA_FOUND) return []
    throw error
  }
}

const fetchEvent = async (integration: IkissIntegration, id: string): Promise<IkissEvent> => {
  const [event] = await requestEvents(integration, 'fetch', {
    set_language: 'de',
    set_include_sub_categories: 3,
    set_data: { id },
    set_fetch_mask: FETCH_MASK_DEFAULT,
  })
  if (!event) throw new Error(`iKISS fetch returned no event for ${id}`)
  return event
}

const upsertQuelleId = async (kommune: Kommune): Promise<string> => {
  await upsertEndpoint(kommune, { name: QUELLE_NAME, experienceValue: '' })
  const [quelleId] = await getEndpointIds(QUELLE_NAME, kommune.id)
  if (!quelleId) throw new Error(`Quelle ${QUELLE_NAME} not found for kommune ${kommune.id}`)
  return quelleId
}

// failures is undefined for errors that are counted once per event by the caller.
const reportFailure = (
  payload: BasePayload,
  failures: CronJobItemFailures | undefined,
  kommune: Kommune,
  message: string,
  error: unknown,
  eventId?: string,
) => {
  failures?.recordFailure()
  payload.logger.error({ kommune: kommune.id, eventId, error: String(error) }, message)
  Sentry.captureException(error, {
    tags: { module: 'import-ikiss-veranstaltungen', kommune: String(kommune.id) },
    extra: { eventId },
  })
}

const importEvent = async (
  payload: BasePayload,
  failures: CronJobItemFailures,
  integration: IkissIntegration,
  kommune: Kommune,
  quelleId: string,
  searchHit: IkissEvent,
  imageCache: ImageCache,
  upsertVeranstaltung: ReturnType<typeof createVeranstaltungUpserter>,
) => {
  const { id: eventId, updateDate } = searchHit
  const { docs: existing } = await payload.find({
    collection: 'veranstaltungskalender',
    where: { and: [{ id: { equals: eventId } }, { kommune: { equals: kommune.id } }] },
    limit: 1,
    depth: 0,
    showHiddenFields: true,
  })
  const stored = existing[0]
  if (stored?.lockedForImport) {
    payload.logger.info({ eventId }, 'Skipped locked Veranstaltung %s', eventId)
    return
  }
  // iKISS can flip release without bumping update_date, so the marker alone can't mean unchanged.
  const unchanged =
    updateDate &&
    stored?.upstreamUpdateDate === updateDate &&
    stored.visible === isIkissEventVisible(searchHit, IKISS_TIME_ZONE)
  if (unchanged) return

  let imageFailed = false
  const event = await fetchEvent(integration, eventId)
  const data = await mapIkissEventToVeranstaltung(event, {
    kommuneId: kommune.id,
    quelleId,
    baseUrl: integration.url,
    timeZone: IKISS_TIME_ZONE,
    payloadConfig: payload.config,
    resolveImage: async (imageId) => {
      const resolution = await getImageById(
        payload,
        imageId,
        integration.url,
        integration,
        imageCache,
      )
      if (resolution.status === 'failed') {
        imageFailed = true
        reportFailure(
          payload,
          undefined,
          kommune,
          `Failed to import iKISS image ${imageId}`,
          resolution.error,
          eventId,
        )
      }
      return resolution
    },
  })
  await upsertVeranstaltung({
    collection: 'veranstaltungskalender',
    key: ['id', 'kommune'],
    data: {
      ...data,
      // Withholding the marker makes the next run retry an event whose images failed.
      ...(!imageFailed && updateDate && { upstreamUpdateDate: updateDate }),
    },
  })
  if (imageFailed) failures.recordFailure()
}

const deleteVanishedEvents = async (
  payload: BasePayload,
  failures: CronJobItemFailures,
  kommune: Kommune,
  quelleId: string,
  seenIds: string[],
) => {
  const { docs } = await payload.find({
    collection: 'veranstaltungskalender',
    where: {
      and: [
        { kommune: { equals: kommune.id } },
        { source: { contains: quelleId } },
        ...(seenIds.length > 0 ? [{ id: { not_in: seenIds } }] : []),
      ],
    },
    pagination: false,
    depth: 0,
  })

  for (const doc of docs) {
    try {
      await payload.delete({ collection: 'veranstaltungskalender', id: doc.id })
    } catch (error) {
      reportFailure(
        payload,
        failures,
        kommune,
        'Failed to delete iKISS Veranstaltung',
        error,
        doc.id,
      )
    }
  }
}

export const importIkissVeranstaltungen = async (
  payload: BasePayload,
  kommune: Kommune,
  failures: CronJobItemFailures,
  now: Date = new Date(),
): Promise<void> => {
  let integration: IkissIntegration | undefined
  try {
    integration = await findEventsIntegration(payload, kommune)
  } catch (error) {
    reportFailure(
      payload,
      failures,
      kommune,
      'iKISS Veranstaltungen integration lookup failed',
      error,
    )
    return
  }
  if (!integration) return

  const failureCountBefore = failures.getCount()
  await syncEvents(payload, kommune, failures, integration, now)
  const failureCount = failures.getCount() - failureCountBefore
  await updateIntegrationResult(
    payload,
    integration.id,
    failureCount > 0 ? `${failureCount} Fehler, Details im Log` : undefined,
  )
}

const syncEvents = async (
  payload: BasePayload,
  kommune: Kommune,
  failures: CronJobItemFailures,
  integration: IkissIntegration,
  now: Date,
): Promise<void> => {
  let upstreamSet: IkissEvent[]
  try {
    upstreamSet = selectUpstreamSet(await searchPublicEvents(integration), now, IKISS_TIME_ZONE)
  } catch (error) {
    reportFailure(payload, failures, kommune, 'iKISS Veranstaltungen search failed', error)
    return
  }

  try {
    const quelleId = await upsertQuelleId(kommune)
    const imageCache = await prefetchImages(payload, kommune.id)
    const upsertVeranstaltung = createVeranstaltungUpserter(failures)

    for (const searchHit of upstreamSet) {
      try {
        await importEvent(
          payload,
          failures,
          integration,
          kommune,
          quelleId,
          searchHit,
          imageCache,
          upsertVeranstaltung,
        )
      } catch (error) {
        reportFailure(
          payload,
          failures,
          kommune,
          'Failed to import iKISS Veranstaltung',
          error,
          searchHit.id,
        )
      }
    }

    await deleteVanishedEvents(
      payload,
      failures,
      kommune,
      quelleId,
      upstreamSet.map(({ id }) => id),
    )
  } catch (error) {
    reportFailure(payload, failures, kommune, 'iKISS Veranstaltungen sync failed', error)
  }
}
