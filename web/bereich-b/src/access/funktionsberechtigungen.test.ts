import { describe, it, expect } from 'vitest'
import { hasFunktionsberechtigung } from './funktionsberechtigungen'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import { mockSuperAdmin, mockOeUser, mockMultiOeUser } from './__tests__/mock-factories'

describe('hasFunktionsberechtigung', () => {
  it('returns false for null user', () => {
    expect(hasFunktionsberechtigung(null, Funktionsberechtigung.Inhaltspflege)).toBe(false)
  })

  it('returns true for superadmin regardless of permission', () => {
    expect(
      hasFunktionsberechtigung(
        mockSuperAdmin(),
        Funktionsberechtigung.BackofficeNutzendenverwaltung,
      ),
    ).toBe(true)
  })

  it('returns true when permission exists in any OE (no oeId filter)', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege)).toBe(true)
  })

  it('returns false when no matching permission in any OE', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(
      hasFunktionsberechtigung(user, Funktionsberechtigung.BackofficeNutzendenverwaltung),
    ).toBe(false)
  })

  it('returns true when permission exists in specific oeId', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege, 'oe-1')).toBe(true)
  })

  it('returns false when permission exists in different oeId than filter', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege, 'oe-2')).toBe(false)
  })

  it('returns false for empty OEs array', () => {
    const user = mockOeUser('oe-1', [], { organisationseinheiten: [] })
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege)).toBe(false)
  })

  it('returns false for undefined OEs', () => {
    const user = { isSuperAdmin: false, organisationseinheiten: undefined }
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege)).toBe(false)
  })

  it('handles string OE reference correctly', () => {
    const user = mockMultiOeUser([
      {
        organisationseinheit: 'oe-str',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege, 'oe-str')).toBe(true)
  })

  it('handles object OE reference correctly', () => {
    const user = mockMultiOeUser([
      {
        organisationseinheit: { id: 'oe-obj' },
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    expect(hasFunktionsberechtigung(user, Funktionsberechtigung.Inhaltspflege, 'oe-obj')).toBe(true)
  })
})
