import { describe, expect, it } from 'vitest'
import { isLageHelferSeedEnabled } from '../is-lagehelfer-seed-enabled'

describe('isLageHelferSeedEnabled', () => {
  it('is disabled by default', () => {
    expect(isLageHelferSeedEnabled()).toBe(false)
  })

  it.each(['false', '', '1', 'TRUE', 'yes'])(
    'is disabled for ENABLE_LAGEHELFER_SEED=%j',
    (value) => {
      expect(isLageHelferSeedEnabled({ ENABLE_LAGEHELFER_SEED: value })).toBe(false)
    },
  )

  it('is enabled only for the exact value "true"', () => {
    expect(isLageHelferSeedEnabled({ ENABLE_LAGEHELFER_SEED: 'true' })).toBe(true)
  })

  it('is independent of ENABLE_DATASEEDER', () => {
    const env = { ENABLE_DATASEEDER: 'true' } as { ENABLE_LAGEHELFER_SEED?: string }
    expect(isLageHelferSeedEnabled(env)).toBe(false)
  })
})
