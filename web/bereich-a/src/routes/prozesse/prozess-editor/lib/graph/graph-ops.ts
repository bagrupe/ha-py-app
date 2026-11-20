import {type Connection, type XYPosition} from '@xyflow/react';
import cloneDeep from 'lodash/cloneDeep';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type GhostSchritt} from '../domain-types.ts';
import {deriveEdge} from '../flow/edge-derivation.ts';
import {
  type IdFactory,
  type ProcessMetadata,
  type ProzessEditorFlow,
  type SchrittNode,
  type SchrittNodeData,
  type VerbindungEdge,
} from '../flow/flow.types.ts';

type Graph = ProzessEditorFlow;
type SchrittData = SchrittNode['data']['schritt'];
type VerbindungData = NonNullable<VerbindungEdge['data']>;

const defaultCreateId: IdFactory = () => crypto.randomUUID();

const withGraph = (
  graph: Graph,
  nodes: SchrittNode[],
  edges: VerbindungEdge[],
): Graph => ({nodes, edges, metadata: graph.metadata});

const isGhostStep = (schritt: SchrittData): schritt is GhostSchritt =>
  schritt.__typename === 'GhostSchritt';

const findStep = (
  nodes: SchrittNode[],
  id: string | null | undefined,
): SchrittData | undefined => nodes.find((n) => n.id === id)?.data.schritt;

export const addStep = (
  graph: Graph,
  stepData: Partial<SchrittData> & Pick<SchrittData, '__typename'>,
  position: XYPosition,
  options: {createId?: IdFactory} = {},
): Graph => {
  const createId = options.createId ?? defaultCreateId;
  const id = createId();

  const node: SchrittNode = {
    id,
    type: 'schritt',
    position: {...position},
    zIndex: 1,
    data: {schritt: {...cloneDeep(stepData), id} as SchrittData},
  };

  return withGraph(graph, [...graph.nodes, node], graph.edges);
};

export const connect = (
  graph: Graph,
  connection: Pick<Connection, 'source' | 'target'>,
  options: {createId?: IdFactory} = {},
): Graph => {
  const createId = options.createId ?? defaultCreateId;

  const edge: VerbindungEdge = deriveEdge(
    {
      id: createId(),
      source: connection.source,
      target: connection.target,
      type: 'kommunalEdge',
      reconnectable: true,
      data: {
        verbindung: {
          name: null,
          statusAenderung: null,
          statusAenderungBeschreibung: null,
          istRelevant: 'true',
        },
      },
    },
    findStep(graph.nodes, connection.source),
  );

  return withGraph(graph, graph.nodes, [...graph.edges, edge]);
};

export const reconnect = (
  graph: Graph,
  edgeId: string,
  connection: Pick<Connection, 'source' | 'target'>,
): Graph => {
  const edges = graph.edges.map((edge) => {
    if (edge.id !== edgeId) return edge;
    return deriveEdge(
      {...edge, source: connection.source, target: connection.target},
      findStep(graph.nodes, connection.source),
    );
  });

  return withGraph(graph, graph.nodes, edges);
};

export const updateStepData = (
  graph: Graph,
  nodeId: string,
  patch: Partial<SchrittData>,
  _metadata: ProcessMetadata,
): Graph => {
  const nodes = graph.nodes.map((node) => {
    if (node.id !== nodeId) return node;

    const schritt = {
      ...cloneDeep(node.data.schritt),
      ...cloneDeep(patch),
    } as SchrittData;

    if (
      !isGhostStep(schritt) &&
      schritt.sollZustaendigkeit.art !== ZustaendigkeitArt.Dynamisch &&
      schritt.sollZustaendigkeit.liestRolleId
    ) {
      schritt.sollZustaendigkeit.liestRolleId = null;
    }

    return {...node, data: {...node.data, schritt}};
  });

  return withGraph(graph, nodes, graph.edges);
};

/** An explicit `null` clears the field; only an omitted (`undefined`) key leaves the
 *  existing value untouched. */
const applyPatch = <T extends object>(base: T, patch: Partial<T>): T => {
  const next = {...base};
  for (const key in patch) {
    const value = patch[key];
    if (value !== undefined) {
      next[key] = value as T[Extract<keyof T, string>];
    }
  }
  return next;
};

