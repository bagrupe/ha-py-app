import { describe, expect, it } from 'vitest'
import {
  parseMesswert,
  pegelGefahrenstufeMitHysterese,
  pegelGefahrenstufeVonWert,
  sindGrenzwerteGueltig,
} from './sensoren'

describe('parseMesswert', () => {
  it('parses a valid numeric string', () => {
    expect(parseMesswert('36.7')).toBe(36.7)
  })

  it('parses zero as a real value, not "missing"', () => {
    expect(parseMesswert('0')).toBe(0)
  })

  it('returns null for an empty string (kein Messwert gefunden)', () => {
    expect(parseMesswert('')).toBeNull()
  })

  it('returns null for a non-numeric string', () => {
    expect(parseMesswert('not-a-number')).toBeNull()
  })
})

describe('pegelGefahrenstufeVonWert', () => {
  const grenzwerte = { info1: 110, info2: 190, info3: 260 }

  it.each([
    [0, 'GRUEN'],
    [109, 'GRUEN'],
    [110, 'GRUEN'],
    [111, 'GELB'],
    [190, 'GELB'],
    [191, 'ORANGE'],
    [260, 'ORANGE'],
    [261, 'ROT'],
    [1000, 'ROT'],
  ] as const)('maps value %d to %s', (value, expected) => {
    expect(pegelGefahrenstufeVonWert(value, grenzwerte)).toBe(expected)
  })
})

describe('pegelGefahrenstufeMitHysterese', () => {
  // Schwellenwert 100cm (Grenze GRUEN/GELB), passend zum vom Fachbereich genannten Beispiel:
  // erst bei 91cm (100cm - 9cm Puffer) wieder auf GRUEN zurückstufen.
  const grenzwerte = { info1: 100, info2: 200, info3: 300 }

  it('übernimmt die Rohstufe unverändert bei der ersten Beobachtung', () => {
    expect(pegelGefahrenstufeMitHysterese('GRUEN', null, 95, grenzwerte)).toBe('GRUEN')
  })

  it('stuft sofort hoch, auch ohne Puffer', () => {
    expect(pegelGefahrenstufeMitHysterese('GELB', 'GRUEN', 101, grenzwerte)).toBe('GELB')
  })

  it('bleibt bei der letzten Stufe, solange der Wert nicht 9cm unter den Schwellenwert gefallen ist', () => {
    expect(pegelGefahrenstufeMitHysterese('GRUEN', 'GELB', 95, grenzwerte)).toBe('GELB')
    expect(pegelGefahrenstufeMitHysterese('GRUEN', 'GELB', 92, grenzwerte)).toBe('GELB')
  })

  it('stuft herunter, sobald der Wert genau 9cm unter den Schwellenwert gefallen ist', () => {
    expect(pegelGefahrenstufeMitHysterese('GRUEN', 'GELB', 91, grenzwerte)).toBe('GRUEN')
    expect(pegelGefahrenstufeMitHysterese('GRUEN', 'GELB', 50, grenzwerte)).toBe('GRUEN')
  })

  it('bleibt unverändert, wenn Roh- und letzte Stufe übereinstimmen', () => {
    expect(pegelGefahrenstufeMitHysterese('ORANGE', 'ORANGE', 250, grenzwerte)).toBe('ORANGE')
  })
})

describe('sindGrenzwerteGueltig', () => {
  it('accepts strictly increasing, positive grenzwerte', () => {
    expect(sindGrenzwerteGueltig({ info1: 110, info2: 190, info3: 260, info4: 272 })).toBe(true)
  })

  it('rejects all-zero grenzwerte (unkalibrierter Sensor)', () => {
    expect(sindGrenzwerteGueltig({ info1: 0, info2: 0, info3: 0, info4: 0 })).toBe(false)
  })

  it('rejects non-monotonic grenzwerte', () => {
    expect(sindGrenzwerteGueltig({ info1: 110, info2: 100, info3: 260, info4: 272 })).toBe(false)
  })

  it('rejects grenzwerte with duplicate boundaries', () => {
    expect(sindGrenzwerteGueltig({ info1: 110, info2: 110, info3: 260, info4: 272 })).toBe(false)
  })
})
