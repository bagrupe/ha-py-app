import * as Types from '../../../__generated__/graphql';

import {
  ProzessEditorSchritt_BezahlenSchritt_Fragment,
  ProzessEditorSchritt_EmailForwarderExportSchritt_Fragment,
  ProzessEditorSchritt_EndeSchritt_Fragment,
  ProzessEditorSchritt_FormularSchritt_Fragment,
  ProzessEditorSchritt_GovManagerRestExportSchritt_Fragment,
  ProzessEditorSchritt_NachrichtSchritt_Fragment,
  ProzessEditorSchritt_ProgrammatischerSchritt_Fragment,
  ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt_Fragment,
  ProzessEditorSchritt_WarteAufGovManagerSchritt_Fragment,
} from './prozess-editor-schritt.generated';
import {ProzessEditorProzessFragment} from './prozess-version-erstellen.generated';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {ProzessEditorSchrittFragmentDoc} from './prozess-editor-schritt.generated';
import {ProzessEditorProzessFragmentDoc} from './prozess-version-erstellen.generated';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type ProzessUpsertInput = {
  id?: string | null;
  name: string;
};

export type ProzessVersionVeroeffentlichenInput = {
  prozessVersionId: string;
};

export type ProzessVersionFragment = {
  __typename?: 'ProzessVersion';
  id: string;
  publishedAt?: Date | null;
  start?:
    | {__typename?: 'BezahlenSchritt'; id: string}
    | {__typename?: 'EmailForwarderExportSchritt'; id: string}
    | {__typename?: 'EndeSchritt'; id: string}
    | {__typename?: 'FormularSchritt'; id: string}
    | {__typename?: 'GovManagerRestExportSchritt'; id: string}
    | {__typename?: 'NachrichtSchritt'; id: string}
    | {__typename?: 'ProgrammatischerSchritt'; id: string}
    | {__typename?: 'WarteAufBezahlungAbgeschlossenSchritt'; id: string}
    | {__typename?: 'WarteAufGovManagerSchritt'; id: string}
    | null;
  rollen: Array<{__typename?: 'ZustaendigkeitRolle'; id: string; name: string}>;
  alleSchritte: Array<
    | ({
        __typename?: 'BezahlenSchritt';
      } & ProzessEditorSchritt_BezahlenSchritt_Fragment)
    | ({
        __typename?: 'EmailForwarderExportSchritt';
      } & ProzessEditorSchritt_EmailForwarderExportSchritt_Fragment)
    | ({__typename?: 'EndeSchritt'} & ProzessEditorSchritt_EndeSchritt_Fragment)
    | ({
        __typename?: 'FormularSchritt';
      } & ProzessEditorSchritt_FormularSchritt_Fragment)
    | ({
        __typename?: 'GovManagerRestExportSchritt';
      } & ProzessEditorSchritt_GovManagerRestExportSchritt_Fragment)
    | ({
        __typename?: 'NachrichtSchritt';
      } & ProzessEditorSchritt_NachrichtSchritt_Fragment)
    | ({
        __typename?: 'ProgrammatischerSchritt';
      } & ProzessEditorSchritt_ProgrammatischerSchritt_Fragment)
    | ({
        __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
      } & ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt_Fragment)
    | ({
        __typename?: 'WarteAufGovManagerSchritt';
      } & ProzessEditorSchritt_WarteAufGovManagerSchritt_Fragment)
  >;
};

export type GetProzessByIdQueryVariables = Types.Exact<{
  prozessId: string;
}>;

export type GetProzessByIdQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          prozessById: {__typename?: 'Prozess'} & ProzessEditorProzessFragment;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type MoeglicheZustaendigeQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type MoeglicheZustaendigeQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        kommune: {
          __typename?: 'Kommune';
          dienstleister: Array<{
            __typename?: 'Dienstleister';
            id: string;
            name: string;
            eMailAdressen: Array<string>;
            organisationseinheiten: Array<{
              __typename?: 'Untereinheit';
              id: string;
              name: string;
            }>;
          }>;
          organisationseinheiten: Array<{
            __typename?: 'Untereinheit';
            id: string;
            name: string;
            mitarbeiterGruppen: Array<{
              __typename?: 'MitarbeiterGruppe';
              id: string;
              name: string;
              eMailAdressen: Array<string>;
              isDeleted: boolean;
            }>;
          }>;
        };
      }
    | {__typename?: 'Buerger'}
    | {__typename?: 'SystemUser'};
};

export type GruppenUndOrganisationseinheitenQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type GruppenUndOrganisationseinheitenQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        id: string;
        organisationseinheiten: Array<{
          __typename?: 'ResolvedBackofficeUserOrganisationseinheit';
          organisationseinheit: {
            __typename?: 'Untereinheit';
            id: string;
            name: string;
          };
        }>;
        kommune: {
          __typename?: 'Kommune';
          mitarbeiterGruppen: Array<{
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
            eMailAdressen: Array<string>;
          }>;
        };
      }
    | {__typename?: 'Buerger'; id: string}
    | {__typename?: 'SystemUser'; id: string};
};

