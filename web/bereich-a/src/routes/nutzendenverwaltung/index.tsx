import type {RouteObject} from 'react-router';
import {FunktionsberechtigungInOrganisationseinheit} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {Nutzende} from './nutzende/nutzende.tsx';

/**
 * Route-Definition für die Nutzendenverwaltung.
 * Stellt den Pfad und die zugehörigen Komponenten mit Berechtigungsprüfung bereit.
 */
export const nutzendenverwaltungRoute: RouteObject = {
  path: 'nutzendenverwaltung',
  children: [
    {
      index: true,
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung
          }
          modal
        >
          <Nutzende />
        </IfFunktionsberechtigung>
      ),
    },
  ],
};
