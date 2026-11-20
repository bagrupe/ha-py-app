import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type EncryptedValueInput = {
  cipher: string;
  nonce: string;
  tag: string;
};

export type ResetPasswordInput = {
  currentPassword: string;
  newPassword: string;
  organizationPrivateKey: string;
  personalPrivateKey: EncryptedValueInput;
  personalPrivateKeySalt: string;
  personalPublicKey: string;
};

export type ResetPasswordMutationVariables = Types.Exact<{
  input: ResetPasswordInput;
}>;

export type ResetPasswordMutation = {
  __typename?: 'Mutation';
  resetPassword: {
    __typename?: 'ResetPasswordPayload';
    boolean?: boolean | null;
  };
};

export const ResetPasswordDocument = gql`
  mutation ResetPassword($input: ResetPasswordInput!) {
    resetPassword(input: $input) {
      boolean
    }
  }
`;

export function useResetPasswordMutation() {
  return Urql.useMutation<
    ResetPasswordMutation,
    ResetPasswordMutationVariables
  >(ResetPasswordDocument);
}
