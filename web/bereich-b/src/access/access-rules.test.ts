import { describe, it, expect, vi } from 'vitest'
import { accessRules, composeAccessRules, ACCESS_SKIP_FOLLOWING_RULES } from './access-rules'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import {
  mockSuperAdmin,
  mockOeUser,
  mockMultiOeUser,
  mockKommuneAdmin,
  mockApiSyncUser,
  readArgs,
  writeArgs,
} from './__tests__/mock-factories'

describe('authenticated', () => {
  it('returns true when user is present', () => {
    expect(accessRules.authenticated(readArgs(mockOeUser()))).toBe(true)
  })

  it('returns false when user is null', () => {
    expect(accessRules.authenticated(readArgs(null))).toBe(false)
  })

  it('returns false when user is undefined', () => {
    expect(accessRules.authenticated(readArgs(undefined))).toBe(false)
  })
})

describe('publicRead', () => {
  const anonymousWhere = { visible: { equals: true } }
  const read = accessRules.publicRead(anonymousWhere)

  it('returns the public filter for anonymous requests', () => {
    expect(read(readArgs(null))).toEqual(anonymousWhere)
  })

  it('allows authenticated requests without the public filter', () => {
    expect(read(readArgs(mockOeUser()))).toBe(true)
  })

  it('evaluates dynamic public filters per request', () => {
    const dynamicWhere = vi.fn(() => anonymousWhere)
    const dynamicRead = accessRules.publicRead(dynamicWhere)

    expect(dynamicRead(readArgs(null))).toEqual(anonymousWhere)
    expect(dynamicWhere).toHaveBeenCalledTimes(1)
    expect(dynamicRead(readArgs(mockOeUser()))).toBe(true)
    expect(dynamicWhere).toHaveBeenCalledTimes(1)
  })
})

describe('versionsWithFunktionsberechtigung', () => {
  const readVersions = accessRules.versionsWithFunktionsberechtigung(
    Funktionsberechtigung.InhaltspflegeNewsArtikel,
  )

  it('denies anonymous requests', () => {
    expect(readVersions(readArgs(null))).toBe(false)
  })

  it('denies authenticated users without the Funktionsberechtigung', () => {
    expect(readVersions(readArgs(mockOeUser()))).toBe(false)
  })

  it('scopes permitted users to their own Kommune', () => {
    const user = mockOeUser('oe-1', [Funktionsberechtigung.InhaltspflegeNewsArtikel])

    expect(readVersions(readArgs(user))).toEqual({
      'version.kommune': { equals: 'kommune-1' },
    })
  })

  it('scopes superadmins to their Kommune without requiring the Funktionsberechtigung', () => {
    expect(readVersions(readArgs(mockSuperAdmin()))).toEqual({
      'version.kommune': { equals: 'kommune-1' },
    })
  })

  it('denies a kommune-less user that holds no Funktionsberechtigung', () => {
    expect(readVersions(readArgs(mockApiSyncUser()))).toBe(false)
  })

  it('lets a kommune-less superadmin read across tenants', () => {
    expect(readVersions(readArgs(mockSuperAdmin({ kommune: null })))).toBe(true)
  })
})

describe('superAdmin', () => {
  it('returns true for superadmin', () => {
    expect(accessRules.superAdmin(readArgs(mockSuperAdmin()))).toBe(true)
  })

  it('returns false for regular user', () => {
    expect(accessRules.superAdmin(readArgs(mockOeUser()))).toBe(false)
  })
})

describe('forbidden', () => {
  it('always returns false', () => {
    expect(accessRules.forbidden(readArgs(mockSuperAdmin()))).toBe(false)
  })
})

describe('kommune — read', () => {
  const kommuneRead = accessRules.kommune(false)
  const kommuneIsKommuneRead = accessRules.kommune(true)

  it('collectionIsKommune: false → { kommune: { equals: id } }', () => {
    const result = kommuneRead(readArgs(mockKommuneAdmin('k-1')))
    expect(result).toEqual({ kommune: { equals: 'k-1' } })
  })

  it('collectionIsKommune: true → { id: { equals: id } }', () => {
    const result = kommuneIsKommuneRead(readArgs(mockKommuneAdmin('k-1')))
    expect(result).toEqual({ id: { equals: 'k-1' } })
  })

  it('API sync user (no kommune) → {}', () => {
    const result = kommuneRead(readArgs(mockApiSyncUser()))
    expect(result).toEqual({})
  })

  it('no user → true', () => {
    const result = kommuneRead(readArgs(null))
    expect(result).toBe(true)
  })
})

