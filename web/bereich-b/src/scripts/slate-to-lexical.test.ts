import { beforeEach, describe, expect, it, vi } from 'vitest'
const convertSlateToLexicalMock = vi.hoisted(() => vi.fn())

vi.mock('@payloadcms/richtext-lexical/migrate', async (importOriginal) => {
  const actual = await importOriginal<typeof import('@payloadcms/richtext-lexical/migrate')>()
  convertSlateToLexicalMock.mockImplementation(actual.convertSlateToLexical)

  return {
    ...actual,
    convertSlateToLexical: convertSlateToLexicalMock,
  }
})

import {
  convertContent,
  EMPTY_LEXICAL_ROOT,
  getNestedValue,
  isSlateArray,
  migrateCollection,
  migrateTargets,
} from './slate-to-lexical'

// ── Helpers ──────────────────────────────────────────────────────────────────

const slateP = (text: string) => ({ children: [{ text }] })
const slateBold = (text: string) => ({ children: [{ text, bold: true }] })
const slateItalic = (text: string) => ({ children: [{ text, italic: true }] })
const slateLink = (text: string, url: string) => ({
  type: 'link',
  url,
  children: [{ text }],
})
const slateList = (items: string[]) => ({
  type: 'ul',
  children: items.map((t) => ({ type: 'li', children: [{ children: [{ text: t }] }] })),
})

const lexicalRoot = (obj: unknown) => typeof obj === 'object' && obj !== null && 'root' in obj

const richTextBlock = (content: unknown) => ({
  blockType: 'rich-text',
  content,
  id: 'block-1',
})

const imageBlock = () => ({
  blockType: 'image',
  image: 'img-1',
  id: 'block-2',
})

const setNestedValue = (obj: Record<string, unknown>, dottedPath: string, value: unknown) => {
  const path = dottedPath.split('.')
  let current: Record<string, unknown> = obj

  for (const key of path.slice(0, -1)) {
    const next = current[key]
    if (!next || typeof next !== 'object') {
      current[key] = {}
    }
    current = current[key] as Record<string, unknown>
  }

  current[path[path.length - 1]] = value
}

// ── Mock MongoDB collection ──────────────────────────────────────────────────

function mockCollection(docs: Record<string, unknown>[]) {
  const stored = [...docs]
  const bulkWriteOps: unknown[] = []
  const bulkWriteOptions: unknown[] = []
  const findOptions: unknown[] = []
  const findQueries: Record<string, unknown>[] = []

  const matchesQuery = (doc: Record<string, unknown>, query: Record<string, unknown>) => {
    const idQuery = query._id as { $gt?: unknown } | undefined
    if (idQuery?.$gt !== undefined && String(doc._id) <= String(idQuery.$gt)) return false

    return Object.entries(query)
      .filter(([key]) => key !== '_id')
      .every(([key, condition]) => {
        const value = getNestedValue(doc, key.split('.'))
        const expected = condition as { $exists?: boolean; $ne?: unknown }
        if (expected.$exists === true && value === undefined) return false
        if ('$ne' in expected && value === expected.$ne) return false
        return true
      })
  }

  return {
    collection: {
      find: (query: Record<string, unknown>, options?: unknown) => {
        findQueries.push(query)
        findOptions.push(options)
        return {
          sort: () => ({
            limit: (limit: number) => ({
              toArray: async () => stored.filter((doc) => matchesQuery(doc, query)).slice(0, limit),
            }),
          }),
        }
      },
      bulkWrite: async (ops: unknown[], options?: unknown) => {
        bulkWriteOps.push(...ops)
        bulkWriteOptions.push(options)
        for (const op of ops as any[]) {
          if (op.updateOne) {
            const doc = stored.find((d) => d._id === op.updateOne.filter._id)
            if (doc && op.updateOne.update.$set) {
              for (const [key, val] of Object.entries(op.updateOne.update.$set)) {
                setNestedValue(doc, key, val)
              }
            }
          }
        }
      },
    },
    stored,
    bulkWriteOps,
    bulkWriteOptions,
    findOptions,
    findQueries,
  }
}

const mockLogger = () => ({
  info: vi.fn(),
  warn: vi.fn(),
})

beforeEach(() => {
  vi.clearAllMocks()
})

// ═════════════════════════════════════════════════════════════════════════════
// isSlateArray — format detection
// ═════════════════════════════════════════════════════════════════════════════

