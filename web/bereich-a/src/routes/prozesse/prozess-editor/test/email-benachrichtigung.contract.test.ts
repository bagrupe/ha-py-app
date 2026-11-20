import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  emailRecipient,
  supportsEmailNotification,
} from '../lib/email-benachrichtigung.ts';

const catalog = {
  mitarbeiterGruppenWithoutEmail: new Set(['abt-without-mail']),
  dienstleisterWithoutEmail: new Set(['dl-without-mail']),
};

describe('supportsEmailNotification (which steps offer the checkbox)', () => {
  it('Bürger: never', () => {
    expect(supportsEmailNotification({art: ZustaendigkeitArt.Buerger})).toBe(
      false,
    );
  });

  it('OE: only with an Abteilung', () => {
    const oe = (mitarbeiterGruppeId: string | null) =>
      supportsEmailNotification({
        art: ZustaendigkeitArt.Organisationseinheit,
        mitarbeiterGruppeId,
      });

    expect(oe(null)).toBe(false);
    expect(oe('abt-1')).toBe(true);
  });

  it('Dienstleister and Dynamisch: always', () => {
    expect(
      supportsEmailNotification({art: ZustaendigkeitArt.Dienstleister}),
    ).toBe(true);
    expect(supportsEmailNotification({art: ZustaendigkeitArt.Dynamisch})).toBe(
      true,
    );
  });
});

describe('emailRecipient (the addressee the editor can name)', () => {
  it('OE with Abteilung: the Abteilung, and whether it has an e-mail', () => {
    const oe = (mitarbeiterGruppeId: string) =>
      emailRecipient(
        {art: ZustaendigkeitArt.Organisationseinheit, mitarbeiterGruppeId},
        catalog,
      );

    expect(oe('abt-1')).toEqual({
      kind: 'abteilung',
      id: 'abt-1',
      hasEmail: true,
    });
    expect(oe('abt-without-mail')).toEqual({
      kind: 'abteilung',
      id: 'abt-without-mail',
      hasEmail: false,
    });
  });

  it('Dienstleister: the Dienstleister, without e-mail until one is chosen', () => {
    const dienstleister = (dienstleisterId: string | null) =>
      emailRecipient(
        {art: ZustaendigkeitArt.Dienstleister, dienstleisterId},
        catalog,
      );

    expect(dienstleister(null)).toEqual({
      kind: 'dienstleister',
      id: null,
      hasEmail: false,
    });
    expect(dienstleister('dl-1')).toEqual({
      kind: 'dienstleister',
      id: 'dl-1',
      hasEmail: true,
    });
    expect(dienstleister('dl-without-mail')).toEqual({
      kind: 'dienstleister',
      id: 'dl-without-mail',
      hasEmail: false,
    });
  });

  it('nobody the editor can name: Bürger, OE without Abteilung, Dynamisch', () => {
    expect(
      emailRecipient({art: ZustaendigkeitArt.Buerger}, catalog),
    ).toBeNull();
    expect(
      emailRecipient(
        {
          art: ZustaendigkeitArt.Organisationseinheit,
          mitarbeiterGruppeId: null,
        },
        catalog,
      ),
    ).toBeNull();
    expect(
      emailRecipient({art: ZustaendigkeitArt.Dynamisch}, catalog),
    ).toBeNull();
  });
});
