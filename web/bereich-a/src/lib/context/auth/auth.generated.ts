import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type LoginInput = {
  email: string;
  password: string;
};

export type LoginMutationVariables = Types.Exact<{
  input: LoginInput;
}>;

export type LoginMutation = {
  __typename?: 'Mutation';
  login: {
    __typename?: 'LoginPayload';
    result: Types.LoginResult;
    token?: string | null;
  };
};

export type EncryptedValueFragment = {
  __typename?: 'EncryptedValue';
  cipher: string;
  nonce: string;
  tag: string;
};

export type User_BackofficeUser_Fragment = {
  __typename: 'BackofficeUser';
  eMail: string;
  vorname: string;
  nachname: string;
  organisationPrivateKey?: string | null;
  art: Types.BackofficeNutzerArt;
  isKommuneAdmin: boolean;
  personalPrivateKeySalt?: string | null;
  funktionsberechtigungen: Array<Types.GlobaleFunktionsberechtigung>;
  id: string;
  publicKey?: string | null;
  kommune: {
    __typename?: 'Kommune';
    id: string;
    name: string;
    privateKey?:
      | ({__typename?: 'EncryptedValue'} & EncryptedValueFragment)
      | null;
  };
  gruppen: Array<{__typename?: 'MitarbeiterGruppe'; id: string}>;
  personalPrivateKey?:
    | ({__typename?: 'EncryptedValue'} & EncryptedValueFragment)
    | null;
  organisationseinheiten: Array<{
    __typename?: 'ResolvedBackofficeUserOrganisationseinheit';
    id: string;
    funktionsberechtigungen: Array<Types.FunktionsberechtigungInOrganisationseinheit>;
    meta: {__typename?: 'Untereinheit'; name: string};
  }>;
};

export type User_Buerger_Fragment = {
  __typename: 'Buerger';
  personalPrivateKeySalt?: string | null;
  id: string;
  publicKey?: string | null;
  personalPrivateKey?:
    | ({__typename?: 'EncryptedValue'} & EncryptedValueFragment)
    | null;
};

export type User_SystemUser_Fragment = {
  __typename: 'SystemUser';
  id: string;
  publicKey?: string | null;
};

export type UserFragment =
  | User_BackofficeUser_Fragment
  | User_Buerger_Fragment
  | User_SystemUser_Fragment;

export type MyQueryVariables = Types.Exact<{[key: string]: never}>;

export type MyQuery = {__typename?: 'Query'; my: User};

export type User = User_BackofficeUser | User_Buerger | User_SystemUser;

export type User_BackofficeUser = {
  __typename?: 'BackofficeUser';
} & User_BackofficeUser_Fragment;

export type User_Buerger = {__typename?: 'Buerger'} & User_Buerger_Fragment;

export type User_SystemUser = {
  __typename?: 'SystemUser';
} & User_SystemUser_Fragment;

export const EncryptedValueFragmentDoc = gql`
  fragment EncryptedValue on EncryptedValue {
    cipher
    nonce
    tag
  }
`;
export const UserFragmentDoc = gql`
  fragment User on User {
    __typename
    id
    publicKey
    ... on Buerger {
      personalPrivateKey {
        ...EncryptedValue
      }
      personalPrivateKeySalt
    }
    ... on Mitarbeiter {
      eMail
      vorname
      nachname
      organisationPrivateKey
      kommune {
        id
        name
        privateKey {
          ...EncryptedValue
        }
      }
      organisationPrivateKey
      gruppen {
        id
      }
    }
    ... on BackofficeUser {
      art
      isKommuneAdmin
      personalPrivateKey {
        ...EncryptedValue
      }
      personalPrivateKeySalt
      organisationseinheiten {
        id: organisationseinheitId
        meta: organisationseinheit {
          name
        }
        funktionsberechtigungen: alleFunktionsberechtigungen
      }
      funktionsberechtigungen
    }
  }
  ${EncryptedValueFragmentDoc}
`;
export const LoginDocument = gql`
  mutation Login($input: LoginInput!) {
    login(input: $input) {
      result
      token
    }
  }
`;

export function useLoginMutation() {
  return Urql.useMutation<LoginMutation, LoginMutationVariables>(LoginDocument);
}
export const MyDocument = gql`
  query My {
    my @export(exportName: "User") {
      ...User
    }
  }
  ${UserFragmentDoc}
`;

export function useMyQuery(
  options?: Omit<Urql.UseQueryArgs<MyQueryVariables>, 'query'>,
) {
  return Urql.useQuery<MyQuery, MyQueryVariables>({
    query: MyDocument,
    ...options,
  });
}
