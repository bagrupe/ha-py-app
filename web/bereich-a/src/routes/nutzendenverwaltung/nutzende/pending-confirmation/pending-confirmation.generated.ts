import * as Types from '../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type UserConfirmInput = {
  organizationPrivateKey: string;
  userId: string;
};

export type NutzendePendingConfrimationQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type NutzendePendingConfrimationQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          mitarbeiterPendingConfirmation: Array<
            {__typename?: 'BackofficeUser'} & PendingUserFragment
          >;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type PendingUserFragment = {
  __typename?: 'BackofficeUser';
  id: string;
  vorname: string;
  nachname: string;
  eMail: string;
  pendingConfirmation?: Types.PendingConfirmationReason | null;
  publicKey?: string | null;
};

export type UserConfirmMutationVariables = Types.Exact<{
  input: UserConfirmInput;
}>;

export type UserConfirmMutation = {
  __typename?: 'Mutation';
  userConfirm: {__typename?: 'UserConfirmPayload'; boolean?: boolean | null};
};

export const PendingUserFragmentDoc = gql`
  fragment PendingUser on Mitarbeiter {
    id
    vorname
    nachname
    eMail
    pendingConfirmation
    publicKey
  }
`;
export const NutzendePendingConfrimationDocument = gql`
  query NutzendePendingConfrimation {
    my {
      ... on BackofficeUser {
        kommune {
          mitarbeiterPendingConfirmation {
            ...PendingUser
          }
        }
      }
    }
  }
  ${PendingUserFragmentDoc}
`;

export function useNutzendePendingConfrimationQuery(
  options?: Omit<
    Urql.UseQueryArgs<NutzendePendingConfrimationQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    NutzendePendingConfrimationQuery,
    NutzendePendingConfrimationQueryVariables
  >({query: NutzendePendingConfrimationDocument, ...options});
}
export const UserConfirmDocument = gql`
  mutation UserConfirm($input: UserConfirmInput!) {
    userConfirm(input: $input) {
      boolean
    }
  }
`;

export function useUserConfirmMutation() {
  return Urql.useMutation<UserConfirmMutation, UserConfirmMutationVariables>(
    UserConfirmDocument,
  );
}
