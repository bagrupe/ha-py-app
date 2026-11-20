import { type Rolle } from '../collections/users/rollen'

export const hasRolle = (user: unknown, rolle: Rolle): boolean =>
  !!user && ((user as { rollen?: string[] })?.rollen ?? []).includes(rolle)
