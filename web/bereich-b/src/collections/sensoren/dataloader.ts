import groupBy from 'lodash/groupBy'
import { type PayloadRequest } from 'payload'
import { Temporal } from 'temporal-polyfill'
export type SensorData = {
  timestamp: string
  application_id: string
  application_name: string
  dev_eui: string
  device_name: string
  aggregation_interval: string
  location: string
  municipality: string
  sensortype: string
  usecase: string
  device_data: Record<string, unknown>
  device_meta: Record<string, unknown> | null
  pipeline_name: string
}
import {
  CONSOLIDATED_PIPELINE_NAME,
  getHapySensorenPostgrestAggregatedTable,
  getHapySensorenClient,
} from '../../lib/hapy-sensoren-client'
import { createRequestBoundDataLoader } from '../../utils/create-request-bound-dataloader'
import { inferAggregationType, reaggregateSeries } from './reaggregation'

const getKey = (sensorName: string, fieldName: string) => `${sensorName}@${fieldName}`

export const getSensorCurrentValueLoader = createRequestBoundDataLoader<
  [sensorName: string, fieldName: string],
  string
>('sensorCurrentValueLoader', async (keys) => {
  const client = getHapySensorenClient()
  const table = getHapySensorenPostgrestAggregatedTable()

  const sensorNames = [...new Set(keys.map(([sensorName]) => sensorName))]

  const { data, error } = await client
    .from(table)
    .select('*')
    .eq('pipeline_name', CONSOLIDATED_PIPELINE_NAME)
    .in('device_name', sensorNames)
    .order('timestamp', { ascending: false })
    .limit(sensorNames.length * 2)

  if (error) {
    console.error(`Error fetching sensor data ${sensorNames.join(', ')}:`, error)
    return keys.map(() => '')
  }

  const groupedBySensor = groupBy(data as SensorData[], 'device_name')

  const sensorValueMap: Record<string, string> = {}

  for (const sensorName in groupedBySensor) {
    const latestEntry = groupedBySensor[sensorName][0]
    if (!latestEntry) continue

    for (const [fieldName, value] of Object.entries(latestEntry.device_data)) {
      sensorValueMap[getKey(sensorName, fieldName)] = String(value)
    }
  }

  return keys.map(([sensorName, fieldName]) => sensorValueMap[getKey(sensorName, fieldName)] || '')
})

export type SensorGrenzwerte = {
  info1: number
  info2: number
  info3: number
  info4: number
}

export const getSensorGrenzwerteLoader = createRequestBoundDataLoader<
  string,
  SensorGrenzwerte | null
>('sensorGrenzwerteLoader', async (keys) => {
  const client = getHapySensorenClient()
  const table = getHapySensorenPostgrestAggregatedTable()

  const { data, error } = await client
    .from(table)
    .select('device_name, device_meta, timestamp')
    .eq('pipeline_name', CONSOLIDATED_PIPELINE_NAME)
    .in('device_name', keys)
    .order('timestamp', { ascending: false })
    .limit(keys.length * 2)

  if (error) {
    console.error(`Error fetching sensor grenzwerte ${keys.join(', ')}:`, error)
    return keys.map(() => null)
  }

  const groupedBySensor = groupBy(data as SensorData[], 'device_name')

  return keys.map((deviceName) => {
    const meta = groupedBySensor[deviceName]?.[0]?.device_meta
    if (!meta) return null

    const nums = [meta.info_1, meta.info_2, meta.info_3, meta.info_4].map(Number)
    if (nums.some((n) => Number.isNaN(n))) return null

    return { info1: nums[0], info2: nums[1], info3: nums[2], info4: nums[3] }
  })
})

