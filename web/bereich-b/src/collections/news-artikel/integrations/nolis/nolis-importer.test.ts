import { beforeEach, describe, expect, test, vi } from 'vitest'

const fetchNolisResponseMock = vi.hoisted(() => vi.fn())
const getImageMock = vi.hoisted(() => vi.fn())
const htmlToLexicalMock = vi.hoisted(() => vi.fn())
const upsertMock = vi.hoisted(() => vi.fn())
const updateIntegrationResultMock = vi.hoisted(() => vi.fn())

vi.mock('./nolis-client', () => ({
  fetchNolisResponse: fetchNolisResponseMock,
}))

vi.mock('../../../../dataseeder/upsert', () => ({
  upsert: upsertMock,
}))

vi.mock('../common', () => ({
  getImageFromPayloadOrFetchFromRemote: getImageMock,
  prefetchImporterCaches: vi.fn(async () => ({
    articleCache: new Map(),
    imageCache: new Map(),
  })),
  resolveKommuneId: vi.fn((kommune) => (typeof kommune === 'string' ? kommune : kommune.id)),
  updateIntegrationResult: updateIntegrationResultMock,
}))

vi.mock('../../../../lib/html-to-lexical', () => ({
  getDefaultEditorConfig: vi.fn(async () => ({})),
  htmlToLexical: htmlToLexicalMock,
}))

const article = (content: string) => ({
  id: '900000539',
  titel: 'Stadtverwaltung und Polizei im Austausch',
  anreisser: 'Gemeinsamer Weg zu einer attraktiven Stadt',
  veroeffentlichungsdatum: '2026-09-01T10:00:00+02:00',
  mitteilungsinhalt_html: content,
  vorschaubild: 'https://example.test/preview.jpg',
})

const integration = {
  id: 'integration-1',
  kommune: 'kommune-1',
  url: 'https://example.test',
  token: 'token',
  type: 'meldungen',
  konfiguration: { artikelSeitenId: '33910' },
} as never

describe('nolisImport', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    getImageMock.mockResolvedValue({ id: 'image-1' })
    htmlToLexicalMock.mockImplementation((html: string) => ({ importedHtml: html }))
  })

  test('moves one trailing image caption from content to the title image', async () => {
    fetchNolisResponseMock.mockResolvedValue({
      data: [article('Meldungstext.<br><br>Foto: Peter Jahn')],
    })
    const warn = vi.fn()

    const { nolisImport } = await import('./nolis-importer')
    await nolisImport(
      {
        config: {},
        logger: { warn },
      } as never,
      integration,
    )

    expect(htmlToLexicalMock).toHaveBeenCalledWith('<p>Meldungstext.</p>', {})
    expect(upsertMock).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          titelbilder: [
            {
              bild: 'image-1',
              id: 'image-1',
              bildunterschrift: 'Foto: Peter Jahn',
            },
          ],
          originalUrl: 'https://example.test/portal/meldungen/artikel-900000539-33910.html',
          inhalte: [
            {
              blockType: 'rich-text',
              content: { importedHtml: '<p>Meldungstext.</p>' },
            },
          ],
        }),
      }),
      expect.any(Object),
    )
    expect(warn).not.toHaveBeenCalled()
  })

  test('uses the first caption and removes captions for unavailable additional images', async () => {
    const content = [
      'Meldungstext.',
      'Bild 1: Fahrzeugübergabe. © Foto: Peter Jahn',
      'Bild 2: Jugendfeuerwehr. © Foto: Peter Jahn',
    ].join('<br><br>')
    fetchNolisResponseMock.mockResolvedValue({ data: [article(content)] })
    const warn = vi.fn()

    const { nolisImport } = await import('./nolis-importer')
    await nolisImport(
      {
        config: {},
        logger: { warn },
      } as never,
      integration,
    )

    expect(htmlToLexicalMock).toHaveBeenCalledWith('<p>Meldungstext.</p>', {})
    expect(upsertMock.mock.calls[0]?.[0].data.titelbilder[0].bildunterschrift).toBe(
      'Bild 1: Fahrzeugübergabe. © Foto: Peter Jahn',
    )
    expect(warn).not.toHaveBeenCalled()
  })
})
