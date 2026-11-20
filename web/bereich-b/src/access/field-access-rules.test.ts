import { describe, it, expect } from 'vitest'
import { fieldAccessRules } from './field-access-rules'
import { mockSuperAdmin, mockOeUser, readArgs } from './__tests__/mock-factories'

describe('fieldAccessRules', () => {
  describe('superAdmin', () => {
    it('returns true for superadmin, false otherwise', () => {
      expect(fieldAccessRules.superAdmin(readArgs(mockSuperAdmin()))).toBe(true)
      expect(fieldAccessRules.superAdmin(readArgs(mockOeUser()))).toBe(false)
    })
  })

  describe('forbidden', () => {
    it('always returns false', () => {
      expect(fieldAccessRules.forbidden(readArgs(mockSuperAdmin()))).toBe(false)
      expect(fieldAccessRules.forbidden(readArgs(null))).toBe(false)
    })
  })
})
