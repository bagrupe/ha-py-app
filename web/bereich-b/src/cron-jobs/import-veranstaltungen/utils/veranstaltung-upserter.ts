import { upsert } from '../../../dataseeder/upsert'
import { type CronJobItemFailures } from '../../cron-job-item-failures'

type ValidationFailure = { message?: string; status: 400; data: { errors: unknown[] } }

const isValidationFailure = (error: unknown): error is ValidationFailure => {
  if (typeof error !== 'object' || error === null) return false
  const { status, data } = error as { status?: unknown; data?: { errors?: unknown } }
  return status === 400 && Array.isArray(data?.errors)
}

const describeDetail = (detail: unknown): string => {
  const { path, message } = (detail ?? {}) as { path?: unknown; message?: unknown }
  return [path, message].filter((part) => typeof part === 'string' && part).join(': ')
}

export const createVeranstaltungUpserter =
  (failures: CronJobItemFailures) => async (args: Parameters<typeof upsert>[0]) => {
    try {
      await upsert(args)
    } catch (error) {
      if (!isValidationFailure(error)) throw error
      failures.recordFailure()
      const details =
        error.data.errors.map(describeDetail).filter(Boolean).join('; ') ||
        error.message ||
        'keine Details'
      console.error(
        `Veranstaltung ${String(args.data.id)} konnte nicht importiert werden: ${details}`,
      )
    }
  }
