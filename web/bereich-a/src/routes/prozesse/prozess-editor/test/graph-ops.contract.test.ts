import cloneDeep from 'lodash/cloneDeep';
import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type SchrittNode, type VerbindungEdge} from '../lib/flow/flow.types.ts';
import {
  addStep,
  attachGhost,
  connect,
  deleteSelection,
  detachToGhost,
  duplicateSubgraph,
  reconnect,
  updateConnectionData,
  updateStepData,
} from '../lib/graph/graph-ops.ts';
import {verbindungZuInput} from '../lib/input-converters.ts';
import {makeEdge, makeFlow, makeNode, seqIds} from './support/make-flow.ts';

/**
 * Graph ops are pure `(graph, args) => graph`. Tested over SYNTHETIC graphs
 * because ghosts are editor-only and never appear in the GraphQL fixtures.
 */

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const stepData = (node: SchrittNode): any => node.data.schritt;

const automatisierung = (edge: VerbindungEdge): boolean =>
  edge.data?.automatisierung ?? false;

describe('Layer 1 — graph operations', () => {
  it('all ops return new graph objects and never mutate their inputs', () => {
    const flow = makeFlow(
      [
        makeNode('a', {position: {x: 0, y: 0}}),
        makeNode('b', {position: {x: 200, y: 0}}),
      ],
      [makeEdge('e1', 'a', 'b')],
    );
    const snapshot = cloneDeep(flow);

    addStep(
      flow,
      {__typename: 'EndeSchritt', titel: 'Ende'},
      {x: 50, y: 50},
      {
        createId: seqIds('new-step'),
      },
    );
    connect(flow, {source: 'a', target: 'b'}, {createId: seqIds('new-edge')});
    reconnect(flow, 'e1', {source: 'b', target: 'a'});
    updateStepData(flow, 'a', {titel: 'Geändert'}, flow.metadata);
    updateConnectionData(flow, 'e1', {name: 'Label'});
    deleteSelection(flow, {nodes: [], edges: [flow.edges[0]]});
    detachToGhost(
      flow,
      'a',
      {width: 120, height: 60},
      {
        createId: seqIds('ghost'),
      },
    );

    expect(flow).toEqual(snapshot);
  });

  describe('addStep', () => {
    it('adds a node at the given position with a generated id (injectable factory)', () => {
      const flow = makeFlow([makeNode('a')], []);

      const next = addStep(
        flow,
        {__typename: 'EndeSchritt', titel: 'Ende'},
        {x: 320, y: 140},
        {createId: seqIds('generated-id')},
      );

      expect(next.nodes).toHaveLength(2);
      const added = next.nodes.find((n) => n.id === 'generated-id')!;
      expect(added).toBeDefined();
      expect(added.position).toEqual({x: 320, y: 140});
      expect(stepData(added).id).toBe('generated-id');
      expect(stepData(added).__typename).toBe('EndeSchritt');
      expect(stepData(added).titel).toBe('Ende');
    });
  });

  describe('connect', () => {
    it('creates a default Verbindung with istRelevant "true"', () => {
      const flow = makeFlow([makeNode('a'), makeNode('b')], []);

      const next = connect(
        flow,
        {source: 'a', target: 'b'},
        {createId: seqIds('edge-1')},
      );

      expect(next.edges).toHaveLength(1);
      const edge = next.edges[0];
      expect(edge.id).toBe('edge-1');
      expect(edge.source).toBe('a');
      expect(edge.target).toBe('b');
      expect(edge.data!.verbindung).toEqual({
        name: null,
        statusAenderung: null,
        statusAenderungBeschreibung: null,
        istRelevant: 'true',
      });
    });

    it('derives edge label/automation from the source node', () => {
      const flow = makeFlow(
        [
          makeNode('prog', {
            schritt: {
              __typename: 'ProgrammatischerSchritt',
              implementationAssemblyQualifiedName: 'Some.Type',
            } as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('form'),
          makeNode('target'),
        ],
        [],
      );

      const fromProg = connect(
        flow,
        {source: 'prog', target: 'target'},
        {createId: seqIds('e-prog')},
      ).edges[0];
      expect(automatisierung(fromProg)).toBe(true);
      // no name → label falls back to istRelevant when automated
      expect(fromProg.label).toBe('true');

      const fromForm = connect(
        flow,
        {source: 'form', target: 'target'},
        {createId: seqIds('e-form')},
      ).edges[0];
      expect(automatisierung(fromForm)).toBe(false);
      expect(fromForm.label).toBeNull();
    });
  });

  describe('reconnect', () => {
    it('updates only source/target and recomputes derived automation/label', () => {
      const flow = makeFlow(
        [
          makeNode('form'),
          makeNode('prog', {
            schritt: {
              __typename: 'ProgrammatischerSchritt',
              implementationAssemblyQualifiedName: 'Some.Type',
            } as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('target'),
        ],
        [makeEdge('e1', 'form', 'target', {name: null})],
      );

      const next = reconnect(flow, 'e1', {source: 'prog', target: 'target'});
      const edge = next.edges[0];

      expect(edge.source).toBe('prog');
      expect(edge.target).toBe('target');
      expect(edge.data!.verbindung.istRelevant).toBe('true');
      expect(automatisierung(edge)).toBe(true);
      expect(edge.label).toBe('true');
    });
  });

  describe('updateStepData', () => {
    it('patches editable step fields', () => {
      const flow = makeFlow([makeNode('a', {schritt: {titel: 'Alt'}})], []);

      const next = updateStepData(
        flow,
        'a',
        {titel: 'Neu', anweisung: 'Hinweis'},
        flow.metadata,
      );

      const node = next.nodes.find((n) => n.id === 'a')!;
      expect(stepData(node).titel).toBe('Neu');
      expect(stepData(node).anweisung).toBe('Hinweis');
    });

    it('clears liestRolleId when sollZustaendigkeit.art is not Dynamisch', () => {
      const flow = makeFlow(
        [
          makeNode('a', {
            schritt: {
              sollZustaendigkeit: {
                art: ZustaendigkeitArt.Dynamisch,
                dynamischeArten: [],
                liestRolleId: 'role-1',
              },
            } as Partial<SchrittNode['data']['schritt']>,
          }),
        ],
        [],
        {rollen: [{id: 'role-1', name: 'Sachbearbeiter'}]},
      );

      const next = updateStepData(
        flow,
        'a',
        {
          sollZustaendigkeit: {
            art: ZustaendigkeitArt.Buerger,
            dynamischeArten: [],
            liestRolleId: 'role-1',
          },
        } as Parameters<typeof updateStepData>[2],
        flow.metadata,
      );

      const node = next.nodes.find((n) => n.id === 'a')!;
      expect(stepData(node).sollZustaendigkeit.art).toBe(
        ZustaendigkeitArt.Buerger,
      );
      expect(stepData(node).sollZustaendigkeit.liestRolleId).toBeNull();
    });

    it('keeps liestRolleId when sollZustaendigkeit.art is Dynamisch', () => {
      const flow = makeFlow(
        [
          makeNode('a', {
            schritt: {
              sollZustaendigkeit: {
                art: ZustaendigkeitArt.Buerger,
                dynamischeArten: [],
              },
            } as Partial<SchrittNode['data']['schritt']>,
          }),
        ],
        [],
      );

      const next = updateStepData(
        flow,
        'a',
        {
          sollZustaendigkeit: {
            art: ZustaendigkeitArt.Dynamisch,
            dynamischeArten: [ZustaendigkeitArt.Buerger],
            liestRolleId: 'role-1',
          },
        } as Parameters<typeof updateStepData>[2],
        flow.metadata,
      );

      const node = next.nodes.find((n) => n.id === 'a')!;
      expect(stepData(node).sollZustaendigkeit.liestRolleId).toBe('role-1');
    });
  });

  describe('updateConnectionData', () => {
    it('applies an explicit null to clear a field and recomputes the label', () => {
      const flow = makeFlow(
        [makeNode('a'), makeNode('b')],
        [
          makeEdge('e1', 'a', 'b', {
            name: 'Alt',
            statusAenderung: 'Titel',
            statusAenderungBeschreibung: 'Beschreibung',
            istRelevant: 'true',
          }),
        ],
      );

      const next = updateConnectionData(flow, 'e1', {
        name: null,
        statusAenderung: null,
        statusAenderungBeschreibung: null,
      });

      const {verbindung} = next.edges[0].data!;
      expect(verbindung.name).toBeNull();
      expect(verbindung.statusAenderung).toBeNull();
      expect(verbindung.statusAenderungBeschreibung).toBeNull();
      expect(verbindung.istRelevant).toBe('true');
      expect(next.edges[0].label).toBeNull();
    });

    it('leaves a field untouched when its patch key is undefined', () => {
      const flow = makeFlow(
        [makeNode('a'), makeNode('b')],
        [makeEdge('e1', 'a', 'b', {name: 'Alt', statusAenderung: 'Titel'})],
      );

      const next = updateConnectionData(flow, 'e1', {
        name: 'Neu',
        statusAenderung: undefined,
      });

      const {verbindung} = next.edges[0].data!;
      expect(verbindung.name).toBe('Neu');
      expect(verbindung.statusAenderung).toBe('Titel');
      expect(next.edges[0].label).toBe('Neu');
    });

    it('serializes a cleared field as null in the version input', () => {
      const flow = makeFlow(
        [makeNode('a'), makeNode('b')],
        [makeEdge('e1', 'a', 'b', {statusAenderung: 'Titel'})],
      );

      const cleared = updateConnectionData(flow, 'e1', {statusAenderung: null});
      const {verbindung} = cleared.edges[0].data!;

      const input = verbindungZuInput({
        ...verbindung,
        id: 'e1',
        vonId: 'a',
        nachId: 'b',
      });
      expect(input.statusAenderung).toBeNull();
    });
  });

  describe('deleteSelection', () => {
    it('preserves current single-selection delete semantics', () => {
      const flow = makeFlow(
        [makeNode('a'), makeNode('b'), makeNode('c')],
        [makeEdge('e1', 'a', 'b'), makeEdge('e2', 'b', 'c')],
      );

      const isolated = makeFlow([makeNode('lonely')], []);
      const afterNode = deleteSelection(isolated, {
        nodes: [isolated.nodes[0]],
        edges: [],
      });
      expect(afterNode.nodes).toHaveLength(0);

      const afterEdge = deleteSelection(flow, {
        nodes: [],
        edges: [flow.edges[0]],
      });
      expect(afterEdge.edges.map((e) => e.id)).toEqual(['e2']);
      expect(afterEdge.nodes).toHaveLength(3);

      const ghostFlow = makeFlow(
        [
          makeNode('GHOST-1', {
            schritt: {
              __typename: 'GhostSchritt',
              titel: 'Platzhalter',
              slots: [],
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('b'),
        ],
        [makeEdge('e1', 'GHOST-1', 'b')],
      );
      const afterGhost = deleteSelection(ghostFlow, {
        nodes: [ghostFlow.nodes[0]],
        edges: [ghostFlow.edges[0]],
      });
      expect(afterGhost.nodes.map((n) => n.id)).toEqual(['b']);
      expect(afterGhost.edges).toHaveLength(0);

      const afterDetach = deleteSelection(flow, {
        nodes: [flow.nodes[1]],
        edges: [flow.edges[0]],
      });
      expect(afterDetach.nodes.some((n) => n.id === 'b')).toBe(true);
      expect(
        afterDetach.nodes.some(
          (n) => stepData(n).__typename === 'GhostSchritt',
        ),
      ).toBe(true);
    });

    it('multi-select delete stays disabled until #199 defines a policy', () => {
      const flow = makeFlow([makeNode('a'), makeNode('b')], []);
      const snapshot = cloneDeep(flow);

      const next = deleteSelection(flow, {
        nodes: [flow.nodes[0], flow.nodes[1]],
        edges: [],
      });

      expect(next.nodes.map((n) => n.id)).toEqual(['a', 'b']);
      expect(flow).toEqual(snapshot);
    });
  });

  describe('detachToGhost', () => {
    it('inserts one ghost, rewires all incident edges from the step to the ghost', () => {
      const flow = makeFlow(
        [
          makeNode('up'),
          makeNode('mid', {position: {x: 300, y: 100}}),
          makeNode('down'),
        ],
        [makeEdge('e1', 'up', 'mid'), makeEdge('e2', 'mid', 'down')],
      );

      const next = detachToGhost(
        flow,
        'mid',
        {width: 120, height: 60},
        {createId: seqIds('GHOST-x')},
      );

      const ghost = next.nodes.find(
        (n) => stepData(n).__typename === 'GhostSchritt',
      )!;
      expect(ghost).toBeDefined();
      expect(ghost.id).toBe('GHOST-x');
      expect(
        next.nodes.filter((n) => stepData(n).__typename === 'GhostSchritt'),
      ).toHaveLength(1);

      expect(
        next.edges.some((e) => e.source === 'mid' || e.target === 'mid'),
      ).toBe(false);
      expect(next.edges.find((e) => e.id === 'e1')!.target).toBe('GHOST-x');
      expect(next.edges.find((e) => e.id === 'e2')!.source).toBe('GHOST-x');
    });

    it('moves the detached step below the ghost using the 120x60 placeholder rule', () => {
      const flow = makeFlow(
        [makeNode('mid', {position: {x: 300, y: 100}})],
        [],
      );

      const next = detachToGhost(
        flow,
        'mid',
        {width: 200, height: 80},
        {createId: seqIds('GHOST-x')},
      );

      const ghost = next.nodes.find((n) => n.id === 'GHOST-x')!;
      // ghost (120x60) centered in original node: x + (w/2 - 60), y + (h/2 - 30)
      expect(ghost.position).toEqual({
        x: 300 + (200 / 2 - 60),
        y: 100 + (80 / 2 - 30),
      });

      const detached = next.nodes.find((n) => n.id === 'mid')!;
      // detached node placed below ghost (+90 y), re-centered on x
      expect(detached.position).toEqual({
        x: 300,
        y: 100 + (80 / 2 - 30) + 90,
      });
    });

    it('recomputes derived edge state when a programmatic source is detached (Finding 2)', () => {
      const flow = makeFlow(
        [
          makeNode('prog', {
            schritt: {
              __typename: 'ProgrammatischerSchritt',
              implementationAssemblyQualifiedName: 'Some.Type',
            } as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('target'),
        ],
        [],
      );
      const withEdge = connect(
        flow,
        {source: 'prog', target: 'target'},
        {
          createId: seqIds('e1'),
        },
      );
      expect(automatisierung(withEdge.edges[0])).toBe(true);
      expect(withEdge.edges[0].label).toBe('true');

      const next = detachToGhost(
        withEdge,
        'prog',
        {width: 120, height: 60},
        {
          createId: seqIds('GHOST-x'),
        },
      );
      const edge = next.edges.find((e) => e.id === 'e1')!;
      expect(edge.source).toBe('GHOST-x');
      expect(automatisierung(edge)).toBe(false);
      expect(edge.label).toBeNull();
    });
  });

  describe('attachGhost', () => {
    it('rewires all incident ghost edges to the dragged step and removes the ghost', () => {
      const flow = makeFlow(
        [
          makeNode('up'),
          makeNode('GHOST-1', {
            schritt: {
              __typename: 'GhostSchritt',
              titel: 'Platzhalter',
              slots: [],
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('down'),
          makeNode('dragged'),
        ],
        [makeEdge('e1', 'up', 'GHOST-1'), makeEdge('e2', 'GHOST-1', 'down')],
      );

      const next = attachGhost(flow, 'dragged', 'GHOST-1');

      expect(next.nodes.some((n) => n.id === 'GHOST-1')).toBe(false);
      expect(next.edges.find((e) => e.id === 'e1')!.target).toBe('dragged');
      expect(next.edges.find((e) => e.id === 'e2')!.source).toBe('dragged');
      expect(
        next.edges.some(
          (e) => e.source === 'GHOST-1' || e.target === 'GHOST-1',
        ),
      ).toBe(false);
    });

    it('recomputes derived edge state when a programmatic source is attached (Finding 2)', () => {
      const flow = makeFlow(
        [
          makeNode('GHOST-1', {
            schritt: {
              __typename: 'GhostSchritt',
              titel: 'Platzhalter',
              slots: [],
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('target'),
          makeNode('prog', {
            schritt: {
              __typename: 'ProgrammatischerSchritt',
              implementationAssemblyQualifiedName: 'Some.Type',
            } as Partial<SchrittNode['data']['schritt']>,
          }),
        ],
        [makeEdge('e1', 'GHOST-1', 'target')],
      );

      const next = attachGhost(flow, 'prog', 'GHOST-1');
      const edge = next.edges.find((e) => e.id === 'e1')!;
      expect(edge.source).toBe('prog');
      expect(automatisierung(edge)).toBe(true);
      expect(edge.label).toBe('true');
    });
  });

  describe('duplicateSubgraph', () => {
    it('regenerates node ids, step ids, form field ids, and connection ids', () => {
      const flow = makeFlow(
        [
          makeNode('n1', {
            schritt: {
              felder: [
                {id: 'f1', __typename: 'StringFormularFeld', order: 0},
                {id: 'f2', __typename: 'StringFormularFeld', order: 1},
              ],
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('n2'),
        ],
        [makeEdge('e1', 'n1', 'n2')],
      );

      const next = duplicateSubgraph(
        flow,
        ['n1', 'n2'],
        {x: 40, y: 40},
        {
          createId: seqIds('n1c', 'f1c', 'f2c', 'n2c', 'e1c'),
        },
      );

      expect(next.nodes).toHaveLength(4);
      expect(next.edges).toHaveLength(2);

      const clone1 = next.nodes.find((n) => n.id === 'n1c')!;
      expect(clone1).toBeDefined();
      expect(stepData(clone1).id).toBe('n1c');
      expect(stepData(clone1).felder.map((f: {id: string}) => f.id)).toEqual([
        'f1c',
        'f2c',
      ]);

      const clonedEdge = next.edges.find((e) => e.id === 'e1c')!;
      expect(clonedEdge).toBeDefined();
    });

    it('remaps internal edges to cloned nodes and drops external edges', () => {
      const flow = makeFlow(
        [makeNode('inside1'), makeNode('inside2'), makeNode('outside')],
        [
          makeEdge('internal', 'inside1', 'inside2'),
          makeEdge('crossing-out', 'inside2', 'outside'),
          makeEdge('crossing-in', 'outside', 'inside1'),
        ],
      );

      const next = duplicateSubgraph(
        flow,
        ['inside1', 'inside2'],
        {x: 10, y: 10},
        {createId: seqIds('in1c', 'in2c', 'intc')},
      );

      const clonedEdges = next.edges.filter((e) => e.id === 'intc');
      expect(clonedEdges).toHaveLength(1);
      expect(clonedEdges[0].source).toBe('in1c');
      expect(clonedEdges[0].target).toBe('in2c');

      expect(
        next.edges.filter(
          (e) =>
            ['in1c', 'in2c'].includes(e.source) ||
            ['in1c', 'in2c'].includes(e.target),
        ),
      ).toHaveLength(1);
    });

    it('offsets positions and strips view-only data', () => {
      const flow = makeFlow(
        [
          makeNode('n1', {
            position: {x: 100, y: 200},
            measured: {width: 150, height: 70},
            selected: true,
          }),
        ],
        [],
      );
      flow.nodes[0].data.isStart = true;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (flow.nodes[0].data as any).errors = [{message: 'x'}];
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (flow.nodes[0].data as any).intersectionCause = {width: 1, height: 1};

      const next = duplicateSubgraph(
        flow,
        ['n1'],
        {x: 30, y: 40},
        {
          createId: seqIds('n1c'),
        },
      );

      const clone = next.nodes.find((n) => n.id === 'n1c')!;
      expect(clone.position).toEqual({x: 130, y: 240});
      expect(clone.selected).toBeFalsy();
      expect(clone.measured).toBeUndefined();
      expect(clone.data.isStart).toBeFalsy();
      expect(clone.data).not.toHaveProperty('errors');
      expect(clone.data).not.toHaveProperty('intersectionCause');
    });

    it('strips view-only data from cloned edges (Finding 3)', () => {
      const flow = makeFlow(
        [makeNode('n1'), makeNode('n2')],
        [makeEdge('e1', 'n1', 'n2')],
      );
      flow.edges[0].selected = true;

      const next = duplicateSubgraph(
        flow,
        ['n1', 'n2'],
        {x: 10, y: 10},
        {
          createId: seqIds('n1c', 'n2c', 'e1c'),
        },
      );

      const clone = next.edges.find((e) => e.id === 'e1c')!;
      expect(clone).toBeDefined();
      expect(clone.selected).toBeFalsy();
    });

    it('reuses process-level roles and remaps internal step-reference fields where possible', () => {
      const flow = makeFlow(
        [
          makeNode('bezahlen', {
            schritt: {
              __typename: 'BezahlenSchritt',
              betrag: 10,
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('warte', {
            schritt: {
              __typename: 'WarteAufBezahlungAbgeschlossenSchritt',
              bezahlenSchrittId: 'bezahlen',
              schreibtRolleId: 'role-1',
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
          makeNode('warteExternal', {
            schritt: {
              __typename: 'WarteAufBezahlungAbgeschlossenSchritt',
              bezahlenSchrittId: 'bezahlen-external',
            } as unknown as Partial<SchrittNode['data']['schritt']>,
          }),
        ],
        [],
        {rollen: [{id: 'role-1', name: 'Sachbearbeiter'}]},
      );

      const next = duplicateSubgraph(
        flow,
        ['bezahlen', 'warte', 'warteExternal'],
        {x: 20, y: 20},
        {createId: seqIds('bezahlenC', 'warteC', 'warteExtC')},
      );

      expect(next.metadata.rollen).toEqual(flow.metadata.rollen);
      const cloneWarte = next.nodes.find((n) => n.id === 'warteC')!;
      expect(stepData(cloneWarte).schreibtRolleId).toBe('role-1');

      expect(stepData(cloneWarte).bezahlenSchrittId).toBe('bezahlenC');

      const cloneExt = next.nodes.find((n) => n.id === 'warteExtC')!;
      expect(stepData(cloneExt).bezahlenSchrittId).toBe('');
    });
  });
});
