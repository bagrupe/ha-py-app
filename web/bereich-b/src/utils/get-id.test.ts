import { describe, it, expect } from 'vitest'
import { getId } from './get-id'

describe('getId', () => {
  it('returns the string as-is for string input', () => {
    expect(getId('abc-123')).toBe('abc-123')
  })

  it('returns .id for object input', () => {
    expect(getId({ id: 'obj-456' })).toBe('obj-456')
  })

  it('returns undefined for null input', () => {
    expect(getId(null)).toBeUndefined()
  })

  it('returns undefined for undefined input', () => {
    expect(getId(undefined)).toBeUndefined()
  })
})
