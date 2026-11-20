import * as Types from '../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type ArchivierteAntraegeQueryVariables = Types.Exact<{
  search?: Types.Maybe<string>;
  skip?: Types.Maybe<number>;
  take?: Types.Maybe<number>;
}>;

export type ArchivierteAntraegeQuery = {
  __typename?: 'Query';
  archivierteAntraege?: {
    __typename?: 'ArchivierteAntraegeCollectionSegment';
    totalCount: number;
    items?: Array<{
      __typename?: 'ArchivierterAntragListItem';
      id: string;
      prozessBezeichnung?: string | null;
      status: Types.AusfuehrungStatus;
      abgeschlossenAm?: Date | null;
      archiviertAm: Date;
    }> | null;
  } | null;
};

export type ArchivierterAntragQueryVariables = Types.Exact<{
  id: string;
}>;

export type ArchivierterAntragQuery = {
  __typename?: 'Query';
  archivierterAntrag?: {
    __typename?: 'ArchivierterAntragDetail';
    id: string;
    prozessBezeichnung?: string | null;
    status: Types.AusfuehrungStatus;
    createdAt: Date;
    abgeschlossenAm?: Date | null;
    archiviertAm: Date;
    sharedKeyEncryptedForKommune: string;
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

export const ArchivierteAntraegeDocument = gql`
  query ArchivierteAntraege($search: String, $skip: Int, $take: Int) {
    archivierteAntraege(search: $search, skip: $skip, take: $take) {
      totalCount
      items {
        id
        prozessBezeichnung
        status
        abgeschlossenAm
        archiviertAm
      }
    }
  }
`;

export function useArchivierteAntraegeQuery(
  options?: Omit<Urql.UseQueryArgs<ArchivierteAntraegeQueryVariables>, 'query'>,
) {
  return Urql.useQuery<
    ArchivierteAntraegeQuery,
    ArchivierteAntraegeQueryVariables
  >({query: ArchivierteAntraegeDocument, ...options});
}
export const ArchivierterAntragDocument = gql`
  query ArchivierterAntrag($id: UUID!) {
    archivierterAntrag(id: $id) {
      id
      prozessBezeichnung
      status
      createdAt
      abgeschlossenAm
      archiviertAm
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

export function useArchivierterAntragQuery(
  options: Omit<Urql.UseQueryArgs<ArchivierterAntragQueryVariables>, 'query'>,
) {
  return Urql.useQuery<
    ArchivierterAntragQuery,
    ArchivierterAntragQueryVariables
  >({query: ArchivierterAntragDocument, ...options});
}
