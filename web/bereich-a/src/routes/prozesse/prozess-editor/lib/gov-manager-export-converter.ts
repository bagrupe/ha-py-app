import {SlotValueType} from '../../../../__generated__/graphql.ts';
import {
  type GovManagerRestExportSchritt,
  type JsonSlotFormFieldProps,
  type JsonStringFormFieldProps,
} from '../components/form/govmanager-export-schritt.tsx';
import {
  type JsonFieldFragment,
  type JsonPartFragment,
  type JsonValueWithSlots_JsonObject_Fragment,
  type JsonValueWithSlotsFragment,
  type JsonValueWithSlotsRecursive_JsonObject_Fragment,
  type JsonValueWithSlotsRecursiveFragment,
} from '../json-fragments.generated.ts';

/**
 * Typ für einen Slot mit Eigenschaften wie Name, Verschlüsselung, Werttyp und Optionalität.
 */
type SlotType = {
  __typename?: 'Slot' | 'String' | undefined;
  name: string;
  encrypted: boolean;
  valueType: SlotValueType;
  optional: boolean;
};

/**
 * Typ für die möglichen JSON-Werttypen, ausgenommen JsonObject.
 */
type JsonValueTypes = Exclude<
  JsonValueWithSlotsFragment,
  JsonValueWithSlots_JsonObject_Fragment
>['__typename'];

/**
 * Wandelt Pfad-Strings und Slot-Informationen in eine Struktur von Export-Teilen um.
 * @param allProcessSlots Alle Slots des Prozesses.
 * @param nextExportParts Mapping von Slotnamen zu Export-Feldeigenschaften.
 * @param nextStringExportParts Liste von String-Feldern für den Export.
 * @returns Array von Export-Teilen, die die Struktur der Exportdaten repräsentieren.
 */
export const dotPathToExportParts = (
  allProcessSlots: SlotType[],
  nextExportParts: Record<
    string,
    JsonSlotFormFieldProps | JsonSlotFormFieldProps
  >,
  nextStringExportParts: JsonStringFormFieldProps[],
) => {
  const exportsParts = [];
  const jsonPart: JsonPartFragment = {
    __typename: 'JsonPart',
    value: {__typename: 'JsonObject', fields: []},
  };
  /**
   * Erzeugt rekursiv ein verschachteltes JSON-Objekt basierend auf einem Pfad.
   * @param fields Aktuelle Felder des JSON-Objekts.
   * @param path Array der Pfadsegmente.
   * @param leafType Typ des Blattelements (Slot- oder String-Wert).
   * @param value Wert, der im Blatt gespeichert wird.
   */
  const createNestedObject = (
    fields: JsonValueWithSlotsRecursive_JsonObject_Fragment['fields'],
    path: string[],
    leafType: JsonValueTypes,
    value: string,
  ) => {
    const isLeaf = path.length === 1;
    const pathToken = path.shift();
    if (!pathToken) return;
    if (isLeaf && pathToken) {
      const nextJsonField: Omit<JsonFieldFragment, 'value'> = {
        __typename: 'JsonField',
        name: pathToken,
      };
      if (leafType === 'JsonSlotValue') {
        fields.push({
          ...nextJsonField,
          value: {__typename: 'JsonSlotValue', slotName: value},
        });
      } else if (leafType === 'JsonStringValue') {
        fields.push({
          ...nextJsonField,
          value: {__typename: 'JsonStringValue', value: value},
        });
      }
    } else {
      const existingPath = fields
        .filter(
          (field): field is JsonFieldFragment =>
            field.__typename === 'JsonField',
        )
        .find((field) => field.name === pathToken);
      if (existingPath && path.length > 0) {
        if (existingPath.value.__typename === 'JsonObject') {
          createNestedObject(existingPath.value.fields, path, leafType, value);
        }
        return;
      }
      const jsonField: Omit<JsonFieldFragment, 'value'> & {
        value: JsonValueWithSlotsRecursive_JsonObject_Fragment;
      } = {
        __typename: 'JsonField',
        name: pathToken,
        value: {
          __typename: 'JsonObject',
          fields: [],
        },
      };
      fields.push(jsonField);
      createNestedObject(jsonField.value.fields, path, leafType, value);
    }
  };

  for (const slot of allProcessSlots) {
    const currentExportPart = nextExportParts[slot.name];
    if (!currentExportPart?.exportField) continue;
    if (slot.valueType === SlotValueType.Upload) {
      exportsParts.push({
        __typename: 'FilePart' as const,
        slotName: slot.name,
      });
      continue;
    }
    if (jsonPart.value.__typename === 'JsonObject') {
      createNestedObject(
        jsonPart.value.fields,
        currentExportPart.path.split('.'),
        'JsonSlotValue',
        slot.name,
      );
    }
  }

  for (const stringField of nextStringExportParts) {
    // Todo make this work
    if (jsonPart.value.__typename === 'JsonObject') {
      createNestedObject(
        jsonPart.value.fields,
        stringField.path.split('.'),
        'JsonStringValue',
        stringField.value,
      );
    }
  }
  exportsParts.push(jsonPart);
  return exportsParts;
};

/**
 * Ermittelt Standardwerte für Export-Felder basierend auf vorhandenen Export-Teilen.
 * @param slotNames Liste der Slotnamen.
 * @param exportParts Export-Teile des GovManagerRestExportSchritt.
 * @returns Objekt mit Standardwerten für Slot- und String-Formfelder.
 */
export const getDefaultValuesFromExportParts = (
  slotNames: string[],
  exportParts: GovManagerRestExportSchritt['exportParts'],
) => {
  const defaultJsonsSlotFormFields: Record<string, JsonSlotFormFieldProps> =
    Object.fromEntries(
      slotNames.map((slot) => [slot, {exportField: false, path: ''}]),
    );
  const defaultJsonStringFormFields: JsonStringFormFieldProps[] = [];
  for (const exportPart of exportParts) {
    if (
      exportPart.__typename === 'FilePart' &&
      slotNames.includes(exportPart.slotName)
    ) {
      defaultJsonsSlotFormFields[exportPart.slotName].exportField = true;
      defaultJsonsSlotFormFields[exportPart.slotName].path =
        exportPart.slotName; // Todo make path editable
    } else if (exportPart.__typename === 'JsonPart') {
      /**
       * Füllt rekursiv die Standardwerte aus verschachtelten JSON-Werten.
       * @param value Aktueller JSON-Wert.
       * @param currentPath Aktueller Pfad als String.
       */
      const fillFromNestedJsonValues = (
        value: JsonValueWithSlotsRecursiveFragment,
        currentPath: string,
      ) => {
        if (
          value.__typename === 'JsonSlotValue' &&
          slotNames.includes(value.slotName)
        ) {
          if (defaultJsonsSlotFormFields[value.slotName]) {
            defaultJsonsSlotFormFields[value.slotName].exportField = true;
            defaultJsonsSlotFormFields[value.slotName].path = currentPath;
          }
        } else if (value.__typename === 'JsonObject') {
          for (const field of value.fields) {
            const nextPath = currentPath
              ? `${currentPath}.${field.name}`
              : field.name;
            fillFromNestedJsonValues(field.value, nextPath);
          }
        } else if (value.__typename === 'JsonStringValue') {
          defaultJsonStringFormFields.push({
            path: currentPath,
            value: value.value,
          });
        }
      };
      fillFromNestedJsonValues(
        exportPart.value as JsonValueWithSlotsRecursiveFragment,
        '',
      );
    }
  }
  return {defaultJsonsSlotFormFields, defaultJsonStringFormFields};
};
