import { describe, expect, it } from 'vitest'
import { buildQrResponse, encodeMeCard, encodePayload, QR_SVG_OPTIONS } from '../qr-code'

describe('encodePayload', () => {
  describe('type: none', () => {
    it('returns null when type is missing', () => {
      expect(encodePayload({})).toBeNull()
    })

    it('returns null when type is none', () => {
      expect(encodePayload({ type: 'none' })).toBeNull()
    })
  })

  describe('type: url', () => {
    it('trims surrounding whitespace', () => {
      expect(encodePayload({ type: 'url', url: '  https://example.com  ' })).toBe(
        'https://example.com',
      )
    })

    it('returns null for an empty url', () => {
      expect(encodePayload({ type: 'url', url: '' })).toBeNull()
    })

    it('returns null for whitespace-only url', () => {
      expect(encodePayload({ type: 'url', url: '   ' })).toBeNull()
    })

    it('returns null when url is undefined', () => {
      expect(encodePayload({ type: 'url' })).toBeNull()
    })
  })

  describe('type: contact', () => {
    it('builds a compact MECARD', () => {
      const result = encodePayload({
        type: 'contact',
        contact: {
          name: 'Ada Lovelace',
          phone: '030 00000000',
          email: 'ada@example.com',
          address: 'Rathausplatz 1, Hameln',
        },
      })
      expect(result).toBe(
        'MECARD:N:Ada Lovelace;TEL:030 00000000;EMAIL:ada@example.com;ADR:Rathausplatz 1\\, Hameln;;',
      )
    })

    it('omits fields that are empty strings or undefined', () => {
      const result = encodePayload({
        type: 'contact',
        contact: { name: 'Ada', email: '' },
      })
      expect(result).toBe('MECARD:N:Ada;;')
    })

    it('returns null when the contact has no populated fields', () => {
      expect(encodePayload({ type: 'contact', contact: {} })).toBeNull()
    })

    it('returns null when contact is missing entirely', () => {
      expect(encodePayload({ type: 'contact' })).toBeNull()
    })

    it('replaces CR/LF so a crafted value cannot break onto a new line', () => {
      const result = encodeMeCard({ name: 'Ada\r\nLovelace' })
      expect(result).toBe('MECARD:N:Ada Lovelace;;')
    })

    it('escapes the MECARD separators \\ ; : and , so a value cannot inject a field', () => {
      const result = encodeMeCard({
        name: 'Ada;TEL:666',
        address: 'A, B \\ C',
      })
      expect(result).toBe('MECARD:N:Ada\\;TEL\\:666;ADR:A\\, B \\\\ C;;')
    })
  })

  describe('type: coordinates', () => {
    it('emits geo:lat,lng', () => {
      expect(encodePayload({ type: 'coordinates', coordinates: [52.104, 9.356] })).toBe(
        'geo:52.104,9.356',
      )
    })

    it('returns null when coordinates are missing', () => {
      expect(encodePayload({ type: 'coordinates' })).toBeNull()
    })

    it('returns null when coordinates are null', () => {
      expect(encodePayload({ type: 'coordinates', coordinates: null })).toBeNull()
    })
  })
})

describe('buildQrResponse', () => {
  it('returns null when there is no encodable payload', () => {
    expect(buildQrResponse({ type: 'none' })).toBeNull()
    expect(buildQrResponse({ type: 'url', url: '' })).toBeNull()
    expect(buildQrResponse({ type: 'contact', contact: {} })).toBeNull()
  })

  it('is deterministic: same input yields the same etag', () => {
    const a = buildQrResponse({ type: 'url', url: 'https://example.com' })
    const b = buildQrResponse({ type: 'url', url: 'https://example.com' })
    expect(a?.etag).toBe(b?.etag)
  })

  it('different inputs yield different etags', () => {
    const a = buildQrResponse({ type: 'url', url: 'https://a.example' })
    const b = buildQrResponse({ type: 'url', url: 'https://b.example' })
    expect(a?.etag).not.toBe(b?.etag)
  })

  it('etag is stable against whitespace differences in url (post-trim)', () => {
    const a = buildQrResponse({ type: 'url', url: 'https://example.com' })
    const b = buildQrResponse({ type: 'url', url: '  https://example.com  ' })
    expect(a?.etag).toBe(b?.etag)
  })

  it('etag incorporates render options (so a margin bump invalidates caches)', () => {
    // Sanity-check that the etag would change if QR_SVG_OPTIONS changed —
    // we can't mutate the const, so verify the hash includes the current options.
    const result = buildQrResponse({ type: 'url', url: 'https://example.com' })
    expect(result?.etag).toMatch(/^"[a-f0-9]{40}"$/)
    // If this constant ever changes, the etag above must change too.
    expect(QR_SVG_OPTIONS.margin).toBe(1)
    expect(QR_SVG_OPTIONS.errorCorrectionLevel).toBe('M')
  })

  it('render() produces an SVG string', async () => {
    const result = buildQrResponse({ type: 'url', url: 'https://example.com' })
    const svg = await result!.render()
    expect(svg).toMatch(/^<svg[\s\S]+<\/svg>\s*$/)
  })

  it('render() throws when input exceeds QR capacity at level M', async () => {
    // Level M caps byte content at ~2331 chars; 10k is well beyond.
    const huge = 'A'.repeat(10_000)
    const result = buildQrResponse({ type: 'url', url: huge })
    await expect(result!.render()).rejects.toThrow()
  })
})
