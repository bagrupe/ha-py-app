import { beforeEach, describe, expect, it, vi } from 'vitest'
import { CronJobItemFailures } from '../../../cron-job-item-failures'
import { importIkissVeranstaltungen } from '../ikiss-sync'

type Doc = Record<string, unknown>
type Operation = { op: 'create' | 'update' | 'delete'; collection: string; id: unknown }
type UpstreamEvent = {
  id: string
  title: string
  from?: string
  to?: string
  updated?: string
  teaser?: string
  image?: string
  released?: boolean
  area?: 'internet' | 'user'
}
type FetchHandler = (request: { url: URL; body: string }) => Response | Promise<Response>

const state = {
  collections: {} as Record<string, Doc[]>,
  operations: [] as Operation[],
  nextId: 1,
}

const matchesWhere = (doc: Doc, where: Record<string, unknown> | undefined): boolean => {
  if (!where) return true
  return Object.entries(where).every(([field, condition]) => {
    if (field === 'and') return (condition as Doc[]).every((part) => matchesWhere(doc, part))
    const value = doc[field]
    const [[operator, expected]] = Object.entries(condition as Doc)
    const values = Array.isArray(value) ? value : [value]
    switch (operator) {
      case 'equals':
      case 'contains':
        return values.includes(expected)
      case 'in':
        return values.some((v) => (expected as unknown[]).includes(v))
      case 'not_in':
        return !values.some((v) => (expected as unknown[]).includes(v))
      default:
        throw new Error(`Unsupported where operator ${operator}`)
    }
  })
}

const docsOf = (collection: string) => (state.collections[collection] ??= [])

const payloadStub = {
  config: {},
  logger: { info() {}, warn() {}, error() {} },
  find: async ({ collection, where }: { collection: string; where?: Record<string, unknown> }) => {
    const docs = docsOf(collection).filter((doc) => matchesWhere(doc, where))
    return { docs, totalDocs: docs.length }
  },
  create: async ({ collection, data }: { collection: string; data: Doc }) => {
    const doc = { id: `generated-${state.nextId++}`, ...data }
    docsOf(collection).push(doc)
    state.operations.push({ op: 'create', collection, id: doc.id })
    return doc
  },
  update: async ({ collection, id, data }: { collection: string; id: unknown; data: Doc }) => {
    const doc = docsOf(collection).find((candidate) => candidate.id === id)
    Object.assign(doc ?? {}, data)
    state.operations.push({ op: 'update', collection, id })
    return doc
  },
  delete: async ({ collection, id }: { collection: string; id: unknown }) => {
    state.collections[collection] = docsOf(collection).filter((doc) => doc.id !== id)
    state.operations.push({ op: 'delete', collection, id })
  },
}

vi.mock('@payload-config', () => ({ default: {} }))
vi.mock('payload', async (importOriginal) => ({
  ...(await importOriginal<object>()),
  getPayload: async () => payloadStub,
}))
vi.mock('@sentry/nextjs', () => ({ captureException: vi.fn(), captureMessage: vi.fn() }))
vi.mock('../../../../lib/html-to-lexical', () => ({
  getDefaultEditorConfig: vi.fn(async () => ({})),
  htmlToLexical: vi.fn((html: string) => ({ importedHtml: html })),
}))

const payload = payloadStub as never
const kommune = (id: string) => ({ id, name: id }) as never

const integration = (kommuneId: string, host: string, overrides: Doc = {}) => ({
  id: `integration-${kommuneId}`,
  integrationtype: 'IKISS_VERANSTALTUNGEN',
  kommune: kommuneId,
  url: `https://${host}`,
  zugangsdaten: { benutzername: `user-${host}`, passwort: `pass-${host}` },
  ...overrides,
})

const searchResponse = (events: UpstreamEvent[]) =>
  new Response(
    `<ikiss><result><tevents_list>${events
      .map(
        (e) =>
          `<tevents><object_id>${e.id}</object_id><title><![CDATA[${e.title}]]></title>` +
          `<datetime_from>${e.from ?? '2026-11-05 10:00:00'}</datetime_from>` +
          `<datetime_to>${e.to ?? '2026-11-05 12:00:00'}</datetime_to>` +
          `<release>${e.released === false ? 0 : 1}</release><area>${e.area === 'user' ? 2 : 3}</area>` +
          `<update_date>${e.updated ?? '2026-10-01 08:00:00'}</update_date></tevents>`,
      )
      .join('')}</tevents_list></result></ikiss>`,
  )

