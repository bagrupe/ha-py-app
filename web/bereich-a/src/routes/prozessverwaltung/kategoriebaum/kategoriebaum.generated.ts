import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type KategorieAusblendungAufhebenInput = {
  kategorieId: string;
  untereinheitId: string;
};

export type KategorieAusblendungSetzenInput = {
  kategorieId: string;
  untereinheitId: string;
};

export type KategorieCreateInput = {
  name: string;
  parentId?: string | null;
  untereinheitId?: string | null;
};

export type KategorieDeleteInput = {
  id: string;
};

export type KategorieRenameInput = {
  id: string;
  name: string;
};

export type KategorieZustaendigkeitSetzenInput = {
  art: Types.ZustaendigkeitArt;
  dienstleisterId?: string | null;
  erbt: boolean;
  kategorieId: string;
  mitarbeiterGruppeId?: string | null;
};

export type KategoriebaumOptionenQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type KategoriebaumOptionenQuery = {
  __typename?: 'Query';
  my:
    | {
        __typename?: 'BackofficeUser';
        art: Types.BackofficeNutzerArt;
        id: string;
        kommune: {
          __typename?: 'Kommune';
          untereinheiten: Array<{
            __typename?: 'Untereinheit';
            id: string;
            name: string;
            mitarbeiterGruppen: Array<{
              __typename?: 'MitarbeiterGruppe';
              id: string;
              name: string;
            }>;
          }>;
          dienstleister: Array<{
            __typename?: 'Dienstleister';
            id: string;
            name: string;
            organisationseinheiten: Array<{
              __typename?: 'Untereinheit';
              id: string;
            }>;
          }>;
        };
      }
    | {__typename?: 'Buerger'; id: string}
    | {__typename?: 'SystemUser'; id: string};
};

export type KategorieBaumQueryVariables = Types.Exact<{
  untereinheitId: string;
}>;

export type KategorieBaumQuery = {
  __typename?: 'Query';
  kategorieBaum: Array<{__typename?: 'Kategorie'} & KategorieFragment>;
};

export type AusgeblendeteKategorienQueryVariables = Types.Exact<{
  untereinheitId: string;
}>;

export type AusgeblendeteKategorienQuery = {
  __typename?: 'Query';
  ausgeblendeteKategorien: Array<
    {__typename?: 'Kategorie'} & KategorieFragment
  >;
};

export type KategorieLoeschVorschauQueryVariables = Types.Exact<{
  id: string;
}>;

export type KategorieLoeschVorschauQuery = {
  __typename?: 'Query';
  kategorieLoeschVorschau: {
    __typename?: 'KategorieLoeschVorschau';
    anzahlUnterkategorien: number;
    istGeteilt: boolean;
    betroffeneUntereinheiten: Array<{
      __typename?: 'UntereinheitBetroffenheit';
      untereinheitName: string;
      anzahlEigeneUnterkategorien: number;
    }>;
  };
};

export type KategorieCreateMutationVariables = Types.Exact<{
  input: KategorieCreateInput;
}>;

