import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type SollZustaendigkeit} from '../lib/domain-types.ts';
import {
  projectByArt,
  resolveSollZustaendigkeitForArt,
} from '../lib/soll-zustaendigkeit.ts';

const savedOe: SollZustaendigkeit = {
  art: ZustaendigkeitArt.Organisationseinheit,
  organisationseinheitId: 'oe-hameln',
  mitarbeiterGruppeId: 'abt-22',
  dienstleisterId: null,
  liestRolleId: null,
  dynamischeArten: [],
  versendeEMailAnMitarbeiterGruppe: true,
};

describe('resolveSollZustaendigkeitForArt (a tab switch isolates the Arten)', () => {
  it('restores the saved configuration when the Art stays the same', () => {
    expect(
      resolveSollZustaendigkeitForArt(
        savedOe,
        ZustaendigkeitArt.Organisationseinheit,
      ),
    ).toEqual(projectByArt(savedOe, ZustaendigkeitArt.Organisationseinheit));
  });

  it('carries no OE field into Dienstleister', () => {
    const result = resolveSollZustaendigkeitForArt(
      savedOe,
      ZustaendigkeitArt.Dienstleister,
    );
    expect(result.mitarbeiterGruppeId).toBeNull();
    expect(result.organisationseinheitId).toBeNull();
    expect(result.dienstleisterId).toBeNull();
    expect(result.art).toBe(ZustaendigkeitArt.Dienstleister);
  });

  it('starts the e-mail notification unchecked on another Art', () => {
    expect(
      resolveSollZustaendigkeitForArt(savedOe, ZustaendigkeitArt.Dienstleister)
        .versendeEMailAnMitarbeiterGruppe,
    ).toBe(false);
  });

  it('restores the e-mail notification together with the saved Art', () => {
    expect(
      resolveSollZustaendigkeitForArt(
        savedOe,
        ZustaendigkeitArt.Organisationseinheit,
      ).versendeEMailAnMitarbeiterGruppe,
    ).toBe(true);
  });
});

describe('projectByArt keeps only the fields the Art uses', () => {
  const all: SollZustaendigkeit = {
    art: ZustaendigkeitArt.Organisationseinheit,
    organisationseinheitId: 'oe-1',
    mitarbeiterGruppeId: 'gruppe-1',
    dienstleisterId: 'dl-1',
    liestRolleId: 'rolle-1',
    dynamischeArten: [ZustaendigkeitArt.Dienstleister],
    versendeEMailAnMitarbeiterGruppe: true,
  };

  it('Organisationseinheit keeps OE, Abteilung and the e-mail notification', () => {
    expect(projectByArt(all, ZustaendigkeitArt.Organisationseinheit)).toEqual({
      art: ZustaendigkeitArt.Organisationseinheit,
      organisationseinheitId: 'oe-1',
      mitarbeiterGruppeId: 'gruppe-1',
      dienstleisterId: null,
      liestRolleId: null,
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: true,
    });
  });

  it('Dienstleister keeps Dienstleister, OE and the e-mail notification', () => {
    expect(projectByArt(all, ZustaendigkeitArt.Dienstleister)).toEqual({
      art: ZustaendigkeitArt.Dienstleister,
      organisationseinheitId: 'oe-1',
      mitarbeiterGruppeId: null,
      dienstleisterId: 'dl-1',
      liestRolleId: null,
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: true,
    });
  });

  it('Bürger drops every id and the e-mail notification', () => {
    expect(projectByArt(all, ZustaendigkeitArt.Buerger)).toEqual({
      art: ZustaendigkeitArt.Buerger,
      organisationseinheitId: null,
      mitarbeiterGruppeId: null,
      dienstleisterId: null,
      liestRolleId: null,
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: false,
    });
  });

  it('Dynamisch keeps Rolle, dynamischeArten and the e-mail notification', () => {
    expect(projectByArt(all, ZustaendigkeitArt.Dynamisch)).toEqual({
      art: ZustaendigkeitArt.Dynamisch,
      organisationseinheitId: null,
      mitarbeiterGruppeId: null,
      dienstleisterId: null,
      liestRolleId: 'rolle-1',
      dynamischeArten: [ZustaendigkeitArt.Dienstleister],
      versendeEMailAnMitarbeiterGruppe: true,
    });
  });
});
