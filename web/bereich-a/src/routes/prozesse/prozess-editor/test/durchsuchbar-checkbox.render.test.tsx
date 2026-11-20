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
    durchsuchbar: false,
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

const durchsuchbarCheckbox = () =>
  screen.queryByLabelText(
    'Suche in der App anbieten',
  ) as HTMLInputElement | null;

const removeOptionButton = () =>
  screen
    .getAllByRole('button')
    .find((btn) => btn.querySelector('svg.text-red-500') != null);

afterEach(cleanup);

describe('StringFeld — Suche in der App anbieten', () => {
  it('disables the checkbox for a field without options', () => {
    render(<Harness onReady={() => {}} />);

    expect(durchsuchbarCheckbox()).not.toBeNull();
    expect(durchsuchbarCheckbox()?.disabled).toBe(true);
    expect(durchsuchbarCheckbox()?.checked).toBe(false);
  });

  it('enables the checkbox once an option exists, and resets the stored value when the last option is removed again', () => {
    let getValues: GetValues = () => ({feld: stringFeld()});
    render(<Harness onReady={(next) => (getValues = next)} />);

    fireEvent.click(screen.getByText('Hinzufügen'));
    expect(durchsuchbarCheckbox()?.disabled).toBe(false);

    fireEvent.click(durchsuchbarCheckbox()!);
    expect(durchsuchbarCheckbox()?.checked).toBe(true);
    expect((getValues().feld as StringFeldValue).durchsuchbar).toBe(true);

    fireEvent.click(removeOptionButton()!);

    expect(durchsuchbarCheckbox()?.disabled).toBe(true);
    expect((getValues().feld as StringFeldValue).durchsuchbar).toBe(false);
  });
});
