import {
  applyEdgeChanges,
  applyNodeChanges,
  type Connection,
  type EdgeChange,
  type NodeChange,
  type XYPosition,
} from '@xyflow/react';
import {create} from 'zustand';
import {type ProzessEditorProzess} from '../../verfuegbare-prozesse.generated.ts';
import {
  type Clipboard,
  copySelection,
  pasteClipboard,
} from '../clipboard/copy-paste.ts';
import {type ZustaendigkeitRolle} from '../domain-types.ts';
import {
  type ProcessMetadata,
  type ProzessEditorFlow,
  type SchrittNode,
  type VerbindungEdge,
} from '../flow/flow.types.ts';
import {
  addStep as addStepOp,
  attachGhost as attachGhostOp,
  connect as connectOp,
  detachToGhost as detachToGhostOp,
  reconnect as reconnectOp,
  updateConnectionData as updateConnectionDataOp,
  updateStepData as updateStepDataOp,
} from '../graph/graph-ops.ts';
import {
  type History,
  type HistorySnapshot,
  emptyHistory,
  pushPast,
  redo as redoHistory,
  snapshotOf,
  undo as undoHistory,
} from '../history/undo-redo.ts';
import {hasDirtyChange} from '../metadata/dirty-state.ts';
import {
  addRole as addRoleOp,
  setName as setNameOp,
} from '../metadata/metadata-reducers.ts';
import {prozessToFlow} from '../serialization/prozess-to-flow.ts';
import {validateGraph} from '../validate-graph.ts';
import {
  type ProzessValidationResult,
  type ZustaendigkeitCatalog,
} from '../validate-prozess.ts';

type SchrittData = SchrittNode['data']['schritt'];
type VerbindungData = NonNullable<VerbindungEdge['data']>;
type NodeMeasurement = {width?: number; height?: number};
type PublishedVersionMetadata = {
  id: string;
  publishedAt?: Date | string | null;
};

const SMART_EDGES_STORAGE_KEY = 'prozesseditor.smartEdges';

const readSmartEdgesSetting = (): boolean =>
  typeof localStorage !== 'undefined' &&
  localStorage.getItem(SMART_EDGES_STORAGE_KEY) === 'true';

const writeSmartEdgesSetting = (enabled: boolean): void => {
  if (typeof localStorage === 'undefined') return;
  localStorage.setItem(SMART_EDGES_STORAGE_KEY, enabled ? 'true' : 'false');
};

const serializePublishedAt = (
  publishedAt: PublishedVersionMetadata['publishedAt'],
): string | null =>
  publishedAt instanceof Date ? publishedAt.toISOString() : publishedAt ?? null;

const EMPTY_METADATA: ProcessMetadata = {
  prozessId: '',
  name: 'Neuer Prozess',
  startId: null,
  rollen: [],
  istOeffentlich: false,
  hasVersionChanges: false,
};

const markDirty = (metadata: ProcessMetadata): ProcessMetadata =>
  metadata.hasVersionChanges
    ? metadata
    : {...metadata, hasVersionChanges: true};

/**
 * Re-runs validation and reconciles the derived view-only node fields (`errors`,
 * `isStart`). Nodes whose validation state is unchanged keep their object identity, so
 * React Flow only re-renders the nodes whose badges/start-marker actually changed.
 */
const withValidation = (
  nodes: SchrittNode[],
  edges: VerbindungEdge[],
  metadata: ProcessMetadata,
  catalog: ZustaendigkeitCatalog | null = null,
): {nodes: SchrittNode[]; validationResult: ProzessValidationResult} => {
  const validationResult = validateGraph(
    nodes,
    edges,
    metadata,
    catalog ?? undefined,
  );
  const {startId} = metadata;

  const nextNodes = nodes.map((node) => {
    const errors = validationResult.errors[node.id]?.errors;
    const isStart = node.id === startId;
    if (node.data.errors === errors && node.data.isStart === isStart) {
      return node;
    }
    return {...node, data: {...node.data, errors, isStart}};
  });

  return {nodes: nextNodes, validationResult};
};

