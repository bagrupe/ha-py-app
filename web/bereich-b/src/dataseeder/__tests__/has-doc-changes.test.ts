import { describe, expect, it } from 'vitest'
import { hasDocChanges } from '../upsert'

// Real fixture dumped from payload.find({ depth: 0 }) at runtime
const stored = {
  id: '682c8888f77eb6dd93f35212',
  importId:
    'http://rssfeed.app.zr-wbl.de/lk-app-rss-feed/aerzen_news.xml/3f6f3b6bc0bd4211bbc1d6b49996373e',
  titel: 'Kultur Programmheft',
  teaser: '',
  titelbild: '682c8f91f77eb6dd93f3b0f8',
  datum: '2025-05-19T02:00:00.000Z',
  ordinal: 0,
  inhalte: [
    {
      content: [
        {
          type: 'p',
          children: [
            {
              text: 'Das Kultur Programmheft 2025 erhalten Sie ab sofort als umweltfreundliche Print-Ausgabe am Empfang der Gemeindeverwaltung.',
            },
          ],
        },
        {
          type: 'p',
          children: [
            { text: 'Zum Originalbeitrag: ' },
            {
              type: 'link',
              newTab: false,
              url: 'https://www.aerzen.de/index.php/aktuelles',
              children: [{ text: 'Hier klicken!' }],
            },
          ],
        },
      ],
      id: '69c38340a0f6092150dcb93f',
      blockType: 'rich-text',
    },
  ],
  untereinheit: '00e48df6-0d0f-48d2-9e8d-67fae50d4d26',
  kommune: '65ae4370f399a4b34dcd359c',
  integration: '682c87c6f77eb6dd93f3505b',
  notified: false,
  _status: 'published',
  createdAt: '2025-05-20T13:50:00.607Z',
  updatedAt: '2026-03-25T06:40:00.974Z',
  titelbilder: [{ bild: '682c8f91f77eb6dd93f3b0f8', id: '682c8f91f77eb6dd93f3b0f8' }],
  visible: true,
}

// Real incoming data as passed by the RSS importer (datum now normalized to ISO)
const incoming = {
  titel: 'Kultur Programmheft',
  importId:
    'http://rssfeed.app.zr-wbl.de/lk-app-rss-feed/aerzen_news.xml/3f6f3b6bc0bd4211bbc1d6b49996373e',
  kommune: '65ae4370f399a4b34dcd359c',
  untereinheit: '00e48df6-0d0f-48d2-9e8d-67fae50d4d26',
  _status: 'published',
  titelbilder: [{ bild: '682c8f91f77eb6dd93f3b0f8', id: '682c8f91f77eb6dd93f3b0f8' }],
  teaser: '',
  datum: '2025-05-19T02:00:00.000Z',
  inhalte: [
    {
      blockType: 'rich-text',
      content: [
        {
          type: 'p',
          children: [
            {
              text: 'Das Kultur Programmheft 2025 erhalten Sie ab sofort als umweltfreundliche Print-Ausgabe am Empfang der Gemeindeverwaltung.',
            },
          ],
        },
        {
          type: 'p',
          children: [
            { text: 'Zum Originalbeitrag: ' },
            {
              type: 'link',
              newTab: false,
              url: 'https://www.aerzen.de/index.php/aktuelles',
              children: [{ text: 'Hier klicken!' }],
            },
          ],
        },
      ],
    },
  ],
  ordinal: 0,
  integration: '682c87c6f77eb6dd93f3505b',
}

