import { beforeEach, describe, expect, test, vi } from 'vitest'
import { CronJobItemFailures } from '../cron-job-item-failures'
import type { CronJobTask } from '../metrics'

type Query = Record<string, unknown[]>
type Response = { data: unknown[] | null; error: unknown; count: number | null }
type SensorFixture = { name: string; titel: string; felder: { name: string; werteart?: string }[] }

const ok = (data: unknown[], count = data.length): Response => ({ data, error: null, count })
const failed = (): Response => ({ data: null, error: { message: 'boom' }, count: null })

const mocks = vi.hoisted(() => ({
  job: undefined as CronJobTask | undefined,
  queries: [] as Query[],
  respond: undefined as unknown as (query: Query) => Response,
  warn: vi.fn(),
  sensoren: [] as SensorFixture[],
  update: vi.fn(),
}))

vi.mock('@payload-config', () => ({ default: {} }))
vi.mock('@sentry/nextjs', () => ({
  captureException: vi.fn(),
  captureMessage: vi.fn(),
  flush: vi.fn(),
}))
vi.mock('../metrics', () => ({
  scheduleWithMetrics: (_name: string, _cron: string, task: CronJobTask) => {
    mocks.job = task
  },
}))
vi.mock('payload', () => ({
  getPayload: async () => ({
    logger: { child: () => ({ info() {}, error() {}, warn: mocks.warn }) },
    find: async ({ collection }: { collection: string }) => ({
      docs: collection === 'kommunen' ? [{ id: 'kommune-1' }] : mocks.sensoren,
    }),
    update: mocks.update,
    create: vi.fn(),
  }),
}))
vi.mock('../../lib/hapy-sensoren-client', () => ({
  CONSOLIDATED_PIPELINE_NAME: 'consolidated',
  getHapySensorenPostgrestAggregatedTable: () => 'aggregated',
  getHapySensorenPostgrestTable: () => 'raw',
  getHapySensorenClient: () => ({
    from: (table: string) => {
      const query: Query = { from: [table] }
      mocks.queries.push(query)
      const builder: object = new Proxy(
        {},
        {
          get: (_, method: string) =>
            method === 'then'
              ? (resolve: (r: Response) => void) => resolve(mocks.respond(query))
              : (...args: unknown[]) => {
                  query[method] = args
                  return builder
                },
        },
      )
      return builder
    },
  }),
}))

import { importSensoren } from '../import-sensoren'

importSensoren()

const row = (
  deviceData: Record<string, unknown>,
  device_name = 'DL-CWS2-1-Pyrmont',
  landkreisapp: string | null = 'Glättemeldeanlage Hagener Berg',
) => ({ device_name, device_data: deviceData, timestamp: '2026-10-12T09:00:00.000Z', landkreisapp })

const runJob = () => mocks.job!(new CronJobItemFailures())
const aggregatedQuery = () => mocks.queries.find((q) => q.from[0] === 'aggregated')!

describe('import-sensoren job', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mocks.queries = []
    mocks.respond = () => ok([])
    mocks.sensoren = [
      {
        name: 'DL-CWS2-1-Pyrmont',
        titel: 'Glättemeldeanlage Hagener Berg',
        felder: [{ name: 'alarm_level_last', werteart: 'glaette-id' }],
      },
    ]
  })

  test('fails the run and keeps the sensors untouched on a PostgREST error', async () => {
    mocks.respond = failed

    await expect(runJob()).rejects.toThrow()
    expect(mocks.update).not.toHaveBeenCalled()
  })

  test('fails the run when PostgREST sends no row count', async () => {
    mocks.respond = () => ({ data: [row({ alarm_level_last: 'SAFE' })], error: null, count: null })

    await expect(runJob()).rejects.toThrow('no row count')
    expect(mocks.update).not.toHaveBeenCalled()
  })

  test('warns on an empty result and keeps the sensors untouched', async () => {
    await runJob()

    expect(mocks.warn).toHaveBeenCalled()
    expect(mocks.update).not.toHaveBeenCalled()
  })

  test('reads every page instead of stopping at the PostgREST row limit', async () => {
    const rows = [
      ...Array(1000).fill(row({ alarm_level_last: 'SAFE' })),
      row({ air_temperature_mean: 3.2 }),
    ]
    mocks.respond = (query) => {
      const [from, to] = (query.range ?? [0, rows.length - 1]) as [number, number]
      return ok(rows.slice(from, to + 1), rows.length)
    }

    await runJob()

    expect(mocks.update).toHaveBeenCalledTimes(1)
    expect(mocks.update.mock.calls[0][0].data.felder).toContainEqual({
      name: 'air_temperature_mean',
    })
  })

  test('selects only the columns needed for field discovery over a recent window', async () => {
    mocks.respond = () => ok([row({ alarm_level_last: 'SAFE' })])

    await runJob()

    const query = aggregatedQuery()
    const columns = (query.select[0] as string).split(',').map((c) => c.trim())
    expect(columns).not.toContain('*')
    expect(columns).toEqual(
      expect.arrayContaining(['device_name', 'device_data', 'timestamp', 'landkreisapp']),
    )

    const start = Date.parse(query.gte[1] as string)
    expect(Date.now() - start).toBeLessThanOrEqual(24 * 60 * 60 * 1000)
  })

  test('skips a sensor without landkreisapp without counting it as a validation failure', async () => {
    mocks.sensoren.push({ name: 'Heidelbeck 1', titel: 'Heidelbeck 1', felder: [] })
    mocks.respond = () => ok([row({ water_level: 1.2 }, 'Heidelbeck 1', null)])

    await runJob()

    expect(mocks.update).not.toHaveBeenCalled()
    expect(mocks.warn).not.toHaveBeenCalled()
  })

  test('keeps a titel edited in the CMS', async () => {
    mocks.sensoren[0].titel = 'Glätte Hagener Berg'
    mocks.respond = () => ok([row({ alarm_level_last: 'SAFE', air_temperature_mean: 3.2 })])

    await runJob()

    expect(mocks.update).toHaveBeenCalledTimes(1)
    expect(mocks.update.mock.calls[0][0].data).not.toHaveProperty('titel')
  })

  test('updates only the sensor whose fields changed', async () => {
    mocks.sensoren.push({ name: 'Pegel-1', titel: 'Pegel 1', felder: [] })
    mocks.respond = () =>
      ok([row({ alarm_level_last: 'SAFE' }), row({ water_level: 1.2 }, 'Pegel-1', 'Pegel 1')])

    await runJob()

    expect(mocks.update).toHaveBeenCalledTimes(1)
    expect(mocks.update).toHaveBeenCalledWith(
      expect.objectContaining({ where: { name: { equals: 'Pegel-1' } } }),
    )
  })
})
