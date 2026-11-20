import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type KommuneQueryVariables = Types.Exact<{
  kommuneId: string;
}>;

export type KommuneQuery = {__typename?: 'Query'; kommune: Kommune};

export type Kommune = {
  __typename?: 'Kommune';
  id: string;
  name: string;
  design?: {
    __typename?: 'KommuneDesign';
    colors?: {
      __typename?: 'KommuneDesignColors';
      primary?: string | null;
      primaryLight?: string | null;
    } | null;
    logo?: {__typename?: 'Medien'; url?: string | null} | null;
    mangelIcon?: {__typename?: 'Medien'; url?: string | null} | null;
    ideenIcon?: {__typename?: 'Medien'; url?: string | null} | null;
  } | null;
};

export const KommuneDocument = gql`
  query kommune($kommuneId: UUID!) {
    kommune(kommuneId: $kommuneId) @export(exportName: "Kommune") {
      id
      name
      design {
        colors {
          primary
          primaryLight
        }
        logo {
          url
        }
        mangelIcon {
          url
        }
        ideenIcon {
          url
        }
      }
    }
  }
`;

export function useKommuneQuery(
  options: Omit<Urql.UseQueryArgs<KommuneQueryVariables>, 'query'>,
) {
  return Urql.useQuery<KommuneQuery, KommuneQueryVariables>({
    query: KommuneDocument,
    ...options,
  });
}
