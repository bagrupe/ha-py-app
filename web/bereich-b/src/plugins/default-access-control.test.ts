import { describe, it, expect } from 'vitest'
import type { CollectionConfig, Config, Field, GlobalConfig } from 'payload'
import { wrapHidden, wrapAccess, wrapField, defaultAccessControl } from './default-access-control'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import {
  mockSuperAdmin,
  mockOeUser,
  mockKommuneAdmin,
  readArgs,
  writeArgs,
} from '../access/__tests__/mock-factories'

const makeCollection = (overrides?: Partial<CollectionConfig>): CollectionConfig => ({
  slug: 'test-collection',
  fields: [],
  ...overrides,
})

const makeGlobal = (overrides?: Partial<GlobalConfig>): GlobalConfig => ({
  slug: 'test-global',
  fields: [],
  ...overrides,
})

describe('wrapHidden', () => {
  it('returns custom admin.hidden if already set', () => {
    const config = makeCollection({ admin: { hidden: true } })
    expect(wrapHidden(config)).toBe(true)
  })

  it('uses config.custom.funktionsberechtigungen when specified', () => {
    const config = makeCollection({
      custom: { funktionsberechtigungen: [Funktionsberechtigung.BackofficeNutzendenverwaltung] },
    })
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    const user = mockOeUser('oe-1', [Funktionsberechtigung.BackofficeNutzendenverwaltung])
    expect(hidden({ user })).toBe(false)
  })

  it('defaults to Inhaltspflege', () => {
    const config = makeCollection()
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(hidden({ user })).toBe(false)
  })

  it('superadmin → false (not hidden)', () => {
    const config = makeCollection()
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    expect(hidden({ user: mockSuperAdmin() })).toBe(false)
  })

  it('user with matching permission → false', () => {
    const config = makeCollection()
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    const user = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])
    expect(hidden({ user })).toBe(false)
  })

  it('user without matching permission → true', () => {
    const config = makeCollection()
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    const user = mockOeUser('oe-1', [Funktionsberechtigung.BackofficeNutzendenverwaltung])
    expect(hidden({ user })).toBe(true)
  })

  it('empty organisationseinheiten → true', () => {
    const config = makeCollection()
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    const user = mockOeUser('oe-1', [], { organisationseinheiten: [] })
    expect(hidden({ user })).toBe(true)
  })

  it('organisationseinheiten: undefined → true', () => {
    const config = makeCollection()
    const hidden = wrapHidden(config) as ({ user }: { user: unknown }) => boolean
    const user = { isSuperAdmin: false, organisationseinheiten: undefined }
    expect(hidden({ user })).toBe(true)
  })
})

describe('wrapAccess', () => {
  it('unauthenticated + read → proceeds (not auto-false)', async () => {
    const config = makeCollection()
    const access = wrapAccess('read', config)
    const result = await access(readArgs(null))
    // authenticated rule returns false for null user, but read doesn't auto-false
    expect(result).toBe(false)
  })

  it('unauthenticated + create → false', async () => {
    const config = makeCollection()
    const access = wrapAccess('create', config)
    expect(await access(writeArgs(null, {}))).toBe(false)
  })

  it('unauthenticated + update → false', async () => {
    const config = makeCollection()
    const access = wrapAccess('update', config)
    expect(await access(writeArgs(null, {}))).toBe(false)
  })

  it('unauthenticated + delete → false', async () => {
    const config = makeCollection()
    const access = wrapAccess('delete', config)
    expect(await access(writeArgs(null, {}))).toBe(false)
  })

  it("slug 'kommunen' → adds kommune(true)", async () => {
    const config = makeCollection({ slug: 'kommunen' })
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockKommuneAdmin('k-1')))
    // Should have { id: { equals: 'k-1' } } from kommune(true)
    expect(result).toMatchObject({ and: expect.arrayContaining([{ id: { equals: 'k-1' } }]) })
  })

  it('has kommune field → adds kommune(false)', async () => {
    const config = makeCollection({
      fields: [{ name: 'kommune', type: 'relationship', relationTo: 'kommunen' }],
    })
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockKommuneAdmin('k-1')))
    expect(result).toMatchObject({ and: expect.arrayContaining([{ kommune: { equals: 'k-1' } }]) })
  })

  it('no kommune field/slug → no kommune rule', async () => {
    const config = makeCollection()
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockKommuneAdmin('k-1')))
    // Should just get true (authenticated passes, no kommune WHERE)
    expect(result).toBe(true)
  })

  it("slug 'untereinheit' → adds organisationseinheit(true)", async () => {
    const config = makeCollection({ slug: 'untereinheit' })
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockOeUser('oe-1')))
    expect(result).toMatchObject({ and: expect.arrayContaining([{ id: { in: ['oe-1'] } }]) })
  })

  it('has untereinheit field → adds organisationseinheit(false, ...)', async () => {
    const config = makeCollection({
      fields: [{ name: 'untereinheit', type: 'relationship', relationTo: 'untereinheit' }],
    })
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockOeUser('oe-1')))
    expect(result).toMatchObject({
      and: expect.arrayContaining([{ untereinheit: { in: ['oe-1'] } }]),
    })
  })

  it('no untereinheit field/slug → no OE rule', async () => {
    const config = makeCollection()
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockOeUser('oe-1')))
    expect(result).toBe(true)
  })

  it('uses custom access[operation] when defined', async () => {
    const customRule = () => ({ custom: { equals: 'yes' } })
    const config = makeCollection({ access: { read: customRule } })
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockOeUser()))
    // Custom rule returns a WHERE, so it gets wrapped
    expect(result).toMatchObject({ and: expect.arrayContaining([{ custom: { equals: 'yes' } }]) })
  })

  it('falls back to authenticated', async () => {
    const config = makeCollection()
    const access = wrapAccess('read', config)
    // Authenticated user with no kommune/OE rules → true from authenticated
    expect(await access(readArgs(mockOeUser()))).toBe(true)
  })

  it('kommune-bound superadmin stays tenant-scoped and skips OE rules', async () => {
    const config = makeCollection({
      fields: [
        { name: 'kommune', type: 'relationship', relationTo: 'kommunen' },
        { name: 'untereinheit', type: 'relationship', relationTo: 'untereinheit' },
      ],
    })
    const access = wrapAccess('read', config)
    const result = await access(readArgs(mockSuperAdmin()))
    expect(result).toEqual({ and: [{ kommune: { equals: 'kommune-1' } }] })
  })

  it('kommune-bound superadmin bypasses custom read access rules after tenant scoping', async () => {
    const config = makeCollection({
      fields: [{ name: 'kommune', type: 'relationship', relationTo: 'kommunen' }],
      access: {
        read: () => false,
      },
    })
    const access = wrapAccess('read', config)

    await expect(access(readArgs(mockSuperAdmin()))).resolves.toEqual({
      and: [{ kommune: { equals: 'kommune-1' } }],
    })
  })
})