describe('kommune — write', () => {
  const kommuneWrite = accessRules.kommune(false)
  const kommuneIsKommune = accessRules.kommune(true)

  it('user without kommune → true', () => {
    const result = kommuneWrite(writeArgs(mockApiSyncUser(), { kommune: 'k-1' }))
    expect(result).toBe(true)
  })

  it('matching kommune → true', () => {
    const result = kommuneWrite(writeArgs(mockKommuneAdmin('k-1'), { kommune: 'k-1' }))
    expect(result).toBe(true)
  })

  it('mismatching kommune → false', () => {
    const result = kommuneWrite(writeArgs(mockKommuneAdmin('k-1'), { kommune: 'k-2' }))
    expect(result).toBe(false)
  })

  it('doc has no kommune, collectionIsKommune: false → true', () => {
    const result = kommuneWrite(writeArgs(mockKommuneAdmin('k-1'), {}))
    expect(result).toBe(true)
  })

  it('new doc creation, collectionIsKommune: true, no id → true', () => {
    const result = kommuneIsKommune(writeArgs(mockKommuneAdmin('k-1'), { some: 'data' }))
    expect(result).toBe(true)
  })

  it('collectionIsKommune: true, id matches → true', () => {
    const result = kommuneIsKommune(
      writeArgs(mockKommuneAdmin('k-1'), { some: 'data' }, { id: 'k-1' }),
    )
    expect(result).toBe(true)
  })

  it('collectionIsKommune: true, id differs → false', () => {
    const result = kommuneIsKommune(
      writeArgs(mockKommuneAdmin('k-1'), { some: 'data' }, { id: 'k-2' }),
    )
    expect(result).toBe(false)
  })

  it('no user on write → true', () => {
    const result = kommuneWrite(writeArgs(null, { kommune: 'k-1' }))
    expect(result).toBe(true)
  })

  it('populated kommune object (via getId) → correctly extracts id', () => {
    const result = kommuneWrite(writeArgs(mockKommuneAdmin('k-1'), { kommune: { id: 'k-1' } }))
    expect(result).toBe(true)
  })
})

