import * as Types from '../../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type ProzessUpsertInput = {
  id?: string | null;
  name: string;
};

export type UpsertProzessMutationVariables = Types.Exact<{
  input: ProzessUpsertInput;
}>;

export type UpsertProzessMutation = {
  __typename?: 'Mutation';
  prozessUpsert: {
    __typename?: 'ProzessUpsertPayload';
    prozess?: {__typename?: 'Prozess'; id: string; name: string} | null;
  };
};

export type ProzessQueryVariables = Types.Exact<{
  kommuneId: string;
  id: string;
}>;

export type ProzessQuery = {
  __typename?: 'Query';
  kommune: {
    __typename?: 'Kommune';
    prozessById: {__typename?: 'Prozess'; id: string; name: string};
  };
};

export const UpsertProzessDocument = gql`
  mutation UpsertProzess($input: ProzessUpsertInput!) {
    prozessUpsert(input: $input) {
      prozess {
        id
        name
      }
    }
  }
`;

export function useUpsertProzessMutation() {
  return Urql.useMutation<
    UpsertProzessMutation,
    UpsertProzessMutationVariables
  >(UpsertProzessDocument);
}
export const ProzessDocument = gql`
  query Prozess($kommuneId: UUID!, $id: UUID!) {
    kommune(kommuneId: $kommuneId) {
      prozessById(id: $id) {
        id
        name
      }
    }
  }
`;

export function useProzessQuery(
  options: Omit<Urql.UseQueryArgs<ProzessQueryVariables>, 'query'>,
) {
  return Urql.useQuery<ProzessQuery, ProzessQueryVariables>({
    query: ProzessDocument,
    ...options,
  });
}
