import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type DeleteProzessInput = {
  id: string;
};

export type DeleteProzessVersionInput = {
  id: string;
};

export type DeleteServicePortalLinkInput = {
  id: string;
};

export type ProzessAktivierenInput = {
  id: string;
};

export type ProzessDeaktivierenInput = {
  id: string;
};

export type ProzessUebersichtQueryVariables = Types.Exact<{
  groupId?: Types.Maybe<string>;
  search?: Types.Maybe<string>;
  skip?: Types.Maybe<number>;
  take?: Types.Maybe<number>;
}>;

export type ProzessUebersichtQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        id: string;
        kommune: {
          __typename?: 'Kommune';
          prozessTags: Array<ProzessTag>;
          prozessGroups: Array<{
            __typename?: 'ProzessGroup';
            id: string;
            name: string;
          }>;
          prozesseUndLeistungen?: {
            __typename?: 'ProzesseUndLeistungenCollectionSegment';
            items: Array<UserFacingProzess> | null;
            totalCount: number;
          } | null;
        };
      }
    | {__typename?: 'Buerger'; id: string}
    | {__typename?: 'SystemUser'; id: string};
};

export type ProzessTag = {
  __typename?: 'ProzessTag';
  id: string;
  tag: string;
  prozesse: Array<{__typename?: 'Prozess'; id: string; name: string}>;
};

export type UserFacingProzess =
  | UserFacingProzess_Prozess
  | UserFacingProzess_ServicePortalLink;

export type UserFacingProzess_Prozess = {
  __typename?: 'Prozess';
  versionenCount: number;
  deaktiviertAm?: Date | null;
  id: string;
  name: string;
  tags: Array<{__typename?: 'ProzessTag'; id: string; tag: string}>;
  currentVersion?: {
    __typename?: 'ProzessVersion';
    id: string;
    publishedAt?: Date | null;
  } | null;
  group: ProzessGroup | null;
};

export type UserFacingProzess_ServicePortalLink = {
  __typename?: 'ServicePortalLink';
  url: string;
  id: string;
  name: string;
  group: ProzessGroup | null;
};

export type ProzessGroup = {
  __typename?: 'ProzessGroup';
  id: string;
  name: string;
};

export type SetGroupToProzessMutationVariables = Types.Exact<{
  groupId?: Types.Maybe<string>;
  prozessId: string;
}>;

export type SetGroupToProzessMutation = {
  __typename?: 'Mutation';
  setGroupToProzess: {
    __typename?: 'SetGroupToProzessPayload';
    userFacingProzess?:
      | {__typename?: 'Prozess'; id: string; name: string}
      | {__typename?: 'ServicePortalLink'; id: string; name: string}
      | null;
  };
};

export type DeleteProzessVersionMutationVariables = Types.Exact<{
  input: DeleteProzessVersionInput;
}>;

export type DeleteProzessVersionMutation = {
  __typename?: 'Mutation';
  deleteProzessVersion: {
    __typename?: 'DeleteProzessVersionPayload';
    prozessVersion?: {__typename?: 'ProzessVersion'; id: string} | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ProzessVersionHasAusfuehrungen'; message: string}
      | {__typename: 'ProzessVersionIsCurrentVersion'; message: string}
      | {__typename: 'ProzessVersionIsLastPublished'; message: string}
      | {__typename: 'ProzessVersionNotFound'; message: string}
    > | null;
  };
};

export type DeleteServicePortalLinkMutationVariables = Types.Exact<{
  input: DeleteServicePortalLinkInput;
}>;

export type DeleteServicePortalLinkMutation = {
  __typename?: 'Mutation';
  deleteServicePortalLink: {
    __typename?: 'DeleteServicePortalLinkPayload';
    servicePortalLink?: {__typename?: 'ServicePortalLink'; id: string} | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ServicePortalLinkNotFoundError'; message: string}
    > | null;
  };
};

export type DeleteProzessMutationVariables = Types.Exact<{
  input: DeleteProzessInput;
}>;

export type DeleteProzessMutation = {
  __typename?: 'Mutation';
  deleteProzess: {
    __typename?: 'DeleteProzessPayload';
    prozess?: {__typename?: 'Prozess'; id: string} | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ProzessHasVersionen'; message: string}
      | {__typename: 'ProzessNotFound'; message: string}
    > | null;
  };
};

export type ProzessDeaktivierenMutationVariables = Types.Exact<{
  input: ProzessDeaktivierenInput;
}>;

export type ProzessDeaktivierenMutation = {
  __typename?: 'Mutation';
  prozessDeaktivieren: {
    __typename?: 'ProzessDeaktivierenPayload';
    prozess?: {
      __typename?: 'Prozess';
      id: string;
      deaktiviertAm?: Date | null;
    } | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ProzessNotFound'; message: string}
    > | null;
  };
};

export type ProzessAktivierenMutationVariables = Types.Exact<{
  input: ProzessAktivierenInput;
}>;

export type ProzessAktivierenMutation = {
  __typename?: 'Mutation';
  prozessAktivieren: {
    __typename?: 'ProzessAktivierenPayload';
    prozess?: {
      __typename?: 'Prozess';
      id: string;
      deaktiviertAm?: Date | null;
    } | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ProzessNotFound'; message: string}
    > | null;
  };
};

