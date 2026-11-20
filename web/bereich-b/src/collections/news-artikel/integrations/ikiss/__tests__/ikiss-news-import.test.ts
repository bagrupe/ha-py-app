import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { afterAll, beforeAll, beforeEach, describe, expect, test, vi } from 'vitest'
import { iKissImport } from '../ikiss-importer'

const upsertMock = vi.hoisted(() => vi.fn())
const getImageMock = vi.hoisted(() =>
  vi.fn(async (_payload: unknown, _url: string, fileName: string) => ({ id: `media:${fileName}` })),
)

vi.mock('@sentry/nextjs', () => ({
  captureException: vi.fn(),
  captureMessage: vi.fn(),
}))

vi.mock('../../../../../dataseeder/upsert', () => ({ upsert: upsertMock }))

vi.mock('../../common', () => ({
  getImageFromPayloadOrFetchFromRemote: getImageMock,
  prefetchImporterCaches: vi.fn(async () => ({ articleCache: new Map(), imageCache: new Map() })),
  resolveKommuneId: vi.fn((kommune: string) => kommune),
  updateIntegrationResult: vi.fn(),
}))

vi.mock('../../../../../lib/html-to-lexical', () => ({
  getDefaultEditorConfig: vi.fn(async () => ({})),
  htmlToLexical: vi.fn((html: string) => ({ importedHtml: html })),
}))

const fixture = (name: string) => readFileSync(join(__dirname, 'fixtures', name), 'utf-8')

const xmlResponse = (body: string) =>
  new Response(body, { headers: { 'content-type': 'text/xml;charset=utf-8' } })

const recordedResponse = (requestBody: string): Response => {
  const field = (name: string) => requestBody.match(new RegExp(`<${name}>([^<]*)</${name}>`))?.[1]
  const module = field('set_module')
  const action = field('action')
  if (module === 'content' && action === 'search') {
    return xmlResponse(fixture(`content-search-category-${field('categorie')?.split('.')[1]}.xml`))
  }
  if (module === 'content' && action === 'fetch') {
    return xmlResponse(fixture(`article-${field('id')}.xml`))
  }
  if (module === 'media' && action === 'fetch') {
    return xmlResponse(fixture(`media-${field('id')}.xml`))
  }
  throw new Error(`No recorded response for ${module}/${action}`)
}

const payloadStub = {
  config: {},
  logger: { error: vi.fn(), info: vi.fn(), warn: vi.fn() },
} as never

const integration = {
  id: 'integration-1',
  kommune: 'kommune-1',
  untereinheit: undefined,
  url: 'https://ikiss.example.test',
  benutzername: 'user',
  passwort: 'secret',
  konfiguration: {
    kategorien: [
      { kategorie: '2561.264.1', gewichtung: 10 },
      { kategorie: '2561.154.1', gewichtung: 0 },
    ],
  },
} as never

describe('iKISS news import', () => {
  beforeAll(() => {
    vi.useFakeTimers({ toFake: ['Date'] })
    vi.setSystemTime(new Date('2026-10-26T12:00:00Z'))
  })

  afterAll(() => {
    vi.useRealTimers()
  })

  beforeEach(() => {
    vi.clearAllMocks()
    vi.stubGlobal(
      'fetch',
      vi.fn(async (_url: URL, init: { body: string }) => recordedResponse(init.body)),
    )
  })

  test('imports iKISS articles as news-artikel docs', async () => {
    await iKissImport(payloadStub, integration)

    expect(upsertMock.mock.calls.map(([args]) => args)).toEqual(
      JSON.parse(fixture('expected-news-artikel-upserts.json')),
    )
  })
})
