import { describe, expect, test } from 'vitest'
import { CronJobItemFailures } from '../cron-job-item-failures'

describe('CronJobItemFailures', () => {
  test('tracks count on recordFailure and recordFailures', () => {
    const failures = new CronJobItemFailures()

    failures.recordFailure()
    failures.recordFailures(2)
    failures.recordFailures(0)

    expect(failures.getCount()).toBe(3)
  })
})
