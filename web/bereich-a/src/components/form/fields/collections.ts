// Gemeinsame Logik für Select- und Radio-Group-Felder.

import {type ReactNode} from 'react';
import {type FieldProps} from './common.tsx';

/**
 * Definiert ein Element einer Sammlung (z. B. für Dropdowns oder Radio-Gruppen).
 *
 * @param key - Eindeutiger Schlüssel des Elements. Wird automatisch generiert, wenn nicht angegeben.
 * @param name - Anzeigetext des Elements.
 * @param customItem - Individuelle Darstellung des Elements (optional).
 * @param separator - Gibt an, ob das Element eine Trennlinie darstellen soll (optional).
 * @param value - Der tatsächliche Wert des Elements.
 */
export type CollectionItem<T> = {
  key?: string;
  name?: string;
  customItem?: ReactNode;
  separator?: boolean;
  value: T;
};

/**
 * Eigenschaften für Felder, die mit Sammlungen arbeiten (z. B. Select oder Radio-Gruppen).
 *
 * @param items - Die Sammlung der auswählbaren Elemente.
 */
export interface CollectionFieldProps<T> extends FieldProps<T> {
  items: CollectionItem<T>[];
}

/**
 * Erzeugt einen eindeutigen Key für ein Element, basierend auf dessen Wert.
 *
 * @param value - Der Wert des Elements.
 * @returns Ein eindeutiger Schlüssel als String.
 *
 * Gibt Sonderwerte wie `%%NULL` für `null` oder `%%UNDEFINED` für `undefined` zurück,
 * um diese explizit unterscheidbar zu machen.
 */
export const getCollectionItemKey = (value: unknown) =>
  value === null
    ? '%%NULL'
    : value === undefined
    ? '%%UNDEFINED'
    : JSON.stringify(value);

/**
 * Sucht ein Element in einer Sammlung anhand dessen Schlüssel.
 *
 * @param items - Die Sammlung der auswählbaren Elemente.
 * @param key - Der Schlüssel des gesuchten Elements.
 * @returns Das gefundene Element oder `undefined`, wenn keines gefunden wurde.
 */
export const findCollectionItemByKey = <T>(
  items: CollectionItem<T>[],
  key: string | number,
) =>
  items.find(
    (needle) => (needle.key ?? getCollectionItemKey(needle.value)) === key,
  );

/**
 * Sucht ein Element in einer Sammlung anhand dessen Wert oder eines spezifischen Identifikators.
 *
 * @param items - Die Sammlung der auswählbaren Elemente.
 * @param value - Der Wert des gesuchten Elements.
 * @param fieldName - (Optional) Name des Feldes für Warnmeldungen.
 * @param valueIdentifier - (Optional) Schlüssel zur eindeutigen Identifizierung, falls die Elemente Objekte sind.
 * @returns Das gefundene Element oder `undefined`, wenn keiner passt.
 *
 * Gibt eine Warnung aus, wenn ein Wert nicht definiert ist und kein entsprechendes Element in der Sammlung gefunden wurde (nur bei Entwicklung).
 */
export const findCollectionItemByValue = <T>(
  items: CollectionItem<T>[],
  value: T | undefined,
  fieldName: unknown,
  valueIdentifier?: keyof T,
) => {
  const result = items.find((needle) => {
    if (valueIdentifier)
      return needle.value[valueIdentifier] === value?.[valueIdentifier];

    return needle.value === value;
  });
  if (result == null && value != null && items.length && import.meta.env.DEV) {
    console.warn(
      `Value for field "${fieldName}" is ${value} but no item with the corresponding value is defined.`,
    );
  }
  return result;
};
