import * as Types from '../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type BackofficeUserDeleteInput = {
  userId: string;
};

export type BackofficeUserDeleteMutationVariables = Types.Exact<{
  input: BackofficeUserDeleteInput;
}>;

export type BackofficeUserDeleteMutation = {
  __typename?: 'Mutation';
  backofficeUserDelete: {
    __typename: 'BackofficeUserDeletePayload';
    backofficeUser?: {__typename?: 'BackofficeUser'; id: string} | null;
    errors?: Array<{__typename?: 'NotAllowedError'; message: string}> | null;
  };
};

export const BackofficeUserDeleteDocument = gql`
  mutation backofficeUserDelete($input: BackofficeUserDeleteInput!) {
    backofficeUserDelete(input: $input) {
      __typename
      backofficeUser {
        id
      }
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useBackofficeUserDeleteMutation() {
  return Urql.useMutation<
    BackofficeUserDeleteMutation,
    BackofficeUserDeleteMutationVariables
  >(BackofficeUserDeleteDocument);
}
