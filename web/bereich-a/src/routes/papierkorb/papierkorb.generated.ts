import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AntragWiederherstellenInput = {
  ausfuehrungId: string;
};

export type GeloeschteAntraegeQueryVariables = Types.Exact<{
  search?: Types.Maybe<string>;
  skip?: Types.Maybe<number>;
  take?: Types.Maybe<number>;
}>;

export type GeloeschteAntraegeQuery = {
  __typename?: 'Query';
  geloeschteAntraege?: {
    __typename?: 'GeloeschteAntraegeCollectionSegment';
    totalCount: number;
    items?: Array<{
      __typename?: 'GeloeschterAntrag';
      id: string;
      prozessBezeichnung: string;
      status: Types.AusfuehrungStatus;
      geloeschtAm: Date;
      loeschgrund?: string | null;
      geloeschtVon?: string | null;
      endgueltigGeloeschtAm?: Date | null;
    }> | null;
  } | null;
};

export type GeloeschterAntragQueryVariables = Types.Exact<{
  id: string;
}>;

export type GeloeschterAntragQuery = {
  __typename?: 'Query';
  geloeschterAntrag?: {
    __typename?: 'GeloeschterAntragDetail';
    sharedKeyEncryptedForKommune: string;
    antrag: {
      __typename?: 'GeloeschterAntrag';
      id: string;
      prozessBezeichnung: string;
      status: Types.AusfuehrungStatus;
      createdAt: Date;
      geloeschtAm: Date;
      loeschgrund?: string | null;
      geloeschtVon?: string | null;
      endgueltigGeloeschtAm?: Date | null;
    };
    slotWerte: Array<{
      __typename?: 'ArchivSlotWert';
      slotName: string;
      istFreigegeben?: boolean | null;
      encrypted: boolean;
      plainValue?: string | null;
      encryptedValue?: {
        __typename?: 'ArchivEncryptedValue';
        cipher: string;
        nonce: string;
        tag: string;
      } | null;
    }>;
    verlauf: Array<{
      __typename?: 'ArchivVerlaufEintrag';
      id: string;
      createdAt: Date;
      statusAenderung: string;
      statusAenderungBeschreibung: string;
      benutzer?: string | null;
      ziel?: string | null;
      nachricht?: string | null;
    }>;
  } | null;
};

export type AntragWiederherstellenMutationVariables = Types.Exact<{
  input: AntragWiederherstellenInput;
}>;

export type AntragWiederherstellenMutation = {
  __typename?: 'Mutation';
  antragWiederherstellen: {
    __typename?: 'AntragWiederherstellenPayload';
    ausfuehrung?: {__typename?: 'Ausfuehrung'; id: string} | null;
    errors?: Array<
      | {__typename?: 'AusfuehrungNotFoundError'; message: string}
      | {__typename?: 'NotAllowedError'; message: string}
    > | null;
  };
};

export const GeloeschteAntraegeDocument = gql`
  query GeloeschteAntraege($search: String, $skip: Int, $take: Int) {
    geloeschteAntraege(search: $search, skip: $skip, take: $take) {
      totalCount
      items {
        id
        prozessBezeichnung
        status
        geloeschtAm
        loeschgrund
        geloeschtVon
        endgueltigGeloeschtAm
      }
    }
  }
`;

export function useGeloeschteAntraegeQuery(
  options?: Omit<Urql.UseQueryArgs<GeloeschteAntraegeQueryVariables>, 'query'>,
) {
  return Urql.useQuery<
    GeloeschteAntraegeQuery,
    GeloeschteAntraegeQueryVariables
  >({query: GeloeschteAntraegeDocument, ...options});
}
export const GeloeschterAntragDocument = gql`
  query GeloeschterAntrag($id: UUID!) {
    geloeschterAntrag(id: $id) {
      antrag {
        id
        prozessBezeichnung
        status
        createdAt
        geloeschtAm
        loeschgrund
        geloeschtVon
        endgueltigGeloeschtAm
      }
      sharedKeyEncryptedForKommune
      slotWerte {
        slotName
        istFreigegeben
        encrypted
        encryptedValue {
          cipher
          nonce
          tag
        }
        plainValue
      }
      verlauf {
        id
        createdAt
        statusAenderung
        statusAenderungBeschreibung
        benutzer
        ziel
        nachricht
      }
    }
  }
`;

export function useGeloeschterAntragQuery(
  options: Omit<Urql.UseQueryArgs<GeloeschterAntragQueryVariables>, 'query'>,
) {
  return Urql.useQuery<GeloeschterAntragQuery, GeloeschterAntragQueryVariables>(
    {query: GeloeschterAntragDocument, ...options},
  );
}
export const AntragWiederherstellenDocument = gql`
  mutation AntragWiederherstellen($input: AntragWiederherstellenInput!) {
    antragWiederherstellen(input: $input) {
      ausfuehrung {
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

export function useAntragWiederherstellenMutation() {
  return Urql.useMutation<
    AntragWiederherstellenMutation,
    AntragWiederherstellenMutationVariables
  >(AntragWiederherstellenDocument);
}
