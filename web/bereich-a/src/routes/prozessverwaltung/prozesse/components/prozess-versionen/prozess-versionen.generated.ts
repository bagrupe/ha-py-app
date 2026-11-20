import * as Types from '../../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type ProzessVersionenFuerLoeschungQueryVariables = Types.Exact<{
  kommuneId: string;
  prozessId: string;
}>;

export type ProzessVersionenFuerLoeschungQuery = {
  __typename?: 'Query';
  kommune: {
    __typename?: 'Kommune';
    prozessById: {
      __typename?: 'Prozess';
      id: string;
      versionen: Array<{
        __typename?: 'ProzessVersion';
        id: string;
        createdAt?: Date | null;
        publishedAt?: Date | null;
        hatAusfuehrungen: boolean;
      }>;
    };
  };
};

export const ProzessVersionenFuerLoeschungDocument = gql`
  query ProzessVersionenFuerLoeschung($kommuneId: UUID!, $prozessId: UUID!) {
    kommune(kommuneId: $kommuneId) {
      prozessById(id: $prozessId) {
        id
        versionen {
          id
          createdAt
          publishedAt
          hatAusfuehrungen
        }
      }
    }
  }
`;

export function useProzessVersionenFuerLoeschungQuery(
  options: Omit<
    Urql.UseQueryArgs<ProzessVersionenFuerLoeschungQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    ProzessVersionenFuerLoeschungQuery,
    ProzessVersionenFuerLoeschungQueryVariables
  >({query: ProzessVersionenFuerLoeschungDocument, ...options});
}
