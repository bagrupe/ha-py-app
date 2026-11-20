import {type GhostSchritt, type SchrittDaten} from '../../lib/domain-types.ts';
import {schrittZuInput, verbindungZuInput} from '../../lib/input-converters.ts';
import {type ProzessVersionErstellenInput} from '../../prozess-version-erstellen.generated.ts';
import {type ProzessEditorProzess} from '../../verfuegbare-prozesse.generated.ts';
import {
  legacyDataToStoreProzess,
  type LegacySchritt,
} from './legacy-data-to-store-prozess.ts';

type EditableSchritt = Exclude<SchrittDaten, GhostSchritt>;

const toEditorSchritt = ({
  versendeEMailAnMitarbeiterGruppe,
  ...schritt
}: LegacySchritt): EditableSchritt =>
  ({
    ...schritt,
    sollZustaendigkeit: {
      ...schritt.sollZustaendigkeit,
      versendeEMailAnMitarbeiterGruppe:
        versendeEMailAnMitarbeiterGruppe ?? false,
    },
  }) as EditableSchritt;

/**
 * Ground truth for the serialization contract: a verbatim port of the current
 * load (`dataToStoreProzess`) + topbar save mapping (topbar.tsx `neueProzessVersionErstellen`).
 * Reuses the production `schrittZuInput` / `verbindungZuInput` so it tracks today's
 * behavior exactly until Phase 5 retires them.
 */
export const legacyProzessToVersionInput = (
  prozessData: ProzessEditorProzess,
  veroeffentlichen = false,
): ProzessVersionErstellenInput => {
  const prozess = legacyDataToStoreProzess(prozessData);

  const schrittInputs = prozess.schritte.map(toEditorSchritt).map((schritt) => {
    if (
      schritt.__typename === 'WarteAufGovManagerSchritt' &&
      !schritt.govManagerSchrittId
    ) {
      const upstreamId = prozess.verbindungen.find(
        (v) => v.nachId === schritt.id,
      )?.vonId;
      const govManagerSchritt = prozess.schritte.find(
        (s) =>
          s.id === upstreamId && s.__typename === 'GovManagerRestExportSchritt',
      );
      if (govManagerSchritt) {
        return schrittZuInput({
          ...schritt,
          govManagerSchrittId: govManagerSchritt.id,
        });
      }
    }
    return schrittZuInput(schritt);
  });

  const verbindungInputs = prozess.verbindungen.map(verbindungZuInput);

  const usedZustaendigkeitRollen = prozess.schritte
    .flatMap((s) => [s.schreibtRolleId, s.sollZustaendigkeit.liestRolleId])
    .filter((id): id is string => Boolean(id));

  const rollen = prozess.rollen
    .filter(({id}) => usedZustaendigkeitRollen.includes(id))
    .map((nz) => ({id: nz.id, name: nz.name}));

  return {
    prozessId: prozess.id,
    verbindungen: verbindungInputs,
    schritte: schrittInputs,
    veroeffentlichen,
    zustaendigkeitRollen: rollen,
  };
};
