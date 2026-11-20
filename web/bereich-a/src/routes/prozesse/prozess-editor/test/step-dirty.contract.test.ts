import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type SchrittDaten} from '../lib/domain-types.ts';
import {isStepDirty} from '../lib/step-dirty.ts';

/**
 * Basis-Schritt, wie ihn der Store hält: die Soll-Zuständigkeit trägt aus der
 * Query zusätzlich das aufgelöste `mitarbeiterGruppe`-Objekt mit, das der
 * Formular-Input ({@link projectByArt}) nicht kennt.
 */
const savedDienstleister = {
  __typename: 'FormularSchritt',
  id: 'schritt-1',
  titel: 'Prüfung durch die Kommune',
  anweisung: null,
  erledigungDurchBuerger: false,
  schreibtRolleId: null,
  slots: [],
  felder: [{id: 'feld-1', angezeigterName: 'Name'}],
  sollZustaendigkeit: {
    art: ZustaendigkeitArt.Dienstleister,
    organisationseinheitId: 'oe-1',
    mitarbeiterGruppeId: null,
    dienstleisterId: 'dl-1',
    mitarbeiterGruppe: null,
    dynamischeArten: [],
    liestRolleId: null,
    versendeEMailAnMitarbeiterGruppe: false,
  },
} as unknown as SchrittDaten;

const withSollZustaendigkeit = (
  step: SchrittDaten,
  soll: Record<string, unknown>,
): SchrittDaten =>
  ({...(step as object), sollZustaendigkeit: soll}) as unknown as SchrittDaten;

describe('isStepDirty (Übernehmen nur bei echten Änderungen)', () => {
  it('meldet keinen Unterschied für den unveränderten Schritt', () => {
    expect(isStepDirty(savedDienstleister, savedDienstleister)).toBe(false);
  });

  it('meldet keinen Unterschied nach einem Tab-Wechsel-Roundtrip (Puffer-Form ohne mitarbeiterGruppe)', () => {
    const afterRoundTrip = withSollZustaendigkeit(savedDienstleister, {
      art: ZustaendigkeitArt.Dienstleister,
      organisationseinheitId: 'oe-1',
      mitarbeiterGruppeId: null,
      dienstleisterId: 'dl-1',
      liestRolleId: null,
      dynamischeArten: [],
    });

    expect(isStepDirty(afterRoundTrip, savedDienstleister)).toBe(false);
  });

  it('meldet eine Änderung, wenn ein Feld des Schritts bearbeitet wurde', () => {
    const renamed = {
      ...(savedDienstleister as object),
      titel: 'Neuer Titel',
    } as unknown as SchrittDaten;

    expect(isStepDirty(renamed, savedDienstleister)).toBe(true);
  });

  it('meldet eine Änderung bei bearbeiteten Formularfeldern (tiefer Vergleich)', () => {
    const editedFelder = {
      ...(savedDienstleister as object),
      felder: [{id: 'feld-1', angezeigterName: 'Vorname'}],
    } as unknown as SchrittDaten;

    expect(isStepDirty(editedFelder, savedDienstleister)).toBe(true);
  });

  it('meldet eine Änderung, wenn die Zuständigkeitsart mit echtem Wert gewechselt wurde', () => {
    const switchedToOe = withSollZustaendigkeit(savedDienstleister, {
      art: ZustaendigkeitArt.Organisationseinheit,
      organisationseinheitId: 'oe-1',
      mitarbeiterGruppeId: 'abt-22',
      dienstleisterId: null,
      liestRolleId: null,
      dynamischeArten: [],
    });

    expect(isStepDirty(switchedToOe, savedDienstleister)).toBe(true);
  });

  it('reports a change when the e-mail notification was toggled', () => {
    const notifying = withSollZustaendigkeit(savedDienstleister, {
      art: ZustaendigkeitArt.Dienstleister,
      organisationseinheitId: 'oe-1',
      mitarbeiterGruppeId: null,
      dienstleisterId: 'dl-1',
      liestRolleId: null,
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: true,
    });

    expect(isStepDirty(notifying, savedDienstleister)).toBe(true);
  });
});
