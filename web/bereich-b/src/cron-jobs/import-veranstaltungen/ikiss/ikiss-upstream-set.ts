import { type IkissEvent } from '../../../integrations/ikiss/ikiss-events'
import { resolveEventPeriod } from './ikiss-dates'

export const selectUpstreamSet = (
  events: IkissEvent[],
  now: Date,
  timeZone: string,
): IkissEvent[] =>
  events.filter((event) => {
    if (event.area !== 'internet') return false
    const period = resolveEventPeriod(event, timeZone)
    return !period || period.end >= now
  })
