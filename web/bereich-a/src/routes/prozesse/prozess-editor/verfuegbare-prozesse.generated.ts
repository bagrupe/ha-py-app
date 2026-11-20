import * as Types from '../../../__generated__/graphql';

import {ProzessEditorProzessFragment} from './prozess-version-erstellen.generated';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {ProzessEditorProzessFragmentDoc} from './prozess-version-erstellen.generated';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type VerfuegbareProzesseQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type VerfuegbareProzesseQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        id: string;
        kommune: {
          __typename?: 'Kommune';
          prozesse: Array<ProzessEditorProzess>;
          id: string;
        };
      }
    | {__typename?: 'Buerger'; id: string}
    | {__typename?: 'SystemUser'; id: string};
};

export type ProzessEditorProzess = {
  __typename?: 'Prozess';
} & ProzessEditorProzessFragment;

export const VerfuegbareProzesseDocument = gql`
  query VerfuegbareProzesse {
    my {
      id
      ... on BackofficeUser {
        kommune {
          id
          prozesse @export(exportName: "ProzessEditorProzess") {
            ...ProzessEditorProzess
          }
        }
      }
    }
  }
  ${ProzessEditorProzessFragmentDoc}
`;

export function useVerfuegbareProzesseQuery(
  options?: Omit<Urql.UseQueryArgs<VerfuegbareProzesseQueryVariables>, 'query'>,
) {
  return Urql.useQuery<
    VerfuegbareProzesseQuery,
    VerfuegbareProzesseQueryVariables
  >({query: VerfuegbareProzesseDocument, ...options});
}
