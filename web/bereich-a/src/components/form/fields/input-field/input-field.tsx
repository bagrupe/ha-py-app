import {type FormBuilder, type RegisterOptions} from '@atmina/formbuilder';
import {
  type FC,
  type ForwardedRef,
  forwardRef,
  type InputHTMLAttributes,
  type ReactNode,
} from 'react';
import {type UseFormRegisterReturn} from 'react-hook-form';
import {twMerge} from 'tailwind-merge';
import {getFieldError} from '../common.tsx';
import {FloatingLabelOutline} from '../floating-label-outline.tsx';

/**
 * Eigenschaften für das `InputField`, ein flexibles Textfeld mit Unterstützung für Einzel- und Mehrzeilen-Eingaben sowie Anpassungen und Dekoration.
 *
 * @param label - Beschriftung des Input-Felds.
 * @param error - Fehlertext oder boolean, um einen Fehlerzustand anzuzeigen.
 * @param minRows - Mindestzeilen für Textareas bei Mehrzeilen-Eingabe.
 * @param inputClass - Zusätzliche CSS-Klasse für den Eingabebereich.
 * @param multiLine - Aktiviert die Verwendung einer Textarea anstelle eines Input-Felds.
 * @param fieldsetClass - Zusätzliche CSS-Klasse für das äußere Fieldset.
 * @param startAdornment - Optionaler Inhalt, der links vom Eingabe-Inhalt angezeigt wird.
 * @param endAdornment - Optionaler Inhalt, der rechts vom Eingabe-Inhalt angezeigt wird.
 * @param props - Zusätzliche Attribute für eingebaute HTML-Eingabeelemente (`input` oder `textarea`).
 */
export type InputFieldProps = {
  label?: string;
  error?: string | true;
  minRows?: number;
  inputClass?: string;
  multiLine?: boolean;
  fieldsetClass?: string;

  startAdornment?: ReactNode;
  endAdornment?: ReactNode;
} & InputHTMLAttributes<HTMLInputElement | HTMLTextAreaElement>;

/**
 * Eigenschaften für die Formular-Variante des `InputField`, die mit `FormBuilder` integriert ist.
 *
 * @param on - Instanz des `FormBuilder` zur Verwaltung des Eingabewerts.
 * @param rules - Optional: Validierungsregeln für das Eingabefeld.
 * @param props - Zusätzliche Eigenschaften, die vom `InputField` geerbt werden.
 */
export type InputFormFieldProps = {
  on: FormBuilder<string>;
  rules?: RegisterOptions<string>;
} & Omit<
  InputFieldProps,
  Exclude<keyof UseFormRegisterReturn, 'disabled' | 'maxLength'>
>;

/**
 * Flexibles Eingabefeld für Text oder Mehrzeilen-Text mit Fehlerbehandlung, Platzhalter und Stiloptionen.
 *
 * @param props - Eigenschaften zur Konfiguration des Eingabefelds, inklusive Unterstützung für Start- und End-Elemente, Fehler und Multi-Line.
 */
export const InputField = forwardRef<
  HTMLInputElement | HTMLTextAreaElement,
  InputFieldProps
>(
  (
    {
      error,
      className,
      inputClass: customInputClass,
      multiLine,
      minRows,
      startAdornment,
      endAdornment,
      fieldsetClass,
      ...props
    }: InputFieldProps,
    ref,
  ) => {
    // Space as placeholder allows use of placeholder-shown pseudo-selector; with an empty string or undefined it doesn't work.
    const placeholder = props.placeholder || ' ';
    const inputClass =
      'peer relative z-10 w-full bg-transparent px-3 py-2 outline-none placeholder:opacity-0 placeholder:transition-opacity group-focus-within:placeholder:opacity-100';
    return (
      <FloatingLabelOutline
        error={error}
        label={props.label}
        className={className}
        startAdornment={startAdornment}
        endAdornment={endAdornment}
        fieldsetClass={fieldsetClass}
      >
        {(id) =>
          multiLine ? (
            <textarea
              {...props}
              id={id}
              rows={10}
              className={twMerge(
                inputClass,
                customInputClass,
                !!startAdornment && 'pl-0',
                !!endAdornment && 'pr-0',
              )}
              placeholder={placeholder}
              ref={ref as ForwardedRef<HTMLTextAreaElement>}
              readOnly={
                typeof props.value === 'string' &&
                !(props.onChange || props.onInput)
              }
            />
          ) : (
            <input
              {...props}
              id={id}
              className={twMerge(
                inputClass,
                customInputClass,
                !!startAdornment && 'pl-0',
                !!endAdornment && 'pr-0',
              )}
              placeholder={placeholder}
              ref={ref as ForwardedRef<HTMLInputElement>}
              readOnly={
                typeof props.value === 'string' &&
                !(props.onChange || props.onInput)
              }
            />
          )
        }
      </FloatingLabelOutline>
    );
  },
);
InputField.displayName = 'InputField';

/**
 * Komponente für ein Formular-Eingabefeld, das mit `FormBuilder` integriert ist.
 *
 * @param on - Instanz des `FormBuilder`, um den Wert zu steuern und zu validieren.
 * @param rules - Optional: Validierungsregeln für die Eingabe.
 * @param error - Optionaler Fehlerzustand, falls keine automatische Fehlerermittlung verwendet wird.
 * @param props - Zusätzliche Eigenschaften für das Eingabefeld.
 *
 * Nutzt automatisch den durch `FormBuilder` bereitgestellten Fehlerzustand, wenn verfügbar.
 */
export const InputFormField: FC<InputFormFieldProps> = ({
  on,
  rules,
  error,
  ...props
}) => (
  <InputField {...on(rules)} {...props} error={error ?? getFieldError(on)} />
);
