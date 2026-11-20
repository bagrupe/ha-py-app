import * as Types from '../../../__generated__/graphql';

import {ProzessEditorVerbindungFragment} from './prozess-editor-verbindung.generated';
import {
  ProzessEditorFormularFeld_AnzeigeTextBlockFeld_Fragment,
  ProzessEditorFormularFeld_CheckboxListFormularFeld_Fragment,
  ProzessEditorFormularFeld_DateFormularFeld_Fragment,
  ProzessEditorFormularFeld_LocationFormularFeld_Fragment,
  ProzessEditorFormularFeld_SignatureFormularFeld_Fragment,
  ProzessEditorFormularFeld_StringFormularFeld_Fragment,
  ProzessEditorFormularFeld_TimeFormularFeld_Fragment,
  ProzessEditorFormularFeld_UploadFormularFeld_Fragment,
} from './prozess-editor-formular-feld.generated';
import {JsonPartFragment} from './json-fragments.generated';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {ProzessEditorVerbindungFragmentDoc} from './prozess-editor-verbindung.generated';
import {ProzessEditorFormularFeldFragmentDoc} from './prozess-editor-formular-feld.generated';
import {JsonPartFragmentDoc} from './json-fragments.generated';

export type ProzessEditorSchritt_BezahlenSchritt_Fragment = {
  __typename: 'BezahlenSchritt';
  betrag: number;
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  slots: Array<{
    __typename: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
};

export type ProzessEditorSchritt_EmailForwarderExportSchritt_Fragment = {
  __typename: 'EmailForwarderExportSchritt';
  emailAddress: StringExpression;
  subject: StringExpression;
  body: StringExpression;
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchritt_EndeSchritt_Fragment = {
  __typename: 'EndeSchritt';
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchritt_FormularSchritt_Fragment = {
  __typename: 'FormularSchritt';
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  felder: Array<
    | ({
        __typename?: 'AnzeigeTextBlockFeld';
      } & ProzessEditorFormularFeld_AnzeigeTextBlockFeld_Fragment)
    | ({
        __typename?: 'CheckboxListFormularFeld';
      } & ProzessEditorFormularFeld_CheckboxListFormularFeld_Fragment)
    | ({
        __typename?: 'DateFormularFeld';
      } & ProzessEditorFormularFeld_DateFormularFeld_Fragment)
    | ({
        __typename?: 'LocationFormularFeld';
      } & ProzessEditorFormularFeld_LocationFormularFeld_Fragment)
    | ({
        __typename?: 'SignatureFormularFeld';
      } & ProzessEditorFormularFeld_SignatureFormularFeld_Fragment)
    | ({
        __typename?: 'StringFormularFeld';
      } & ProzessEditorFormularFeld_StringFormularFeld_Fragment)
    | ({
        __typename?: 'TimeFormularFeld';
      } & ProzessEditorFormularFeld_TimeFormularFeld_Fragment)
    | ({
        __typename?: 'UploadFormularFeld';
      } & ProzessEditorFormularFeld_UploadFormularFeld_Fragment)
  >;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchritt_GovManagerRestExportSchritt_Fragment = {
  __typename: 'GovManagerRestExportSchritt';
  exportFilePartsAsPdf: boolean;
  vorgangsTyp: string;
  mandantenSchluessel: string;
  vorgangsSchluessel: string;
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  exportParts: Array<
    | {__typename: 'FilePart'; slotName: string}
    | ({__typename: 'JsonPart'} & JsonPartFragment)
  >;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchritt_NachrichtSchritt_Fragment = {
  __typename: 'NachrichtSchritt';
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchritt_ProgrammatischerSchritt_Fragment = {
  __typename: 'ProgrammatischerSchritt';
  implementationAssemblyQualifiedName: string;
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt_Fragment =
  {
    __typename: 'WarteAufBezahlungAbgeschlossenSchritt';
    bezahlenSchrittId: string;
    id: string;
    titel?: string | null;
    anweisung?: string | null;
    erledigungDurchBuerger: boolean;
    schreibtRolleId?: string | null;
    versendeEMailAnMitarbeiterGruppe?: boolean | null;
    sollZustaendigkeit: {
      __typename?: 'Zustaendigkeit';
      art: Types.ZustaendigkeitArt;
      organisationseinheitId?: string | null;
      mitarbeiterGruppeId?: string | null;
      dienstleisterId?: string | null;
      dynamischeArten: Array<Types.ZustaendigkeitArt>;
      liestRolleId?: string | null;
      mitarbeiterGruppe?: {
        __typename?: 'MitarbeiterGruppe';
        id: string;
        name: string;
        eMailAdressen: Array<string>;
      } | null;
      liestRolle?: {
        __typename?: 'ZustaendigkeitRolle';
        id: string;
        name: string;
      } | null;
    };
    schreibtRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
    verbindungen: Array<
      {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
    >;
    nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
    slots: Array<{
      __typename?: 'Slot';
      name: string;
      encrypted: boolean;
      valueType: Types.SlotValueType;
      optional: boolean;
      brauchtFreigabe: boolean;
    }>;
  };

export type ProzessEditorSchritt_WarteAufGovManagerSchritt_Fragment = {
  __typename: 'WarteAufGovManagerSchritt';
  govManagerSchrittId: string;
  id: string;
  titel?: string | null;
  anweisung?: string | null;
  erledigungDurchBuerger: boolean;
  schreibtRolleId?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  sollZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    organisationseinheitId?: string | null;
    mitarbeiterGruppeId?: string | null;
    dienstleisterId?: string | null;
    dynamischeArten: Array<Types.ZustaendigkeitArt>;
    liestRolleId?: string | null;
    mitarbeiterGruppe?: {
      __typename?: 'MitarbeiterGruppe';
      id: string;
      name: string;
      eMailAdressen: Array<string>;
    } | null;
    liestRolle?: {
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    } | null;
  };
  schreibtRolle?: {
    __typename?: 'ZustaendigkeitRolle';
    id: string;
    name: string;
  } | null;
  verbindungen: Array<
    {__typename?: 'Verbindung'} & ProzessEditorVerbindungFragment
  >;
  nodePosition?: {__typename?: 'NodePosition'; x: number; y: number} | null;
  slots: Array<{
    __typename?: 'Slot';
    name: string;
    encrypted: boolean;
    valueType: Types.SlotValueType;
    optional: boolean;
    brauchtFreigabe: boolean;
  }>;
};

export type ProzessEditorSchrittFragment =
  | ProzessEditorSchritt_BezahlenSchritt_Fragment
  | ProzessEditorSchritt_EmailForwarderExportSchritt_Fragment
  | ProzessEditorSchritt_EndeSchritt_Fragment
  | ProzessEditorSchritt_FormularSchritt_Fragment
  | ProzessEditorSchritt_GovManagerRestExportSchritt_Fragment
  | ProzessEditorSchritt_NachrichtSchritt_Fragment
  | ProzessEditorSchritt_ProgrammatischerSchritt_Fragment
  | ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt_Fragment
  | ProzessEditorSchritt_WarteAufGovManagerSchritt_Fragment;

export const ProzessEditorSchrittFragmentDoc = gql`
  fragment ProzessEditorSchritt on Schritt {
    __typename
    id
    titel
    anweisung
    erledigungDurchBuerger
    sollZustaendigkeit {
      art
      organisationseinheitId
      mitarbeiterGruppeId
      dienstleisterId
      mitarbeiterGruppe {
        id
        name
        eMailAdressen
      }
      dynamischeArten
      liestRolleId
      liestRolle {
        id
        name
      }
    }
    schreibtRolle {
      id
      name
    }
    schreibtRolleId
    versendeEMailAnMitarbeiterGruppe
    verbindungen {
      ...ProzessEditorVerbindung
    }
    nodePosition {
      x
      y
    }
    slots {
      name
      encrypted
      valueType
      optional
      brauchtFreigabe
    }
    ... on FormularSchritt {
      felder {
        ...ProzessEditorFormularFeld
      }
    }
    ... on BezahlenSchritt {
      betrag
      slots {
        __typename
        name
      }
    }
    ... on WarteAufBezahlungAbgeschlossenSchritt {
      bezahlenSchrittId
    }
    ... on GovManagerRestExportSchritt {
      exportFilePartsAsPdf
      exportParts {
        __typename
        ... on FilePart {
          slotName
        }
        ... on JsonPart {
          ...JsonPart
        }
      }
      vorgangsTyp
      mandantenSchluessel
      vorgangsSchluessel
    }
    ... on WarteAufGovManagerSchritt {
      govManagerSchrittId
    }
    ... on ProgrammatischerSchritt {
      implementationAssemblyQualifiedName
    }
    ... on EmailForwarderExportSchritt {
      emailAddress
      subject
      body
    }
  }
  ${ProzessEditorVerbindungFragmentDoc}
  ${ProzessEditorFormularFeldFragmentDoc}
  ${JsonPartFragmentDoc}
`;