describe('wrapField', () => {
  it('propagates funktionsberechtigungen from collection to field', () => {
    const field: Field = {
      name: 'test',
      type: 'text',
      custom: { funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege] },
    }
    const config = makeCollection({
      custom: { funktionsberechtigungen: [Funktionsberechtigung.BackofficeNutzendenverwaltung] },
    })
    const result = wrapField(field, config)
    expect(result.custom?.funktionsberechtigungen).toEqual([
      Funktionsberechtigung.BackofficeNutzendenverwaltung,
    ])
  })

  it('falls back to Inhaltspflege when the collection declares none', () => {
    const field: Field = {
      name: 'test',
      type: 'text',
      custom: { funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegePois] },
    }
    const result = wrapField(field, makeCollection())
    expect(result.custom?.funktionsberechtigungen).toEqual([Funktionsberechtigung.Inhaltspflege])
  })

  it('leaves field unchanged when no custom.funktionsberechtigungen', () => {
    const field: Field = { name: 'test', type: 'text' }
    const config = makeCollection()
    const result = wrapField(field, config)
    expect(result).toEqual(field)
  })

  it('leaves field unchanged when field custom is not an array', () => {
    const field: Field = { name: 'test', type: 'text', custom: { funktionsberechtigungen: 123 } }
    const config = makeCollection()
    const result = wrapField(field, config)
    expect(result.custom?.funktionsberechtigungen).toBe(123)
  })
})

describe('defaultAccessControl', () => {
  it('wraps all collections with read/create/update/delete access + hidden', () => {
    const config = {
      collections: [makeCollection({ slug: 'items', fields: [] })],
    }
    const result = defaultAccessControl(config as Config)
    const col = result.collections![0]
    expect(col.access?.read).toBeTypeOf('function')
    expect(col.access?.create).toBeTypeOf('function')
    expect(col.access?.update).toBeTypeOf('function')
    expect(col.access?.delete).toBeTypeOf('function')
    expect(col.admin?.hidden).toBeDefined()
  })

  it('wrapped collection access applies the generated tenant restriction', async () => {
    const config = {
      collections: [
        makeCollection({
          slug: 'items',
          fields: [{ name: 'kommune', type: 'relationship', relationTo: 'kommunen' }],
        }),
      ],
    }

    const result = defaultAccessControl(config as Config)
    const access = result.collections![0].access!.read!

    await expect(access(readArgs(mockKommuneAdmin('k-1')))).resolves.toEqual({
      and: [{ kommune: { equals: 'k-1' } }],
    })
  })

  it('wraps globals with read/update access', () => {
    const config = {
      globals: [makeGlobal({ slug: 'settings', fields: [] })],
    }
    const result = defaultAccessControl(config as Config)
    const glob = result.globals![0]
    expect(glob.access?.read).toBeTypeOf('function')
    expect(glob.access?.update).toBeTypeOf('function')
  })

  it('preserves existing collection properties', () => {
    const config = {
      collections: [
        makeCollection({
          slug: 'items',
          labels: { singular: 'Item', plural: 'Items' },
          fields: [{ name: 'title', type: 'text' }],
        }),
      ],
    }
    const result = defaultAccessControl(config as Config)
    const col = result.collections![0]
    expect(col.slug).toBe('items')
    expect(col.labels).toEqual({ singular: 'Item', plural: 'Items' })
    expect(col.fields).toHaveLength(1)
  })
})
