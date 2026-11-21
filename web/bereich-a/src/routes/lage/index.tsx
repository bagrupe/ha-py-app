import type {RouteObject} from 'react-router';
import {GlobaleFunktionsberechtigung} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {LageDetail} from './lage-detail.tsx';
import {LageListe} from './lage-liste.tsx';

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
