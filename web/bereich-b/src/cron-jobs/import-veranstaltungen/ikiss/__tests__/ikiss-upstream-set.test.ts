import { describe, expect, it } from 'vitest'
import { type IkissEvent } from '../../../../integrations/ikiss/ikiss-events'
import { selectUpstreamSet } from '../ikiss-upstream-set'

const now = new Date('2026-10-26T10:00:00Z')
const timeZone = 'Europe/Berlin'

const event = (id: string, overrides: Partial<IkissEvent> = {}): IkissEvent => ({
  id,
  title: id,
  datetimeFrom: '2026-11-01 10:00:00',
  datetimeTo: '2026-11-01 12:00:00',
  released: true,
  area: 'internet',
  ...overrides,
})

const ids = (events: IkissEvent[]) => events.map((e) => e.id)

describe('iKISS Veranstaltung upstream set', () => {
  it('keeps every public event that has not explicitly ended', () => {
    const events = [
      event('unreleased', { released: false }),
      event('area-user', { area: 'user' }),
      event('area-intranet', { area: 'intranet' }),
      event('area-unknown', { area: undefined }),
      event('undated', { datetimeFrom: '0000-00-00 00:00:00', datetimeTo: '0000-00-00 00:00:00' }),
      event('ended-yesterday', {
        datetimeFrom: '2026-10-25 16:00:00',
        datetimeTo: '2026-10-25 18:00:00',
      }),
      event('ends-later-today', {
        datetimeFrom: '2026-10-26 08:00:00',
        datetimeTo: '2026-10-26 22:00:00',
      }),
      event('future'),
    ]

    const upstreamSet = selectUpstreamSet(events, now, timeZone)

    expect(ids(upstreamSet)).toEqual(['unreleased', 'undated', 'ends-later-today', 'future'])
  })
})
