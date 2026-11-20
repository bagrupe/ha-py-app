import {
  type ProzessEditorFlow,
  type SchrittNode,
  type VerbindungEdge,
  type ZustaendigkeitRolle,
} from '../flow/flow.types.ts';

/**
 * The slice of editor state that participates in undo/redo. The graph (`nodes` / `edges`)
 * plus the versioned metadata a structural edit can change (`startId`, `rollen`) and the
 * dirty flag, which must be restored together with the graph (spec §202 / §294). Name and
 * latest-version metadata are deliberately excluded — they are not graph history and must
 * survive an undo unchanged.
 */
export type HistorySnapshot = {
  nodes: SchrittNode[];
  edges: VerbindungEdge[];
  startId: string | null;
  rollen: ZustaendigkeitRolle[];
  hasVersionChanges: boolean;
};

/** Past holds the states we can undo to; future holds the states a redo restores. */
export type History = {
  past: HistorySnapshot[];
  future: HistorySnapshot[];
};

/** Matches the React Flow Pro `useUndoRedo` default; oldest entries are dropped past it. */
export const DEFAULT_MAX_HISTORY = 100;

export const emptyHistory = (): History => ({past: [], future: []});

/** Projects the undoable subset out of the live flow. The node/edge arrays are stored by
 *  reference — the store only ever replaces them immutably, so a stored snapshot is never
 *  mutated after the fact. */
export const snapshotOf = (flow: ProzessEditorFlow): HistorySnapshot => ({
  nodes: flow.nodes,
  edges: flow.edges,
  startId: flow.metadata.startId,
  rollen: flow.metadata.rollen,
  hasVersionChanges: flow.metadata.hasVersionChanges,
});

/**
 * Records `present` as a new past entry and clears the redo stack — a fresh change makes
 * any previously-undone states unreachable. The past is capped at `maxHistorySize` by
 * dropping the oldest entries.
 */
export const pushPast = (
  history: History,
  present: HistorySnapshot,
  maxHistorySize = DEFAULT_MAX_HISTORY,
): History => ({
  past: [...history.past, present].slice(-maxHistorySize),
  future: [],
});

export const canUndo = (history: History): boolean => history.past.length > 0;

export const canRedo = (history: History): boolean => history.future.length > 0;

/**
 * Steps one entry back. Returns the snapshot to restore and the new history with the current
 * `present` pushed onto the redo stack, or `null` when there is nothing to undo.
 */
export const undo = (
  history: History,
  present: HistorySnapshot,
): {history: History; snapshot: HistorySnapshot} | null => {
  if (history.past.length === 0) return null;
  const snapshot = history.past[history.past.length - 1];
  return {
    history: {
      past: history.past.slice(0, -1),
      future: [...history.future, present],
    },
    snapshot,
  };
};

/**
 * Steps one entry forward — the mirror of {@link undo}. Returns the snapshot to restore and
 * the new history with the current `present` pushed back onto the past stack, or `null` when
 * there is nothing to redo.
 */
export const redo = (
  history: History,
  present: HistorySnapshot,
): {history: History; snapshot: HistorySnapshot} | null => {
  if (history.future.length === 0) return null;
  const snapshot = history.future[history.future.length - 1];
  return {
    history: {
      past: [...history.past, present],
      future: history.future.slice(0, -1),
    },
    snapshot,
  };
};