const fetchResponse = (e: UpstreamEvent) =>
  new Response(
    `<ikiss><result><tevents><object_full_id>${e.id}</object_full_id>` +
      `<object_id>${e.id.split('.')[1]}</object_id>` +
      `<title><![CDATA[${e.title}]]></title>` +
      `<datetime_from>${e.from ?? '2026-11-05 10:00:00'}</datetime_from>` +
      `<datetime_to>${e.to ?? '2026-11-05 12:00:00'}</datetime_to>` +
      `<data_short_content><![CDATA[${e.teaser ?? `Short ${e.title}`}]]></data_short_content>` +
      `<data_content><![CDATA[<p>Content ${e.title}</p>]]></data_content>` +
      `<location>Hameln</location><release>${e.released === false ? 'false' : 'true'}</release>` +
      `<area>${e.area ?? 'internet'}</area>` +
      `<image>${e.image ?? ''}</image>` +
      `</tevents></result></ikiss>`,
  )

const terrorResponse = (errorNumber: number) =>
  new Response(
    `<ikiss><result><terror><error_num>${errorNumber}</error_num><error_msg>ERROR ${errorNumber}</error_msg></terror></result></ikiss>`,
  )

const serveUpstream =
  (events: UpstreamEvent[]): FetchHandler =>
  ({ body }) => {
    const action = body.match(/<action>(\w+)<\/action>/)?.[1]
    if (action === 'search') return searchResponse(events)
    if (body.includes('<set_module>media</set_module>')) return new Response('', { status: 500 })
    const id = body.match(/<id>([^<]+)<\/id>/)?.[1]
    const event = events.find((e) => e.id === id)
    if (!event) throw new Error(`Unexpected fetch of ${id}`)
    return fetchResponse(event)
  }

let handler: FetchHandler
const fetchMock = vi.fn(async (url: URL, init: { body: string }) =>
  handler({ url, body: init.body }),
)

const now = new Date('2026-10-26T10:00:00Z')
const host = 'ikiss.k1.test'

const runImport = async (kommuneId = 'kommune-1') => {
  const failures = new CronJobItemFailures()
  await importIkissVeranstaltungen(payload, kommune(kommuneId), failures, now)
  return failures
}

const veranstaltungen = () => docsOf('veranstaltungskalender')
const veranstaltungOperations = (): Operation[] =>
  state.operations.filter((o) => o.collection === 'veranstaltungskalender')
const quelleId = () =>
  docsOf('veranstaltungskalender-quelle').find(
    (q) => q.name === 'Landkreis Hameln-Pyrmont' && q.kommune === 'kommune-1',
  )?.id as string

const seedQuelle = () => {
  state.collections['veranstaltungskalender-quelle'] = [
    { id: 'quelle-lk', name: 'Landkreis Hameln-Pyrmont', kommune: 'kommune-1' },
  ]
}

const lkDoc = (id: string): Doc => ({ id, titel: id, kommune: 'kommune-1', source: ['quelle-lk'] })
const otherQuelleDoc = { id: 'et4-1', titel: 'ET4', kommune: 'kommune-1', source: ['quelle-et4'] }

const ids = (docs: Doc[]) => docs.map((doc) => doc.id).sort()

