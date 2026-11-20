import * as Types from '../../../__generated__/graphql';

import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';

export type ProzessEditorFormularFeldBase_AnzeigeTextBlockFeld_Fragment = {
  __typename: 'AnzeigeTextBlockFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_CheckboxListFormularFeld_Fragment = {
  __typename: 'CheckboxListFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_DateFormularFeld_Fragment = {
  __typename: 'DateFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_LocationFormularFeld_Fragment = {
  __typename: 'LocationFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_SignatureFormularFeld_Fragment = {
  __typename: 'SignatureFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_StringFormularFeld_Fragment = {
  __typename: 'StringFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_TimeFormularFeld_Fragment = {
  __typename: 'TimeFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBase_UploadFormularFeld_Fragment = {
  __typename: 'UploadFormularFeld';
  id: string;
  slotName: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  order: number;
  encrypted: boolean;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  pflichtfeld: boolean;
  oeffentlichSichtbar: boolean;
};

export type ProzessEditorFormularFeldBaseFragment =
  | ProzessEditorFormularFeldBase_AnzeigeTextBlockFeld_Fragment
  | ProzessEditorFormularFeldBase_CheckboxListFormularFeld_Fragment
  | ProzessEditorFormularFeldBase_DateFormularFeld_Fragment
  | ProzessEditorFormularFeldBase_LocationFormularFeld_Fragment
  | ProzessEditorFormularFeldBase_SignatureFormularFeld_Fragment
  | ProzessEditorFormularFeldBase_StringFormularFeld_Fragment
  | ProzessEditorFormularFeldBase_TimeFormularFeld_Fragment
  | ProzessEditorFormularFeldBase_UploadFormularFeld_Fragment;

export type ProzessEditorFormularFeld_AnzeigeTextBlockFeld_Fragment = {
  __typename?: 'AnzeigeTextBlockFeld';
  text: string;
} & ProzessEditorFormularFeldBase_AnzeigeTextBlockFeld_Fragment;

export type ProzessEditorFormularFeld_CheckboxListFormularFeld_Fragment = {
  __typename?: 'CheckboxListFormularFeld';
  options: Array<{
    __typename?: 'CheckboxListFeldOption';
    key: string;
    label: string;
    order: number;
    defaultChecked: boolean;
  }>;
} & ProzessEditorFormularFeldBase_CheckboxListFormularFeld_Fragment;

export type ProzessEditorFormularFeld_DateFormularFeld_Fragment = {
  __typename?: 'DateFormularFeld';
} & ProzessEditorFormularFeldBase_DateFormularFeld_Fragment;

export type ProzessEditorFormularFeld_LocationFormularFeld_Fragment = {
  __typename?: 'LocationFormularFeld';
} & ProzessEditorFormularFeldBase_LocationFormularFeld_Fragment;

export type ProzessEditorFormularFeld_SignatureFormularFeld_Fragment = {
  __typename?: 'SignatureFormularFeld';
} & ProzessEditorFormularFeldBase_SignatureFormularFeld_Fragment;

export type ProzessEditorFormularFeld_StringFormularFeld_Fragment = {
  __typename?: 'StringFormularFeld';
  multiline: boolean;
  durchsuchbar: boolean;
  options: Array<{
    __typename?: 'StringFormularFeldOption';
    key: string;
    value: string;
    istRelevant?: BoolExpression | null;
  }>;
} & ProzessEditorFormularFeldBase_StringFormularFeld_Fragment;

export type ProzessEditorFormularFeld_TimeFormularFeld_Fragment = {
  __typename?: 'TimeFormularFeld';
} & ProzessEditorFormularFeldBase_TimeFormularFeld_Fragment;

export type ProzessEditorFormularFeld_UploadFormularFeld_Fragment = {
  __typename?: 'UploadFormularFeld';
  multi: boolean;
  document: boolean;
  brauchtFreigabe: boolean;
} & ProzessEditorFormularFeldBase_UploadFormularFeld_Fragment;

export type ProzessEditorFormularFeldFragment =
  | ProzessEditorFormularFeld_AnzeigeTextBlockFeld_Fragment
  | ProzessEditorFormularFeld_CheckboxListFormularFeld_Fragment
  | ProzessEditorFormularFeld_DateFormularFeld_Fragment
  | ProzessEditorFormularFeld_LocationFormularFeld_Fragment
  | ProzessEditorFormularFeld_SignatureFormularFeld_Fragment
  | ProzessEditorFormularFeld_StringFormularFeld_Fragment
  | ProzessEditorFormularFeld_TimeFormularFeld_Fragment
  | ProzessEditorFormularFeld_UploadFormularFeld_Fragment;

export const ProzessEditorFormularFeldBaseFragmentDoc = gql`
  fragment ProzessEditorFormularFeldBase on FormularFeld {
    __typename
    id
    slotName
    angezeigterName
    anweisung
    order
    encrypted
    inhaltsTag
    istRelevant
    pflichtfeld
    oeffentlichSichtbar
  }
`;
export const ProzessEditorFormularFeldFragmentDoc = gql`
  fragment ProzessEditorFormularFeld on FormularFeld {
    ...ProzessEditorFormularFeldBase
    ... on CheckboxListFormularFeld {
      options {
        key
        label
        order
        defaultChecked
      }
    }
    ... on AnzeigeTextBlockFeld {
      text
    }
    ... on StringFormularFeld {
      multiline
      durchsuchbar
      options {
        key
        value
        istRelevant
      }
    }
    ... on UploadFormularFeld {
      multi
      document
      brauchtFreigabe
    }
  }
  ${ProzessEditorFormularFeldBaseFragmentDoc}
`;
