import {type FormBuilder} from '@atmina/formbuilder';
import {ExpressionInputFormField} from '../../../../../components/form/fields/expression-input-field/expression-input-field.tsx';
import type {SchrittDaten} from '../../lib/domain-types.ts';

/**
 * Typ für die Formulardaten des E-Mail-Weiterleiten-Schritts.
 * Repräsentiert die spezifischen Daten eines Schritts vom Typ 'EmailForwarderExportSchritt'.
 */
type FormData = Extract<
  SchrittDaten,
  {__typename: 'EmailForwarderExportSchritt'}
>;

/**
 * Komponente zur Eingabe der Felder für den E-Mail-Weiterleiten-Schritt.
 * Stellt Formularfelder für E-Mail-Adresse, Betreff und Inhalt bereit.
 * @param on FormBuilder-Instanz zur Steuerung der Formularfelder
 */
export const EmailWeiterleitenSchritt = ({on}: {on: FormBuilder<FormData>}) => (
  <div>
    <ExpressionInputFormField
      label='E-Mail Adresse'
      kind='string'
      on={on.emailAddress}
    />
    <ExpressionInputFormField label='Betreff' kind='string' on={on.subject} />
    <ExpressionInputFormField label='Inhalt' kind='string' on={on.body} />
  </div>
);
