import {Navigate, type RouteObject} from 'react-router';
import {apiDocsRoute} from './api-docs';
import {authRoute} from './auth';
import {deeplinksRoute} from './deeplinks/index.tsx';
import {ErrorPage} from './error-page.tsx';
import {loggedInRoute} from './logged-in';

/**
 * Route, die alle nicht definierten Pfade abfängt und zur Startseite weiterleitet.
 */
const catchAllRoute: RouteObject = {
  path: '*',
  element: <Navigate to='/' />,
};

/**
 * Wurzel-Route des Frontends mit Fehlerbehandlung und untergeordneten Routen.
 */
export const rootRoute: RouteObject = {
  path: '/',
  errorElement: <ErrorPage />,
  children: [
    loggedInRoute,
    authRoute,
    apiDocsRoute,
    catchAllRoute,
    deeplinksRoute,
  ],
};
