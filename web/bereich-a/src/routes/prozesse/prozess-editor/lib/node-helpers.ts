import {type Edge} from '@xyflow/react';
import {type SchrittNode} from './flow/flow.types.ts';

/**
 * Typ für mögliche Aktionen beim Löschen von Knoten oder Kanten im Prozess-Editor.
 */
export type Action =
  | 'delete-node'
  | 'delete-ghost-node'
  | 'detach-node'
  | 'delete-edge'
  | 'delete-many';

/**
 * Ermittelt die passende Löschaktion basierend auf der Auswahl von Knoten und Kanten.
 * @param nodes Ausgewählte Knoten mit den zugehörigen Schritt-Daten.
 * @param edges Ausgewählte Kanten.
 * @returns Die ermittelte Aktion oder null, falls keine zutrifft.
 */
export const getDeleteAction = ({
  nodes,
  edges,
}: {
  nodes: SchrittNode[];
  edges: Edge[];
}) => {
  let action: Action | null = null;

  // A multi-node selection is bulk-deleted outright (nodes + incident edges, no ghost
  // placeholders). The detach-to-ghost affordance below is single-node only.
  if (nodes.length > 1) return 'delete-many';

  const onlyGhostNodes = nodes.every(
    (n) => n.data.schritt.__typename === 'GhostSchritt',
  );

  // From here the selection is at most one node, so the single-entity reasoning holds.
  switch (true) {
    case nodes.length > 0 && edges.length > 0: {
      // Ghost nodes can only be deleted. Normal nodes, if still connected can only be detached.
      action = onlyGhostNodes ? 'delete-ghost-node' : 'detach-node';
      break;
    }
    case nodes.length > 0: {
      // Deleting a node/ghost-node without connections
      action = onlyGhostNodes ? 'delete-ghost-node' : 'delete-node';
      break;
    }
    default:
      // We are deleting only edges
      action = 'delete-edge';
  }

  return action;
};
