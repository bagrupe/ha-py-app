import type {ReactNode} from 'react';
import type {RouteObject} from 'react-router';
import {GlobaleFunktionsberechtigung} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {
  DashboardEinstieg,
  EinsatzleitungSeite,
  LeitstelleSeite,
} from './dashboard/lage-dashboard.tsx';
import {LageDetail} from './lage-detail.tsx';
import {LageListe} from './lage-liste.tsx';

const nurLageHelfer = (element: ReactNode) => (
  <IfFunktionsberechtigung
    funktionsberechtigung={GlobaleFunktionsberechtigung.LageHelfer}
    modal
  >
    {element}
  </IfFunktionsberechtigung>
);

/**
 * Route-Definition für das Lage-Management. Zugriff nur mit der globalen Funktionsberechtigung
 * "LageHelfer", analog zu den Lage-Mutations im Backend.
 */
export const lageRoute: RouteObject = {
  path: 'lage',
  children: [
    {
      index: true,
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.LageHelfer}
          modal
        >
          <LageListe />
        </IfFunktionsberechtigung>
      ),
    },
    {path: 'dashboard', element: nurLageHelfer(<DashboardEinstieg />)},
    {path: 'leitstelle', element: nurLageHelfer(<LeitstelleSeite />)},
    {
      path: 'einsatzleitung/:gruppeId',
      element: nurLageHelfer(<EinsatzleitungSeite />),
    },
    {
      path: ':id',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.LageHelfer}
          modal
        >
          <LageDetail />
        </IfFunktionsberechtigung>
      ),
    },
  ],
};
