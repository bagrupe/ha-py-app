import { describe, expect, it } from 'vitest'
import { lexicalToHtml } from './lexical-to-html'

const lexicalParagraph = (text: string) => ({
  root: {
    type: 'root',
    direction: 'ltr',
    format: '',
    indent: 0,
    version: 1,
    children: [
      {
        type: 'paragraph',
        direction: 'ltr',
        format: '',
        indent: 0,
        version: 1,
        children: [
          { type: 'text', detail: 0, format: 0, mode: 'normal', style: '', text, version: 1 },
        ],
      },
    ],
  },
})

describe('lexicalToHtml', () => {
  it('converts a lexical paragraph to HTML', () => {
    const html = lexicalToHtml(lexicalParagraph('Hallo Welt'))
    expect(html).toContain('Hallo Welt')
    expect(html).toContain('<p')
  })

  it('returns an empty string for null/undefined', () => {
    expect(lexicalToHtml(null)).toBe('')
    expect(lexicalToHtml(undefined)).toBe('')
  })

  it('returns an empty string for a value that is not a lexical editor state', () => {
    expect(lexicalToHtml({ foo: 'bar' })).toBe('')
    expect(lexicalToHtml('plain string')).toBe('')
  })
})
