import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AddGebieteToLageInput = {
  gebietIds: Array<string>;
  lageId: string;
};

export type CreateLageInput = {
  gebietIds?: Array<string> | null;
  note?: string | null;
  title: string;
  untereinheitId: string;
};

export type SetLageGebietStatusInput = {
  gebietId: string;
  lageId: string;
  status: Types.LageGebietStatus;
};

export type UpdateLageInput = {
  lageId: string;
  note?: string | null;
  title: string;
};

export type LageListItemFragment = {
  __typename?: 'Lage';
  id: string;
  untereinheitId: string;
  title: string;
  status: Types.LageStatus;
  createdAt: Date;
  gebiete: Array<{
    __typename?: 'LageGebiet';
    id: string;
    gebietId: string;
    status: Types.LageGebietStatus;
    gebiet: {__typename?: 'Gebiet'; id: string; name: string};
  }>;
};

export type LageDetailFragment = {
  __typename?: 'Lage';
  id: string;
  untereinheitId: string;
  title: string;
  note?: string | null;
  warningText?: string | null;
  status: Types.LageStatus;
  createdAt: Date;
  updatedAt: Date;
  closedAt?: Date | null;
  gebiete: Array<{
    __typename?: 'LageGebiet';
    id: string;
    gebietId: string;
    status: Types.LageGebietStatus;
    calledOutAt?: Date | null;
    readyAt?: Date | null;
    liveAt?: Date | null;
    endedAt?: Date | null;
    doneAt?: Date | null;
    gebiet: {
      __typename?: 'Gebiet';
      id: string;
      name: string;
      einsatzleitungen: Array<{
        __typename?: 'MitarbeiterGruppe';
        id: string;
        name: string;
      }>;
    };
  }>;
};

export type GebietOptionFragment = {
  __typename?: 'Gebiet';
  id: string;
  untereinheitId: string;
  name: string;
};

export type LagenQueryVariables = Types.Exact<{
  status?: Types.Maybe<Types.LageStatus>;
}>;

export type LagenQuery = {
  __typename?: 'Query';
  lagen: Array<{__typename?: 'Lage'} & LageListItemFragment>;
};

export type LageByIdQueryVariables = Types.Exact<{
  id: string;
}>;

export type LageByIdQuery = {
  __typename?: 'Query';
  lage?: ({__typename?: 'Lage'} & LageDetailFragment) | null;
  gebiete: Array<{__typename?: 'Gebiet'} & GebietOptionFragment>;
};

