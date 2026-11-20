/**
 * Formatiert den Namen einer Person als Initiale des Vornamens gefolgt vom Nachnamen.
 * @param person Objekt mit den Eigenschaften `vorname` und `nachname`.
 * @returns Formatierter Name als String, z.B. "M. Müller".
 */
export const formatVornameNachname = (person: {
  vorname: string;
  nachname: string;
}): string => `${person.vorname.charAt(0)}. ${person.nachname}`;
