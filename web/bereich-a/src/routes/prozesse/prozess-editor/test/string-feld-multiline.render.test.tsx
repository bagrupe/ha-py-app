/** @vitest-environment jsdom */
import {useFormBuilder} from '@atmina/formbuilder';
import {cleanup, fireEvent, render, screen} from '@testing-library/react';
import {useEffect} from 'react';
import {afterEach, describe, expect, it} from 'vitest';
import {ProzessEditorFormFeld} from '../components/form/form-feld.tsx';
import {type FormularSchrittFormFelderType} from '../components/form/formular-schritt-form.tsx';

const stringFeld = (): FormularSchrittFormFelderType =>
  ({
    __typename: 'StringFormularFeld',
    id: 'feld-1',
    slotName: 'beschreibung',
    angezeigterName: 'Beschreibung',
    anweisung: null,
    order: 0,
    encrypted: false,
    inhaltsTag: null,
    istRelevant: 'true',
    pflichtfeld: false,
    multiline: false,
    options: [],
  }) as unknown as FormularSchrittFormFelderType;

type StringFeldValue = Extract<
  FormularSchrittFormFelderType,
  {__typename: 'StringFormularFeld'}
>;

type GetValues = () => {feld: FormularSchrittFormFelderType};

const Harness = ({onReady}: {onReady: (getValues: GetValues) => void}) => {
  const {fields, getValues} = useFormBuilder<{
    feld: FormularSchrittFormFelderType;
  }>({values: {feld: stringFeld()}});

  useEffect(() => {
    onReady(getValues);
  }, [getValues, onReady]);

  return (
    <ProzessEditorFormFeld
      on={fields.feld}
      canMoveUp={false}
      canMoveDown={false}
      onRemove={() => {}}
      onMove={() => {}}
    />
  );
};

const multilineCheckbox = () =>
  screen.queryByLabelText('Mehrzeiliges Textfeld') as HTMLInputElement | null;

afterEach(cleanup);

describe('StringFeld — mehrzeiliges Textfeld', () => {
  it('offers an enabled checkbox for a field without options', () => {
    render(<Harness onReady={() => {}} />);

    expect(multilineCheckbox()).not.toBeNull();
    expect(multilineCheckbox()?.disabled).toBe(false);
  });

  it('disables the checkbox and resets the stored value once an option is added', () => {
    let getValues: GetValues = () => ({feld: stringFeld()});
    render(<Harness onReady={(next) => (getValues = next)} />);

    fireEvent.click(multilineCheckbox()!);
    expect(multilineCheckbox()?.checked).toBe(true);
    expect((getValues().feld as StringFeldValue).multiline).toBe(true);

    fireEvent.click(screen.getByText('Hinzufügen'));

    expect(multilineCheckbox()?.disabled).toBe(true);
    expect((getValues().feld as StringFeldValue).multiline).toBe(false);
  });
});
