import {useFormBuilder} from '@atmina/formbuilder';
import {useCallback, useEffect, useMemo, useState} from 'react';
import {Helmet} from 'react-helmet-async';
import {useNavigate} from 'react-router';
import {type RouteObject, useSearchParams, Link} from 'react-router';
import {hasFunktionsberechtigungInAnyOrganisationseinheit} from 'src/lib/funktionsberechtigung.ts';
import {
  FunktionsberechtigungInOrganisationseinheit,
  LoginResult,
} from '../../../__generated__/graphql.ts';
import {EmailFormField} from '../../../components/form/fields/email-field/email-field.tsx';
import {PasswordInputFormField} from '../../../components/form/fields/password-input-field';
import {Form} from '../../../components/form/form.tsx';
import type {UserFragment} from '../../../lib/context/auth/auth.generated.ts';
import {useAuth} from '../../../lib/context/auth/auth.tsx';
import {AuthSubmitButton} from '../components/auth-submit-button.tsx';

/**
 * Typ für die Login-Daten mit E-Mail, Passwort und optionalem Zwei-Faktor-Code.
 */
type EmailPasswordForm = {
  email: string;
  password: string;
  twoFactorCode?: string;
};

type BackofficeUserFragment = Extract<
  UserFragment,
  {__typename: 'BackofficeUser'}
>;

const backofficeUserFromFragment = (
  user: UserFragment,
): BackofficeUserFragment | null =>
  user.__typename === 'BackofficeUser' ? user : null;

/**
 * Gibt den Startpath für den Benutzer zurück
 * @param backofficeUser
 * @returns
 */
const defaultStartPathForBackofficeUser = (
  backofficeUser: BackofficeUserFragment | null,
): string => {
  if (
    backofficeUser !== null &&
    !hasFunktionsberechtigungInAnyOrganisationseinheit(
      backofficeUser,
      FunktionsberechtigungInOrganisationseinheit.Backoffice,
    )
  ) {
    return '/cms/admin';
  }
  return '/antraege/neu';
};

/**
 * Komponente für die Login-Seite.
 * Verwaltet das Login-Formular, führt die Authentifizierung durch und leitet bei Erfolg weiter.
 */
export const Login = () => {
  const {isLoggedIn, user, passwordLogin} = useAuth();

  const [loginResult, setLoginResult] = useState<LoginResult | undefined>(
    undefined,
  );
  const builder = useFormBuilder<EmailPasswordForm>();
  const navigate = useNavigate();
  const [params] = useSearchParams();
  const redirectTo = params.get('redirect');
  const forceLogin = params.has('force');

  const startPath = defaultStartPathForBackofficeUser(user);
  const to = redirectTo && redirectTo.startsWith('/') ? redirectTo : startPath;

  /**
   * Führt eine Weiterleitung durch.
   * @param to Zielpfad der Weiterleitung
   */
  const redirect = useCallback(
    (to: string) => {
      if (to.startsWith('/cms')) {
        // Can't use navigate() because it's not part of the Router.
        window.location.assign(new URL(to, window.location.href));
      } else {
        navigate(to);
      }
    },
    [navigate],
  );

  useEffect(() => {
    if (isLoggedIn && !forceLogin) {
      redirect(to);
    }
  }, [forceLogin, isLoggedIn, redirect, to]);

  /**
   * Führt den Login-Vorgang aus.
   * @param form Login-Daten aus dem Formular
   * @param withTwoFactorCode Gibt an, ob der Zwei-Faktor-Code verwendet werden soll
   */
  const login = useCallback(
    async (form: EmailPasswordForm, withTwoFactorCode = true) => {
      if (!withTwoFactorCode) {
        builder.reset({
          ...form,
          twoFactorCode: '',
        });
      }

      const outcome = await passwordLogin(
        form.email,
        form.password,
        withTwoFactorCode ? form.twoFactorCode : undefined,
      );

      if (!outcome.ok) {
        if (outcome.result !== undefined) {
          setLoginResult(outcome.result);
        }
      } else {
        const pathAfterLogin = defaultStartPathForBackofficeUser(
          backofficeUserFromFragment(outcome.user),
        );
        const target =
          redirectTo && redirectTo.startsWith('/')
            ? redirectTo
            : pathAfterLogin;
        redirect(target);
      }
    },
    [builder, passwordLogin, redirect, redirectTo],
  );

  /**
   * Callback für das Absenden des Login-Formulars.
   * @param form Login-Daten aus dem Formular
   */
  const submit = useCallback(
    async (form: EmailPasswordForm) => {
      await login(form);
    },
    [login],
  );

  /**
   * Ermittelt die Fehlermeldung basierend auf dem Login-Ergebnis.
   */
  const errorMessage = useMemo(() => {
    if (loginResult !== undefined) {
      switch (loginResult) {
        case LoginResult.WrongLogin:
          return 'Entweder Nutzername oder Passwort sind falsch.';
        case LoginResult.NeedsConfirmation:
          return 'Ihr Zugang muss von einem Administrator Ihrer Organisation bestätigt werden bevor Sie sich anmelden können.';
      }
    }
  }, [loginResult]);

  return (
    <>
      <Helmet>
        <title>Anmelden</title>
      </Helmet>
      <div className='m-auto flex w-full max-w-md flex-col gap-4'>
        <h1 className='text-3xl font-bold text-gray-700'>
          Herzlich Willkommen!
        </h1>

        <Form builder={builder} onSubmit={submit}>
          <EmailFormField
            label='E-Mail'
            on={builder.fields.email}
            autoComplete='email'
            rules={{
              required: true,
            }}
            className='w-full rounded-xl shadow-sm transition-shadow focus-within:shadow-md'
            fieldsetClass='rounded-xl border-gray-200'
            inputClass='py-3'
          />
          <PasswordInputFormField
            label='Passwort'
            on={builder.fields.password}
            autoComplete='current-password'
            rules={{required: true}}
            className='w-full rounded-xl shadow-sm transition-shadow focus-within:shadow-md'
            fieldsetClass='rounded-xl border-gray-200'
            inputClass='py-3'
          />
          <div className='flex justify-end'>
            <Link
              to='/auth/reset-password'
              className='text-sm font-medium text-primary transition-colors hover:text-primary/70'
            >
              Passwort vergessen?
            </Link>
          </div>

          {errorMessage && (
            <p className='mt-2 text-sm text-primary'>{errorMessage}</p>
          )}

          <AuthSubmitButton>Anmelden</AuthSubmitButton>
        </Form>
      </div>
    </>
  );
};

/**
 * Route für die Login-Seite.
 */
export const loginRoute: RouteObject = {
  path: 'login',
  element: <Login />,
};
