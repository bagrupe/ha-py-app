import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type SollZustaendigkeit} from './domain-types.ts';

/**
 * Which fields an Art actually uses. `organisationseinheitId` belongs to OE *and*
 * Dienstleister; `mitarbeiterGruppeId` only to OE. The e-mail notification belongs to
 * every Art that can be notified.
 */
const FIELDS_BY_ART: Record<ZustaendigkeitArt, (keyof SollZustaendigkeit)[]> = {
  [ZustaendigkeitArt.Buerger]: [],
  [ZustaendigkeitArt.Organisationseinheit]: [
    'organisationseinheitId',
    'mitarbeiterGruppeId',
    'versendeEMailAnMitarbeiterGruppe',
  ],
  [ZustaendigkeitArt.Dienstleister]: [
    'dienstleisterId',
    'organisationseinheitId',
    'versendeEMailAnMitarbeiterGruppe',
  ],
  [ZustaendigkeitArt.Dynamisch]: [
    'liestRolleId',
    'dynamischeArten',
    'versendeEMailAnMitarbeiterGruppe',
  ],
};

const EMPTY_FIELDS: Omit<SollZustaendigkeit, 'art'> = {
  organisationseinheitId: null,
  mitarbeiterGruppeId: null,
  dienstleisterId: null,
  liestRolleId: null,
  dynamischeArten: [],
  versendeEMailAnMitarbeiterGruppe: false,
};

/**
 * Tab switch: returns the fields of the target Art. The saved configuration is restored
 * when it already has that Art, otherwise the Art starts empty, so no field of another
 * Art is carried over.
 */
export const resolveSollZustaendigkeitForArt = (
  saved: SollZustaendigkeit,
  targetArt: ZustaendigkeitArt,
): SollZustaendigkeit =>
  saved.art === targetArt
    ? projectByArt(saved, targetArt)
    : projectByArt({...EMPTY_FIELDS, art: targetArt}, targetArt);

/**
 * Reduces the selection to the fields the Art uses and resets the rest. Run once on
 * apply, so a saved step does not drag along a field of a briefly visited Art.
 */
export const projectByArt = (
  value: SollZustaendigkeit,
  art: ZustaendigkeitArt,
): SollZustaendigkeit => {
  const keep = new Set<keyof SollZustaendigkeit>(FIELDS_BY_ART[art]);
  return {
    art,
    organisationseinheitId: keep.has('organisationseinheitId')
      ? value.organisationseinheitId ?? null
      : null,
    mitarbeiterGruppeId: keep.has('mitarbeiterGruppeId')
      ? value.mitarbeiterGruppeId ?? null
      : null,
    dienstleisterId: keep.has('dienstleisterId')
      ? value.dienstleisterId ?? null
      : null,
    liestRolleId: keep.has('liestRolleId') ? value.liestRolleId ?? null : null,
    dynamischeArten: keep.has('dynamischeArten')
      ? value.dynamischeArten ?? []
      : [],
    versendeEMailAnMitarbeiterGruppe:
      keep.has('versendeEMailAnMitarbeiterGruppe') &&
      (value.versendeEMailAnMitarbeiterGruppe ?? false),
  };
};
