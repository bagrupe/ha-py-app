import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { JSDOM } from 'jsdom'
import { describe, expect, it, vi } from 'vitest'
import { parseIkissEventsResponse } from '../../../../integrations/ikiss/ikiss-events'
import { mapIkissEventToVeranstaltung } from '../ikiss-event-mapper'

vi.mock('../../../../lib/html-to-lexical', () => ({
  getDefaultEditorConfig: vi.fn(async () => ({})),
  htmlToLexical: vi.fn((html: string) => ({ importedHtml: html })),
}))

const fetchedEvent = (fixture = 'event-fetch-vhs.xml') =>
  parseIkissEventsResponse(readFileSync(join(__dirname, 'fixtures', fixture), 'utf-8'))[0]

const normalizeWhitespace = (text: string | null) => (text ?? '').replace(/\s+/g, ' ').trim()

const importedBody = async (fixture: string) => {
  const doc = await mapIkissEventToVeranstaltung(fetchedEvent(fixture), {
    kommuneId: 'kommune-1',
    quelleId: 'quelle-lk',
    baseUrl: 'https://ikiss.example.test',
    timeZone: 'Europe/Berlin',
    resolveImage: async () => ({ status: 'notAnImage' }),
  })
  const [block] = doc.inhalte as { content: { importedHtml: string } }[]
  return new JSDOM(block.content.importedHtml).window.document.body
}

describe('iKISS Veranstaltung body rendering', () => {
  const paragraphTexts = (body: HTMLElement) =>
    Array.from(body.querySelectorAll('p'), (p) => normalizeWhitespace(p.textContent))

  it('renders a link whose text holds markup without leaking the tag', async () => {
    const body = await importedBody('event-fetch-4001.xml')

    expect(paragraphTexts(body)).toContain(
      'Das Projekt „Geste - gemeinsamSTARK“ wird im Rahmen des Programms "Akti(F) Plus-Aktiv für Familien und ihre Kinder" durch das Bundesministerium für Arbeit und Soziales und die Europäische Union über den Europäischen Sozialfonds Plus (ESF Plus) gefördert.',
    )
    expect(body.textContent).not.toContain('/>')
  })

  it('keeps the mail link of the body', async () => {
    const body = await importedBody('event-fetch-4001.xml')

    expect(Array.from(body.querySelectorAll('a'), (a) => a.getAttribute('href'))).toEqual([
      'mailto:geste@impuls-hamelnpyrmont.de',
    ])
  })

  it('shows the contact once when the body already contains it', async () => {
    const body = await importedBody('event-fetch-4001.xml')
    const contact =
      'Melden Sie sich auch gern telefonisch 05151 9821- 40 oder per Mail geste@impuls-hamelnpyrmont.de'

    expect(paragraphTexts(body).filter((text) => text === contact)).toHaveLength(1)
  })
})

describe('iKISS Veranstaltung field mapping', () => {
  it('maps an iKISS event to a Veranstaltung doc', async () => {
    const doc = await mapIkissEventToVeranstaltung(fetchedEvent(), {
      kommuneId: 'kommune-1',
      quelleId: 'quelle-lk',
      baseUrl: 'https://ikiss.example.test',
      timeZone: 'Europe/Berlin',
      resolveImage: async (imageId) =>
        ({ status: 'imported', image: { id: `media-${imageId}` } }) as never,
    })

    expect(doc).toStrictEqual({
      id: '3767.3995.1',
      titel: 'Raus aus der Erschöpfung - Besser schlafen in den Wechseljahren',
      visible: true,
      teaser: 'Besser schlafen in den Wechseljahren.',
      timeAndLocation: {
        locationName: 'vhs-Haus, Kompetenzschmiede, Raum 008',
        dates: [{ start: '2026-10-23T14:00:00.000Z', end: '2026-10-23T16:00:00.000Z' }],
      },
      inhalte: [
        {
          blockType: 'rich-text',
          content: {
            importedHtml: expect.stringMatching(
              /Raus aus der Erschöpfung[\s\S]*<a href="mailto:contact-eca83f38@example\.com"[^>]*>contact-eca83f38@example\.com<\/a>/,
            ),
          },
        },
        { blockType: 'image-veranstaltungsmedien', image: 'media-3767.3497.1' },
        {
          blockType: 'rich-text',
          content: {
            importedHtml: expect.stringMatching(/<p>Kostenfrei<\/p>\s*<p>Anmeldung über/),
          },
        },
      ],
      titelbild: { external: false, internal: 'media-3767.3498.1' },
      source: ['quelle-lk'],
      kommune: 'kommune-1',
    })
  })

  it('sends emptied fields as null so the stored doc mirrors upstream', async () => {
    const doc = await mapIkissEventToVeranstaltung(
      { id: '3767.1.1', title: 'Bare', datetimeFrom: '2026-11-05 10:00:00', released: true },
      {
        kommuneId: 'kommune-1',
        quelleId: 'quelle-lk',
        baseUrl: 'https://ikiss.example.test',
        timeZone: 'Europe/Berlin',
        resolveImage: async () => ({ status: 'notAnImage' }),
      },
    )

    expect(doc).toMatchObject({
      teaser: null,
      timeAndLocation: { locationName: null },
      inhalte: [],
      titelbild: { external: false, internal: null },
    })
  })

  it('omits the cover when its image import fails', async () => {
    const doc = await mapIkissEventToVeranstaltung(fetchedEvent(), {
      kommuneId: 'kommune-1',
      quelleId: 'quelle-lk',
      baseUrl: 'https://ikiss.example.test',
      timeZone: 'Europe/Berlin',
      resolveImage: async () => ({ status: 'failed', error: new Error('HTTP 500') }),
    })

    expect(doc).not.toHaveProperty('titelbild')
  })

  it('drops inline media that are not images', async () => {
    const doc = await mapIkissEventToVeranstaltung(fetchedEvent(), {
      kommuneId: 'kommune-1',
      quelleId: 'quelle-lk',
      baseUrl: 'https://ikiss.example.test',
      timeZone: 'Europe/Berlin',
      resolveImage: async () => ({ status: 'notAnImage' }),
    })

    expect(doc.inhalte).not.toContainEqual(
      expect.objectContaining({ blockType: 'image-veranstaltungsmedien' }),
    )
  })
})
