import { tz } from '@date-fns/tz'
import { addDays, endOfDay, startOfDay } from 'date-fns'
import { describe, expect, test } from 'vitest'

const KOMMUNE_TZ = tz('Europe/Berlin')

const utc = (year: number, month: number, day: number, hour = 0, minute = 0): Date =>
  new Date(Date.UTC(year, month - 1, day, hour, minute))

describe('import-weather Berlin-day bucketing', () => {
  test('summer/CEST (UTC+2): 22:00 UTC starts the next Berlin day', () => {
    expect(startOfDay(utc(2025, 7, 25, 22, 0), { in: KOMMUNE_TZ }).toISOString()).toBe(
      '2025-07-26T00:00:00.000+02:00',
    )
    expect(startOfDay(utc(2025, 7, 25, 21, 0), { in: KOMMUNE_TZ }).toISOString()).toBe(
      '2025-07-25T00:00:00.000+02:00',
    )
  })

  test('winter/CET (UTC+1): 23:00 UTC starts the next Berlin day', () => {
    expect(startOfDay(utc(2025, 1, 25, 23, 0), { in: KOMMUNE_TZ }).toISOString()).toBe(
      '2025-01-26T00:00:00.000+01:00',
    )
    expect(startOfDay(utc(2025, 1, 25, 22, 0), { in: KOMMUNE_TZ }).toISOString()).toBe(
      '2025-01-25T00:00:00.000+01:00',
    )
  })

  test('forecast cutoff is end-of-day Berlin, two days after now', () => {
    const cutoff = endOfDay(addDays(utc(2025, 4, 27, 12, 0), 2), {
      in: KOMMUNE_TZ,
    })
    expect(cutoff.toISOString()).toBe('2025-04-29T23:59:59.999+02:00')
  })
})
