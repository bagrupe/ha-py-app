import type { PayloadRequest } from 'payload'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'

vi.mock('../../utils/point-in-geoflaeche', () => ({
  booleanPointInFeatureCollection: vi.fn(() => true),
}))

import { poiUpload } from './poi-upload'

type FeatureProperties = {
  OBJECTID: number
  Name: string
  Telefonnummer?: string | null
  Homepage?: string | null
  email?: string | null
  other?: string | null
}

const buildInput = (properties: FeatureProperties) => ({
  kategorieId: 'category-1',
  organisationseinheitId: 'oe-1',
  featureCollection: {
    type: 'FeatureCollection' as const,
    name: 'import',
    features: [
      {
        type: 'Feature' as const,
        geometry: { type: 'Point' as const, coordinates: [9.3, 52.1] as [number, number] },
        properties,
      },
    ],
  },
})

const input = buildInput({ OBJECTID: 1, Name: 'Test POI' })

const jugendmusikschuleInput = buildInput({
  OBJECTID: 15969,
  Name: 'Jugendmusikschule Bad Münder',
  Telefonnummer: '05042/81701',
  email: 'info@example.com',
  Homepage: 'https://www.jms-bad-muender.de',
  other: 'Zusätzlicher Beschreibungstext',
})
jugendmusikschuleInput.featureCollection.features[0].geometry.coordinates = [
  531552.4658, 5782803.3669,
]

const jugendmusikschuleAdditionalInformation = [
  { heading: 'Webseite', text: 'https://www.jms-bad-muender.de', kind: 'website' },
  { heading: 'Email', text: 'info@example.com', kind: 'email' },
  { heading: 'Telefonnummer', text: '05042/81701', kind: 'phone' },
  { heading: 'Sonstiges', text: 'Zusätzlicher Beschreibungstext', kind: 'other' },
]

const createRequest = (
  existingPoi?: { id: string; title: string; lockedForImport: boolean },
  requestInput: unknown = input,
) => {
  const find = vi
    .fn()
    .mockResolvedValueOnce({ docs: [{ id: 'category-1' }] })
    .mockResolvedValueOnce({ docs: [{ id: 'oe-1' }] })
    .mockResolvedValueOnce({ docs: existingPoi ? [existingPoi] : [] })
  const create = vi.fn().mockResolvedValue({ id: 'poi-1' })
  const update = vi.fn().mockResolvedValue({ id: 'poi-1' })
  const req = {
    user: {
      id: 'user-1',
      kommune: { id: 'kommune-1' },
      organisationseinheiten: [
        {
          organisationseinheit: 'oe-1',
          funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegePois],
        },
      ],
    },
    json: vi.fn().mockResolvedValue(requestInput),
    payload: { find, create, update },
  } as unknown as PayloadRequest

  return { req, find, create, update }
}

describe('poiUpload', () => {
  beforeEach(() => {
    vi.spyOn(console, 'info').mockImplementation(() => undefined)
  })

  it('enforces caller access for lookups and creates', async () => {
    const { req, find, create } = createRequest()

    const response = await poiUpload(req)

    expect(response.status).toBe(200)
    expect(find).toHaveBeenCalledTimes(3)
    for (const [options] of find.mock.calls) {
      expect(options).toMatchObject({ overrideAccess: false, req })
    }
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({ collection: 'poi', overrideAccess: false, req }),
    )
  })

  it('enforces caller access for updates', async () => {
    const { req, update } = createRequest({
      id: 'poi-1',
      title: 'Existing POI',
      lockedForImport: false,
    })

    const response = await poiUpload(req)

    expect(response.status).toBe(200)
    expect(update).toHaveBeenCalledWith(
      expect.objectContaining({
        collection: 'poi',
        id: 'poi-1',
        overrideAccess: false,
        req,
      }),
    )
  })

  it('maps all four properties into additionalInformation in order', async () => {
    const { req, create } = createRequest(undefined, jugendmusikschuleInput)

    const response = await poiUpload(req)

    expect(response.status).toBe(200)
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          additionalInformation: jugendmusikschuleAdditionalInformation,
        }),
      }),
    )
  })

  it.each([undefined, null, ''])('adds no "other" entry when other is %s', async (other) => {
    const requestInput = buildInput({
      OBJECTID: 1,
      Name: 'Test POI',
      Telefonnummer: '05042/81701',
      email: 'info@example.de',
      Homepage: 'https://example.de',
      other,
    })
    const { req, create } = createRequest(undefined, requestInput)

    const response = await poiUpload(req)

    expect(response.status).toBe(200)
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          additionalInformation: [
            { heading: 'Webseite', text: 'https://example.de', kind: 'website' },
            { heading: 'Email', text: 'info@example.de', kind: 'email' },
            { heading: 'Telefonnummer', text: '05042/81701', kind: 'phone' },
          ],
        }),
      }),
    )
  })

  it('maps other into additionalInformation on the update path', async () => {
    const { req, update } = createRequest(
      { id: 'poi-1', title: 'Existing POI', lockedForImport: false },
      jugendmusikschuleInput,
    )

    const response = await poiUpload(req)

    expect(response.status).toBe(200)
    expect(update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          additionalInformation: jugendmusikschuleAdditionalInformation,
        }),
      }),
    )
  })

  it('yields an empty additionalInformation list when only OBJECTID and Name are present', async () => {
    const { req, create } = createRequest()

    const response = await poiUpload(req)

    expect(response.status).toBe(200)
    expect(create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({ additionalInformation: [] }),
      }),
    )
  })
})
