import {type SchrittDaten} from './domain-types.ts';
import {projectByArt} from './soll-zustaendigkeit.ts';

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === 'object' && value !== null;

const deepEqual = (a: unknown, b: unknown): boolean => {
  if (a === b) return true;

  if (Array.isArray(a) || Array.isArray(b)) {
    if (!Array.isArray(a) || !Array.isArray(b) || a.length !== b.length) {
      return false;
    }
    return a.every((item, index) => deepEqual(item, b[index]));
  }

  if (isRecord(a) && isRecord(b)) {
    const keysA = Object.keys(a);
    const keysB = Object.keys(b);
    if (keysA.length !== keysB.length) return false;
    return keysA.every((key) => deepEqual(a[key], b[key]));
  }

  return false;
};

/**
 * Projiziert die Soll-Zuständigkeit auf die Felder der aktiven Art. Der Store
 * trägt an der Baseline zusätzliche Query-Felder (z. B. `mitarbeiterGruppe`), die
 * das Formular beim Tab-Wechsel verwirft — ohne diese Angleichung zählte ein
 * reiner Tab-Wechsel fälschlich als Änderung.
 */
const normalizeStep = (step: SchrittDaten): object =>
  'sollZustaendigkeit' in step
    ? {
        ...step,
        sollZustaendigkeit: projectByArt(
          step.sollZustaendigkeit,
          step.sollZustaendigkeit.art,
        ),
      }
    : step;

/**
 * Ob sich der bearbeitete Schritt inhaltlich vom gespeicherten unterscheidet.
 * Die Soll-Zuständigkeit wird vor dem Vergleich auf die aktive Art projiziert,
 * damit bloßes Tab-Wechseln keine (Schein-)Änderung erzeugt.
 */
export const isStepDirty = (
  current: SchrittDaten,
  saved: SchrittDaten,
): boolean => !deepEqual(normalizeStep(current), normalizeStep(saved));