describe('iKISS Veranstaltung sync run', () => {
  beforeEach(() => {
    state.collections = { integration: [integration('kommune-1', host)] }
    state.operations = []
    state.nextId = 1
    fetchMock.mockClear()
    vi.spyOn(console, 'info').mockImplementation(() => {})
    vi.spyOn(console, 'warn').mockImplementation(() => {})
    vi.spyOn(console, 'error').mockImplementation(() => {})
    vi.stubGlobal('fetch', fetchMock)
  })

  it('syncs the LK Quelle docs with upstream', async () => {
    const event = (name: string, title = name): UpstreamEvent => ({ id: `3767.${name}.1`, title })
    handler = serveUpstream([
      event('changed'),
      event('unchanged'),
      event('lockedChanged'),
      event('gone'),
      event('lockedGone'),
    ])
    await runImport()

    for (const doc of veranstaltungen()) {
      if (['3767.lockedChanged.1', '3767.lockedGone.1'].includes(doc.id as string)) {
        doc.lockedForImport = true
      }
    }
    const otherKommuneDoc = {
      id: '3767.other.1',
      titel: 'Other',
      kommune: 'kommune-2',
      source: ['quelle-lk-k2'],
    }
    veranstaltungen().push(otherQuelleDoc, otherKommuneDoc)

    const changed = { updated: '2026-10-20 09:00:00' }
    handler = serveUpstream([
      { ...event('changed', 'Changed upstream'), ...changed },
      event('unchanged'),
      { ...event('lockedChanged', 'Locked changed upstream'), ...changed },
      event('new'),
    ])
    state.operations = []
    const failures = await runImport()

    expect(
      veranstaltungOperations().sort((a, b) => String(a.id).localeCompare(String(b.id))),
    ).toEqual([
      { op: 'update', collection: 'veranstaltungskalender', id: '3767.changed.1' },
      { op: 'delete', collection: 'veranstaltungskalender', id: '3767.gone.1' },
      { op: 'delete', collection: 'veranstaltungskalender', id: '3767.lockedGone.1' },
      { op: 'create', collection: 'veranstaltungskalender', id: '3767.new.1' },
    ])
    expect(ids(veranstaltungen())).toEqual(
      [
        '3767.changed.1',
        '3767.unchanged.1',
        '3767.lockedChanged.1',
        '3767.new.1',
        'et4-1',
        '3767.other.1',
      ].sort(),
    )
    const titleOf = (id: string) => veranstaltungen().find((doc) => doc.id === id)?.titel
    expect(titleOf('3767.changed.1')).toBe('Changed upstream')
    expect(titleOf('3767.lockedChanged.1')).toBe('lockedChanged')
    expect(veranstaltungen()).toContainEqual(otherQuelleDoc)
    expect(veranstaltungen()).toContainEqual(otherKommuneDoc)
    expect(failures.getCount()).toBe(0)
    expect(
      veranstaltungen().filter((doc) => (doc.source as string[]).includes(quelleId())),
    ).toHaveLength(4)

    state.operations = []
    const before = structuredClone(veranstaltungen())
    await runImport()

    expect(veranstaltungOperations()).toEqual([])
    expect(veranstaltungen()).toEqual(before)
  })

  it('re-imports only on an update_date change and mirrors it without losing images', async () => {
    const a = { id: '3767.a.1', title: 'A', teaser: 'Teaser A' }
    const fetchedBodies = () => fetchMock.mock.calls.map(([, init]) => init.body)
    handler = serveUpstream([a])
    await runImport()
    const doc = veranstaltungen().find((candidate) => candidate.id === a.id) as Doc
    doc.titelbild = { external: false, internal: 'media-old' }

    fetchMock.mockClear()
    await runImport()
    expect(fetchedBodies(), 'unchanged update_date skips the fetch').toEqual([
      expect.stringContaining('<action>search</action>'),
    ])

    const updated = { ...a, teaser: '', image: '3767_9_1', updated: '2026-10-20 09:00:00' }
    handler = serveUpstream([updated])
    const imageFailures = await runImport()
    expect(doc.teaser, 'emptied upstream field is cleared').toBeNull()
    expect(imageFailures.getCount(), 'failed image counts as a failure').toBe(1)
    expect(doc.titelbild, 'failed cover keeps the stored one').toEqual({
      external: false,
      internal: 'media-old',
    })

    fetchMock.mockClear()
    await runImport()
    expect(
      fetchedBodies().some((body) => body.includes(`<id>${a.id}</id>`)),
      'failed image retries next run',
    ).toBe(true)
  })

  it('imports an event whose image is a document without counting a failure', async () => {
    const event = { id: '3767.a.1', title: 'A', image: '3767_3497_1' }
    const pdfMedia = new Response(
      '<ikiss><result><tmedia><tdata_list><tdata>' +
        '<media_path><![CDATA[/media/custom/3767_3497_1.PDF?1790085805]]></media_path>' +
        '</tdata></tdata_list></tmedia></result></ikiss>',
    )
    const upstream = serveUpstream([event])
    handler = (request) =>
      request.body.includes('<set_module>media</set_module>') ? pdfMedia.clone() : upstream(request)

    const failures = await runImport()
    const doc = veranstaltungen().find((candidate) => candidate.id === event.id) as Doc
    expect(failures.getCount()).toBe(0)
    expect(doc.titelbild).toEqual({ external: false, internal: null })
    expect(doc.upstreamUpdateDate, 'not-an-image does not retry').toBeTruthy()
  })

  it('removes all LK Quelle docs when upstream has no events', async () => {
    seedQuelle()
    state.collections['veranstaltungskalender'] = [
      lkDoc('3767.a.1'),
      lkDoc('3767.b.1'),
      otherQuelleDoc,
    ]
    handler = () => terrorResponse(4043)

    const failures = await runImport()

    expect(veranstaltungen()).toEqual([otherQuelleDoc])
    expect(failures.getCount()).toBe(0)
  })

  it('records the run result on the integration', async () => {
    const status = () => state.collections['integration'][0].status as Doc

    handler = serveUpstream([{ id: '3767.a.1', title: 'A' }])
    await runImport()
    expect(status().erfolg).toBeTruthy()
    expect(status().last_import_date).toBeTruthy()
    expect(status().import_log).toBeFalsy()

    handler = () => new Response('', { status: 500 })
    await runImport()
    expect(status().import_log).toBeTruthy()
  })

  it('changes nothing when upstream fails', async () => {
    const cases: Record<string, FetchHandler> = {
      'terror other than 4043': () => terrorResponse(4001),
      'HTTP 500': () => new Response('', { status: 500 }),
      'network error': () => {
        throw new TypeError('fetch failed')
      },
      'response without tevents_list': () => new Response('<ikiss><result></result></ikiss>'),
    }

    for (const [name, failingHandler] of Object.entries(cases)) {
      seedQuelle()
      state.collections['veranstaltungskalender'] = [lkDoc('3767.a.1'), lkDoc('3767.b.1')]
      const before = structuredClone(veranstaltungen())
      state.operations = []
      handler = failingHandler

      const failures = await runImport()

      expect(veranstaltungOperations(), name).toEqual([])
      expect(veranstaltungen(), name).toEqual(before)
      expect(failures.getCount(), name).toBe(1)
    }
  })

  it('keeps the doc of an event that failed to import and imports the rest', async () => {
    const a = { id: '3767.a.1', title: 'A' }
    const b = { id: '3767.b.1', title: 'B' }
    handler = serveUpstream([a])
    await runImport()
    const docA = structuredClone(veranstaltungen().find((doc) => doc.id === a.id))
    state.operations = []

    const upstream = serveUpstream([{ ...a, updated: '2026-10-20 09:00:00' }, b])
    handler = (request) => {
      if (request.body.includes(`<id>${a.id}</id>`)) throw new TypeError('fetch failed')
      return upstream(request)
    }
    const failures = await runImport()

    expect(veranstaltungen().find((doc) => doc.id === a.id)).toEqual(docA)
    expect(veranstaltungOperations()).toEqual([
      { op: 'create', collection: 'veranstaltungskalender', id: b.id },
    ])
    expect(failures.getCount()).toBe(1)
  })

  it('imports only for kommunen with an iKISS events integration', async () => {
    state.collections['integration'] = [
      integration('kommune-1', 'ikiss.k1.test'),
      integration('kommune-2', 'ikiss.k2.test', { integrationtype: 'IKISS' }),
    ]
    handler = serveUpstream([{ id: '3767.a.1', title: 'A' }])

    for (const kommuneId of ['kommune-1', 'kommune-2', 'kommune-3']) {
      await runImport(kommuneId)
    }

    expect(veranstaltungen().map((doc) => [doc.id, doc.kommune])).toEqual([
      ['3767.a.1', 'kommune-1'],
    ])
    expect(fetchMock.mock.calls.length).toBeGreaterThan(0)
    for (const [url, init] of fetchMock.mock.calls) {
      expect(url.host).toBe('ikiss.k1.test')
      expect(init.body).toContain('<name>user-ikiss.k1.test</name>')
      expect(init.body).toContain('<password>pass-ikiss.k1.test</password>')
    }
  })

  describe('visibility and editor locks', () => {
    const eventId = '3767.a.1'
    const undated = { from: '0000-00-00 00:00:00', to: '0000-00-00 00:00:00' }
    const past = { from: '2026-10-01 10:00:00', to: '2026-10-01 12:00:00' }
    const laterDate = { from: '2026-12-01 10:00:00', to: '2026-12-01 12:00:00' }
    const editorDates = [{ start: '2026-11-20T10:00:00.000Z', end: '2026-11-20T12:00:00.000Z' }]
    const bumped = { updated: '2026-10-20 09:00:00' }

    const upstream = (overrides: Partial<UpstreamEvent> = {}): UpstreamEvent => ({
      id: eventId,
      title: 'A',
      ...overrides,
    })
    const stored = (id = eventId) => veranstaltungen().find((doc) => doc.id === id) as Doc
    const storedDates = (id = eventId) => (stored(id).timeAndLocation as { dates: unknown[] }).dates

    const importFrom = async (...events: UpstreamEvent[]) => {
      handler = serveUpstream(events)
      state.operations = []
      await runImport()
    }

    const editorSaves = (changes: Doc) =>
      Object.assign(stored(), { lockedForImport: true, upstreamUpdateDate: null, ...changes })

    const editorPublishesWithDate = () =>
      editorSaves({
        visible: true,
        timeAndLocation: { ...(stored().timeAndLocation as Doc), dates: editorDates },
      })

    describe('new upstream events', () => {
      it('imports a released, dated event as visible', async () => {
        await importFrom(upstream())

        expect(stored().visible).toBe(true)
        expect(storedDates()).toHaveLength(1)
      })

      it('imports a released event without a date as hidden with no dates', async () => {
        await importFrom(upstream(undated))

        expect(stored().visible).toBe(false)
        expect(storedDates()).toEqual([])
      })

      it('imports an unreleased dated event as hidden but keeps its dates', async () => {
        await importFrom(upstream({ released: false }))

        expect(stored().visible).toBe(false)
        expect(storedDates()).toHaveLength(1)
      })

      it('imports an unreleased event without a date as hidden with no dates', async () => {
        await importFrom(upstream({ ...undated, released: false }))

        expect(stored().visible).toBe(false)
        expect(storedDates()).toEqual([])
      })

      it('does not import an event whose end date is in the past', async () => {
        await importFrom(upstream(past))

        expect(veranstaltungen()).toEqual([])
      })

      it('does not import a non-public event', async () => {
        await importFrom(upstream({ area: 'user' }))

        expect(veranstaltungen()).toEqual([])
      })
    })

    describe('unlocked events', () => {
      it('shows an event once iKISS adds a date', async () => {
        await importFrom(upstream(undated))

        await importFrom(upstream({ ...bumped }))

        expect(stored().visible).toBe(true)
        expect(storedDates()).toHaveLength(1)
      })

      it('shows an event once iKISS releases it', async () => {
        await importFrom(upstream({ released: false }))

        await importFrom(upstream({ ...bumped }))

        expect(stored().visible).toBe(true)
      })

      it('picks up a release change that does not bump update_date', async () => {
        await importFrom(upstream({ released: false }))

        await importFrom(upstream({ released: true }))

        expect(stored().visible).toBe(true)
      })

      it('hides an event once iKISS un-releases it', async () => {
        await importFrom(upstream())

        await importFrom(upstream({ released: false, ...bumped }))

        expect(stored().visible).toBe(false)
      })

      it('hides an event and clears its dates once iKISS removes the date', async () => {
        await importFrom(upstream())

        await importFrom(upstream({ ...undated, ...bumped }))

        expect(stored().visible).toBe(false)
        expect(storedDates()).toEqual([])
      })

      it('deletes an event once it has ended', async () => {
        await importFrom(upstream())

        await importFrom(upstream(past))

        expect(veranstaltungen()).toEqual([])
      })
    })

    describe('events edited by an editor', () => {
      beforeEach(async () => {
        await importFrom(upstream(undated))
        editorPublishesWithDate()
      })

      it('keeps the editor version while iKISS still has no date', async () => {
        const before = structuredClone(stored())

        await importFrom(upstream({ ...undated, ...bumped }))

        expect(veranstaltungOperations()).toEqual([])
        expect(stored()).toEqual(before)
      })

      it('ignores a different future date from iKISS', async () => {
        const before = structuredClone(stored())

        await importFrom(upstream({ ...laterDate, ...bumped }))

        expect(veranstaltungOperations()).toEqual([])
        expect(stored()).toEqual(before)
      })

      it('is deleted despite the lock when iKISS no longer lists it', async () => {
        await importFrom(upstream({ id: '3767.other.1', title: 'Other' }))

        expect(veranstaltungen().map((doc) => doc.id)).toEqual(['3767.other.1'])
      })

      it('is deleted despite the lock when the iKISS date has passed', async () => {
        expect(storedDates()).toEqual(editorDates)

        await importFrom(upstream(past))

        expect(veranstaltungen()).toEqual([])
      })

      it('is deleted despite the lock when iKISS has no events at all', async () => {
        handler = () => terrorResponse(4043)

        await runImport()

        expect(veranstaltungen()).toEqual([])
      })

      it('stays hidden after a typo fix even if iKISS later adds a date and releases it', async () => {
        await importFrom(upstream({ ...undated, released: false }))
        editorSaves({ titel: 'A (fixed)', visible: false })

        await importFrom(upstream({ released: true, ...bumped }))

        expect(stored().visible).toBe(false)
        expect(stored().titel).toBe('A (fixed)')
      })

      it('is overwritten by the next import once the lock is removed', async () => {
        Object.assign(stored(), { lockedForImport: false })

        await importFrom(upstream({ ...undated, ...bumped }))

        expect(stored().visible).toBe(false)
        expect(storedDates()).toEqual([])
      })
    })
  })
})
