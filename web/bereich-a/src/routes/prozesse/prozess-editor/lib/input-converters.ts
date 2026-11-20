import {
  BoolExpression,
  type WithUnparsedExpressions,
} from '@kommunalapp/expressions';
import {type GovManagerRestExportSchritt} from '../components/form/govmanager-export-schritt.tsx';
import {type JsonValueWithSlotsFragment} from '../json-fragments.generated.ts';
import {
  type ProzessEditorFormularFeld_CheckboxListFormularFeld_Fragment,
  type ProzessEditorFormularFeld_StringFormularFeld_Fragment,
} from '../prozess-editor-formular-feld.generated.ts';
import {
  type CheckboxListFeldOptionInput,
  type CheckboxListFormularFeldInput,
  type FormularFeldInput,
  type FormularSchrittInput,
  type GovManagerRestExportSchrittInput,
  type JsonPartInput,
  type JsonValueWithSlotsInput,
  type PartInput,
  type ProzessEditorSchritt_FormularSchritt,
  type SchrittInput,
  type StringFormularFeldInput,
  type StringFormularFeldOptionInput,
  type VerbindungInput,
} from '../prozess-version-erstellen.generated.ts';
import type {
  GhostSchritt,
  SchrittDaten,
  VerbindungDaten,
} from './domain-types.ts';
import {supportsEmailNotification} from './email-benachrichtigung.ts';
import {projectByArt} from './soll-zustaendigkeit.ts';

/**
 * Wandelt eine Checkbox-Listen-Option in das entsprechende Input-Format um.
 * @param option Die Option des Checkbox-Listen-Feldes.
 * @param index Die Reihenfolge der Option.
 * @returns Die umgewandelte Option als Input.
 */
export const checkboxListOptionenZuInput = (
  option: ProzessEditorFormularFeld_CheckboxListFormularFeld_Fragment['options'][number],
  index: number,
): CheckboxListFeldOptionInput => {
  const {__typename, order, ...rest} = option;

  return {
    ...rest,
    order: index,
    key: rest.key,
    label: rest.label,
  };
};

/**
 * Wandelt eine String-Feld-Option in das entsprechende Input-Format um.
 * @param option Die Option des String-Feldes.
 * @returns Die umgewandelte Option als Input.
 */
export const stringFeldOptionenZuInput = (
  option: WithUnparsedExpressions<
    ProzessEditorFormularFeld_StringFormularFeld_Fragment['options'][number]
  >,
): StringFormularFeldOptionInput => {
  const {__typename, ...rest} = option;
  const istRelevant = rest.istRelevant as unknown as string | null | undefined;

  return {
    value: rest.value,
    key: rest.value,
    istRelevant: istRelevant ? new BoolExpression(istRelevant) : null,
  };
};

/**
 * Wandelt einen JSON-Wert mit Slots in das entsprechende Input-Format um.
 * @param jsonPart Der JSON-Wert mit Slots.
 * @returns Der umgewandelte JSON-Wert als Input.
 */
export const jsonZuInput = (
  jsonPart: JsonValueWithSlotsFragment,
): JsonValueWithSlotsInput => {
  const {__typename} = jsonPart;

  switch (__typename) {
    case 'JsonStringValue':
      return {jsonStringValueInput: {value: jsonPart.value}};
    case 'JsonSlotValue':
      return {jsonSlotValueInput: {slotName: jsonPart.slotName}};
    case 'JsonObject':
      return {
        jsonObjectInput: {
          fields: jsonPart.fields.map(({name, value}) => ({
            name,
            value: jsonZuInput(value as JsonValueWithSlotsFragment),
          })),
        },
      };
  }
};

/**
 * Wandelt einen Export-Teil des GovManager-Schritts in das entsprechende Input-Format um.
 * @param part Der Export-Teil.
 * @returns Der umgewandelte Export-Teil als Input.
 */
export const partZuInput = (
  part: GovManagerRestExportSchritt['exportParts'][number],
): PartInput => {
  const {__typename, ...rest} = part;

  const targetKey = ((): keyof PartInput => {
    switch (__typename) {
      case 'FilePart':
        return 'filePartInput';
      case 'JsonPart':
        return 'jsonPartInput';
    }
  })();

  if (__typename === 'JsonPart') {
    const jsonInput = rest as unknown as JsonPartInput;
    jsonInput.value = jsonZuInput(part.value);
  }

  return {[targetKey]: rest} as unknown as PartInput;
};

/**
 * Wandelt ein Formularfeld in das entsprechende Input-Format um.
 * @param feld Das Formularfeld mit unparsierten Ausdrücken.
 * @param index Die Reihenfolge des Feldes.
 * @returns Das umgewandelte Formularfeld als Input.
 */
