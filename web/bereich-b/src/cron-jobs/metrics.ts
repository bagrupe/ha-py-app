import { schedule, type ScheduleOptions } from 'node-cron'
import { CronJobItemFailures } from './cron-job-item-failures'
import { getCronJobIntervalSeconds, registerCronJobSchedule } from './cron-job-schedule-registry'

/** Read at call time — Next.js inlines `process.env.PUSHGATEWAY_URL` at build time if read at module scope. */
function getPushgatewayUrl(): string | undefined {
  return process.env['PUSHGATEWAY_URL']
}

function getEnvironment(): string {
  return (process.env['ENVIRONMENT'] ?? process.env['SENTRY_ENVIRONMENT'] ?? 'local').toLowerCase()
}

function getPushgatewayInstance(): string {
  return `${getEnvironment()}-bereich-b`
}

type JobMetricState = {
  itemsFailedTotal: number
}

const metricStateByJob = new Map<string, JobMetricState>()

function getJobMetricState(jobName: string): JobMetricState {
  let state = metricStateByJob.get(jobName)
  if (!state) {
    state = { itemsFailedTotal: 0 }
    metricStateByJob.set(jobName, state)
  }
  return state
}

function buildMetricsPayload(
  success: boolean,
  durationSeconds: number,
  environment: string,
  itemsFailedTotal: number,
  expectedIntervalSeconds?: number,
): string {
  const timestamp = Math.floor(Date.now() / 1000)
  const lines = [
    '# TYPE cron_job_last_success gauge',
    `cron_job_last_success{environment="${environment}"} ${success ? 1 : 0}`,
    '# TYPE cron_job_last_run_timestamp gauge',
    `cron_job_last_run_timestamp{environment="${environment}"} ${timestamp}`,
    '# TYPE cron_job_duration_seconds gauge',
    `cron_job_duration_seconds{environment="${environment}"} ${durationSeconds}`,
    '# TYPE cron_job_items_failed_total counter',
    `cron_job_items_failed_total{environment="${environment}"} ${itemsFailedTotal}`,
  ]

  if (expectedIntervalSeconds !== undefined) {
    lines.push(
      '# TYPE cron_job_expected_interval_seconds gauge',
      `cron_job_expected_interval_seconds{environment="${environment}"} ${expectedIntervalSeconds}`,
    )
  }

  lines.push('')
  return lines.join('\n')
}

async function pushMetrics(
  jobName: string,
  success: boolean,
  durationSeconds: number,
  itemsFailed: number,
) {
  const pushgatewayUrl = getPushgatewayUrl()
  if (!pushgatewayUrl) {
    return
  }

  const environment = getEnvironment()
  const state = getJobMetricState(jobName)
  if (itemsFailed > 0) {
    state.itemsFailedTotal += itemsFailed
  }

  const expectedIntervalSeconds = getCronJobIntervalSeconds(jobName)
  const targetUrl = `${pushgatewayUrl.replace(/\/$/, '')}/metrics/job/${encodeURIComponent(jobName)}/instance/${encodeURIComponent(getPushgatewayInstance())}`
  const body = buildMetricsPayload(
    success,
    durationSeconds,
    environment,
    state.itemsFailedTotal,
    expectedIntervalSeconds,
  )

  try {
    const response = await fetch(targetUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'text/plain; version=0.0.4; charset=utf-8',
      },
      body,
      signal: AbortSignal.timeout(10_000),
    })

    if (!response.ok) {
      const detail = await response.text()
      console.error(
        `Failed to push cron metrics for ${jobName}: Pushgateway responded with ${response.status}: ${detail}`,
      )
    }
  } catch (error) {
    console.error(`Failed to push cron metrics for ${jobName}:`, error)
  }
}

export type CronJobTask = (failures: CronJobItemFailures) => Promise<void> | void

export function recordCronJobRun(
  jobName: string,
  success: boolean,
  durationSeconds: number,
  itemsFailed = 0,
): Promise<void> {
  return pushMetrics(jobName, success, durationSeconds, itemsFailed)
}

export const scheduleWithMetrics = (
  jobName: string,
  cronExpression: string,
  task: CronJobTask,
  options?: ScheduleOptions,
) => {
  registerCronJobSchedule(jobName, cronExpression)

  schedule(
    cronExpression,
    async () => {
      const start = Date.now()
      let success = true
      const failures = new CronJobItemFailures()

      try {
        await task(failures)
      } catch {
        success = false
      } finally {
        await pushMetrics(jobName, success, (Date.now() - start) / 1000, failures.getCount())
      }
    },
    options,
  )
}

export function logCronMetricsConfig() {
  const pushgatewayUrl = getPushgatewayUrl()
  if (pushgatewayUrl) {
    console.info(`Cron job metrics enabled — pushing to ${pushgatewayUrl}`)
  }
}

export function resetCronJobMetricsForTesting(): void {
  metricStateByJob.clear()
}
