import { describe, expect, it } from 'vitest'
import { formatSensorArtTitle } from './sensor-art'

describe('formatSensorArtTitle', () => {
  it('keeps the composite title and trims both parts', () => {
    expect(formatSensorArtTitle({ name: ' Pegelstand ', einheit: ' cm ' })).toBe('Pegelstand (cm)')
  })

  it('does not throw when projected dependencies are missing', () => {
    expect(formatSensorArtTitle({ name: 'Luftdruck', einheit: undefined! })).toBe('Luftdruck')
    expect(formatSensorArtTitle({ name: undefined!, einheit: undefined! })).toBe('')
  })
})
