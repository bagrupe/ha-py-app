import {type FormBuilder} from '@atmina/formbuilder';
import {
  type BrowserNativeObject,
  type Primitive,
  type RegisterOptions,
} from 'react-hook-form';

/**
 * Validierungsregeln für Felder, basierend auf react-hook-form.
 *
 * @template T - Der Datentyp des Feldes.
 *
 * Unterstützt Regeln wie `required`, `maxLength`, etc., die auf den Typ des Feldwertes abgestimmt sind.
 */
export type FieldRules<T> = RegisterOptions<
  {__: T; b: T},
  T extends Primitive | BrowserNativeObject ? '__' : '__'
>;

/**
 * Allgemeine Eigenschaften für Eingabefelder.
 *
 * @template T - Der Datentyp des Eingabefeldes.
 *
 * @param label - Beschriftung des Feldes.
 * @param on - `FormBuilder`-Instanz zur Steuerung des Eingabewerts.
 * @param className - Zusätzliche CSS-Klassen für das Feld.
 * @param helperText - Zusätzliche Hilfetexte oder Hinweise unterhalb des Feldes.
 * @param rules - Optional: Validierungsregeln für das Feld.
 * @param type - Typ des Eingabefeldes (z. B. `text`, `password`).
 * @param monospace - Gibt an, ob der Text in Monospace-Schriftart dargestellt werden soll.
 * @param disabled - Deaktivierungsstatus des Feldes.
 * @param autoFocus - Gibt an, ob das Feld beim Laden der Seite den Fokus erhalten soll.
 */
export type FieldProps<T = string> = {
  label: string;
  on: FormBuilder<T>;
  className?: string;
  helperText?: string;
  rules?: FieldRules<T> | null;
  type?: string;
  monospace?: boolean;
  disabled?: boolean;
  autoFocus?: boolean;
};

/**
 * Ermittelt die Fehlermeldung für ein Feld, falls ein Validierungsfehler aufgetreten ist.
 *
 * @param on - `FormBuilder`-Instanz, die das Feld steuert.
 *
 * @returns Einen Fehlertext, eine Standardfehlermeldung (z. B. `Dieses Feld ist ein Pflichtfeld`) oder `undefined`,
 * falls kein Fehler vorhanden ist.
 */
export const getFieldError = (on: FormBuilder<unknown>) => {
  const errorMap: Record<string, string> = {
    required: 'Dieses Feld ist ein Pflichtfeld.',
  };

  const {errors} = on.$useState();

  return errors
    ? errors.message || (errors.type && errorMap[errors.type]) || true
    : undefined;
};
