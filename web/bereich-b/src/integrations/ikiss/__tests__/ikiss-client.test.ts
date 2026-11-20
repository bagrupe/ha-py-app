import { describe, expect, test } from 'vitest'
import { decodeIkissResponse } from '../ikiss-client'

/**
 * The iKISS API returns `Content-Type: text/xml;charset=iso-8859-15`.
 * Node's `response.text()` ignores the charset parameter and decodes as
 * UTF-8, so ISO-8859-15 bytes for umlauts (0xE4, 0xF6, 0xFC, 0xDF, 0xE9)
 * become U+FFFD. `decodeIkissResponse` reads the declared charset and
 * decodes correctly.
 */
describe('decodeIkissResponse', () => {
  const iso88591Bytes = (text: string) => new Uint8Array(Buffer.from(text, 'binary'))

  test('decodes ISO-8859-15 body declared via charset parameter', async () => {
    // 0xFC=ü, 0xE4=ä, 0xDF=ß, 0xF6=ö, 0xE9=é
    const body = iso88591Bytes('Gefl\xFCgelpest - Stra\xDFe - r\xF6misch - \xE4pfel - Caf\xE9')
    const response = new Response(body, {
      headers: { 'content-type': 'text/xml;charset=iso-8859-15' },
    })

    const decoded = await decodeIkissResponse(response)

    expect(decoded).toBe('Geflügelpest - Straße - römisch - äpfel - Café')
    expect(decoded).not.toContain('�')
  })

  test('native response.text() corrupts the same body (regression guard)', async () => {
    const body = iso88591Bytes('Gefl\xFCgelpest')
    const response = new Response(body, {
      headers: { 'content-type': 'text/xml;charset=iso-8859-15' },
    })

    const corrupted = await response.text()

    expect(corrupted).toContain('�')
    expect(corrupted).not.toBe('Geflügelpest')
  })

  test('decodes UTF-8 body when charset=utf-8', async () => {
    const body = new Uint8Array(Buffer.from('Bundesstraßen', 'utf-8'))
    const response = new Response(body, {
      headers: { 'content-type': 'text/xml;charset=utf-8' },
    })

    const decoded = await decodeIkissResponse(response)

    expect(decoded).toBe('Bundesstraßen')
  })

  test('falls back to UTF-8 when no charset is declared', async () => {
    const body = new Uint8Array(Buffer.from('Geflügelpest', 'utf-8'))
    const response = new Response(body, {
      headers: { 'content-type': 'text/xml' },
    })

    const decoded = await decodeIkissResponse(response)

    expect(decoded).toBe('Geflügelpest')
  })
})
