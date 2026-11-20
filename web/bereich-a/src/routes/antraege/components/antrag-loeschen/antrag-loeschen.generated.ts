import * as Types from '../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AntragSoftLoeschenInput = {
  ausfuehrungId: string;
  grund: string;
};

export type AntragSoftLoeschenMutationVariables = Types.Exact<{
  input: AntragSoftLoeschenInput;
}>;

export type AntragSoftLoeschenMutation = {
  __typename?: 'Mutation';
  antragSoftLoeschen: {
    __typename?: 'AntragSoftLoeschenPayload';
    ausfuehrung?: {
      __typename?: 'Ausfuehrung';
      id: string;
      geloeschtAm?: Date | null;
    } | null;
    errors?: Array<
      | {__typename?: 'AusfuehrungNotFoundError'; message: string}
      | {__typename?: 'NotAllowedError'; message: string}
    > | null;
  };
};

export const AntragSoftLoeschenDocument = gql`
  mutation AntragSoftLoeschen($input: AntragSoftLoeschenInput!) {
    antragSoftLoeschen(input: $input) {
      ausfuehrung {
        id
        geloeschtAm
      }
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useAntragSoftLoeschenMutation() {
  return Urql.useMutation<
    AntragSoftLoeschenMutation,
    AntragSoftLoeschenMutationVariables
  >(AntragSoftLoeschenDocument);
}
