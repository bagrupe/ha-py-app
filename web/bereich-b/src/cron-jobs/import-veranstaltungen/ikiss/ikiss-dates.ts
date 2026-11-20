import { TZDate } from '@date-fns/tz'
import { type IkissEvent } from '../../../integrations/ikiss/ikiss-events'

export const IKISS_TIME_ZONE = 'Europe/Berlin'

export type EventPeriod = { start: Date; end: Date }

const NAIVE_TIMESTAMP = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/

export const parseIkissTimestamp = (value: string, timeZone: string): Date | undefined => {
  const match = NAIVE_TIMESTAMP.exec(value.trim())
  if (!match) return undefined
  const [year, month, day, hours, minutes, seconds] = match.slice(1).map(Number)
  if (year === 0 || month === 0 || day === 0) return undefined
  const parsed = new TZDate(year, month - 1, day, hours, minutes, seconds, 0, timeZone)
  return Number.isNaN(parsed.getTime()) ? undefined : new Date(parsed.getTime())
}

export const resolveEventPeriod = (
  event: Pick<IkissEvent, 'datetimeFrom' | 'datetimeTo'>,
  timeZone: string,
): EventPeriod | undefined => {
  const start = event.datetimeFrom && parseIkissTimestamp(event.datetimeFrom, timeZone)
  if (!start) return undefined
  const end = event.datetimeTo && parseIkissTimestamp(event.datetimeTo, timeZone)
  return { start, end: end && end > start ? end : start }
}
