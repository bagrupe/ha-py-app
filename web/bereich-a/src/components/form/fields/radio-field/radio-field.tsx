import {type FormBuilder, type RegisterOptions} from '@atmina/formbuilder';
import * as RadioGroup from '@radix-ui/react-radio-group';
import {useCallback} from 'react';
import {twMerge} from 'tailwind-merge';
import {
  type CollectionItem,
  findCollectionItemByKey,
  findCollectionItemByValue,
  getCollectionItemKey,
} from '../collections.ts';

/**
 * Eigenschaften für das `RadioField` zur Auswahl von Optionen.
 *
 * @param name - Der Feldname zur Identifikation in Formularen.
 * @param items - Liste der auszuwählenden Elemente, mit optionalem Status `disabled`.
 * @param valueIdentifier - Schlüssel, um den Wert eines Elements im `items`-Array zu identifizieren.
 * @param className - Zusätzliche CSS-Klassen für die RadioGroup.
 * @param label - Beschriftung für die Radio-Gruppe.
 * @param error - Fehlertext oder boolean, um einen Fehlerzustand anzuzeigen.
 * @param value - Der aktuell ausgewählte Wert.
 * @param onChange - Callback, das den neuen ausgewählten Wert meldet.
 * @param required - Gibt an, ob die Auswahl erforderlich ist.
 * @param disabled - Deaktivierungsstatus der gesamten Radio-Gruppe.
 * @param orientation - Layout der Radio-Schaltflächen (`horizontal` oder `vertical`).
 */
export type RadioFieldProps<TItem> = {
  name?: string;
  items: (CollectionItem<TItem> & {disabled?: boolean})[];
  valueIdentifier?: keyof TItem;
  className?: string;
  label?: string;
  error?: string | true;
  value?: TItem;
  onChange: (value: TItem | null) => void;
  required?: boolean;
  disabled?: boolean;
  orientation?: 'horizontal' | 'vertical';
};

/**
 * Eigenschaften für ein `RadioFormField`, das mit `FormBuilder` integriert ist.
 *
 * @param on - Instanz des `FormBuilder`, um den Wert zu steuern.
 * @param rules - Optional: Validierungsregeln für die Auswahl.
 * @param props - Zusätzliche Eigenschaften, die von `RadioFieldProps` übernommen werden, ohne den `value` oder das `onChange`.
 */
export type RadioFormFieldProps<TItem> = {
  on: FormBuilder<TItem>;
  rules?: RegisterOptions<TItem>;
} & Omit<RadioFieldProps<TItem>, 'value' | 'onChange'>;

/**
 * Komponente zur Darstellung einer Radio-Gruppe für die Auswahl aus vordefinierten Optionen.
 *
 * @param props - Eigenschaften, um die Optionen darzustellen und deren Verhalten zu steuern.
 */
export const RadioField = <TItem,>({
  name,
  items,
  value,
  disabled,
  onChange,
  className,
  orientation = 'vertical',
  required,
}: RadioFieldProps<TItem>) => {
  const currentItem = findCollectionItemByValue(items, value, name);
  const currentItemKey =
    currentItem?.key ?? getCollectionItemKey(currentItem?.value);

  const handleChange = useCallback(
    (newValue: string) => {
      const item = findCollectionItemByKey(items, newValue);
      if (item) onChange(item.value);
    },
    [items, onChange],
  );

  return (
    <RadioGroup.Root
      value={currentItemKey}
      disabled={disabled}
      className={twMerge(
        orientation === 'horizontal' && 'flex gap-6',
        className,
      )}
      onValueChange={handleChange}
      orientation={orientation}
      required={required}
    >
      {items.map(
        ({
          value: itemValue,
          key: itemKey = getCollectionItemKey(itemValue),
          name: itemName = itemKey,
          disabled = false,
        }) => (
          <label
            key={itemKey}
            className={twMerge(
              'flex cursor-pointer items-center gap-2 py-1',
              disabled && 'cursor-not-allowed text-gray-300',
            )}
          >
            <RadioGroup.Item
              value={itemKey}
              className={twMerge(
                'size-[18px] rounded-full border border-gray-300 bg-white outline-none focus:shadow-[0_0_0_2px] focus:shadow-primary',
              )}
              disabled={disabled}
            >
              <RadioGroup.Indicator
                className={twMerge(
                  'relative flex size-full items-center justify-center after:block after:size-3 after:rounded-full',
                  disabled ? 'after:bg-gray-700' : 'after:bg-primary',
                )}
              />
            </RadioGroup.Item>
            <div>{itemName}</div>
          </label>
        ),
      )}
    </RadioGroup.Root>
  );
};

/**
 * Formular-Komponente zur Auswahl aus einer Radio-Gruppe, die mit `FormBuilder` integriert ist.
 *
 * @param on - Instanz des `FormBuilder`, um den ausgewählten Wert und die Logik zu verwalten.
 * @param rules - Optionale Validierungsregeln, z. B. ob eine Auswahl erforderlich ist.
 * @param disabled - Deaktivierungsstatus der Radio-Gruppe.
 * @param props - Zusätzliche Eigenschaften, die an das `RadioField` weitergereicht werden.
 *
 * Nutzt den `RadioField` zum Rendern und erweitert dessen Funktionalität mit Formularsteuerung.
 */
export const RadioFormField = <TItem,>({
  on,
  rules,
  disabled,
  ...props
}: RadioFormFieldProps<TItem>) => {
  const {
    field: {value, onChange},
  } = on.$useController();

  return (
    <RadioField
      {...props}
      required={rules?.required?.toString() === 'true'}
      disabled={rules?.disabled || disabled}
      value={value}
      onChange={onChange}
    />
  );
};