export type AssignProzessTagMutationVariables = Types.Exact<{
  prozessId: string;
  tagId: string;
}>;

export type AssignProzessTagMutation = {
  __typename?: 'Mutation';
  assignProzessTag: {
    __typename: 'AssignProzessTagPayload';
    prozess?: {
      __typename?: 'Prozess';
      id: string;
      name: string;
      tags: Array<{__typename?: 'ProzessTag'; id: string; tag: string}>;
    } | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ProzessNotFound'; message: string}
      | {__typename: 'ProzessTagNotFound'; message: string}
    > | null;
  };
};

export const ProzessUebersichtDocument = gql`
  query ProzessUebersicht(
    $groupId: UUID
    $search: String
    $skip: Int
    $take: Int
  ) {
    my {
      id
      ... on BackofficeUser {
        kommune {
          prozessGroups {
            id
            name
          }
          prozessTags @export(exportName: "ProzessTag") {
            id
            tag
            prozesse {
              id
              name
            }
          }
          prozesseUndLeistungen(
            groupId: $groupId
            search: $search
            skip: $skip
            take: $take
          ) {
            items @export(exportName: "UserFacingProzess") {
              id
              name
              group @export(exportName: "ProzessGroup") {
                id
                name
              }
              ... on Prozess {
                tags {
                  id
                  tag
                }
                versionenCount
                deaktiviertAm
                currentVersion {
                  id
                  publishedAt
                }
              }
              ... on ServicePortalLink {
                url
              }
            }
            totalCount
          }
        }
      }
    }
  }
`;

export function useProzessUebersichtQuery(
  options?: Omit<Urql.UseQueryArgs<ProzessUebersichtQueryVariables>, 'query'>,
) {
  return Urql.useQuery<ProzessUebersichtQuery, ProzessUebersichtQueryVariables>(
    {query: ProzessUebersichtDocument, ...options},
  );
}
export const SetGroupToProzessDocument = gql`
  mutation setGroupToProzess($groupId: UUID, $prozessId: UUID!) {
    setGroupToProzess(input: {groupId: $groupId, prozessId: $prozessId}) {
      userFacingProzess {
        id
        name
      }
    }
  }
`;

export function useSetGroupToProzessMutation() {
  return Urql.useMutation<
    SetGroupToProzessMutation,
    SetGroupToProzessMutationVariables
  >(SetGroupToProzessDocument);
}
export const DeleteProzessVersionDocument = gql`
  mutation DeleteProzessVersion($input: DeleteProzessVersionInput!) {
    deleteProzessVersion(deleteProzessVersionInput: $input) {
      prozessVersion {
        id
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useDeleteProzessVersionMutation() {
  return Urql.useMutation<
    DeleteProzessVersionMutation,
    DeleteProzessVersionMutationVariables
  >(DeleteProzessVersionDocument);
}
export const DeleteServicePortalLinkDocument = gql`
  mutation DeleteServicePortalLink($input: DeleteServicePortalLinkInput!) {
    deleteServicePortalLink(deleteServicePortalLinkInput: $input) {
      servicePortalLink {
        id
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useDeleteServicePortalLinkMutation() {
  return Urql.useMutation<
    DeleteServicePortalLinkMutation,
    DeleteServicePortalLinkMutationVariables
  >(DeleteServicePortalLinkDocument);
}
export const DeleteProzessDocument = gql`
  mutation DeleteProzess($input: DeleteProzessInput!) {
    deleteProzess(deleteProzessInput: $input) {
      prozess {
        id
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useDeleteProzessMutation() {
  return Urql.useMutation<
    DeleteProzessMutation,
    DeleteProzessMutationVariables
  >(DeleteProzessDocument);
}
export const ProzessDeaktivierenDocument = gql`
  mutation ProzessDeaktivieren($input: ProzessDeaktivierenInput!) {
    prozessDeaktivieren(input: $input) {
      prozess {
        id
        deaktiviertAm
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useProzessDeaktivierenMutation() {
  return Urql.useMutation<
    ProzessDeaktivierenMutation,
    ProzessDeaktivierenMutationVariables
  >(ProzessDeaktivierenDocument);
}
export const ProzessAktivierenDocument = gql`
  mutation ProzessAktivieren($input: ProzessAktivierenInput!) {
    prozessAktivieren(input: $input) {
      prozess {
        id
        deaktiviertAm
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useProzessAktivierenMutation() {
  return Urql.useMutation<
    ProzessAktivierenMutation,
    ProzessAktivierenMutationVariables
  >(ProzessAktivierenDocument);
}
export const AssignProzessTagDocument = gql`
  mutation assignProzessTag($prozessId: UUID!, $tagId: UUID!) {
    assignProzessTag(input: {prozessId: $prozessId, tagId: $tagId}) {
      __typename
      prozess {
        id
        name
        tags {
          id
          tag
        }
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useAssignProzessTagMutation() {
  return Urql.useMutation<
    AssignProzessTagMutation,
    AssignProzessTagMutationVariables
  >(AssignProzessTagDocument);
}
