import { getId } from '../utils/get-id'
import { isSuperAdmin } from '../utils/is-super-admin'

export const hasFunktionsberechtigung = (
  user: unknown,
  funktionsberechtigung: string,
  organisationseinheitId?: string,
): boolean => {
  if (!user) return false
  if (isSuperAdmin(user)) return true

  const { organisationseinheiten = [] } = user as {
    organisationseinheiten: {
      funktionsberechtigungen: string[]
      organisationseinheit: string | { id: string }
    }[]
  }

  for (const oe of organisationseinheiten) {
    if (
      organisationseinheitId &&
      (!oe.organisationseinheit || getId(oe.organisationseinheit) != organisationseinheitId)
    ) {
      continue
    }
    if (oe.funktionsberechtigungen.includes(funktionsberechtigung)) {
      return true
    }
  }
  return false
}