export type LageErstellenOptionenQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type LageErstellenOptionenQuery = {
  __typename?: 'Query';
  gebiete: Array<{__typename?: 'Gebiet'} & GebietOptionFragment>;
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          id: string;
          untereinheiten: Array<{
            __typename?: 'Untereinheit';
            id: string;
            name: string;
          }>;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type CreateLageMutationVariables = Types.Exact<{
  input: CreateLageInput;
}>;

export type CreateLageMutation = {
  __typename?: 'Mutation';
  createLage: {
    __typename?: 'CreateLagePayload';
    lage?: {__typename?: 'Lage'; id: string} | null;
    errors?: Array<
      | {__typename: 'GebietOfOtherUntereinheitError'; message: string}
      | {__typename: 'LageUntereinheitNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type UpdateLageMutationVariables = Types.Exact<{
  input: UpdateLageInput;
}>;

export type UpdateLageMutation = {
  __typename?: 'Mutation';
  updateLage: {
    __typename?: 'UpdateLagePayload';
    lage?: ({__typename?: 'Lage'} & LageDetailFragment) | null;
    errors?: Array<
      | {__typename: 'LageNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type AddGebieteToLageMutationVariables = Types.Exact<{
  input: AddGebieteToLageInput;
}>;

export type AddGebieteToLageMutation = {
  __typename?: 'Mutation';
  addGebieteToLage: {
    __typename?: 'AddGebieteToLagePayload';
    lage?: ({__typename?: 'Lage'} & LageDetailFragment) | null;
    errors?: Array<
      | {__typename: 'GebietAlreadyInLageError'; message: string}
      | {__typename: 'GebietOfOtherUntereinheitError'; message: string}
      | {__typename: 'LageClosedError'; message: string}
      | {__typename: 'LageNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type SetLageGebietStatusMutationVariables = Types.Exact<{
  input: SetLageGebietStatusInput;
}>;

export type SetLageGebietStatusMutation = {
  __typename?: 'Mutation';
  setLageGebietStatus: {
    __typename?: 'SetLageGebietStatusPayload';
    lage?: ({__typename?: 'Lage'} & LageDetailFragment) | null;
    errors?: Array<
      | {__typename: 'GebietNotInLageError'; message: string}
      | {__typename: 'InvalidLageGebietTransitionError'; message: string}
      | {__typename: 'LageClosedError'; message: string}
      | {__typename: 'LageNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export const LageListItemFragmentDoc = gql`
  fragment LageListItem on Lage {
    id
    untereinheitId
    title
    status
    createdAt
    gebiete {
      id
      gebietId
      status
      gebiet {
        id
        name
      }
    }
  }
`;
export const LageDetailFragmentDoc = gql`
  fragment LageDetail on Lage {
    id
    untereinheitId
    title
    note
    warningText
    status
    createdAt
    updatedAt
    closedAt
    gebiete {
      id
      gebietId
      status
      calledOutAt
      readyAt
      liveAt
      endedAt
      doneAt
      gebiet {
        id
        name
        einsatzleitungen {
          id
          name
        }
      }
    }
  }
`;
export const GebietOptionFragmentDoc = gql`
  fragment GebietOption on Gebiet {
    id
    untereinheitId
    name
  }
`;
export const LagenDocument = gql`
  query Lagen($status: LageStatus) {
    lagen(status: $status) {
      ...LageListItem
    }
  }
  ${LageListItemFragmentDoc}
`;

export function useLagenQuery(
  options?: Omit<Urql.UseQueryArgs<LagenQueryVariables>, 'query'>,
) {
  return Urql.useQuery<LagenQuery, LagenQueryVariables>({
    query: LagenDocument,
    ...options,
  });
}
export const LageByIdDocument = gql`
  query LageById($id: UUID!) {
    lage(id: $id) {
      ...LageDetail
    }
    gebiete {
      ...GebietOption
    }
  }
  ${LageDetailFragmentDoc}
  ${GebietOptionFragmentDoc}
`;

export function useLageByIdQuery(
  options: Omit<Urql.UseQueryArgs<LageByIdQueryVariables>, 'query'>,
) {
  return Urql.useQuery<LageByIdQuery, LageByIdQueryVariables>({
    query: LageByIdDocument,
    ...options,
  });
}
export const LageErstellenOptionenDocument = gql`
  query LageErstellenOptionen {
    gebiete {
      ...GebietOption
    }
    my {
      ... on BackofficeUser {
        kommune {
          id
          untereinheiten {
            id
            name
          }
        }
      }
    }
  }
  ${GebietOptionFragmentDoc}
`;

export function useLageErstellenOptionenQuery(
  options?: Omit<
    Urql.UseQueryArgs<LageErstellenOptionenQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    LageErstellenOptionenQuery,
    LageErstellenOptionenQueryVariables
  >({query: LageErstellenOptionenDocument, ...options});
}
export const CreateLageDocument = gql`
  mutation CreateLage($input: CreateLageInput!) {
    createLage(input: $input) {
      lage {
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

export function useCreateLageMutation() {
  return Urql.useMutation<CreateLageMutation, CreateLageMutationVariables>(
    CreateLageDocument,
  );
}
export const UpdateLageDocument = gql`
  mutation UpdateLage($input: UpdateLageInput!) {
    updateLage(input: $input) {
      lage {
        ...LageDetail
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${LageDetailFragmentDoc}
`;

export function useUpdateLageMutation() {
  return Urql.useMutation<UpdateLageMutation, UpdateLageMutationVariables>(
    UpdateLageDocument,
  );
}
export const AddGebieteToLageDocument = gql`
  mutation AddGebieteToLage($input: AddGebieteToLageInput!) {
    addGebieteToLage(input: $input) {
      lage {
        ...LageDetail
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${LageDetailFragmentDoc}
`;

export function useAddGebieteToLageMutation() {
  return Urql.useMutation<
    AddGebieteToLageMutation,
    AddGebieteToLageMutationVariables
  >(AddGebieteToLageDocument);
}
export const SetLageGebietStatusDocument = gql`
  mutation SetLageGebietStatus($input: SetLageGebietStatusInput!) {
    setLageGebietStatus(input: $input) {
      lage {
        ...LageDetail
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${LageDetailFragmentDoc}
`;

export function useSetLageGebietStatusMutation() {
  return Urql.useMutation<
    SetLageGebietStatusMutation,
    SetLageGebietStatusMutationVariables
  >(SetLageGebietStatusDocument);
}
