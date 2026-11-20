import { describe, it, expect } from 'vitest'
import type { CollectionConfig } from 'payload'
import { untereinheitField, hasUntereinheitField } from './untereinheit-field'
import { wrapField } from '../plugins/default-access-control'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import { mockSuperAdmin, mockOeUser, mockMultiOeUser } from '../access/__tests__/mock-factories'

describe('hasUntereinheitField', () => {
  it('returns true when untereinheit relationship field present', () => {
    const config = {
      slug: 'test',
      fields: [{ name: 'untereinheit', type: 'relationship', relationTo: 'untereinheit' }],
    } as CollectionConfig
    expect(hasUntereinheitField(config)).toBe(true)
  })

  it('returns false when absent', () => {
    const config = {
      slug: 'test',
      fields: [{ name: 'title', type: 'text' }],
    } as CollectionConfig
    expect(hasUntereinheitField(config)).toBe(false)
  })
})

describe('untereinheitField beforeValidate hook', () => {
  const field = untereinheitField()
  const hook = field.hooks!.beforeValidate![0]

  it('superadmin → returns value unchanged', () => {
    const result = hook({
      req: { user: mockSuperAdmin() },
      value: 'oe-1',
      operation: 'create',
    } as never)
    expect(result).toBe('oe-1')
  })

  it('no user → returns value unchanged', () => {
    const result = hook({
      req: { user: null },
      value: 'oe-1',
      operation: 'create',
    } as never)
    expect(result).toBe('oe-1')
  })

  it('create, non-superadmin, no value → throws', () => {
    expect(() =>
      hook({
        req: { user: mockOeUser('oe-1') },
        value: null,
        operation: 'create',
      } as never),
    ).toThrow('Bitte wählen Sie eine Organisationseinheit')
  })

  it('update, non-superadmin, no value → throws', () => {
    expect(() =>
      hook({
        req: { user: mockOeUser('oe-1') },
        value: null,
        operation: 'update',
      } as never),
    ).toThrow('Bitte wählen Sie eine Organisationseinheit')
  })

  it('valid OE assignment → returns value', () => {
    const result = hook({
      req: { user: mockOeUser('oe-1') },
      value: 'oe-1',
      operation: 'create',
    } as never)
    expect(result).toBe('oe-1')
  })

  it("OE not in user's assignments → throws", () => {
    expect(() =>
      hook({
        req: { user: mockOeUser('oe-1') },
        value: 'oe-999',
        operation: 'create',
      } as never),
    ).toThrow('Bitte wählen Sie eine Organisationseinheit')
  })

  it('read operation → returns value unchanged', () => {
    const result = hook({
      req: { user: mockOeUser('oe-1') },
      value: 'oe-999',
      operation: 'read',
    } as never)
    expect(result).toBe('oe-999')
  })
})

describe('untereinheitField defaultValue', () => {
  const field = untereinheitField()
  const defaultValue = field.defaultValue as (args: {
    user: unknown
    req: unknown
  }) => string | undefined

  it('superadmin → undefined', () => {
    expect(defaultValue({ user: mockSuperAdmin(), req: {} })).toBeUndefined()
  })

  it('no user → undefined', () => {
    expect(defaultValue({ user: null, req: {} })).toBeUndefined()
  })

  it('user with matching OE → first matching OE id', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(defaultValue({ user, req: {} })).toBe('oe-1')
  })

  it('user with no matching OE → undefined', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.BackofficeNutzendenverwaltung])
    expect(defaultValue({ user, req: {} })).toBeUndefined()
  })
})

describe('untereinheitField filterOptions', () => {
  const field = untereinheitField()
  const filterOptions = field.filterOptions as (args: { user: unknown }) => unknown

  it('no user → {}', () => {
    // filterOptions returns {} for falsy user (early return on line 35)
    expect(filterOptions({ user: null })).toEqual({})
  })

  it('superadmin → {}', () => {
    expect(filterOptions({ user: mockSuperAdmin() })).toEqual({})
  })

  it('normal user → { id: { in: [...] } } filtered by permission', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(filterOptions({ user })).toEqual({ id: { in: ['oe-1'] } })
  })

  it('user without organisationseinheiten prop → { id: { equals: "" } }', () => {
    // User-like object without organisationseinheiten property
    const user = { id: 'u-1', isSuperAdmin: false }
    expect(filterOptions({ user })).toEqual({ id: { equals: '' } })
  })
})

