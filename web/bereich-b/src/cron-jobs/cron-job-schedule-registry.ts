import { tryParseIntervalSeconds } from './cron-schedule-parser'

const intervalSecondsByJob = new Map<string, number>()

export function registerCronJobSchedule(jobName: string, cronExpression: string): void {
  if (!cronExpression.trim()) {
    return
  }

  const intervalSeconds = tryParseIntervalSeconds(cronExpression)
  if (intervalSeconds !== null) {
    intervalSecondsByJob.set(jobName, intervalSeconds)
  }
}

export function getCronJobIntervalSeconds(jobName: string): number | undefined {
  return intervalSecondsByJob.get(jobName)
}

export function resetCronJobScheduleRegistryForTesting(): void {
  intervalSecondsByJob.clear()
}