export type KategorieCreateMutation = {
  __typename?: 'Mutation';
  kategorieCreate: {
    __typename?: 'KategorieCreatePayload';
    kategorie?: ({__typename?: 'Kategorie'} & KategorieFragment) | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type KategorieRenameMutationVariables = Types.Exact<{
  input: KategorieRenameInput;
}>;

export type KategorieRenameMutation = {
  __typename?: 'Mutation';
  kategorieRename: {
    __typename?: 'KategorieRenamePayload';
    kategorie?: ({__typename?: 'Kategorie'} & KategorieFragment) | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type KategorieZustaendigkeitSetzenMutationVariables = Types.Exact<{
  input: KategorieZustaendigkeitSetzenInput;
}>;

export type KategorieZustaendigkeitSetzenMutation = {
  __typename?: 'Mutation';
  kategorieZustaendigkeitSetzen: {
    __typename?: 'KategorieZustaendigkeitSetzenPayload';
    kategorie?: ({__typename?: 'Kategorie'} & KategorieFragment) | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type KategorieDeleteMutationVariables = Types.Exact<{
  input: KategorieDeleteInput;
}>;

export type KategorieDeleteMutation = {
  __typename?: 'Mutation';
  kategorieDelete: {
    __typename?: 'KategorieDeletePayload';
    success?: boolean | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type KategorieAusblendungSetzenMutationVariables = Types.Exact<{
  input: KategorieAusblendungSetzenInput;
}>;

export type KategorieAusblendungSetzenMutation = {
  __typename?: 'Mutation';
  kategorieAusblendungSetzen: {
    __typename?: 'KategorieAusblendungSetzenPayload';
    success?: boolean | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type KategorieAusblendungAufhebenMutationVariables = Types.Exact<{
  input: KategorieAusblendungAufhebenInput;
}>;

export type KategorieAusblendungAufhebenMutation = {
  __typename?: 'Mutation';
  kategorieAusblendungAufheben: {
    __typename?: 'KategorieAusblendungAufhebenPayload';
    success?: boolean | null;
    errors?: Array<{__typename: 'NotAllowedError'; message: string}> | null;
  };
};

export type KategorieFragment = {
  __typename?: 'Kategorie';
  id: string;
  parentId?: string | null;
  untereinheitId?: string | null;
  istWurzel: boolean;
  name: string;
  ziel?: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
  } | null;
};

export const KategorieFragmentDoc = gql`
  fragment Kategorie on Kategorie {
    id
    parentId
    untereinheitId
    istWurzel
    name
    ziel {
      art
      organisationseinheitId
      mitarbeiterGruppeId
      dienstleisterId
    }
  }
`;
export const KategoriebaumOptionenDocument = gql`
  query KategoriebaumOptionen {
    my {
      id
      ... on BackofficeUser {
        art
        kommune {
          untereinheiten {
            id
            name
            mitarbeiterGruppen(includeDeleted: false) {
              id
              name
            }
          }
          dienstleister {
            id
            name
            organisationseinheiten {
              id
            }
          }
        }
      }
    }
  }
`;

export function useKategoriebaumOptionenQuery(
  options?: Omit<
    Urql.UseQueryArgs<KategoriebaumOptionenQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    KategoriebaumOptionenQuery,
    KategoriebaumOptionenQueryVariables
  >({query: KategoriebaumOptionenDocument, ...options});
}
export const KategorieBaumDocument = gql`
  query KategorieBaum($untereinheitId: UUID!) {
    kategorieBaum(untereinheitId: $untereinheitId) {
      ...Kategorie
    }
  }
  ${KategorieFragmentDoc}
`;

export function useKategorieBaumQuery(
  options: Omit<Urql.UseQueryArgs<KategorieBaumQueryVariables>, 'query'>,
) {
  return Urql.useQuery<KategorieBaumQuery, KategorieBaumQueryVariables>({
    query: KategorieBaumDocument,
    ...options,
  });
}
export const AusgeblendeteKategorienDocument = gql`
  query AusgeblendeteKategorien($untereinheitId: UUID!) {
    ausgeblendeteKategorien(untereinheitId: $untereinheitId) {
      ...Kategorie
    }
  }
  ${KategorieFragmentDoc}
`;

export function useAusgeblendeteKategorienQuery(
  options: Omit<
    Urql.UseQueryArgs<AusgeblendeteKategorienQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    AusgeblendeteKategorienQuery,
    AusgeblendeteKategorienQueryVariables
  >({query: AusgeblendeteKategorienDocument, ...options});
}
export const KategorieLoeschVorschauDocument = gql`
  query KategorieLoeschVorschau($id: UUID!) {
    kategorieLoeschVorschau(id: $id) {
      anzahlUnterkategorien
      istGeteilt
      betroffeneUntereinheiten {
        untereinheitName
        anzahlEigeneUnterkategorien
      }
    }
  }
`;

export function useKategorieLoeschVorschauQuery(
  options: Omit<
    Urql.UseQueryArgs<KategorieLoeschVorschauQueryVariables>,
    'query'
  >,
) {
  return Urql.useQuery<
    KategorieLoeschVorschauQuery,
    KategorieLoeschVorschauQueryVariables
  >({query: KategorieLoeschVorschauDocument, ...options});
}
export const KategorieCreateDocument = gql`
  mutation KategorieCreate($input: KategorieCreateInput!) {
    kategorieCreate(input: $input) {
      kategorie {
        ...Kategorie
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${KategorieFragmentDoc}
`;

export function useKategorieCreateMutation() {
  return Urql.useMutation<
    KategorieCreateMutation,
    KategorieCreateMutationVariables
  >(KategorieCreateDocument);
}
export const KategorieRenameDocument = gql`
  mutation KategorieRename($input: KategorieRenameInput!) {
    kategorieRename(input: $input) {
      kategorie {
        ...Kategorie
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${KategorieFragmentDoc}
`;

export function useKategorieRenameMutation() {
  return Urql.useMutation<
    KategorieRenameMutation,
    KategorieRenameMutationVariables
  >(KategorieRenameDocument);
}
export const KategorieZustaendigkeitSetzenDocument = gql`
  mutation KategorieZustaendigkeitSetzen(
    $input: KategorieZustaendigkeitSetzenInput!
  ) {
    kategorieZustaendigkeitSetzen(input: $input) {
      kategorie {
        ...Kategorie
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${KategorieFragmentDoc}
`;

export function useKategorieZustaendigkeitSetzenMutation() {
  return Urql.useMutation<
    KategorieZustaendigkeitSetzenMutation,
    KategorieZustaendigkeitSetzenMutationVariables
  >(KategorieZustaendigkeitSetzenDocument);
}
export const KategorieDeleteDocument = gql`
  mutation KategorieDelete($input: KategorieDeleteInput!) {
    kategorieDelete(input: $input) {
      success
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useKategorieDeleteMutation() {
  return Urql.useMutation<
    KategorieDeleteMutation,
    KategorieDeleteMutationVariables
  >(KategorieDeleteDocument);
}
export const KategorieAusblendungSetzenDocument = gql`
  mutation KategorieAusblendungSetzen(
    $input: KategorieAusblendungSetzenInput!
  ) {
    kategorieAusblendungSetzen(input: $input) {
      success
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useKategorieAusblendungSetzenMutation() {
  return Urql.useMutation<
    KategorieAusblendungSetzenMutation,
    KategorieAusblendungSetzenMutationVariables
  >(KategorieAusblendungSetzenDocument);
}
export const KategorieAusblendungAufhebenDocument = gql`
  mutation KategorieAusblendungAufheben(
    $input: KategorieAusblendungAufhebenInput!
  ) {
    kategorieAusblendungAufheben(input: $input) {
      success
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
`;

export function useKategorieAusblendungAufhebenMutation() {
  return Urql.useMutation<
    KategorieAusblendungAufhebenMutation,
    KategorieAusblendungAufhebenMutationVariables
  >(KategorieAusblendungAufhebenDocument);
}
