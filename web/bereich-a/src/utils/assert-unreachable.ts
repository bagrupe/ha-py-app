/**
 * Funktion zur Sicherstellung, dass ein bestimmter Codepfad niemals erreicht wird.
 * Wirft im Entwicklungsmodus einen Fehler, um unerwartete Fälle zu erkennen.
 * @param _ Ein Wert vom Typ `never`, der niemals existieren sollte.
 * @returns Gibt niemals zurück, da sie entweder einen Fehler wirft oder den Typ `never` erzwingt.
 */
export const assertUnreachable = (_: never): never => {
  if (process.env.NODE_ENV !== 'production') {
    throw new Error('This should not happen');
  }
  return undefined as never;
};
