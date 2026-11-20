/** @vitest-environment jsdom */
import {useFormBuilder} from '@atmina/formbuilder';
import {
  cleanup,
  fireEvent,
  render,
  screen,
  waitFor,
} from '@testing-library/react';
import {afterEach, describe, expect, it, vi} from 'vitest';
import {ZustaendigkeitArt} from '../../../../__generated__/graphql.ts';
import {Form} from '../../../../components/form/form.tsx';
import {SollZustaendigkeitForm} from '../components/form/soll-zustaendigkeit-form.tsx';
import type * as ProzessEditorGenerated from '../prozess-editor.generated.ts';
import {type SchrittSollZustaendigkeitInput} from '../prozess-version-erstellen.generated.ts';

vi.mock('../prozess-editor.generated.ts', async (importOriginal) => {
  const actual = await importOriginal<typeof ProzessEditorGenerated>();
  return {
    ...actual,
    useMoeglicheZustaendigeQuery: () => [
      {
        data: {
          my: {
            __typename: 'BackofficeUser',
            kommune: {
              dienstleister: [],
              organisationseinheiten: [
                {
                  id: 'oe-mit-abteilung',
                  name: 'Emmerthal',
                  mitarbeiterGruppen: [
                    {
                      id: 'abt-1',
                      name: 'Bauamt',
                      eMailAdressen: [],
                      isDeleted: false,
                    },
                  ],
                },
                {
                  id: 'oe-ohne-abteilung',
                  name: 'Aerzen',
                  mitarbeiterGruppen: [],
                },
              ],
            },
          },
        },
      },
    ],
  };
});

const FEHLT = 'Bitte wählen Sie eine Abteilung aus.';
const OE_LEER = /Diese Organisationseinheit hat keine Abteilung/;

const Harness = ({
  value,
  abteilungPflicht,
  onSubmit,
}: {
  value: SchrittSollZustaendigkeitInput;
  abteilungPflicht?: boolean;
  onSubmit: (v: SchrittSollZustaendigkeitInput) => void;
}) => {
  const builder = useFormBuilder<{
    sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  }>({
    values: {sollZustaendigkeit: value},
  });
  return (
    <Form builder={builder} onSubmit={(v) => onSubmit(v.sollZustaendigkeit)}>
      <SollZustaendigkeitForm
        on={builder.fields.sollZustaendigkeit}
        schrittId='s1'
        valueForArt={(art) => ({art})}
        arten={[
          ZustaendigkeitArt.Organisationseinheit,
          ZustaendigkeitArt.Dienstleister,
        ]}
        abteilungPflicht={abteilungPflicht}
      />
      <button type='submit'>Weiter</button>
    </Form>
  );
};

const oe = (
  organisationseinheitId: string,
  mitarbeiterGruppeId: string | null,
): SchrittSollZustaendigkeitInput => ({
  art: ZustaendigkeitArt.Organisationseinheit,
  organisationseinheitId,
  mitarbeiterGruppeId,
});

const submit = () => fireEvent.click(screen.getByText('Weiter'));

afterEach(cleanup);

