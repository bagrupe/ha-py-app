import {type FormBuilder, type RegisterOptions} from '@atmina/formbuilder';
import {
  type ChangeEventHandler,
  type FC,
  forwardRef,
  type ReactNode,
  useEffect,
  useRef,
} from 'react';
import {type UseFormRegisterReturn} from 'react-hook-form';
import {twMerge} from 'tailwind-merge';
import {type FormularSchrittFeld_CheckboxListFormularFeld_Fragment} from '../../../../routes/antraege/detail/detail.generated.ts';

/**
 * Eigenschaften für die Darstellung eines individuellen Checkbox-Feldes.
 *
 * @param orientation - Orientierung der Checkbox relativ zur Beschriftung ('checkbox-left' oder 'checkbox-right').
 * @param value - Gibt an, ob die Checkbox ausgewählt ist.
 * @param onChange - Event-Handler für Änderungen des Checkbox-Status.
 * @param label - Beschriftung der Checkbox.
 * @param disabled - Deaktivierungsstatus der Checkbox.
 * @param className - Zusätzliche CSS-Klassen für das Styling.
 * @param name - Der Name des Formularfeldes.
 * @param title - Tooltip-Titel der Checkbox.
 * @param helperText
 * @param indeterminate - Gibt an, ob die Checkbox im unbestimmten Zustand ist.
 */
export type CheckboxFieldProps = {
  orientation?: 'checkbox-left' | 'checkbox-right';
  value?: boolean;
  onChange?: ChangeEventHandler<HTMLInputElement>;
  label?: ReactNode;
  disabled?: boolean;
  className?: string;
  name?: string;
  title?: string;
  helperText?: string;
  indeterminate?: boolean;
};

/**
 * Eigenschaften für ein Formularfeld mit Checkbox-Funktionalität.
 *
 * @param on - Instanz des FormBuilder für die Feldsteuerung.
 * @param rules - Optional: Validierungsregeln für das Formularfeld.
 * @param checked - Ob die Checkbox vorab aktiviert ist.
 * @param disabled - Ob die Checkbox deaktiviert ist.
 */
export type CheckboxFormFieldProps<T> = {
  on: FormBuilder<T>;
  rules?: RegisterOptions<T>;
  checked?: boolean;
  disabled?: boolean;
} & Omit<CheckboxFieldProps, keyof UseFormRegisterReturn>;

/**
 * Komponente zur Darstellung eines Checkbox-Feldes mit vielseitigen Optionen wie Orientierung und Styling.
 *
 * @param props - Eigenschaften zur Definition des Checkbox-Feldes, einschließlich Label, Status und Event-Handler.
 */
export const CheckboxField: FC<CheckboxFieldProps> = forwardRef<
  HTMLInputElement,
  CheckboxFieldProps
>(
  (
    {
      orientation = 'checkbox-right',
      value,
      onChange,
      label,
      disabled,
      className,
      name,
      title,
      helperText,
      indeterminate,
    },
    ref,
  ) => {
    const ownRef = useRef<HTMLInputElement | null>(null);

    useEffect(() => {
      if (ownRef.current && indeterminate != null) {
        ownRef.current.indeterminate = indeterminate;
      }
    }, [indeterminate, ownRef]);

    return (
      <label
        title={title}
        className={twMerge(
          'flex cursor-pointer',
          orientation === 'checkbox-left'
            ? 'flex-row gap-2'
            : 'flex-row-reverse justify-between gap-8',
          className,
          disabled && 'text-gray-500 opacity-50',
        )}
      >
        <div className='group relative mt-1'>
          <input
            ref={(el) => {
              ownRef.current = el;
              if (typeof ref === 'function') {
                ref(el);
              } else if (ref) {
                ref.current = el;
              }
            }}
            name={name}
            type='checkbox'
            checked={value}
            disabled={disabled}
            className='sr-only'
            onChange={onChange}
          />
          <div
            className={twMerge(
              'flex size-4 items-center justify-center rounded border border-gray-500 bg-white',
              disabled && 'border-gray-300 bg-gray-300 ',
            )}
          />
          <svg
            stroke='currentColor'
            fill='currentColor'
            strokeWidth='0'
            viewBox='0 0 24 24'
            className='absolute inset-0.5 size-3 stroke-2 text-primary'
            height='1em'
            width='1em'
            xmlns='http://www.w3.org/2000/svg'
          >
            <path
              d='M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z'
              className='hidden group-has-[input:checked]:block group-has-[input:indeterminate]:hidden'
            />
            <rect
              x='9'
              y='9'
              width='6'
              height='6'
              className='hidden group-has-[input:indeterminate]:block'
            />
          </svg>
        </div>
        {(label || helperText) && (
          <span className='flex flex-col'>
            {label && <span>{label}</span>}
            {helperText && (
              <span className='text-sm text-gray-500'>{helperText}</span>
            )}
          </span>
        )}
      </label>
    );
  },
);
CheckboxField.displayName = 'CheckboxField';

