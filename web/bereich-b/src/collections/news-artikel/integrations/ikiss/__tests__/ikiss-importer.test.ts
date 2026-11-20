import { editorConfigFactory } from '@payloadcms/richtext-lexical'
import { type SanitizedConfig } from 'payload'
import { beforeAll, beforeEach, describe, expect, test, vi } from 'vitest'
import { getArticleByIdAndUpload } from '../ikiss-importer'

const fetchIKissResponseMock = vi.hoisted(() => vi.fn())
const getImageMock = vi.hoisted(() => vi.fn())
const decodeIkissResponseMock = vi.hoisted(() => vi.fn())
const getDefaultEditorConfigMock = vi.hoisted(() => vi.fn())
const htmlToLexicalMock = vi.hoisted(() => vi.fn())
const upsertMock = vi.hoisted(() => vi.fn())
const updateIntegrationResultMock = vi.hoisted(() => vi.fn())

vi.mock('@sentry/nextjs', () => ({
  captureException: vi.fn(),
  captureMessage: vi.fn(),
}))

vi.mock('../../../../../integrations/ikiss/ikiss-client', () => ({
  createIKissRequest: vi.fn(() => ({ ikiss: { request: {} } })),
  decodeIkissResponse: decodeIkissResponseMock,
  fetchIKissResponse: fetchIKissResponseMock,
}))

vi.mock('../../../../../dataseeder/upsert', () => ({
  upsert: upsertMock,
}))

vi.mock('../../common', () => ({
  getImageFromPayloadOrFetchFromRemote: getImageMock,
  prefetchImporterCaches: vi.fn(async () => ({
    articleCache: new Map(),
    imageCache: new Map(),
  })),
  resolveKommuneId: vi.fn((kommune) => (typeof kommune === 'string' ? kommune : kommune.id)),
  updateIntegrationResult: updateIntegrationResultMock,
}))

vi.mock('../../../../../lib/html-to-lexical', () => ({
  getDefaultEditorConfig: getDefaultEditorConfigMock,
  htmlToLexical: htmlToLexicalMock,
}))

const ikissXml = (result: string[]) =>
  ['<?xml version="1.0"?>', '<ikiss>', '  <result>', ...result, '  </result>', '</ikiss>'].join(
    '\n',
  )

const articleXml = (html: string) =>
  ikissXml([
    '    <tcontent>',
    `      <data_content><![CDATA[${html}]]></data_content>`,
    '      <date>2026-06-08T14:32:51.000Z</date>',
    '      <release>true</release>',
    '      <tLayout/>',
    '      <tTpFields>',
    '        <title>Einweihungsfeier der Schule im Hummtal</title>',
    '        <data_content></data_content>',
    '      </tTpFields>',
    '    </tcontent>',
  ])

const mediaXml = ikissXml([
  '    <tmedia>',
  '      <tdata_list>',
  '        <tdata><width>800</width><media_path>/3767_1795_1.jpg?1</media_path></tdata>',
  '      </tdata_list>',
  '    </tmedia>',
])

const payloadStub = {
  config: {},
  logger: { error: vi.fn(), info: vi.fn(), warn: vi.fn() },
} as never

const integrationStub = {
  id: 'integration-1',
  kommune: 'kommune-1',
  url: 'https://example.test',
  benutzername: 'user',
  passwort: 'pass',
} as never

const importArticle = (articleId: string) =>
  getArticleByIdAndUpload(payloadStub, articleId, 0, integrationStub, new Map(), new Map())

