import {type ReactNode, useEffect} from 'react';
import {Navigate, type RouteObject} from 'react-router';
import {FunktionsberechtigungInOrganisationseinheit} from '../../__generated__/graphql.ts';
import {LoggedInLayout} from '../../components/layouts/logged-in-layout';
import {useAuth} from '../../lib/context/auth/auth.tsx';
import {hasFunktionsberechtigungInAnyOrganisationseinheit} from '../../lib/funktionsberechtigung.ts';
import {antraegeRoute} from '../antraege';
import {archivRoute} from '../archiv';
import {einstellungenRoute} from '../einstellungen';
import {lageRoute} from '../lage';
import {nutzendenverwaltungRoute} from '../nutzendenverwaltung';
import {papierkorbRoute} from '../papierkorb';
import {profileRoutes} from '../profile/index.tsx';
import {prozesseRoute} from '../prozesse';
import {prozesseVerwaltenRoute} from '../prozessverwaltung';

/**
 * Komponente, die überprüft, ob der Nutzer eingeloggt ist und andernfalls zur Login-Seite weiterleitet.
 * @param children Die darzustellenden Kind-Komponenten, wenn der Nutzer eingeloggt ist
 * @returns Die Kind-Komponenten oder eine Weiterleitung zur Login-Seite
 */
const RedirectIfNotLoggedIn = ({children}: {children?: ReactNode}) => {
  const {isLoggedIn} = useAuth();
  if (!isLoggedIn) {
    return <Navigate to='/auth/login' />;
  }
  return children;
};

/**
 * Leitet den Nutzer zur passenden Startseite weiter, abhängig von seinen Berechtigungen.
 */
const DefaultRedirect = () => {
  const {user} = useAuth();
  const backofficeUser = user?.__typename === 'BackofficeUser' ? user : null;
  const hasBackoffice = hasFunktionsberechtigungInAnyOrganisationseinheit(
    backofficeUser,
    FunktionsberechtigungInOrganisationseinheit.Backoffice,
  );

  useEffect(() => {
    if (!hasBackoffice) {
      window.location.href = '/cms/admin';
    }
  }, [hasBackoffice]);

  if (hasBackoffice) {
    return <Navigate to='/antraege/neu' />;
  }

  return null;
};

/**
 * Route-Definition für den Bereich nach dem Login.
 * Stellt das Layout und die untergeordneten Routen bereit, die nur für eingeloggte Nutzer zugänglich sind.
 */
export const loggedInRoute: RouteObject = {
  element: (
    <RedirectIfNotLoggedIn>
      <LoggedInLayout />
    </RedirectIfNotLoggedIn>
  ),
  children: [
    {index: true, element: <DefaultRedirect />},
    antraegeRoute,
    prozesseRoute,
    nutzendenverwaltungRoute,
    lageRoute,
    prozesseVerwaltenRoute,
    einstellungenRoute,
    archivRoute,
    papierkorbRoute,
    profileRoutes,
  ],
};
