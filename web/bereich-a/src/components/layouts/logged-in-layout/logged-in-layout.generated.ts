import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type LoggedInLayoutQueryVariables = Types.Exact<{[key: string]: never}>;

export type LoggedInLayoutQuery = {
  __typename?: 'Query';
  neu?: {
    __typename?: 'AusfuehrungenCollectionSegment';
    totalCount: number;
  } | null;
  inBearbeitung?: {
    __typename?: 'AusfuehrungenCollectionSegment';
    totalCount: number;
  } | null;
  abgeschlossen?: {
    __typename?: 'AusfuehrungenCollectionSegment';
    totalCount: number;
  } | null;
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          id: string;
          prozesse: Array<{__typename?: 'Prozess'; id: string; name: string}>;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type RechtstexteQueryVariables = Types.Exact<{[key: string]: never}>;

export type RechtstexteQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          id: string;
          rechtsTexte: {
            __typename?: 'BereichBKommune_Legal';
            impressum?: string | null;
            privacy?: string | null;
          };
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export const LoggedInLayoutDocument = gql`
  query loggedInLayout {
    neu: ausfuehrungen(status: BEARBEITUNG_DURCH_KOMMUNE, zugewiesen: false) {
      totalCount
    }
    inBearbeitung: ausfuehrungen(
      status: BEARBEITUNG_DURCH_KOMMUNE
      zugewiesen: true
    ) {
      totalCount
    }
    abgeschlossen: ausfuehrungen(status: ABGESCHLOSSEN) {
      totalCount
    }
    my {
      ... on BackofficeUser {
        kommune {
          id
          prozesse {
            id
            name
          }
        }
      }
    }
  }
`;

export function useLoggedInLayoutQuery(
  options?: Omit<Urql.UseQueryArgs<LoggedInLayoutQueryVariables>, 'query'>,
) {
  return Urql.useQuery<LoggedInLayoutQuery, LoggedInLayoutQueryVariables>({
    query: LoggedInLayoutDocument,
    ...options,
  });
}
export const RechtstexteDocument = gql`
  query Rechtstexte {
    my {
      ... on BackofficeUser {
        kommune {
          id
          rechtsTexte {
            impressum
            privacy
          }
        }
      }
    }
  }
`;

export function useRechtstexteQuery(
  options?: Omit<Urql.UseQueryArgs<RechtstexteQueryVariables>, 'query'>,
) {
  return Urql.useQuery<RechtstexteQuery, RechtstexteQueryVariables>({
    query: RechtstexteDocument,
    ...options,
  });
}
