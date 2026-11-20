import {type RouteObject} from 'react-router';
import {FunktionsberechtigungInOrganisationseinheit} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {AbgeschlosseneAntraege} from './abgeschlossen/abgeschlossen.tsx';
import {AntraegeInBearbeitung} from './antraege-in-bearbeitung/antraege-in-bearbeitung.tsx';
import {AntragDetail} from './detail/detail.tsx';
import {NeueAntraege} from './neu/neu.tsx';

/**
 * Definiert die Routenstruktur für den Bereich "Anträge" im Frontend.
 * Enthält Pfade und zugehörige Komponenten für neue, in Bearbeitung befindliche,
 * abgeschlossene Anträge sowie Detailansichten einzelner Anträge.
 */
export const antraegeRoute: RouteObject = {
  path: 'antraege',
  children: [
    {
      path: 'neu',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege
          }
          modal
        >
          <NeueAntraege />
        </IfFunktionsberechtigung>
      ),
    },
    {
      path: 'in-bearbeitung',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege
          }
          modal
        >
          <AntraegeInBearbeitung />
        </IfFunktionsberechtigung>
      ),
    },
    {
      path: 'abgeschlossen',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege
          }
          modal
        >
          <AbgeschlosseneAntraege />
        </IfFunktionsberechtigung>
      ),
    },
    {
      path: ':id',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={
            FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege
          }
          modal
        >
          <AntragDetail />
        </IfFunktionsberechtigung>
      ),
    },
  ],
};
