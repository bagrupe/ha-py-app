import {beforeEach, describe, expect, it} from 'vitest';
import {type Clipboard} from '../lib/clipboard/copy-paste.ts';
import {emptyHistory} from '../lib/history/undo-redo.ts';
import {useProzessEditorStore} from '../lib/store/index.ts';
import {type ProzessEditorProzess} from '../verfuegbare-prozesse.generated.ts';
import {loadFixtureProzess} from './load-fixtures.ts';
import {makeEdge, makeMetadata, makeNode} from './support/make-flow.ts';

/**
 * The store actions are a thin shell over the pure copy/paste utilities. The behavior that
 * only exists at the store layer is the dirty-state classification (spec §4: "Copy is not
 * dirty; paste is dirty") and the clipboard handoff, which is what these tests pin.
 */

const seed = () => {
  useProzessEditorStore.setState({
    nodes: [
      makeNode('a', {selected: true, position: {x: 0, y: 0}}),
      makeNode('b', {selected: false}),
    ],
    edges: [makeEdge('e1', 'a', 'b')],
    metadata: makeMetadata({hasVersionChanges: false}),
    history: emptyHistory(),
    clipboard: null,
  });
};

describe('store copy/paste — dirty classification + clipboard handoff', () => {
  beforeEach(seed);

  it('copy snapshots the selection without marking the version dirty', () => {
    useProzessEditorStore.getState().copy();

    const state = useProzessEditorStore.getState();
    expect(state.clipboard?.nodes.map((n) => n.id)).toEqual(['a']);
    expect(state.metadata.hasVersionChanges).toBe(false);
  });

  it('paste appends the clones, selects them, and marks the version dirty', () => {
    const store = useProzessEditorStore.getState();
    store.copy();
    store.paste({x: 40, y: 40});

    const state = useProzessEditorStore.getState();
    expect(state.nodes).toHaveLength(3);
    expect(state.nodes.filter((n) => n.selected)).toHaveLength(1);
    expect(state.nodes.find((n) => n.selected)!.id).not.toBe('a');
    expect(state.metadata.hasVersionChanges).toBe(true);
  });

  it('paste with an empty clipboard is a no-op (stays clean)', () => {
    useProzessEditorStore.getState().paste({x: 10, y: 10});

    const state = useProzessEditorStore.getState();
    expect(state.nodes).toHaveLength(2);
    expect(state.metadata.hasVersionChanges).toBe(false);
  });

  it('paste preserves an internal connection with remapped endpoints', () => {
    // AC1 calls out connections: copying two connected, selected steps must paste the
    // edge between them re-pointed at the clones, not at the originals.
    useProzessEditorStore.setState({
      nodes: [
        makeNode('a', {selected: true, position: {x: 0, y: 0}}),
        makeNode('b', {selected: true, position: {x: 100, y: 0}}),
      ],
      edges: [makeEdge('e1', 'a', 'b')],
      metadata: makeMetadata({hasVersionChanges: false}),
      history: emptyHistory(),
      clipboard: null,
    });

    const store = useProzessEditorStore.getState();
    store.copy();
    store.paste({x: 40, y: 40});

    const state = useProzessEditorStore.getState();
    expect(state.nodes).toHaveLength(4);
    expect(state.edges).toHaveLength(2);

    const pastedNodeIds = state.nodes
      .map((n) => n.id)
      .filter((id) => id !== 'a' && id !== 'b');
    const newEdge = state.edges.find((e) => e.id !== 'e1')!;
    expect(pastedNodeIds).toContain(newEdge.source);
    expect(pastedNodeIds).toContain(newEdge.target);
  });

  it('paste is a single undoable step', () => {
    const store = useProzessEditorStore.getState();
    store.copy();
    store.paste({x: 40, y: 40});
    expect(useProzessEditorStore.getState().nodes).toHaveLength(3);

    useProzessEditorStore.getState().undo();

    const state = useProzessEditorStore.getState();
    expect(state.nodes).toHaveLength(2);
    expect(state.metadata.hasVersionChanges).toBe(false);
  });
});

describe('store clipboard process-scoped on load (no cross-process leak)', () => {
  const load = (name: 'maengelmelder' | 'fuehrerschein-verlaengern') =>
    useProzessEditorStore
      .getState()
      .initializeFromProzess(
        loadFixtureProzess(name) as unknown as ProzessEditorProzess,
      );
  const stub: Clipboard = {
    nodes: [makeNode('x', {selected: false})],
    edges: [],
  };

  it('drops the clipboard when a different process is loaded', () => {
    load('maengelmelder');
    useProzessEditorStore.setState({clipboard: stub});

    load('fuehrerschein-verlaengern');

    expect(useProzessEditorStore.getState().clipboard).toBeNull();
  });

  it('keeps the clipboard across a same-process reload (the save/reinit path)', () => {
    load('maengelmelder');
    useProzessEditorStore.setState({clipboard: stub});

    load('maengelmelder');

    expect(useProzessEditorStore.getState().clipboard).toBe(stub);
  });

  it('drops the clipboard when the editor is left (load null)', () => {
    load('maengelmelder');
    useProzessEditorStore.setState({clipboard: stub});

    useProzessEditorStore.getState().initializeFromProzess(null);

    expect(useProzessEditorStore.getState().clipboard).toBeNull();
  });
});
