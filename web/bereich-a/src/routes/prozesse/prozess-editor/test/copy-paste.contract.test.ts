import cloneDeep from 'lodash/cloneDeep';
import {describe, expect, it} from 'vitest';
import {copySelection, pasteClipboard} from '../lib/clipboard/copy-paste.ts';
import {type SchrittNode} from '../lib/flow/flow.types.ts';
import {makeEdge, makeFlow, makeNode, seqIds} from './support/make-flow.ts';

/**
 * Copy/paste utilities are pure. `copySelection(graph)` answers "what enters the
 * clipboard payload"; `pasteClipboard(graph, clipboard, offset)` answers "how the
 * payload behaves on paste". Both are exercised over SYNTHETIC graphs, mirroring the
 * graph-op contract tests. Paste reuses the same id-regeneration adapter as
 * `duplicateSubgraph`, so a pasted subgraph never duplicates step/field/connection ids.
 */

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const stepData = (node: SchrittNode): any => node.data.schritt;

describe('copySelection — what enters the clipboard payload', () => {
  it('captures only the selected nodes', () => {
    const flow = makeFlow(
      [
        makeNode('a', {selected: true}),
        makeNode('b', {selected: true}),
        makeNode('c', {selected: false}),
      ],
      [],
    );

    const clipboard = copySelection(flow);

    expect(clipboard.nodes.map((n) => n.id)).toEqual(['a', 'b']);
  });

  it('captures internal edges (both endpoints selected) and drops crossing edges', () => {
    const flow = makeFlow(
      [
        makeNode('a', {selected: true}),
        makeNode('b', {selected: true}),
        makeNode('outside', {selected: false}),
      ],
      [
        makeEdge('internal', 'a', 'b'),
        makeEdge('crossing-out', 'b', 'outside'),
        makeEdge('crossing-in', 'outside', 'a'),
      ],
    );

    const clipboard = copySelection(flow);

    expect(clipboard.edges.map((e) => e.id)).toEqual(['internal']);
  });

  it('excludes ghost nodes even when selected, and edges incident to them', () => {
    const flow = makeFlow(
      [
        makeNode('a', {selected: true}),
        makeNode('GHOST-1', {
          selected: true,
          schritt: {
            __typename: 'GhostSchritt',
            titel: 'Platzhalter',
            slots: [],
          } as unknown as Partial<SchrittNode['data']['schritt']>,
        }),
      ],
      [makeEdge('a-ghost', 'a', 'GHOST-1')],
    );

    const clipboard = copySelection(flow);

    expect(clipboard.nodes.map((n) => n.id)).toEqual(['a']);
    expect(clipboard.edges).toHaveLength(0);
  });

  it('clears selection state in the payload (clean snapshot)', () => {
    const flow = makeFlow(
      [makeNode('a', {selected: true}), makeNode('b', {selected: true})],
      [makeEdge('e1', 'a', 'b')],
    );
    flow.edges[0].selected = true;

    const clipboard = copySelection(flow);

    expect(clipboard.nodes.every((n) => !n.selected)).toBe(true);
    expect(clipboard.edges.every((e) => !e.selected)).toBe(true);
  });

  it('preserves the original ids (the payload is a snapshot, not a clone)', () => {
    const flow = makeFlow([makeNode('a', {selected: true})], []);

    const clipboard = copySelection(flow);

    expect(clipboard.nodes[0].id).toBe('a');
    expect(stepData(clipboard.nodes[0]).id).toBe('a');
  });

  it('strips view-only node data (selection, measured, isStart, errors, intersection)', () => {
    const flow = makeFlow(
      [makeNode('a', {selected: true, measured: {width: 150, height: 70}})],
      [],
    );
    flow.nodes[0].data.isStart = true;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (flow.nodes[0].data as any).errors = [{message: 'x'}];
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    (flow.nodes[0].data as any).intersectionCause = {width: 1, height: 1};

    const node = copySelection(flow).nodes[0];

    expect(node.measured).toBeUndefined();
    expect(node.data.isStart).toBeFalsy();
    expect(node.data).not.toHaveProperty('errors');
    expect(node.data).not.toHaveProperty('intersectionCause');
  });

  it('decouples the payload from the live graph (deep snapshot)', () => {
    const flow = makeFlow(
      [makeNode('a', {selected: true, schritt: {titel: 'Original'}})],
      [],
    );

    const clipboard = copySelection(flow);
    stepData(clipboard.nodes[0]).titel = 'Mutated in clipboard';

    expect(stepData(flow.nodes[0]).titel).toBe('Original');
  });

  it('returns an empty clipboard when nothing is selected', () => {
    const flow = makeFlow(
      [makeNode('a'), makeNode('b')],
      [makeEdge('e1', 'a', 'b')],
    );

    const clipboard = copySelection(flow);

    expect(clipboard.nodes).toHaveLength(0);
    expect(clipboard.edges).toHaveLength(0);
  });

  it('does not mutate the input graph', () => {
    const flow = makeFlow(
      [makeNode('a', {selected: true}), makeNode('b', {selected: true})],
      [makeEdge('e1', 'a', 'b')],
    );
    const snapshot = cloneDeep(flow);

    copySelection(flow);

    expect(flow).toEqual(snapshot);
  });
});

