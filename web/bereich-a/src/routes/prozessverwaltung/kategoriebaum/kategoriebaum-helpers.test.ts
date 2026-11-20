import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql';
import {
  findeZwilling,
  kollidiertAlsZwilling,
  resolveEffektivesZiel,
  zaehleNachfahren,
} from './kategoriebaum-helpers.ts';
import {type KategorieFragment} from './kategoriebaum.generated.ts';

const kategorie = (
  overrides: Partial<KategorieFragment>,
): KategorieFragment => ({
  id: 'id',
  parentId: null,
  untereinheitId: null,
  istWurzel: false,
  name: 'Test',
  ziel: null,
  ...overrides,
});

describe('kollidiertAlsZwilling', () => {
  it('flags creating an own category with the same name as an existing shared sibling', () => {
    const geschwister = [kategorie({name: 'test2', untereinheitId: null})];
    expect(kollidiertAlsZwilling(geschwister, 'test2', 'untereinheit-1')).toBe(
      true,
    );
  });

  it('flags creating a shared category with the same name as an existing own sibling', () => {
    const geschwister = [
      kategorie({name: 'test2', untereinheitId: 'untereinheit-1'}),
    ];
    expect(kollidiertAlsZwilling(geschwister, 'test2', null)).toBe(true);
  });

  it('does not flag two different untereinheiten owning the same name', () => {
    const geschwister = [
      kategorie({name: 'test2', untereinheitId: 'untereinheit-1'}),
    ];
    expect(kollidiertAlsZwilling(geschwister, 'test2', 'untereinheit-2')).toBe(
      false,
    );
  });

  it('does not flag distinct names', () => {
    const geschwister = [kategorie({name: 'test1', untereinheitId: null})];
    expect(kollidiertAlsZwilling(geschwister, 'test2', 'untereinheit-1')).toBe(
      false,
    );
  });

  it('does not flag an own-vs-own duplicate for the same untereinheit (the backend already rejects that via its own unique-name check)', () => {
    const geschwister = [
      kategorie({name: 'test2', untereinheitId: 'untereinheit-1'}),
    ];
    expect(kollidiertAlsZwilling(geschwister, 'test2', 'untereinheit-1')).toBe(
      false,
    );
  });
});

describe('zaehleNachfahren', () => {
  it('counts direct and indirect children across multiple levels', () => {
    const kinderVon = new Map<string | null, KategorieFragment[]>([
      ['wurzel', [kategorie({id: 'a'}), kategorie({id: 'b'})]],
      ['a', [kategorie({id: 'a1'})]],
      ['a1', [kategorie({id: 'a1a'})]],
    ]);
    expect(zaehleNachfahren('wurzel', kinderVon)).toBe(4);
  });

  it('returns 0 for a category without children', () => {
    const kinderVon = new Map<string | null, KategorieFragment[]>();
    expect(zaehleNachfahren('a', kinderVon)).toBe(0);
  });
});

const ziel = (mitarbeiterGruppeId: string): KategorieFragment['ziel'] => ({
  art: ZustaendigkeitArt.Organisationseinheit,
  organisationseinheitId: 'oe-1',
  mitarbeiterGruppeId,
  dienstleisterId: null,
});

const nachId = (liste: KategorieFragment[]) =>
  new Map(liste.map((k) => [k.id, k]));

