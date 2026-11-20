/** @vitest-environment jsdom */
import {
  cleanup,
  fireEvent,
  render,
  screen,
  waitFor,
} from '@testing-library/react';
import {afterEach, describe, expect, it, vi} from 'vitest';
import type * as WeiterleitenGenerated from './ausfuehrung-weiterleiten.generated.ts';
import {MitarbeiterAuswahl} from './mitarbeiter-auswahl.tsx';

type Variables = {
  groupId: string | null;
  search: string | null;
  skip: number;
  take: number;
};

const calls: Variables[] = [];
const alle = Array.from({length: 60}, (_, i) => ({
  id: `u${i}`,
  vorname: i % 7 === 0 ? 'Anna' : `Vorname${i}`,
  nachname: `Nachname${String(i).padStart(2, '0')}`,
  eMail: `user${String(i).padStart(2, '0')}@example.org`,
  gruppen: [],
}));

vi.mock('./ausfuehrung-weiterleiten.generated', async (importOriginal) => {
  const actual = await importOriginal<typeof WeiterleitenGenerated>();
  return {
    ...actual,
    useMitarbeitendeQuery: ({variables}: {variables: Variables}) => {
      calls.push(variables);
      const q = (variables.search ?? '').toLowerCase();
      const treffer = alle.filter(
        (m) =>
          !q ||
          `${m.vorname} ${m.nachname} ${m.eMail}`.toLowerCase().includes(q),
      );
      return [
        {
          data: {
            my: {
              __typename: 'BackofficeUser',
              kommune: {
                mitarbeiter: {
                  items: treffer.slice(
                    variables.skip,
                    variables.skip + variables.take,
                  ),
                  pageInfo: {
                    hasNextPage:
                      variables.skip + variables.take < treffer.length,
                  },
                },
              },
            },
          },
          fetching: false,
        },
      ];
    },
  };
});

const renderAuswahl = (onSelect = vi.fn(), currentUserId?: string) =>
  render(
    <MitarbeiterAuswahl
      groupId='g1'
      currentUserId={currentUserId}
      selected={null}
      onSelect={onSelect}
    />,
  );

afterEach(() => {
  cleanup();
  calls.length = 0;
});

describe('MitarbeiterAuswahl', () => {
  it('zeigt die erste Seite und laedt mit "Weitere anzeigen" die naechste nach', () => {
    renderAuswahl();

    expect(screen.getAllByRole('button', {pressed: false})).toHaveLength(25);

    fireEvent.click(screen.getByText('Weitere anzeigen'));

    expect(calls.some((c) => c.skip === 25 && c.take === 25)).toBe(true);
    expect(screen.getAllByRole('button', {pressed: false})).toHaveLength(50);
  });

  it('erreicht auch Personen jenseits der ersten 100 Eintraege', () => {
    renderAuswahl();

    fireEvent.click(screen.getByText('Weitere anzeigen'));
    fireEvent.click(screen.getByText('Weitere anzeigen'));

    expect(screen.getByText('user59@example.org')).toBeTruthy();
    expect(screen.queryByText('Weitere anzeigen')).toBeNull();
  });

  it('sucht serverseitig und setzt das Nachladen bei neuer Suche zurueck', async () => {
    renderAuswahl();
    fireEvent.click(screen.getByText('Weitere anzeigen'));

    fireEvent.change(screen.getByRole('searchbox'), {target: {value: 'anna'}});

    await waitFor(() =>
      expect(calls.some((c) => c.search === 'anna' && c.skip === 0)).toBe(true),
    );
    await waitFor(() =>
      expect(screen.getAllByRole('button', {pressed: false})).toHaveLength(9),
    );
  });

  it('zeigt einen Leerzustand ohne Treffer', async () => {
    renderAuswahl();

    fireEvent.change(screen.getByRole('searchbox'), {
      target: {value: 'zzzzqq'},
    });

    await waitFor(() =>
      expect(screen.getByText('Keine Mitarbeitenden gefunden.')).toBeTruthy(),
    );
  });

  it('blendet die eigene Person aus und meldet die Auswahl', () => {
    const onSelect = vi.fn();
    renderAuswahl(onSelect, 'u1');

    expect(screen.queryByText('user01@example.org')).toBeNull();
    fireEvent.click(screen.getByText('user02@example.org'));

    expect(onSelect).toHaveBeenCalledWith({
      id: 'u2',
      name: 'Vorname2 Nachname02',
    });
  });
});
