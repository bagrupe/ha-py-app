import {type RouteObject} from 'react-router';
import {
  FunktionsberechtigungInOrganisationseinheit,
  GlobaleFunktionsberechtigung,
} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {KategoriebaumVerwalten} from './kategoriebaum/kategoriebaum-verwalten.tsx';
import {Prozesse} from './prozesse/prozesse.tsx';

/**
 * Route-Definition für die Prozessverwaltung.
 * Stellt sicher, dass nur Nutzer mit entsprechender Berechtigung Zugriff auf die Prozessübersicht haben.
 */
export const prozesseVerwaltenRoute: RouteObject = {
  path: 'prozessverwaltung',
  children: [
    {
      index: true,
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.Prozessverwaltung}
          modal
        >
          <Prozesse />
        </IfFunktionsberechtigung>
      ),
    },
    {
      path: 'kategoriebaum',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung
          }
          modal
        >
          <KategoriebaumVerwalten />
        </IfFunktionsberechtigung>
      ),
    },
  ],
};