describe('resolveEffektivesZiel', () => {
  const UE = 'ue-1';
  const wurzelZiel = ziel('wurzel');
  const spielplatz = kategorie({id: 'spielplatz', name: 'Spielplatz'});
  const muelleimer = kategorie({
    id: 'muelleimer',
    name: 'Mülleimer',
    parentId: 'spielplatz',
  });
  const spielplatzZwilling = kategorie({
    id: 'spielplatz-ue',
    name: 'Spielplatz',
    untereinheitId: UE,
    ziel: ziel('abt-53'),
  });

  it('inherits the ziel of the parent twin for a child without an own twin', () => {
    const alle = nachId([spielplatz, muelleimer, spielplatzZwilling]);

    const ergebnis = resolveEffektivesZiel(muelleimer, alle, wurzelZiel, UE);

    expect(ergebnis.ziel).toEqual(ziel('abt-53'));
    expect(ergebnis.eigen).toBe(false);
  });

  it('inherits from the parent twin when the child twin has no ziel of its own', () => {
    const kindZwilling = kategorie({
      id: 'muelleimer-ue',
      name: 'Mülleimer',
      parentId: 'spielplatz',
      untereinheitId: UE,
    });
    const alle = nachId([
      spielplatz,
      muelleimer,
      spielplatzZwilling,
      kindZwilling,
    ]);

    const ergebnis = resolveEffektivesZiel(muelleimer, alle, wurzelZiel, UE);

    expect(ergebnis.ziel).toEqual(ziel('abt-53'));
    expect(ergebnis.eigen).toBe(false);
  });

  it('prefers the own twin of the child over the parent twin', () => {
    const kindZwilling = kategorie({
      id: 'muelleimer-ue',
      name: 'Mülleimer',
      parentId: 'spielplatz',
      untereinheitId: UE,
      ziel: ziel('abt-51'),
    });
    const alle = nachId([
      spielplatz,
      muelleimer,
      spielplatzZwilling,
      kindZwilling,
    ]);

    const ergebnis = resolveEffektivesZiel(muelleimer, alle, wurzelZiel, UE);

    expect(ergebnis.ziel).toEqual(ziel('abt-51'));
    expect(ergebnis.eigen).toBe(true);
  });

  it('uses the nearest ancestor twin, not a more distant one', () => {
    const spielgeraet = kategorie({
      id: 'spielgeraet',
      name: 'Spielgerät',
      parentId: 'muelleimer',
    });
    const muelleimerZwilling = kategorie({
      id: 'muelleimer-ue',
      name: 'Mülleimer',
      parentId: 'spielplatz',
      untereinheitId: UE,
      ziel: ziel('abt-52'),
    });
    const alle = nachId([
      spielplatz,
      muelleimer,
      spielgeraet,
      spielplatzZwilling,
      muelleimerZwilling,
    ]);

    const ergebnis = resolveEffektivesZiel(spielgeraet, alle, wurzelZiel, UE);

    expect(ergebnis.ziel).toEqual(ziel('abt-52'));
  });

  it('ignores the twin of another untereinheit', () => {
    const fremderZwilling = {...spielplatzZwilling, untereinheitId: 'ue-2'};
    const alle = nachId([spielplatz, muelleimer, fremderZwilling]);

    const ergebnis = resolveEffektivesZiel(muelleimer, alle, wurzelZiel, UE);

    expect(ergebnis.ziel).toEqual(wurzelZiel);
  });

  it('falls back to the wurzel ziel when nobody up the tree has one', () => {
    const alle = nachId([spielplatz, muelleimer]);

    const ergebnis = resolveEffektivesZiel(muelleimer, alle, wurzelZiel, UE);

    expect(ergebnis.ziel).toEqual(wurzelZiel);
    expect(ergebnis.eigen).toBe(false);
  });

  it('does not give the wurzel itself a fallback ziel', () => {
    const wurzel = kategorie({
      id: 'wurzel',
      istWurzel: true,
      untereinheitId: UE,
    });

    const ergebnis = resolveEffektivesZiel(
      wurzel,
      nachId([wurzel]),
      wurzelZiel,
      UE,
    );

    expect(ergebnis.ziel).toBeNull();
  });
});

describe('findeZwilling', () => {
  it('only matches an own category with the same name and parent', () => {
    const geteilt = kategorie({id: 'a', name: 'Gewässer', parentId: 'p'});
    const richtig = kategorie({
      id: 'b',
      name: 'Gewässer',
      parentId: 'p',
      untereinheitId: 'ue-1',
    });
    const andererParent = kategorie({
      id: 'c',
      name: 'Gewässer',
      parentId: 'q',
      untereinheitId: 'ue-1',
    });
    const alle = nachId([geteilt, richtig, andererParent]);

    expect(findeZwilling(geteilt, alle, 'ue-1')?.id).toBe('b');
    expect(findeZwilling(richtig, alle, 'ue-1')).toBeNull();
  });
});
