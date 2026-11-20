import { afterEach, beforeEach, describe, expect, test, vi } from 'vitest'
import {
  registerCronJobSchedule,
  resetCronJobScheduleRegistryForTesting,
} from '../cron-job-schedule-registry'
import { recordCronJobRun, resetCronJobMetricsForTesting } from '../metrics'

describe('cron job metrics', () => {
  const originalFetch = global.fetch
  const originalPushgatewayUrl = process.env['PUSHGATEWAY_URL']
  const originalEnvironment = process.env['ENVIRONMENT']

  beforeEach(() => {
    resetCronJobScheduleRegistryForTesting()
    resetCronJobMetricsForTesting()
    process.env['PUSHGATEWAY_URL'] = 'http://pushgateway'
    process.env['ENVIRONMENT'] = 'testing'
  })

  afterEach(() => {
    global.fetch = originalFetch
    resetCronJobScheduleRegistryForTesting()
    resetCronJobMetricsForTesting()

    if (originalPushgatewayUrl === undefined) {
      delete process.env['PUSHGATEWAY_URL']
    } else {
      process.env['PUSHGATEWAY_URL'] = originalPushgatewayUrl
    }

    if (originalEnvironment === undefined) {
      delete process.env['ENVIRONMENT']
    } else {
      process.env['ENVIRONMENT'] = originalEnvironment
    }
  })

  test('does nothing without pushgateway url', async () => {
    delete process.env['PUSHGATEWAY_URL']
    const fetchMock = vi.fn()
    global.fetch = fetchMock

    await recordCronJobRun('import_weather', true, 1.2)

    expect(fetchMock).not.toHaveBeenCalled()
  })

  test('pushes run metrics with instance label and expected interval', async () => {
    registerCronJobSchedule('import_integrations', '*/10 * * * *')

    let requestUrl = ''
    let requestBody = ''
    global.fetch = vi.fn(async (url, init) => {
      requestUrl = String(url)
      requestBody = String(init?.body)
      return new Response('', { status: 200 })
    })

    await recordCronJobRun('import_integrations', false, 1.5, 2)

    expect(requestUrl).toBe(
      'http://pushgateway/metrics/job/import_integrations/instance/testing-bereich-b',
    )
    expect(requestBody).toContain('cron_job_last_success{environment="testing"} 0')
    expect(requestBody).toContain('cron_job_duration_seconds{environment="testing"} 1.5')
    expect(requestBody).toContain('cron_job_items_failed_total{environment="testing"} 2')
    expect(requestBody).toContain('cron_job_expected_interval_seconds{environment="testing"} 600')
  })

  test('accumulates item failures across runs', async () => {
    const bodies: string[] = []
    global.fetch = vi.fn(async (_url, init) => {
      bodies.push(String(init?.body))
      return new Response('', { status: 200 })
    })

    await recordCronJobRun('import_weather', true, 1, 1)
    await recordCronJobRun('import_weather', true, 1, 2)

    expect(bodies[0]).toContain('cron_job_items_failed_total{environment="testing"} 1')
    expect(bodies[1]).toContain('cron_job_items_failed_total{environment="testing"} 3')
  })
})
