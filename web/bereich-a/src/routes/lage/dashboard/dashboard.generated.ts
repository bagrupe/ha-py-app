import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type MeldungAnLeitstelleAbgebenInput = {
  ausfuehrungId: string;
  grund: Types.AbgabeGrund;
  kommentar?: string | null;
};

export type MeldungEinheitZuweisenInput = {
  ausfuehrungId: string;
  einheitId?: string | null;
};

export type MeldungEinschaetzungSetzenInput = {
  ausfuehrungId: string;
  benoetigteAusruestung?: Array<string> | null;
  klasse?: Types.MeldungKlasse | null;
};

export type MeldungExternUebergebenInput = {
  ausfuehrungId: string;
  kommentar?: string | null;
  stelle: Types.ExterneStelle;
};

export type MeldungFortsetzenInput = {
  aktion: Types.MeldungAktion;
  ausfuehrungId: string;
};

export type MeldungNotfallPruefenInput = {
  ausfuehrungId: string;
  ergebnis: Types.NotfallPruefung;
};

export type MeldungUmverteilenInput = {
  ausfuehrungId: string;
  mitarbeiterGruppeId: string;
};

export type MeldungVerwerfenInput = {
  ausfuehrungId: string;
  begruendung: string;
};

export type SetLageMeldewegInput = {
  lageId: string;
  offen: boolean;
};

export type DashboardMeldungFragment = {
  __typename?: 'Ausfuehrung';
  id: string;
  meldungsnummer?: number | null;
  createdAt: Date;
  abgeschlossenAm?: Date | null;
  ereignisStatus?: Types.EreignisStatus | null;
  klasse?: Types.MeldungKlasse | null;
  benoetigteAusruestung?: Array<string> | null;
  moeglicherNotfall: boolean;
  notfallPruefung?: Types.NotfallPruefung | null;
  klaerungSeit?: Date | null;
  klaerungGrund?: Types.AbgabeGrund | null;
  klaerungKommentar?: string | null;
  verwerfenGrund?: string | null;
  externeStelle?: Types.ExterneStelle | null;
  externKommentar?: string | null;
  anzahlBestaetigungen: number;
  lage?: {
    __typename?: 'LageAssignment';
    gebietId: string;
    gebietName: string;
  } | null;
  einheit?: {__typename?: 'Einheit'; id: string} | null;
  istZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    mitarbeiterGruppeId?: string | null;
  };
  slotValues: Array<
    | {__typename?: 'EncryptedSlotValue'; slotName: string}
    | {__typename?: 'PlainSlotValue'; value: unknown; slotName: string}
  >;
};

export type DashboardLageFragment = {
  __typename?: 'Lage';
  id: string;
  title: string;
  status: Types.LageStatus;
  warningText?: string | null;
  meldewegPausiertSeit?: Date | null;
  gebiete: Array<{
    __typename?: 'LageGebiet';
    id: string;
    gebietId: string;
    status: Types.LageGebietStatus;
    liveAt?: Date | null;
  }>;
};

export type DashboardGebietFragment = {
  __typename?: 'Gebiet';
  id: string;
  name: string;
  geometry?: string | null;
  einsatzleitungen: Array<{
    __typename?: 'MitarbeiterGruppe';
    id: string;
    name: string;
  }>;
};

export type DashboardEinheitFragment = {
  __typename?: 'Einheit';
  id: string;
  name: string;
  ausruestung: Array<string>;
  mitarbeiterGruppeId: string;
};

export type DashboardStammdatenQueryVariables = Types.Exact<{
  [key: string]: never;
}>;

export type DashboardStammdatenQuery = {
  __typename?: 'Query';
  lagen: Array<{__typename?: 'Lage'} & DashboardLageFragment>;
  gebiete: Array<{__typename?: 'Gebiet'} & DashboardGebietFragment>;
  einheiten: Array<{__typename?: 'Einheit'} & DashboardEinheitFragment>;
};

export type DashboardMeldungenQueryVariables = Types.Exact<{
  lageId: string;
  offen?: Types.Maybe<boolean>;
}>;

export type DashboardMeldungenQuery = {
  __typename?: 'Query';
  lageMeldungen: Array<{__typename?: 'Ausfuehrung'} & DashboardMeldungFragment>;
};

export type DashboardEinheitZuweisenMutationVariables = Types.Exact<{
  input: MeldungEinheitZuweisenInput;
}>;

