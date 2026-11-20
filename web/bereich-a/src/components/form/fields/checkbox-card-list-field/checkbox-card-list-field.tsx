import {type FormBuilder, type RegisterOptions} from '@atmina/formbuilder';
import {twMerge} from 'tailwind-merge';
import {CheckboxField} from '../checkbox-field';

/**
 * Stellt ein Formularfeld bereit, das eine Liste von Checkboxen darstellt.
 *
 * @param label - Beschriftung des Formularfelds.
 * @param items - Liste der Checkbox-Optionen mit eindeutigen IDs und Namen.
 * @param on - Instanz des FormBuilder, um die Feldsteuerung und -werte zu verwalten.
 * @param rules - Optionale Validierungsregeln für das Formularfeld.
 */
export type CheckboxListFormFieldProps = {
  label: string;
  items: {id: string; name: string}[];
  on: FormBuilder<string[]>;
  rules?: RegisterOptions<string[]>;
};

/**
 * Komponente zum Rendern eines Formularfelds mit einer Liste von auswählbaren Checkbox-Karten.
 *
 * @param props - Enthält die Eigenschaften für die Darstellung des Felds: `label`, `items`,
 * `on` für die Verwaltung der Feldwerte und optional `rules` für Validierung.
 *
 * Verwendet den provided `on` FormBuilder zur Feldsteuerung und Validierung.
 */
export const CheckboxCardListFormField = ({
  on,
  items,
  label,
  rules,
}: CheckboxListFormFieldProps) => {
  const {
    field: {value = [], onChange},
    fieldState: {error},
  } = on.$useController({rules});

  return (
    <div>
      <div className='flex items-center'>
        <div className='mr-4 whitespace-nowrap font-bold'>{label}</div>
        <div className='h-px w-full border-0 bg-neutral-300' />
      </div>

      <div className='mt-3 flex flex-col gap-1'>
        {items.map(({id, name}) => {
          const active = value.includes(id);

          return (
            <CheckboxField
              key={id}
              className={twMerge(
                'rounded border p-2 hover:border-gray-400 hover:bg-gray-200',
                error && 'border-red-600',
                active && 'border-primary bg-primary/20 hover:bg-primary/50',
              )}
              label={name}
              onChange={({currentTarget}) => {
                if (currentTarget.checked && !value.includes(id)) {
                  onChange([...value, id]);
                } else {
                  onChange(value.filter((other) => other != id));
                }
              }}
              value={active}
            />
          );
        })}

        {error && <span className='text-sm text-red-600'>{error.message}</span>}
      </div>
    </div>
  );
};
