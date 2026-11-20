import { beforeEach, describe, expect, it, vi } from 'vitest'
import { CronJobItemFailures } from '../cron-job-item-failures'
import { type D4Veranstaltung } from '../import-veranstaltungen/fetch-all-veranstaltungen'

const ikissIntegration = vi.hoisted(() => ({
  id: 'integration-1',
  integrationtype: 'IKISS_VERANSTALTUNGEN',
  kommune: 'kommune-1',
  url: 'https://ikiss.example.test',
  zugangsdaten: { benutzername: 'user', passwort: 'secret' },
}))

const mocks = vi.hoisted(() => ({
  upsert: vi.fn(),
  fetchAllVeranstaltungen: vi.fn(),
}))

vi.mock('@payload-config', () => ({ default: {} }))
vi.mock('../metrics', () => ({ scheduleWithMetrics: vi.fn() }))
vi.mock('payload', () => ({
  getPayload: async () => ({
    config: {},
    logger: { info() {}, warn() {}, error() {} },
    find: async ({ collection }: { collection: string }) => ({
      docs:
        collection === 'kommunen'
          ? [kommune]
          : collection === 'integration'
            ? [ikissIntegration]
            : [],
    }),
    update: async () => ({}),
  }),
}))
vi.mock('../../dataseeder/upsert', () => ({ upsert: mocks.upsert }))
vi.mock('../../lib/html-to-lexical', () => ({
  getDefaultEditorConfig: async () => ({}),
  htmlToLexical: (html: string) => ({ importedHtml: html }),
}))
vi.mock('../import-veranstaltungen/fetch-all-veranstaltungen', () => ({
  fetchAllVeranstaltungen: mocks.fetchAllVeranstaltungen,
}))
vi.mock('../import-veranstaltungen/utils/endpoint-service', () => ({
  getEndpointsVeranstaltungen: () => [{ name: 'Destination One', experienceValue: 'experience' }],
  getEndpointIds: async () => ['quelle-1'],
  upsertEndpoint: vi.fn(),
}))
vi.mock('../import-veranstaltungen/utils/category-service', () => ({
  ensureCategoriesExist: vi.fn(),
  getCategoryIds: async () => ['category-1'],
}))
vi.mock('../import-veranstaltungen/utils/location-bounds-service', () => ({
  getLocationBoundsByRegionalKey: async () => ({ rect: [], geojson: { features: [] } }),
  getGemeindenBoundsForKommune: async () => [],
  getUntereinheitIdByCoordinates: () => 'untereinheit-1',
}))
vi.mock('../import-veranstaltungen/utils/geojson-service', () => ({
  isPointInAtLeastOnePoly: () => true,
}))
vi.mock('../import-veranstaltungen/utils/upload-default-image', () => ({
  uploadDefaultImage: async () => ({ id: 'image-1' }),
}))
vi.mock('../import-veranstaltungen/utils/untereinheiten-present-test', () => ({
  hasUntereinheiten: async () => true,
}))

import { importVeranstaltungen } from '../import-veranstaltungen/import-veranstaltungen'

const kommune = { id: 'kommune-1', name: 'Landkreis Hameln-Pyrmont', regionalschluessel: '03252' }

const et4Event: D4Veranstaltung = {
  id: 'et4-1',
  title: 'Stadtfest',
  name: 'Stadtfest Hameln',
  city: 'Hameln',
  zip: '31785',
  street: 'Osterstraße 1',
  web: 'https://anbieter.example.test',
  geo: { main: { latitude: 52.1, longitude: 9.35 } },
  texts: [
    { rel: 'teaser', type: 'text/plain', value: 'https://tickets.example.test/stadtfest' },
    { rel: 'details', type: 'text/html', value: '<p>Programm</p>' },
  ],
  media_objects: [{ rel: 'booking', url: 'https://buchung.example.test' }],
  timeIntervals: [{ start: '2026-11-01T10:00:00Z', end: '2026-11-01T18:00:00Z' }],
  categories: [{ value: 'Fest' }],
  attributes: [{ key: 'interval_start', value: '' }],
  addresses: [
    {
      rel: 'organizer',
      name: 'Stadt Hameln',
      city: 'Hameln',
      zip: '31785',
      street: 'Markt 1',
      phone: '05151 1',
      web: 'https://hameln.example.test',
      email: 'info@hameln.example.test',
    },
  ],
}

describe('import_veranstaltungen cron', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.spyOn(console, 'info').mockImplementation(() => {})
    vi.spyOn(console, 'error').mockImplementation(() => {})
    vi.stubGlobal(
      'fetch',
      vi.fn(async () => {
        throw new TypeError('fetch failed')
      }),
    )
    mocks.fetchAllVeranstaltungen.mockResolvedValue([et4Event])
  })

  it('imports ET4 Veranstaltungen even when the iKISS step fails', async () => {
    const failures = new CronJobItemFailures()

    await importVeranstaltungen(failures)

    expect(mocks.upsert.mock.calls.map(([args]) => args)).toEqual([
      {
        collection: 'veranstaltungskalender',
        key: ['id', 'kommune'],
        data: {
          id: 'et4-1',
          titel: 'Stadtfest',
          teaser: 'https://tickets.example.test/stadtfest',
          subtitle: 'Stadtfest Hameln',
          category: ['category-1'],
          titelbild: { external: false, internal: 'image-1' },
          source: ['quelle-1'],
          untereinheit: 'untereinheit-1',
          timeAndLocation: {
            coordinates: [52.1, 9.35],
            locationName: 'Hameln',
            address: 'Osterstraße 1, 31785 Hameln',
            dates: [{ start: '2026-11-01T10:00:00.000Z', end: '2026-11-01T18:00:00.000Z' }],
          },
          veranstalterAdresse: {
            name: 'Stadt Hameln',
            ort: 'Hameln',
            plz: '31785',
            strasse: 'Markt 1',
            telefon: '05151 1',
            url: 'https://hameln.example.test',
            email: 'info@hameln.example.test',
          },
          buchungsUrl: 'https://buchung.example.test',
          ticketUrl: 'https://tickets.example.test/stadtfest',
          anbieterUrl: 'https://anbieter.example.test',
          inhalte: [{ blockType: 'rich-text', content: { importedHtml: '<p>Programm</p>' } }],
          kommune: 'kommune-1',
        },
      },
    ])
    expect(failures.getCount()).toBe(1)
  })

  it('keeps importing when a single ET4 event or a whole ET4 endpoint fails', async () => {
    const secondEvent = { ...et4Event, id: 'et4-2' }
    mocks.fetchAllVeranstaltungen.mockResolvedValue([et4Event, secondEvent])
    mocks.upsert.mockRejectedValueOnce(new Error('Key is not unique'))
    const eventFailures = new CronJobItemFailures()

    await importVeranstaltungen(eventFailures)

    expect(mocks.upsert.mock.calls.map(([args]) => args.data.id)).toEqual(['et4-1', 'et4-2'])
    expect(eventFailures.getCount(), 'failed event plus failed iKISS step').toBe(2)

    vi.mocked(fetch).mockClear()
    mocks.fetchAllVeranstaltungen.mockRejectedValue(new SyntaxError('Unexpected token <'))
    const endpointFailures = new CronJobItemFailures()

    await importVeranstaltungen(endpointFailures)

    expect(fetch, 'iKISS still runs after ET4 failed').toHaveBeenCalled()
    expect(endpointFailures.getCount(), 'failed endpoint plus failed iKISS step').toBe(2)
  })
})