export const feldZuInput = (
  feld: WithUnparsedExpressions<
    ProzessEditorSchritt_FormularSchritt['felder'][number]
  >,
  index: number,
): FormularFeldInput => {
  const {__typename, ...rest} = feld;

  const targetKey = ((): keyof FormularFeldInput => {
    switch (__typename) {
      case 'CheckboxListFormularFeld':
        return 'checkboxListFormularFeldInput';
      case 'DateFormularFeld':
        return 'dateFormularFeldInput';
      case 'TimeFormularFeld':
        return 'timeFormularFeldInput';
      case 'LocationFormularFeld':
        return 'locationFormularFeldInput';
      case 'StringFormularFeld':
        return 'stringFormularFeldInput';
      case 'UploadFormularFeld':
        return 'uploadFormularFeldInput';
      case 'SignatureFormularFeld':
        return 'signatureFormularFeldInput';
      case 'AnzeigeTextBlockFeld':
        return 'anzeigeTextBlockFormularFeldInput';
    }
  })();

  const input = rest as unknown as FormularFeldInput[keyof FormularFeldInput];
  input!.order = index;

  if (__typename === 'CheckboxListFormularFeld') {
    const checkboxFeld = input as CheckboxListFormularFeldInput;
    checkboxFeld.options = feld.options.map((option, index) =>
      checkboxListOptionenZuInput(option, index),
    );
  } else if (__typename === 'StringFormularFeld') {
    const stringFeld = input as StringFormularFeldInput;
    stringFeld.options = feld.options.map(stringFeldOptionenZuInput);
  }

  return {[targetKey]: rest} as unknown as FormularFeldInput;
};

/**
 * Wandelt einen Prozess-Schritt in das entsprechende Input-Format um.
 * @param schritt Der Prozess-Schritt ohne GhostSchritt.
 * @returns Der umgewandelte Schritt als Input.
 */
export const schrittZuInput = (
  schritt: Exclude<SchrittDaten, GhostSchritt>,
): SchrittInput => {
  const {
    __typename,
    erledigungDurchBuerger,
    verbindungen,
    schreibtRolle,
    sollZustaendigkeit: {__typename: _, ...zustaendigkeit},
    slots,
    nodePosition,
    ...rest
  } = schritt;

  const targetKey = ((): keyof SchrittInput => {
    switch (__typename) {
      case 'BezahlenSchritt':
        return 'bezahlenSchrittInput';
      case 'WarteAufBezahlungAbgeschlossenSchritt':
        return 'warteAufBezahlungAbgeschlossenSchrittInput';
      case 'FormularSchritt':
        return 'formularSchrittInput';
      case 'ProgrammatischerSchritt':
        return 'programmatischerSchrittInput';
      case 'EndeSchritt':
        return 'endeSchrittInput';
      case 'EmailForwarderExportSchritt':
        return 'emailForwardSchrittInput';
      case 'GovManagerRestExportSchritt':
        return 'govManagerRestExportSchrittInput';
      case 'WarteAufGovManagerSchritt':
        return 'warteAufGovManagerSchrittInput';
      case 'NachrichtSchritt':
        return 'nachrichtSchrittInput';
    }
  })();
  const {versendeEMailAnMitarbeiterGruppe, ...sollZustaendigkeit} =
    projectByArt(zustaendigkeit, zustaendigkeit.art);

  const input: SchrittInput[keyof SchrittInput] = {
    ...rest,
    nodePosition: nodePosition
      ? {x: nodePosition.x, y: nodePosition.y}
      : undefined,
    sollZustaendigkeit,
    // The checkbox disappears when the Abteilung is removed, but the flag keeps its value until here.
    versendeEMailAnMitarbeiterGruppe:
      supportsEmailNotification(sollZustaendigkeit) &&
      versendeEMailAnMitarbeiterGruppe,
  };

  if (__typename === 'FormularSchritt') {
    const formularInput = input as FormularSchrittInput;
    formularInput.felder = schritt.felder.map((feld, index) =>
      feldZuInput(feld, index),
    );
  }

  if (__typename === 'GovManagerRestExportSchritt') {
    const exportSchrittInput = input as GovManagerRestExportSchrittInput;
    exportSchrittInput.exportParts = schritt.exportParts.map(partZuInput);
  }

  return {[targetKey]: input} as unknown as SchrittInput;
};

/**
 * Wandelt eine Verbindung in das entsprechende Input-Format um.
 * @param verbindung Die Verbindungsdaten.
 * @returns Die umgewandelte Verbindung als Input.
 */
export const verbindungZuInput = (
  verbindung: VerbindungDaten,
): VerbindungInput => {
  const {__typename, istRelevant, ...rest} = verbindung;

  return {
    ...rest,
    istRelevant: new BoolExpression(istRelevant),
  };
};
