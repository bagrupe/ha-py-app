import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type DienstleisterCreateInput = {
  eMailAdressen: Array<string>;
  name: string;
  organisationseinheitIds: Array<string>;
};

export type DienstleisterUpdateInput = {
  dienstleisterId: string;
  eMailAdressen: Array<string>;
  name: string;
  organisationseinheitIds: Array<string>;
};

export type DienstleisterQueryVariables = Types.Exact<{[key: string]: never}>;

export type DienstleisterQuery = {
  __typename?: 'Query';
  dienstleister?: {
    __typename?: 'DienstleisterCollectionSegment';
    items?: Array<
      {__typename?: 'Dienstleister'} & DienstleisterFragment
    > | null;
  } | null;
};

export type DienstleisterCreateMutationVariables = Types.Exact<{
  input: DienstleisterCreateInput;
}>;

export type DienstleisterCreateMutation = {
  __typename?: 'Mutation';
  dienstleisterCreate: {
    __typename?: 'DienstleisterCreatePayload';
    dienstleister?: {__typename?: 'Dienstleister'; id: string} | null;
    errors?: Array<
      | {__typename?: 'InvalidEmailError'; message: string}
      | {__typename?: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DienstleisterUpdateMutationVariables = Types.Exact<{
  input: DienstleisterUpdateInput;
}>;

export type DienstleisterUpdateMutation = {
  __typename?: 'Mutation';
  dienstleisterUpdate: {
    __typename?: 'DienstleisterUpdatePayload';
    errors?: Array<
      | {__typename?: 'InvalidEmailError'; message: string}
      | {__typename?: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DienstleisterDeleteMutationVariables = Types.Exact<{
  id: string;
}>;

export type DienstleisterDeleteMutation = {
  __typename?: 'Mutation';
  dienstleisterDelete: {
    __typename?: 'DienstleisterDeletePayload';
    errors?: Array<{__typename?: 'NotAllowedError'; message: string}> | null;
  };
};

export type DienstleisterFragment = {
  __typename?: 'Dienstleister';
  id: string;
  name: string;
  eMailAdressen: Array<string>;
  organisationseinheiten: Array<{__typename?: 'Untereinheit'; id: string}>;
};

export const DienstleisterFragmentDoc = gql`
  fragment Dienstleister on Dienstleister {
    id
    name
    eMailAdressen
    organisationseinheiten {
      id
    }
  }
`;
export const DienstleisterDocument = gql`
  query Dienstleister {
    dienstleister {
      items {
        ...Dienstleister
      }
    }
  }
  ${DienstleisterFragmentDoc}
`;

export function useDienstleisterQuery(
  options?: Omit<Urql.UseQueryArgs<DienstleisterQueryVariables>, 'query'>,
) {
  return Urql.useQuery<DienstleisterQuery, DienstleisterQueryVariables>({
    query: DienstleisterDocument,
    ...options,
  });
}
export const DienstleisterCreateDocument = gql`
  mutation DienstleisterCreate($input: DienstleisterCreateInput!) {
    dienstleisterCreate(input: $input) {
      dienstleister {
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

export function useDienstleisterCreateMutation() {
  return Urql.useMutation<
    DienstleisterCreateMutation,
    DienstleisterCreateMutationVariables
  >(DienstleisterCreateDocument);
}
export const DienstleisterUpdateDocument = gql`
  mutation DienstleisterUpdate($input: DienstleisterUpdateInput!) {
    dienstleisterUpdate(input: $input) {
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useDienstleisterUpdateMutation() {
  return Urql.useMutation<
    DienstleisterUpdateMutation,
    DienstleisterUpdateMutationVariables
  >(DienstleisterUpdateDocument);
}
export const DienstleisterDeleteDocument = gql`
  mutation DienstleisterDelete($id: UUID!) {
    dienstleisterDelete(input: {dienstleisterId: $id}) {
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useDienstleisterDeleteMutation() {
  return Urql.useMutation<
    DienstleisterDeleteMutation,
    DienstleisterDeleteMutationVariables
  >(DienstleisterDeleteDocument);
}
