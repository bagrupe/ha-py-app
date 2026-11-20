import {type KategorieFragment} from './kategoriebaum.generated.ts';

export const kollidiertAlsZwilling = (
  geschwister: KategorieFragment[],
  name: string,
  neueUntereinheitId: string | null,
) =>
  geschwister.some(
    (k) =>
      k.name === name &&
      (k.untereinheitId == null) !== (neueUntereinheitId == null),
  );

export const findeZwilling = (
  kategorie: KategorieFragment,
  kategorieById: Map<string, KategorieFragment>,
  untereinheitId: string,
): KategorieFragment | null =>
  kategorie.untereinheitId != null
    ? null
    : [...kategorieById.values()].find(
        (k) =>
          k.untereinheitId === untereinheitId &&
          k.parentId === kategorie.parentId &&
          k.name === kategorie.name,
      ) ?? null;

// Wurzel ist kein ParentId-Vorfahre - Fallback auf sie muss separat erfolgen (wie im Backend).
export const resolveEffektivesZiel = (
  kategorie: KategorieFragment,
  kategorieById: Map<string, KategorieFragment>,
  wurzelZiel: KategorieFragment['ziel'],
  untereinheitId: string,
): {ziel: KategorieFragment['ziel']; eigen: boolean} => {
  const eigenesZiel = (k: KategorieFragment) =>
    k.ziel ?? findeZwilling(k, kategorieById, untereinheitId)?.ziel ?? null;

  const eigen = eigenesZiel(kategorie);
  if (eigen) return {ziel: eigen, eigen: true};
  let current = kategorie.parentId
    ? kategorieById.get(kategorie.parentId)
    : undefined;
  while (current) {
    const geerbt = eigenesZiel(current);
    if (geerbt) return {ziel: geerbt, eigen: false};
    current = current.parentId
      ? kategorieById.get(current.parentId)
      : undefined;
  }
  return {ziel: kategorie.istWurzel ? null : wurzelZiel, eigen: false};
};

export const zaehleNachfahren = (
  id: string,
  kinderVon: Map<string | null, KategorieFragment[]>,
): number => {
  const kinder = kinderVon.get(id) ?? [];
  return kinder.reduce(
    (summe, kind) => summe + 1 + zaehleNachfahren(kind.id, kinderVon),
    0,
  );
};
