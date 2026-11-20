import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'

import { type IkissIntegration } from '../../../../../integrations/ikiss/ikiss-integration'
import { getArticleByIdAndUpload } from '../ikiss-importer'

const find = vi.fn()
const remove = vi.fn()
const create = vi.fn()
const update = vi.fn()
const info = vi.fn()

// v3 passes `payload` into the importer as an argument (v1 used a module
// singleton), so inject a minimal fake instead of mocking the `payload` module.
// Mocking the module would drop `buildConfig`, which the importer's transitive
// imports (payload.config) require to load.
const payload = {
  find,
  delete: remove,
  create,
  update,
  logger: { info, error: vi.fn(), warn: vi.fn() },
} as unknown as Parameters<typeof getArticleByIdAndUpload>[0]

describe('unpublishing an imported iKISS article', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    remove.mockResolvedValue({})
    update.mockResolvedValue({})
  })

  afterEach(() => {
    vi.unstubAllGlobals()
  })

  test('deletes the matching local article when its release is withdrawn', async () => {
    find.mockResolvedValue({ docs: [{ id: 'local-article-id' }] })
    vi.stubGlobal(
      'fetch',
      vi.fn(
        async () =>
          new Response(
            '<?xml version="1.0"?><ikiss><result><tcontent><release>false</release></tcontent></result></ikiss>',
            { headers: { 'content-type': 'text/xml;charset=utf-8' } },
          ),
      ),
    )

    await getArticleByIdAndUpload(payload, 'ikiss-article-id', 0, {
      id: 'integration-id',
      url: 'http://ikiss.test',
      benutzername: 'user',
      passwort: 'pass',
      kommune: 'kommune-id',
    } as unknown as IkissIntegration)

    expect(find).toHaveBeenCalledWith({
      collection: 'news-artikel',
      where: {
        and: [{ importId: { equals: 'ikiss-article-id' } }, { kommune: { equals: 'kommune-id' } }],
      },
      limit: 1,
      depth: 0,
    })
    expect(remove).toHaveBeenCalledWith({ collection: 'news-artikel', id: 'local-article-id' })
    expect(create).not.toHaveBeenCalled()
  })
})