export const getSensorAlarmLevelLoader = createRequestBoundDataLoader<string, string | null>(
  'sensorAlarmLevelLoader',
  async (keys) => {
    const client = getHapySensorenClient()
    const table = getHapySensorenPostgrestAggregatedTable()

    const { data, error } = await client
      .from(table)
      .select('device_name, device_data, timestamp')
      .eq('pipeline_name', CONSOLIDATED_PIPELINE_NAME)
      .in('device_name', keys)
      .order('timestamp', { ascending: false })
      .limit(keys.length * 2)

    if (error) {
      console.error(`Error fetching sensor alarm level ${keys.join(', ')}:`, error)
      return keys.map(() => null)
    }

    const groupedBySensor = groupBy(data as SensorData[], 'device_name')

    return keys.map((deviceName) => {
      const level = groupedBySensor[deviceName]?.[0]?.device_data?.alarm_level_last
      return typeof level === 'string' ? level : null
    })
  },
)

type Datapoint = { timeIsoString: string; value: string }
export const getSensorHistorieLoader = (req: PayloadRequest, timeframe: string) =>
  createRequestBoundDataLoader<
    [sensorName: string, fieldName: string, isRate: boolean],
    Datapoint[]
  >('sensorHistorieLoader', async (keys) => {
    const client = getHapySensorenClient()
    const table = getHapySensorenPostgrestAggregatedTable()

    const now = new Date()
    const startDate = new Date()
    if (timeframe === '24h') {
      startDate.setDate(now.getDate() - 1)
    } else if (timeframe === '7d') {
      startDate.setDate(now.getDate() - 7)
    } else {
      startDate.setDate(now.getDate() - 30)
    }

    const sensorNames = [...new Set(keys.map(([sensorName]) => sensorName))]

    const { data, error } = await client
      .from(table)
      .select('*')
      .eq('pipeline_name', CONSOLIDATED_PIPELINE_NAME)
      .in('device_name', sensorNames)
      .gte('timestamp', startDate.toISOString())
      .order('timestamp', { ascending: true })

    if (error) {
      console.error('Error fetching sensor history:', error)
      return keys.map(() => [])
    }

    const groupedBySensor = groupBy(data as SensorData[], 'device_name')
    const targetInterval = Temporal.Duration.from({ hours: 1 })

    return keys.map(([sensorName, fieldName, isRate]) => {
      const sensorEntries = groupedBySensor[sensorName] ?? []

      const points = sensorEntries
        .filter((entry) => fieldName in entry.device_data)
        .map((entry) => {
          let value = Number(entry.device_data[fieldName])
          if (Number.isNaN(value)) {
            value = 0
          }
          const aggregationInterval = Temporal.Duration.from(entry.aggregation_interval)
          if (value > 0 && isRate && fieldName !== 'rain_intensity') {
            const factor =
              targetInterval.total('milliseconds') / aggregationInterval.total('milliseconds')
            value *= factor
          }
          return {
            timestamp: Temporal.Instant.from(entry.timestamp),
            aggregationInterval,
            value,
          }
        })

      const reaggregated = reaggregateSeries(
        points,
        Temporal.Duration.from({ hours: 1 }),
        inferAggregationType(fieldName),
      )

      return reaggregated.map<Datapoint>((entry) => ({
        timeIsoString: entry.timestamp.toString(),
        value: String(entry.value),
      }))
    })
  })(req)

export const getSensorLastMeasurementLoader = createRequestBoundDataLoader<string, Date | null>(
  'sensorLastMeasurementLoader',
  async (keys) => {
    const client = getHapySensorenClient()
    const table = getHapySensorenPostgrestAggregatedTable()

    const { data, error } = await client
      .from(table)
      .select('device_name, timestamp')
      .eq('pipeline_name', CONSOLIDATED_PIPELINE_NAME)
      .in('device_name', keys)
      .order('timestamp', { ascending: false })

    if (error) {
      console.error('Error fetching last measurement timestamps:', error)
      return keys.map(() => null)
    }

    const groupedBySensor = groupBy(data as SensorData[], 'device_name')

    return keys.map((deviceName) => {
      const entries = groupedBySensor[deviceName]
      if (!entries || entries.length === 0) return null

      const latestEntry = entries[0]
      return latestEntry ? new Date(latestEntry.timestamp) : null
    })
  },
)
