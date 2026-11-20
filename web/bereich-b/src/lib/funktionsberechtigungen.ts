export enum Funktionsberechtigung {
  BackofficeNutzendenverwaltung = 'BackofficeNutzendenverwaltung',
  BackofficeAntraege = 'BackofficeAntraege',
  Backoffice = 'Backoffice',
  BackofficeDienstleisterverwaltung = 'BackofficeDienstleisterverwaltung',
  Inhaltspflege = 'Inhaltspflege',
  InhaltspflegeNewsArtikel = 'InhaltspflegeNewsArtikel',
  InhaltspflegeWettermesspunkte = 'InhaltspflegeWettermesspunkte',
  InhaltspflegeGeoflaechen = 'InhaltspflegeGeoflaechen',
  InhaltspflegePois = 'InhaltspflegePois',
  InhaltspflegeIntegrationen = 'InhaltspflegeIntegrationen',
  InhaltspflegeVeranstaltungen = 'InhaltspflegeVeranstaltungen',
  InhaltspflegeSensoren = 'InhaltspflegeSensoren',
  InhaltspflegeAufrufe = 'InhaltspflegeAufrufe',
}

export type WithFunktionsberechtigungen = { funktionsberechtigungen?: Funktionsberechtigung[] }

export const funktionsberechtigungenOf = (custom: unknown): Funktionsberechtigung[] | undefined =>
  (custom as WithFunktionsberechtigungen | undefined)?.funktionsberechtigungen

export const hasAnyFunktionsberechtigung = (
  granted: unknown,
  required: readonly Funktionsberechtigung[],
): boolean => Array.isArray(granted) && required.some((f) => granted.includes(f))
