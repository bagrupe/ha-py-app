import * as Sentry from '@sentry/nextjs'
import { getPayload } from 'payload'
import config from '@payload-config'
import { subHours } from 'date-fns'
import keyBy from 'lodash/keyBy'
import uniqBy from 'lodash/uniqBy'
import groupBy from 'lodash/groupBy'
import { type CronJobItemFailures } from './cron-job-item-failures'
import { scheduleWithMetrics } from './metrics'
import { z } from 'zod'
import { type Sensoren } from '../payload-types'
import {
  CONSOLIDATED_PIPELINE_NAME,
  getHapySensorenClient,
  getHapySensorenPostgrestAggregatedTable,
  getHapySensorenPostgrestTable,
} from '../lib/hapy-sensoren-client'

type SensorFeld = NonNullable<Sensoren['felder']>[number]

/**
 * device_data keys that report a category (e.g. SAFE/ADVISORY/...) instead of a
 * number. `typeof value === 'number'` never matches these, so without this
 * allowlist they'd be silently dropped from `felder` on every import run.
 */
const KATEGORIALE_FELDER = new Set(['alarm_level_last'])

/**
 * Only ever adds fields: a field missing from a (recent, possibly partial) result
 * keeps its CMS-configured `werteart` instead of being dropped.
 */
export const computeUpsertedFelder = (
  sensorEntries: SensorData[],
  knownFelder: SensorFeld[],
): SensorFeld[] => {
  const felder = new Set<string>()

  for (const entry of sensorEntries) {
    for (const [key, value] of Object.entries(entry.device_data)) {
      if (typeof value === 'number' || KATEGORIALE_FELDER.has(key)) {
        felder.add(key)
      }
    }
  }

  return uniqBy([...knownFelder, ...[...felder].map((feld) => ({ name: feld }))], 'name')
}

const sensorSchema = z.object({
  timestamp: z.string(),
  device_name: z.string(),
  landkreisapp: z.string(),
  device_data: z.record(z.string(), z.unknown()),
})

const SENSOR_COLUMNS = 'device_name,device_data,timestamp,landkreisapp'

/** Upper bound of a PostgREST page; the server may cap lower, which the offset-based paging tolerates. */
const PAGE_SIZE = 1000

const DEFAULT_SYNC_WINDOW_HOURS = 6

/** Read at call time: Next.js inlines `process.env.X` at build time if read at module scope. */
const getSyncWindowHours = () => {
  const hours = Number(process.env['HAPY_SENSOREN_SYNC_WINDOW_HOURS'])
  return Number.isFinite(hours) && hours > 0 ? hours : DEFAULT_SYNC_WINDOW_HOURS
}

const fetchRecentRows = async (start: Date, end: Date) => {
  const client = getHapySensorenClient()
  const rows: Record<string, unknown>[] = []
  let total = Infinity

  while (rows.length < total) {
    const { data, error, count } = await client
      .from(getHapySensorenPostgrestAggregatedTable())
      .select(SENSOR_COLUMNS, { count: 'exact' })
      .eq('pipeline_name', CONSOLIDATED_PIPELINE_NAME)
      .gte('timestamp', start.toISOString())
      .lte('timestamp', end.toISOString())
      .order('timestamp', { ascending: false })
      .order('device_name')
      .range(rows.length, rows.length + PAGE_SIZE - 1)

    if (error) throw new Error(`PostgREST query failed: ${error.message}`)
    if (count == null)
      throw new Error('PostgREST returned no row count, cannot verify completeness')

    total = count
    if (!data?.length) break
    rows.push(...data)
  }

  if (rows.length < total) {
    throw new Error(`PostgREST returned only ${rows.length} of ${total} rows`)
  }

  return rows
}

const dataSchema = z.object({
  rxInfo: z.array(
    z.object({
      name: z.string().optional(),
      location: z
        .object({
          latitude: z.number(),
          longitude: z.number(),
        })
        .optional(),
    }),
  ),
})

const sensorCoordsSchema = z.object({
  data_raw: z.string().transform((s) => dataSchema.parse(JSON.parse(s))),
})

export type SensorData = z.infer<typeof sensorSchema>

