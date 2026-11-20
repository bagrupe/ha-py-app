import {describe, expect, it} from 'vitest';
import {
  canRedo,
  canUndo,
  emptyHistory,
  type History,
  type HistorySnapshot,
  pushPast,
  redo,
  snapshotOf,
  undo,
} from '../lib/history/undo-redo.ts';
import {makeEdge, makeFlow, makeNode} from './support/make-flow.ts';

/**
 * The undo/redo history is a pure model, ported from the React Flow Pro `useUndoRedo`
 * template but adapted to the KommunalApp editor. The Pro template snapshots `{nodes, edges}`
 * only; here a snapshot ALSO carries the versioned metadata that a structural edit can change
 * (`startId`, `rollen`) and the dirty flag, which must be restored together with the graph
 * (spec §202 / §294). Name and latest-version metadata are deliberately excluded — they are
 * not graph history. These tests pin "how the graph looks after undo/redo" before the store
 * or the editor template depend on it.
 */

const snap = (
  nodeIds: string[],
  edges: [string, string, string][] = [],
  metadata: Parameters<typeof makeFlow>[2] = {},
): HistorySnapshot =>
  snapshotOf(
    makeFlow(
      nodeIds.map((id) => makeNode(id)),
      edges.map(([id, source, target]) => makeEdge(id, source, target)),
      metadata,
    ),
  );

describe('snapshotOf — what the graph history captures', () => {
  it('captures the graph plus the versioned metadata (startId, rollen, dirty)', () => {
    const flow = makeFlow([makeNode('a')], [], {
      startId: 'a',
      rollen: [{id: 'r1', name: 'Sachbearbeiter'}],
      hasVersionChanges: true,
    });

    const result = snapshotOf(flow);

    expect(result.nodes.map((n) => n.id)).toEqual(['a']);
    expect(result.startId).toBe('a');
    expect(result.rollen).toEqual([{id: 'r1', name: 'Sachbearbeiter'}]);
    expect(result.hasVersionChanges).toBe(true);
  });

  it('excludes name and latest-version metadata (not graph history)', () => {
    const flow = makeFlow([], [], {
      name: 'Mein Prozess',
      latestVersionId: 'v1',
      latestVersionPublishedAt: '2020-01-01',
    });

    const result = snapshotOf(flow);

    expect(result).not.toHaveProperty('name');
    expect(result).not.toHaveProperty('latestVersionId');
    expect(result).not.toHaveProperty('latestVersionPublishedAt');
  });
});

describe('pushPast — recording an undoable change', () => {
  it('records the present on the past stack', () => {
    const history = pushPast(emptyHistory(), snap(['a']));

    expect(history.past).toHaveLength(1);
    expect(history.past[0].nodes.map((n) => n.id)).toEqual(['a']);
  });

  it('clears the redo stack — a new change invalidates redo', () => {
    const history: History = {past: [snap(['a'])], future: [snap(['b'])]};

    const next = pushPast(history, snap(['c']));

    expect(next.future).toEqual([]);
  });

  it('caps the past at maxHistorySize, dropping the oldest entries', () => {
    let history = emptyHistory();
    for (let i = 0; i < 5; i++) {
      history = pushPast(history, snap([`n${i}`]), 3);
    }

    expect(history.past).toHaveLength(3);
    expect(history.past.map((p) => p.nodes[0].id)).toEqual(['n2', 'n3', 'n4']);
  });

  it('does not mutate the input history', () => {
    const history = emptyHistory();

    pushPast(history, snap(['a']));

    expect(history.past).toEqual([]);
    expect(history.future).toEqual([]);
  });
});

describe('undo — stepping back', () => {
  it('returns the last past snapshot and moves the present onto the redo stack', () => {
    const history: History = {past: [snap(['a'])], future: []};
    const present = snap(['a', 'b']);

    const result = undo(history, present)!;

    expect(result.snapshot.nodes.map((n) => n.id)).toEqual(['a']);
    expect(result.history.past).toEqual([]);
    expect(result.history.future.map((f) => f.nodes.map((n) => n.id))).toEqual([
      ['a', 'b'],
    ]);
  });

  it('returns null when there is nothing to undo', () => {
    expect(undo(emptyHistory(), snap(['a']))).toBeNull();
  });
});

describe('redo — stepping forward', () => {
  it('returns the last future snapshot and moves the present onto the past stack', () => {
    const history: History = {past: [], future: [snap(['a', 'b'])]};
    const present = snap(['a']);

    const result = redo(history, present)!;

    expect(result.snapshot.nodes.map((n) => n.id)).toEqual(['a', 'b']);
    expect(result.history.future).toEqual([]);
    expect(result.history.past.map((p) => p.nodes.map((n) => n.id))).toEqual([
      ['a'],
    ]);
  });

  it('returns null when there is nothing to redo', () => {
    expect(redo(emptyHistory(), snap(['a']))).toBeNull();
  });
});

describe('canUndo / canRedo — stack availability', () => {
  it('is false on an empty history', () => {
    expect(canUndo(emptyHistory())).toBe(false);
    expect(canRedo(emptyHistory())).toBe(false);
  });

  it('reflects the available stacks', () => {
    expect(canUndo({past: [snap(['a'])], future: []})).toBe(true);
    expect(canRedo({past: [], future: [snap(['a'])]})).toBe(true);
  });
});

describe('undo → redo round-trip — how the graph looks after stepping', () => {
  it('restores the prior graph and dirty flag on undo, then re-applies on redo', () => {
    // Clean graph {a} → a structural edit connects {a, b} and marks the version dirty.
    const before = snap(['a'], [], {hasVersionChanges: false});
    const after = snap(['a', 'b'], [['e', 'a', 'b']], {
      hasVersionChanges: true,
    });

    let history = pushPast(emptyHistory(), before);

    const undone = undo(history, after)!;
    expect(undone.snapshot.nodes.map((n) => n.id)).toEqual(['a']);
    expect(undone.snapshot.edges).toHaveLength(0);
    expect(undone.snapshot.hasVersionChanges).toBe(false);

    history = undone.history;

    const redone = redo(history, undone.snapshot)!;
    expect(redone.snapshot.nodes.map((n) => n.id)).toEqual(['a', 'b']);
    expect(redone.snapshot.edges.map((e) => e.id)).toEqual(['e']);
    expect(redone.snapshot.hasVersionChanges).toBe(true);
  });
});
