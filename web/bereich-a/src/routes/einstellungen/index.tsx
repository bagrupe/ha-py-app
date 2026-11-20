import type {RouteObject} from 'react-router';
import {GlobaleFunktionsberechtigung} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {AufbewahrungEinstellungen} from './aufbewahrung.tsx';

/**
 * Route-Definition für die Aufbewahrungs-Einstellungen. Zugriffsschutz per
 * Funktionsberechtigung 'Aufbewahrung verwalten' auf Routen-Ebene.
 */
const geschuetzt = (
  <IfFunktionsberechtigung
    funktionsberechtigung={GlobaleFunktionsberechtigung.AufbewahrungVerwaltung}
    modal
  >
    <AufbewahrungEinstellungen />
  </IfFunktionsberechtigung>
);

export const einstellungenRoute: RouteObject = {
  path: 'einstellungen',
  children: [
    {index: true, element: geschuetzt},
    {path: 'aufbewahrung', element: geschuetzt},
  ],
};
