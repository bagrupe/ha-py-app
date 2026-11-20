import { readFileSync } from 'node:fs'
import { join } from 'node:path'
import { describe, expect, it } from 'vitest'
import { parseIkissEventsResponse } from '../ikiss-events'

const fixture = (name: string) => readFileSync(join(__dirname, 'fixtures', name), 'utf-8')

describe('iKISS events response parsing', () => {
  it('parses a search response', () => {
    const searched = parseIkissEventsResponse(fixture('events-search.xml'))

    expect(searched).toMatchObject([
      {
        id: '3767.3898.1',
        title: 'WasserVision - Wasser ist Leben',
        datetimeFrom: '2025-09-15 00:00:00',
        released: false,
        area: 'internet',
      },
      { id: '3767.3950.1', title: 'Coffee & Talk for HEALTH', released: false, area: 'internet' },
    ])
  })

  it('parses a fetch response', () => {
    const [fetched] = parseIkissEventsResponse(fixture('events-fetch-3990.xml'))

    expect(fetched).toMatchObject({
      id: '3767.3990.1',
      datetimeFrom: '2026-09-25 16:00:00',
      datetimeTo: '2026-09-25 18:00:00',
      location: 'Osterstraße 46, 31785 Hameln',
      released: false,
      area: 'internet',
      image: '/media/custom/safe/3767_3464_1_t.PNG',
    })
    expect(fetched.content).toContain('<ikiss i_ma="contact-4a668fd9@example.com"')
    expect(fetched.content).toContain('<ul class=" ikiss-unordered-list">')
  })

  it('rejects a truncated response instead of reading it as an empty list', () => {
    expect(() => parseIkissEventsResponse('<ikiss><result><tevents_list>')).toThrow(
      'iKISS events response is incomplete',
    )
  })

  it('reads a complete empty list as no events', () => {
    expect(
      parseIkissEventsResponse('<ikiss><result><tevents_list></tevents_list></result></ikiss>\n'),
    ).toEqual([])
  })
})
