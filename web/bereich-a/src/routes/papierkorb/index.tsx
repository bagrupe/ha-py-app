import type {RouteObject} from 'react-router';
import {GlobaleFunktionsberechtigung} from '../../__generated__/graphql.ts';
import {IfFunktionsberechtigung} from '../../components/if-funktionsberechtigung.tsx';
import {PapierkorbDetail} from './papierkorb-detail.tsx';
import {PapierkorbListe} from './papierkorb-liste.tsx';

export const papierkorbRoute: RouteObject = {
  path: 'papierkorb',
  children: [
    {
      index: true,
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.AntragLoeschung}
          modal
        >
          <PapierkorbListe />
        </IfFunktionsberechtigung>
      ),
    },
    {
      path: ':id',
      element: (
        <IfFunktionsberechtigung
          funktionsberechtigung={GlobaleFunktionsberechtigung.AntragLoeschung}
          modal
        >
          <PapierkorbDetail />
        </IfFunktionsberechtigung>
      ),
    },
  ],
};