/**
 * Zustand state and actions for the Prozess-Editor. React Flow owns the live graph: the
 * controlled `nodes` / `edges` arrays here are passed straight to `<ReactFlow>` and
 * mutated through the pure graph operations. The only persistent non-graph state is
 * {@link ProcessMetadata}. Selection lives on `node.selected` / `edge.selected`.
 */
export type ProzessEditorStore = {
  nodes: SchrittNode[];
  edges: VerbindungEdge[];
  metadata: ProcessMetadata;
  validationResult: ProzessValidationResult;
  catalog: ZustaendigkeitCatalog | null;
  smartEdges: boolean;
  clipboard: Clipboard | null;
  history: History;

  initializeFromProzess: (prozess: ProzessEditorProzess | null) => void;

  onNodesChange: (changes: NodeChange<SchrittNode>[]) => void;
  onEdgesChange: (changes: EdgeChange<VerbindungEdge>[]) => void;

  addConnectedStep: (
    vonId: string,
    stepData: Partial<SchrittData> & Pick<SchrittData, '__typename'>,
    position: XYPosition,
  ) => void;
  connect: (connection: Pick<Connection, 'source' | 'target'>) => void;
  reconnect: (
    edgeId: string,
    connection: Pick<Connection, 'source' | 'target'>,
  ) => void;
  updateStepData: (nodeId: string, patch: Partial<SchrittData>) => void;
  updateConnectionData: (
    edgeId: string,
    patch: Partial<VerbindungData['verbindung']>,
  ) => void;
  detachToGhost: (nodeId: string, measured?: NodeMeasurement) => void;
  attachGhost: (nodeId: string, ghostId: string) => void;
  /** Snapshots the current selection into the clipboard. Never marks the version dirty. */
  copy: () => void;
  /** Pastes the clipboard, offsetting the clones by `offset`. Marks the version dirty. */
  paste: (offset: XYPosition) => void;
  /**
   * Records the current graph as an undoable step. Graph operations snapshot themselves;
   * this is for the live React Flow interactions that bypass them — node drags and
   * React-Flow-native deletions — which must snapshot before they emit their changes.
   */
  takeSnapshot: () => void;
  /**
   * Drops the snapshot {@link takeSnapshot} recorded at drag start when the drag produced no
   * net position change, so a click or sub-grid wiggle leaves no do-nothing step on the undo
   * stack. Called from the drag-stop handlers.
   */
  dropRedundantDragSnapshot: () => void;
  /** Restores the previous graph snapshot (graph + versioned metadata + dirty flag). */
  undo: () => void;
  /** Re-applies the snapshot a preceding {@link undo} stepped back from. */
  redo: () => void;
  /** View-only drag-over highlight; never marks the version dirty. */
  setIntersectionCause: (
    nodeId: string | null,
    measured?: NodeMeasurement,
  ) => void;

  setName: (name: string) => void;
  markVersionPublished: (version: PublishedVersionMetadata) => void;
  addRole: (name: string) => ZustaendigkeitRolle;
  setCatalog: (catalog: ZustaendigkeitCatalog) => void;

  setSmartEdges: (enabled: boolean) => void;
};

type GraphSlice = Pick<
  ProzessEditorStore,
  'nodes' | 'edges' | 'metadata' | 'validationResult' | 'history'
>;

const runGraphOp = (
  state: ProzessEditorStore,
  op: (graph: ProzessEditorFlow) => ProzessEditorFlow,
): GraphSlice => {
  // Every graph operation is an undoable step: snapshot the pre-edit graph first.
  const history = pushPast(state.history, snapshotOf(state));
  const next = op({
    nodes: state.nodes,
    edges: state.edges,
    metadata: state.metadata,
  });
  const metadata = markDirty(next.metadata);
  const {nodes, validationResult} = withValidation(
    next.nodes,
    next.edges,
    metadata,
    state.catalog,
  );
  return {history, nodes, edges: next.edges, metadata, validationResult};
};

