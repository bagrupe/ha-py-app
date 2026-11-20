import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type DienstleisterMitarbeiterInviteInput = {
  dienstleisterId: string;
  email: string;
};

export type InviteDienstleisterMitarbeiterMutationVariables = Types.Exact<{
  input: DienstleisterMitarbeiterInviteInput;
}>;

export type InviteDienstleisterMitarbeiterMutation = {
  __typename?: 'Mutation';
  dienstleisterMitarbeiterInvite: {
    __typename?: 'DienstleisterMitarbeiterInvitePayload';
    success?: boolean | null;
    errors?: Array<{__typename?: 'NotAllowedError'; message: string}> | null;
  };
};

export type DienstleisterEinladenPageQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type DienstleisterEinladenPageQuery = {
  __typename?: 'Query';
  dienstleister?: {
    __typename?: 'DienstleisterCollectionSegment';
    items?: Array<{
      __typename?: 'Dienstleister';
      id: string;
      name: string;
    }> | null;
  } | null;
};

export const InviteDienstleisterMitarbeiterDocument = gql`
  mutation InviteDienstleisterMitarbeiter(
    $input: DienstleisterMitarbeiterInviteInput!
  ) {
    dienstleisterMitarbeiterInvite(input: $input) {
      success
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useInviteDienstleisterMitarbeiterMutation() {
  return Urql.useMutation<
    InviteDienstleisterMitarbeiterMutation,
    InviteDienstleisterMitarbeiterMutationVariables
  >(InviteDienstleisterMitarbeiterDocument);
}
export const DienstleisterEinladenPageDocument = gql`
  query DienstleisterEinladenPage {
    dienstleister(ichKannEinladen: true) {
      items {
        id
        name
      }
    }
  }
`;

export function useDienstleisterEinladenPageQuery(
  options?: Omit<
    Urql.UseQueryArgs<DienstleisterEinladenPageQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    DienstleisterEinladenPageQuery,
    DienstleisterEinladenPageQueryVariables
  >({query: DienstleisterEinladenPageDocument, ...options});
}