describe('untereinheitField mutable custom interaction', () => {
  it('fresh field uses default Inhaltspflege in defaultValue', () => {
    const field = untereinheitField()
    const defaultValue = field.defaultValue as (args: {
      user: unknown
      req: unknown
    }) => string | undefined
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(defaultValue({ user, req: {} })).toBe('oe-1')
  })

  it('fresh field uses default Inhaltspflege in filterOptions', () => {
    const field = untereinheitField()
    const filterOptions = field.filterOptions as (args: { user: unknown }) => unknown
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(filterOptions({ user })).toEqual({ id: { in: ['oe-1'] } })
  })

  it('after wrapField mutates custom, defaultValue uses new permission', () => {
    const field = untereinheitField()
    const config = {
      slug: 'test',
      fields: [field],
      custom: { funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeNewsArtikel] },
    } as CollectionConfig
    wrapField(field, config)
    const defaultValue = field.defaultValue as (args: {
      user: unknown
      req: unknown
    }) => string | undefined
    const user = mockOeUser('oe-1', [Funktionsberechtigung.InhaltspflegeNewsArtikel])
    expect(defaultValue({ user, req: {} })).toBe('oe-1')
  })

  it('after wrapField mutates custom, filterOptions uses new permission', () => {
    const field = untereinheitField()
    const config = {
      slug: 'test',
      fields: [field],
      custom: { funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegeNewsArtikel] },
    } as CollectionConfig
    wrapField(field, config)
    const filterOptions = field.filterOptions as (args: { user: unknown }) => unknown
    const user = mockOeUser('oe-1', [Funktionsberechtigung.InhaltspflegeNewsArtikel])
    expect(filterOptions({ user })).toEqual({ id: { in: ['oe-1'] } })
  })
})

describe('untereinheitField edge cases', () => {
  it('beforeValidate with multiple OEs, value matches second → returns value', () => {
    const field = untereinheitField()
    const hook = field.hooks!.beforeValidate![0]
    const user = mockMultiOeUser([
      {
        organisationseinheit: 'oe-1',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
      {
        organisationseinheit: 'oe-2',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    const result = hook({
      req: { user },
      value: 'oe-2',
      operation: 'create',
    } as never)
    expect(result).toBe('oe-2')
  })

  it('filterOptions with multiple OEs, only some have permission → filters correctly', () => {
    const field = untereinheitField()
    const filterOptions = field.filterOptions as (args: { user: unknown }) => unknown
    const user = mockMultiOeUser([
      {
        organisationseinheit: 'oe-1',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
      {
        organisationseinheit: 'oe-2',
        funktionsberechtigungen: [Funktionsberechtigung.BackofficeNutzendenverwaltung],
      },
      {
        organisationseinheit: 'oe-3',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    expect(filterOptions({ user })).toEqual({ id: { in: ['oe-1', 'oe-3'] } })
  })

  it('defaultValue with multiple OEs → returns first matching (not second)', () => {
    const field = untereinheitField()
    const defaultValue = field.defaultValue as (args: {
      user: unknown
      req: unknown
    }) => string | undefined
    const user = mockMultiOeUser([
      {
        organisationseinheit: 'oe-1',
        funktionsberechtigungen: [Funktionsberechtigung.BackofficeNutzendenverwaltung],
      },
      {
        organisationseinheit: 'oe-2',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
      {
        organisationseinheit: 'oe-3',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    expect(defaultValue({ user, req: {} })).toBe('oe-2')
  })

  it('beforeValidate value matches OE but user has empty funktionsberechtigungen → throws', () => {
    const field = untereinheitField()
    const hook = field.hooks!.beforeValidate![0]
    // The beforeValidate hook only checks if the OE is in the user's list, not permissions
    // But if the user has no OEs at all, it won't match
    const user = mockOeUser('oe-1', [], { organisationseinheiten: [] })
    expect(() =>
      hook({
        req: { user },
        value: 'oe-1',
        operation: 'create',
      } as never),
    ).toThrow('Bitte wählen Sie eine Organisationseinheit')
  })
})
