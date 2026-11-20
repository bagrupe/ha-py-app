import { addMonths } from 'date-fns'
import type { OverpassBbox } from 'overpass-ts'
import { type EndpointVeranstaltung } from './utils/endpoint-service'
import { sanitizeEt4DateString } from './utils/sanitize-et4-date-string'

export const FETCH_LIMIT = 100

export type D4Response = {
  status: string
  count: number
  overallcount: number
  items: {
    id: string
    title: string
    texts: {
      rel: string
      type: string
      value: string
    }[]
    city: string
    zip: string
    street: string
    web: string
    geo: {
      main: {
        latitude: number
        longitude: number
      }
    }
    media_objects: {
      rel: string
      url: string
    }[]
    timeIntervals: {
      start: string
      end: string
    }[]
    name: string
    categories: {
      value: string
    }[]
    attributes: [{ key: 'interval_start' | 'interval_end' | string; value: string }]
    addresses: {
      rel: 'author' | 'organisation' | 'organizer' | 'copyright' | 'contact_person'
      name?: string
      city?: string
      zip?: string
      street?: string
      phone?: string
      web?: string
      email?: string
      district?: string
    }[]
  }[]
}

export type D4Veranstaltung = D4Response['items'][number]

const getUrl = (
  experienceValue: string,
  bounds: OverpassBbox,
  page: number,
  licenseKey?: string,
): string => {
  const startDate = new Date()
  startDate.setMinutes(0, 0, 0)

  const url = new URL('https://meta.et4.de/rest.ashx/search/')
  url.searchParams.set('experience', experienceValue)
  if (licenseKey) url.searchParams.set('licensekey', licenseKey)
  url.searchParams.set('type', 'Event')
  url.searchParams.set('startdate', startDate.toISOString())
  url.searchParams.set('enddate', addMonths(startDate, 4).toISOString())
  url.searchParams.set('template', 'ET2022A.json')
  url.searchParams.set(
    'q',
    `lat:[${bounds.minlat} TO ${bounds.maxlat}] AND lon:[${bounds.minlon} TO ${bounds.maxlon}]`,
  )
  url.searchParams.set('limit', FETCH_LIMIT.toString())
  url.searchParams.set('offset', (page * FETCH_LIMIT).toString())
  url.searchParams.set('unrollintervals', 'true')
  url.searchParams.set('sort', 'start asc')

  return url.toString()
}

export const fetchAllVeranstaltungen = async (
  endpoint: EndpointVeranstaltung,
  rect: OverpassBbox,
): Promise<D4Veranstaltung[]> => {
  let page = 0
  let lastPage = false

  const result = []

  while (!lastPage) {
    const url = getUrl(endpoint.experienceValue, rect, page, endpoint.licenseKey)

    const response = await fetch(url, {
      headers: { 'user-agent': 'node' },
    })

    const data = (await response.json()) as D4Response

    if (!data || !data.items.length) {
      lastPage = true
      continue
    }

    if (data.count + page * FETCH_LIMIT >= data.overallcount) {
      lastPage = true
    }
    page++

    result.push(...data.items)
  }

  return collapseDatesOnSameId(result)
}

const collapseDatesOnSameId = (veranstaltungen: D4Veranstaltung[]): D4Veranstaltung[] => {
  const map = new Map<string, D4Veranstaltung>()
  for (const veranstaltung of veranstaltungen) {
    const instanceStart = veranstaltung.attributes.find((a) => a.key === 'interval_start')
    const instanceEnd = veranstaltung.attributes.find((a) => a.key === 'interval_end')

    if (!instanceStart || !instanceEnd) continue

    if (map.has(veranstaltung.id)) {
      const existingVeranstaltung = map.get(veranstaltung.id)!
      existingVeranstaltung.timeIntervals.push({
        start: sanitizeEt4DateString(instanceStart.value),
        end: sanitizeEt4DateString(instanceEnd.value),
      })
      continue
    }

    veranstaltung.timeIntervals = [
      {
        start: sanitizeEt4DateString(instanceStart.value),
        end: sanitizeEt4DateString(instanceEnd.value),
      },
    ]
    map.set(veranstaltung.id, veranstaltung)
  }

  return [...map.values()]
}
