import type {RouteObject} from 'react-router';
import {GlobaleFunktionsberechtigung} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {ArchivDetail} from './archiv-detail.tsx';
import {ArchivListe} from './archiv-liste.tsx';

/**
 * Route-Definition für das Archiv (read-only). Zugriffsschutz per Funktionsberechtigung
 * 'Archiv einsehen' auf Routen-Ebene, wie in routes/antraege/index.tsx.
 */
export const archivRoute: RouteObject = {
  path: 'archiv',
  children: [
    {
      index: true,
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.ArchivEinsicht}
          modal
        >
          <ArchivListe />
        </IfFunktionsberechtigung>
      ),
    },
    {
      path: ':id',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.ArchivEinsicht}
          modal
        >
          <ArchivDetail />
        </IfFunktionsberechtigung>
      ),
    },
  ],
};