describe('pasteClipboard — how the payload behaves on paste', () => {
  it('regenerates node ids, step ids, form field ids, and connection ids', () => {
    const source = makeFlow(
      [
        makeNode('n1', {
          selected: true,
          schritt: {
            felder: [
              {id: 'f1', __typename: 'StringFormularFeld', order: 0},
              {id: 'f2', __typename: 'StringFormularFeld', order: 1},
            ],
          } as unknown as Partial<SchrittNode['data']['schritt']>,
        }),
        makeNode('n2', {selected: true}),
      ],
      [makeEdge('e1', 'n1', 'n2')],
    );
    const clipboard = copySelection(source);

    const next = pasteClipboard(
      makeFlow([], []),
      clipboard,
      {x: 40, y: 40},
      {createId: seqIds('n1c', 'f1c', 'f2c', 'n2c', 'e1c')},
    );

    expect(next.nodes.map((n) => n.id)).toEqual(['n1c', 'n2c']);
    const clone1 = next.nodes.find((n) => n.id === 'n1c')!;
    expect(stepData(clone1).id).toBe('n1c');
    expect(stepData(clone1).felder.map((f: {id: string}) => f.id)).toEqual([
      'f1c',
      'f2c',
    ]);
    expect(next.edges.map((e) => e.id)).toEqual(['e1c']);
  });

  it('offsets the pasted positions relative to the copied nodes', () => {
    const source = makeFlow(
      [makeNode('a', {selected: true, position: {x: 100, y: 200}})],
      [],
    );
    const clipboard = copySelection(source);

    const next = pasteClipboard(
      makeFlow([], []),
      clipboard,
      {x: 30, y: 40},
      {
        createId: seqIds('aC'),
      },
    );

    expect(next.nodes.find((n) => n.id === 'aC')!.position).toEqual({
      x: 130,
      y: 240,
    });
  });

  it('remaps internal edges to the cloned nodes', () => {
    const source = makeFlow(
      [makeNode('a', {selected: true}), makeNode('b', {selected: true})],
      [makeEdge('e1', 'a', 'b')],
    );
    const clipboard = copySelection(source);

    const next = pasteClipboard(
      makeFlow([], []),
      clipboard,
      {x: 10, y: 10},
      {
        createId: seqIds('aC', 'bC', 'eC'),
      },
    );

    const edge = next.edges.find((e) => e.id === 'eC')!;
    expect(edge.source).toBe('aC');
    expect(edge.target).toBe('bC');
  });

  it('remaps internal step-reference fields and clears external references', () => {
    const source = makeFlow(
      [
        makeNode('bezahlen', {
          selected: true,
          schritt: {
            __typename: 'BezahlenSchritt',
            betrag: 10,
          } as unknown as Partial<SchrittNode['data']['schritt']>,
        }),
        makeNode('warte', {
          selected: true,
          schritt: {
            __typename: 'WarteAufBezahlungAbgeschlossenSchritt',
            bezahlenSchrittId: 'bezahlen',
          } as unknown as Partial<SchrittNode['data']['schritt']>,
        }),
        makeNode('warteExternal', {
          selected: true,
          schritt: {
            __typename: 'WarteAufBezahlungAbgeschlossenSchritt',
            bezahlenSchrittId: 'bezahlen-external',
          } as unknown as Partial<SchrittNode['data']['schritt']>,
        }),
      ],
      [],
    );
    const clipboard = copySelection(source);

    const next = pasteClipboard(
      makeFlow([], []),
      clipboard,
      {x: 20, y: 20},
      {
        createId: seqIds('bezahlenC', 'warteC', 'warteExtC'),
      },
    );

    expect(
      stepData(next.nodes.find((n) => n.id === 'warteC')!).bezahlenSchrittId,
    ).toBe('bezahlenC');
    expect(
      stepData(next.nodes.find((n) => n.id === 'warteExtC')!).bezahlenSchrittId,
    ).toBe('');
  });

  it('selects the pasted elements and deselects the existing graph', () => {
    const source = makeFlow(
      [makeNode('a', {selected: true}), makeNode('b', {selected: true})],
      [makeEdge('e1', 'a', 'b')],
    );
    const clipboard = copySelection(source);

    const graph = makeFlow(
      [makeNode('existing', {selected: true})],
      [makeEdge('existing-edge', 'existing', 'existing')],
    );
    graph.edges[0].selected = true;

    const next = pasteClipboard(
      graph,
      clipboard,
      {x: 10, y: 10},
      {
        createId: seqIds('aC', 'bC', 'eC'),
      },
    );

    expect(next.nodes.find((n) => n.id === 'existing')!.selected).toBe(false);
    expect(next.edges.find((e) => e.id === 'existing-edge')!.selected).toBe(
      false,
    );
    expect(next.nodes.find((n) => n.id === 'aC')!.selected).toBe(true);
    expect(next.nodes.find((n) => n.id === 'bC')!.selected).toBe(true);
    expect(next.edges.find((e) => e.id === 'eC')!.selected).toBe(true);
  });

  it('appends the clones to the existing graph', () => {
    const source = makeFlow([makeNode('a', {selected: true})], []);
    const clipboard = copySelection(source);

    const graph = makeFlow(
      [makeNode('keep1'), makeNode('keep2')],
      [makeEdge('keepEdge', 'keep1', 'keep2')],
    );

    const next = pasteClipboard(
      graph,
      clipboard,
      {x: 10, y: 10},
      {
        createId: seqIds('aC'),
      },
    );

    expect(next.nodes.map((n) => n.id)).toEqual(['keep1', 'keep2', 'aC']);
    expect(next.edges.map((e) => e.id)).toEqual(['keepEdge']);
  });

  it('produces distinct ids on each paste and leaves the clipboard reusable', () => {
    const source = makeFlow([makeNode('a', {selected: true})], []);
    const clipboard = copySelection(source);
    const clipboardSnapshot = cloneDeep(clipboard);

    let graph = makeFlow([], []);
    graph = pasteClipboard(
      graph,
      clipboard,
      {x: 10, y: 10},
      {
        createId: seqIds('paste1'),
      },
    );
    graph = pasteClipboard(
      graph,
      clipboard,
      {x: 20, y: 20},
      {
        createId: seqIds('paste2'),
      },
    );

    expect(graph.nodes.map((n) => n.id)).toEqual(['paste1', 'paste2']);
    expect(clipboard).toEqual(clipboardSnapshot);
  });

  it('is a no-op for an empty clipboard', () => {
    const graph = makeFlow(
      [makeNode('a', {selected: true})],
      [makeEdge('e1', 'a', 'a')],
    );

    const next = pasteClipboard(graph, {nodes: [], edges: []}, {x: 10, y: 10});

    expect(next.nodes).toEqual(graph.nodes);
    expect(next.edges).toEqual(graph.edges);
  });

  it('does not mutate the input graph or the clipboard', () => {
    const source = makeFlow(
      [makeNode('a', {selected: true}), makeNode('b', {selected: true})],
      [makeEdge('e1', 'a', 'b')],
    );
    const clipboard = copySelection(source);
    const clipboardSnapshot = cloneDeep(clipboard);

    const graph = makeFlow([makeNode('existing', {selected: true})], []);
    const graphSnapshot = cloneDeep(graph);

    pasteClipboard(
      graph,
      clipboard,
      {x: 10, y: 10},
      {
        createId: seqIds('aC', 'bC', 'eC'),
      },
    );

    expect(graph).toEqual(graphSnapshot);
    expect(clipboard).toEqual(clipboardSnapshot);
  });
});

describe('copy → paste round-trip', () => {
  it('duplicates the selected subgraph into the graph with fresh, selected clones', () => {
    const graph = makeFlow(
      [
        makeNode('a', {selected: true, position: {x: 0, y: 0}}),
        makeNode('b', {selected: true, position: {x: 0, y: 100}}),
      ],
      [makeEdge('a-b', 'a', 'b')],
    );

    const clipboard = copySelection(graph);
    const next = pasteClipboard(
      graph,
      clipboard,
      {x: 40, y: 40},
      {
        createId: seqIds('aC', 'bC', 'abC'),
      },
    );

    expect(next.nodes.map((n) => n.id)).toEqual(['a', 'b', 'aC', 'bC']);
    expect(next.edges.map((e) => e.id)).toEqual(['a-b', 'abC']);
    const clonedEdge = next.edges.find((e) => e.id === 'abC')!;
    expect(clonedEdge.source).toBe('aC');
    expect(clonedEdge.target).toBe('bC');
    expect(next.nodes.find((n) => n.id === 'a')!.selected).toBe(false);
    expect(next.nodes.find((n) => n.id === 'aC')!.selected).toBe(true);
  });
});
