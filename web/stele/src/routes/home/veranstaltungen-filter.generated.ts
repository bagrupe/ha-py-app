import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type KioskVeranstaltungenFilterOptionsQueryVariables = Types.Exact<{
  kommuneId: unknown;
}>;

export type KioskVeranstaltungenFilterOptionsQuery = {
  __typename?: 'Query';
  veranstaltungskalenderKategories?: {
    __typename?: 'VeranstaltungskalenderKategories';
    docs: Array<{
      __typename?: 'VeranstaltungskalenderKategorie';
      id: string;
      label: string;
    }>;
  } | null;
  untereinheitList?: {
    __typename?: 'Untereinheits';
    docs: Array<{
      __typename?: 'BereichBUntereinheit';
      id: string;
      name: string;
    }>;
  } | null;
};

export const KioskVeranstaltungenFilterOptionsDocument = gql`
  query KioskVeranstaltungenFilterOptions($kommuneId: JSON!) {
    veranstaltungskalenderKategories(
      where: {kommune: {equals: $kommuneId}, filterkategorie: {equals: true}}
      limit: 200
    ) {
      docs {
        id
        label
      }
    }
    untereinheitList(
      where: {kommune: {equals: $kommuneId}, isGemeinde: {equals: true}}
      limit: 200
    ) {
      docs {
        id
        name
      }
    }
  }
`;

export function useKioskVeranstaltungenFilterOptionsQuery(
  options: Omit<
    Urql.UseQueryArgs<KioskVeranstaltungenFilterOptionsQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    KioskVeranstaltungenFilterOptionsQuery,
    KioskVeranstaltungenFilterOptionsQueryVariables
  >({query: KioskVeranstaltungenFilterOptionsDocument, ...options});
}
