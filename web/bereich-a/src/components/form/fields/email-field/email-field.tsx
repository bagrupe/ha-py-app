import {
  InputField,
  type InputFieldProps,
  InputFormField,
  type InputFormFieldProps,
} from '../input-field';

/**
 * Eigenschaften für das E-Mail-Feld ohne expliziten Typ, abgeleitet von InputFieldProps.
 *
 * Ermöglicht die Konfiguration des EmailField ohne den Input-Typ zu überschreiben.
 */
export type EmailFieldProps = Omit<InputFieldProps, 'type'>;

/**
 * Eigenschaften für das E-Mail-Formularfeld ohne expliziten Typ, abgeleitet von InputFormFieldProps.
 *
 * Ermöglicht die Konfiguration des EmailFormField ohne den Input-Typ zu überschreiben.
 */
export type EmailFormFieldProps = Omit<InputFormFieldProps, 'type'>;

/**
 * Komponente für ein Input-Feld speziell für E-Mail-Adressen.
 *
 * @param props - Eigenschaften des Feldes, z. B. Platzhalter, Styling oder Event-Handler. Der Typ ist immer 'email'.
 */
export const EmailField = (props: EmailFieldProps) => (
  <InputField {...props} autoComplete='email' type='email' />
);

/**
 * Formular-Komponente zum Validieren und Verarbeiten von E-Mail-Adressen.
 *
 * @param on - FormBuilder zur Verwaltung des Eingabewerts.
 * @param rules - Optionale Validierungsregeln, erweitert um spezifische E-Mail-Validierungen.
 * @param props - Zusätzliche Eigenschaften für das E-Mail-Feld.
 *
 * Die Validierung überprüft im Basissatz die korrekte Struktur einer E-Mail-Adresse sowie das Fehlen von Sonderzeichen vor dem '@'.
 */
export const EmailFormField = ({on, rules, ...props}: EmailFormFieldProps) => (
  <InputFormField
    on={on}
    rules={{
      validate: (email: string) => {
        if (email.trim() && !/^[\u{20}-\u{7F}]*@/gu.test(email)) {
          return 'Bitte geben Sie eine gültige E-Mail Adresse ohne Sonderzeichen vor dem @ ein.';
        }
      },
      ...rules,
    }}
    {...props}
    type='email'
  />
);
