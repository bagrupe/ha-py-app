/** @vitest-environment jsdom */
import {useFormBuilder} from '@atmina/formbuilder';
import {cleanup, render, screen} from '@testing-library/react';
import {useEffect} from 'react';
import {afterEach, beforeEach, describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from '../../../../__generated__/graphql.ts';
import {
  EMailBenachrichtigungForm,
  type EditableSchrittDaten,
} from '../components/form/soll-zustaendigkeit-form.tsx';
import {useProzessEditorStore} from '../lib/store';
import {makeStepData} from './support/make-flow.ts';

const catalog = {
  oeGroups: new Map([['oe-1', new Set(['abt-without-mail'])]]),
  dienstleisterOEs: new Map([
    ['dl-with-mail', new Set(['oe-1'])],
    ['dl-without-mail', new Set(['oe-1'])],
  ]),
  mitarbeiterGruppenWithoutEmail: new Set(['abt-without-mail']),
  dienstleisterWithoutEmail: new Set(['dl-without-mail']),
};

beforeEach(() => useProzessEditorStore.setState({catalog}));

const notifyingOeSchrittWithoutAddress = (): EditableSchrittDaten =>
  makeStepData('s1', {
    sollZustaendigkeit: {
      art: ZustaendigkeitArt.Organisationseinheit,
      organisationseinheitId: 'oe-1',
      mitarbeiterGruppeId: 'abt-without-mail',
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: true,
    },
  }) as EditableSchrittDaten;

const buergerSchritt = (): EditableSchrittDaten =>
  makeStepData('s2') as EditableSchrittDaten;

const dienstleisterSchritt = (
  dienstleisterId: string | null,
): EditableSchrittDaten =>
  makeStepData('s3', {
    sollZustaendigkeit: {
      art: ZustaendigkeitArt.Dienstleister,
      organisationseinheitId: 'oe-1',
      dienstleisterId,
      dynamischeArten: [],
      versendeEMailAnMitarbeiterGruppe: false,
    },
  }) as EditableSchrittDaten;

const dynamischerSchritt = (): EditableSchrittDaten =>
  makeStepData('s4', {
    sollZustaendigkeit: {
      art: ZustaendigkeitArt.Dynamisch,
      dynamischeArten: [ZustaendigkeitArt.Dienstleister],
      versendeEMailAnMitarbeiterGruppe: false,
    },
  }) as EditableSchrittDaten;

type GetValues = () => EditableSchrittDaten;

const Sidebar = ({
  schritt,
  onReady,
}: {
  schritt?: EditableSchrittDaten;
  onReady: (getValues: GetValues) => void;
}) => {
  const {fields, getValues} = useFormBuilder<EditableSchrittDaten>({
    values: schritt,
  });

  useEffect(() => {
    onReady(getValues);
  }, [getValues, onReady]);

  return schritt ? (
    <EMailBenachrichtigungForm on={fields.sollZustaendigkeit} />
  ) : null;
};

const checkbox = () => screen.getByRole('checkbox') as HTMLInputElement;

const supportText = () => checkbox().closest('label')?.textContent ?? '';

const noop = () => {};

afterEach(cleanup);

describe('EMailBenachrichtigungForm — e-mail notification checkbox', () => {
  it('shows the saved status even when the group has no e-mail address', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(
      <Sidebar schritt={notifyingOeSchrittWithoutAddress()} onReady={noop} />,
    );

    expect(checkbox().checked).toBe(true);
  });

  it('does not change the form value when it is only displayed', () => {
    const gespeichert = notifyingOeSchrittWithoutAddress();
    let getValues: GetValues = () => gespeichert;
    const onReady = (next: GetValues) => (getValues = next);

    const {rerender} = render(<Sidebar onReady={onReady} />);
    rerender(<Sidebar schritt={gespeichert} onReady={onReady} />);

    expect(getValues()).toEqual(gespeichert);
  });

  it('shows the saved status even when another step was opened first', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(<Sidebar schritt={buergerSchritt()} onReady={noop} />);
    rerender(
      <Sidebar schritt={notifyingOeSchrittWithoutAddress()} onReady={noop} />,
    );

    expect(checkbox().checked).toBe(true);
  });

  it('explains what the notification does for a Dienstleister that has an e-mail address', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(
      <Sidebar schritt={dienstleisterSchritt('dl-with-mail')} onReady={noop} />,
    );

    expect(checkbox().disabled).toBe(false);
    expect(supportText()).toContain(
      'Der gewählte Dienstleister wird per E-Mail benachrichtigt, sobald ein Antrag diesen Schritt erreicht.',
    );
  });

  it('disables the checkbox and says where to add the address for a Dienstleister without one', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(
      <Sidebar
        schritt={dienstleisterSchritt('dl-without-mail')}
        onReady={noop}
      />,
    );

    expect(checkbox().disabled).toBe(true);
    expect(supportText()).toContain(
      'Der gewählte Dienstleister hat keine E-Mail-Adresse. Hinterlegen Sie eine in der Nutzendenverwaltung, um die Benachrichtigung zu aktivieren.',
    );
  });

  it('disables the checkbox and asks for a Dienstleister while none is chosen', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(<Sidebar schritt={dienstleisterSchritt(null)} onReady={noop} />);

    expect(checkbox().disabled).toBe(true);
    expect(supportText()).toContain(
      'Wählen Sie zuerst einen Dienstleister aus, um die Benachrichtigung zu aktivieren.',
    );
  });

  it('names the Abteilung in the hint when it has no e-mail address', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(
      <Sidebar schritt={notifyingOeSchrittWithoutAddress()} onReady={noop} />,
    );

    expect(supportText()).toContain(
      'Die gewählte Abteilung hat keine E-Mail-Adresse. Hinterlegen Sie eine in der Nutzendenverwaltung, um die Benachrichtigung zu aktivieren.',
    );
  });

  it('explains on a dynamic step that the recipient is chosen at runtime', () => {
    const {rerender} = render(<Sidebar onReady={noop} />);

    rerender(<Sidebar schritt={dynamischerSchritt()} onReady={noop} />);

    expect(checkbox().disabled).toBe(false);
    expect(supportText()).toContain(
      'Die zur Laufzeit gewählte Abteilung oder der gewählte Dienstleister wird per E-Mail benachrichtigt, sofern eine E-Mail-Adresse hinterlegt ist.',
    );
  });
});
