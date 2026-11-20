/** Parses node-cron expressions used in bereich-b into an expected interval. */
const MINUTES_STEP_PATTERN = /^\*\/(\d+)$/
const HOURS_STEP_PATTERN = /^\*\/(\d+)$/

/**
 * Returns the expected interval in seconds for simple periodic schedules, or null if unknown.
 * Supports the cron patterns used by bereich-b node-cron jobs (e.g. every N minutes/hours).
 */
export function tryParseIntervalSeconds(cronExpression: string): number | null {
  const parts = cronExpression.trim().split(/\s+/)
  if (parts.length < 5) {
    return null
  }

  const [minutes, hours] = parts

  const minutesMatch = MINUTES_STEP_PATTERN.exec(minutes)
  if (minutesMatch) {
    return Number.parseInt(minutesMatch[1], 10) * 60
  }

  const hoursMatch = HOURS_STEP_PATTERN.exec(hours)
  if (minutes === '0' && hoursMatch) {
    return Number.parseInt(hoursMatch[1], 10) * 3600
  }

  if (minutes === '0' && hours === '*') {
    return 3600
  }

  if (minutes === '0' && hours === '0') {
    return 86400
  }

  return null
}
