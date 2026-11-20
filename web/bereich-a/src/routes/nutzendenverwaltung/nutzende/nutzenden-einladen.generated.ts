import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type InviteBackofficeUserInput = {
  abteilungIds: Array<string>;
  art: Types.BackofficeNutzerArt;
  email: string;
  organisationseinheitIds: Array<string>;
};

export type InviteBackofficeUserMutationVariables = Types.Exact<{
  input: InviteBackofficeUserInput;
}>;

export type InviteBackofficeUserMutation = {
  __typename?: 'Mutation';
  result: {
    __typename?: 'InviteBackofficeUserPayload';
    success?: boolean | null;
    errors?: Array<{__typename?: 'NotAllowedError'; message: string}> | null;
  };
};

export type NutzendenEinladenPageQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type NutzendenEinladenPageQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        art: Types.BackofficeNutzerArt;
        abteilungen: Array<{
          __typename?: 'MitarbeiterGruppe';
          id: string;
          name: string;
        }>;
        organisationseinheiten: Array<{
          __typename?: 'UntereinheitPermissions';
          untereinheitId: string;
          untereinheit: {__typename?: 'Untereinheit'; name: string};
        }>;
        mandant: {
          __typename?: 'Kommune';
          organisationseinheiten: Array<{
            __typename?: 'Untereinheit';
            id: string;
            name: string;
          }>;
          abteilungen: Array<{
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          }>;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export const InviteBackofficeUserDocument = gql`
  mutation InviteBackofficeUser($input: InviteBackofficeUserInput!) {
    result: inviteBackofficeUser(input: $input) {
      success
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useInviteBackofficeUserMutation() {
  return Urql.useMutation<
    InviteBackofficeUserMutation,
    InviteBackofficeUserMutationVariables
  >(InviteBackofficeUserDocument);
}
export const NutzendenEinladenPageDocument = gql`
  query NutzendenEinladenPage {
    my {
      ... on BackofficeUser {
        art
        abteilungen: gruppen {
          id
          name
        }
        organisationseinheiten: untereinheitPermissions {
          untereinheitId
          untereinheit {
            name
          }
        }
        mandant: kommune {
          organisationseinheiten: untereinheiten {
            id
            name
          }
          abteilungen: mitarbeiterGruppen {
            id
            name
          }
        }
      }
    }
  }
`;

export function useNutzendenEinladenPageQuery(
  options?: Omit<
    Urql.UseQueryArgs<NutzendenEinladenPageQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    NutzendenEinladenPageQuery,
    NutzendenEinladenPageQueryVariables
  >({query: NutzendenEinladenPageDocument, ...options});
}
