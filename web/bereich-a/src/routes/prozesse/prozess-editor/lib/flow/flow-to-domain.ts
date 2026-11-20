import {
  type SchrittDaten,
  type VerbindungDaten,
  type ZustaendigkeitRolle,
} from '../domain-types.ts';
import {type SchrittNode, type VerbindungEdge} from './flow.types.ts';

const findRolle = (
  rollen: ZustaendigkeitRolle[],
  id: string | null | undefined,
): ZustaendigkeitRolle | null =>
  (id != null && rollen.find((r) => r.id === id)) || null;

/**
 * Adapts a React Flow node back into the domain `SchrittDaten` shape that the legacy
 * graph utilities (`validateProzess`, `createProzessVisitor`) and the node renderer
 * consume: `node.id` is the canonical step id, and the role objects stripped by
 * `prozessToFlow` are re-attached from process metadata.
 */
export const nodeToSchrittDaten = (
  node: SchrittNode,
  rollen: ZustaendigkeitRolle[],
): SchrittDaten => {
  const schritt = {...node.data.schritt, id: node.id};

  if (schritt.__typename === 'GhostSchritt') {
    return schritt;
  }

  return {
    ...schritt,
    schreibtRolle: findRolle(rollen, schritt.schreibtRolleId),
    sollZustaendigkeit: {
      ...schritt.sollZustaendigkeit,
      liestRolle: findRolle(rollen, schritt.sollZustaendigkeit.liestRolleId),
    },
  } as SchrittDaten;
};

/** Adapts a React Flow edge back into the domain `VerbindungDaten` shape:
 *  `edge.source` / `edge.target` are the canonical `vonId` / `nachId`. */
export const edgeToVerbindungDaten = (edge: VerbindungEdge): VerbindungDaten =>
  ({
    ...edge.data?.verbindung,
    id: edge.id,
    vonId: edge.source,
    nachId: edge.target,
  }) as VerbindungDaten;

/**
 * Projects the live graph into the domain `{schritte, verbindungen}` shape for the graph
 * utilities that still operate on it (upstream traversal, available-role resolution).
 */
export const flowToDomain = (
  nodes: SchrittNode[],
  edges: VerbindungEdge[],
  rollen: ZustaendigkeitRolle[],
): {schritte: SchrittDaten[]; verbindungen: VerbindungDaten[]} => ({
  schritte: nodes.map((node) => nodeToSchrittDaten(node, rollen)),
  verbindungen: edges.map(edgeToVerbindungDaten),
});
