import { PostgrestClient } from '@supabase/postgrest-js'

export const CONSOLIDATED_PIPELINE_NAME = 'consolidated'
export const MIXED_PIPELINE_NAME = 'mixed'

export const getHapySensorenPostgrestAggregatedTable = () =>
  process.env.HAPY_SENSOREN_POSTGREST_AGGREGATED_TABLE!

export const getHapySensorenPostgrestTable = () => process.env.HAPY_SENSOREN_POSTGREST_TABLE!

let sensorenClient: PostgrestClient | undefined
export const getHapySensorenClient = () => {
  if (sensorenClient) return sensorenClient

  const url = process.env.HAPY_SENSOREN_POSTGREST_URL ?? ''
  const token = process.env.HAPY_SENSOREN_POSTGREST_TOKEN ?? ''
  const client = new PostgrestClient(url, {
    headers: {
      'X-Gravitee-Api-Key': token!,
    },
  })

  return (sensorenClient = client)
}
