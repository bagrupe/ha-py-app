import * as Types from '../../../__generated__/graphql';

import {
  SlotValue_EncryptedSlotValue_Fragment,
  SlotValue_PlainSlotValue_Fragment,
} from '../../../components/ui/slot-value/slot-value.generated';
import {
  BoolExpression,
  IntExpression,
  StringExpression,
} from '@kommunalapp/expressions';

import gql from 'graphql-tag';
import {SlotValueFragmentDoc} from '../../../components/ui/slot-value/slot-value.generated';
import * as Urql from 'urql';
export type Omit<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>>;
export type AusfuehrungBearbeitungInput = {
  nextVerbindungId: string;
  schrittId: string;
  slotValues: Array<SlotValuesInput>;
};

export type AusfuehrungContinueInput = {
  ausfuehrungId: string;
  bearbeitungen: Array<AusfuehrungBearbeitungInput>;
  naechsteIstZustaendigkeit?: SchrittSollZustaendigkeitInput | null;
};

export type EncryptedValueInput = {
  cipher: string;
  nonce: string;
  tag: string;
};

export type SchrittSollZustaendigkeitInput = {
  art: Types.ZustaendigkeitArt;
  dienstleisterId?: string | null;
  dynamischeArten?: Array<Types.ZustaendigkeitArt> | null;
  liestRolleId?: string | null;
  mitarbeiterGruppeId?: string | null;
  organisationseinheitId?: string | null;
};

export type SlotValuesInput = {
  name: string;
  value: SlotValuesValueInput;
};

export type SlotValuesValueInput =
  | {encryptedValue: EncryptedValueInput; plainValue?: never}
  | {encryptedValue?: never; plainValue: unknown};

export type UpdateIstFreigegebenSlotValueInput = {
  ausfuehrungId: string;
  istFreigegeben: boolean;
  slotValueId: string;
};

export type AusfuehrungQueryVariables = Types.Exact<{
  ausfuehrungId: string;
}>;

export type AusfuehrungQuery = {
  __typename?: 'Query';
  ausfuehrung: AntragDetailAusfuehrung;
};

export type AntragDetailAusfuehrung = {
  __typename?: 'Ausfuehrung';
  id: string;
  sharedKeyEncryptedForKommune: string;
  createdAt: Date;
  updatedAt: Date;
  status: Types.AusfuehrungStatus;
  manuellAbgeschlossen?: Date | null;
  nachrichtMaxLength: number;
  verlauf: Array<{
    __typename?: 'Historie';
    id: string;
    createdAt: Date;
    statusAenderung?: string | null;
    statusAenderungBeschreibung?: string | null;
    benutzer?: string | null;
    ziel?: string | null;
    nachricht?: string | null;
  }>;
  istZustaendigkeit: {
    __typename?: 'Zustaendigkeit';
    art: Types.ZustaendigkeitArt;
    zugewiesenePersonId?: string | null;
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
      isDeleted: boolean;
    } | null;
    zugewiesenePerson?: {
      __typename?: 'BackofficeUser';
      id: string;
      vorname: string;
      nachname: string;
      isDeleted: boolean;
    } | null;
  };
  bearbeitungen: Array<{
    __typename?: 'Bearbeitung';
    schritt: AntragDetailSchritt;
    createdAt: Date;
    user:
      | {__typename?: 'BackofficeUser'; vorname: string; nachname: string}
      | {__typename?: 'Buerger'}
      | {__typename?: 'SystemUser'};
  }>;
  prozessVersion: {
    __typename?: 'ProzessVersion';
    id: string;
    prozess: {
      __typename?: 'Prozess';
      id: string;
      name: string;
      tags: Array<{__typename?: 'ProzessTag'; tag: string}>;
    };
  };
  slotValues: Array<
    | ({
        __typename?: 'EncryptedSlotValue';
      } & SlotValue_EncryptedSlotValue_Fragment)
    | ({__typename?: 'PlainSlotValue'} & SlotValue_PlainSlotValue_Fragment)
  >;
  currentSchritt:
    | {
        __typename?: 'BezahlenSchritt';
        id: string;
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        felder: Array<
          | ({
              __typename?: 'AnzeigeTextBlockFeld';
            } & FormularSchrittFeld_AnzeigeTextBlockFeld_Fragment)
          | ({
              __typename?: 'CheckboxListFormularFeld';
            } & FormularSchrittFeld_CheckboxListFormularFeld_Fragment)
          | ({
              __typename?: 'DateFormularFeld';
            } & FormularSchrittFeld_DateFormularFeld_Fragment)
          | ({
              __typename?: 'LocationFormularFeld';
            } & FormularSchrittFeld_LocationFormularFeld_Fragment)
          | ({
              __typename?: 'SignatureFormularFeld';
            } & FormularSchrittFeld_SignatureFormularFeld_Fragment)
          | ({
              __typename?: 'StringFormularFeld';
            } & FormularSchrittFeld_StringFormularFeld_Fragment)
          | ({
              __typename?: 'TimeFormularFeld';
            } & FormularSchrittFeld_TimeFormularFeld_Fragment)
          | ({
              __typename?: 'UploadFormularFeld';
            } & FormularSchrittFeld_UploadFormularFeld_Fragment)
        >;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      }
    | {
        __typename?: 'NachrichtSchritt';
        nachrichtMaxLength: number;
        id: string;
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
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
        titel?: string | null;
        erledigungDurchBuerger: boolean;
        verbindungen: Array<{
          __typename?: 'Verbindung';
          id: string;
          name?: string | null;
          nachId: string;
          istRelevant: BoolExpression;
          nach:
            | {
                __typename?: 'BezahlenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EmailForwarderExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'EndeSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'FormularSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'GovManagerRestExportSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'NachrichtSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'ProgrammatischerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufBezahlungAbgeschlossenSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              }
            | {
                __typename?: 'WarteAufGovManagerSchritt';
                sollZustaendigkeit: {
                  __typename?: 'Zustaendigkeit';
                  art: Types.ZustaendigkeitArt;
                  liestRolleId?: string | null;
                  dynamischeArten: Array<Types.ZustaendigkeitArt>;
                };
              };
        }>;
        sollZustaendigkeit: {
          __typename?: 'Zustaendigkeit';
          mitarbeiterGruppeId?: string | null;
          mitarbeiterGruppe?: {
            __typename?: 'MitarbeiterGruppe';
            id: string;
            name: string;
          } | null;
        };
      };
};

