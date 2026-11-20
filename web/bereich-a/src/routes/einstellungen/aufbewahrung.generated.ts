import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AufbewahrungsEinstellungenAktualisierenInput = {
  archivVerzoegerungMinuten: number;
  archivierungAktiv: boolean;
  hardDeleteAktiv: boolean;
  hardDeleteVerzoegerungMinuten: number;
};

export type AufbewahrungsEinstellungenQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type AufbewahrungsEinstellungenQuery = {
  __typename?: 'Query';
  aufbewahrungsEinstellungen: {
    __typename?: 'AufbewahrungsEinstellungen';
    hardDeleteVerzoegerungMinuten: number;
    archivVerzoegerungMinuten: number;
    hardDeleteAktiv: boolean;
    archivierungAktiv: boolean;
    aktualisiertAm?: Date | null;
  };
};

export type AufbewahrungsEinstellungenAktualisierenMutationVariables =
  Types.Exact<{
    input: AufbewahrungsEinstellungenAktualisierenInput;
  }>;

export type AufbewahrungsEinstellungenAktualisierenMutation = {
  __typename?: 'Mutation';
  aufbewahrungsEinstellungenAktualisieren: {
    __typename?: 'AufbewahrungsEinstellungenAktualisierenPayload';
    einstellungen?: {
      __typename?: 'AufbewahrungsEinstellungen';
      hardDeleteVerzoegerungMinuten: number;
      archivVerzoegerungMinuten: number;
      hardDeleteAktiv: boolean;
      archivierungAktiv: boolean;
      aktualisiertAm?: Date | null;
    } | null;
    errors?: Array<{__typename?: 'NotAllowedError'; message: string}> | null;
  };
};

export const AufbewahrungsEinstellungenDocument = gql`
  query AufbewahrungsEinstellungen {
    aufbewahrungsEinstellungen {
      hardDeleteVerzoegerungMinuten
      archivVerzoegerungMinuten
      hardDeleteAktiv
      archivierungAktiv
      aktualisiertAm
    }
  }
`;

export function useAufbewahrungsEinstellungenQuery(
  options?: Omit<
    Urql.UseQueryArgs<AufbewahrungsEinstellungenQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    AufbewahrungsEinstellungenQuery,
    AufbewahrungsEinstellungenQueryVariables
  >({query: AufbewahrungsEinstellungenDocument, ...options});
}
export const AufbewahrungsEinstellungenAktualisierenDocument = gql`
  mutation AufbewahrungsEinstellungenAktualisieren(
    $input: AufbewahrungsEinstellungenAktualisierenInput!
  ) {
    aufbewahrungsEinstellungenAktualisieren(input: $input) {
      einstellungen {
        hardDeleteVerzoegerungMinuten
        archivVerzoegerungMinuten
        hardDeleteAktiv
        archivierungAktiv
        aktualisiertAm
      }
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useAufbewahrungsEinstellungenAktualisierenMutation() {
  return Urql.useMutation<
    AufbewahrungsEinstellungenAktualisierenMutation,
    AufbewahrungsEinstellungenAktualisierenMutationVariables
  >(AufbewahrungsEinstellungenAktualisierenDocument);
}
