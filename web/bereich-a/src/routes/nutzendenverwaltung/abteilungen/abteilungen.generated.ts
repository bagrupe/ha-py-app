import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AddAbteilungInput = {
  eMailAdressen: Array<string>;
  name: string;
};

export type DeleteAbteilungInput = {
  id: string;
};

export type UpdateAbteilungInput = {
  eMailAdressen: Array<string>;
  id: string;
  name: string;
  organisationseinheitIds: Array<string>;
};

export type UpdateAbteilungMutationVariables = Types.Exact<{
  input: UpdateAbteilungInput;
}>;

export type UpdateAbteilungMutation = {
  __typename?: 'Mutation';
  updateAbteilung: {
    __typename?: 'UpdateAbteilungPayload';
    mitarbeiterGruppe?: {
      __typename: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    errors?: Array<
      | {__typename: 'GroupNameInvalid'; message: string}
      | {__typename: 'InvalidEmailError'; message: string}
    > | null;
  };
};

export type DeleteAbteilungPayloadFragment = {
  __typename: 'DeleteAbteilungPayload';
  success: boolean;
  prozessDependencies?: Array<{
    __typename?: 'DeleteAbteilungProzessDependency';
    prozessId: string;
    prozessName: string;
    schrittNamen: Array<string>;
  }> | null;
  mitarbeiterGruppe?: {
    __typename: 'MitarbeiterGruppe';
    id: string;
    name: string;
  } | null;
};

export type DeleteAbteilungMutationVariables = Types.Exact<{
  input: DeleteAbteilungInput;
}>;

export type DeleteAbteilungMutation = {
  __typename?: 'Mutation';
  deleteAbteilung: {
    __typename: 'DeleteAbteilungPayload';
  } & DeleteAbteilungPayloadFragment;
};

export type AddAbteilungMutationVariables = Types.Exact<{
  input: AddAbteilungInput;
}>;

export type AddAbteilungMutation = {
  __typename?: 'Mutation';
  addAbteilung: {
    __typename?: 'AddAbteilungPayload';
    mitarbeiterGruppe?: {
      __typename: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    errors?: Array<{__typename: 'InvalidEmailError'; message: string}> | null;
  };
};

export const DeleteAbteilungPayloadFragmentDoc = gql`
  fragment DeleteAbteilungPayload on DeleteAbteilungPayload {
    __typename
    prozessDependencies {
      prozessId
      prozessName
      schrittNamen
    }
    success
    mitarbeiterGruppe {
      __typename
      id
      name
    }
  }
`;
export const UpdateAbteilungDocument = gql`
  mutation UpdateAbteilung($input: UpdateAbteilungInput!) {
    updateAbteilung(input: $input) {
      mitarbeiterGruppe {
        __typename
        id
        name
        eMailAdressen
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

export function useUpdateAbteilungMutation() {
  return Urql.useMutation<
    UpdateAbteilungMutation,
    UpdateAbteilungMutationVariables
  >(UpdateAbteilungDocument);
}
export const DeleteAbteilungDocument = gql`
  mutation DeleteAbteilung($input: DeleteAbteilungInput!) {
    deleteAbteilung(input: $input) {
      __typename
      ...DeleteAbteilungPayload
    }
  }
  ${DeleteAbteilungPayloadFragmentDoc}
`;

export function useDeleteAbteilungMutation() {
  return Urql.useMutation<
    DeleteAbteilungMutation,
    DeleteAbteilungMutationVariables
  >(DeleteAbteilungDocument);
}
export const AddAbteilungDocument = gql`
  mutation AddAbteilung($input: AddAbteilungInput!) {
    addAbteilung(input: $input) {
      mitarbeiterGruppe {
        __typename
        id
        name
        eMailAdressen
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

export function useAddAbteilungMutation() {
  return Urql.useMutation<AddAbteilungMutation, AddAbteilungMutationVariables>(
    AddAbteilungDocument,
  );
}
