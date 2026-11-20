import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AddProzessGroupInput = {
  name: string;
};

export type DeleteProzessGroupInput = {
  id: string;
};

export type UpdateProzessGroupInput = {
  id: string;
  name: string;
};

export type UpdateProzessGroupMutationVariables = Types.Exact<{
  input: UpdateProzessGroupInput;
}>;

export type UpdateProzessGroupMutation = {
  __typename?: 'Mutation';
  updateProzessGroup: {
    __typename: 'UpdateProzessGroupPayload';
    prozessGroup?: {
      __typename?: 'ProzessGroup';
      id: string;
      name: string;
    } | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type DeleteProzessGroupMutationVariables = Types.Exact<{
  input: DeleteProzessGroupInput;
}>;

export type DeleteProzessGroupMutation = {
  __typename?: 'Mutation';
  deleteProzessGroup: {
    __typename: 'DeleteProzessGroupPayload';
    prozessGroup?: {
      __typename?: 'ProzessGroup';
      id: string;
      name: string;
    } | null;
    errors?: Array<
      | {__typename: 'NotAllowedError'; message: string}
      | {__typename: 'ProzessGroupAssignedToProzess'; message: string}
      | {__typename: 'ProzessGroupNotFound'; message: string}
    > | null;
  };
};

export type AddProzessGroupMutationVariables = Types.Exact<{
  input: AddProzessGroupInput;
}>;

export type AddProzessGroupMutation = {
  __typename?: 'Mutation';
  addProzessGroup: {
    __typename: 'AddProzessGroupPayload';
    prozessGroup?: {
      __typename: 'ProzessGroup';
      id: string;
      name: string;
    } | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export const UpdateProzessGroupDocument = gql`
  mutation UpdateProzessGroup($input: UpdateProzessGroupInput!) {
    updateProzessGroup(updateProzessGroupInput: $input) {
      __typename
      prozessGroup {
        id
        name
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

export function useUpdateProzessGroupMutation() {
  return Urql.useMutation<
    UpdateProzessGroupMutation,
    UpdateProzessGroupMutationVariables
  >(UpdateProzessGroupDocument);
}
export const DeleteProzessGroupDocument = gql`
  mutation DeleteProzessGroup($input: DeleteProzessGroupInput!) {
    deleteProzessGroup(deleteProzessGroupInput: $input) {
      __typename
      prozessGroup {
        id
        name
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

export function useDeleteProzessGroupMutation() {
  return Urql.useMutation<
    DeleteProzessGroupMutation,
    DeleteProzessGroupMutationVariables
  >(DeleteProzessGroupDocument);
}
export const AddProzessGroupDocument = gql`
  mutation AddProzessGroup($input: AddProzessGroupInput!) {
    addProzessGroup(addProzessGroupInput: $input) {
      __typename
      prozessGroup {
        __typename
        id
        name
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

export function useAddProzessGroupMutation() {
  return Urql.useMutation<
    AddProzessGroupMutation,
    AddProzessGroupMutationVariables
  >(AddProzessGroupDocument);
}
