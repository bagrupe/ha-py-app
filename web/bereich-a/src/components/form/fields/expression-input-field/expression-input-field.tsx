import type {FormBuilder, RegisterOptions} from '@atmina/formbuilder';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';
import {type ForwardedRef, forwardRef, useCallback, useState} from 'react';
import {type UseFormRegisterReturn} from 'react-hook-form';
import {twMerge} from 'tailwind-merge';
import {InputField, type InputFieldProps} from '../input-field';

const expressionMap = {
  bool: BoolExpression,
  int: IntExpression,
  string: StringExpression,
} as const;

/**
 * Unterstützte Arten von Ausdrücken für das Parsing.
 * - `bool`: Boolean-Ausdrücke
 * - `int`: Integer-Ausdrücke
 * - `string`: String-Ausdrücke
 */
type ExpressionKind = keyof typeof expressionMap;

/**
 * Instanzen von spezifischen Ausdrucksklassen, abhängig vom angegebenen Typ.
 */
type ExpressionInstance<T extends ExpressionKind> = InstanceType<
  (typeof expressionMap)[T]
>;

/**
 * Eigenschaften für das `ExpressionInputField`, das die Eingabe und Validierung
 * bestimmter Ausdrucksarten verarbeitet.
 *
 * @param value - Der aktuelle Wert des Ausdrucks als Text.
 * @param onChange - Callback, das den neuen Wert meldet.
 * @param kind - Der Typ des Ausdrucks (`bool`, `int` oder `string`).
 * @param rest - Zusätzliche Eigenschaften, die an das InputField weitergereicht werden.
 */
export type ExpressionInputFieldProps<TKind extends ExpressionKind> = {
  value?: string;
  onChange?: (newValue: string) => void;
  kind: TKind;
} & Omit<InputFieldProps, 'value' | 'onChange'>;

/**
 * Versucht, einen Ausdruck abhängig vom Typ zu analysieren.
 *
 * @param rawExpression - Der Ausdruck als Roh-String.
 * @param kind - Die Art des Ausdrucks (`bool`, `int` oder `string`).
 * @returns Erfolgs- oder Fehlerobjekt mit entsprechender Instanz oder Fehlermeldung.
 */
const tryParse = <T extends ExpressionKind>(
  rawExpression: string,
  kind: T,
):
  | {success: true; expression: ExpressionInstance<T>}
  | {success: false; expression?: undefined; error?: unknown} => {
  try {
    const classConstructor = expressionMap[kind];
    const expression = new classConstructor(
      rawExpression,
    ) as ExpressionInstance<T>;

    return {success: true, expression};
  } catch (e) {
    return {success: false, error: e};
  }
};

/**
 * Text-Eingabekomponente mit Parsing und Fehleranzeige für `bool`, `int` oder `string` Ausdrucksarten.
 *
 * @param value - Der aktuelle Eingabewert.
 * @param onChange - Callback, das bei einem Update des Wertes ausgelöst wird.
 * @param kind - Typ des Ausdrucks, der verarbeitet werden soll.
 * @param error - Optionaler Fehlertext, der angezeigt wird.
 * @param ref - Weiterleitung des Refs an das eigentliche HTML-Input-Element.
 */
export const ExpressionInputField = forwardRef(function ExpressionInputField<
  T extends ExpressionKind,
>(
  {value, onChange, kind, error, ...rest}: ExpressionInputFieldProps<T>,
  ref: ForwardedRef<HTMLInputElement>,
) {
  const [errorState, setErrorState] = useState(error);
  const onChangeParsed = useCallback(
    (rawExpression: string) => {
      const parseResult = tryParse(rawExpression, kind);

      if (!parseResult.success && 'error' in parseResult) {
        setErrorState(parseResult.error as string);
      }
      if (parseResult.success) {
        setErrorState(undefined);
      }

      onChange?.(rawExpression);
    },
    [kind, onChange],
  );
  return (
    <InputField
      onChange={(e) => onChangeParsed(e.target.value)}
      value={value}
      ref={ref}
      error={errorState}
      {...rest}
    />
  );
});

/**
 * Eigenschaften für das Formularfeld zur Eingabe und Validierung von Ausdrücken.
 *
 * @param on - FormBuilder zur Steuerung des Eingabewerts.
 * @param rules - Optional: Validierungsregeln für den analysierten Ausdruck.
 * @param kind - Typ des Ausdrucks (`bool`, `int` oder `string`).
 * @param rest - Zusätzliche Eigenschaften, die an `ExpressionInputField` weitergegeben werden.
 */
export type ExpressionInputFormFieldProps<T extends ExpressionKind> = Omit<
  ExpressionInputFieldProps<T>,
  keyof UseFormRegisterReturn
> & {
  on: FormBuilder<string>;
  rules?: RegisterOptions<ExpressionInstance<T>>;
};

/**
 * Formular-Komponente zur Eingabe, Validierung und Parsing von Ausdrücken.
 *
 * @param on - FormBuilder zur Verwaltung und Validierung des Werts.
 * @param rules - Validierungsregeln für den Ausdruck.
 * @param className - Zusätzliche CSS-Klassen für die Eingabe.
 * @param kind - Typ des zu validierenden Ausdrucks (`bool`, `int`, `string`).
 * @param rest - Zusätzliche Attribute für die zugrunde liegende Eingabe.
 *
 * Die Validierung wird über die `tryParse`-Methode durchgeführt, wobei Fehlermeldungen bei fehlerhaften Eingaben zurückgegeben werden.
 */
export function ExpressionInputFormField<T extends ExpressionKind>({
  on,
  rules,
  className,
  kind,
  ...rest
}: ExpressionInputFormFieldProps<T>) {
  const {
    field,
    fieldState: {error},
  } = on.$useController({
    rules: {
      validate: (value, _) => {
        const parseResult = tryParse(value, kind);
        return parseResult.success || String(parseResult.error);
      },
    },
  });
  return (
    <ExpressionInputField
      {...field}
      {...rest}
      kind={kind}
      error={error?.message}
      className={twMerge(className, 'font-mono')}
    />
  );
}
