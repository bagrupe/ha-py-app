export const isSuperAdmin = (benutzer: unknown): boolean =>
  benutzer != null && (benutzer as { isSuperAdmin?: boolean })?.isSuperAdmin === true