/**
 * Restores a history snapshot into the live state. The graph and the versioned metadata
 * the snapshot carries (`startId`, `rollen`, dirty flag) are applied; name and latest-version
 * metadata are kept from the current state (they are not graph history), and validation is
 * recomputed for the restored graph.
 */
const applySnapshot = (
  state: ProzessEditorStore,
  history: History,
  snapshot: HistorySnapshot,
): GraphSlice => {
  const metadata: ProcessMetadata = {
    ...state.metadata,
    startId: snapshot.startId,
    rollen: snapshot.rollen,
    hasVersionChanges: snapshot.hasVersionChanges,
  };
  const {nodes, validationResult} = withValidation(
    snapshot.nodes,
    snapshot.edges,
    metadata,
    state.catalog,
  );
  return {history, nodes, edges: snapshot.edges, metadata, validationResult};
};

const isStructural = (changes: {type: string}[]): boolean =>
  changes.some(
    (change) =>
      change.type === 'add' ||
      change.type === 'remove' ||
      change.type === 'replace',
  );

export const useProzessEditorStore = create<ProzessEditorStore>((set) => {
  const initial = withValidation([], [], EMPTY_METADATA);

  return {
    nodes: initial.nodes,
    edges: [],
    metadata: EMPTY_METADATA,
    validationResult: initial.validationResult,
    catalog: null,
    smartEdges: readSmartEdgesSetting(),
    clipboard: null,
    history: emptyHistory(),

    initializeFromProzess: (prozess) =>
      set((state) => {
        const flow = prozess
          ? prozessToFlow(prozess)
          : {nodes: [], edges: [], metadata: EMPTY_METADATA};
        const {nodes, validationResult} = withValidation(
          flow.nodes,
          flow.edges,
          flow.metadata,
          state.catalog,
        );
        return {
          nodes,
          edges: flow.edges,
          metadata: flow.metadata,
          validationResult,
          // A load is a fresh baseline — undo must not cross into the previous process.
          history: emptyHistory(),
          // Clipboard is process-scoped: dropped when a different process is loaded
          // (switch or leaving), kept across a same-process reload (e.g. after saving a
          // version) so a pending copy survives the save.
          clipboard:
            flow.metadata.prozessId === state.metadata.prozessId
              ? state.clipboard
              : null,
        };
      }),

    onNodesChange: (changes) =>
      set((state) => {
        const nodes = applyNodeChanges(changes, state.nodes);
        const metadata = hasDirtyChange(changes, [])
          ? markDirty(state.metadata)
          : state.metadata;
        if (!isStructural(changes)) {
          return {nodes, metadata};
        }
        const validated = withValidation(
          nodes,
          state.edges,
          metadata,
          state.catalog,
        );
        return {
          nodes: validated.nodes,
          metadata,
          validationResult: validated.validationResult,
        };
      }),

    onEdgesChange: (changes) =>
      set((state) => {
        const edges = applyEdgeChanges(changes, state.edges);
        const metadata = hasDirtyChange([], changes)
          ? markDirty(state.metadata)
          : state.metadata;
        if (!isStructural(changes)) {
          return {edges, metadata};
        }
        const validated = withValidation(
          state.nodes,
          edges,
          metadata,
          state.catalog,
        );
        return {
          nodes: validated.nodes,
          edges,
          metadata,
          validationResult: validated.validationResult,
        };
      }),

    addConnectedStep: (vonId, stepData, position) =>
      set((state) =>
        runGraphOp(state, (graph) => {
          const stepId = crypto.randomUUID();
          const withStep = addStepOp(graph, stepData, position, {
            createId: () => stepId,
          });
          return connectOp(withStep, {source: vonId, target: stepId});
        }),
      ),

    connect: (connection) =>
      set((state) =>
        runGraphOp(state, (graph) => connectOp(graph, connection)),
      ),

    reconnect: (edgeId, connection) =>
      set((state) =>
        runGraphOp(state, (graph) => reconnectOp(graph, edgeId, connection)),
      ),

    updateStepData: (nodeId, patch) =>
      set((state) =>
        runGraphOp(state, (graph) =>
          updateStepDataOp(graph, nodeId, patch, graph.metadata),
        ),
      ),

    updateConnectionData: (edgeId, patch) =>
      set((state) =>
        runGraphOp(state, (graph) =>
          updateConnectionDataOp(graph, edgeId, patch),
        ),
      ),

    detachToGhost: (nodeId, measured) =>
      set((state) =>
        runGraphOp(state, (graph) => detachToGhostOp(graph, nodeId, measured)),
      ),

    attachGhost: (nodeId, ghostId) =>
      set((state) =>
        runGraphOp(state, (graph) => attachGhostOp(graph, nodeId, ghostId)),
      ),

    copy: () =>
      set((state) => {
        const clipboard = copySelection({
          nodes: state.nodes,
          edges: state.edges,
          metadata: state.metadata,
        });
        // Copying nothing must not clobber an earlier clipboard.
        return clipboard.nodes.length > 0 ? {clipboard} : {};
      }),

    paste: (offset) =>
      set((state) => {
        const {clipboard} = state;
        if (!clipboard || clipboard.nodes.length === 0) return {};
        return runGraphOp(state, (graph) =>
          pasteClipboard(graph, clipboard, offset),
        );
      }),

    takeSnapshot: () =>
      set((state) => ({history: pushPast(state.history, snapshotOf(state))})),

    dropRedundantDragSnapshot: () =>
      set((state) => {
        const {past} = state.history;
        const last = past[past.length - 1];
        if (!last || last.nodes.length !== state.nodes.length) return {};
        const moved = state.nodes.some((node) => {
          const before = last.nodes.find((n) => n.id === node.id);
          return (
            !before ||
            before.position.x !== node.position.x ||
            before.position.y !== node.position.y
          );
        });
        return moved
          ? {}
          : {history: {...state.history, past: past.slice(0, -1)}};
      }),

    undo: () =>
      set((state) => {
        const result = undoHistory(state.history, snapshotOf(state));
        if (!result) return {};
        return applySnapshot(state, result.history, result.snapshot);
      }),

    redo: () =>
      set((state) => {
        const result = redoHistory(state.history, snapshotOf(state));
        if (!result) return {};
        return applySnapshot(state, result.history, result.snapshot);
      }),

    setIntersectionCause: (causeId, measured) =>
      set((state) => ({
        nodes: state.nodes.map((node) => {
          const intersectionCause = node.id === causeId ? measured : undefined;
          if (node.data.intersectionCause === intersectionCause) return node;
          return {...node, data: {...node.data, intersectionCause}};
        }),
      })),

    setName: (name) =>
      set((state) => ({metadata: setNameOp(state.metadata, name)})),

    markVersionPublished: (version) =>
      set((state) => ({
        metadata: {
          ...state.metadata,
          latestVersionId: version.id,
          latestVersionPublishedAt: serializePublishedAt(version.publishedAt),
        },
      })),

    setCatalog: (catalog) =>
      set((state) => {
        const {nodes, validationResult} = withValidation(
          state.nodes,
          state.edges,
          state.metadata,
          catalog,
        );
        return {catalog, nodes, validationResult};
      }),

    addRole: (name) => {
      const id = crypto.randomUUID();
      // Snapshot first so creating a role is a single undoable step (and undo clears the
      // dirty flag it sets), matching every other editing action.
      set((state) => ({
        history: pushPast(state.history, snapshotOf(state)),
        metadata: addRoleOp(state.metadata, name, {createId: () => id}),
      }));
      return {id, name};
    },

    setSmartEdges: (enabled) =>
      set(() => {
        writeSmartEdgesSetting(enabled);
        return {smartEdges: enabled};
      }),
  };
});
