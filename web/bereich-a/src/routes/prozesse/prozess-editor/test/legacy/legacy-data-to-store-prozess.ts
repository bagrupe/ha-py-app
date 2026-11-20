import {
  deepUnparseExpressions,
  type WithUnparsedExpressions,
} from '@kommunalapp/expressions';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  type VerbindungDaten,
  type ZustaendigkeitRolle,
} from '../../lib/domain-types.ts';
import {type ProzessEditorSchritt} from '../../prozess-version-erstellen.generated.ts';
import {type ProzessEditorProzess} from '../../verfuegbare-prozesse.generated.ts';

export type LegacySchritt = WithUnparsedExpressions<ProzessEditorSchritt>;

/**
 * Frozen snapshot of the pre-refactor `dataToStoreProzess` load mapping, copied verbatim
 * (minus the unused validation pass) so the serialization keystone keeps a stable ground
 * truth after the production store is retired. Do not "modernize" this — it must keep
 * describing the old behavior.
 */
export type LegacyStoreProzess = {
  id: string;
  name: string;
  startId: string;
  schritte: LegacySchritt[];
  verbindungen: VerbindungDaten[];
  rollen: ZustaendigkeitRolle[];
  latestVersionId?: string;
};

export const legacyDataToStoreProzess = (
  prozess: ProzessEditorProzess,
): LegacyStoreProzess => {
  const schritte = prozess.latestVersion?.alleSchritte ?? [
    {
      id: crypto.randomUUID(),
      titel: 'Neuer Schritt',
      verbindungen: [],
      erledigungDurchBuerger: true,
      slots: [],
      versendeEMailAnMitarbeiterGruppe: false,
      anweisung: null,
      sollZustaendigkeit: {
        art: ZustaendigkeitArt.Buerger,
        dynamischeArten: [],
      },
      felder: [
        {
          id: crypto.randomUUID(),
          __typename: 'StringFormularFeld',
          angezeigterName: 'Neues Feld',
          multiline: false,
          durchsuchbar: false,
          istRelevant: 'true',
          options: [],
          slotName: 'Neuer Slot',
          order: 0,
          encrypted: false,
          pflichtfeld: false,
          oeffentlichSichtbar: false,
        },
      ],
      __typename: 'FormularSchritt',
    },
  ];

  return {
    id: prozess.id,
    latestVersionId: prozess.latestVersion?.id,
    startId: prozess.latestVersion?.start?.id ?? schritte[0].id,
    name: prozess.name,
    schritte: deepUnparseExpressions(schritte),
    verbindungen: deepUnparseExpressions(
      schritte.flatMap((s) => s.verbindungen.map((v) => ({...v}))),
    ),
    rollen: prozess.latestVersion?.rollen ?? [],
  };
};
