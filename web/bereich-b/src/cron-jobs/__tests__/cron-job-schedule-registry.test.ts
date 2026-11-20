import { afterEach, describe, expect, test } from 'vitest'
import {
  getCronJobIntervalSeconds,
  registerCronJobSchedule,
  resetCronJobScheduleRegistryForTesting,
} from '../cron-job-schedule-registry'

describe('cron job schedule registry', () => {
  afterEach(() => {
    resetCronJobScheduleRegistryForTesting()
  })

  test('stores parsed interval', () => {
    registerCronJobSchedule('import_integrations', '*/10 * * * *')

    expect(getCronJobIntervalSeconds('import_integrations')).toBe(600)
  })

  test('ignores unknown cron expression', () => {
    registerCronJobSchedule('unknown_job', 'at midnight on tuesdays')

    expect(getCronJobIntervalSeconds('unknown_job')).toBeUndefined()
  })
})
