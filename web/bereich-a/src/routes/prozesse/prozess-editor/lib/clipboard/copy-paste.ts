import {type XYPosition} from '@xyflow/react';
import cloneDeep from 'lodash/cloneDeep';
import {
  type IdFactory,
  type ProzessEditorFlow,
  type SchrittNode,
  type VerbindungEdge,
} from '../flow/flow.types.ts';
import {cloneSubgraph} from '../graph/graph-ops.ts';

/**
 * A decoupled snapshot of the copied subgraph. It holds the selected steps and the
 * connections internal to them with their original ids; ids are only regenerated when the
 * payload is pasted, so the same clipboard can be pasted repeatedly. The payload survives
 * later graph edits because it is deep-cloned and stripped of view-only state.
 */
export type Clipboard = {
  nodes: SchrittNode[];
  edges: VerbindungEdge[];
};

const isGhostNode = (node: SchrittNode): boolean =>
  node.data.schritt.__typename === 'GhostSchritt';

/**
 * Captures the current selection as a clipboard payload: the selected non-ghost steps and
 * the connections whose source and target are both selected. The snapshot is a clean deep
 * copy — selection and derived view-only fields are dropped — so it stays valid after the
 * live graph changes.
 */
export const copySelection = (graph: ProzessEditorFlow): Clipboard => {
  const selectedNodes = graph.nodes.filter(
    (node) => node.selected && !isGhostNode(node),
  );
  const selectedIds = new Set(selectedNodes.map((node) => node.id));

  const nodes = selectedNodes.map(
    (node): SchrittNode => ({
      id: node.id,
      type: node.type,
      position: {...node.position},
      zIndex: node.zIndex,
      data: {schritt: cloneDeep(node.data.schritt)},
    }),
  );

  const edges = graph.edges
    .filter(
      (edge) => selectedIds.has(edge.source) && selectedIds.has(edge.target),
    )
    .map(
      (edge): VerbindungEdge => ({
        id: edge.id,
        source: edge.source,
        target: edge.target,
        type: edge.type,
        reconnectable: edge.reconnectable,
        data: cloneDeep(edge.data!),
      }),
    );

  return {nodes, edges};
};

/**
 * Pastes a clipboard payload into the graph: the payload is cloned with fresh ids
 * (via {@link cloneSubgraph}), offset by `offset`, and appended. The pasted elements become
 * the new selection and everything previously selected is deselected. An empty clipboard is
 * a no-op.
 */
export const pasteClipboard = (
  graph: ProzessEditorFlow,
  clipboard: Clipboard,
  offset: XYPosition,
  options: {createId?: IdFactory} = {},
): ProzessEditorFlow => {
  if (clipboard.nodes.length === 0) return graph;

  const {nodes, edges} = cloneSubgraph(
    clipboard.nodes,
    clipboard.edges,
    offset,
    options.createId,
  );

  return {
    nodes: [
      ...graph.nodes.map((node) =>
        node.selected ? {...node, selected: false} : node,
      ),
      ...nodes.map((node) => ({...node, selected: true})),
    ],
    edges: [
      ...graph.edges.map((edge) =>
        edge.selected ? {...edge, selected: false} : edge,
      ),
      ...edges.map((edge) => ({...edge, selected: true})),
    ],
    metadata: graph.metadata,
  };
};
