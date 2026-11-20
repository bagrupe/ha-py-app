import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type BackofficeUserOrganisationseinheitInput = {
  nutzerspezifischeFunktionsberechtigungen: Array<Types.FunktionsberechtigungInOrganisationseinheit>;
  organisationseinheitId: string;
  zugehoerig: boolean;
};

export type BackofficeUserUpdateInput = {
  assignedGroups: Array<string>;
  backofficeUserId: string;
  funktionsberechtigungen: Array<Types.GlobaleFunktionsberechtigung>;
  organisationseinheiten: Array<BackofficeUserOrganisationseinheitInput>;
};

export type NutzendeQueryVariables = Types.Exact<{
  groupId?: Types.Maybe<string>;
  nurDienstleister?: Types.Maybe<boolean>;
  art?: Types.Maybe<Types.BackofficeNutzerArt>;
  search?: Types.Maybe<string>;
  skip?: Types.Maybe<number>;
  take?: Types.Maybe<number>;
}>;

export type NutzendeQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          mitarbeiter?: {
            __typename?: 'MitarbeiterCollectionSegment';
            totalCount: number;
            items?: Array<
              {__typename?: 'BackofficeUser'} & NutzendeListItemFragment
            > | null;
          } | null;
          mitarbeiterGruppen: Array<
            {__typename?: 'MitarbeiterGruppe'} & MitarbeiterGruppeFragment
          >;
          untereinheiten: Array<
            {__typename?: 'Untereinheit'} & UntereinheitFragment
          >;
        };
        dienstleister?: {__typename?: 'Dienstleister'; name: string} | null;
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
  availableFunktionsberechtigungen: {
    __typename?: 'FunktionsberechtigungenMetadata';
  } & FunktionsberechtigungenMetadataFragment;
};

export type NutzendeListItemFragment = {
  __typename?: 'BackofficeUser';
  publicKey?: string | null;
  art: Types.BackofficeNutzerArt;
  status: Types.BackofficeNutzerStatus;
  canBeDeleted: boolean;
  canBeUpdated: boolean;
  funktionsberechtigungen: Array<Types.GlobaleFunktionsberechtigung>;
  id: string;
  vorname: string;
  nachname: string;
  eMail: string;
  isDeleted: boolean;
  pendingConfirmation?: Types.PendingConfirmationReason | null;
  organisationseinheiten: Array<
    {
      __typename?: 'ResolvedBackofficeUserOrganisationseinheit';
    } & BackofficeUserOrganisationseinheitFragment
  >;
  dienstleister?: {__typename?: 'Dienstleister'; name: string} | null;
  gruppen: Array<{__typename?: 'MitarbeiterGruppe'; id: string; name: string}>;
};

export type BackofficeUserOrganisationseinheitFragment = {
  __typename?: 'ResolvedBackofficeUserOrganisationseinheit';
  organisationseinheitId: string;
  zugehoerig: boolean;
  nutzerspezifischeFunktionsberechtigungen: Array<Types.FunktionsberechtigungInOrganisationseinheit>;
  geerbteFunktionsberechtigungen: Array<Types.FunktionsberechtigungInOrganisationseinheit>;
  alleFunktionsberechtigungen: Array<Types.FunktionsberechtigungInOrganisationseinheit>;
  organisationseinheit: {__typename?: 'Untereinheit'; name: string};
};

export type UntereinheitFragment = {
  __typename?: 'Untereinheit';
  id: string;
  name: string;
  eMailAdressen: Array<string>;
};

export type AddGroupToMitarbeiterMutationVariables = Types.Exact<{
  groupId: string;
  mitarbeiterId: string;
}>;

export type AddGroupToMitarbeiterMutation = {
  __typename?: 'Mutation';
  addGroupToMitarbeiter: {
    __typename?: 'AddGroupToMitarbeiterPayload';
    mitarbeiter?: {
      __typename?: 'BackofficeUser';
      id: string;
      vorname: string;
      nachname: string;
    } | null;
  };
};

export type BackofficeUserUpdateMutationVariables = Types.Exact<{
  input: BackofficeUserUpdateInput;
}>;

export type BackofficeUserUpdateMutation = {
  __typename?: 'Mutation';
  backofficeUserUpdate: {
    __typename: 'BackofficeUserUpdatePayload';
    backofficeUser?: {__typename?: 'BackofficeUser'; id: string} | null;
    errors?: Array<{__typename?: 'NotAllowedError'; message: string}> | null;
  };
};

export type RemoveGroupFromMitarbeiterMutationVariables = Types.Exact<{
  groupId: string;
  mitarbeiterId: string;
}>;

export type RemoveGroupFromMitarbeiterMutation = {
  __typename?: 'Mutation';
  removeGroupFromMitarbeiter: {
    __typename?: 'RemoveGroupFromMitarbeiterPayload';
    mitarbeiter?: {
      __typename?: 'BackofficeUser';
      id: string;
      vorname: string;
      nachname: string;
    } | null;
  };
};

export type MitarbeiterGruppeFragment = {
  __typename?: 'MitarbeiterGruppe';
  id: string;
  name: string;
  eMailAdressen: Array<string>;
  organisationseinheiten: Array<{__typename?: 'Untereinheit'; id: string}>;
};

