/** @vitest-environment jsdom */
import {useFormBuilder} from '@atmina/formbuilder';
import {cleanup, render, screen} from '@testing-library/react';
import {afterEach, describe, expect, it, vi} from 'vitest';
import {ZustaendigkeitArt} from '../../../../__generated__/graphql.ts';
import {SollZustaendigkeitForm} from '../components/form/soll-zustaendigkeit-form.tsx';
import type {SchrittSollZustaendigkeitInput} from '../prozess-version-erstellen.generated.ts';

vi.mock('../prozess-editor.generated', () => ({
  useMoeglicheZustaendigeQuery: () => [
    {
      data: {
        my: {
          __typename: 'BackofficeUser',
          kommune: {
            organisationseinheiten: [],
            dienstleister: [],
          },
        },
      },
    },
  ],
}));

const arten = [
  ZustaendigkeitArt.Organisationseinheit,
  ZustaendigkeitArt.Dienstleister,
];

const Formular = ({langeNamen}: {langeNamen?: boolean}) => {
  const {fields} = useFormBuilder<{
    sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  }>({
    values: {sollZustaendigkeit: {art: ZustaendigkeitArt.Dienstleister}},
  });
  return (
    <SollZustaendigkeitForm
      on={fields.sollZustaendigkeit}
      schrittId='schritt-1'
      arten={arten}
      valueForArt={(art) => ({art})}
      langeNamen={langeNamen}
    />
  );
};

afterEach(cleanup);

describe('SollZustaendigkeitForm Reiter', () => {
  it('kuerzt die Namen standardmaessig fuer den Prozesseditor', () => {
    render(<Formular />);

    expect(screen.getByRole('tab', {name: 'OE'})).toBeTruthy();
    expect(screen.getByRole('tab', {name: 'Dienstl.'})).toBeTruthy();
  });

  it('zeigt mit langeNamen die ausgeschriebenen Namen', () => {
    render(<Formular langeNamen />);

    expect(
      screen.getByRole('tab', {name: 'Organisationseinheit'}),
    ).toBeTruthy();
    expect(screen.getByRole('tab', {name: 'Dienstleister'})).toBeTruthy();
    expect(screen.queryByRole('tab', {name: 'Dienstl.'})).toBeNull();
  });
});
