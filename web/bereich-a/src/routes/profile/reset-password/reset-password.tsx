import {useFormBuilder} from '@atmina/formbuilder';
import {useCallback, useState} from 'react';
import {type RouteObject} from 'react-router';
import {InputFormField} from 'src/components/form/fields/input-field';
import {Form} from 'src/components/form/form';
import {Button} from 'src/components/ui/button';
import {useAuth} from 'src/lib/context/auth/auth';
import {
  encryptPersonalKey,
  exportPublicKey,
  generateKeyPair,
  getServerLoginPassword,
  reencryptOrganisationKeyForNewUser,
} from 'src/lib/crypto/crypto';
import {mutationFailed} from 'src/lib/mutation';
import documentCheckIllustration from '../../../assets/document-check-illustration.svg';
import {
  PasswordChecklist,
  validatePassword,
} from '../../../components/password-checklist';
import {useResetPasswordMutation} from './reset-password.generated';

/**
 * Typ für das Formular zum Zurücksetzen des Passworts.
 */
type ResetPasswordForm = {
  currentPassword: string;
  newPassword: string;
  repeatNewPassword: string;
};

/**
 * Komponente zum Zurücksetzen des Passworts.
 * Stellt ein Formular bereit, das die Eingabe des aktuellen und neuen Passworts ermöglicht und die Passwortänderung durchführt.
 */
export const ResetPassword = () => {
  const builder = useFormBuilder<ResetPasswordForm>();
  const {user, personalPrivateKey} = useAuth();

  builder.fields.newPassword.$useWatch();
  builder.fields.repeatNewPassword.$useWatch();

  const [success, setSuccess] = useState<boolean | null>(null);

  const [, mutateResetPassword] = useResetPasswordMutation();

  /**
   * Funktion zum Verarbeiten des Formulars und Ausführen der Passwortänderung.
   * @param form Formular-Daten mit aktuellem und neuem Passwort
   */
  const submit = useCallback(
    async (form: ResetPasswordForm) => {
      setSuccess(null);

      if (
        user?.__typename === 'BackofficeUser' &&
        user.organisationPrivateKey &&
        personalPrivateKey
      ) {
        const personalKeyPair = await generateKeyPair();

        const encryptedPersonalKey = await encryptPersonalKey(
          form.newPassword,
          user.eMail,
          personalKeyPair.privateKey,
        );

        const newOrganizationPrivateKey =
          await reencryptOrganisationKeyForNewUser(
            personalPrivateKey,
            user.organisationPrivateKey,
            personalKeyPair.publicKey,
          );

        const result = await mutateResetPassword({
          input: {
            currentPassword: await getServerLoginPassword(
              form.currentPassword,
              user.eMail,
            ),
            newPassword: await getServerLoginPassword(
              form.newPassword,
              user.eMail,
            ),
            personalPublicKey: await exportPublicKey(personalKeyPair.publicKey),
            personalPrivateKey: encryptedPersonalKey.encrypted,
            personalPrivateKeySalt: encryptedPersonalKey.salt,
            organizationPrivateKey: newOrganizationPrivateKey,
          },
        });

        if (mutationFailed(result)) return;
        setSuccess(!!result.data!.resetPassword.boolean);
      }
    },
    [mutateResetPassword, personalPrivateKey, user],
  );

  return (
    <div className='container flex h-full max-w-xl flex-col gap-4 py-8'>
      {success === true ? (
        <>
          <img
            src={documentCheckIllustration}
            className='mx-auto max-w-[150px]'
          />
          <h1 className='text-3xl font-bold text-gray-700'>
            Passwort zurückgesetzt
          </h1>
          <p>Ihr Passwort wurde erfolgreich zurückgesetzt.</p>
        </>
      ) : (
        <>
          <h1 className='text-2xl font-bold'>Passwort zurücksetzen</h1>
          <p>Bitte geben Sie ein neues Passwort ein.</p>
          <Form builder={builder} onSubmit={submit}>
            <InputFormField
              type='password'
              label='Altes Passwort'
              on={builder.fields.currentPassword}
              rules={{
                required: true,
              }}
            />

            <InputFormField
              type='password'
              label='Neues Passwort'
              on={builder.fields.newPassword}
              rules={{
                required: true,
                validate: (value: string) => {
                  const failedRules = validatePassword(
                    value,
                    builder.getValues().repeatNewPassword,
                  );
                  if (failedRules.length > 0) {
                    return 'Das Passwort verstößt gegen ein oder mehere Validierungsregeln.';
                  }
                },
              }}
            />

            <InputFormField
              type='password'
              label='Neues Passwort bestätigen'
              on={builder.fields.repeatNewPassword}
              rules={{
                required: true,
              }}
            />

            <PasswordChecklist
              failedRules={validatePassword(
                builder.getValues().newPassword,
                builder.getValues().repeatNewPassword,
              )}
            />

            <Button
              className='mt-4 w-full'
              disabled={user?.__typename !== 'BackofficeUser'}
            >
              Passwort zurücksetzen
            </Button>

            {success === false && (
              <p className='mt-4'>
                <span className='text-red-500'>
                  Beim Zurücksetzen Ihres Passwortes ist ein Fehler aufgetreten.
                </span>
              </p>
            )}
          </Form>
        </>
      )}
    </div>
  );
};

/**
 * Route-Definition für die Passwort-zurücksetzen-Seite.
 */
export const resetPasswordRoute: RouteObject = {
  path: 'reset-password',
  element: <ResetPassword />,
};
