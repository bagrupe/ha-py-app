import {type FC, forwardRef, useState} from 'react';
import {MdOutlineVisibility, MdOutlineVisibilityOff} from 'react-icons/md';
import {getFieldError} from '../common';
import {
  InputField,
  type InputFieldProps,
  type InputFormFieldProps,
} from '../input-field';

/**
 * Eigenschaften für das `PasswordInputField`, ein Eingabefeld speziell für Passwörter mit anpassbarem Typ und Sichtbarkeitsumschaltung.
 *
 * @param props - Erbt alle Eigenschaften von `InputFieldProps`, außer `type` und `endAdornment`, die intern gesetzt werden.
 */
export type PasswordInputFieldProps = Omit<
  InputFieldProps,
  'type' | 'endAdornment'
>;

/**
 * Eingabefeld für Passwörter mit Option, die Passwortsichtbarkeit umzuschalten.
 *
 * @param props - Eigenschaften für das Passwortfeld, wie Platzhalter, Styling oder Event-Handler.
 */
export const PasswordInputField = forwardRef<
  HTMLInputElement,
  PasswordInputFieldProps
>(({...props}, ref) => {
  const [showPassword, setShowPassword] = useState(false);

  const endAdornment = (
    <button
      type='button'
      className='size-4'
      onClick={() => setShowPassword((prev) => !prev)}
    >
      {showPassword ? <MdOutlineVisibilityOff /> : <MdOutlineVisibility />}
    </button>
  );

  return (
    <InputField
      {...props}
      ref={ref}
      type={showPassword ? 'text' : 'password'}
      endAdornment={endAdornment}
    />
  );
});
PasswordInputField.displayName = 'PasswordInputField';

/**
 * Eigenschaften für ein Passwortformularfeld, das mit `FormBuilder` integriert ist.
 *
 * @param on - Instanz des FormBuilder zur Steuerung und Validierung des Werts.
 * @param rules - Optional: Validierungsregeln für die Passwort-Eingabe.
 * @param props - Zusätzliche Eigenschaften zum Anpassen des Eingabefeldes.
 *
 * Erbt alle Eigenschaften von `InputFormFieldProps`, außer `type` und `endAdornment`.
 */
export type PasswordInputFormFieldProps = Omit<
  InputFormFieldProps,
  'type' | 'endAdornment'
>;

/**
 * Formularfeld für die Eingabe eines Passworts, das mit `FormBuilder` integriert ist.
 *
 * @param on - FormBuilder zur Verwaltung des Eingabewerts.
 * @param rules - Optional: Validierungsregeln für das Passwortfeld.
 * @param props - Zusätzliche Eigenschaften für das Eingabefeld.
 *
 * Nutzt den `PasswordInputField` als Basis und zeigt automatisch Validierungsfehler an.
 */
export const PasswordInputFormField: FC<PasswordInputFormFieldProps> = ({
  on,
  rules,
  ...props
}) => (
  <PasswordInputField {...on(rules)} {...props} error={getFieldError(on)} />
);
