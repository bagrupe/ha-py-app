import { getPayload, type Payload } from 'payload'
import config from '@/payload.config'
import { afterAll, beforeAll, describe, expect, it } from 'vitest'

let payload: Payload
const createdIds: string[] = []
const date = { start: '2026-01-01T10:00:00.000Z', end: '2026-01-01T12:00:00.000Z' }

const editorReq = async () => {
  const { docs } = await payload.find({
    collection: 'benutzer',
    where: { email: { equals: 'hvb-hapy@example.com' } },
    limit: 1,
  })
  return { user: { ...docs[0], collection: 'benutzer' } } as never
}

describe('veranstaltungskalender writes', () => {
  beforeAll(async () => {
    payload = await getPayload({ config: await config })
  })

  afterAll(async () => {
    for (const id of createdIds) {
      await payload.delete({ collection: 'veranstaltungskalender', id }).catch(() => {})
    }
  })

  it('locks an editor-saved event from import and clears the upstream marker', async () => {
    const created = await payload.create({
      collection: 'veranstaltungskalender',
      data: {
        id: `it-lock-${Date.now()}`,
        titel: 'IT',
        visible: false,
        upstreamUpdateDate: '2026-01-01',
        timeAndLocation: { dates: [] },
      },
    })
    createdIds.push(created.id as string)

    const readMarker = async () =>
      (
        await payload.findByID({
          collection: 'veranstaltungskalender',
          id: created.id,
          showHiddenFields: true,
        })
      ).upstreamUpdateDate
    expect(await readMarker()).toBe('2026-01-01')

    const updated = await payload.update({
      collection: 'veranstaltungskalender',
      id: created.id,
      data: { visible: true, timeAndLocation: { dates: [date] } },
      req: await editorReq(),
      overrideAccess: true,
    })

    expect(updated.visible).toBe(true)
    expect(updated.lockedForImport).toBe(true)
    expect(await readMarker()).toBeFalsy()
  })

  it('lets the importer path (no user) write without a locked flag', async () => {
    const created = await payload.create({
      collection: 'veranstaltungskalender',
      data: {
        id: `it-import-${Date.now()}`,
        titel: 'IT',
        visible: true,
        timeAndLocation: { dates: [] },
      },
    })
    createdIds.push(created.id as string)
    expect(created.visible).toBe(true)
    expect(created.lockedForImport).toBeFalsy()
  })
})
