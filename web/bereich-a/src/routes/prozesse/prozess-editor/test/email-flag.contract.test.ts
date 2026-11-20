import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type SchrittDaten} from '../lib/domain-types.ts';
import {schrittZuInput} from '../lib/input-converters.ts';
import {type FormularSchrittInput} from '../prozess-version-erstellen.generated.ts';
import {makeStepData} from './support/make-flow.ts';

const serialize = (schritt: SchrittDaten): FormularSchrittInput =>
  (
    schrittZuInput(
      schritt as Exclude<SchrittDaten, {__typename: 'GhostSchritt'}>,
    ) as {
      formularSchrittInput: FormularSchrittInput;
    }
  ).formularSchrittInput;

describe('schrittZuInput — the e-mail flag moves from the Zuständigkeit to the step input', () => {
  const serializeWithZustaendigkeit = (
    sollZustaendigkeit: Record<string, unknown>,
  ) =>
    serialize(
      makeStepData('s1', {
        sollZustaendigkeit: {
          ...sollZustaendigkeit,
          versendeEMailAnMitarbeiterGruppe: true,
        },
      } as Partial<SchrittDaten>) as SchrittDaten,
    );

  it('writes the flag on the step, not inside sollZustaendigkeit', () => {
    const input = serializeWithZustaendigkeit({
      art: ZustaendigkeitArt.Dienstleister,
      organisationseinheitId: 'oe-1',
      dienstleisterId: 'dl-1',
      dynamischeArten: [],
    });

    expect(input.versendeEMailAnMitarbeiterGruppe).toBe(true);
    expect(input.sollZustaendigkeit).not.toHaveProperty(
      'versendeEMailAnMitarbeiterGruppe',
    );
  });

  it('keeps the flag for OE with Abteilung', () => {
    expect(
      serializeWithZustaendigkeit({
        art: ZustaendigkeitArt.Organisationseinheit,
        organisationseinheitId: 'oe-1',
        mitarbeiterGruppeId: 'abt-1',
        dynamischeArten: [],
      }).versendeEMailAnMitarbeiterGruppe,
    ).toBe(true);
  });

  it('keeps the flag for Dynamisch', () => {
    expect(
      serializeWithZustaendigkeit({
        art: ZustaendigkeitArt.Dynamisch,
        liestRolleId: null,
        dynamischeArten: [ZustaendigkeitArt.Dienstleister],
      }).versendeEMailAnMitarbeiterGruppe,
    ).toBe(true);
  });

  it('clears the flag for Bürger', () => {
    expect(
      serializeWithZustaendigkeit({
        art: ZustaendigkeitArt.Buerger,
        dynamischeArten: [],
      }).versendeEMailAnMitarbeiterGruppe,
    ).toBe(false);
  });

  it('clears the flag for OE without Abteilung', () => {
    expect(
      serializeWithZustaendigkeit({
        art: ZustaendigkeitArt.Organisationseinheit,
        organisationseinheitId: 'oe-1',
        mitarbeiterGruppeId: null,
        dynamischeArten: [],
      }).versendeEMailAnMitarbeiterGruppe,
    ).toBe(false);
  });
});
