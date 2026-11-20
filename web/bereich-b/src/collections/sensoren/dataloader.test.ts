import { type PayloadRequest } from 'payload'
import { describe, expect, it, vi } from 'vitest'

const mockQueryResult = vi.fn()

vi.mock('../../lib/hapy-sensoren-client', () => ({
  CONSOLIDATED_PIPELINE_NAME: 'consolidated',
  getHapySensorenPostgrestAggregatedTable: () => 'gold_all_in_one',
  getHapySensorenClient: () => ({
    from: () => {
      const builder = {
        select: () => builder,
        eq: () => builder,
        in: () => builder,
        order: () => builder,
        limit: () => builder,
        then: (resolve: (result: unknown) => void) => resolve(mockQueryResult()),
      }
      return builder
    },
  }),
}))

const { getSensorAlarmLevelLoader, getSensorGrenzwerteLoader } = await import('./dataloader')

const fakeRequest = () => ({ context: {} }) as unknown as PayloadRequest

describe('getSensorGrenzwerteLoader', () => {
  it('reads info_1..info_4 from device_meta of the latest consolidated row', async () => {
    mockQueryResult.mockReturnValue({
      data: [
        {
          device_name: 'R5_Remte Afferde',
          timestamp: '2026-08-11T07:00:00+00:00',
          device_meta: { info_1: 110, info_2: 190, info_3: 260, info_4: 272 },
        },
      ],
      error: null,
    })

    const result = await getSensorGrenzwerteLoader(fakeRequest()).load('R5_Remte Afferde')

    expect(result).toEqual({ info1: 110, info2: 190, info3: 260, info4: 272 })
  })

  it('returns null when device_meta is missing', async () => {
    mockQueryResult.mockReturnValue({
      data: [
        { device_name: 'H1_Hartbach', timestamp: '2026-08-11T07:00:00+00:00', device_meta: null },
      ],
      error: null,
    })

    const result = await getSensorGrenzwerteLoader(fakeRequest()).load('H1_Hartbach')

    expect(result).toBeNull()
  })

  it('returns null when the postgrest query errors', async () => {
    mockQueryResult.mockReturnValue({ data: null, error: new Error('boom') })

    const result = await getSensorGrenzwerteLoader(fakeRequest()).load('unknown-sensor')

    expect(result).toBeNull()
  })
})

describe('getSensorAlarmLevelLoader', () => {
  it('reads alarm_level_last from device_data of the latest consolidated-pipeline row', async () => {
    mockQueryResult.mockReturnValue({
      data: [
        {
          device_name: 'DL-CWS2-1-Pyrmont',
          timestamp: '2026-08-11T07:00:00+00:00',
          device_data: { alarm_level_last: 'SAFE' },
        },
      ],
      error: null,
    })

    const result = await getSensorAlarmLevelLoader(fakeRequest()).load('DL-CWS2-1-Pyrmont')

    expect(result).toBe('SAFE')
  })

  it('returns null when no row is found for the sensor', async () => {
    mockQueryResult.mockReturnValue({ data: [], error: null })

    const result = await getSensorAlarmLevelLoader(fakeRequest()).load('unknown-sensor')

    expect(result).toBeNull()
  })
})
