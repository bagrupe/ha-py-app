import * as Types from '../../__generated__/graphql';

import {
  SlotValue_EncryptedSlotValue_Fragment,
  SlotValue_PlainSlotValue_Fragment,
} from '../../components/ui/slot-value/slot-value.generated';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {SlotValueFragmentDoc} from '../../components/ui/slot-value/slot-value.generated';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;

export type AusfuehrungFragment = {
  __typename?: 'Ausfuehrung';
  id: string;
  sharedKeyEncryptedForKommune: string;
  createdAt: Date;
  istZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    dienstleister?: {
      __typename?: 'Dienstleister';
      id: string;
      name: string;
    } | null;
    organisationseinheit?: {
      __typename?: 'Untereinheit';
      id: string;
      name: string;
    } | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
    } | null;
    zugewiesenePerson?: {
      __typename?: 'BackofficeUser';
      id: string;
      vorname: string;
      nachname: string;
    } | null;
  };
  prozessVersion: {
    __typename?: 'ProzessVersion';
    id: string;
    beschreibungstext: StringExpression;
    prozess: {__typename?: 'Prozess'; id: string; name: string};
  };
  currentSchritt:
    | {
        __typename?: 'BezahlenSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'EmailForwarderExportSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'EndeSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'FormularSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'GovManagerRestExportSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'NachrichtSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'ProgrammatischerSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'WarteAufGovManagerSchritt';
        id: string;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      };
  beschreibungstextSlotValues: Array<
    | ({
        __typename?: 'EncryptedSlotValue';
      } & SlotValue_EncryptedSlotValue_Fragment)
    | ({__typename?: 'PlainSlotValue'} & SlotValue_PlainSlotValue_Fragment)
  >;
};

export type AusfuehrungenQueryVariables = Types.Exact<{
  status?: Types.Maybe<Types.AusfuehrungStatus>;
  zugewiesen?: Types.Maybe<boolean>;
  prozessId?: Types.Maybe<string>;
  skip?: Types.Maybe<number>;
  take?: Types.Maybe<number>;
}>;

export type AusfuehrungenQuery = {
  __typename?: 'Query';
  ausfuehrungen?: {
    __typename?: 'AusfuehrungenCollectionSegment';
    totalCount: number;
    items?: Array<{__typename?: 'Ausfuehrung'} & AusfuehrungFragment> | null;
  } | null;
};

export const AusfuehrungFragmentDoc = gql`
  fragment Ausfuehrung on Ausfuehrung {
    id
    sharedKeyEncryptedForKommune
    createdAt
    istZustaendigkeit {
      art
      dienstleister {
        id
        name
      }
      organisationseinheit {
        id
        name
      }
      mitarbeiterGruppe {
        id
        name
      }
      zugewiesenePerson {
        id
        vorname
        nachname
      }
    }
    prozessVersion {
      id
      beschreibungstext
      prozess {
        id
        name
      }
    }
    currentSchritt {
      id
      sollZustaendigkeit {
        mitarbeiterGruppe {
          id
          name
        }
      }
    }
    beschreibungstextSlotValues {
      ...SlotValue
    }
  }
  ${SlotValueFragmentDoc}
`;
export const AusfuehrungenDocument = gql`
  query Ausfuehrungen(
    $status: AusfuehrungStatus
    $zugewiesen: Boolean
    $prozessId: UUID
    $skip: Int
    $take: Int
  ) {
    ausfuehrungen(
      status: $status
      zugewiesen: $zugewiesen
      prozessId: $prozessId
      skip: $skip
      take: $take
    ) {
      totalCount
      items {
        ...Ausfuehrung
      }
    }
  }
  ${AusfuehrungFragmentDoc}
`;

export function useAusfuehrungenQuery(
  options?: Omit<Urql.UseQueryArgs<AusfuehrungenQueryVariables>, 'query'>,
) {
  return Urql.useQuery<AusfuehrungenQuery, AusfuehrungenQueryVariables>({
    query: AusfuehrungenDocument,
    ...options,
  });
}