const _importSensoren = async (failures: CronJobItemFailures) => {
  const payload = await getPayload({ config })
  const log = payload.logger.child({ module: 'import-sensoren' })

  log.info('Starting sensor import...')

  const kommuneHameln = (
    await payload.find({
      collection: 'kommunen',
      where: { name: { equals: 'Landkreis Hameln-Pyrmont' } },
      pagination: false,
    })
  ).docs[0]

  if (!kommuneHameln) {
    log.error('Kommune "Landkreis Hameln-Pyrmont" not found. Aborting.')
    return
  }

  const syncWindowHours = getSyncWindowHours()
  const end = new Date()
  const start = subHours(end, syncWindowHours)

  log.info(
    'Fetching sensor data from %s to %s (%d h window)',
    start.toISOString(),
    end.toISOString(),
    syncWindowHours,
  )

  const rows = await fetchRecentRows(start, end)

  log.info('Fetched %d rows', rows.length)

  if (rows.length === 0) {
    log.warn('No sensor rows in the sync window, leaving sensors untouched')
    return
  }

  const validationErrors: { device_name: string; error: string }[] = []
  const sensorData: SensorData[] = []
  const notInLandkreisApp = new Set<string>()
  for (const sensor of rows) {
    // The data source marks devices that are not meant for the Landkreis app with `landkreisapp: null`.
    if (sensor.landkreisapp === null) {
      notInLandkreisApp.add(String(sensor.device_name))
      continue
    }

    const res = sensorSchema.safeParse(sensor)
    if (!res.success) {
      validationErrors.push({
        device_name: String(sensor.device_name ?? 'unknown'),
        error: res.error.issues.map((i) => `${i.path.join('.')}: ${i.message}`).join('; '),
      })
      continue
    }
    sensorData.push(res.data)
  }

  if (notInLandkreisApp.size > 0) {
    log.info(
      { sensors: [...notInLandkreisApp] },
      'Skipped %d sensors without landkreisapp',
      notInLandkreisApp.size,
    )
  }

  if (validationErrors.length > 0) {
    failures.recordFailures(validationErrors.length)
    log.warn({ validationErrors }, '%d rows failed validation', validationErrors.length)
  }

  const groupedBySensor = groupBy(sensorData, (r) => r.device_name)
  const sensorNames = Object.keys(groupedBySensor)

  log.info('%d valid rows across %d unique sensors', sensorData.length, sensorNames.length)

  const sensoren = (
    await payload.find({
      collection: 'sensoren',
      where: { kommune: { equals: kommuneHameln.id } },
      pagination: false,
      depth: 0,
      context: {
        source: 'importer',
      },
    })
  ).docs

  const sensorMap = keyBy(sensoren, 'name')

  log.info('%d existing sensors in CMS', sensoren.length)

  let updated = 0
  let unchanged = 0
  let created = 0
  const errors: { name: string; action: string; error: string }[] = []

  for (const sensorName in groupedBySensor) {
    const sensorEntries = groupedBySensor[sensorName] || []

    if (sensorEntries.length === 0) continue

    const knownSensor = sensorMap[sensorName]
    const knownFelder = knownSensor?.felder ?? []
    const upsertedFelder = computeUpsertedFelder(sensorEntries, knownFelder)

    if (knownSensor) {
      if (upsertedFelder.length === knownFelder.length) {
        unchanged++
        continue
      }

      try {
        await payload.update({
          collection: 'sensoren',
          where: { name: { equals: sensorName } },
          data: { felder: upsertedFelder },
        })
        updated++
      } catch (e) {
        errors.push({ name: sensorName, action: 'update', error: String(e) })
        Sentry.captureException(e, {
          tags: {
            module: 'import-sensoren',
            action: 'update',
            sensor: sensorName,
          },
        })
      }
    } else {
      try {
        const res = await getHapySensorenClient()
          .from(getHapySensorenPostgrestTable())
          .select()
          .eq('device_name', sensorName)
          .order('timestamp', { ascending: false })

        const coords = await sensorCoordsSchema.safeParseAsync(res.data?.[0])

        const info = coords.data?.data_raw.rxInfo.find((info) => info.location)

        await payload.create({
          collection: 'sensoren',
          data: {
            name: sensorName,
            titel: sensorEntries[0].landkreisapp || sensorName,
            felder: upsertedFelder,
            position: [info?.location?.latitude ?? 0, info?.location?.longitude ?? 0],
            kommune: kommuneHameln.id,
          },
        })
        created++
      } catch (e) {
        errors.push({ name: sensorName, action: 'create', error: String(e) })
        Sentry.captureException(e, {
          tags: {
            module: 'import-sensoren',
            action: 'create',
            sensor: sensorName,
          },
        })
      }
    }
  }

  log.info(
    {
      found: sensorNames.length,
      updated,
      unchanged,
      created,
      skipped: notInLandkreisApp.size,
      errors: errors.length,
    },
    'Import complete: %d found, %d updated, %d unchanged, %d created, %d skipped, %d errors',
    sensorNames.length,
    updated,
    unchanged,
    created,
    notInLandkreisApp.size,
    errors.length,
  )

  if (errors.length > 0) {
    failures.recordFailures(errors.length)
    log.error({ errors }, '%d sensors failed to import', errors.length)
    Sentry.captureMessage(`Sensor import: ${errors.length} sensors failed`, {
      level: 'error',
      tags: { module: 'import-sensoren' },
      extra: { errors },
    })
  }
}

// TODO uncomment if importSensoren is activated
const oncePerHour = '0 * * * *'

export const importSensoren = () => {
  scheduleWithMetrics(
    'import_sensoren',
    oncePerHour,
    async (failures) => {
      try {
        await _importSensoren(failures)
      } catch (e) {
        const payload = await getPayload({ config })
        payload.logger
          .child({ module: 'import-sensoren' })
          .error(e, 'Sensor import failed with unhandled error')
        Sentry.captureException(e, { tags: { module: 'import-sensoren' } })
        throw e
      } finally {
        await Sentry.flush(5000)
      }
    },
    { runOnInit: true },
  )
}
