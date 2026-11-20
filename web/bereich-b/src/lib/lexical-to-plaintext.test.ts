import { describe, expect, it } from 'vitest'
import { firstRichTextBlockPlaintext, lexicalToPlaintext } from './lexical-to-plaintext'

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

describe('lexicalToPlaintext', () => {
  it('extracts the text from a lexical editor state', () => {
    expect(lexicalToPlaintext(lexicalParagraph('Hallo Welt'))).toBe('Hallo Welt')
  })

  it('returns an empty string for null/undefined', () => {
    expect(lexicalToPlaintext(null)).toBe('')
    expect(lexicalToPlaintext(undefined)).toBe('')
  })

  it('returns an empty string for a value that is not a lexical editor state', () => {
    expect(lexicalToPlaintext({ foo: 'bar' })).toBe('')
    expect(lexicalToPlaintext('plain string')).toBe('')
  })
})

describe('firstRichTextBlockPlaintext', () => {
  it('returns the plaintext of the first rich-text block', () => {
    const blocks = [
      { blockType: 'rich-text', content: lexicalParagraph('Erster') },
      { blockType: 'rich-text', content: lexicalParagraph('Zweiter') },
    ]
    expect(firstRichTextBlockPlaintext(blocks)).toBe('Erster')
  })

  it('skips non rich-text blocks', () => {
    const blocks = [
      { blockType: 'image-veranstaltungsmedien' },
      { blockType: 'rich-text', content: lexicalParagraph('Nach dem Bild') },
    ]
    expect(firstRichTextBlockPlaintext(blocks)).toBe('Nach dem Bild')
  })

  it('returns an empty string when there is no rich-text block', () => {
    expect(firstRichTextBlockPlaintext([{ blockType: 'image-veranstaltungsmedien' }])).toBe('')
    expect(firstRichTextBlockPlaintext([])).toBe('')
    expect(firstRichTextBlockPlaintext(null)).toBe('')
    expect(firstRichTextBlockPlaintext(undefined)).toBe('')
  })
})