/**
 * Wrapper-Komponente für ein Formularfeld mit individuell konfigurierbarer Checkbox.
 *
 * @param on - FormBuilder zur Verwaltung der Feldlogik.
 * @param rules - Optional: Validierungsregeln für das Formularfeld.
 * @param props - Zusätzliche Eigenschaften für die Checkbox.
 */
export const CheckboxFormField: FC<CheckboxFormFieldProps<boolean>> = ({
  on,
  rules,
  ...props
}) => <CheckboxField {...on(rules)} {...props} />;

/**
 * Eine einfache Checkbox für Formulare mit einem Pflicht-Label.
 *
 * @param on - FormBuilder zur Feldsteuerung.
 * @param label - Beschriftungstext für die Checkbox.
 */
export const SimpleCheckBoxFormField: FC<{
  on: FormBuilder<boolean>;
  label: string;
}> = ({on, label, ...props}) => (
  <CheckboxField
    label={label}
    orientation='checkbox-left'
    {...on()}
    {...props}
  />
);

/**
 * Typ für Checkbox-Listenoptionen aus dem Fragment 'FormularSchrittFeld_CheckboxListFormularFeld_Fragment'.
 */
export type CheckBoxListFormOptions =
  FormularSchrittFeld_CheckboxListFormularFeld_Fragment['options'];

/**
 * Formular-Komponente zur Darstellung einer Liste von auswählbaren Checkboxen.
 *
 * @param options - Liste der Checkbox-Optionen mit Schlüsseln und Beschriftungen.
 * @param label - Titel für die Checkbox-Liste.
 * @param on - FormBuilder zur Feldverwaltung und -steuerung.
 * @param rules - Optional: Validierungsregeln für das Formularfeld.
 */
export const CheckboxListFormField: FC<
  {options: CheckBoxListFormOptions; label: string} & Omit<
    CheckboxFormFieldProps<string | null>,
    keyof CheckboxFieldProps
  >
> = ({on, rules, options, label, ...props}) => {
  const formKeys = on.$useWatch();
  let checkedKeys = formKeys?.split(',') ?? [];

  return (
    <>
      <p>{label}</p>
      {options.map(({key, label}) => (
        <CheckboxField
          value={checkedKeys.includes(key)}
          key={key}
          label={label}
          orientation='checkbox-left'
          onChange={(event) => {
            if (event.target.checked) {
              checkedKeys.push(key);
              on.$setValue(checkedKeys.join(','));
            } else {
              // FIXME(react-hooks v7): reassigning closure variable; switch to a const or state.
              // eslint-disable-next-line react-hooks/immutability
              checkedKeys = checkedKeys.filter(
                (currentKey) => currentKey !== key,
              );
              on.$setValue(checkedKeys.join(','));
            }
          }}
          {...props}
        />
      ))}
    </>
  );
};
