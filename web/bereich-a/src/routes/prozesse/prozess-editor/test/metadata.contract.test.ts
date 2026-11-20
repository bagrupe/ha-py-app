import {type EdgeChange, type NodeChange} from '@xyflow/react';
import {afterEach, describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  hasDirtyChange,
  isDirtyEdgeChange,
  isDirtyNodeChange,
} from '../lib/metadata/dirty-state.ts';
import {
  addRole,
  resolveRoleRefs,
  setName,
  setStartId,
  updateRole,
} from '../lib/metadata/metadata-reducers.ts';
import {useProzessEditorStore} from '../lib/store';
import {validateGraph} from '../lib/validate-graph.ts';
import {type ZustaendigkeitCatalog} from '../lib/validate-prozess.ts';
import {type ProzessEditorProzess} from '../verfuegbare-prozesse.generated.ts';
import {loadFixtureProzess} from './load-fixtures.ts';
import {makeEdge, makeMetadata, makeNode, seqIds} from './support/make-flow.ts';

const ende = (id: string) =>
  makeNode(id, {schritt: {__typename: 'EndeSchritt'}});

describe('Layer 2 — metadata + validation', () => {
  afterEach(() => {
    useProzessEditorStore.getState().initializeFromProzess(null);
  });

  describe('validateGraph (pure over nodes, edges, metadata)', () => {
    it('flags missing start', () => {
      const nodes = [makeNode('a'), ende('b')];
      const edges = [makeEdge('e1', 'a', 'b')];

      const result = validateGraph(nodes, edges, makeMetadata({startId: null}));

      expect(result.valid).toBe(false);
      expect(result.globalErrors).toContainEqual({
        message: 'Ein Prozess benötigt genau einen Start-Schritt.',
      });
    });

    it('flags multiple disconnected roots', () => {
      const nodes = [makeNode('a'), ende('b'), makeNode('c'), ende('d')];
      const edges = [makeEdge('e1', 'a', 'b'), makeEdge('e2', 'c', 'd')];

      const result = validateGraph(nodes, edges, makeMetadata({startId: 'a'}));

      expect(result.valid).toBe(false);
      expect(result.globalErrors).toContainEqual({
        message: 'Ein Prozess muss durchgängig verbunden sein.',
      });
    });

    it('flags no end step', () => {
      const nodes = [makeNode('a'), makeNode('b')];
      const edges = [makeEdge('e1', 'a', 'b')];

      const result = validateGraph(nodes, edges, makeMetadata({startId: 'a'}));

      expect(result.valid).toBe(false);
      expect(result.globalErrors).toContainEqual({
        message: 'Ein Prozess benötigt mindestens einen Ende-Schritt.',
      });
    });

    it('flags paths that do not reach an end step', () => {
      const nodes = [makeNode('a'), makeNode('b'), ende('e')];
      const edges = [makeEdge('e1', 'a', 'b'), makeEdge('e2', 'a', 'e')];

      const result = validateGraph(nodes, edges, makeMetadata({startId: 'a'}));

      expect(result.valid).toBe(false);
      expect(result.errors['b'].errors).toContainEqual({
        message: 'Pfad führt nicht in einen Ende-Schritt',
      });
    });

    it('flags missing incoming/outgoing connections', () => {
      const nodes = [makeNode('a'), ende('b'), makeNode('orphan')];
      const edges = [makeEdge('e1', 'a', 'b')];

      const result = validateGraph(nodes, edges, makeMetadata({startId: 'a'}));

      const orphanMessages = result.errors['orphan'].errors.map(
        (e) => e.message,
      );
      expect(orphanMessages).toContain(
        'Schritt benötigt mindestens eine eingehende Verbindung',
      );
      expect(orphanMessages).toContain(
        'Schritt benötigt mindestens eine ausgehende Verbindung',
      );
    });

    it('flags invalid dynamic-role availability', () => {
      const nodes = [
        makeNode('a'),
        makeNode('b', {
          schritt: {
            sollZustaendigkeit: {
              art: ZustaendigkeitArt.Dynamisch,
              dynamischeArten: [],
              liestRolleId: 'role-1',
              versendeEMailAnMitarbeiterGruppe: false,
            },
          },
        }),
        ende('e'),
      ];
      const edges = [makeEdge('e1', 'a', 'b'), makeEdge('e2', 'b', 'e')];
      const metadata = makeMetadata({
        startId: 'a',
        rollen: [{id: 'role-1', name: 'Sachbearbeiter'}],
      });

      const result = validateGraph(nodes, edges, metadata);

      expect(result.errors['b'].errors).toContainEqual({
        message:
          'Rolle "Sachbearbeiter" ist nicht von allen eingehenden Verbindungen gesetzt.',
      });
    });

    it('flags ghost placeholders', () => {
      const nodes = [
        makeNode('a'),
        makeNode('ghost', {schritt: {__typename: 'GhostSchritt'}}),
        ende('e'),
      ];
      const edges = [
        makeEdge('e1', 'a', 'ghost'),
        makeEdge('e2', 'ghost', 'e'),
      ];

      const result = validateGraph(nodes, edges, makeMetadata({startId: 'a'}));

      expect(result.errors['ghost'].errors).toContainEqual({
        message:
          'Platzhalter müssen vor dem Speichern entfernt oder ersetzt werden.',
      });
    });

    it('treats dangling edges / missing node ids as validation errors, not crashes', () => {
      const nodes = [makeNode('a'), ende('b')];
      const edges = [
        makeEdge('e1', 'a', 'b'),
        makeEdge('e2', 'a', 'does-not-exist'),
      ];

      const run = () =>
        validateGraph(nodes, edges, makeMetadata({startId: 'a'}));

      expect(run).not.toThrow();
      expect(run().valid).toBe(false);
    });
  });

  describe('validateGraph — Zuständigkeit gegen den Katalog', () => {
    // oe-1 has groups gruppe-1 and gruppe-without-mail; dl-1 serves only oe-2.
    const catalog: ZustaendigkeitCatalog = {
      oeGroups: new Map([
        ['oe-1', new Set(['gruppe-1', 'gruppe-without-mail'])],
        ['oe-2', new Set<string>()],
      ]),
      dienstleisterOEs: new Map([
        ['dl-1', new Set(['oe-2'])],
        ['dl-without-mail', new Set(['oe-2'])],
      ]),
      mitarbeiterGruppenWithoutEmail: new Set(['gruppe-without-mail']),
      dienstleisterWithoutEmail: new Set(['dl-without-mail']),
    };

    const validate = (
      sollZustaendigkeit: {
        art: ZustaendigkeitArt;
        dynamischeArten: ZustaendigkeitArt[];
        organisationseinheitId?: string | null;
        mitarbeiterGruppeId?: string | null;
        dienstleisterId?: string | null;
      },
      useCatalog = true,
      versendeEMailAnMitarbeiterGruppe = false,
    ) =>
      validateGraph(
        [
          makeNode('a', {
            schritt: {
              sollZustaendigkeit: {
                ...sollZustaendigkeit,
                versendeEMailAnMitarbeiterGruppe,
              },
            },
          }),
          ende('b'),
        ],
        [makeEdge('e1', 'a', 'b')],
        makeMetadata({startId: 'a'}),
        useCatalog ? catalog : undefined,
      );

    const messages = (
      result: ReturnType<typeof validateGraph>,
      id = 'a',
    ): string[] => result.errors[id]?.errors.map((e) => e.message) ?? [];

    it('flags a Dienstleister step whose OE the Dienstleister does not serve', () => {
      const result = validate({
        art: ZustaendigkeitArt.Dienstleister,
        dienstleisterId: 'dl-1',
        organisationseinheitId: 'oe-1', // dl-1 serves only oe-2
        dynamischeArten: [],
      });

      expect(result.valid).toBe(false);
      expect(messages(result)).toContain(
        'Die Organisationseinheit gehört nicht zum gewählten Dienstleister.',
      );
    });

    it('passes a Dienstleister step whose OE the Dienstleister serves', () => {
      const result = validate({
        art: ZustaendigkeitArt.Dienstleister,
        dienstleisterId: 'dl-1',
        organisationseinheitId: 'oe-2',
        dynamischeArten: [],
      });

      expect(messages(result)).toEqual([]);
    });

    it('flags an OE step whose Abteilung does not belong to the OE', () => {
      const result = validate({
        art: ZustaendigkeitArt.Organisationseinheit,
        organisationseinheitId: 'oe-1',
        mitarbeiterGruppeId: 'gruppe-x', // not in oe-1
        dynamischeArten: [],
      });

      expect(messages(result)).toContain(
        'Die Abteilung gehört nicht zur gewählten Organisationseinheit.',
      );
    });

    it('flags an OE step that notifies an Abteilung without an e-mail address', () => {
      const result = validate(
        {
          art: ZustaendigkeitArt.Organisationseinheit,
          organisationseinheitId: 'oe-1',
          mitarbeiterGruppeId: 'gruppe-without-mail',
          dynamischeArten: [],
        },
        true,
        true,
      );

      expect(result.valid).toBe(false);
      expect(messages(result)).toContain(
        'Die E-Mail-Benachrichtigung ist aktiv, aber zu der gewählten Abteilung ist keine E-Mail-Adresse hinterlegt.',
      );
    });

    it('passes an Abteilung without an e-mail address while the notification is off', () => {
      const result = validate({
        art: ZustaendigkeitArt.Organisationseinheit,
        organisationseinheitId: 'oe-1',
        mitarbeiterGruppeId: 'gruppe-without-mail',
        dynamischeArten: [],
      });

      expect(messages(result)).toEqual([]);
    });

    it('passes a notified Abteilung that has an e-mail address', () => {
      const result = validate(
        {
          art: ZustaendigkeitArt.Organisationseinheit,
          organisationseinheitId: 'oe-1',
          mitarbeiterGruppeId: 'gruppe-1',
          dynamischeArten: [],
        },
        true,
        true,
      );

      expect(messages(result)).toEqual([]);
    });

    it('flags a Dienstleister step that notifies a Dienstleister without an e-mail address', () => {
      const result = validate(
        {
          art: ZustaendigkeitArt.Dienstleister,
          dienstleisterId: 'dl-without-mail',
          organisationseinheitId: 'oe-2',
          dynamischeArten: [],
        },
        true,
        true,
      );

      expect(result.valid).toBe(false);
      expect(messages(result)).toContain(
        'Die E-Mail-Benachrichtigung ist aktiv, aber zu dem gewählten Dienstleister ist keine E-Mail-Adresse hinterlegt.',
      );
    });

    it('passes a notified Dienstleister that has an e-mail address', () => {
      const result = validate(
        {
          art: ZustaendigkeitArt.Dienstleister,
          dienstleisterId: 'dl-1',
          organisationseinheitId: 'oe-2',
          dynamischeArten: [],
        },
        true,
        true,
      );

      expect(messages(result)).toEqual([]);
    });

    it('flags a missing Organisationseinheit / Dienstleister', () => {
      expect(
        messages(
          validate({
            art: ZustaendigkeitArt.Organisationseinheit,
            organisationseinheitId: null,
            dynamischeArten: [],
          }),
        ),
      ).toContain('Es muss eine Organisationseinheit gewählt werden.');

      expect(
        messages(
          validate({
            art: ZustaendigkeitArt.Dienstleister,
            dienstleisterId: null,
            organisationseinheitId: 'oe-2',
            dynamischeArten: [],
          }),
        ),
      ).toContain('Es muss ein Dienstleister gewählt werden.');
    });

    it('does not run the check when no catalog is given', () => {
      const result = validate(
        {
          art: ZustaendigkeitArt.Dienstleister,
          dienstleisterId: 'dl-1',
          organisationseinheitId: 'oe-1',
          dynamischeArten: [],
        },
        false,
      );

      expect(messages(result)).toEqual([]);
    });
  });

  describe('metadata reducers', () => {
    it('setName does NOT mark the version dirty', () => {
      const meta = makeMetadata({name: 'Alt', hasVersionChanges: false});

      const next = setName(meta, 'Neu');

      expect(next.name).toBe('Neu');
      expect(next.hasVersionChanges).toBe(false);
      expect(meta.name).toBe('Alt');
    });

    it('setStartId marks the version dirty', () => {
      const meta = makeMetadata({startId: 'a', hasVersionChanges: false});

      const next = setStartId(meta, 'b');

      expect(next.startId).toBe('b');
      expect(next.hasVersionChanges).toBe(true);
      expect(meta.startId).toBe('a');
    });

    it('addRole / updateRole match current UI behavior', () => {
      const meta = makeMetadata({rollen: [], hasVersionChanges: false});

      const withRole = addRole(meta, 'Sachbearbeiter', {
        createId: seqIds('role-1'),
      });
      expect(withRole.rollen).toEqual([{id: 'role-1', name: 'Sachbearbeiter'}]);
      expect(withRole.hasVersionChanges).toBe(true);
      expect(meta.rollen).toHaveLength(0);

      const renamed = updateRole(withRole, 'role-1', {name: 'Leitung'});
      expect(renamed.rollen).toEqual([{id: 'role-1', name: 'Leitung'}]);
      expect(renamed.hasVersionChanges).toBe(true);
      expect(withRole.rollen[0].name).toBe('Sachbearbeiter');
    });

    it('resolveRoleRefs resolves role names through metadata.rollen', () => {
      const step = makeNode('a', {
        schritt: {
          schreibtRolleId: 'role-write',
          sollZustaendigkeit: {
            art: ZustaendigkeitArt.Dynamisch,
            dynamischeArten: [],
            liestRolleId: 'role-read',
            versendeEMailAnMitarbeiterGruppe: false,
          },
        },
      }).data.schritt;

      const metadata = makeMetadata({
        rollen: [
          {id: 'role-write', name: 'Schreiber'},
          {id: 'role-read', name: 'Leser'},
        ],
      });

      const resolved = resolveRoleRefs(step, metadata);

      expect(resolved.schreibtRolle).toEqual({
        id: 'role-write',
        name: 'Schreiber',
      });
      expect(resolved.sollZustaendigkeit.liestRolle).toEqual({
        id: 'role-read',
        name: 'Leser',
      });
    });

    it('resolveRoleRefs leaves ghost steps untouched', () => {
      const ghost = makeNode('ghost', {
        schritt: {__typename: 'GhostSchritt'},
      }).data.schritt;

      expect(() => resolveRoleRefs(ghost, makeMetadata())).not.toThrow();
      expect(resolveRoleRefs(ghost, makeMetadata())).not.toHaveProperty(
        'schreibtRolle',
      );
    });
  });

  describe('store metadata actions', () => {
    it('marks an unchanged version as published from the mutation response without dirtying the graph', () => {
      useProzessEditorStore
        .getState()
        .initializeFromProzess(
          loadFixtureProzess(
            'maengelmelder',
          ) as unknown as ProzessEditorProzess,
        );

      const before = useProzessEditorStore.getState().metadata;
      expect(before.latestVersionId).toBe(
        '019e820f-c338-7c47-9f14-47f594fe8f4b',
      );
      expect(before.latestVersionPublishedAt).toBeNull();
      expect(before.hasVersionChanges).toBe(false);

      useProzessEditorStore.getState().markVersionPublished({
        id: before.latestVersionId!,
        publishedAt: new Date('2026-06-15T13:00:00.000Z'),
      });

      const after = useProzessEditorStore.getState().metadata;
      expect(after.latestVersionId).toBe(before.latestVersionId);
      expect(after.latestVersionPublishedAt).toBe('2026-06-15T13:00:00.000Z');
      expect(after.hasVersionChanges).toBe(false);
    });
  });

  describe('dirty-state classification', () => {
    it('dirty: add/remove node, add/remove edge, reconnect, persisted data change, committed position, attach/detach, paste/duplicate, role/start change', () => {
      const node = makeNode('a');
      const edge = makeEdge('e1', 'a', 'b');

      const dirtyNodeChanges: NodeChange[] = [
        {type: 'add', item: node},
        {type: 'remove', id: 'a'},
        {type: 'replace', id: 'a', item: node},
        {type: 'position', id: 'a', position: {x: 10, y: 10}, dragging: false},
      ];
      for (const change of dirtyNodeChanges) {
        expect(isDirtyNodeChange(change)).toBe(true);
      }

      const dirtyEdgeChanges: EdgeChange[] = [
        {type: 'add', item: edge},
        {type: 'remove', id: 'e1'},
        {type: 'replace', id: 'e1', item: edge},
      ];
      for (const change of dirtyEdgeChanges) {
        expect(isDirtyEdgeChange(change)).toBe(true);
      }
    });

    it('not dirty: selection, dimensions/measured, position while dragging', () => {
      const notDirtyNodeChanges: NodeChange[] = [
        {type: 'select', id: 'a', selected: true},
        {type: 'dimensions', id: 'a', dimensions: {width: 10, height: 10}},
        {type: 'position', id: 'a', position: {x: 10, y: 10}, dragging: true},
      ];
      for (const change of notDirtyNodeChanges) {
        expect(isDirtyNodeChange(change)).toBe(false);
      }

      expect(
        isDirtyEdgeChange({type: 'select', id: 'e1', selected: true}),
      ).toBe(false);
    });

    it('copy is not dirty; paste is dirty', () => {
      const pasted = makeNode('pasted');

      expect(hasDirtyChange([], [])).toBe(false);
      expect(
        hasDirtyChange([{type: 'select', id: 'a', selected: true}], []),
      ).toBe(false);

      expect(hasDirtyChange([{type: 'add', item: pasted}], [])).toBe(true);
    });
  });
});
