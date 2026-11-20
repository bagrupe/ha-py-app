import { describe, expect, it, vi } from 'vitest'

// Pois imports a geometry helper that only needs the full Payload config when called. Avoid
// initializing payload.config while this static collection-contract test imports the config.
vi.mock('@payload-config', () => ({ default: Promise.resolve({}) }))
import { Aufrufe } from '../collections/aufrufe/aufrufe'
import { Kommunen } from '../collections/kommunen'
import { NewsArtikel } from '../collections/news-artikel/news-artikel'
import { Pois } from '../collections/pois/pois'
import { SensorArt } from '../collections/sensoren/sensor-art'
import { Sensoren } from '../collections/sensoren/sensoren'
import { Veranstaltungskalender } from '../collections/veranstaltungen/veranstaltungskalender'

describe('generated value forceSelect dependencies', () => {
  it.each([
    ['sensor-art.title', SensorArt.forceSelect, { name: true, einheit: true }],
    [
      'sensoren generated fields',
      Sensoren.forceSelect,
      {
        name: true,
        letzteBenachrichtigteGefahrenstufe: true,
        felder: { name: true, werteart: true },
      },
    ],
    ['news-artikel generated fields', NewsArtikel.forceSelect, { inhalte: true }],
    [
      'aufrufe generated fields',
      Aufrufe.forceSelect,
      { beschreibung: true, bild: true, qrCode: true, kommune: true },
    ],
    [
      'kommunen.lizenzen.kartenlizenzenHtml',
      Kommunen.forceSelect,
      { lizenzen: { kartenlizenzen: true } },
    ],
    ['poi.contents contentHtml', Pois.forceSelect, { contents: true }],
    [
      'veranstaltungskalender.inhalte contentHtml',
      Veranstaltungskalender.forceSelect,
      { inhalte: true },
    ],
  ])('declares the dependencies for %s', (_placement, actual, expected) => {
    expect(actual).toEqual(expected)
  })
})