export type AntragDetailSchritt =
  | AntragDetailSchritt_BezahlenSchritt
  | AntragDetailSchritt_EmailForwarderExportSchritt
  | AntragDetailSchritt_EndeSchritt
  | AntragDetailSchritt_FormularSchritt
  | AntragDetailSchritt_GovManagerRestExportSchritt
  | AntragDetailSchritt_NachrichtSchritt
  | AntragDetailSchritt_ProgrammatischerSchritt
  | AntragDetailSchritt_WarteAufBezahlungAbgeschlossenSchritt
  | AntragDetailSchritt_WarteAufGovManagerSchritt;

export type AntragDetailSchritt_BezahlenSchritt = {
  __typename: 'BezahlenSchritt';
  betrag: number;
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_EmailForwarderExportSchritt = {
  __typename: 'EmailForwarderExportSchritt';
  body: StringExpression;
  subject: StringExpression;
  id: string;
  emailAddress: StringExpression;
  titel?: string | null;
  erledigungDurchBuerger: boolean;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_EndeSchritt = {
  __typename: 'EndeSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_FormularSchritt = {
  __typename: 'FormularSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  felder: Array<
    | ({
        __typename?: 'AnzeigeTextBlockFeld';
      } & FormularSchrittFeld_AnzeigeTextBlockFeld_Fragment)
    | ({
        __typename?: 'CheckboxListFormularFeld';
      } & FormularSchrittFeld_CheckboxListFormularFeld_Fragment)
    | ({
        __typename?: 'DateFormularFeld';
      } & FormularSchrittFeld_DateFormularFeld_Fragment)
    | ({
        __typename?: 'LocationFormularFeld';
      } & FormularSchrittFeld_LocationFormularFeld_Fragment)
    | ({
        __typename?: 'SignatureFormularFeld';
      } & FormularSchrittFeld_SignatureFormularFeld_Fragment)
    | ({
        __typename?: 'StringFormularFeld';
      } & FormularSchrittFeld_StringFormularFeld_Fragment)
    | ({
        __typename?: 'TimeFormularFeld';
      } & FormularSchrittFeld_TimeFormularFeld_Fragment)
    | ({
        __typename?: 'UploadFormularFeld';
      } & FormularSchrittFeld_UploadFormularFeld_Fragment)
  >;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_GovManagerRestExportSchritt = {
  __typename: 'GovManagerRestExportSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_NachrichtSchritt = {
  __typename: 'NachrichtSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_ProgrammatischerSchritt = {
  __typename: 'ProgrammatischerSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_WarteAufBezahlungAbgeschlossenSchritt = {
  __typename: 'WarteAufBezahlungAbgeschlossenSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type AntragDetailSchritt_WarteAufGovManagerSchritt = {
  __typename: 'WarteAufGovManagerSchritt';
  id: string;
  erledigungDurchBuerger: boolean;
  titel?: string | null;
  slots: Array<{__typename?: 'Slot'} & SlotFragment>;
};

export type SlotFragment = {
  __typename?: 'Slot';
  name: string;
  brauchtFreigabe: boolean;
  optional: boolean;
};

export type UpdateIstFreigegebenSlotValueMutationVariables = Types.Exact<{
  input: UpdateIstFreigegebenSlotValueInput;
}>;

export type UpdateIstFreigegebenSlotValueMutation = {
  __typename?: 'Mutation';
  updateIstFreigegebenSlotValue: {
    __typename?: 'UpdateIstFreigegebenSlotValuePayload';
    ausfuehrung?: {__typename?: 'Ausfuehrung'; id: string} | null;
  };
};

export type AusfuehrungContinueMutationVariables = Types.Exact<{
  input: AusfuehrungContinueInput;
}>;

export type AusfuehrungContinueMutation = {
  __typename?: 'Mutation';
  ausfuehrungContinue: {
    __typename?: 'AusfuehrungContinuePayload';
    ausfuehrungResult?: {
      __typename?: 'AusfuehrungResult';
      ausfuehrung: {__typename?: 'Ausfuehrung'; id: string};
    } | null;
  };
};

export type AusfuehrungUpdateZugewiesenePersonMutationVariables = Types.Exact<{
  ausfuehrungId: string;
  userId: string;
}>;

export type AusfuehrungUpdateZugewiesenePersonMutation = {
  __typename?: 'Mutation';
  ausfuehrungUpdateZugewiesenePerson: {
    __typename?: 'AusfuehrungUpdateZugewiesenePersonPayload';
    ausfuehrung?: {__typename?: 'Ausfuehrung'; id: string} | null;
  };
};

export type FormularSchrittFeld_AnzeigeTextBlockFeld_Fragment = {
  __typename: 'AnzeigeTextBlockFeld';
  text: string;
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
};

export type FormularSchrittFeld_CheckboxListFormularFeld_Fragment = {
  __typename: 'CheckboxListFormularFeld';
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
  options: Array<{
    __typename?: 'CheckboxListFeldOption';
    key: string;
    label: string;
  }>;
};

export type FormularSchrittFeld_DateFormularFeld_Fragment = {
  __typename: 'DateFormularFeld';
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
};

export type FormularSchrittFeld_LocationFormularFeld_Fragment = {
  __typename: 'LocationFormularFeld';
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
};

export type FormularSchrittFeld_SignatureFormularFeld_Fragment = {
  __typename: 'SignatureFormularFeld';
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
};

export type FormularSchrittFeld_StringFormularFeld_Fragment = {
  __typename: 'StringFormularFeld';
  multiline: boolean;
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
  options: Array<{
    __typename?: 'StringFormularFeldOption';
    key: string;
    value: string;
  }>;
};

export type FormularSchrittFeld_TimeFormularFeld_Fragment = {
  __typename: 'TimeFormularFeld';
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
};

export type FormularSchrittFeld_UploadFormularFeld_Fragment = {
  __typename: 'UploadFormularFeld';
  id: string;
  angezeigterName?: string | null;
  anweisung?: string | null;
  slotName: string;
  pflichtfeld: boolean;
  istRelevant: BoolExpression;
};

export type FormularSchrittFeldFragment =
  | FormularSchrittFeld_AnzeigeTextBlockFeld_Fragment
  | FormularSchrittFeld_CheckboxListFormularFeld_Fragment
  | FormularSchrittFeld_DateFormularFeld_Fragment
  | FormularSchrittFeld_LocationFormularFeld_Fragment
  | FormularSchrittFeld_SignatureFormularFeld_Fragment
  | FormularSchrittFeld_StringFormularFeld_Fragment
  | FormularSchrittFeld_TimeFormularFeld_Fragment
  | FormularSchrittFeld_UploadFormularFeld_Fragment;

export const SlotFragmentDoc = gql`
  fragment Slot on Slot {
    name
    brauchtFreigabe
    optional
  }
`;
export const FormularSchrittFeldFragmentDoc = gql`
  fragment FormularSchrittFeld on FormularFeld {
    __typename
    id
    angezeigterName
    anweisung
    slotName
    pflichtfeld
    istRelevant
    ... on StringFormularFeld {
      multiline
      options {
        key
        value
      }
    }
    ... on CheckboxListFormularFeld {
      options {
        key
        label
      }
    }
    ... on AnzeigeTextBlockFeld {
      text
    }
  }
`;
export const AusfuehrungDocument = gql`
  query Ausfuehrung($ausfuehrungId: UUID!) {
    ausfuehrung(id: $ausfuehrungId)
      @export(exportName: "AntragDetailAusfuehrung") {
      id
      sharedKeyEncryptedForKommune
      createdAt
      updatedAt
      status
      manuellAbgeschlossen
      nachrichtMaxLength
      verlauf {
        id
        createdAt
        statusAenderung
        statusAenderungBeschreibung
        benutzer
        ziel
        nachricht
      }
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
          isDeleted
        }
        zugewiesenePersonId
        zugewiesenePerson {
          id
          vorname
          nachname
          isDeleted
        }
      }
      bearbeitungen {
        user {
          ... on Mitarbeiter {
            vorname
            nachname
          }
        }
        createdAt
        schritt @export(exportName: "AntragDetailSchritt") {
          __typename
          id
          erledigungDurchBuerger
          titel
          ... on FormularSchritt {
            felder {
              ...FormularSchrittFeld
            }
          }
          slots {
            ...Slot
          }
          ... on BezahlenSchritt {
            betrag
          }
          ... on EmailForwarderExportSchritt {
            body
            subject
            id
            emailAddress
            titel
          }
        }
      }
      prozessVersion {
        id
        prozess {
          id
          name
          tags {
            tag
          }
        }
      }
      slotValues {
        ...SlotValue
      }
      currentSchritt {
        id
        titel
        erledigungDurchBuerger
        ... on FormularSchritt {
          felder {
            ...FormularSchrittFeld
          }
        }
        ... on NachrichtSchritt {
          nachrichtMaxLength
        }
        verbindungen {
          id
          name
          nachId
          istRelevant
          nach {
            sollZustaendigkeit {
              art
              liestRolleId
              dynamischeArten
            }
          }
        }
        sollZustaendigkeit {
          mitarbeiterGruppeId
          mitarbeiterGruppe {
            id
            name
          }
        }
      }
    }
  }
  ${FormularSchrittFeldFragmentDoc}
  ${SlotFragmentDoc}
  ${SlotValueFragmentDoc}
`;

export function useAusfuehrungQuery(
  options: Omit<Urql.UseQueryArgs<AusfuehrungQueryVariables>, 'query'>,
) {
  return Urql.useQuery<AusfuehrungQuery, AusfuehrungQueryVariables>({
    query: AusfuehrungDocument,
    ...options,
  });
}
export const UpdateIstFreigegebenSlotValueDocument = gql`
  mutation UpdateIstFreigegebenSlotValue(
    $input: UpdateIstFreigegebenSlotValueInput!
  ) {
    updateIstFreigegebenSlotValue(input: $input) {
      ausfuehrung {
        id
      }
    }
  }
`;

export function useUpdateIstFreigegebenSlotValueMutation() {
  return Urql.useMutation<
    UpdateIstFreigegebenSlotValueMutation,
    UpdateIstFreigegebenSlotValueMutationVariables
  >(UpdateIstFreigegebenSlotValueDocument);
}
export const AusfuehrungContinueDocument = gql`
  mutation AusfuehrungContinue($input: AusfuehrungContinueInput!) {
    ausfuehrungContinue(input: $input) {
      ausfuehrungResult {
        ausfuehrung {
          id
        }
      }
    }
  }
`;

export function useAusfuehrungContinueMutation() {
  return Urql.useMutation<
    AusfuehrungContinueMutation,
    AusfuehrungContinueMutationVariables
  >(AusfuehrungContinueDocument);
}
export const AusfuehrungUpdateZugewiesenePersonDocument = gql`
  mutation AusfuehrungUpdateZugewiesenePerson(
    $ausfuehrungId: UUID!
    $userId: UUID!
  ) {
    ausfuehrungUpdateZugewiesenePerson(
      input: {ausfuehrungId: $ausfuehrungId, userId: $userId}
    ) {
      ausfuehrung {
        id
      }
    }
  }
`;

export function useAusfuehrungUpdateZugewiesenePersonMutation() {
  return Urql.useMutation<
    AusfuehrungUpdateZugewiesenePersonMutation,
    AusfuehrungUpdateZugewiesenePersonMutationVariables
  >(AusfuehrungUpdateZugewiesenePersonDocument);
}
