import * as Sentry from '@sentry/react';
import {useEffect} from 'react';
import {Helmet, HelmetProvider} from 'react-helmet-async';
import {
  createRoutesFromChildren,
  matchRoutes,
  RouterProvider,
  useLocation,
  useNavigationType,
} from 'react-router';
import {ToastContainer} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import {ConfirmContextProvider} from './components/modal/confirm-modal.tsx';
import generatedGitInfo from './generatedGitInfo.json';
import {AuthProvider} from './lib/context/auth/auth.tsx';
import {SENTRY_DSN} from './lib/sentry.ts';
import {router} from './router.tsx';
import {UrqlProvider} from './urql.tsx';

Sentry.init({
  dsn: import.meta.env.VITE_SENTRY_DSN || SENTRY_DSN,
  enabled: !import.meta.env.DEV,
  integrations: [
    Sentry.reactRouterV7BrowserTracingIntegration({
      useEffect,
      useLocation,
      useNavigationType,
      createRoutesFromChildren,
      matchRoutes,
    }),
    Sentry.captureConsoleIntegration(),
    Sentry.reportingObserverIntegration(),
  ],
  environment: generatedGitInfo.environment,
  release: generatedGitInfo.release,
  beforeSend(event) {
    if (event.message?.includes('[vite]')) return null;
    return event;
  },
});

/**
 * Hauptkomponente der Anwendung.
 * Stellt Kontext-Provider für Authentifizierung, GraphQL, Routing und modale Bestätigungen bereit.
 * Bindet Sentry Fehlergrenze und Helmet für das Dokumenten-Head-Management ein.
 * @returns React-Komponente der App.
 */
const App = () => (
  <Sentry.ErrorBoundary
    fallback={
      <main className='flex min-h-screen items-center justify-center p-6'>
        <p className='text-center text-lg'>
          Die Anwendung konnte nicht geladen werden. Bitte laden Sie die Seite
          neu.
        </p>
      </main>
    }
  >
    <HelmetProvider>
      <AuthProvider>
        <UrqlProvider navigate={router.navigate}>
          <Helmet>
            <title>Kommunal App Bereich A</title>
          </Helmet>
          <ConfirmContextProvider>
            <RouterProvider router={router} />
            <ToastContainer position='bottom-right' theme='light' />
          </ConfirmContextProvider>
        </UrqlProvider>
      </AuthProvider>
    </HelmetProvider>
  </Sentry.ErrorBoundary>
);

export default App;
