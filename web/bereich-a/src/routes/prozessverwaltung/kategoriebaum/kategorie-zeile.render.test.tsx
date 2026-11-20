/** @vitest-environment jsdom */
import {
  cleanup,
  fireEvent,
  render,
  screen,
  waitFor,
} from '@testing-library/react';
import type * as Urql from 'urql';
import {afterEach, describe, expect, it, vi} from 'vitest';
import {KategorieZeile} from './kategorie-zeile.tsx';
import type * as KategoriebaumGenerated from './kategoriebaum.generated.ts';
import {type KategorieFragment} from './kategoriebaum.generated.ts';

const renameKategorie = vi.fn();
const createKategorie = vi.fn();
const setZustaendigkeit = vi.fn();
const deleteKategorie = vi.fn();
const ausblenden = vi.fn();

vi.mock('./kategoriebaum.generated.ts', async (importOriginal) => {
  const actual = await importOriginal<typeof KategoriebaumGenerated>();
  return {
    ...actual,
    useKategorieRenameMutation: () => [{fetching: false}, renameKategorie],
    useKategorieCreateMutation: () => [{fetching: false}, createKategorie],
    useKategorieZustaendigkeitSetzenMutation: () => [
      {fetching: false},
      setZustaendigkeit,
    ],
    useKategorieDeleteMutation: () => [{fetching: false}, deleteKategorie],
    useKategorieAusblendungSetzenMutation: () => [
      {fetching: false},
      ausblenden,
    ],
  };
});

vi.mock('urql', async (importOriginal) => {
  const actual = await importOriginal<typeof Urql>();
  return {...actual, useClient: () => ({query: vi.fn()})};
});

vi.mock('../../../components/modal/confirm-modal.tsx', () => ({
  useConfirm: () => vi.fn().mockResolvedValue(true),
}));

const geteilteKategorie = (
  overrides: Partial<KategorieFragment> = {},
): KategorieFragment =>
  ({
    id: 'kat-1',
    parentId: null,
    untereinheitId: null,
    istWurzel: false,
    name: 'Spielplatz Neu',
    ziel: null,
    ...overrides,
  }) as KategorieFragment;

afterEach(() => {
  cleanup();
  vi.clearAllMocks();
});

describe('KategorieZeile — Zuständigkeit speichern mit gleichzeitigem Rename', () => {
  it('legt den Zwilling mit dem neuen, nicht dem veralteten Namen an', async () => {
    const kategorie = geteilteKategorie();
    renameKategorie.mockResolvedValue({
      data: {kategorieRename: {kategorie, errors: null}},
    });
    createKategorie.mockResolvedValue({
      data: {
        kategorieCreate: {kategorie: {id: 'zwilling-1'}, errors: null},
      },
    });
    setZustaendigkeit.mockResolvedValue({
      data: {kategorieZustaendigkeitSetzen: {kategorie: {}, errors: null}},
    });

    render(
      <KategorieZeile
        kategorie={kategorie}
        kinderVon={new Map()}
        kategorieById={new Map([[kategorie.id, kategorie]])}
        wurzelZiel={null}
        untereinheitId='untereinheit-1'
        istSuperadmin
        tiefe={0}
        expandedIds={new Set()}
        onToggleExpand={() => {}}
        gruppenOptionen={[]}
        dienstleisterOptionen={[]}
        onChanged={() => {}}
        offeneAktionenId={kategorie.id}
        onToggleAktionen={() => {}}
      />,
    );

    fireEvent.click(screen.getByText('Bearbeiten'));

    fireEvent.change(screen.getByDisplayValue('Spielplatz Neu'), {
      target: {value: 'Spielplatz Neu 2'},
    });

    // Weg von der "Erbt"-Standardauswahl, damit der Zwilling-Anlege-Zweig greift.
    // Radix Tabs.Trigger reagiert auf mousedown, nicht auf click.
    fireEvent.mouseDown(screen.getByRole('tab', {name: 'Abteilung'}));
    fireEvent.click(screen.getByText('Speichern'));

    await waitFor(() => expect(setZustaendigkeit).toHaveBeenCalled());

    expect(renameKategorie).toHaveBeenCalledWith({
      input: {id: 'kat-1', name: 'Spielplatz Neu 2'},
    });
    expect(createKategorie).toHaveBeenCalledWith({
      input: {
        name: 'Spielplatz Neu 2',
        parentId: null,
        untereinheitId: 'untereinheit-1',
      },
    });
  });
});