describe('isSlateArray', () => {
  it('1. detects valid Slate array', () => {
    expect(isSlateArray([slateP('hello')])).toBe(true)
  })

  it('2. rejects empty array', () => {
    expect(isSlateArray([])).toBe(false)
  })

  it('3. rejects Lexical object with root key', () => {
    expect(isSlateArray(EMPTY_LEXICAL_ROOT)).toBe(false)
  })

  it('4. rejects null and undefined', () => {
    expect(isSlateArray(null)).toBe(false)
    expect(isSlateArray(undefined)).toBe(false)
  })

  it('5. rejects array of primitives', () => {
    expect(isSlateArray(['a', 'b'])).toBe(false)
  })

  it('6. rejects array of objects without children', () => {
    expect(isSlateArray([{ text: 'hello' }])).toBe(false)
  })

  it('7. rejects arrays with mixed valid and invalid Slate nodes', () => {
    expect(isSlateArray([{ children: [{ text: 'hello' }] }, { INVALID: true }])).toBe(false)
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// convertContent — routing logic
// ═════════════════════════════════════════════════════════════════════════════

describe('convertContent', () => {
  it('8. converts Slate array to Lexical', () => {
    const result = convertContent([slateP('hello')])
    expect(result.status).toBe('migrated')
    expect(lexicalRoot(result.converted)).toBe(true)
  })

  it('9. converts empty array to EMPTY_LEXICAL_ROOT', () => {
    const result = convertContent([])
    expect(result.status).toBe('empty')
    expect(result.converted).toEqual(EMPTY_LEXICAL_ROOT)
  })

  it('10. skips already-Lexical content', () => {
    const result = convertContent(EMPTY_LEXICAL_ROOT)
    expect(result.status).toBe('skipped')
    expect(result.converted).toEqual(EMPTY_LEXICAL_ROOT)
  })

  it('11. skips null', () => {
    const result = convertContent(null)
    expect(result.status).toBe('skipped')
    expect(result.converted).toBeNull()
  })

  it('12. rejects malformed rich text values', () => {
    expect(() => convertContent({ unexpected: true })).toThrow(
      'Expected Slate richText JSON, Lexical richText JSON, or an empty value',
    )
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// getNestedValue — path traversal
// ═════════════════════════════════════════════════════════════════════════════

describe('getNestedValue', () => {
  it('13. traverses deep path', () => {
    const obj = { a: { b: { c: 'val' } } }
    expect(getNestedValue(obj, ['a', 'b', 'c'])).toBe('val')
  })

  it('14. returns undefined for missing key', () => {
    const obj = { a: { b: 1 } }
    expect(getNestedValue(obj, ['a', 'x', 'c'])).toBeUndefined()
  })

  it('15. returns undefined when null at intermediate level', () => {
    const obj = { a: null }
    expect(getNestedValue(obj as any, ['a', 'b'])).toBeUndefined()
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// migrateCollection — block type
// ═════════════════════════════════════════════════════════════════════════════

describe('migrateCollection (block type)', () => {
  it('16. migrates doc with Slate rich-text block', async () => {
    const { collection } = mockCollection([
      { _id: '1', inhalte: [richTextBlock([slateP('hello')])] },
    ])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'inhalte',
      'block',
    )
    expect(result.migrated).toBe(1)
    expect(result.skipped).toBe(0)
  })

  it('17. skips doc with already-Lexical rich-text block', async () => {
    const { collection } = mockCollection([
      { _id: '1', inhalte: [richTextBlock(EMPTY_LEXICAL_ROOT)] },
    ])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'inhalte',
      'block',
    )
    expect(result.migrated).toBe(0)
    expect(result.skipped).toBe(1)
  })

  it('18. leaves image blocks untouched', async () => {
    const img = imageBlock()
    const { collection, stored } = mockCollection([{ _id: '1', inhalte: [img] }])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'inhalte',
      'block',
    )
    expect(result.migrated).toBe(0)
    expect(stored[0].inhalte).toEqual([img])
  })

  it('19. converts only Slate blocks in mixed array', async () => {
    const { collection } = mockCollection([
      {
        _id: '1',
        inhalte: [
          richTextBlock([slateP('convert me')]),
          imageBlock(),
          richTextBlock(EMPTY_LEXICAL_ROOT),
        ],
      },
    ])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'inhalte',
      'block',
    )
    expect(result.migrated).toBe(1)
    expect(result.skipped).toBe(1)
  })

  it('20. converts empty content in block to EMPTY_LEXICAL_ROOT', async () => {
    const { collection, stored } = mockCollection([{ _id: '1', inhalte: [richTextBlock([])] }])
    await migrateCollection(mockLogger(), collection as any, 'test', 'inhalte', 'block')
    const updatedBlock = (stored[0].inhalte as any[])[0]
    expect(updatedBlock.content).toEqual(EMPTY_LEXICAL_ROOT)
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// migrateCollection — inline type
// ═════════════════════════════════════════════════════════════════════════════

describe('migrateCollection (inline type)', () => {
  it('21. migrates Slate value at dotted path and persists it at the nested location', async () => {
    const { collection, stored, bulkWriteOps, findQueries } = mockCollection([
      { _id: '1', lizenzen: { kartenlizenzen: [slateP('license')] } },
    ])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'lizenzen.kartenlizenzen',
      'inline',
    )
    expect(result.migrated).toBe(1)
    expect(findQueries[0]).toEqual({
      'lizenzen.kartenlizenzen': { $exists: true, $ne: null },
    })
    expect(bulkWriteOps).toHaveLength(1)
    expect(stored[0].lizenzen).toEqual({
      kartenlizenzen: expect.objectContaining({
        root: expect.objectContaining({
          type: 'root',
        }),
      }),
    })
  })

  it('22. skips Lexical value at dotted path', async () => {
    const { collection } = mockCollection([
      { _id: '1', lizenzen: { kartenlizenzen: EMPTY_LEXICAL_ROOT } },
    ])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'lizenzen.kartenlizenzen',
      'inline',
    )
    expect(result.skipped).toBe(1)
    expect(result.migrated).toBe(0)
  })

  it('23. skips doc where dotted path does not exist without issuing writes', async () => {
    const { collection, bulkWriteOps } = mockCollection([{ _id: '1', lizenzen: {} }])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'lizenzen.kartenlizenzen',
      'inline',
    )
    expect(result.migrated).toBe(0)
    expect(result.skipped).toBe(0)
    expect(bulkWriteOps).toEqual([])
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// Idempotency
// ═════════════════════════════════════════════════════════════════════════════

describe('idempotency', () => {
  it('24. second run on already-migrated data produces 0 migrations', async () => {
    const docs = [
      { _id: '1', inhalte: [richTextBlock([slateP('hello')])] },
      { _id: '2', inhalte: [richTextBlock([slateP('world')])] },
    ]
    const { collection } = mockCollection(docs)
    const logger = mockLogger()

    // First run
    const first = await migrateCollection(logger, collection as any, 'test', 'inhalte', 'block')
    expect(first.migrated).toBe(2)

    // Second run on same (now mutated) data
    const second = await migrateCollection(logger, collection as any, 'test', 'inhalte', 'block')
    expect(second.migrated).toBe(0)
    expect(second.skipped).toBe(2)
  })

  it('25. running twice produces identical output', async () => {
    const makeDocs = () => [{ _id: '1', inhalte: [richTextBlock([slateP('test')])] }]
    const mock1 = mockCollection(makeDocs())
    const mock2 = mockCollection(makeDocs())
    const logger = mockLogger()

    await migrateCollection(logger, mock1.collection as any, 'test', 'inhalte', 'block')
    await migrateCollection(logger, mock2.collection as any, 'test', 'inhalte', 'block')

    expect(mock1.stored).toEqual(mock2.stored)
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// Error handling
// ═════════════════════════════════════════════════════════════════════════════

describe('error handling', () => {
  it('26. warns about conversion errors and leaves the original block untouched', async () => {
    const original = richTextBlock([slateP('ok')])
    const logger = mockLogger()
    const { collection, stored, bulkWriteOps } = mockCollection([
      { _id: '1', inhalte: [{ ...original }] },
    ])

    convertSlateToLexicalMock.mockImplementationOnce(() => {
      throw new Error('malformed slate')
    })

    const result = await migrateCollection(logger, collection as any, 'test', 'inhalte', 'block')

    expect(result).toEqual({ total: 1, migrated: 0, skipped: 1, warnings: 1 })
    expect(logger.warn).toHaveBeenCalledWith(
      {
        blockIndex: 0,
        collection: 'test',
        error: 'malformed slate',
        field: 'inhalte',
        id: '1',
        valueType: 'array(length=1)',
      },
      'Slate -> Lexical migration skipped malformed content',
    )
    expect(stored[0].inhalte).toEqual([{ ...original }])
    expect(bulkWriteOps).toEqual([])
  })

  it('27. skips doc with null field value gracefully', async () => {
    const { collection } = mockCollection([{ _id: '1', lizenzen: { kartenlizenzen: null } }])
    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'test',
      'lizenzen.kartenlizenzen',
      'inline',
    )
    expect(result.warnings).toBe(0)
    expect(result.migrated).toBe(0)
  })

  it('28. warns about malformed inline content instead of silently skipping it', async () => {
    const logger = mockLogger()
    const { collection } = mockCollection([{ _id: '1', beschreibung: { unexpected: true } }])

    const result = await migrateCollection(
      logger,
      collection as any,
      'aufrufe',
      'beschreibung',
      'inline',
    )

    expect(result).toEqual({ total: 1, migrated: 0, skipped: 1, warnings: 1 })
    expect(logger.warn).toHaveBeenCalledTimes(1)
  })

  it('29. continues converting valid blocks after preserving a malformed block', async () => {
    const logger = mockLogger()
    const malformed = richTextBlock({ unexpected: true })
    const { collection, stored } = mockCollection([
      { _id: '1', inhalte: [malformed, richTextBlock([slateP('valid')])] },
    ])

    const result = await migrateCollection(logger, collection as any, 'test', 'inhalte', 'block')

    expect(result).toEqual({ total: 1, migrated: 1, skipped: 1, warnings: 1 })
    expect((stored[0].inhalte as any[])[0]).toEqual(malformed)
    expect((stored[0].inhalte as any[])[1].content).toMatchObject({ root: { type: 'root' } })
  })
})

describe('batching and target resolution', () => {
  it('30. processes documents in bounded _id batches', async () => {
    const { collection, findQueries } = mockCollection([
      { _id: '1', beschreibung: [slateP('one')] },
      { _id: '2', beschreibung: [slateP('two')] },
      { _id: '3', beschreibung: [slateP('three')] },
    ])

    const result = await migrateCollection(
      mockLogger(),
      collection as any,
      'aufrufe',
      'beschreibung',
      'inline',
      { batchSize: 2 },
    )

    expect(result.migrated).toBe(3)
    expect(findQueries).toEqual([
      { beschreibung: { $exists: true, $ne: null } },
      { beschreibung: { $exists: true, $ne: null }, _id: { $gt: '2' } },
      { beschreibung: { $exists: true, $ne: null }, _id: { $gt: '3' } },
    ])
  })

  it('31. resolves version models and propagates the migration session', async () => {
    const versionCollection = mockCollection([
      { _id: '1', version: { inhalte: [richTextBlock([slateP('draft')])] } },
    ])
    const logger = mockLogger()
    const session = { id: 'session' }

    await migrateTargets({
      adapter: {
        collections: {},
        versions: { 'news-artikel': { collection: versionCollection.collection } },
      },
      logger,
      session,
      targets: [
        { collectionSlug: 'news-artikel', field: 'inhalte', type: 'block', versions: true },
      ],
    })

    expect(versionCollection.findQueries[0]).toEqual({
      'version.inhalte': { $exists: true, $ne: null },
    })
    expect(versionCollection.findOptions[0]).toEqual({ session })
    expect(versionCollection.bulkWriteOptions[0]).toEqual({ session })
  })

  it('32. keeps persistence failures fatal', async () => {
    const { collection } = mockCollection([{ _id: '1', beschreibung: [slateP('valid')] }])
    collection.bulkWrite = vi.fn().mockRejectedValue(new Error('database unavailable'))

    await expect(
      migrateCollection(mockLogger(), collection as any, 'aufrufe', 'beschreibung', 'inline'),
    ).rejects.toThrow('database unavailable')
  })
})

// ═════════════════════════════════════════════════════════════════════════════
// Content fidelity
// ═════════════════════════════════════════════════════════════════════════════

describe('content fidelity', () => {
  it('33. preserves link nodes and their URL metadata', () => {
    const slate = [
      {
        children: [
          { text: 'Visit ' },
          slateLink('our site', 'https://example.com'),
          { text: ' today' },
        ],
      },
    ]
    const result = convertContent(slate)
    expect(result.status).toBe('migrated')
    expect(result.converted).toMatchObject({
      root: {
        children: [
          {
            type: 'paragraph',
            children: [
              { text: 'Visit ' },
              {
                type: 'link',
                fields: {
                  url: 'https://example.com',
                  linkType: 'custom',
                },
                children: [{ text: 'our site' }],
              },
              { text: ' today' },
            ],
          },
        ],
      },
    })
  })

  it('34. preserves bold and italic formatting flags', () => {
    const slate = [
      {
        children: [
          { text: 'normal ' },
          { text: 'bold', bold: true },
          { text: ' ' },
          { text: 'italic', italic: true },
        ],
      },
    ]
    const result = convertContent(slate)
    expect(result.status).toBe('migrated')
    expect(result.converted).toMatchObject({
      root: {
        children: [
          {
            type: 'paragraph',
            children: [
              { text: 'normal ', format: 0 },
              { text: 'bold', format: 1 },
              { text: ' ', format: 0 },
              { text: 'italic', format: 2 },
            ],
          },
        ],
      },
    })
  })

  it('35. preserves list structure as list and listitem nodes', () => {
    const slate = [slateList(['item 1', 'item 2', 'item 3'])]
    const result = convertContent(slate)
    expect(result.status).toBe('migrated')
    expect(result.converted).toMatchObject({
      root: {
        children: [
          {
            type: 'list',
            tag: 'ul',
            listType: 'bullet',
            children: [
              { type: 'listitem', children: [{ text: 'item 1' }] },
              { type: 'listitem', children: [{ text: 'item 2' }] },
              { type: 'listitem', children: [{ text: 'item 3' }] },
            ],
          },
        ],
      },
    })
  })

  it('36. preserves empty paragraphs as text nodes inside a paragraph', () => {
    const slate = [{ children: [{ text: '' }] }]
    const result = convertContent(slate)
    expect(result.status).toBe('migrated')
    expect(result.converted).toMatchObject({
      root: {
        children: [
          {
            type: 'paragraph',
            children: [{ type: 'text', text: '' }],
          },
        ],
      },
    })
  })
})

describe('slate img nodes', () => {
  const imageUrl = 'https://www.salzhemmendorf.de/wp-content/uploads/2024/10/Gleichstellung.jpg'

  type LinkNode = { type: 'link'; fields: { url?: string }; children: { text?: string }[] }

  const collectLinks = (node: unknown): LinkNode[] => {
    if (typeof node !== 'object' || node === null) return []
    const own = (node as { type?: string }).type === 'link' ? [node as LinkNode] : []
    return [...own, ...Object.values(node).flatMap(collectLinks)]
  }

  const linkText = (link: LinkNode) => link.children.map((child) => child.text ?? '').join('')

  it('does not turn an image into a link whose text is the image url', () => {
    const slate = [
      { children: [{ text: 'Intro' }] },
      { type: 'img', url: imageUrl, children: [{ text: '' }] },
    ]

    const { converted } = convertContent(slate)

    const linkTexts = collectLinks(converted).map(linkText)
    expect(linkTexts).not.toContain(imageUrl)
  })

  it('does not emit a link with an empty url for an img node without src', () => {
    const slate = [{ type: 'img', children: [{ text: '' }] }]

    const { converted } = convertContent(slate)

    const emptyUrlLinks = collectLinks(converted).filter((link) => link.fields.url === '')
    expect(emptyUrlLinks).toEqual([])
  })

  it('drops a link that only wraps an image', () => {
    const slate = [
      { children: [{ text: 'Intro' }] },
      {
        type: 'link',
        url: 'https://example.org/page',
        children: [{ type: 'img', url: imageUrl, children: [{ text: '' }] }],
      },
    ]

    const { converted } = convertContent(slate)

    expect(collectLinks(converted)).toEqual([])
    expect(JSON.stringify(converted)).toContain('Intro')
  })

  it('yields an empty root when the content is only images', () => {
    const { converted, status } = convertContent([
      { type: 'img', url: imageUrl, children: [{ text: '' }] },
    ])

    expect(status).toBe('migrated')
    expect(converted).toEqual(EMPTY_LEXICAL_ROOT)
  })
})