export const updateConnectionData = (
  graph: Graph,
  edgeId: string,
  patch: Partial<VerbindungData['verbindung']>,
): Graph => {
  const edges = graph.edges.map((edge) => {
    if (edge.id !== edgeId) return edge;

    const verbindung = applyPatch({...edge.data!.verbindung}, patch);
    const updated: VerbindungEdge = {
      ...edge,
      data: {...edge.data!, verbindung},
    };

    return deriveEdge(updated, findStep(graph.nodes, edge.source));
  });

  return withGraph(graph, graph.nodes, edges);
};

type Selection = {nodes: SchrittNode[]; edges: VerbindungEdge[]};

const isGhostNode = (node: SchrittNode): boolean =>
  isGhostStep(node.data.schritt);

export const deleteSelection = (graph: Graph, selection: Selection): Graph => {
  const {nodes, edges} = selection;

  // Single-selection only (getDeleteAction); multi-node selection has no policy yet.
  if (nodes.length > 1) return graph;

  const onlyGhostNodes = nodes.length > 0 && nodes.every(isGhostNode);

  if (nodes.length > 0 && edges.length > 0) {
    return onlyGhostNodes
      ? deleteNodesAndEdges(graph, nodes, edges)
      : detachToGhost(graph, nodes[0].id, nodes[0].measured);
  }

  if (nodes.length > 0) {
    return deleteNodesAndEdges(graph, nodes, []);
  }

  const removedEdgeIds = new Set(edges.map((e) => e.id));
  return withGraph(
    graph,
    graph.nodes,
    graph.edges.filter((e) => !removedEdgeIds.has(e.id)),
  );
};

const deleteNodesAndEdges = (
  graph: Graph,
  nodes: SchrittNode[],
  edges: VerbindungEdge[],
): Graph => {
  const removedNodeIds = new Set(nodes.map((n) => n.id));
  const removedEdgeIds = new Set(edges.map((e) => e.id));

  return withGraph(
    graph,
    graph.nodes.filter((n) => !removedNodeIds.has(n.id)),
    graph.edges.filter((e) => !removedEdgeIds.has(e.id)),
  );
};

export const detachToGhost = (
  graph: Graph,
  nodeId: string,
  measured?: {width?: number; height?: number},
  options: {createId?: IdFactory} = {},
): Graph => {
  const createId = options.createId ?? defaultCreateId;

  const target = graph.nodes.find((n) => n.id === nodeId);
  if (!target) return graph;

  // Ghost node (120x60) centered in the original node's footprint.
  const ghostPosition: XYPosition = {
    x: measured?.width
      ? target.position.x + (measured.width / 2 - 60)
      : target.position.x,
    y: measured?.height
      ? target.position.y + (measured.height / 2 - 30)
      : target.position.y,
  };

  const generated = createId();
  const ghostId = generated.startsWith('GHOST-')
    ? generated
    : `GHOST-${generated}`;

  const ghostNode: SchrittNode = {
    id: ghostId,
    type: 'schritt',
    position: ghostPosition,
    zIndex: 0,
    data: {
      schritt: {
        __typename: 'GhostSchritt',
        id: ghostId,
        titel: 'Platzhalter',
        slots: [],
      } as GhostSchritt,
    },
  };

  // Detached node moves below the ghost (+90 y) and re-centers on the x axis.
  const detachedPosition: XYPosition = {
    x: measured?.width
      ? ghostPosition.x - (measured.width / 2 - 60)
      : ghostPosition.x,
    y: ghostPosition.y + 90,
  };

  const nodes = graph.nodes.map((node) =>
    node.id === nodeId ? {...node, position: detachedPosition} : node,
  );
  nodes.push(ghostNode);

  const stepById = new Map(nodes.map((node) => [node.id, node.data.schritt]));
  const edges = graph.edges.map((edge) => {
    if (edge.source !== nodeId && edge.target !== nodeId) return edge;
    const rewired: VerbindungEdge = {
      ...edge,
      source: edge.source === nodeId ? ghostId : edge.source,
      target: edge.target === nodeId ? ghostId : edge.target,
    };
    return deriveEdge(rewired, stepById.get(rewired.source));
  });

  return withGraph(graph, nodes, edges);
};

