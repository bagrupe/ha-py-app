import { beforeEach, describe, expect, it, vi } from 'vitest'
import { getImageById } from '../ikiss-images'

const getImageFromPayloadOrFetchFromRemote = vi.hoisted(() => vi.fn())

vi.mock('@sentry/nextjs', () => ({ captureException: vi.fn(), captureMessage: vi.fn() }))

vi.mock('../../../collections/news-artikel/integrations/common', () => ({
  getImageFromPayloadOrFetchFromRemote,
  resolveKommuneId: (kommune: string) => kommune,
  prefetchImporterCaches: vi.fn(),
  updateIntegrationResult: vi.fn(),
}))

type Rendition = { path: string; width: number }

const mediaResponse = (renditions: Rendition[]) =>
  new Response(
    [
      '<ikiss><result><tmedia><tdata_list>',
      ...renditions.map(
        ({ path, width }) =>
          `<tdata><media_path><![CDATA[${path}]]></media_path><width>${width}</width><height>100</height></tdata>`,
      ),
      '</tdata_list></tmedia></result></ikiss>',
    ].join(''),
    { headers: { 'content-type': 'text/xml;charset=utf-8' } },
  )

const payloadStub = { logger: { info: vi.fn() } } as never
const integration = {
  kommune: 'kommune-1',
  url: 'https://ikiss.example.test',
  benutzername: 'user',
  passwort: 'secret',
} as never

const resolve = async (response: Response) => {
  vi.stubGlobal(
    'fetch',
    vi.fn(async () => response),
  )
  return getImageById(payloadStub, '3767.3529.1', 'https://ikiss.example.test', integration)
}

const importedImageUrl = async (renditions: Rendition[]) => {
  await resolve(mediaResponse(renditions))
  return getImageFromPayloadOrFetchFromRemote.mock.lastCall?.[1]
}

describe('iKISS image selection', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('selects the image rendition to import', async () => {
    const withRendition = await importedImageUrl([
      { path: '/media/custom/3767_3529_1_m.PNG?1790935603', width: 400 },
      { path: '/media/custom/3767_3529_1_g.PNG?1790935603', width: 1920 },
      { path: '/media/custom/3767_3529_1_r.PNG?1790935613', width: 800 },
    ])
    expect(withRendition).toBe(
      'https://ikiss.example.test/media/custom/3767_3529_1_r.PNG?1790935613',
    )

    const withoutRendition = await importedImageUrl([
      { path: '/media/custom/3767_3529_1_m.PNG?1790935603', width: 400 },
      { path: '/media/custom/3767_3529_1_g.PNG?1790935603', width: 800 },
      { path: '/media/custom/3767_3529_1_t.PNG?1790935603', width: 200 },
    ])
    expect(withoutRendition).toBe(
      'https://ikiss.example.test/media/custom/3767_3529_1_g.PNG?1790935603',
    )

    const underSafe = await importedImageUrl([
      { path: '/media/custom/safe/3767_3529_1_g.PNG?1790935603', width: 2400 },
      { path: '/media/custom/safe/3767_3529_1_r.PNG?1790935613', width: 1920 },
    ])
    expect(underSafe).toBe(
      'https://ikiss.example.test/media/custom/safe/3767_3529_1_r.PNG?1790935613',
    )
  })

  it('reports a document medium as not an image without downloading it', async () => {
    const resolution = await resolve(
      mediaResponse([{ path: '/media/custom/3767_3497_1.PDF?1790085805', width: 0 }]),
    )

    expect(resolution).toEqual({ status: 'notAnImage' })
    expect(getImageFromPayloadOrFetchFromRemote).not.toHaveBeenCalled()
  })

  it('returns the imported image', async () => {
    getImageFromPayloadOrFetchFromRemote.mockResolvedValueOnce({ id: 'media-1' })

    const resolution = await resolve(
      mediaResponse([{ path: '/media/custom/3767_3529_1_r.PNG?1790935613', width: 1920 }]),
    )

    expect(resolution).toEqual({ status: 'imported', image: { id: 'media-1' } })
  })

  it('fails when iKISS or the upload fails', async () => {
    expect(await resolve(new Response('', { status: 500 }))).toMatchObject({ status: 'failed' })

    getImageFromPayloadOrFetchFromRemote.mockRejectedValueOnce(new Error('invalid: file'))
    const uploadFailure = await resolve(
      mediaResponse([{ path: '/media/custom/3767_3529_1_r.PNG?1790935613', width: 1920 }]),
    )
    expect(uploadFailure).toMatchObject({ status: 'failed' })
  })
})
