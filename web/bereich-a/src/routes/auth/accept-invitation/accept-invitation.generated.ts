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

export type RegisterBackofficeUserInput = {
  derivedPassword: string;
  encryptedPrivateKey: EncryptedValueInput;
  invitationCode: string;
  nachname: string;
  publicKey: string;
  salt: string;
  vorname: string;
};

export type AcceptInvitationMutationVariables = Types.Exact<{
  input: RegisterBackofficeUserInput;
}>;

export type AcceptInvitationMutation = {
  __typename?: 'Mutation';
  registerBackofficeUser: {
    __typename?: 'RegisterBackofficeUserPayload';
    result?: Types.RegisterBackofficeUserResult | null;
  };
};

export const AcceptInvitationDocument = gql`
  mutation AcceptInvitation($input: RegisterBackofficeUserInput!) {
    registerBackofficeUser(input: $input) {
      result
    }
  }
`;

export function useAcceptInvitationMutation() {
  return Urql.useMutation<
    AcceptInvitationMutation,
    AcceptInvitationMutationVariables
  >(AcceptInvitationDocument);
}
