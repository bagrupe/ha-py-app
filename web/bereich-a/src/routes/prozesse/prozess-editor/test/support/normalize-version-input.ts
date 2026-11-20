import {
  type ProzessVersionErstellenInput,
  type SchrittInput,
} from '../../prozess-version-erstellen.generated.ts';

/**
 * Read-only denormalized fields the editor receives but the server never persists.
 * Today's save path over-sends `liestRolle` (inside `sollZustaendigkeit`); both it
 * and `schreibtRolle` are resolved from `metadata.rollen` in the refactored boundary,
 * so they are dropped on both sides before comparing. `__typename` is dropped because
 * it survives only inside kept denormalized objects (e.g. `mitarbeiterGruppe`).
 */
const IGNORED_KEYS = new Set(['liestRolle', 'schreibtRolle', '__typename']);

const stripIgnored = (value: unknown): unknown => {
  if (Array.isArray(value)) return value.map(stripIgnored);
  if (value && typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value)
        .filter(([key]) => !IGNORED_KEYS.has(key))
        .map(([key, child]) => [key, stripIgnored(child)]),
    );
  }
  return value;
};

/** Editor default render position. A step with no stored `nodePosition` renders here
 *  and the refactored save persists it from `node.position` (spec §4.7), whereas the
 *  legacy save emitted no position at all — so the two are semantically equivalent. */
const DEFAULT_NODE_POSITION = {x: 100, y: 100};

const innerStep = (
  schritt: SchrittInput,
): {id: string; nodePosition?: unknown} =>
  Object.values(schritt).find((value) => value != null) as {
    id: string;
    nodePosition?: unknown;
  };

const coalescePosition = (schritt: SchrittInput): SchrittInput => {
  const inner = innerStep(schritt);
  if (inner.nodePosition == null) inner.nodePosition = DEFAULT_NODE_POSITION;
  return schritt;
};

const byId = (a: string, b: string): number => (a < b ? -1 : a > b ? 1 : 0);

/**
 * Normalized semantic form for comparing two `ProzessVersionErstellenInput`s:
 * Expression instances collapse to their string via `toJSON`, `undefined` is dropped,
 * top-level steps/connections/roles are id-sorted (their order is not meaningful),
 * while form field / option / export-part order is preserved.
 */
export const normalizeVersionInput = (input: ProzessVersionErstellenInput) => {
  const json = JSON.parse(
    JSON.stringify(input),
  ) as ProzessVersionErstellenInput;
  const stripped = stripIgnored(json) as ProzessVersionErstellenInput;

  return {
    prozessId: stripped.prozessId,
    veroeffentlichen: stripped.veroeffentlichen,
    schritte: [...stripped.schritte]
      .map(coalescePosition)
      .sort((a, b) => byId(innerStep(a).id, innerStep(b).id)),
    verbindungen: [...stripped.verbindungen].sort((a, b) => byId(a.id, b.id)),
    zustaendigkeitRollen: [...stripped.zustaendigkeitRollen].sort((a, b) =>
      byId(a.id, b.id),
    ),
  };
};
