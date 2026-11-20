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

export type ForgotPasswordConfirmInput = {
  password: string;
  passwordResetCode: string;
  personalPrivateKey: EncryptedValueInput;
  personalPrivateKeySalt: string;
  personalPublicKey: string;
};

export type ForgotPasswordInput = {
  email: string;
};

export type ForgotPasswordMutationVariables = Types.Exact<{
  input: ForgotPasswordInput;
}>;

export type ForgotPasswordMutation = {
  __typename?: 'Mutation';
  forgotPassword: {
    __typename?: 'ForgotPasswordPayload';
    boolean?: boolean | null;
  };
};

export type ForgotPasswordConfirmMutationVariables = Types.Exact<{
  input: ForgotPasswordConfirmInput;
}>;

export type ForgotPasswordConfirmMutation = {
  __typename?: 'Mutation';
  forgotPasswordConfirm: {
    __typename?: 'ForgotPasswordConfirmPayload';
    result: Types.PasswordConfirmationResult;
  };
};

export const ForgotPasswordDocument = gql`
  mutation ForgotPassword($input: ForgotPasswordInput!) {
    forgotPassword(input: $input) {
      boolean
    }
  }
`;

export function useForgotPasswordMutation() {
  return Urql.useMutation<
    ForgotPasswordMutation,
    ForgotPasswordMutationVariables
  >(ForgotPasswordDocument);
}
export const ForgotPasswordConfirmDocument = gql`
  mutation ForgotPasswordConfirm($input: ForgotPasswordConfirmInput!) {
    forgotPasswordConfirm(input: $input) {
      result
    }
  }
`;

export function useForgotPasswordConfirmMutation() {
  return Urql.useMutation<
    ForgotPasswordConfirmMutation,
    ForgotPasswordConfirmMutationVariables
  >(ForgotPasswordConfirmDocument);
}
