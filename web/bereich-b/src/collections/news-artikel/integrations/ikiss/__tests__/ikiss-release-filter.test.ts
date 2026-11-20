import { XMLParser } from 'fast-xml-parser'
import { afterEach, describe, expect, test, vi } from 'vitest'
import { type IkissIntegration } from '../../../../../integrations/ikiss/ikiss-integration'
import { isReleased } from '../../../../../integrations/ikiss/ikiss-xml'
import { getArticles } from '../ikiss-importer'

describe('isReleased', () => {
  test('boolean true is released', () => {
    expect(isReleased(true)).toBe(true)
  })
  test("string 'true' is released", () => {
    expect(isReleased('true')).toBe(true)
  })
  test('boolean false is not released', () => {
    expect(isReleased(false)).toBe(false)
  })
  test("string 'false' is not released", () => {
    expect(isReleased('false')).toBe(false)
  })
  test('missing release is not released', () => {
    expect(isReleased(undefined)).toBe(false)
  })
})

describe('release parsed from an iKISS fetch response drives the import', () => {
  const parser = new XMLParser({ stopNodes: ['*.data_content'] })
  const fetchXml = (release: string) =>
    `<?xml version="1.0"?><ikiss><result><tcontent><release>${release}</release></tcontent></result></ikiss>`

  test('a released article is imported', () => {
    const tcontent = parser.parse(fetchXml('true')).ikiss.result.tcontent
    expect(isReleased(tcontent.release)).toBe(true)
  })

  test('a draft article is skipped', () => {
    const tcontent = parser.parse(fetchXml('false')).ikiss.result.tcontent
    expect(isReleased(tcontent.release)).toBe(false)
  })
})

describe('getArticles search request', () => {
  afterEach(() => {
    vi.unstubAllGlobals()
  })

  // The search intentionally does NOT filter by release: unreleased articles
  // must still be returned so the importer can remove previously-imported ones
  // that iKISS has unpublished. Release state is enforced per-article on fetch.
  test('searches by category without a release filter', async () => {
    const bodies: string[] = []
    const fetchMock = vi.fn(async (_url: unknown, init: { body?: unknown }) => {
      bodies.push(String(init?.body ?? ''))
      return new Response(
        '<?xml version="1.0"?><ikiss><result><tcontent_list></tcontent_list></result></ikiss>',
        { headers: { 'content-type': 'text/xml;charset=utf-8' } },
      )
    })
    vi.stubGlobal('fetch', fetchMock)

    await getArticles('2561.264.1', {
      url: 'http://ikiss.test',
      benutzername: 'user',
      passwort: 'pass',
      kommune: 'kommune-id',
    } as unknown as IkissIntegration)

    expect(fetchMock).toHaveBeenCalledTimes(1)
    expect(bodies[0]).toContain('<categorie>2561.264.1</categorie>')
    expect(bodies[0]).not.toContain('<release>')
  })
})
