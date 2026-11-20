import {motion} from 'framer-motion';
import {Outlet, type RouteObject} from 'react-router';
import {supportsWebCrypto} from '../../lib/crypto/crypto.tsx';
import {useAsyncMemo} from '../../lib/hooks/use-async-memo.ts';
import {acceptInvitationRoute} from './accept-invitation/accept-invitation.tsx';
import {SlidingKommuneDisplay} from './components/sliding-kommune-display.tsx';
import {loginRoute} from './login/login.tsx';
import {confirmResetPasswordRoute} from './reset-password/confirm/confirm.tsx';
import {resetPasswordRoute} from './reset-password/reset-password.tsx';

/**
 * Komponente für die Authentifizierungsseite.
 * Prüft die Unterstützung von WebCrypto und zeigt je nach Ergebnis den Inhalt oder eine Warnung an.
 * Zeigt eine vollflächige, animiert wechselnde Hintergrundbilder-Anzeige mit einer davor
 * schwebenden Karte für den eigentlichen Inhalt (Login, Passwort zurücksetzen, ...).
 */
export const AuthPage = () => {
  const {value: doesSupportWebCrypto, error} = useAsyncMemo(
    () => supportsWebCrypto(),
    [],
  );

  return (
    <div className='relative z-0 flex h-screen flex-col overflow-hidden bg-white'>
      <div className='absolute inset-0 -z-10'>
        <SlidingKommuneDisplay />
      </div>

      <div className='flex flex-1 flex-col overflow-auto px-4 py-8 sm:px-6'>
        <motion.div
          animate={{
            boxShadow: [
              '0 0 0px 0px rgba(255,255,255,0.0), 0 25px 50px -12px rgba(0,0,0,0.35)',
              '0 0 45px 10px rgba(255,255,255,0.55), 0 25px 50px -12px rgba(0,0,0,0.35)',
              '0 0 0px 0px rgba(255,255,255,0.0), 0 25px 50px -12px rgba(0,0,0,0.35)',
            ],
          }}
          transition={{
            duration: 2.2,
            repeat: Infinity,
            ease: 'easeInOut',
          }}
          className='m-auto w-full max-w-md rounded-2xl bg-white/80 p-8 ring-1 ring-white/40 backdrop-blur-md sm:p-10'
        >
          {Boolean(error) && (
            <div className='text-lg font-medium text-red-700'>
              Die Browser-Unterstützung für die Verschlüsselung konnte nicht
              geprüft werden. Bitte laden Sie die Seite neu.
            </div>
          )}
          {doesSupportWebCrypto === false && (
            <div className='text-lg font-medium'>
              Ihr Browser unterstützt nicht die nötigen Schnittstellen zur
              Ende-zu-Ende Verschlüsselung. Bitte verwenden Sie einen modernen
              Browser.
            </div>
          )}
          {!error && doesSupportWebCrypto !== false && <Outlet />}
        </motion.div>
      </div>

      <div className='flex justify-center gap-x-4 px-4 py-2 text-white/90 [text-shadow:0_1px_2px_rgb(0_0_0_/_0.4)]'>
        <a href='/impressum' rel='noreferrer noopener' target='_blank'>
          Impressum
        </a>
        <a href='/datenschutz' rel='noreferrer noopener' target='_blank'>
          Datenschutzerklärung
        </a>
      </div>
    </div>
  );
};

/**
 * Route-Definition für den Authentifizierungsbereich.
 * Enthält die Pfade und Komponenten für Login, Passwort zurücksetzen, Passwortbestätigung und Einladung annehmen.
 */
export const authRoute: RouteObject = {
  path: 'auth',
  element: <AuthPage />,
  children: [
    loginRoute,
    resetPasswordRoute,
    confirmResetPasswordRoute,
    acceptInvitationRoute,
  ],
};
