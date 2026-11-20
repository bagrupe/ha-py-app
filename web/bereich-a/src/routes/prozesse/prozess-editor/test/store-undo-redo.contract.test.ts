import {beforeEach, describe, expect, it} from 'vitest';
import {emptyHistory} from '../lib/history/undo-redo.ts';
import {useProzessEditorStore} from '../lib/store/index.ts';
import {makeMetadata, makeNode} from './support/make-flow.ts';

/**
 * The store wires the pure history model (`lib/history/undo-redo.ts`) into the live editor.
 * The behavior that only exists at the store layer is what these tests pin: which actions
 * record an undoable step, that undo/redo restore the graph AND the dirty flag consistently
 * (spec §202), that name/version metadata survive an undo (spec §294), and that loading a
 * process resets the history.
 */

const seed = () => {
  useProzessEditorStore.setState({
    nodes: [makeNode('a'), makeNode('b')],
    edges: [],
    metadata: makeMetadata({name: 'Mein Prozess', hasVersionChanges: false}),
    history: emptyHistory(),
    clipboard: null,
  });
};

describe('store undo/redo — history wiring', () => {
  beforeEach(seed);

  it('records a graph edit and undo restores the prior graph and clean state', () => {
    const store = useProzessEditorStore.getState();
    store.connect({source: 'a', target: 'b'});

    let state = useProzessEditorStore.getState();
    expect(state.edges).toHaveLength(1);
    expect(state.metadata.hasVersionChanges).toBe(true);
    expect(state.history.past).toHaveLength(1);

    useProzessEditorStore.getState().undo();

    state = useProzessEditorStore.getState();
    expect(state.edges).toHaveLength(0);
    expect(state.metadata.hasVersionChanges).toBe(false);
  });

  it('redo re-applies the undone edit (graph and dirty flag)', () => {
    const store = useProzessEditorStore.getState();
    store.connect({source: 'a', target: 'b'});
    useProzessEditorStore.getState().undo();
    useProzessEditorStore.getState().redo();

    const state = useProzessEditorStore.getState();
    expect(state.edges).toHaveLength(1);
    expect(state.metadata.hasVersionChanges).toBe(true);
  });

  it('undo is a no-op when there is nothing to undo', () => {
    useProzessEditorStore.getState().undo();

    const state = useProzessEditorStore.getState();
    expect(state.nodes).toHaveLength(2);
    expect(state.edges).toHaveLength(0);
    expect(state.metadata.hasVersionChanges).toBe(false);
  });

  it('undo does not revert the process name (name is not graph history)', () => {
    const store = useProzessEditorStore.getState();
    store.connect({source: 'a', target: 'b'});
    useProzessEditorStore.getState().setName('Umbenannt');

    useProzessEditorStore.getState().undo();

    const state = useProzessEditorStore.getState();
    expect(state.edges).toHaveLength(0);
    expect(state.metadata.name).toBe('Umbenannt');
  });

  it('takeSnapshot makes a following non-runGraphOp change undoable (drag/delete path)', () => {
    const store = useProzessEditorStore.getState();
    store.takeSnapshot();
    useProzessEditorStore.getState().onNodesChange([{type: 'remove', id: 'b'}]);

    let state = useProzessEditorStore.getState();
    expect(state.nodes.map((n) => n.id)).toEqual(['a']);

    useProzessEditorStore.getState().undo();

    state = useProzessEditorStore.getState();
    expect(state.nodes.map((n) => n.id)).toEqual(['a', 'b']);
  });

  it('records role creation and undo removes the role and restores clean state', () => {
    const store = useProzessEditorStore.getState();
    const role = store.addRole('Sachbearbeiter');

    let state = useProzessEditorStore.getState();
    expect(state.metadata.rollen.map((r) => r.id)).toContain(role.id);
    expect(state.metadata.hasVersionChanges).toBe(true);
    expect(state.history.past).toHaveLength(1);

    useProzessEditorStore.getState().undo();

    state = useProzessEditorStore.getState();
    expect(state.metadata.rollen).toHaveLength(0);
    expect(state.metadata.hasVersionChanges).toBe(false);
  });

  it('drops a drag snapshot that produced no net position change', () => {
    const store = useProzessEditorStore.getState();
    store.takeSnapshot();
    expect(useProzessEditorStore.getState().history.past).toHaveLength(1);

    // Drag started and ended in the same spot — nothing actually moved.
    useProzessEditorStore.getState().dropRedundantDragSnapshot();

    expect(useProzessEditorStore.getState().history.past).toHaveLength(0);
  });

  it('keeps a drag snapshot when a node actually moved', () => {
    const store = useProzessEditorStore.getState();
    store.takeSnapshot();
    useProzessEditorStore
      .getState()
      .onNodesChange([{type: 'position', id: 'a', position: {x: 120, y: 80}}]);

    useProzessEditorStore.getState().dropRedundantDragSnapshot();

    expect(useProzessEditorStore.getState().history.past).toHaveLength(1);
  });

  it('a new edit after an undo clears the redo stack', () => {
    const store = useProzessEditorStore.getState();
    store.connect({source: 'a', target: 'b'});
    useProzessEditorStore.getState().undo();
    expect(useProzessEditorStore.getState().history.future).toHaveLength(1);

    useProzessEditorStore.getState().connect({source: 'b', target: 'a'});

    expect(useProzessEditorStore.getState().history.future).toHaveLength(0);
  });

  it('initializeFromProzess resets the history (no undo across a load)', () => {
    useProzessEditorStore.getState().connect({source: 'a', target: 'b'});
    expect(useProzessEditorStore.getState().history.past).toHaveLength(1);

    useProzessEditorStore.getState().initializeFromProzess(null);

    const state = useProzessEditorStore.getState();
    expect(state.history.past).toHaveLength(0);
    expect(state.history.future).toHaveLength(0);
  });
});
