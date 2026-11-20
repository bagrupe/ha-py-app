import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest'
import { parseIkissTimestamp, resolveEventPeriod } from '../ikiss-dates'

const timeZone = 'Europe/Berlin'

describe('iKISS Veranstaltung date parsing', () => {
  beforeAll(() => {
    vi.stubEnv('TZ', 'UTC')
  })

  afterAll(() => {
    vi.unstubAllEnvs()
  })

  it('parses iKISS timestamps in the given time zone', () => {
    expect(parseIkissTimestamp('2026-01-15 16:00:00', timeZone)?.toISOString()).toBe(
      '2026-01-15T15:00:00.000Z',
    )
    expect(parseIkissTimestamp('2026-07-15 16:00:00', timeZone)?.toISOString()).toBe(
      '2026-07-15T14:00:00.000Z',
    )
  })

  it('resolves the period of an event', () => {
    const datetimeFrom = '2026-07-15 16:00:00'
    const start = new Date('2026-07-15T14:00:00.000Z')

    expect(resolveEventPeriod({ datetimeFrom }, timeZone)).toEqual({ start, end: start })
    expect(
      resolveEventPeriod({ datetimeFrom, datetimeTo: '0000-00-00 00:00:00' }, timeZone),
    ).toEqual({ start, end: start })
    expect(
      resolveEventPeriod({ datetimeFrom, datetimeTo: '2026-07-15 15:00:00' }, timeZone),
    ).toEqual({ start, end: start })
    expect(
      resolveEventPeriod({ datetimeFrom, datetimeTo: '2026-07-15 18:30:00' }, timeZone),
    ).toEqual({ start, end: new Date('2026-07-15T16:30:00.000Z') })
    expect(resolveEventPeriod({ datetimeFrom: '0000-00-00 00:00:00' }, timeZone)).toBeUndefined()
    expect(resolveEventPeriod({}, timeZone)).toBeUndefined()
  })
})
