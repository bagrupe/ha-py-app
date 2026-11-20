import { type PaginatedDocs } from 'payload'
import type { SensorArt } from '../../../payload-types'

type FetchSensorArten = (input: string) => Promise<Pick<Response, 'json' | 'ok' | 'status'>>

const inFlightRequests = new Map<string, Promise<SensorArt[]>>()

export const loadSensorArten = (
  apiUrl: string,
  fetchSensorArten: FetchSensorArten = fetch,
): Promise<SensorArt[]> => {
  const url = `${apiUrl}/sensor-art`
  const existingRequest = inFlightRequests.get(url)
  if (existingRequest) return existingRequest

  const request = fetchSensorArten(url)
    .then(async (response) => {
      if (!response.ok) {
        throw new Error(`Failed to load sensor types (${response.status})`)
      }

      const result = (await response.json()) as PaginatedDocs<SensorArt>
      return result.docs
    })
    .finally(() => {
      if (inFlightRequests.get(url) === request) {
        inFlightRequests.delete(url)
      }
    })

  inFlightRequests.set(url, request)
  return request
}
