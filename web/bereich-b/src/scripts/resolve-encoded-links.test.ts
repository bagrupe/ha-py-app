import { describe, expect, it, vi } from 'vitest'
import { resolveEncodedLinks, resolveEncodedLinksInTargets } from './resolve-encoded-links'

const text = (value: string) => ({ type: 'text', text: value, version: 1 })

const link = (url: string, linkText: string) => ({
  type: 'link',
  fields: { linkType: 'custom', newTab: true, url },
  children: [text(linkText)],
})

const root = (...paragraphChildren: unknown[][]) => ({
  type: 'root',
  children: paragraphChildren.map((children) => ({ type: 'paragraph', children })),
})

const baseUrl = 'https://www.hameln-pyrmont.de'
const encodedRedirect = '%2Fredirect.phtml%3Fextlink%3D1%26La%3D1%26url_fid%3D2749.500.1'

describe('resolveEncodedLinks', () => {
  it('decodes an encoded relative url and resolves it against the base url', () => {
    const { node, resolved } = resolveEncodedLinks(
      root([text('see '), link(encodedRedirect, 'KAW')]) as never,
      baseUrl,
    )

    expect(resolved).toBe(1)
    expect(node).toEqual(
      root([
        text('see '),
        link(
          'https://www.hameln-pyrmont.de/redirect.phtml?extlink=1&La=1&url_fid=2749.500.1',
          'KAW',
        ),
      ]),
    )
  })

  it('resolves links nested inside other nodes', () => {
    const nested = {
      type: 'root',
      children: [{ type: 'list', children: [{ type: 'listitem', children: [link('%2Fa', 'a')] }] }],
    }

    const { node, resolved } = resolveEncodedLinks(nested as never, baseUrl)

    expect(resolved).toBe(1)
    expect(JSON.stringify(node)).toContain('"url":"https://www.hameln-pyrmont.de/a"')
  })

  it('leaves absolute, mailto and already resolved links untouched', () => {
    const original = root(
      [link('https://example.org/a', 'a')],
      [link('mailto:x@example.org', 'm')],
      [link('https://www.hameln-pyrmont.de/redirect.phtml?extlink=1', 'r')],
    )

    const { node, resolved } = resolveEncodedLinks(original as never, baseUrl)

    expect(resolved).toBe(0)
    expect(node).toBe(original)
  })

  it('is idempotent', () => {
    const once = resolveEncodedLinks(root([link(encodedRedirect, 'x')]) as never, baseUrl)
    const twice = resolveEncodedLinks(once.node, baseUrl)

    expect(twice.resolved).toBe(0)
    expect(twice.node).toEqual(once.node)
  })
})

describe('resolveEncodedLinksInTargets', () => {
  const richText = (content: unknown) => ({ blockType: 'rich-text', content: { root: content } })

  const run = async (docs: Record<string, unknown>[], versions = false) => {
    const bulkWrite = vi.fn()
    const find = vi.fn((filter: { _id?: { $gt: number } }) => ({
      sort: () => ({
        limit: () => ({
          toArray: async () => docs.filter((doc) => (doc._id as number) > (filter._id?.$gt ?? 0)),
        }),
      }),
    }))
    const logger = { info: vi.fn(), warn: vi.fn() }
    const model = { collection: { find, bulkWrite } }

    await resolveEncodedLinksInTargets({
      adapter: versions
        ? { collections: {}, versions: { 'news-artikel': model } }
        : { collections: { 'news-artikel': model } },
      baseUrlByIntegrationId: new Map([['int-1', baseUrl]]),
      logger,
      targets: [{ collectionSlug: 'news-artikel', field: 'inhalte', type: 'block', versions }],
    })
    return { bulkWrite, logger }
  }

  it('rewrites only docs with encoded links, using the base url of their integration', async () => {
    const { bulkWrite } = await run([
      { _id: 1, integration: 'int-1', inhalte: [richText(root([link(encodedRedirect, 'x')]))] },
      { _id: 2, integration: 'int-1', inhalte: [richText(root([link('https://ok.test', 'y')]))] },
    ])

    expect(bulkWrite).toHaveBeenCalledTimes(1)
    const [[operations]] = bulkWrite.mock.calls
    expect(operations).toHaveLength(1)
    expect(operations[0].updateOne.filter).toEqual({ _id: 1 })
    expect(JSON.stringify(operations[0].updateOne.update.$set.inhalte)).toContain(
      '"url":"https://www.hameln-pyrmont.de/redirect.phtml?extlink=1&La=1&url_fid=2749.500.1"',
    )
  })

  it('reads the integration from the version payload for version targets', async () => {
    const { bulkWrite } = await run(
      [
        {
          _id: 1,
          version: { integration: 'int-1', inhalte: [richText(root([link('%2Fa', 'a')]))] },
        },
      ],
      true,
    )

    expect(bulkWrite).toHaveBeenCalledTimes(1)
    expect(bulkWrite.mock.calls[0][0][0].updateOne.update.$set).toHaveProperty('version.inhalte')
  })

  it('leaves docs without a known integration unchanged and warns', async () => {
    const { bulkWrite, logger } = await run([
      { _id: 1, inhalte: [richText(root([link('%2Fa', 'a')]))] },
      { _id: 2, integration: 'unknown', inhalte: [richText(root([link('%2Fb', 'b')]))] },
    ])

    expect(bulkWrite).not.toHaveBeenCalled()
    expect(logger.warn).toHaveBeenCalledTimes(2)
  })
})
