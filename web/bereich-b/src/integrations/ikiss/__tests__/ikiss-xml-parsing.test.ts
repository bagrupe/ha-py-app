import { XMLParser } from 'fast-xml-parser'
import { describe, expect, test } from 'vitest'
import { stripCdata } from '../ikiss-xml'
import {
  articleWithBoldXml,
  articleWithItalicCdataXml,
  articleWithItalicXml,
  articleWithLinkXml,
  emptyContentXml,
  mixedArticleCdataXml,
  mixedArticleXml,
  plainTextArticleXml,
} from './testdata'

/**
 * The XMLParser config must match what ikiss-xml.ts uses.
 * We reconstruct it here rather than importing the module-level instance,
 * because importing ikiss-xml.ts would pull in Payload runtime deps.
 */
const parser = new XMLParser({
  stopNodes: ['*.data_content'],
})

function parseDataContent(xml: string): unknown {
  const result = parser.parse(xml)
  return result.ikiss.result.tcontent.data_content
}

describe('iKISS XML parsing with stopNodes', () => {
  test('plain text article: data_content is a string', () => {
    const dc = parseDataContent(plainTextArticleXml)
    expect(typeof dc).toBe('string')
    expect(dc).toContain('Niedersächsische Landesbehörde')
    expect(dc).toContain('</p>')
  })

  test('article with <em>: data_content preserves italic tags as string', () => {
    const dc = parseDataContent(articleWithItalicXml)
    expect(typeof dc).toBe('string')
    expect(dc).toContain('<em>')
    expect(dc).toContain('</em>')
    expect(dc).toContain('Verdienstorden')
  })

  test('article with <strong>: data_content preserves bold tags as string', () => {
    const dc = parseDataContent(articleWithBoldXml)
    expect(typeof dc).toBe('string')
    expect(dc).toContain('<strong>')
    expect(dc).toContain('</strong>')
  })

  test('article with <a>: data_content preserves link tags as string', () => {
    const dc = parseDataContent(articleWithLinkXml)
    expect(typeof dc).toBe('string')
    expect(dc).toContain('<a ')
    expect(dc).toContain('target="_blank"')
  })

  test('mixed article: data_content preserves all HTML tags as string', () => {
    const dc = parseDataContent(mixedArticleXml)
    expect(typeof dc).toBe('string')
    expect(dc).toContain('<em>')
    expect(dc).toContain('<strong>')
    expect(dc).toContain('<ul>')
    expect(dc).toContain('<li>')
    expect(dc).toContain('<a ')
  })

  test('empty data_content returns empty string', () => {
    const dc = parseDataContent(emptyContentXml)
    expect(dc).toBe('')
  })

  test('other XML fields are still parsed normally', () => {
    const result = parser.parse(mixedArticleXml)
    const tcontent = result.ikiss.result.tcontent
    expect(tcontent.date).toBe('2026-02-19')
    expect(tcontent.release).toBe(true)
    expect(tcontent.tTpFields.title).toBe('Tag des Gesundheitsamtes 2026')
  })
})

describe('CDATA handling', () => {
  test('CDATA-wrapped content is preserved as string by stopNodes', () => {
    const dc = parseDataContent(mixedArticleCdataXml)
    expect(typeof dc).toBe('string')
    expect(dc as string).toContain('<![CDATA[')
  })

  test('stripCdata removes CDATA markers and returns clean HTML', () => {
    const dc = parseDataContent(mixedArticleCdataXml) as string
    const cleaned = stripCdata(dc)
    expect(cleaned).not.toContain('<![CDATA[')
    expect(cleaned).not.toContain(']]>')
    expect(cleaned).toContain('<em>')
    expect(cleaned).toContain('<strong>')
  })

  test('stripCdata is a no-op for content without CDATA', () => {
    const dc = parseDataContent(articleWithItalicXml) as string
    expect(stripCdata(dc)).toBe(dc)
  })

  test('stripCdata handles empty string', () => {
    expect(stripCdata('')).toBe('')
  })
})

describe('default XMLParser breaks on inline HTML tags', () => {
  const defaultParser = new XMLParser()

  test('default parser turns data_content with <em> into an object', () => {
    const result = defaultParser.parse(articleWithItalicXml)
    const dc = result.ikiss.result.tcontent.data_content
    expect(typeof dc).not.toBe('string')
  })

  test('default parser turns mixed HTML data_content into an object', () => {
    const result = defaultParser.parse(mixedArticleXml)
    const dc = result.ikiss.result.tcontent.data_content
    expect(typeof dc).not.toBe('string')
  })

  test('default parser turns data_content with <a> link into an object', () => {
    const result = defaultParser.parse(articleWithLinkXml)
    const dc = result.ikiss.result.tcontent.data_content
    expect(typeof dc).not.toBe('string')
  })

  test('default parser turns data_content with CDATA <em> into a string', () => {
    const result = defaultParser.parse(articleWithItalicCdataXml)
    const dc = result.ikiss.result.tcontent.data_content
    // CDATA wrapping makes the default parser return a string — this is why some articles work
    expect(typeof dc).toBe('string')
  })
})
