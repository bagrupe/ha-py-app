import {useFormBuilder} from '@atmina/formbuilder';
import {ArrowLeftIcon} from '@radix-ui/react-icons';
import {useCallback, useState} from 'react';
import {Helmet} from 'react-helmet-async';
import {type RouteObject, Link} from 'react-router';
import {mutationFailed} from 'src/lib/mutation';
import {EmailFormField} from '../../../components/form/fields/email-field/email-field.tsx';
import {Form} from '../../../components/form/form.tsx';
import {AuthSubmitButton} from '../components/auth-submit-button.tsx';
import {useForgotPasswordMutation} from './reset-password.generated.ts';

/**
 * Typ für das Formular zum Zurücksetzen des Passworts mit der E-Mail-Adresse.
 */
type ResetPasswordForm = {
  email: string;
};

/**
 * Komponente für die Passwort-zurücksetzen-Seite.
 * Stellt ein Formular bereit, um einen Link zum Zurücksetzen des Passworts per E-Mail anzufordern.
 */
export const ResetPassword = () => {
  const builder = useFormBuilder<ResetPasswordForm>();
  const [sent, setSent] = useState(false);

  const [, mutateForgotPassword] = useForgotPasswordMutation();

  /**
   * Führt die Anfrage zum Zurücksetzen des Passworts aus.
   * @param form Formular mit der E-Mail-Adresse
   */
  const resetPassword = useCallback(
    async (form: ResetPasswordForm) => {
      setSent(false);
      const result = await mutateForgotPassword({
        input: {
          email: form.email,
        },
      });

      if (mutationFailed(result)) return;
      if (result.data!.forgotPassword.boolean) {
        setSent(true);
      }
    },
    [mutateForgotPassword],
  );

  /**
   * Callback für das Absenden des Formulars.
   * @param form Formular mit der E-Mail-Adresse
   */
  const submit = useCallback(
    async (form: ResetPasswordForm) => {
      await resetPassword(form);
    },
    [resetPassword],
  );

  return (
    <>
      <Helmet>
        <title>Passwort vergessen</title>
      </Helmet>
      <div className='m-auto flex w-full max-w-md flex-col gap-4'>
        <Link to='/auth/login' className='flex items-center gap-2 text-primary'>
          <ArrowLeftIcon />
          <span>Zurück zum Login</span>
        </Link>
        <h1 className='text-3xl font-bold text-gray-700'>
          Passwort vergessen?
        </h1>
        <p>
          Keine Sorge, wir senden Ihnen einen Link an Ihre E-Mail, mit der Sie
          Ihr Passwort zurücksetzen können.
        </p>

        <Form builder={builder} onSubmit={submit}>
          <EmailFormField
            disabled={sent}
            label='E-Mail'
            on={builder.fields.email}
            autoComplete='email'
            rules={{
              required: true,
            }}
            className='w-full'
          />

          <AuthSubmitButton disabled={sent}>
            Passwort zurücksetzen
          </AuthSubmitButton>
          {sent && (
            <p className='mt-4 text-primary'>
              Sie erhalten in Kürze einen Link zum Zurücksetzen Ihres Passwortes
              per E-Mail.
            </p>
          )}
        </Form>
      </div>
    </>
  );
};

/**
 * Route für die Passwort-zurücksetzen-Seite.
 */
export const resetPasswordRoute: RouteObject = {
  path: 'reset-password',
  element: <ResetPassword />,
};
