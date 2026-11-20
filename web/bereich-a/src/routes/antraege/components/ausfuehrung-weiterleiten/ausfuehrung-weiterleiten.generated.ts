import * as Types from '../../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AusfuehrungWeiterleitenInput = {
  ausfuehrungId: string;
  empfaengerEmail?: string | null;
  empfaengerId?: string | null;
  nachricht?: string | null;
  weiterleitungArt?: Types.WeiterleitungArt | null;
  weiterleitungEmpfaenger: Types.WeiterleitungEmpfaenger;
};

export type MitarbeitendeQueryVariables = Types.Exact<{
  groupId?: Types.Maybe<string>;
  search?: Types.Maybe<string>;
  skip?: Types.Maybe<number>;
  take?: Types.Maybe<number>;
}>;

export type MitarbeitendeQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          mitarbeiter?: {
            __typename?: 'MitarbeiterCollectionSegment';
            items?: Array<{
              __typename?: 'BackofficeUser';
              id: string;
              vorname: string;
              nachname: string;
              eMail: string;
              gruppen: Array<{
                __typename?: 'MitarbeiterGruppe';
                id: string;
                name: string;
              }>;
            }> | null;
            pageInfo: {
              __typename?: 'CollectionSegmentInfo';
              hasNextPage: boolean;
            };
          } | null;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type AusfuehrungWeiterleitenError_AntragWeiterleitenError_Fragment = {
  __typename: 'AntragWeiterleitenError';
};

export type AusfuehrungWeiterleitenError_AusfuehrungNotFoundError_Fragment = {
  __typename: 'AusfuehrungNotFoundError';
};

export type AusfuehrungWeiterleitenError_NachrichtRequiredError_Fragment = {
  __typename: 'NachrichtRequiredError';
};

export type AusfuehrungWeiterleitenError_NachrichtTooLongError_Fragment = {
  __typename: 'NachrichtTooLongError';
};

export type AusfuehrungWeiterleitenError_NotAllowedError_Fragment = {
  __typename: 'NotAllowedError';
};

export type AusfuehrungWeiterleitenError_UserNotFoundError_Fragment = {
  __typename: 'UserNotFoundError';
};

export type AusfuehrungWeiterleitenErrorFragment =
  | AusfuehrungWeiterleitenError_AntragWeiterleitenError_Fragment
  | AusfuehrungWeiterleitenError_AusfuehrungNotFoundError_Fragment
  | AusfuehrungWeiterleitenError_NachrichtRequiredError_Fragment
  | AusfuehrungWeiterleitenError_NachrichtTooLongError_Fragment
  | AusfuehrungWeiterleitenError_NotAllowedError_Fragment
  | AusfuehrungWeiterleitenError_UserNotFoundError_Fragment;

export type AusfuehrungWeiterleitenMutationVariables = Types.Exact<{
  input: AusfuehrungWeiterleitenInput;
}>;

export type AusfuehrungWeiterleitenMutation = {
  __typename?: 'Mutation';
  ausfuehrungWeiterleiten: {
    __typename?: 'AusfuehrungWeiterleitenPayload';
    ausfuehrung?: {
      __typename?: 'Ausfuehrung';
      istZustaendigkeit: {
        __typename?: 'Zustaendigkeit';
        zugewiesenePerson?: {
          __typename?: 'BackofficeUser';
          vorname: string;
          nachname: string;
        } | null;
      };
    } | null;
    errors?: Array<
      | {__typename?: 'AntragWeiterleitenError'; message: string}
      | {__typename?: 'AusfuehrungNotFoundError'; message: string}
      | {__typename?: 'NachrichtRequiredError'; message: string}
      | {__typename?: 'NachrichtTooLongError'; message: string}
      | {__typename?: 'NotAllowedError'; message: string}
      | {__typename?: 'UserNotFoundError'; message: string}
    > | null;
  };
};

export const AusfuehrungWeiterleitenErrorFragmentDoc = gql`
  fragment AusfuehrungWeiterleitenError on AusfuehrungWeiterleitenError {
    __typename
  }
`;
export const MitarbeitendeDocument = gql`
  query Mitarbeitende($groupId: UUID, $search: String, $skip: Int, $take: Int) {
    my {
      ... on BackofficeUser {
        kommune {
          mitarbeiter(
            groupId: $groupId
            search: $search
            skip: $skip
            take: $take
          ) {
            items {
              id
              vorname
              nachname
              eMail
              gruppen {
                id
                name
              }
            }
            pageInfo {
              hasNextPage
            }
          }
        }
      }
    }
  }
`;

export function useMitarbeitendeQuery(
  options?: Omit<Urql.UseQueryArgs<MitarbeitendeQueryVariables>, 'query'>,
) {
  return Urql.useQuery<MitarbeitendeQuery, MitarbeitendeQueryVariables>({
    query: MitarbeitendeDocument,
    ...options,
  });
}
export const AusfuehrungWeiterleitenDocument = gql`
  mutation AusfuehrungWeiterleiten($input: AusfuehrungWeiterleitenInput!) {
    ausfuehrungWeiterleiten(input: $input) {
      ausfuehrung {
        istZustaendigkeit {
          zugewiesenePerson {
            vorname
            nachname
          }
        }
      }
      errors {
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useAusfuehrungWeiterleitenMutation() {
  return Urql.useMutation<
    AusfuehrungWeiterleitenMutation,
    AusfuehrungWeiterleitenMutationVariables
  >(AusfuehrungWeiterleitenDocument);
}
