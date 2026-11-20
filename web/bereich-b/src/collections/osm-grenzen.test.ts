import { describe, expect, it } from 'vitest'
import { wrapAccess, wrapHidden } from '../plugins/default-access-control'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import { mockOeUser, mockSuperAdmin, readArgs } from '../access/__tests__/mock-factories'
import { OsmGrenzen } from './osm-grenzen'

describe('osm-grenzen', () => {
  const operations = ['read', 'create', 'update', 'delete'] as const

  it.each(operations)('denies %s for anonymous and regular backoffice users', async (operation) => {
    const access = wrapAccess(operation, OsmGrenzen)
    const regularUser = mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege])

    expect(await access(readArgs(undefined))).toBe(false)
    expect(await access(readArgs(regularUser))).toBe(false)
  })

  it('allows super admins to read and delete entries', async () => {
    const superAdmin = mockSuperAdmin()

    expect(await wrapAccess('read', OsmGrenzen)(readArgs(superAdmin))).toBe(true)
    expect(await wrapAccess('delete', OsmGrenzen)(readArgs(superAdmin))).toBe(true)
  })

  it('is only visible in the admin UI to super admins', () => {
    const hidden = wrapHidden(OsmGrenzen) as ({ user }: { user: unknown }) => boolean

    expect(hidden({ user: mockSuperAdmin() })).toBe(false)
    expect(hidden({ user: mockOeUser('oe-1', [Funktionsberechtigung.Inhaltspflege]) })).toBe(true)
    expect(hidden({ user: undefined })).toBe(true)
  })

  it('is not exposed through GraphQL', () => {
    expect(OsmGrenzen.graphQL).toBe(false)
  })
})
