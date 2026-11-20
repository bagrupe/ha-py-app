/** @vitest-environment jsdom */
import {
  cleanup,
  fireEvent,
  render,
  screen,
  waitFor,
} from '@testing-library/react';
import {MemoryRouter, useLocation} from 'react-router';
import {afterEach, describe, expect, it, vi} from 'vitest';
import {useAppUiStore} from 'src/lib/app-ui-store.ts';
import {PapierkorbListe} from './papierkorb-liste.tsx';
import type * as PapierkorbGenerated from './papierkorb.generated.ts';

vi.stubGlobal(
  'ResizeObserver',
  class {
    observe() {}
    unobserve() {}
    disconnect() {}
  },
);

const wiederherstellen = vi.fn();
const reexecute = vi.fn();
let items: Array<{id: string; prozessBezeichnung: string}> = [];

vi.mock('./papierkorb.generated', async (importOriginal) => {
  const actual = await importOriginal<typeof PapierkorbGenerated>();
  return {
    ...actual,
    useGeloeschteAntraegeQuery: () => [
      {
        data: {
          geloeschteAntraege: {
            totalCount: 2,
            items: items.map((i) => ({
              ...i,
              status: 'ABGESCHLOSSEN',
              geloeschtAm: new Date('2026-10-26T12:00:00'),
              loeschgrund: 'test',
              geloeschtVon: 'Test Nutzer',
              endgueltigGeloeschtAm: null,
            })),
          },
        },
        fetching: false,
      },
      reexecute,
    ],
    useAntragWiederherstellenMutation: () => [
      {fetching: false},
      wiederherstellen,
    ],
  };
});

const LocationProbe = () => <output>{useLocation().search}</output>;

const renderSeite2MitEinemEintrag = () => {
  items = [{id: 'a-2', prozessBezeichnung: 'Mängelmelder Version-2'}];
  useAppUiStore.getState().setSeitengroesse('papierkorb', 1);
  render(
    <MemoryRouter initialEntries={['/papierkorb?page=2']}>
      <PapierkorbListe />
      <LocationProbe />
    </MemoryRouter>,
  );
};

const wiederherstellenBestaetigen = async () => {
  fireEvent.click(screen.getByLabelText('Wiederherstellen'));
  fireEvent.click(
    await screen.findByRole('button', {name: 'Wiederherstellen'}),
  );
};

afterEach(() => {
  cleanup();
  vi.clearAllMocks();
});

describe('PapierkorbListe: Wiederherstellen des letzten Eintrags einer Folgeseite', () => {
  it('springt nach erfolgreichem Wiederherstellen auf die vorherige Seite', async () => {
    wiederherstellen.mockResolvedValue({
      data: {antragWiederherstellen: {ausfuehrung: {id: 'a-2'}, errors: null}},
    });
    renderSeite2MitEinemEintrag();

    await wiederherstellenBestaetigen();

    await waitFor(() =>
      expect(screen.getByRole('status').textContent).toBe('?page=1'),
    );
    expect(reexecute).not.toHaveBeenCalled();
  });

  it('bleibt bei fehlgeschlagenem Wiederherstellen auf der Seite und lädt neu', async () => {
    wiederherstellen.mockResolvedValue({
      data: {
        antragWiederherstellen: {
          ausfuehrung: null,
          errors: [{message: 'Antrag nicht gefunden'}],
        },
      },
    });
    renderSeite2MitEinemEintrag();

    await wiederherstellenBestaetigen();

    await waitFor(() => expect(reexecute).toHaveBeenCalledTimes(1));
    expect(screen.getByRole('status').textContent).toBe('?page=2');
  });
});
