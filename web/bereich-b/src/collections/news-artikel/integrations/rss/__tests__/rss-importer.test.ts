import { editorConfigFactory } from '@payloadcms/richtext-lexical'
import { type SanitizedConfig } from 'payload'
import { beforeAll, beforeEach, describe, expect, test, vi } from 'vitest'
import { rssImport } from '../rss-importer'

const fetchRSSResponseMock = vi.hoisted(() => vi.fn())
const getDefaultEditorConfigMock = vi.hoisted(() => vi.fn())
const upsertMock = vi.hoisted(() => vi.fn())

vi.mock('../rss-client', () => ({ fetchRSSResponse: fetchRSSResponseMock }))

vi.mock('../../../../../dataseeder/upsert', () => ({ upsert: upsertMock }))

vi.mock('../../common', () => ({
  getImageFromPayloadOrFetchFromRemote: vi.fn(),
  prefetchImporterCaches: vi.fn(async () => ({
    articleCache: new Map(),
    imageCache: new Map(),
  })),
  resolveKommuneId: vi.fn((kommune: string) => kommune),
  updateIntegrationResult: vi.fn(),
}))

vi.mock('../../../../../lib/html-to-lexical', async (importOriginal) => ({
  ...(await importOriginal<typeof import('../../../../../lib/html-to-lexical')>()),
  getDefaultEditorConfig: getDefaultEditorConfigMock,
}))

const feed = (content: string, link?: string) => ({
  rss: {
    channel: {
      title: 'Feed',
      link: 'https://www.hameln.de',
      description: 'Feed',
      'atom:link': {},
      item: [
        {
          title: 'Titel',
          ...(link && { link }),
          description: 'Teaser',
          pubDate: 'Mon, 01 Jun 2026 10:00:00 +0000',
          guid: { '#text': 'guid-1', isPermaLink: 'false' },
          'content:encoded': content,
        },
      ],
    },
  },
})

const collectLinkUrls = (node: unknown): (string | undefined)[] => {
  if (typeof node !== 'object' || node === null) return []
  const record = node as { type?: string; fields?: { url?: string } }
  const own = record.type === 'link' ? [record.fields?.url] : []
  return [...own, ...Object.values(node).flatMap(collectLinkUrls)]
}

describe('RSS article import', () => {
  beforeAll(async () => {
    getDefaultEditorConfigMock.mockResolvedValue(
      await editorConfigFactory.fromFeatures({
        config: { collections: [] } as unknown as SanitizedConfig,
      }),
    )
  })

  beforeEach(() => {
    upsertMock.mockReset()
  })

  const importFeed = async (content: string, link?: string) => {
    fetchRSSResponseMock.mockResolvedValue(feed(content, link))
    await rssImport(
      { config: {}, logger: { error: vi.fn(), info: vi.fn(), warn: vi.fn() } } as never,
      {
        id: 'integration-1',
        kommune: 'kommune-1',
        url: 'https://feed.example.test/feed.xml',
        konfiguration: { content: 'content:encoded' },
      } as never,
    )
    return upsertMock.mock.calls[0][0].data.inhalte[0].content
  }

  test('resolves relative hrefs against the item link', async () => {
    const content = await importFeed(
      '<p><a href="/de/rathaus/aktuelles?id=1.2">mehr</a></p>',
      'https://www.hameln.de/de/news/1',
    )

    expect(collectLinkUrls(content)).toEqual(['https://www.hameln.de/de/rathaus/aktuelles?id=1.2'])
  })

  test('replaces an anchor without href by its text', async () => {
    const content = await importFeed(
      '<p>vor <a href="">leer</a> und <a name="x">Anker</a> nach</p>',
      'https://www.hameln.de/de/news/1',
    )

    expect(collectLinkUrls(content)).toEqual([])
    expect(JSON.stringify(content)).toContain('leer')
  })
})