describe('iKISS article import', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    fetchIKissResponseMock.mockResolvedValue(new Response())
    getDefaultEditorConfigMock.mockResolvedValue({})
    htmlToLexicalMock.mockImplementation((html: string) => ({
      root: {
        type: 'root',
        children: [],
        importedHtml: html,
      },
    }))
  })

  test('extracts the teaser paragraph and excludes title/teaser from imported content', async () => {
    const teaser =
      'Nach gut 4 Jahren Bauzeit konnte heute/am 4.6.2026 die Einweihung des sanierten Gebäudes der Schule im Hummetal gefeiert werden. Die Sanierung der Schule im Hummetal gehört Gesamtkosten von rund 15 Millionen Euro zu den aktuell großen Schulbauprojekten des Landkreises Hameln-Pyrmont.'
    const body =
      'Landrat Dirk Adomat betonte während der Einweihungsfeier, wie wichtig die Investitionen in die Schulgebäude des Landkreises ist.'

    decodeIkissResponseMock.mockResolvedValue(
      articleXml(
        [
          '<h1>Einweihungsfeier der Schule im Hummtal</h1>',
          `<div class="lead"><p>${teaser}</p></div>`,
          `<p>${body}</p>`,
        ].join(''),
      ),
    )

    await importArticle('3767.1832.1')

    const upsertArg = upsertMock.mock.calls[0]?.[0]
    expect(upsertArg.data.teaser).toBe(teaser)
    expect(upsertArg.data.teaser).not.toContain('Einweihungsfeier der Schule im Hummtal')
    expect(upsertArg.data.teaser).not.toContain(body)

    const importedHtml = upsertArg.data.inhalte[0].content.root.importedHtml
    expect(importedHtml).toContain(body)
    expect(importedHtml).not.toContain(teaser)
    expect(importedHtml).not.toContain('Einweihungsfeier der Schule im Hummtal')
  })

  describe('with real html-to-lexical conversion', () => {
    let actualLexical: typeof import('../../../../../lib/html-to-lexical')
    let editorConfig: Awaited<ReturnType<typeof editorConfigFactory.fromFeatures>>

    const collectLinkUrls = (node: unknown): string[] => {
      if (typeof node !== 'object' || node === null) return []
      const record = node as { type?: string; fields?: { url?: string } }
      const own = record.type === 'link' && record.fields?.url ? [record.fields.url] : []
      return [...own, ...Object.values(node).flatMap(collectLinkUrls)]
    }

    beforeAll(async () => {
      actualLexical = await vi.importActual('../../../../../lib/html-to-lexical')
      editorConfig = await editorConfigFactory.fromFeatures({
        config: { collections: [] } as unknown as SanitizedConfig,
      })
    })

    beforeEach(() => {
      decodeIkissResponseMock.mockReset()
      getDefaultEditorConfigMock.mockResolvedValue(editorConfig)
      htmlToLexicalMock.mockImplementation(actualLexical.htmlToLexical)
      getImageMock.mockResolvedValue({ id: 'image-1' })
    })

    test.each([
      ['a redirect link', '/redirect.phtml?extlink=1&La=1&url_fid=2749.500.1'],
      ['a media link', '/media/custom/3767_3083_1.PDF?1771414354'],
    ])('resolves %s against the integration url', async (_name, href) => {
      decodeIkissResponseMock.mockResolvedValueOnce(
        articleXml(`<p>Text <a href="${href}" target="_blank">hier</a></p>`),
      )

      await importArticle('3767.1635.1')

      const { inhalte } = upsertMock.mock.calls[0][0].data
      expect(collectLinkUrls(inhalte)).toEqual([`https://example.test${href}`])
    })

    test('leaves absolute and mailto links untouched', async () => {
      decodeIkissResponseMock.mockResolvedValueOnce(
        articleXml(
          '<p><a href="https://www.example.org/a">a</a> <a href="mailto:vet@example.org">m</a></p>',
        ),
      )

      await importArticle('3767.1635.1')

      const { inhalte } = upsertMock.mock.calls[0][0].data
      expect(collectLinkUrls(inhalte)).toEqual([
        'https://www.example.org/a',
        'mailto:vet@example.org',
      ])
    })

    test.each([
      [
        'an image inside a paragraph',
        '<p>Intro</p><p><img src="/media/custom/3767_1795_1.jpg"></p><p>Outro</p>',
      ],
      [
        'an image inside nested divs',
        '<div class="tt_ac"><p>Intro</p><div><img src="/media/custom/3767_1795_1.jpg"></div><p>Outro</p></div>',
      ],
    ])('keeps %s as an image block between rich-text blocks', async (_name, html) => {
      decodeIkissResponseMock
        .mockResolvedValueOnce(articleXml(html))
        .mockResolvedValueOnce(mediaXml)

      await importArticle('3767.1795.1')

      const { inhalte } = upsertMock.mock.calls[0][0].data
      expect(inhalte.map((block: { blockType: string }) => block.blockType)).toEqual([
        'rich-text',
        'image-veranstaltungsmedien',
        'rich-text',
      ])
      expect(JSON.stringify(inhalte)).not.toContain('"horizontalrule"')
    })
  })
})
