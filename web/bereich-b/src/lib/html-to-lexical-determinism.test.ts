import { describe, it, expect, beforeAll } from 'vitest'
import { editorConfigFactory, type SanitizedServerEditorConfig } from '@payloadcms/richtext-lexical'
import { type SanitizedConfig } from 'payload'
import { htmlToLexical } from './html-to-lexical'
import { hasDocChanges } from '../dataseeder/upsert'

let editorConfig: SanitizedServerEditorConfig

beforeAll(async () => {
  editorConfig = await editorConfigFactory.fromFeatures({
    config: { collections: [] } as unknown as SanitizedConfig,
  })
})

/**
 * If htmlToLexical produces different output for the same HTML input,
 * hasDocChanges will always return true and every article will be
 * "updated" on every import run — even when nothing changed.
 */
describe('htmlToLexical determinism', () => {
  const htmlSamples = [
    '<p>Einfacher Absatz</p>',
    '<p>Erster</p><p>Zweiter</p>',
    '<h2>Titel</h2><p>Inhalt</p>',
    '<p><strong>Fett</strong> und <em>kursiv</em></p>',
    '<p>Mehr unter <a href="https://example.com">example.com</a></p>',
    '<ul><li>Eins</li><li>Zwei</li></ul>',
    // Realistic RSS article content
    '<p>Die Kreisverwaltung teilt mit:</p><p>Am <strong>Montag, 15. März 2026</strong> findet eine Informationsveranstaltung statt.</p>',
  ]

  for (const html of htmlSamples) {
    it(`produces identical output for: ${html.slice(0, 60)}...`, () => {
      const run1 = htmlToLexical(html, editorConfig)
      const run2 = htmlToLexical(html, editorConfig)
      // Link nodes get a random id from Lexical — normalize() strips ids so hasDocChanges handles this
      if (html.includes('<a ')) {
        expect(JSON.stringify(run1)).not.toBe(JSON.stringify(run2))
      } else {
        expect(JSON.stringify(run1)).toBe(JSON.stringify(run2))
      }
    })
  }

  it('hasDocChanges returns false when comparing two identical htmlToLexical outputs as inhalte', () => {
    const html = '<p>Test content</p><p>With <strong>formatting</strong></p>'
    const content1 = htmlToLexical(html, editorConfig)
    const content2 = htmlToLexical(html, editorConfig)

    const incoming = {
      titel: 'Test',
      inhalte: [{ blockType: 'rich-text', content: content1 }],
    }
    const stored = {
      titel: 'Test',
      inhalte: [{ blockType: 'rich-text', content: content2, id: 'block-id-123' }],
      createdAt: '2025-01-01T00:00:00.000Z',
      updatedAt: '2025-01-01T00:00:00.000Z',
    }

    expect(hasDocChanges(incoming, stored)).toBe(false)
  })

  it('hasDocChanges returns false when stored content came from a prior identical import', () => {
    // Simulate: import runs once, saves to DB, then runs again with same HTML
    const html = '<p>Die Stadt informiert über Neuigkeiten.</p>'
    const firstImport = htmlToLexical(html, editorConfig)
    // Simulate what Payload stores and returns with depth:0
    const storedDoc = {
      id: 'abc123',
      titel: 'Neuigkeiten',
      importId: 'test-import-1',
      kommune: 'kommune-1',
      inhalte: [{ blockType: 'rich-text', content: firstImport, id: 'generated-block-id' }],
      createdAt: '2025-01-01T00:00:00.000Z',
      updatedAt: '2025-01-01T00:00:00.000Z',
    }

    // Second import — same HTML
    const secondImport = htmlToLexical(html, editorConfig)
    const incoming = {
      titel: 'Neuigkeiten',
      importId: 'test-import-1',
      kommune: 'kommune-1',
      inhalte: [{ blockType: 'rich-text', content: secondImport }],
    }

    expect(hasDocChanges(incoming, storedDoc)).toBe(false)
  })

  it('hasDocChanges returns false for HTML with links (random id stripped by normalize)', () => {
    const html = '<p>Mehr unter <a href="https://example.com">example.com</a></p>'
    const run1 = htmlToLexical(html, editorConfig)
    const run2 = htmlToLexical(html, editorConfig)

    // Raw JSON differs (non-deterministic link id)
    expect(JSON.stringify(run1)).not.toBe(JSON.stringify(run2))

    // But hasDocChanges should normalize away the id
    const incoming = { inhalte: [{ blockType: 'rich-text', content: run1 }] }
    const stored = { inhalte: [{ blockType: 'rich-text', content: run2, id: 'block-1' }] }
    expect(hasDocChanges(incoming, stored)).toBe(false)
  })

  it('hasDocChanges returns false for full article with links between import runs', () => {
    const html =
      '<p>Info: <a href="https://hameln.de/verkehr">Hameln</a> und <a href="https://pyrmont.de">Pyrmont</a></p>' +
      '<p><strong>Weitere Infos:</strong> <a href="https://example.com" target="_blank">Hier klicken</a></p>'
    const run1 = htmlToLexical(html, editorConfig)
    const run2 = htmlToLexical(html, editorConfig)

    const incoming = {
      titel: 'Verkehrsmeldung',
      importId: 'rss-123',
      kommune: 'kommune-1',
      untereinheit: 'ue-1',
      _status: 'published',
      teaser: 'Info',
      datum: '2025-05-19T02:00:00.000Z',
      inhalte: [{ blockType: 'rich-text', content: run1 }],
      titelbilder: [{ bild: 'img-1', id: 'img-1' }],
      ordinal: 0,
      integration: 'int-1',
    }
    const stored = {
      id: 'doc-abc',
      titel: 'Verkehrsmeldung',
      importId: 'rss-123',
      kommune: 'kommune-1',
      untereinheit: 'ue-1',
      _status: 'published',
      teaser: 'Info',
      datum: '2025-05-19T02:00:00.000Z',
      inhalte: [{ blockType: 'rich-text', content: run2, id: 'block-xyz' }],
      titelbilder: [{ bild: 'img-1', id: 'img-1' }],
      ordinal: 0,
      integration: 'int-1',
      createdAt: '2025-01-01T00:00:00.000Z',
      updatedAt: '2025-05-19T02:00:00.000Z',
      notified: false,
      visible: true,
    }

    expect(hasDocChanges(incoming, stored)).toBe(false)
  })
})
