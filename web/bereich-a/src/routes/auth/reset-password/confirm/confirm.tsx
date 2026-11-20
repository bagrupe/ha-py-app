import {useFormBuilder} from '@atmina/formbuilder';
import {ArrowLeftIcon} from '@radix-ui/react-icons';
import {useCallback, useMemo, useState} from 'react';
import {Helmet} from 'react-helmet-async';
import {type RouteObject, Link, useSearchParams, useParams} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {PasswordConfirmationResult} from 'src/__generated__/graphql.ts';
import {
  encryptPersonalKey,
  exportPublicKey,
  generateKeyPair,
  getServerLoginPassword,
} from 'src/lib/crypto/crypto.tsx';
import {mutationFailed} from 'src/lib/mutation';
import documentCheckIllustration from '../../../../assets/document-check-illustration.svg';
import {EmailFormField} from '../../../../components/form/fields/email-field/email-field.tsx';
import {InputFormField} from '../../../../components/form/fields/input-field';
import {Form} from '../../../../components/form/form.tsx';
import {
  PasswordChecklist,
  validatePassword,
} from '../../../../components/password-checklist.tsx';
import {buttonVariants} from '../../../../components/ui/button';
import {AuthSubmitButton} from '../../components/auth-submit-button.tsx';
import {useForgotPasswordConfirmMutation} from '../reset-password.generated.ts';

/**
 * Typ für die Formular-Daten zum Zurücksetzen des Passworts.
 */
type ConfirmPasswordResetForm = {
  email: string;
  password: string;
  repeatPassword: string;
};

/**
 * Komponente zur Bestätigung des Zurücksetzens des Passworts.
 * Verarbeitet das Formular, verschlüsselt Schlüssel und sendet die Daten an den Server.
 */
export const ConfirmResetPassword = () => {
  const {code} = useParams<{code: string}>();
  const [params] = useSearchParams();

  const email = useMemo(() => {
    const email = params.get('email');
    return email;
  }, [params]);

  const builder = useFormBuilder<ConfirmPasswordResetForm>({
    defaultValues: {
      email: email ?? '',
    },
  });

  builder.fields.password.$useWatch();
  builder.fields.repeatPassword.$useWatch();

  const [result, setResult] = useState<PasswordConfirmationResult | null>(null);

  const [, mutateForgotPasswordConfirm] = useForgotPasswordConfirmMutation();

  /**
   * Führt die Bestätigung des Passwort-Zurücksetzens durch.
   * @param form Formular-Daten mit E-Mail und neuem Passwort
   */
  const confirmResetPassword = useCallback(
    async (form: ConfirmPasswordResetForm) => {
      if (!code) return;
      setResult(null);

      const password = await getServerLoginPassword(form.password, form.email);

      const personalKeyPair = await generateKeyPair();

      const encryptedPersonalKey = await encryptPersonalKey(
        form.password,
        form.email,
        personalKeyPair.privateKey,
      );

      const result = await mutateForgotPasswordConfirm({
        input: {
          password,
          passwordResetCode: code,
          personalPublicKey: await exportPublicKey(personalKeyPair.publicKey),
          personalPrivateKey: encryptedPersonalKey.encrypted,
          personalPrivateKeySalt: encryptedPersonalKey.salt,
        },
      });

      if (mutationFailed(result)) return;
      setResult(result.data!.forgotPasswordConfirm.result ?? null);
    },
    [code, mutateForgotPasswordConfirm],
  );

  /**
   * Funktion zum Absenden des Formulars.
   * @param form Formular-Daten mit E-Mail und neuem Passwort
   */
  const submit = useCallback(
    async (form: ConfirmPasswordResetForm) => {
      await confirmResetPassword(form);
    },
    [confirmResetPassword],
  );

  return (
    <>
      <Helmet>
        <title>Passwort zurücksetzen</title>
      </Helmet>
      <div className='m-auto flex w-full max-w-md flex-col gap-4'>
        {result === PasswordConfirmationResult.Success ? (
          <>
            <img
              src={documentCheckIllustration}
              className='mx-auto max-w-[150px]'
            />
            <h1 className='text-3xl font-bold text-gray-700'>
              Passwort zurückgesetzt
            </h1>
            <p>
              Ihr Passwort wurde erfolgreich zurückgesetzt. Nach Bestätigung
              einer administrierenden Person können Sie sich mit Ihrem neuen
              Passwort anmelden.
            </p>
            <Link
              to='/auth/login'
              className={twMerge(
                buttonVariants({variant: 'outlined'}),
                'mt-4 w-full text-center',
              )}
            >
              Zum Login
            </Link>
          </>
        ) : (
          <>
            <Link
              to='/auth/login'
              className='flex items-center gap-2 text-primary'
            >
              <ArrowLeftIcon />
              <span>Zurück zum Login</span>
            </Link>
            <h1 className='text-3xl font-bold text-gray-700'>
              Passwort zurücksetzen
            </h1>
            <p>Bitte geben Sie ein neues Passwort ein.</p>

            <Form builder={builder} onSubmit={submit}>
              <EmailFormField
                disabled
                label='E-Mail'
                on={builder.fields.email}
                autoComplete='email'
                rules={{
                  required: true,
                }}
                className='w-full'
              />

              <InputFormField
                label='Passwort'
                on={builder.fields.password}
                type='password'
                rules={{
                  required: true,
                  validate: (value: string) => {
                    const failedRules = validatePassword(
                      value,
                      builder.getValues().repeatPassword,
                    );
                    if (failedRules.length > 0) {
                      return 'Das Passwort verstößt gegen ein oder mehrere Validierungsregeln.';
                    }
                  },
                }}
                className='w-full'
              />

              <InputFormField
                label='Passwort bestätigen'
                on={builder.fields.repeatPassword}
                type='password'
                rules={{
                  required: true,
                }}
                className='w-full'
              />

              <PasswordChecklist
                failedRules={validatePassword(
                  builder.getValues().password,
                  builder.getValues().repeatPassword,
                )}
              />

              <AuthSubmitButton>Passwort zurücksetzen</AuthSubmitButton>

              {result === PasswordConfirmationResult.CodeExpired && (
                <p className='mt-4'>
                  Der Link zum Zurücksetzen Ihres Passwortes ist abgelaufen.
                  Bitte{' '}
                  <Link to='/auth/reset-password' className='text-primary'>
                    erzeugen Sie einen neuen Link
                  </Link>
                  .
                </p>
              )}

              {result === PasswordConfirmationResult.InvalidCode && (
                <p className='mt-4'>
                  <span className='text-red-500'>
                    Beim Zurücksetzen Ihres Passwortes ist ein Fehler
                    aufgetreten.
                  </span>
                </p>
              )}
            </Form>
          </>
        )}
      </div>
    </>
  );
};

/**
 * Route für die Bestätigung des Passwort-Zurücksetzens.
 */
export const confirmResetPasswordRoute: RouteObject = {
  path: 'reset-password/:code',
  element: <ConfirmResetPassword />,
};