export type DashboardEinheitZuweisenMutation = {
  __typename?: 'Mutation';
  meldungEinheitZuweisen: {
    __typename?: 'MeldungEinheitZuweisenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {
          __typename: 'EinheitGehoertNichtZurEinsatzleitungError';
          message: string;
        }
      | {__typename: 'EinheitNotFoundError'; message: string}
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungInKlaerungError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardFortsetzenMutationVariables = Types.Exact<{
  input: MeldungFortsetzenInput;
}>;

export type DashboardFortsetzenMutation = {
  __typename?: 'Mutation';
  meldungFortsetzen: {
    __typename?: 'MeldungFortsetzenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungAktionNichtMoeglichError'; message: string}
      | {__typename: 'MeldungInKlaerungError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardAnLeitstelleAbgebenMutationVariables = Types.Exact<{
  input: MeldungAnLeitstelleAbgebenInput;
}>;

export type DashboardAnLeitstelleAbgebenMutation = {
  __typename?: 'Mutation';
  meldungAnLeitstelleAbgeben: {
    __typename?: 'MeldungAnLeitstelleAbgebenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'BegruendungErforderlichError'; message: string}
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungInKlaerungError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardUmverteilenMutationVariables = Types.Exact<{
  input: MeldungUmverteilenInput;
}>;

export type DashboardUmverteilenMutation = {
  __typename?: 'Mutation';
  meldungUmverteilen: {
    __typename?: 'MeldungUmverteilenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'MitarbeiterGruppeNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardExternUebergebenMutationVariables = Types.Exact<{
  input: MeldungExternUebergebenInput;
}>;

export type DashboardExternUebergebenMutation = {
  __typename?: 'Mutation';
  meldungExternUebergeben: {
    __typename?: 'MeldungExternUebergebenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardVerwerfenMutationVariables = Types.Exact<{
  input: MeldungVerwerfenInput;
}>;

export type DashboardVerwerfenMutation = {
  __typename?: 'Mutation';
  meldungVerwerfen: {
    __typename?: 'MeldungVerwerfenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'BegruendungErforderlichError'; message: string}
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardNotfallPruefenMutationVariables = Types.Exact<{
  input: MeldungNotfallPruefenInput;
}>;

export type DashboardNotfallPruefenMutation = {
  __typename?: 'Mutation';
  meldungNotfallPruefen: {
    __typename?: 'MeldungNotfallPruefenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardEinschaetzungSetzenMutationVariables = Types.Exact<{
  input: MeldungEinschaetzungSetzenInput;
}>;

export type DashboardEinschaetzungSetzenMutation = {
  __typename?: 'Mutation';
  meldungEinschaetzungSetzen: {
    __typename?: 'MeldungEinschaetzungSetzenPayload';
    ausfuehrung?:
      | ({__typename?: 'Ausfuehrung'} & DashboardMeldungFragment)
      | null;
    errors?: Array<
      | {__typename: 'MeldungAbgeschlossenError'; message: string}
      | {__typename: 'MeldungNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export type DashboardMeldewegMutationVariables = Types.Exact<{
  input: SetLageMeldewegInput;
}>;

export type DashboardMeldewegMutation = {
  __typename?: 'Mutation';
  setLageMeldeweg: {
    __typename?: 'SetLageMeldewegPayload';
    lage?: ({__typename?: 'Lage'} & DashboardLageFragment) | null;
    errors?: Array<
      | {__typename: 'LageClosedError'; message: string}
      | {__typename: 'LageNotFoundError'; message: string}
      | {__typename: 'NotAllowedError'; message: string}
    > | null;
  };
};

export const DashboardMeldungFragmentDoc = gql`
  fragment DashboardMeldung on Ausfuehrung {
    id
    meldungsnummer
    createdAt
    abgeschlossenAm
    ereignisStatus
    klasse
    benoetigteAusruestung
    moeglicherNotfall
    notfallPruefung
    klaerungSeit
    klaerungGrund
    klaerungKommentar
    verwerfenGrund
    externeStelle
    externKommentar
    anzahlBestaetigungen
    lage {
      gebietId
      gebietName
    }
    einheit {
      id
    }
    istZustaendigkeit {
      mitarbeiterGruppeId
    }
    slotValues(
      where: {slotName: {in: ["kategorie", "beschreibung", "adresse"]}}
    ) {
      slotName
      ... on PlainSlotValue {
        value
      }
    }
  }
`;
export const DashboardLageFragmentDoc = gql`
  fragment DashboardLage on Lage {
    id
    title
    status
    warningText
    meldewegPausiertSeit
    gebiete {
      id
      gebietId
      status
      liveAt
    }
  }
`;
export const DashboardGebietFragmentDoc = gql`
  fragment DashboardGebiet on Gebiet {
    id
    name
    geometry
    einsatzleitungen {
      id
      name
    }
  }
`;
export const DashboardEinheitFragmentDoc = gql`
  fragment DashboardEinheit on Einheit {
    id
    name
    ausruestung
    mitarbeiterGruppeId
  }
`;
export const DashboardStammdatenDocument = gql`
  query DashboardStammdaten {
    lagen {
      ...DashboardLage
    }
    gebiete {
      ...DashboardGebiet
    }
    einheiten {
      ...DashboardEinheit
    }
  }
  ${DashboardLageFragmentDoc}
  ${DashboardGebietFragmentDoc}
  ${DashboardEinheitFragmentDoc}
`;

export function useDashboardStammdatenQuery(
  options?: Omit<Urql.UseQueryArgs<DashboardStammdatenQueryVariables>, 'query'>,
) {
  return Urql.useQuery<
    DashboardStammdatenQuery,
    DashboardStammdatenQueryVariables
  >({query: DashboardStammdatenDocument, ...options});
}
export const DashboardMeldungenDocument = gql`
  query DashboardMeldungen($lageId: UUID!, $offen: Boolean) {
    lageMeldungen(lageId: $lageId, offen: $offen) {
      ...DashboardMeldung
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardMeldungenQuery(
  options: Omit<Urql.UseQueryArgs<DashboardMeldungenQueryVariables>, 'query'>,
) {
  return Urql.useQuery<
    DashboardMeldungenQuery,
    DashboardMeldungenQueryVariables
  >({query: DashboardMeldungenDocument, ...options});
}
export const DashboardEinheitZuweisenDocument = gql`
  mutation DashboardEinheitZuweisen($input: MeldungEinheitZuweisenInput!) {
    meldungEinheitZuweisen(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardEinheitZuweisenMutation() {
  return Urql.useMutation<
    DashboardEinheitZuweisenMutation,
    DashboardEinheitZuweisenMutationVariables
  >(DashboardEinheitZuweisenDocument);
}
export const DashboardFortsetzenDocument = gql`
  mutation DashboardFortsetzen($input: MeldungFortsetzenInput!) {
    meldungFortsetzen(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardFortsetzenMutation() {
  return Urql.useMutation<
    DashboardFortsetzenMutation,
    DashboardFortsetzenMutationVariables
  >(DashboardFortsetzenDocument);
}
export const DashboardAnLeitstelleAbgebenDocument = gql`
  mutation DashboardAnLeitstelleAbgeben(
    $input: MeldungAnLeitstelleAbgebenInput!
  ) {
    meldungAnLeitstelleAbgeben(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardAnLeitstelleAbgebenMutation() {
  return Urql.useMutation<
    DashboardAnLeitstelleAbgebenMutation,
    DashboardAnLeitstelleAbgebenMutationVariables
  >(DashboardAnLeitstelleAbgebenDocument);
}
export const DashboardUmverteilenDocument = gql`
  mutation DashboardUmverteilen($input: MeldungUmverteilenInput!) {
    meldungUmverteilen(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardUmverteilenMutation() {
  return Urql.useMutation<
    DashboardUmverteilenMutation,
    DashboardUmverteilenMutationVariables
  >(DashboardUmverteilenDocument);
}
export const DashboardExternUebergebenDocument = gql`
  mutation DashboardExternUebergeben($input: MeldungExternUebergebenInput!) {
    meldungExternUebergeben(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardExternUebergebenMutation() {
  return Urql.useMutation<
    DashboardExternUebergebenMutation,
    DashboardExternUebergebenMutationVariables
  >(DashboardExternUebergebenDocument);
}
export const DashboardVerwerfenDocument = gql`
  mutation DashboardVerwerfen($input: MeldungVerwerfenInput!) {
    meldungVerwerfen(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardVerwerfenMutation() {
  return Urql.useMutation<
    DashboardVerwerfenMutation,
    DashboardVerwerfenMutationVariables
  >(DashboardVerwerfenDocument);
}
export const DashboardNotfallPruefenDocument = gql`
  mutation DashboardNotfallPruefen($input: MeldungNotfallPruefenInput!) {
    meldungNotfallPruefen(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardNotfallPruefenMutation() {
  return Urql.useMutation<
    DashboardNotfallPruefenMutation,
    DashboardNotfallPruefenMutationVariables
  >(DashboardNotfallPruefenDocument);
}
export const DashboardEinschaetzungSetzenDocument = gql`
  mutation DashboardEinschaetzungSetzen(
    $input: MeldungEinschaetzungSetzenInput!
  ) {
    meldungEinschaetzungSetzen(input: $input) {
      ausfuehrung {
        ...DashboardMeldung
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardMeldungFragmentDoc}
`;

export function useDashboardEinschaetzungSetzenMutation() {
  return Urql.useMutation<
    DashboardEinschaetzungSetzenMutation,
    DashboardEinschaetzungSetzenMutationVariables
  >(DashboardEinschaetzungSetzenDocument);
}
export const DashboardMeldewegDocument = gql`
  mutation DashboardMeldeweg($input: SetLageMeldewegInput!) {
    setLageMeldeweg(input: $input) {
      lage {
        ...DashboardLage
      }
      errors {
        __typename
        ... on Error {
          message
        }
      }
    }
  }
  ${DashboardLageFragmentDoc}
`;

export function useDashboardMeldewegMutation() {
  return Urql.useMutation<
    DashboardMeldewegMutation,
    DashboardMeldewegMutationVariables
  >(DashboardMeldewegDocument);
}