describe('hasDocChanges (real fixture)', () => {
  it('returns false for identical import — full document', () => {
    expect(hasDocChanges(incoming, stored)).toBe(false)
  })

  it('ignores fields only on stored doc', () => {
    expect(hasDocChanges({ titel: 'Kultur Programmheft' }, stored)).toBe(false)
  })

  describe('tier 1 — scalar fields', () => {
    it('detects titel change', () => {
      expect(hasDocChanges({ ...incoming, titel: 'Neuer Titel' }, stored)).toBe(true)
    })

    it('detects ordinal change', () => {
      expect(hasDocChanges({ ...incoming, ordinal: 5 }, stored)).toBe(true)
    })

    it('detects _status change', () => {
      expect(hasDocChanges({ ...incoming, _status: 'draft' }, stored)).toBe(true)
    })

    it('detects integration change', () => {
      expect(hasDocChanges({ ...incoming, integration: 'different-id' }, stored)).toBe(true)
    })
  })

  describe('datum — normalized to ISO at import time', () => {
    it('returns false for identical ISO strings', () => {
      expect(
        hasDocChanges({ datum: '2025-05-19T02:00:00.000Z' }, { datum: '2025-05-19T02:00:00.000Z' }),
      ).toBe(false)
    })

    it('returns true for different ISO dates', () => {
      expect(
        hasDocChanges({ datum: '2025-05-20T02:00:00.000Z' }, { datum: '2025-05-19T02:00:00.000Z' }),
      ).toBe(true)
    })

    it('returns true when non-ISO format slips through (not normalized)', () => {
      expect(
        hasDocChanges(
          { datum: 'Mon, 19 May 2025 04:00:00 +0200' },
          { datum: '2025-05-19T02:00:00.000Z' },
        ),
      ).toBe(true)
    })

    it('returns false when existing is a Date object and incoming is matching ISO string', () => {
      expect(
        hasDocChanges(
          { datum: '2025-05-19T02:00:00.000Z' },
          { datum: new Date('2025-05-19T02:00:00.000Z') },
        ),
      ).toBe(false)
    })

    it('returns true when existing is a Date object and incoming is different ISO string', () => {
      expect(
        hasDocChanges(
          { datum: '2025-05-20T02:00:00.000Z' },
          { datum: new Date('2025-05-19T02:00:00.000Z') },
        ),
      ).toBe(true)
    })

    it('returns false when both are Date objects with same value', () => {
      expect(
        hasDocChanges(
          { datum: new Date('2025-05-19T02:00:00.000Z') },
          { datum: new Date('2025-05-19T02:00:00.000Z') },
        ),
      ).toBe(false)
    })
  })

  describe('tier 2 — complex fields (inhalte, titelbilder)', () => {
    it('returns false when content matches but stored has block id', () => {
      expect(hasDocChanges({ inhalte: incoming.inhalte }, stored)).toBe(false)
    })

    it('returns true when block content differs', () => {
      expect(
        hasDocChanges(
          {
            inhalte: [
              {
                blockType: 'rich-text',
                content: [{ type: 'p', children: [{ text: 'Changed' }] }],
              },
            ],
          },
          stored,
        ),
      ).toBe(true)
    })

    it('detects titelbilder change', () => {
      expect(
        hasDocChanges({ ...incoming, titelbilder: [{ bild: 'new-img', id: 'new-img' }] }, stored),
      ).toBe(true)
    })

    it('returns false for identical titelbilder with block ids', () => {
      expect(
        hasDocChanges(
          { titelbilder: [{ bild: '682c8f91f77eb6dd93f3b0f8' }] },
          { titelbilder: [{ bild: '682c8f91f77eb6dd93f3b0f8', id: 'abc123' }] },
        ),
      ).toBe(false)
    })
  })

  describe('edge cases', () => {
    it('returns false for empty incoming', () => {
      expect(hasDocChanges({}, stored)).toBe(false)
    })

    it('handles null values on both sides', () => {
      expect(hasDocChanges({ field: null }, { field: null })).toBe(false)
    })

    it('detects null vs non-null', () => {
      expect(hasDocChanges({ field: null }, { field: 'value' })).toBe(true)
    })

    it('detects boolean change', () => {
      expect(hasDocChanges({ visible: true }, { visible: false })).toBe(true)
    })
  })
})
