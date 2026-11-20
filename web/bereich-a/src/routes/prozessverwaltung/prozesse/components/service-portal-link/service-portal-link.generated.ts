import * as Types from '../../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type ServicePortalLinkUpsertInput = {
  id?: string | null;
  name: string;
  url: string;
};

export type UpsertServicePortalLinkMutationVariables = Types.Exact<{
  input: ServicePortalLinkUpsertInput;
}>;

export type UpsertServicePortalLinkMutation = {
  __typename?: 'Mutation';
  servicePortalLinkUpsert: {
    __typename?: 'ServicePortalLinkUpsertPayload';
    servicePortalLink?: {
      __typename?: 'ServicePortalLink';
      id: string;
      url: string;
    } | null;
  };
};

export type ServicePortalLinkQueryVariables = Types.Exact<{
  kommuneId: string;
  id: string;
}>;

export type ServicePortalLinkQuery = {
  __typename?: 'Query';
  kommune: {
    __typename?: 'Kommune';
    servicePortalLink: {
      __typename?: 'ServicePortalLink';
      id: string;
      url: string;
      name: string;
    };
  };
};

export const UpsertServicePortalLinkDocument = gql`
  mutation UpsertServicePortalLink($input: ServicePortalLinkUpsertInput!) {
    servicePortalLinkUpsert(input: $input) {
      servicePortalLink {
        id
        url
      }
    }
  }
`;

export function useUpsertServicePortalLinkMutation() {
  return Urql.useMutation<
    UpsertServicePortalLinkMutation,
    UpsertServicePortalLinkMutationVariables
  >(UpsertServicePortalLinkDocument);
}
export const ServicePortalLinkDocument = gql`
  query ServicePortalLink($kommuneId: UUID!, $id: UUID!) {
    kommune(kommuneId: $kommuneId) {
      servicePortalLink(id: $id) {
        id
        url
        name
      }
    }
  }
`;

export function useServicePortalLinkQuery(
  options: Omit<Urql.UseQueryArgs<ServicePortalLinkQueryVariables>, 'query'>,
) {
  return Urql.useQuery<ServicePortalLinkQuery, ServicePortalLinkQueryVariables>(
    {query: ServicePortalLinkDocument, ...options},
  );
}
