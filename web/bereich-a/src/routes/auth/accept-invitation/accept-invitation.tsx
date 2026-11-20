import {useFormBuilder} from '@atmina/formbuilder';
import {useCallback, useState} from 'react';
import {Helmet} from 'react-helmet-async';
import {type RouteObject, Link, useSearchParams, useParams} from 'react-router';
import {twMerge} from 'tailwind-merge';
import {RegisterBackofficeUserResult} from 'src/__generated__/graphql.ts';
import {
  encryptPersonalKey,
  exportPublicKey,
  generateKeyPair,
  getServerLoginPassword,
} from 'src/lib/crypto/crypto.tsx';
import {mutationFailed} from 'src/lib/mutation';
import documentCheckIllustration from '../../../assets/document-check-illustration.svg';
import {EmailFormField} from '../../../components/form/fields/email-field/email-field.tsx';
import {InputFormField} from '../../../components/form/fields/input-field';
import {Form} from '../../../components/form/form.tsx';
import {
  PasswordChecklist,
  validatePassword,
} from '../../../components/password-checklist.tsx';
import {buttonVariants} from '../../../components/ui/button';
import {AuthSubmitButton} from '../components/auth-submit-button.tsx';
import {useAcceptInvitationMutation} from './accept-invitation.generated.ts';

/**
 * Typ für die Formular-Daten der Einladungsannahme.
 */
type AcceptInvitationFormData = {
  email: string;
  vorname: string;
  nachname: string;
  password: string;
  repeatPassword: string;
};

/**
 * Komponente zur Annahme einer Einladung und Registrierung eines neuen Nutzers.
 * Verarbeitet das Formular, verschlüsselt Schlüssel und führt die Registrierung durch.
 * Nutzt den Einladungscode aus der URL und zeigt den Erfolg oder Fehler an.
 */
export const AcceptInvitation = () => {
  const {code} = useParams<{code: string}>();
  const [params] = useSearchParams();

  const builder = useFormBuilder<AcceptInvitationFormData>({
    defaultValues: {
      email: params.get('email') || '',
      vorname: '',
      nachname: '',
      password: '',
      repeatPassword: '',
    },
  });

  const [result, setResult] = useState<RegisterBackofficeUserResult | null>(
    null,
  );
  builder.fields.password.$useWatch();
  builder.fields.repeatPassword.$useWatch();

  const [, acceptInvitation] = useAcceptInvitationMutation();

  /**
   * Funktion zum Absenden des Registrierungsformulars.
   * Verschlüsselt den privaten Schlüssel und sendet die Registrierungsdaten an den Server.
   * @param data Die eingegebenen Formulardaten
   */
  const submit = useCallback(
    async (data: AcceptInvitationFormData) => {
      if (!code) return;
      setResult(null);

      const password = await getServerLoginPassword(data.password, data.email);

      const personalKeyPair = await generateKeyPair();

      const encryptedPersonalKey = await encryptPersonalKey(
        data.password,
        data.email,
        personalKeyPair.privateKey,
      );

      const result = await acceptInvitation({
        input: {
          invitationCode: code,
          vorname: data.vorname,
          nachname: data.nachname,
          derivedPassword: password,
          publicKey: await exportPublicKey(personalKeyPair.publicKey),
          encryptedPrivateKey: encryptedPersonalKey.encrypted,
          salt: encryptedPersonalKey.salt,
        },
      });

      if (mutationFailed(result)) return;
      setResult(result.data!.registerBackofficeUser.result ?? null);
    },
    [acceptInvitation, code],
  );

  return (
    <>
      <Helmet>
        <title>Registrierung</title>
      </Helmet>
      <div className='m-auto flex w-full max-w-md flex-col gap-4'>
        {result === RegisterBackofficeUserResult.Success ? (
          <Success />
        ) : (
          <>
            <h1 className='text-3xl font-bold text-gray-700'>Registrieren</h1>
            <p>
              Sie wurden eingeladen, sich zu registrieren. Bitte geben Sie
              folgende Daten an.
            </p>

            <Form builder={builder} onSubmit={submit}>
              <div className='flex flex-col gap-2'>
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
                  label='Vorname'
                  on={builder.fields.vorname}
                  rules={{required: true}}
                  className='asdf'
                />
                <InputFormField
                  label='Nachname'
                  on={builder.fields.nachname}
                  rules={{required: true}}
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
                        return 'Das Passwort verstößt gegen ein oder mehere Validierungsregeln.';
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
              </div>

              <AuthSubmitButton>Registrieren</AuthSubmitButton>

              {result === RegisterBackofficeUserResult.CodeExpired && (
                <p className='mt-4'>
                  Der Einladungs-Link ist abgelaufen. Bitte wenden Sie sich an
                  einen Administrator.
                </p>
              )}

              {result === RegisterBackofficeUserResult.InvalidCode && (
                <p className='mt-4'>
                  <span className='text-red-500'>
                    Beim der Registrierung ist ein Fehler aufgetreten.
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
 * Komponente zur Anzeige der erfolgreichen Registrierung.
 * Informiert den Nutzer über den Abschluss und bietet einen Link zum Login.
 */
const Success = () => (
  <>
    <img src={documentCheckIllustration} className='mx-auto max-w-[150px]' />
    <h1 className='text-3xl font-bold text-gray-700'>
      Registrierung abgeschlossen
    </h1>
    <p>
      Ihre Registrierung war erfolgreich. Nach Bestätigung einer
      administrierenden Person können Sie sich mit Ihrer E-Mail Adresse und
      Ihrem Passwort anmelden.
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
);

/**
 * Route für die Annahme einer Einladung mit dem Einladungscode als URL-Parameter.
 */
export const acceptInvitationRoute: RouteObject = {
  path: 'accept-invitation/:code',
  element: <AcceptInvitation />,
};
