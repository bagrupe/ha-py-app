import {type FC} from 'react';

import {MdClose, MdCheck} from 'react-icons/md';

/**
 * Aufzählung der Regeln für die Passwortvalidierung.
 */
export enum PasswordRules {
  MinLength = 'minLength',
  SpecialChar = 'specialChar',
  Number = 'number',
  Capital = 'capital',
  Match = 'match',
}

/**
 * Zuordnung der Validierungsregeln zu den entsprechenden Fehlermeldungen.
 */
export const passwordValidationMessages = {
  [PasswordRules.MinLength]: 'Mindestens 12 Zeichen',
  [PasswordRules.SpecialChar]: 'Mindestens ein Sonderzeichen',
  [PasswordRules.Number]: 'Mindestens eine Zahl',
  [PasswordRules.Capital]: 'Mindestens ein Großbuchstabe',
  [PasswordRules.Match]: 'Passwörter müssen übereinstimmen.',
};

type PasswordChecklistProps = {
  failedRules: PasswordRules[];
};

/**
 * Validiert ein Passwort anhand definierter Regeln und gibt die fehlgeschlagenen Regeln zurück.
 * @param password Das zu prüfende Passwort, optional.
 * @param repeatPassword Das Wiederholungs-Passwort zum Abgleich.
 * @returns Array der nicht erfüllten Passwortregeln.
 */
export const validatePassword = (
  password: string | undefined,
  repeatPassword: string,
) => {
  if (!password) {
    return Object.values(PasswordRules);
  }
  const failedRules: PasswordRules[] = [];
  const checkDigit = (c: string) => /[0-9]/.test(c);

  const hasUpper = [...password].some(
    (c) => c.toUpperCase() === c && c.toLowerCase() !== c,
  );
  const hasDigit = checkDigit(password);
  const hasSpecial = [...password].some(
    (c) => c.toUpperCase() === c && c.toLowerCase() === c && !checkDigit(c),
  );
  const hasMatch = password.length > 0 && password === repeatPassword;

  if (password.length < 12) {
    failedRules.push(PasswordRules.MinLength);
  }
  if (!hasUpper) failedRules.push(PasswordRules.Capital);
  if (!hasDigit) failedRules.push(PasswordRules.Number);
  if (!hasSpecial) failedRules.push(PasswordRules.SpecialChar);
  if (!hasMatch) failedRules.push(PasswordRules.Match);

  return failedRules;
};

/**
 * Komponente zur Anzeige einer Checkliste der Passwortregeln mit Statusanzeige.
 * @param failedRules Array der nicht erfüllten Passwortregeln.
 * @returns JSX-Element mit Liste der Regeln und deren Erfüllungsstatus.
 */
export const PasswordChecklist: FC<PasswordChecklistProps> = ({
  failedRules,
}) => (
  <ul>
    {Object.values(PasswordRules).map((rule) => (
      <li key={rule} className='flex items-center gap-2'>
        {failedRules.includes(rule) ? (
          <MdClose className='text-red-600' />
        ) : (
          <MdCheck className='text-green-600' />
        )}

        <span className='text-sm text-gray-700'>
          {passwordValidationMessages[rule]}
        </span>
      </li>
    ))}
  </ul>
);