export type ProzessVersionVeroeffentlichenMutationVariables = Types.Exact<{
  input: ProzessVersionVeroeffentlichenInput;
}>;

export type ProzessVersionVeroeffentlichenMutation = {
  __typename?: 'Mutation';
  prozessVersionVeroeffentlichen: {
    __typename?: 'ProzessVersionVeroeffentlichenPayload';
    prozessVersion?:
      | ({__typename?: 'ProzessVersion'} & ProzessVersionFragment)
      | null;
  };
};

export type ProzessUmbenennenMutationVariables = Types.Exact<{
  input: ProzessUpsertInput;
}>;

export type ProzessUmbenennenMutation = {
  __typename?: 'Mutation';
  prozessUpsert: {
    __typename?: 'ProzessUpsertPayload';
    prozess?: {__typename?: 'Prozess'; id: string; name: string} | null;
  };
};

export const ProzessVersionFragmentDoc = gql`
  fragment ProzessVersion on ProzessVersion {
    id
    publishedAt
    start {
      id
    }
    rollen {
      id
      name
    }
    alleSchritte {
      ...ProzessEditorSchritt
    }
  }
  ${ProzessEditorSchrittFragmentDoc}
`;
export const GetProzessByIdDocument = gql`
  query GetProzessById($prozessId: UUID!) {
    my {
      ... on BackofficeUser {
        kommune {
          prozessById(id: $prozessId) {
            ...ProzessEditorProzess
          }
        }
      }
    }
  }
  ${ProzessEditorProzessFragmentDoc}
`;

export function useGetProzessByIdQuery(
  options: Omit<Urql.UseQueryArgs<GetProzessByIdQueryVariables>, 'query'>,
) {
  return Urql.useQuery<GetProzessByIdQuery, GetProzessByIdQueryVariables>({
    query: GetProzessByIdDocument,
    ...options,
  });
}
export const MoeglicheZustaendigeDocument = gql`
  query MoeglicheZustaendige {
    my {
      ... on BackofficeUser {
        kommune {
          dienstleister {
            id
            name
            eMailAdressen
            organisationseinheiten {
              id
              name
            }
          }
          organisationseinheiten: untereinheiten {
            id
            name
            mitarbeiterGruppen(includeDeleted: false) {
              id
              name
              eMailAdressen
              isDeleted
            }
          }
        }
      }
    }
  }
`;

export function useMoeglicheZustaendigeQuery(
  options?: Omit<
    Urql.UseQueryArgs<MoeglicheZustaendigeQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    MoeglicheZustaendigeQuery,
    MoeglicheZustaendigeQueryVariables
  >({query: MoeglicheZustaendigeDocument, ...options});
}
export const GruppenUndOrganisationseinheitenDocument = gql`
  query GruppenUndOrganisationseinheiten {
    my {
      id
      ... on BackofficeUser {
        organisationseinheiten {
          organisationseinheit {
            id
            name
          }
        }
        kommune {
          mitarbeiterGruppen {
            id
            name
            eMailAdressen
          }
        }
      }
    }
  }
`;

export function useGruppenUndOrganisationseinheitenQuery(
  options?: Omit<
    Urql.UseQueryArgs<GruppenUndOrganisationseinheitenQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    GruppenUndOrganisationseinheitenQuery,
    GruppenUndOrganisationseinheitenQueryVariables
  >({query: GruppenUndOrganisationseinheitenDocument, ...options});
}
export const ProzessVersionVeroeffentlichenDocument = gql`
  mutation ProzessVersionVeroeffentlichen(
    $input: ProzessVersionVeroeffentlichenInput!
  ) {
    prozessVersionVeroeffentlichen(input: $input) {
      prozessVersion {
        ...ProzessVersion
      }
    }
  }
  ${ProzessVersionFragmentDoc}
`;

export function useProzessVersionVeroeffentlichenMutation() {
  return Urql.useMutation<
    ProzessVersionVeroeffentlichenMutation,
    ProzessVersionVeroeffentlichenMutationVariables
  >(ProzessVersionVeroeffentlichenDocument);
}
export const ProzessUmbenennenDocument = gql`
  mutation ProzessUmbenennen($input: ProzessUpsertInput!) {
    prozessUpsert(input: $input) {
      prozess {
        id
        name
      }
    }
  }
`;

export function useProzessUmbenennenMutation() {
  return Urql.useMutation<
    ProzessUmbenennenMutation,
    ProzessUmbenennenMutationVariables
  >(ProzessUmbenennenDocument);
}
