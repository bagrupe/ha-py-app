import { describe, it, expect } from 'vitest'
import { isSuperAdmin } from './is-super-admin'

describe('isSuperAdmin', () => {
  it('returns true when isSuperAdmin is true', () => {
    expect(isSuperAdmin({ isSuperAdmin: true })).toBe(true)
  })

  it('returns false when isSuperAdmin is false', () => {
    expect(isSuperAdmin({ isSuperAdmin: false })).toBe(false)
  })

  it('returns false for null', () => {
    expect(isSuperAdmin(null)).toBe(false)
  })

  it('returns false for undefined', () => {
    expect(isSuperAdmin(undefined)).toBe(false)
  })

  it('returns false for object without isSuperAdmin property', () => {
    expect(isSuperAdmin({})).toBe(false)
  })
})
