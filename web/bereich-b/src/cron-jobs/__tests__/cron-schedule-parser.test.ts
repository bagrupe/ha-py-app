import { describe, expect, test } from 'vitest'
import { tryParseIntervalSeconds } from '../cron-schedule-parser'

describe('tryParseIntervalSeconds', () => {
  test.each([
    ['*/10 * * * *', 600],
    ['0 * * * *', 3600],
    ['0 0 * * *', 86400],
    ['0 */2 * * *', 7200],
    ['invalid cron', null],
    ['', null],
  ] as const)('parses %s as %s', (cronExpression, expectedSeconds) => {
    expect(tryParseIntervalSeconds(cronExpression)).toBe(expectedSeconds)
  })
})
