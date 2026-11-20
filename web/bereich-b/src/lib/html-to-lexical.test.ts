import { describe, it, expect, beforeAll } from 'vitest'
import { editorConfigFactory, type SanitizedServerEditorConfig } from '@payloadcms/richtext-lexical'
import { type SanitizedConfig } from 'payload'
import { htmlToLexical } from './html-to-lexical'

let editorConfig: SanitizedServerEditorConfig

beforeAll(async () => {
  editorConfig = await editorConfigFactory.fromFeatures({
    config: { collections: [] } as unknown as SanitizedConfig,
  })
})

const expectLexicalRoot = (result: unknown) => {
  expect(result).toHaveProperty('root')
  const root = (result as { root: Record<string, unknown> }).root
  expect(root.type).toBe('root')
  expect(root).toHaveProperty('children')
  expect(root).toHaveProperty('direction')
  expect(root).toHaveProperty('format')
  expect(root).toHaveProperty('indent')
  expect(root).toHaveProperty('version')
  return root
}

describe('htmlToLexical', () => {
  describe('simple HTML (nolis / veranstaltungen)', () => {
    it('converts a paragraph', () => {
      const result = htmlToLexical('<p>Einfacher Absatz</p>', editorConfig)
      const root = expectLexicalRoot(result)
      const children = root.children as { type: string }[]
      expect(children.length).toBeGreaterThan(0)
      expect(children[0].type).toBe('paragraph')
    })

    it('converts multiple paragraphs', () => {
      const result = htmlToLexical('<p>Erster</p><p>Zweiter</p>', editorConfig)
      const root = expectLexicalRoot(result)
      expect((root.children as unknown[]).length).toBe(2)
    })

    it('converts heading + paragraph', () => {
      const result = htmlToLexical('<h2>Titel</h2><p>Inhalt</p>', editorConfig)
      const root = expectLexicalRoot(result)
      const children = root.children as { type: string; tag?: string }[]
      expect(children[0].type).toBe('heading')
      expect(children[0].tag).toBe('h2')
      expect(children[1].type).toBe('paragraph')
    })

    it('preserves bold and italic', () => {
      const result = htmlToLexical('<p><strong>Fett</strong> und <em>kursiv</em></p>', editorConfig)
      const root = expectLexicalRoot(result)
      const paragraph = (root.children as { children: { text: string; format: number }[] }[])[0]
      expect(paragraph.children.some((n) => n.text === 'Fett' && (n.format & 1) !== 0)).toBe(true)
      expect(paragraph.children.some((n) => n.text === 'kursiv' && (n.format & 2) !== 0)).toBe(true)
    })

    it('handles a realistic nolis article', () => {
      const html = `
        <p>Die Kreisverwaltung teilt mit:</p>
        <p>Am <strong>Montag, 15. März 2026</strong> findet eine
        Informationsveranstaltung zum Thema <em>Klimaschutz</em> statt.</p>
        <p>Beginn 18:00 Uhr. Eintritt frei.</p>
      `
      const result = htmlToLexical(html, editorConfig)
      const root = expectLexicalRoot(result)
      expect((root.children as unknown[]).length).toBe(3)
    })
  })

  describe('HTML with links (rss)', () => {
    it('converts a link inside a paragraph', () => {
      const result = htmlToLexical(
        '<p>Mehr unter <a href="https://example.com">example.com</a></p>',
        editorConfig,
      )
      const root = expectLexicalRoot(result)
      const paragraph = (root.children as { children: unknown[] }[])[0]
      const linkNode = paragraph.children.find(
        (n: any) => n.type === 'link' || n.type === 'autolink',
      )
      expect(linkNode).toBeDefined()
    })

    it('handles a realistic rss article', () => {
      const html = `
        <h2>Straßensperrung B1</h2>
        <p>Die B1 wird zwischen <a href="https://hameln.de/verkehr">Hameln</a>
        und Bad Pyrmont gesperrt.</p>
        <p>Umleitung über L434. <a href="https://hameln.de/karte" target="_blank">Karte</a></p>
      `
      const result = htmlToLexical(html, editorConfig)
      const root = expectLexicalRoot(result)
      const children = root.children as { type: string }[]
      expect(children[0].type).toBe('heading')
      expect(children.length).toBe(3)
    })
  })

  describe('HTML with images (ikiss)', () => {
    it('converts HTML with images (images become non-upload nodes without data attrs)', () => {
      const html = `
        <p>Beschreibung</p>
        <img src="https://example.com/foto.jpg" alt="Foto" />
        <p>Weitere Details</p>
      `
      const result = htmlToLexical(html, editorConfig)
      const root = expectLexicalRoot(result)
      const children = root.children as { type: string }[]
      // Paragraphs are preserved; image may be kept or omitted depending on converter
      expect(children.filter((c) => c.type === 'paragraph').length).toBe(2)
    })

    it('handles complex ikiss-style HTML', () => {
      const html = `
        <p>Die Stadt informiert:</p>
        <p><a href="/aktuelles/123" target="_blank">Mehr erfahren</a></p>
        <h3>Hintergrund</h3>
        <p>Lorem ipsum dolor sit amet.</p>
      `
      const result = htmlToLexical(html, editorConfig)
      const root = expectLexicalRoot(result)
      const children = root.children as { type: string }[]
      expect(children.length).toBeGreaterThanOrEqual(4)
      expect(children.some((c) => c.type === 'heading')).toBe(true)
    })
  })

  describe('edge cases', () => {
    it('handles empty string', () => {
      const result = htmlToLexical('', editorConfig)
      expectLexicalRoot(result)
    })

    it('handles whitespace-only', () => {
      const result = htmlToLexical('   ', editorConfig)
      expectLexicalRoot(result)
    })

    it('handles plain text without tags', () => {
      const result = htmlToLexical('Nur Text ohne Tags', editorConfig)
      const root = expectLexicalRoot(result)
      expect((root.children as unknown[]).length).toBeGreaterThan(0)
    })

    it('handles unordered list', () => {
      const result = htmlToLexical('<ul><li>Eins</li><li>Zwei</li></ul>', editorConfig)
      const root = expectLexicalRoot(result)
      const children = root.children as { type: string }[]
      expect(children[0].type).toBe('list')
    })
  })
})