describe('organisationseinheit — read', () => {
  const oeRead = accessRules.organisationseinheit(false)
  const oeIsUntereinheit = accessRules.organisationseinheit(true)

  it('no user → true', () => {
    expect(oeRead(readArgs(null))).toBe(true)
  })

  it('isReadingStaticFile: true → {}', () => {
    const result = oeRead(readArgs(mockOeUser(), { isReadingStaticFile: true }))
    expect(result).toEqual({})
  })

  it('method GET with id on non-versioned collection keeps OE restriction', () => {
    const result = oeRead(readArgs(mockOeUser(), { id: 'doc-1', method: 'GET' }))
    expect(result).toEqual({ untereinheit: { in: ['oe-1'] } })
  })

  it('method GET with id on versioned collection → {}', () => {
    const user = mockOeUser()
    const result = oeRead(
      readArgs(user, {
        id: 'doc-1',
        req: { user, method: 'GET', collection: { config: { versions: { drafts: true } } } },
      }),
    )
    expect(result).toEqual({})
  })

  it('WHERE clause { untereinheit: { in: [...] } }', () => {
    const result = oeRead(readArgs(mockOeUser('oe-1')))
    expect(result).toEqual({ untereinheit: { in: ['oe-1'] } })
  })

  it('collectionIsUntereinheit: true → { id: { in: [...] } }', () => {
    const result = oeIsUntereinheit(readArgs(mockOeUser('oe-1')))
    expect(result).toEqual({ id: { in: ['oe-1'] } })
  })

  it('empty OEs after funktionsberechtigung filter → false', () => {
    const oeWithPerm = accessRules.organisationseinheit(false, [
      Funktionsberechtigung.BackofficeNutzendenverwaltung,
    ])
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(oeWithPerm(readArgs(user))).toBe(false)
  })

  it('empty OEs array → false', () => {
    const user = mockOeUser('oe-1', [], { organisationseinheiten: [] })
    expect(oeRead(readArgs(user))).toBe(false)
  })

  it('filters by funktionsberechtigung (only matching OEs included)', () => {
    const oeWithPerm = accessRules.organisationseinheit(false, [
      Funktionsberechtigung.Inhaltspflege,
    ])
    const user = mockMultiOeUser([
      {
        organisationseinheit: 'oe-1',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
      {
        organisationseinheit: 'oe-2',
        funktionsberechtigungen: [Funktionsberechtigung.BackofficeNutzendenverwaltung],
      },
    ])
    const result = oeWithPerm(readArgs(user))
    expect(result).toEqual({ untereinheit: { in: ['oe-1'] } })
  })

  it('string OE reference → correct id extraction', () => {
    const user = mockMultiOeUser([
      {
        organisationseinheit: 'oe-str',
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    expect(oeRead(readArgs(user))).toEqual({ untereinheit: { in: ['oe-str'] } })
  })

  it('object OE reference → correct id extraction', () => {
    const user = mockMultiOeUser([
      {
        organisationseinheit: { id: 'oe-obj' },
        funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
      },
    ])
    expect(oeRead(readArgs(user))).toEqual({ untereinheit: { in: ['oe-obj'] } })
  })
})

describe('organisationseinheit — write', () => {
  const oeWrite = accessRules.organisationseinheit(false)
  const oeIsUntereinheit = accessRules.organisationseinheit(true)

  it('no user → true', () => {
    expect(oeWrite(writeArgs(null, { untereinheit: 'oe-1' }))).toBe(true)
  })

  it('no untereinheit on doc, collectionIsUntereinheit: false → true', () => {
    expect(oeWrite(writeArgs(mockOeUser(), {}))).toBe(true)
  })

  it('new doc, collectionIsUntereinheit: true, no id → true', () => {
    expect(oeIsUntereinheit(writeArgs(mockOeUser(), { some: 'data' }))).toBe(true)
  })

  it('user assigned to matching OE → true', () => {
    const result = oeWrite(writeArgs(mockOeUser('oe-1'), { untereinheit: 'oe-1' }))
    expect(result).toBe(true)
  })

  it('user assigned + has required funktionsberechtigung → true', () => {
    const oeWithPerm = accessRules.organisationseinheit(false, [
      Funktionsberechtigung.Inhaltspflege,
    ])
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(oeWithPerm(writeArgs(user, { untereinheit: 'oe-1' }))).toBe(true)
  })

  it('user assigned but wrong funktionsberechtigung → false', () => {
    const oeWithPerm = accessRules.organisationseinheit(false, [
      Funktionsberechtigung.BackofficeNutzendenverwaltung,
    ])
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(oeWithPerm(writeArgs(user, { untereinheit: 'oe-1' }))).toBe(false)
  })

  it('user NOT assigned to OE → false', () => {
    const result = oeWrite(writeArgs(mockOeUser('oe-1'), { untereinheit: 'oe-2' }))
    expect(result).toBe(false)
  })

  it('user has no organisationseinheiten property → false', () => {
    const user = mockOeUser('oe-1', [], { organisationseinheiten: undefined as unknown as [] })
    expect(oeWrite(writeArgs(user, { untereinheit: 'oe-1' }))).toBe(false)
  })

  it('untereinheitId is null → true (no untereinheit on doc means unrestricted)', () => {
    const result = oeWrite(writeArgs(mockOeUser('oe-1'), { untereinheit: null }))
    expect(result).toBe(true)
  })
})

describe('composeAccessRules', () => {
  it('empty rules → true', () => {
    const composed = composeAccessRules([])
    expect(composed(readArgs(null))).toBe(true)
  })

  it('single rule passthrough', () => {
    const composed = composeAccessRules([accessRules.authenticated])
    expect(composed(readArgs(mockOeUser()))).toBe(true)
    expect(composed(readArgs(null))).toBe(false)
  })

  it('false short-circuits', async () => {
    const composed = composeAccessRules([() => false, accessRules.authenticated])
    expect(await composed(readArgs(mockOeUser()))).toBe(false)
  })

  it('true then false → false', async () => {
    const composed = composeAccessRules([() => true, () => false])
    expect(await composed(readArgs(mockOeUser()))).toBe(false)
  })

  it('ACCESS_SKIP_FOLLOWING_RULES breaks loop → true', async () => {
    const composed = composeAccessRules([() => ACCESS_SKIP_FOLLOWING_RULES, () => false])
    expect(await composed(readArgs(mockOeUser()))).toBe(true)
  })

  it('single WHERE → passthrough (single rule shortcut)', () => {
    const where = { kommune: { equals: 'k-1' } }
    const composed = composeAccessRules([() => where])
    // Single rule uses shortcut: rules[0] returned directly
    expect(composed(readArgs(mockOeUser()))).toEqual(where)
  })

  it('two WHEREs → { and: [where1, where2] }', async () => {
    const w1 = { kommune: { equals: 'k-1' } }
    const w2 = { untereinheit: { in: ['oe-1'] } }
    const composed = composeAccessRules([() => w1, () => w2])
    expect(await composed(readArgs(mockOeUser()))).toEqual({ and: [w1, w2] })
  })

  it('all true → true', async () => {
    const composed = composeAccessRules([() => true, () => true])
    expect(await composed(readArgs(mockOeUser()))).toBe(true)
  })
})
