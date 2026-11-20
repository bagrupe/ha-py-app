import type {FormBuilder} from '@atmina/formbuilder';
import {useEffect, useState} from 'react';
import {twMerge} from 'tailwind-merge';
import {type SchrittDaten} from '../../lib/domain-types.ts';
import {FeldHinzufuegenButton} from './feld-hinzufuegen-button.tsx';
import {FormCard} from './form-card.tsx';
import {ProzessEditorFormFeld} from './form-feld.tsx';

/**
 * Typ für einen Formularschritt, der aus den Prozessänderungsdaten extrahiert wird.
 */
export type FormularSchritt = Extract<
  SchrittDaten,
  {__typename: 'FormularSchritt'}
>;

/**
 * Typ für die Formularfelder eines Formularschritts.
 */
export type FormularSchrittFormFelderType = FormularSchritt['felder'][0];

/**
 * Komponente zur Darstellung und Bearbeitung eines Formularschritts mit seinen Feldern.
 * Verwaltet das Hinzufügen, Entfernen und Verschieben von Formularfeldern.
 * @param on FormBuilder-Instanz zur Steuerung des Formularschritts
 */
export const FormularSchrittForm = ({
  on,
}: {
  on: FormBuilder<FormularSchritt>;
}) => {
  const {fields, append, remove, move} = on.felder.$useFieldArray();

  const [highlightIndex, setHighlightIndex] = useState(-1);

  useEffect(() => {
    if (highlightIndex !== -1) {
      const timeoutId = setTimeout(() => {
        setHighlightIndex(-1);
      }, 600);
      return () => {
        clearTimeout(timeoutId);
      };
    }
  }, [highlightIndex]);

  return (
    <div className='space-y-6 '>
      <div className='sticky -top-4 z-10 flex items-center space-x-4 bg-white font-bold'>
        <h2>Felder</h2>
        <hr className='h-px w-full' />
        <FeldHinzufuegenButton onAdd={append} />
      </div>
      {fields.map((feld, index) => (
        <FormCard
          key={feld.$key}
          className={twMerge(
            'transition-colors',
            highlightIndex === index && 'bg-primary-light',
          )}
        >
          <ProzessEditorFormFeld
            on={feld}
            onRemove={() => remove(index)}
            canMoveUp={index > 0}
            canMoveDown={index < fields.length - 1}
            onMove={(dir) => {
              if (dir === 'up') {
                move(index, index - 1);
                setHighlightIndex(index - 1);
              } else {
                move(index, index + 1);
                setHighlightIndex(index + 1);
              }
            }}
          />
        </FormCard>
      ))}
    </div>
  );
};
