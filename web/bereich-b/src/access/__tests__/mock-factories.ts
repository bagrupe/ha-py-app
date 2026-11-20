import type { Benutzer } from '../../payload-types'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'

type MockOe = {
  organisationseinheit: string | { id: string }
  funktionsberechtigungen: string[]
}

type MockUser = Omit<Partial<Benutzer>, 'organisationseinheiten'> & {
  isSuperAdmin?: boolean
  kommune?: string | { id: string } | null
  organisationseinheiten?: MockOe[]
}

export const mockSuperAdmin = (overrides?: Partial<MockUser>): MockUser => ({
  id: 'super-1',
  isSuperAdmin: true,
  kommune: 'kommune-1',
  organisationseinheiten: [],
  ...overrides,
})

export const mockKommuneAdmin = (
  kommuneId = 'kommune-1',
  overrides?: Partial<MockUser>,
): MockUser => ({
  id: 'kadmin-1',
  isSuperAdmin: false,
  kommune: kommuneId,
  organisationseinheiten: [
    {
      organisationseinheit: 'oe-1',
      funktionsberechtigungen: [Funktionsberechtigung.Inhaltspflege],
    },
  ],
  ...overrides,
})

export const mockOeUser = (
  oeId = 'oe-1',
  permissions: string[] = [Funktionsberechtigung.Inhaltspflege],
  overrides?: Partial<MockUser>,
): MockUser => ({
  id: 'oe-user-1',
  isSuperAdmin: false,
  kommune: 'kommune-1',
  organisationseinheiten: [
    {
      organisationseinheit: oeId,
      funktionsberechtigungen: permissions,
    },
  ],
  ...overrides,
})

export const mockMultiOeUser = (oes: MockOe[], overrides?: Partial<MockUser>): MockUser => ({
  id: 'multi-oe-1',
  isSuperAdmin: false,
  kommune: 'kommune-1',
  organisationseinheiten: oes,
  ...overrides,
})

export const mockApiSyncUser = (): MockUser => ({
  id: 'api-sync-1',
  isSuperAdmin: false,
  kommune: null,
  organisationseinheiten: undefined,
})

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyAccessArgs = any

export const readArgs = (
  user: MockUser | null | undefined,
  overrides?: Record<string, unknown>,
): AnyAccessArgs => ({
  data: undefined,
  id: overrides?.id ?? undefined,
  isReadingStaticFile: overrides?.isReadingStaticFile ?? false,
  req: {
    user: user as unknown,
    method: overrides?.method ?? 'GET',
    ...(overrides?.req as object),
  },
  ...overrides,
})

export const writeArgs = (
  user: MockUser | null | undefined,
  data: Record<string, unknown> | undefined,
  overrides?: Record<string, unknown>,
): AnyAccessArgs => ({
  data,
  id: overrides?.id ?? undefined,
  isReadingStaticFile: false,
  req: {
    user: user as unknown,
    method: overrides?.method ?? 'POST',
    ...(overrides?.req as object),
  },
  ...overrides,
})
