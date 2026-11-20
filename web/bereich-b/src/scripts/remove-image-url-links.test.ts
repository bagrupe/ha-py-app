import { describe, expect, it, vi } from 'vitest'
import { removeImageUrlLinks, removeImageUrlLinksInTargets } from './remove-image-url-links'

const text = (value: string) => ({ type: 'text', text: value, version: 1 })

const link = (url: string, linkText: string, newTab = true) => ({
  type: 'link',
  fields: { linkType: 'custom', newTab, url },
  children: [text(linkText)],
})

const root = (...paragraphChildren: unknown[][]) => ({
  type: 'root',
  children: paragraphChildren.map((children) => ({ type: 'paragraph', children })),
})

const imageUrl = 'https://bad-muender.de/images/2026/IMG_1513.jpg'

describe('removeImageUrlLinks', () => {
  it('drops a link whose text is its own image url', () => {
    const { node, removed } = removeImageUrlLinks(
      root([text('before'), link(imageUrl, imageUrl), text('after')]) as never,
    )

    expect(removed).toBe(1)
    expect(node).toEqual(root([text('before'), text('after')]))
  })

  it('replaces a link with an empty url by its children', () => {
    const { node, removed } = removeImageUrlLinks(root([link('', 'orphan text')]) as never)

    expect(removed).toBe(1)
    expect(node).toEqual(root([text('orphan text')]))
  })

  it('drops a paragraph that only held an image-url link', () => {
    const { node, removed } = removeImageUrlLinks(
      root([text('before')], [link(imageUrl, imageUrl)], [text('after')]) as never,
    )

    expect(removed).toBe(1)
    expect(node).toEqual(root([text('before')], [text('after')]))
  })

  it('drops a paragraph left with only blank text after unwrapping an empty-url link', () => {
    const { node } = removeImageUrlLinks(root([text('a')], [text(' '), link('', '')]) as never)

    expect(node).toEqual(root([text('a')]))
  })

  it('keeps blank paragraphs that were not touched by a removal', () => {
    const original = root([text('')], [])

    const { node, removed } = removeImageUrlLinks(original as never)

    expect(removed).toBe(0)
    expect(node).toBe(original)
  })

  it('keeps links with a different text, and image links opened in the same tab', () => {
    const original = root(
      [link(imageUrl, 'Das Plakat')],
      [link(imageUrl, imageUrl, false)],
      [link('https://example.org/a', 'https://example.org/a')],
    )

    const { node, removed } = removeImageUrlLinks(original as never)

    expect(removed).toBe(0)
    expect(node).toBe(original)
  })

  it('is idempotent', () => {
    const once = removeImageUrlLinks(root([link(imageUrl, imageUrl), link('', 'x')]) as never)
    const twice = removeImageUrlLinks(once.node as never)

    expect(twice.removed).toBe(0)
    expect(twice.node).toEqual(once.node)
  })
})

describe('removeImageUrlLinksInTargets', () => {
  it('rewrites only changed rich-text blocks and paginates by _id', async () => {
    const docs = [
      {
        _id: 1,
        inhalte: [
          { blockType: 'rich-text', content: { root: root([link(imageUrl, imageUrl)]) } },
          { blockType: 'image', image: 'x' },
        ],
      },
      { _id: 2, inhalte: [{ blockType: 'rich-text', content: { root: root([text('clean')]) } }] },
    ]
    const bulkWrite = vi.fn()
    const find = vi.fn((filter: { _id?: { $gt: number } }) => ({
      sort: () => ({
        limit: () => ({
          toArray: async () => docs.filter((doc) => doc._id > (filter._id?.$gt ?? 0)),
        }),
      }),
    }))

    await removeImageUrlLinksInTargets({
      adapter: { collections: { 'news-artikel': { collection: { find, bulkWrite } } } },
      logger: {},
      targets: [{ collectionSlug: 'news-artikel', field: 'inhalte', type: 'block' }],
    })

    expect(bulkWrite).toHaveBeenCalledTimes(1)
    const [[operations]] = bulkWrite.mock.calls
    expect(operations).toHaveLength(1)
    expect(operations[0].updateOne.filter).toEqual({ _id: 1 })
    expect(operations[0].updateOne.update.$set.inhalte[0].content.root).toEqual(root())
  })
})
