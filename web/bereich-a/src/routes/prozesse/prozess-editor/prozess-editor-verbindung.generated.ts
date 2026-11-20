import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';

export type ProzessEditorVerbindungFragment = {
  __typename?: 'Verbindung';
  id: string;
  name?: string | null;
  vonId: string;
  nachId: string;
  statusAenderung?: string | null;
  statusAenderungBeschreibung?: string | null;
  istRelevant: BoolExpression;
};

export const ProzessEditorVerbindungFragmentDoc = gql`
  fragment ProzessEditorVerbindung on Verbindung {
    id
    name
    vonId
    nachId
    name
    statusAenderung
    statusAenderungBeschreibung
    istRelevant
  }
`;