export type FunktionsberechtigungenMetadataFragment = {
  __typename?: 'FunktionsberechtigungenMetadata';
  global: Array<{
    __typename?: 'FunktionsberechtigungMetadataOfGlobaleFunktionsberechtigung';
    name: string;
    value: Types.GlobaleFunktionsberechtigung;
    description: string;
    groupName: string;
  }>;
  inOrganisationseinheit: Array<{
    __typename?: 'FunktionsberechtigungMetadataOfFunktionsberechtigungInOrganisationseinheit';
    name: string;
    value: Types.FunktionsberechtigungInOrganisationseinheit;
    description: string;
    groupName: string;
    nutzerArtMindestens: Types.BackofficeNutzerArt;
    implizit: boolean;
  }>;
};

export const BackofficeUserOrganisationseinheitFragmentDoc = gql`
  fragment BackofficeUserOrganisationseinheit on ResolvedBackofficeUserOrganisationseinheit {
    organisationseinheitId
    organisationseinheit {
      name
    }
    zugehoerig
    nutzerspezifischeFunktionsberechtigungen
    geerbteFunktionsberechtigungen
    alleFunktionsberechtigungen
  }
`;
export const NutzendeListItemFragmentDoc = gql`
  fragment NutzendeListItem on Mitarbeiter {
    id
    vorname
    nachname
    eMail
    isDeleted
    gruppen {
      id
      name
    }
    pendingConfirmation
    ... on BackofficeUser {
      publicKey
      organisationseinheiten {
        ...BackofficeUserOrganisationseinheit
      }
      art
      status
      canBeDeleted
      canBeUpdated
      funktionsberechtigungen
      dienstleister {
        name
      }
    }
  }
  ${BackofficeUserOrganisationseinheitFragmentDoc}
`;
export const UntereinheitFragmentDoc = gql`
  fragment Untereinheit on Untereinheit {
    id
    name
    eMailAdressen
  }
`;
export const MitarbeiterGruppeFragmentDoc = gql`
  fragment MitarbeiterGruppe on MitarbeiterGruppe {
    id
    name
    eMailAdressen
    organisationseinheiten {
      id
    }
  }
`;
export const FunktionsberechtigungenMetadataFragmentDoc = gql`
  fragment FunktionsberechtigungenMetadata on FunktionsberechtigungenMetadata {
    global {
      name
      value
      description
      groupName
    }
    inOrganisationseinheit {
      name
      value
      description
      groupName
      nutzerArtMindestens
      implizit
    }
  }
`;
export const NutzendeDocument = gql`
  query Nutzende(
    $groupId: UUID
    $nurDienstleister: Boolean
    $art: BackofficeNutzerArt
    $search: String
    $skip: Int
    $take: Int
  ) {
    my {
      ... on BackofficeUser {
        kommune {
          mitarbeiter(
            groupId: $groupId
            nurDienstleister: $nurDienstleister
            art: $art
            search: $search
            skip: $skip
            take: $take
          ) {
            items {
              ...NutzendeListItem
            }
            totalCount
          }
          mitarbeiterGruppen {
            ...MitarbeiterGruppe
          }
          untereinheiten {
            ...Untereinheit
          }
        }
        dienstleister {
          name
        }
      }
    }
    availableFunktionsberechtigungen: funktionsberechtigungen {
      ...FunktionsberechtigungenMetadata
    }
  }
  ${NutzendeListItemFragmentDoc}
  ${MitarbeiterGruppeFragmentDoc}
  ${UntereinheitFragmentDoc}
  ${FunktionsberechtigungenMetadataFragmentDoc}
`;

export function useNutzendeQuery(
  options?: Omit<Urql.UseQueryArgs<NutzendeQueryVariables>, 'query'>,
) {
  return Urql.useQuery<NutzendeQuery, NutzendeQueryVariables>({
    query: NutzendeDocument,
    ...options,
  });
}
export const AddGroupToMitarbeiterDocument = gql`
  mutation addGroupToMitarbeiter($groupId: UUID!, $mitarbeiterId: UUID!) {
    addGroupToMitarbeiter(
      input: {groupId: $groupId, mitarbeiterId: $mitarbeiterId}
    ) {
      mitarbeiter {
        id
        vorname
        nachname
      }
    }
  }
`;

export function useAddGroupToMitarbeiterMutation() {
  return Urql.useMutation<
    AddGroupToMitarbeiterMutation,
    AddGroupToMitarbeiterMutationVariables
  >(AddGroupToMitarbeiterDocument);
}
export const BackofficeUserUpdateDocument = gql`
  mutation backofficeUserUpdate($input: BackofficeUserUpdateInput!) {
    backofficeUserUpdate(input: $input) {
      __typename
      backofficeUser {
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

export function useBackofficeUserUpdateMutation() {
  return Urql.useMutation<
    BackofficeUserUpdateMutation,
    BackofficeUserUpdateMutationVariables
  >(BackofficeUserUpdateDocument);
}
export const RemoveGroupFromMitarbeiterDocument = gql`
  mutation removeGroupFromMitarbeiter($groupId: UUID!, $mitarbeiterId: UUID!) {
    removeGroupFromMitarbeiter(
      input: {groupId: $groupId, mitarbeiterId: $mitarbeiterId}
    ) {
      mitarbeiter {
        id
        vorname
        nachname
      }
    }
  }
`;

export function useRemoveGroupFromMitarbeiterMutation() {
  return Urql.useMutation<
    RemoveGroupFromMitarbeiterMutation,
    RemoveGroupFromMitarbeiterMutationVariables
  >(RemoveGroupFromMitarbeiterDocument);
}
