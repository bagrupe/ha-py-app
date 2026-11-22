import {describe, expect, it} from 'vitest';
import {MeldungKlasse} from '../../../__generated__/graphql.ts';
import {
  type Meldung,
  fehlendeAusruestung,
  formatDauer,
  nachDringlichkeit,
  ort,
} from './meldung.ts';

const meldung = (overrides: Partial<Meldung>): Meldung => ({
  id: 'id',
  createdAt: new Date('2026-11-21T14:00:00Z'),
  moeglicherNotfall: false,
  anzahlBestaetigungen: 0,
  istZustaendigkeit: {},
  slotValues: [],
  ...overrides,
});

describe('nachDringlichkeit', () => {
  it('sorts by class, then +1 count, then the longest wait', () => {
    const b = meldung({
      id: 'b',
      klasse: MeldungKlasse.B,
      anzahlBestaetigungen: 9,
    });
    const aAlt = meldung({
      id: 'a-alt',
      klasse: MeldungKlasse.A,
      createdAt: new Date('2026-11-21T13:00:00Z'),
    });
    const aNeu = meldung({id: 'a-neu', klasse: MeldungKlasse.A});
    const aPlus = meldung({
      id: 'a-plus',
      klasse: MeldungKlasse.A,
      anzahlBestaetigungen: 2,
    });
    const ohne = meldung({id: 'ohne'});

    expect(
      [ohne, b, aNeu, aPlus, aAlt].sort(nachDringlichkeit).map((m) => m.id),
    ).toEqual(['a-plus', 'a-alt', 'a-neu', 'b', 'ohne']);
  });
});

describe('fehlendeAusruestung', () => {
  it('lists what the unit does not carry', () => {
    const einheit = {
      id: 'e',
      name: 'DLK 23/12 Hameln',
      mitarbeiterGruppeId: 'g',
      ausruestung: ['Drehleiter', 'Absperrung'],
    };

    expect(
      fehlendeAusruestung(
        meldung({benoetigteAusruestung: ['Pumpe', 'Absperrung']}),
        einheit,
      ),
    ).toEqual(['Pumpe']);
    expect(fehlendeAusruestung(undefined, einheit)).toEqual([]);
  });
});

describe('ort', () => {
  it('does not repeat the Gemeinde from the address', () => {
    expect(
      ort(
        meldung({
          lage: {gebietId: 'g', gebietName: 'Hameln'},
          slotValues: [
            {
              __typename: 'PlainSlotValue',
              slotName: 'adresse',
              value: {addressString: 'Hameln, Wohngebiet Nord'},
            },
          ],
        }),
      ),
    ).toBe('Hameln · Wohngebiet Nord');
  });
});

describe('formatDauer', () => {
  it('shows hours only from one hour on', () => {
    expect(formatDauer(40 * 60_000)).toBe('40 min');
    expect(formatDauer(130 * 60_000)).toBe('2 h 10 min');
  });
});
