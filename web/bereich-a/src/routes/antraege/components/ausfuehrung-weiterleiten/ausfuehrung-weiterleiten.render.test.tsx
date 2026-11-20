/** @vitest-environment jsdom */
import * as Dialog from '@radix-ui/react-dialog';
import {
  cleanup,
  fireEvent,
  render,
  screen,
  waitFor,
} from '@testing-library/react';
import {toast} from 'react-toastify';
import {afterEach, describe, expect, it, vi} from 'vitest';
import {WeiterleitungArt} from '../../../../__generated__/graphql';
import type * as WeiterleitenGenerated from './ausfuehrung-weiterleiten.generated.ts';
import {AusfuehrungWeiterleiten} from './ausfuehrung-weiterleiten.tsx';

vi.stubGlobal(
  'ResizeObserver',
  class {
    observe() {}
    unobserve() {}
    disconnect() {}
  },
);

const weiterleiten = vi.fn();
const onOpenChange = vi.fn();

vi.mock('./ausfuehrung-weiterleiten.generated', async (importOriginal) => {
  const actual = await importOriginal<typeof WeiterleitenGenerated>();
  return {
    ...actual,
    useAusfuehrungWeiterleitenMutation: () => [{fetching: false}, weiterleiten],
  };
});

vi.mock('src/lib/context/auth/auth', () => ({
  useAuth: () => ({user: {id: 'me'}}),
}));

vi.mock('react-toastify', () => ({toast: {success: vi.fn(), error: vi.fn()}}));

const ERFOLG = {data: {ausfuehrungWeiterleiten: {errors: null}}};

const renderAbgabe = () =>
  render(
    <Dialog.Root open>
      <AusfuehrungWeiterleiten
        ausfuehrungId='antrag-1'
        currentSchrittAbteilungId={null}
        modus='extern'
        nachrichtMaxLength={1000}
        onOpenChange={onOpenChange}
      />
    </Dialog.Root>,
  );

const abgabeAbsenden = async (nachricht: string) => {
  fireEvent.change(await screen.findByLabelText('E-Mail Adresse eingeben'), {
    target: {value: 'extern@example.com'},
  });
  fireEvent.click(screen.getByLabelText('Zur Abgabe'));
  fireEvent.change(
    await screen.findByLabelText(/Nachricht an die antragstellende Person/),
    {target: {value: nachricht}},
  );
  fireEvent.click(screen.getByRole('button', {name: 'Antrag abgeben'}));
};

afterEach(() => {
  cleanup();
  vi.clearAllMocks();
});

describe('AusfuehrungWeiterleiten Abgabe', () => {
  it.each([
    ['nur Leerzeichen', '   '],
    ['leer', ''],
  ])(
    'zeigt bei %s einen Fehler unter dem Feld und sendet nichts',
    async (_, nachricht) => {
      renderAbgabe();

      await abgabeAbsenden(nachricht);

      expect(
        await screen.findByText('Bitte geben Sie eine Nachricht ein.'),
      ).toBeTruthy();
      expect(weiterleiten).not.toHaveBeenCalled();
      expect(onOpenChange).not.toHaveBeenCalled();
    },
  );

  it('sendet die getrimmte Nachricht und schliesst den Dialog bei Erfolg', async () => {
    weiterleiten.mockResolvedValue(ERFOLG);
    renderAbgabe();

    await abgabeAbsenden('  Abgegeben an das Bauamt.  ');

    await waitFor(() => expect(onOpenChange).toHaveBeenCalledWith(false));
    expect(weiterleiten).toHaveBeenCalledTimes(1);
    expect(weiterleiten.mock.calls[0][0].input).toMatchObject({
      ausfuehrungId: 'antrag-1',
      empfaengerEmail: 'extern@example.com',
      weiterleitungArt: WeiterleitungArt.Schliessen,
      nachricht: 'Abgegeben an das Bauamt.',
    });
    expect(toast.success).toHaveBeenCalledWith('Antrag abgegeben');
  });

  it('laesst den Dialog bei einem Fehler im Payload offen', async () => {
    weiterleiten.mockResolvedValue({
      data: {
        ausfuehrungWeiterleiten: {
          errors: [{message: 'Der Antrag ist bereits abgeschlossen.'}],
        },
      },
    });
    renderAbgabe();

    await abgabeAbsenden('Abgegeben.');

    await waitFor(() => expect(weiterleiten).toHaveBeenCalledTimes(1));
    expect(onOpenChange).not.toHaveBeenCalled();
    expect(toast.success).not.toHaveBeenCalled();
  });

  it('laesst den Dialog bei einem Netzwerkfehler offen', async () => {
    weiterleiten.mockResolvedValue({error: new Error('Netzwerk'), data: null});
    renderAbgabe();

    await abgabeAbsenden('Abgegeben.');

    await waitFor(() => expect(weiterleiten).toHaveBeenCalledTimes(1));
    expect(onOpenChange).not.toHaveBeenCalled();
    expect(toast.success).not.toHaveBeenCalled();
  });
});