export const attachGhost = (
  graph: Graph,
  nodeId: string,
  ghostId: string,
): Graph => {
  if (!graph.nodes.some((n) => n.id === ghostId)) return graph;

  const edges = graph.edges.map((edge) => {
    if (edge.source !== ghostId && edge.target !== ghostId) return edge;
    const rewired: VerbindungEdge = {
      ...edge,
      source: edge.source === ghostId ? nodeId : edge.source,
      target: edge.target === ghostId ? nodeId : edge.target,
    };
    return deriveEdge(rewired, findStep(graph.nodes, rewired.source));
  });

  return withGraph(
    graph,
    graph.nodes.filter((n) => n.id !== ghostId),
    edges,
  );
};

const STEP_REFERENCE_FIELDS = [
  'bezahlenSchrittId',
  'govManagerSchrittId',
] as const;

const stripViewOnlyData = (data: SchrittNodeData): SchrittNodeData => ({
  schritt: data.schritt,
});

/**
 * Clones a set of source nodes and their internal edges into fresh, id-regenerated
 * copies offset by `offset`. Node ids, step ids, form field ids and connection ids are
 * regenerated; internal step-reference fields (`bezahlenSchrittId`, `govManagerSchrittId`)
 * are remapped to the cloned nodes and cleared when they point outside the set; view-only
 * data (`selected`, `measured`, derived node fields) is stripped. Shared by
 * {@link duplicateSubgraph} (in-graph duplicate) and the clipboard `pasteClipboard`.
 */
export const cloneSubgraph = (
  sourceNodes: SchrittNode[],
  sourceEdges: VerbindungEdge[],
  offset: XYPosition,
  createId: IdFactory = defaultCreateId,
): {nodes: SchrittNode[]; edges: VerbindungEdge[]} => {
  const nodeIdMap = new Map<string, string>();

  const clonedNodes = sourceNodes.map((node) => {
    const newNodeId = createId();
    nodeIdMap.set(node.id, newNodeId);

    const schritt = cloneDeep(node.data.schritt) as SchrittData;
    schritt.id = newNodeId;

    if (!isGhostStep(schritt) && 'felder' in schritt && schritt.felder) {
      schritt.felder = schritt.felder.map((feld) => ({
        ...feld,
        id: createId(),
      }));
    }

    return {
      id: newNodeId,
      type: node.type,
      position: {x: node.position.x + offset.x, y: node.position.y + offset.y},
      zIndex: node.zIndex,
      data: stripViewOnlyData({schritt}),
    } as SchrittNode;
  });

  for (const node of clonedNodes) {
    const schritt = node.data.schritt;
    if (isGhostStep(schritt)) continue;
    for (const field of STEP_REFERENCE_FIELDS) {
      const ref = (schritt as Record<string, unknown>)[field];
      if (typeof ref !== 'string' || ref === '') continue;
      (schritt as Record<string, unknown>)[field] = nodeIdMap.get(ref) ?? '';
    }
  }

  const clonedStepById = new Map(
    clonedNodes.map((node) => [node.id, node.data.schritt]),
  );

  // Rebuild from the canonical edge fields (never `...edge`) so view-only state
  // like `selected` is dropped, mirroring how cloned nodes are constructed.
  const clonedEdges = sourceEdges
    .filter((edge) => nodeIdMap.has(edge.source) && nodeIdMap.has(edge.target))
    .map((edge) => {
      const source = nodeIdMap.get(edge.source)!;
      const target = nodeIdMap.get(edge.target)!;
      const cloned: VerbindungEdge = {
        id: createId(),
        source,
        target,
        type: edge.type,
        reconnectable: edge.reconnectable,
        data: cloneDeep(edge.data!),
      };
      return deriveEdge(cloned, clonedStepById.get(source));
    });

  return {nodes: clonedNodes, edges: clonedEdges};
};

export const duplicateSubgraph = (
  graph: Graph,
  selectedIds: string[],
  offset: XYPosition,
  options: {createId?: IdFactory} = {},
): Graph => {
  const selected = new Set(selectedIds);
  const sourceNodes = graph.nodes.filter((n) => selected.has(n.id));
  const sourceEdges = graph.edges.filter(
    (edge) => selected.has(edge.source) && selected.has(edge.target),
  );

  const {nodes, edges} = cloneSubgraph(
    sourceNodes,
    sourceEdges,
    offset,
    options.createId ?? defaultCreateId,
  );

  return withGraph(
    graph,
    [...graph.nodes, ...nodes],
    [...graph.edges, ...edges],
  );
};