describe('SollZustaendigkeitForm, Abteilung als Pflichtfeld', () => {
  it('blocks submit when the OE has Abteilungen but none is chosen', async () => {
    const onSubmit = vi.fn();
    render(
      <Harness
        abteilungPflicht
        value={oe('oe-mit-abteilung', null)}
        onSubmit={onSubmit}
      />,
    );

    submit();

    await screen.findByText(FEHLT);
    expect(onSubmit).not.toHaveBeenCalled();
  });

  it('blocks submit and explains it when the OE has no Abteilung at all', async () => {
    const onSubmit = vi.fn();
    render(
      <Harness
        abteilungPflicht
        value={oe('oe-ohne-abteilung', null)}
        onSubmit={onSubmit}
      />,
    );

    expect(screen.getByText(OE_LEER)).toBeTruthy();
    submit();

    await screen.findByText(FEHLT);
    expect(onSubmit).not.toHaveBeenCalled();
  });

  it('submits when an Abteilung of the OE is chosen', async () => {
    const onSubmit = vi.fn();
    render(
      <Harness
        abteilungPflicht
        value={oe('oe-mit-abteilung', 'abt-1')}
        onSubmit={onSubmit}
      />,
    );

    submit();

    await waitFor(() => expect(onSubmit).toHaveBeenCalledTimes(1));
    expect(onSubmit.mock.calls[0][0]).toMatchObject({
      organisationseinheitId: 'oe-mit-abteilung',
      mitarbeiterGruppeId: 'abt-1',
    });
  });

  it('marks the field as required only when it is mandatory', () => {
    const {rerender} = render(
      <Harness
        abteilungPflicht
        value={oe('oe-mit-abteilung', 'abt-1')}
        onSubmit={vi.fn()}
      />,
    );
    expect(screen.getAllByText('Abteilung *').length).toBeGreaterThan(0);

    rerender(
      <Harness value={oe('oe-mit-abteilung', 'abt-1')} onSubmit={vi.fn()} />,
    );
    expect(screen.queryByText('Abteilung *')).toBeNull();
  });

  it('stays optional by default (process editor)', async () => {
    const onSubmit = vi.fn();
    render(
      <Harness value={oe('oe-mit-abteilung', null)} onSubmit={onSubmit} />,
    );

    submit();

    await waitFor(() => expect(onSubmit).toHaveBeenCalledTimes(1));
    expect(screen.queryByText(FEHLT)).toBeNull();
  });

  it('does not require an Abteilung for Dienstleister', async () => {
    const onSubmit = vi.fn();
    render(
      <Harness
        abteilungPflicht
        value={{
          art: ZustaendigkeitArt.Dienstleister,
          organisationseinheitId: 'oe-mit-abteilung',
          mitarbeiterGruppeId: null,
          dienstleisterId: 'dl-1',
        }}
        onSubmit={onSubmit}
      />,
    );

    submit();

    await waitFor(() => expect(onSubmit).toHaveBeenCalledTimes(1));
  });

  it('does not keep blocking after switching from the OE tab to Dienstleister', async () => {
    const onSubmit = vi.fn();
    render(
      <Harness
        abteilungPflicht
        value={oe('oe-mit-abteilung', null)}
        onSubmit={onSubmit}
      />,
    );

    fireEvent.mouseDown(screen.getByRole('tab', {name: 'Dienstl.'}), {
      button: 0,
    });
    submit();

    await waitFor(() => expect(onSubmit).toHaveBeenCalledTimes(1));
    expect(screen.queryByText(FEHLT)).toBeNull();
  });

  describe('Abteilung dropdown availability', () => {
    const abteilungSelect = () => screen.getAllByRole('combobox')[1];

    it('is disabled while no OE is chosen', () => {
      render(
        <Harness
          abteilungPflicht
          value={{art: ZustaendigkeitArt.Organisationseinheit}}
          onSubmit={vi.fn()}
        />,
      );

      expect(abteilungSelect().hasAttribute('disabled')).toBe(true);
    });

    it('is disabled for an OE without Abteilungen', () => {
      render(
        <Harness
          abteilungPflicht
          value={oe('oe-ohne-abteilung', null)}
          onSubmit={vi.fn()}
        />,
      );

      expect(abteilungSelect().hasAttribute('disabled')).toBe(true);
    });

    it('is enabled for an OE with Abteilungen', () => {
      render(
        <Harness
          abteilungPflicht
          value={oe('oe-mit-abteilung', null)}
          onSubmit={vi.fn()}
        />,
      );

      expect(abteilungSelect().hasAttribute('disabled')).toBe(false);
    });

    it('stays enabled in the process editor without an OE', () => {
      render(
        <Harness
          value={{art: ZustaendigkeitArt.Organisationseinheit}}
          onSubmit={vi.fn()}
        />,
      );

      expect(abteilungSelect().hasAttribute('disabled')).toBe(false);
    });

    it('still blocks submit without an OE', async () => {
      const onSubmit = vi.fn();
      render(
        <Harness
          abteilungPflicht
          value={{art: ZustaendigkeitArt.Organisationseinheit}}
          onSubmit={onSubmit}
        />,
      );

      submit();

      await screen.findByText(FEHLT);
      expect(onSubmit).not.toHaveBeenCalled();
    });
  });
});
