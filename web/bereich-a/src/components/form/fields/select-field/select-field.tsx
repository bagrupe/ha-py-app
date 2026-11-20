import {type FormBuilder, type RegisterOptions} from '@atmina/formbuilder';
import * as Select from '@radix-ui/react-select';
import {useCallback} from 'react';
import {MdExpandMore} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {
  type CollectionItem,
  findCollectionItemByKey,
  findCollectionItemByValue,
  getCollectionItemKey,
} from '../collections';
import {getFieldError} from '../common';
import {InputField} from '../input-field';

/**
 * Eigenschaften für das `SelectField`, ein Dropdown zur Auswahl von Optionen.
 *
 * @param items - Liste der auswählbaren Elemente, bestehend aus Werten und optionalen Schlüsseln/Namen.
 * @param valueIdentifier - Optionaler Schlüssel, um das ausgewählte Element eindeutig zu identifizieren.
 * @param className - CSS-Klassen für das äußere Select-Element.
 * @param label - Beschriftung für das Eingabefeld.
 * @param error - Fehlertext oder boolean, das einen Fehlerzustand anzeigt.
 * @param value - Der aktuelle Wert, der im Dropdown ausgewählt ist.
 * @param onChange - Callback, das aufgerufen wird, wenn die Auswahl geändert wird.
 * @param required - Gibt an, ob die Eingabe erforderlich ist.
 * @param disabled - Deaktivierungsstatus des Dropdowns.
 */
export type SelectFieldProps<TItem> = {
  items: CollectionItem<TItem>[];
  valueIdentifier?: keyof TItem;
  className?: string;
  label?: string;
  error?: string | true;
  value: TItem | undefined;
  onChange: (value: TItem | null) => void;
  required?: boolean;
  disabled?: boolean;
};

/**
 * Eigenschaften für ein `SelectFormField`, das mit `FormBuilder` integriert ist.
 *
 * @param on - Instanz des `FormBuilder`, um den Wert und die Validierung zu steuern.
 * @param rules - Validierungsregeln, z. B. ob das Feld erforderlich ist.
 * @param props - Eigenschaften des `SelectField`, ohne `value` und `onChange`.
 */
export type SelectFormFieldProps<TItem> = {
  on: FormBuilder<TItem>;
  rules?: RegisterOptions<TItem>;
} & Omit<SelectFieldProps<TItem>, 'value' | 'onChange'>;

/**
 * Dropdown-Komponente zur Auswahl eines Wertes aus einer Liste.
 *
 * @param props - Eigenschaften zur Konfiguration des Dropdowns, inklusive Optionen, Label, Fehlerzustand und Auswahländerungen.
 */
export function SelectField<TItem>({
  items,
  value,
  onChange,
  valueIdentifier,
  className,
  label,
  error,
  required,
  disabled,
}: SelectFieldProps<TItem>) {
  const currentItem = findCollectionItemByValue(
    items,
    value,
    undefined,
    valueIdentifier,
  );
  const currentItemValue =
    currentItem?.key ?? getCollectionItemKey(currentItem?.value);

  const handleChange = useCallback(
    (newValue: string) => {
      const item = findCollectionItemByKey(items, newValue);
      if (item && !item.separator) onChange(item.value);
    },
    [items, onChange],
  );

  return (
    <Select.Root
      value={currentItemValue}
      onValueChange={handleChange}
      required={required}
      disabled={disabled}
    >
      <Select.Trigger
        tabIndex={-1}
        className={twMerge(
          'group/select-trigger w-full cursor-pointer text-base font-normal focus:outline-none',
          className,
        )}
      >
        <InputField
          className='cursor-pointer text-left'
          inputClass='cursor-pointer text-left '
          fieldsetClass='group-data-[state=open]/select-trigger:!border-primary group-data-[state=open]/select-trigger:!border-2'
          readOnly
          label={label}
          error={error}
          disabled={disabled}
          value={
            currentItem
              ? currentItem.name ?? getCollectionItemKey(currentItem.value)
              : ''
          }
          endAdornment={
            <div
              className={twMerge(
                'mr-2 flex h-full items-center justify-center before:mr-2 before:h-[calc(100%-1rem)] before:w-px before:bg-gray-300',
                error && 'before:bg-red-600',
              )}
            >
              <MdExpandMore
                className={twMerge(
                  'w-6 text-gray-300',
                  error && 'text-red-600',
                )}
              />
            </div>
          }
        />
      </Select.Trigger>
      <Select.Portal>
        <Select.Content sideOffset={6} position='popper'>
          <Select.Viewport className='max-h-[--radix-select-content-available-height] w-[--radix-select-trigger-width] rounded border border-gray-300 bg-white py-1 shadow'>
            {currentItem == null && (
              /* Hidden option prevents the next option in line from being selected by default when no other options match */
              <Select.Item hidden value={getCollectionItemKey(value)}>
                {value != null && String(value)}
              </Select.Item>
            )}

            {items.map((item) => {
              const itemKey = item.key ?? getCollectionItemKey(item.value);

              if (item.separator) {
                return (
                  <Select.Separator
                    key={itemKey}
                    // TODO: Change separator height and/or color?
                    className='my-1 h-[2px] bg-gray-300'
                  />
                );
              }

              const {name: itemName = itemKey, customItem: itemCustom} = item;

              return (
                <Select.Item
                  key={itemKey}
                  value={itemKey}
                  className='cursor-pointer select-none px-2 py-1 outline-none hover:bg-indigo-100 data-[highlighted]:bg-gray-200 data-[state=checked]:bg-indigo-50'
                >
                  <Select.ItemText>
                    {itemCustom ? (
                      itemCustom
                    ) : (
                      <div className='flex flex-row gap-2'>{itemName}</div>
                    )}
                  </Select.ItemText>
                </Select.Item>
              );
            })}
          </Select.Viewport>
        </Select.Content>
      </Select.Portal>
    </Select.Root>
  );
}

/**
 * Formular-Komponente zur Auswahl von Optionen, integriert mit `FormBuilder`.
 *
 * @param on - Instanz von `FormBuilder` zur Steuerung des Wertes und der Validierungslogik.
 * @param rules - Optional: Validierungsregeln, wie z. B. die Anforderung einer Pflichtauswahl.
 * @param disabled - Deaktivierungsstatus des Dropdowns.
 * @param props - Weitergereichte Eigenschaften an das zugrunde liegende `SelectField`.
 *
 * Nutzt `SelectField` zur Darstellung und fügt Unterstützung für Formularlogik hinzu.
 */
export function SelectFormField<TItem = unknown>({
  on,
  rules,
  disabled,
  ...props
}: SelectFormFieldProps<TItem>) {
  const {
    field: {value, onChange},
  } = on.$useController({rules});

  return (
    <SelectField
      {...props}
      error={getFieldError(on)}
      required={rules?.required?.toString() === 'true'}
      disabled={rules?.disabled || disabled}
      value={value}
      onChange={onChange}
    />
  );
}
