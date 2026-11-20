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
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {ProzessEditorSchrittFragmentDoc} from './prozess-editor-schritt.generated';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AnzeigeTextBlockFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  oeffentlichSichtbar?: boolean;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
  text: string;
};

export type BezahlenSchrittInput = {
  anweisung?: string | null;
  betrag: number;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type CheckboxListFeldOptionInput = {
  defaultChecked: boolean;
  key: string;
  label: string;
  order: number;
};

export type CheckboxListFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  oeffentlichSichtbar?: boolean;
  options: Array<CheckboxListFeldOptionInput>;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type DateFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  oeffentlichSichtbar?: boolean;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type EmailForwarderSchrittInput = {
  anweisung?: string | null;
  body: StringExpression;
  emailAddress: StringExpression;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  subject: StringExpression;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type EndeSchrittInput = {
  anweisung?: string | null;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type FilePartInput = {
  slotName: string;
};

export type FormularFeldInput =
  | {
      anzeigeTextBlockFormularFeldInput: AnzeigeTextBlockFormularFeldInput;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput?: never;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput?: never;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput: CheckboxListFormularFeldInput;
      dateFormularFeldInput?: never;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput?: never;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput: DateFormularFeldInput;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput?: never;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput?: never;
      locationFormularFeldInput: LocationFormularFeldInput;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput?: never;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput?: never;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput: SignatureFormularFeldInput;
      stringFormularFeldInput?: never;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput?: never;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput: StringFormularFeldInput;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput?: never;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput?: never;
      timeFormularFeldInput: TimeFormularFeldInput;
      uploadFormularFeldInput?: never;
    }
  | {
      anzeigeTextBlockFormularFeldInput?: never;
      checkboxListFormularFeldInput?: never;
      dateFormularFeldInput?: never;
      locationFormularFeldInput?: never;
      signatureFormularFeldInput?: never;
      stringFormularFeldInput?: never;
      timeFormularFeldInput?: never;
      uploadFormularFeldInput: UploadFormularFeldInput;
    };

export type FormularSchrittInput = {
  anweisung?: string | null;
  felder: Array<FormularFeldInput>;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type GovManagerRestExportSchrittInput = {
  anweisung?: string | null;
  exportFilePartsAsPdf: boolean;
  exportParts: Array<PartInput>;
  id: string;
  mandantenSchluessel: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
  vorgangsSchluessel: string;
  vorgangsTyp: string;
};

export type JsonFieldInput = {
  name: string;
  value: JsonValueWithSlotsInput;
};

export type JsonObjectInput = {
  fields: Array<JsonFieldInput>;
};

export type JsonPartInput = {
  value: JsonValueWithSlotsInput;
};

export type JsonSlotValueInput = {
  slotName: string;
};

export type JsonStringValueInput = {
  value: string;
};

export type JsonValueWithSlotsInput =
  | {
      jsonObjectInput: JsonObjectInput;
      jsonSlotValueInput?: never;
      jsonStringValueInput?: never;
    }
  | {
      jsonObjectInput?: never;
      jsonSlotValueInput: JsonSlotValueInput;
      jsonStringValueInput?: never;
    }
  | {
      jsonObjectInput?: never;
      jsonSlotValueInput?: never;
      jsonStringValueInput: JsonStringValueInput;
    };

export type LocationFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  oeffentlichSichtbar?: boolean;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type NachrichtSchrittInput = {
  anweisung?: string | null;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type NodePositionInput = {
  x: number;
  y: number;
};

export type PartInput =
  | {filePartInput: FilePartInput; jsonPartInput?: never}
  | {filePartInput?: never; jsonPartInput: JsonPartInput};

export type ProgrammatischerSchrittInput = {
  anweisung?: string | null;
  id: string;
  implementationAssemblyQualifiedName: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type ProzessVersionErstellenInput = {
  prozessId: string;
  schritte: Array<SchrittInput>;
  verbindungen: Array<VerbindungInput>;
  veroeffentlichen: boolean;
  zustaendigkeitRollen: Array<ZustaendigkeitRolleInput>;
};

export type SchrittInput =
  | {
      bezahlenSchrittInput: BezahlenSchrittInput;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput: EmailForwarderSchrittInput;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput: EndeSchrittInput;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput: FormularSchrittInput;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput: GovManagerRestExportSchrittInput;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput: NachrichtSchrittInput;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput: ProgrammatischerSchrittInput;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput: WarteAufBezahlungAbgeschlossenSchrittInput;
      warteAufGovManagerSchrittInput?: never;
    }
  | {
      bezahlenSchrittInput?: never;
      emailForwardSchrittInput?: never;
      endeSchrittInput?: never;
      formularSchrittInput?: never;
      govManagerRestExportSchrittInput?: never;
      nachrichtSchrittInput?: never;
      programmatischerSchrittInput?: never;
      warteAufBezahlungAbgeschlossenSchrittInput?: never;
      warteAufGovManagerSchrittInput: WarteAufGovManagerSchrittInput;
    };

export type SchrittSollZustaendigkeitInput = {
  art: Types.ZustaendigkeitArt;
  dienstleisterId?: string | null;
  dynamischeArten?: Array<Types.ZustaendigkeitArt> | null;
  liestRolleId?: string | null;
  mitarbeiterGruppeId?: string | null;
  organisationseinheitId?: string | null;
};

export type SignatureFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  oeffentlichSichtbar?: boolean;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type StringFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  durchsuchbar?: boolean;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  multiline: boolean;
  oeffentlichSichtbar?: boolean;
  options?: Array<StringFormularFeldOptionInput> | null;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type StringFormularFeldOptionInput = {
  /** Optionaler Ausdruck für diese einzelne Option (zusätzlich zur Relevanz des gesamten Feldes): ist er gesetzt und ergibt false, ist genau diese Option nicht wählbar, auch wenn das Feld selbst relevant ist und andere Optionen weiterhin zur Auswahl stehen. */
  istRelevant?: BoolExpression | null;
  key: string;
  value: string;
};

export type TimeFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  oeffentlichSichtbar?: boolean;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type UploadFormularFeldInput = {
  angezeigterName?: string | null;
  anweisung?: string | null;
  brauchtFreigabe: boolean;
  document: boolean;
  encrypted: boolean;
  id: string;
  inhaltsTag?: string | null;
  istRelevant: BoolExpression;
  multi: boolean;
  oeffentlichSichtbar?: boolean;
  order: number;
  pflichtfeld: boolean;
  slotName: string;
};

export type VerbindungInput = {
  id: string;
  istRelevant: BoolExpression;
  nachId: string;
  name?: string | null;
  statusAenderung?: string | null;
  statusAenderungBeschreibung?: string | null;
  vonId: string;
};

export type WarteAufBezahlungAbgeschlossenSchrittInput = {
  anweisung?: string | null;
  bezahlenSchrittId: string;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type WarteAufGovManagerSchrittInput = {
  anweisung?: string | null;
  govManagerSchrittId: string;
  id: string;
  nodePosition?: NodePositionInput | null;
  schreibtRolleId?: string | null;
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
  titel?: string | null;
  versendeEMailAnMitarbeiterGruppe?: boolean | null;
};

export type ZustaendigkeitRolleInput = {
  id: string;
  name: string;
};

export type NeueProzessVersionErstellenMutationVariables = Types.Exact<{
  input: ProzessVersionErstellenInput;
}>;

export type NeueProzessVersionErstellenMutation = {
  __typename?: 'Mutation';
  prozessVersionErstellen: {
    __typename?: 'ProzessVersionErstellenPayload';
    prozess?: ({__typename?: 'Prozess'} & ProzessEditorProzessFragment) | null;
  };
};

export type ProzessEditorProzessFragment = {
  __typename?: 'Prozess';
  id: string;
  name: string;
  istOeffentlich: boolean;
  tags: Array<{__typename?: 'ProzessTag'; id: string}>;
  latestVersion?: {
    __typename?: 'ProzessVersion';
    alleSchritte: Array<ProzessEditorSchritt>;
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
    rollen: Array<{
      __typename?: 'ZustaendigkeitRolle';
      id: string;
      name: string;
    }>;
  } | null;
};

export type ProzessEditorSchritt =
  | ProzessEditorSchritt_BezahlenSchritt
  | ProzessEditorSchritt_EmailForwarderExportSchritt
  | ProzessEditorSchritt_EndeSchritt
  | ProzessEditorSchritt_FormularSchritt
  | ProzessEditorSchritt_GovManagerRestExportSchritt
  | ProzessEditorSchritt_NachrichtSchritt
  | ProzessEditorSchritt_ProgrammatischerSchritt
  | ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt
  | ProzessEditorSchritt_WarteAufGovManagerSchritt;

export type ProzessEditorSchritt_BezahlenSchritt = {
  __typename?: 'BezahlenSchritt';
} & ProzessEditorSchritt_BezahlenSchritt_Fragment;

export type ProzessEditorSchritt_EmailForwarderExportSchritt = {
  __typename?: 'EmailForwarderExportSchritt';
} & ProzessEditorSchritt_EmailForwarderExportSchritt_Fragment;

export type ProzessEditorSchritt_EndeSchritt = {
  __typename?: 'EndeSchritt';
} & ProzessEditorSchritt_EndeSchritt_Fragment;

export type ProzessEditorSchritt_FormularSchritt = {
  __typename?: 'FormularSchritt';
} & ProzessEditorSchritt_FormularSchritt_Fragment;

export type ProzessEditorSchritt_GovManagerRestExportSchritt = {
  __typename?: 'GovManagerRestExportSchritt';
} & ProzessEditorSchritt_GovManagerRestExportSchritt_Fragment;

export type ProzessEditorSchritt_NachrichtSchritt = {
  __typename?: 'NachrichtSchritt';
} & ProzessEditorSchritt_NachrichtSchritt_Fragment;

export type ProzessEditorSchritt_ProgrammatischerSchritt = {
  __typename?: 'ProgrammatischerSchritt';
} & ProzessEditorSchritt_ProgrammatischerSchritt_Fragment;

export type ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt = {
  __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
} & ProzessEditorSchritt_WarteAufBezahlungAbgeschlossenSchritt_Fragment;

export type ProzessEditorSchritt_WarteAufGovManagerSchritt = {
  __typename?: 'WarteAufGovManagerSchritt';
} & ProzessEditorSchritt_WarteAufGovManagerSchritt_Fragment;

export const ProzessEditorProzessFragmentDoc = gql`
  fragment ProzessEditorProzess on Prozess {
    id
    name
    istOeffentlich
    tags {
      id
    }
    latestVersion {
      id
      publishedAt
      start {
        id
      }
      rollen {
        id
        name
      }
      alleSchritte @export(exportName: "ProzessEditorSchritt") {
        ...ProzessEditorSchritt
      }
    }
  }
  ${ProzessEditorSchrittFragmentDoc}
`;
export const NeueProzessVersionErstellenDocument = gql`
  mutation NeueProzessVersionErstellen($input: ProzessVersionErstellenInput!) {
    prozessVersionErstellen(input: $input) {
      prozess {
        ...ProzessEditorProzess
      }
    }
  }
  ${ProzessEditorProzessFragmentDoc}
`;

export function useNeueProzessVersionErstellenMutation() {
  return Urql.useMutation<
    NeueProzessVersionErstellenMutation,
    NeueProzessVersionErstellenMutationVariables
  >(NeueProzessVersionErstellenDocument);
}
