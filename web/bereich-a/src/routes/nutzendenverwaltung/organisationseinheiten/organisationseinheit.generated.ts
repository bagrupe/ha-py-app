import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type UntereinheitCreateInput = {
  eMailAdressen: Array<string>;
  name: string;
};

export type UntereinheitDeleteInput = {
  untereinheitId: string;
};

export type UntereinheitUpdateInput = {
  eMailAdressen: Array<string>;
  name: string;
  untereinheitId: string;
};

export type UntereinheitenQueryVariables = Types.Exact<{[key: string]: never}>;

export type UntereinheitenQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          untereinheiten: Array<
            {__typename?: 'Untereinheit'} & VerwalteteUntereinheitFragment
          >;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type UntereinheitUpdateMutationVariables = Types.Exact<{
  input: UntereinheitUpdateInput;
}>;

export type UntereinheitUpdateMutation = {
  __typename?: 'Mutation';
  untereinheitUpdate: {
    __typename?: 'UntereinheitUpdatePayload';
    untereinheit?:
      | ({__typename: 'Untereinheit'} & VerwalteteUntereinheitFragment)
      | null;
    errors?: Array<
      | {__typename: 'InvalidEmailError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'UntereinheitIsGemeindeError'; message: string}
      | {__typename: 'UntereinheitNotFoundError'; message: string}
    > | null;
  };
};

export type UntereinheitDeleteMutationVariables = Types.Exact<{
  input: UntereinheitDeleteInput;
}>;

export type UntereinheitDeleteMutation = {
  __typename?: 'Mutation';
  untereinheitDelete: {
    __typename?: 'UntereinheitDeletePayload';
    untereinheit?: Array<
      {__typename?: 'Untereinheit'} & VerwalteteUntereinheitFragment
    > | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'UntereinheitAssignedToUser'; message: string}
      | {__typename: 'UntereinheitIsGemeindeError'; message: string}
      | {__typename: 'UntereinheitNotFoundError'; message: string}
    > | null;
  };
};

export type UntereinheitCreateMutationVariables = Types.Exact<{
  input: UntereinheitCreateInput;
}>;

export type UntereinheitCreateMutation = {
  __typename?: 'Mutation';
  untereinheitCreate: {
    __typename?: 'UntereinheitCreatePayload';
    untereinheit?:
      | ({__typename: 'Untereinheit'} & VerwalteteUntereinheitFragment)
      | null;
    errors?: Array<{__typename: 'InvalidEmailError'; message: string}> | null;
  };
};

export type VerwalteteUntereinheitFragment = {
  __typename?: 'Untereinheit';
  id: string;
  name: string;
  isGemeinde: boolean;
  eMailAdressen: Array<string>;
};

export const VerwalteteUntereinheitFragmentDoc = gql`
  fragment VerwalteteUntereinheit on Untereinheit {
    id
    name
    isGemeinde
    eMailAdressen
  }
`;
export const UntereinheitenDocument = gql`
  query Untereinheiten {
    my {
      ... on BackofficeUser {
        kommune {
          untereinheiten {
            ...VerwalteteUntereinheit
          }
        }
      }
    }
  }
  ${VerwalteteUntereinheitFragmentDoc}
`;

export function useUntereinheitenQuery(
  options?: Omit<Urql.UseQueryArgs<UntereinheitenQueryVariables>, 'query'>,
) {
  return Urql.useQuery<UntereinheitenQuery, UntereinheitenQueryVariables>({
    query: UntereinheitenDocument,
    ...options,
  });
}
export const UntereinheitUpdateDocument = gql`
  mutation UntereinheitUpdate($input: UntereinheitUpdateInput!) {
    untereinheitUpdate(input: $input) {
      untereinheit {
        __typename
        ...VerwalteteUntereinheit
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${VerwalteteUntereinheitFragmentDoc}
`;

export function useUntereinheitUpdateMutation() {
  return Urql.useMutation<
    UntereinheitUpdateMutation,
    UntereinheitUpdateMutationVariables
  >(UntereinheitUpdateDocument);
}
export const UntereinheitDeleteDocument = gql`
  mutation UntereinheitDelete($input: UntereinheitDeleteInput!) {
    untereinheitDelete(input: $input) {
      untereinheit {
        ...VerwalteteUntereinheit
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${VerwalteteUntereinheitFragmentDoc}
`;

export function useUntereinheitDeleteMutation() {
  return Urql.useMutation<
    UntereinheitDeleteMutation,
    UntereinheitDeleteMutationVariables
  >(UntereinheitDeleteDocument);
}
export const UntereinheitCreateDocument = gql`
  mutation UntereinheitCreate($input: UntereinheitCreateInput!) {
    untereinheitCreate(input: $input) {
      untereinheit {
        __typename
        ...VerwalteteUntereinheit
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${VerwalteteUntereinheitFragmentDoc}
`;

export function useUntereinheitCreateMutation() {
  return Urql.useMutation<
    UntereinheitCreateMutation,
    UntereinheitCreateMutationVariables
  >(UntereinheitCreateDocument);
}
