import {describe, expect, it} from 'vitest';
import {flowToVersionInput} from '../lib/serialization/flow-to-version-input.ts';
import {prozessToFlow} from '../lib/serialization/prozess-to-flow.ts';
import {type ProzessEditorProzess} from '../verfuegbare-prozesse.generated.ts';
import {loadFixtureProzess} from './load-fixtures.ts';

type FeldMitDurchsuchbar = {
  __typename: string;
  slotName: string;
  durchsuchbar?: boolean;
};

const stringFelder = (prozess: ProzessEditorProzess) =>
  prozess.latestVersion!.alleSchritte.flatMap((schritt) =>
    'felder' in schritt
      ? (schritt.felder as FeldMitDurchsuchbar[]).filter(
          (feld) => feld.__typename === 'StringFormularFeld',
        )
      : [],
  );

describe('durchsuchbar round trip', () => {
  it('keeps durchsuchbar per field when the Prozesseditor saves a version', () => {
    const prozess = structuredClone(
      loadFixtureProzess('maengelmelder'),
    ) as unknown as ProzessEditorProzess;
    const felder = stringFelder(prozess);
    expect(felder.length).toBeGreaterThan(1);
    felder.forEach((feld, index) => {
      feld.durchsuchbar = index === 0;
    });

    const input = flowToVersionInput(prozessToFlow(prozess), {
      veroeffentlichen: false,
    });

    const gespeichert = input.schritte
      .flatMap((schritt) => schritt.formularSchrittInput?.felder ?? [])
      .map((feld) => feld.stringFormularFeldInput)
      .filter((feld) => feld != null);
    expect(
      gespeichert.map((feld) => [feld.slotName, feld.durchsuchbar]),
    ).toEqual(felder.map((feld) => [feld.slotName, feld.durchsuchbar]));
  });
});
