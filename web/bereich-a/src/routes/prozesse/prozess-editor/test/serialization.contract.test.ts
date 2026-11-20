import {BoolExpression} from '@kommunalapp/expressions';
import {describe, expect, it} from 'vitest';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  type ProzessEditorFlow,
  type SchrittNode,
} from '../lib/flow/flow.types.ts';
import {flowToVersionInput} from '../lib/serialization/flow-to-version-input.ts';
import {prozessToFlow} from '../lib/serialization/prozess-to-flow.ts';
import {
  type SchrittInput,
  type ProzessVersionErstellenInput,
} from '../prozess-version-erstellen.generated.ts';
import {type ProzessEditorProzess} from '../verfuegbare-prozesse.generated.ts';
import {legacyProzessToVersionInput} from './legacy/legacy-prozess-to-version-input.ts';
import {FIXTURE_NAMES, loadFixtureProzess} from './load-fixtures.ts';
import {normalizeVersionInput} from './support/normalize-version-input.ts';

const fixtureProzess = (
  name: (typeof FIXTURE_NAMES)[number],
): ProzessEditorProzess =>
  loadFixtureProzess(name) as unknown as ProzessEditorProzess;

const roundTrip = (prozess: ProzessEditorProzess, veroeffentlichen = false) =>
  flowToVersionInput(prozessToFlow(prozess), {veroeffentlichen});

const stepInputs = <K extends keyof SchrittInput>(
  input: ProzessVersionErstellenInput,
  key: K,
): NonNullable<SchrittInput[K]>[] =>
  input.schritte
    .map((schritt) => schritt[key])
    .filter((value): value is NonNullable<SchrittInput[K]> => value != null);

const firstId = (feld: object): string =>
  (Object.values(feld).find((value) => value != null) as {id: string}).id;

const nodeOfType = (flow: ProzessEditorFlow, typename: string): SchrittNode =>
  flow.nodes.find((node) => node.data.schritt.__typename === typename)!;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const schrittData = (node: SchrittNode): any => node.data.schritt;

const EMPTY_PROZESS: ProzessEditorProzess = {
  __typename: 'Prozess',
  id: 'new-prozess-id',
  name: 'Neuer Prozess',
  istOeffentlich: false,
  tags: [],
  latestVersion: null,
};

describe('Layer 3 — prozessToFlow / flowToVersionInput', () => {
  /**
   * Keystone contract: the refactored load/save boundary must be semantically equivalent
   * to the legacy `dataToStoreProzess` + topbar save mapping for real fixtures. The
   * comparison is intentionally normalized: top-level ids are sorted, read-only
   * denormalized role objects are ignored, and missing legacy node positions are treated
   * as the editor's default render position.
   */
  describe('round-trip losslessness (per real fixture)', () => {
    it.each(FIXTURE_NAMES)(
      '%s round-trips equal to the legacy comparator',
      (name) => {
        const prozess = fixtureProzess(name);

        expect(normalizeVersionInput(roundTrip(prozess))).toEqual(
          normalizeVersionInput(legacyProzessToVersionInput(prozess)),
        );
      },
    );
  });

  describe('legacy comparator', () => {
    it('legacyProzessToVersionInput reproduces dataToStoreProzess + topbar save mapping', () => {
      const input = legacyProzessToVersionInput(
        fixtureProzess('fuehrerschein-verlaengern'),
      );

      expect(input.prozessId).toBeTruthy();
      expect(input.schritte).toHaveLength(14);
      expect(input.verbindungen).toHaveLength(18);
      expect(input.veroeffentlichen).toBe(false);
    });
  });

  describe('new process (no latestVersion)', () => {
    it('seeds one default FormularSchritt + default field, startId = node.id', () => {
      const flow = prozessToFlow(EMPTY_PROZESS);

      expect(flow.nodes).toHaveLength(1);
      expect(flow.edges).toHaveLength(0);

      const schritt = schrittData(flow.nodes[0]);
      expect(schritt.__typename).toBe('FormularSchritt');
      expect(schritt.felder).toHaveLength(1);
      expect(schritt.felder[0].__typename).toBe('StringFormularFeld');
      expect(flow.metadata.startId).toBe(flow.nodes[0].id);
    });

    it('injectable id factory makes the new-process seed deterministic', () => {
      const ids = ['id-step', 'id-field'];
      let i = 0;
      const createId = () => ids[i++];

      const flow = prozessToFlow(EMPTY_PROZESS, {createId});

      expect(flow.nodes[0].id).toBe('id-step');
      expect(schrittData(flow.nodes[0]).felder[0].id).toBe('id-field');
      expect(flow.metadata.startId).toBe('id-step');
    });
  });

  describe('step-type coverage (all 9 types)', () => {
    it('maps FormularSchritt (felder + options order preserved)', () => {
      const legacy = legacyProzessToVersionInput(
        fixtureProzess('bildung-teilhabe'),
      );
      const next = roundTrip(fixtureProzess('bildung-teilhabe'));

      const legacyFelder = stepInputs(legacy, 'formularSchrittInput').map((s) =>
        s.felder.map(firstId),
      );
      const nextFelder = stepInputs(next, 'formularSchrittInput').map((s) =>
        s.felder.map(firstId),
      );

      expect(stepInputs(next, 'formularSchrittInput').length).toBeGreaterThan(
        0,
      );
      // field order within each step is preserved (not sorted)
      expect(nextFelder).toEqual(legacyFelder);
    });

    it('maps BezahlenSchritt (betrag)', () => {
      const [bezahlen] = stepInputs(
        roundTrip(fixtureProzess('fuehrerschein-verlaengern')),
        'bezahlenSchrittInput',
      );
      expect(typeof bezahlen.betrag).toBe('number');
    });

    it('maps WarteAufBezahlungAbgeschlossenSchritt (bezahlenSchrittId preserved)', () => {
      const [warte] = stepInputs(
        roundTrip(fixtureProzess('fuehrerschein-verlaengern')),
        'warteAufBezahlungAbgeschlossenSchrittInput',
      );
      expect(warte.bezahlenSchrittId).toBeTruthy();
    });

    it('maps EndeSchritt', () => {
      const ende = stepInputs(
        roundTrip(fixtureProzess('fuehrerschein-verlaengern')),
        'endeSchrittInput',
      );
      expect(ende.length).toBeGreaterThan(0);
      expect(ende[0].id).toBeTruthy();
    });

    it('maps ProgrammatischerSchritt (implementationAssemblyQualifiedName)', () => {
      const [prog] = stepInputs(
        roundTrip(fixtureProzess('maengelmelder')),
        'programmatischerSchrittInput',
      );
      expect(prog.implementationAssemblyQualifiedName).toBeTruthy();
    });

    it('maps GovManagerRestExportSchritt (exportParts + vorgangs/mandanten keys)', () => {
      const [gov] = stepInputs(
        roundTrip(fixtureProzess('bildung-teilhabe')),
        'govManagerRestExportSchrittInput',
      );
      expect(Array.isArray(gov.exportParts)).toBe(true);
      expect(gov).toHaveProperty('vorgangsTyp');
      expect(gov).toHaveProperty('mandantenSchluessel');
      expect(gov).toHaveProperty('vorgangsSchluessel');
    });

    it('maps WarteAufGovManagerSchritt from real data (statusaenderung-test)', () => {
      const [warte] = stepInputs(
        roundTrip(fixtureProzess('statusaenderung-test')),
        'warteAufGovManagerSchrittInput',
      );
      expect(warte.govManagerSchrittId).toBeTruthy();
    });

    it('maps EmailForwarderExportSchritt from real data (statusaenderung-test)', () => {
      const [email] = stepInputs(
        roundTrip(fixtureProzess('statusaenderung-test')),
        'emailForwardSchrittInput',
      );
      expect(JSON.stringify(email.emailAddress)).toContain(
        'contact-a8ba1400@example.com',
      );
      expect(email).toHaveProperty('subject');
      expect(email).toHaveProperty('body');
    });

    // Synthetisch, da noch keine Fixture einen NachrichtSchritt enthält.
    it('maps NachrichtSchritt (load into node + save under nachrichtSchrittInput)', () => {
      const baseSchritt = {
        anweisung: null,
        erledigungDurchBuerger: false,
        versendeEMailAnMitarbeiterGruppe: false,
        sollZustaendigkeit: {
          art: ZustaendigkeitArt.Organisationseinheit,
          dynamischeArten: [],
        },
        slots: [],
        nodePosition: null,
        verbindungen: [],
      };
      const prozess = {
        ...EMPTY_PROZESS,
        latestVersion: {
          id: 'version-1',
          publishedAt: null,
          start: {id: 'nachricht-1'},
          rollen: [],
          alleSchritte: [
            {
              ...baseSchritt,
              __typename: 'NachrichtSchritt',
              id: 'nachricht-1',
              titel: 'Abschlussnachricht',
              nodePosition: {x: 10, y: 20},
              verbindungen: [
                {
                  id: 'verbindung-1',
                  vonId: 'nachricht-1',
                  nachId: 'ende-1',
                  name: null,
                  statusAenderung: 'Mangel behoben',
                  statusAenderungBeschreibung: null,
                  istRelevant: 'true',
                },
              ],
            },
            {
              ...baseSchritt,
              __typename: 'EndeSchritt',
              id: 'ende-1',
              titel: 'Ende',
            },
          ],
        },
      } as unknown as ProzessEditorProzess;

      const flow = prozessToFlow(prozess);
      expect(nodeOfType(flow, 'NachrichtSchritt')).toBeDefined();

      const input = flowToVersionInput(flow, {veroeffentlichen: false});
      const [nachricht] = stepInputs(input, 'nachrichtSchrittInput');
      expect(nachricht.id).toBe('nachricht-1');
      expect(nachricht.titel).toBe('Abschlussnachricht');
      expect(nachricht.nodePosition).toEqual({x: 10, y: 20});
      expect(input.verbindungen).toHaveLength(1);
      expect(input.verbindungen[0].vonId).toBe('nachricht-1');
      expect(input.verbindungen[0].nachId).toBe('ende-1');
    });
  });

  it('node.data strips graph-owned/derived fields (verbindungen, nodePosition, denormalized roles)', () => {
    const flow = prozessToFlow(fixtureProzess('maengelmelder'));
    const node = nodeOfType(flow, 'FormularSchritt');
    const schritt = schrittData(node);

    expect(schritt).not.toHaveProperty('verbindungen');
    expect(schritt).not.toHaveProperty('nodePosition');
    expect(schritt).not.toHaveProperty('schreibtRolle');
    expect(schritt.sollZustaendigkeit).not.toHaveProperty('liestRolle');
  });

  it('keeps the e-mail flag on sollZustaendigkeit in the editor and on the step in the API', () => {
    const flow = prozessToFlow(fixtureProzess('maengelmelder'));
    const notifying = flow.nodes.filter(
      (node) =>
        schrittData(node).sollZustaendigkeit
          ?.versendeEMailAnMitarbeiterGruppe === true,
    );
    expect(notifying.length).toBeGreaterThan(0);
    flow.nodes.forEach((node) =>
      expect(schrittData(node)).not.toHaveProperty(
        'versendeEMailAnMitarbeiterGruppe',
      ),
    );

    const input = flowToVersionInput(flow, {veroeffentlichen: false});
    const stepById = new Map(
      input.schritte.map((schritt) => {
        const step = Object.values(schritt).find((value) => value != null) as {
          id: string;
          versendeEMailAnMitarbeiterGruppe?: boolean | null;
          sollZustaendigkeit: object;
        };
        return [step.id, step];
      }),
    );
    notifying.forEach((node) => {
      const step = stepById.get(node.id)!;
      expect(step.versendeEMailAnMitarbeiterGruppe).toBe(true);
      expect(step.sollZustaendigkeit).not.toHaveProperty(
        'versendeEMailAnMitarbeiterGruppe',
      );
    });
  });

  it('edge maps verbindung id/source/target; save reconstructs vonId/nachId', () => {
    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    const edge = flow.edges[0];

    expect(edge.source).toBeTruthy();
    expect(edge.target).toBeTruthy();
    expect(edge.data!.verbindung).not.toHaveProperty('vonId');
    expect(edge.data!.verbindung).not.toHaveProperty('nachId');
    expect(edge.data!.verbindung).not.toHaveProperty('id');

    const [input] = flowToVersionInput(flow, {
      veroeffentlichen: false,
    }).verbindungen;
    const matching = flowToVersionInput(flow, {
      veroeffentlichen: false,
    }).verbindungen.find((v) => v.id === edge.id)!;
    expect(input.id).toBeTruthy();
    expect(matching.vonId).toBe(edge.source);
    expect(matching.nachId).toBe(edge.target);
  });

  it('schritt.nodePosition loads into node.position; save reconstructs nodePosition', () => {
    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    const node = nodeOfType(flow, 'GovManagerRestExportSchritt');
    expect(node.position).toEqual({x: 560, y: 290});

    const [gov] = stepInputs(
      flowToVersionInput(flow, {veroeffentlichen: false}),
      'govManagerRestExportSchrittInput',
    );
    expect(gov.nodePosition).toEqual({x: 560, y: 290});
  });

  it('expression scalars load as editable strings and save preserves JSON output', () => {
    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    const edge = flow.edges[0];
    expect(typeof edge.data!.verbindung.istRelevant).toBe('string');

    const [verbindung] = flowToVersionInput(flow, {
      veroeffentlichen: false,
    }).verbindungen;
    expect(verbindung.istRelevant).toBeInstanceOf(BoolExpression);
    expect(JSON.parse(JSON.stringify(verbindung.istRelevant))).toBe('true');
  });

  it('preserves per-option istRelevant on StringFormularFeld options (Kategoriebaum Sync-Export gating)', () => {
    const baseSchritt = {
      anweisung: null,
      erledigungDurchBuerger: true,
      versendeEMailAnMitarbeiterGruppe: null,
      sollZustaendigkeit: {art: ZustaendigkeitArt.Buerger, dynamischeArten: []},
      slots: [],
      nodePosition: null,
      verbindungen: [],
    };
    const prozess = {
      ...EMPTY_PROZESS,
      latestVersion: {
        id: 'version-1',
        publishedAt: null,
        start: {id: 'meldung-1'},
        rollen: [],
        alleSchritte: [
          {
            ...baseSchritt,
            __typename: 'FormularSchritt',
            id: 'meldung-1',
            titel: 'Meldung erfassen',
            felder: [
              {
                __typename: 'StringFormularFeld',
                id: 'kategorie-feld-1',
                slotName: 'kategorie',
                angezeigterName: 'Kategorie',
                anweisung: null,
                order: 0,
                encrypted: false,
                inhaltsTag: null,
                istRelevant: 'true',
                pflichtfeld: true,
                multiline: false,
                options: [
                  {
                    key: 'Ratten',
                    value: 'Ratten',
                    istRelevant: "isInside('Aerzen', slot('adresse')) == true",
                  },
                  {key: 'Gewässer', value: 'Gewässer', istRelevant: null},
                ],
              },
            ],
          },
        ],
      },
    } as unknown as ProzessEditorProzess;

    const input = flowToVersionInput(prozessToFlow(prozess), {
      veroeffentlichen: false,
    });
    const [{options}] = stepInputs(input, 'formularSchrittInput').map(
      (s) => s.felder[0].stringFormularFeldInput!,
    );

    expect(options![0].istRelevant).toBeInstanceOf(BoolExpression);
    expect(JSON.parse(JSON.stringify(options![0].istRelevant))).toBe(
      "isInside('Aerzen', slot('adresse')) == true",
    );
    expect(options![1].istRelevant).toBeFalsy();
  });

  it('keeps oeffentlichSichtbar per field and istOeffentlich on the metadata through load and save', () => {
    const feld = (
      id: string,
      slotName: string,
      oeffentlichSichtbar: boolean,
    ) => ({
      __typename: 'StringFormularFeld',
      id,
      slotName,
      angezeigterName: null,
      anweisung: null,
      order: 0,
      encrypted: false,
      inhaltsTag: null,
      istRelevant: 'true',
      pflichtfeld: false,
      oeffentlichSichtbar,
      multiline: false,
      options: [],
    });
    const prozess = {
      ...EMPTY_PROZESS,
      istOeffentlich: true,
      latestVersion: {
        id: 'version-1',
        publishedAt: null,
        start: {id: 'meldung-1'},
        rollen: [],
        alleSchritte: [
          {
            __typename: 'FormularSchritt',
            id: 'meldung-1',
            titel: 'Meldung erfassen',
            anweisung: null,
            erledigungDurchBuerger: true,
            versendeEMailAnMitarbeiterGruppe: null,
            sollZustaendigkeit: {
              art: ZustaendigkeitArt.Buerger,
              dynamischeArten: [],
            },
            slots: [],
            nodePosition: null,
            verbindungen: [],
            felder: [feld('f-1', 'titel', true), feld('f-2', 'vorname', false)],
          },
        ],
      },
    } as unknown as ProzessEditorProzess;

    const flow = prozessToFlow(prozess);
    const [{felder}] = stepInputs(
      flowToVersionInput(flow, {veroeffentlichen: false}),
      'formularSchrittInput',
    );

    expect(flow.metadata.istOeffentlich).toBe(true);
    expect(
      felder.map((f) => f.stringFormularFeldInput!.oeffentlichSichtbar),
    ).toEqual([true, false]);
  });

  it('metadata.rollen is canonical; step data keeps only schreibtRolleId / liestRolleId', () => {
    const flow = prozessToFlow(fixtureProzess('maengelmelder'));
    expect(flow.metadata.rollen).toHaveLength(1);

    const node = flow.nodes.find(
      (n) => schrittData(n).schreibtRolleId != null,
    )!;
    const schritt = schrittData(node);
    expect(typeof schritt.schreibtRolleId).toBe('string');
    expect(schritt).not.toHaveProperty('schreibtRolle');
  });

  it('WarteAufGovManagerSchritt.govManagerSchrittId resolves from upstream on save when empty', () => {
    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    const warteNode = nodeOfType(flow, 'WarteAufGovManagerSchritt');
    const govNode = nodeOfType(flow, 'GovManagerRestExportSchritt');
    expect(
      flow.edges.some(
        (e) => e.source === govNode.id && e.target === warteNode.id,
      ),
    ).toBe(true);

    schrittData(warteNode).govManagerSchrittId = '';
    const [warte] = stepInputs(
      flowToVersionInput(flow, {veroeffentlichen: false}),
      'warteAufGovManagerSchrittInput',
    );
    expect(warte.govManagerSchrittId).toBe(govNode.id);
  });

  it('internal reference fields (bezahlenSchrittId, govManagerSchrittId) preserved on round-trip', () => {
    const [warteBezahlung] = stepInputs(
      roundTrip(fixtureProzess('fuehrerschein-verlaengern')),
      'warteAufBezahlungAbgeschlossenSchrittInput',
    );
    const [warteGov] = stepInputs(
      roundTrip(fixtureProzess('statusaenderung-test')),
      'warteAufGovManagerSchrittInput',
    );
    expect(warteBezahlung.bezahlenSchrittId).toBeTruthy();
    expect(warteGov.govManagerSchrittId).toBe(
      'a2aea65c-07ae-40a5-88e0-c29b1fbbe485',
    );
  });

  it('save emits only roles referenced by schreibtRolleId / liestRolleId', () => {
    const flow = prozessToFlow(fixtureProzess('maengelmelder'));
    flow.metadata.rollen = [
      ...flow.metadata.rollen,
      {id: 'unused-role', name: 'Unbenutzt'},
    ];

    const {zustaendigkeitRollen} = flowToVersionInput(flow, {
      veroeffentlichen: false,
    });
    expect(zustaendigkeitRollen.some((r) => r.id === 'unused-role')).toBe(
      false,
    );
    expect(zustaendigkeitRollen.length).toBeGreaterThan(0);
  });

  it('GhostSchritt is never emitted by prozessToFlow and is filtered on save', () => {
    for (const name of FIXTURE_NAMES) {
      const flow = prozessToFlow(fixtureProzess(name));
      expect(
        flow.nodes.some((n) => schrittData(n).__typename === 'GhostSchritt'),
      ).toBe(false);
    }

    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    const before = flowToVersionInput(flow, {veroeffentlichen: false}).schritte
      .length;
    flow.nodes.push({
      id: 'ghost-1',
      type: 'schritt',
      position: {x: 0, y: 0},
      data: {
        schritt: {
          __typename: 'GhostSchritt',
          id: 'ghost-1',
          titel: 'Platzhalter',
          slots: [],
        },
      },
    });
    const after = flowToVersionInput(flow, {veroeffentlichen: false}).schritte
      .length;
    expect(after).toBe(before);
  });

  it('drops connections incident to a ghost so save output is referentially closed (Finding 4)', () => {
    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    const realNode = flow.nodes[0];

    flow.nodes.push({
      id: 'GHOST-1',
      type: 'schritt',
      position: {x: 0, y: 0},
      data: {
        schritt: {
          __typename: 'GhostSchritt',
          id: 'GHOST-1',
          titel: 'Platzhalter',
          slots: [],
        },
      },
    });
    // an incident edge, as a mid-edit detach leaves behind
    flow.edges.push({
      id: 'ghost-edge',
      source: realNode.id,
      target: 'GHOST-1',
      type: 'kommunalEdge',
      reconnectable: true,
      data: flow.edges[0].data,
    });

    const input = flowToVersionInput(flow, {veroeffentlichen: false});
    const stepIds = new Set(input.schritte.map(firstId));

    for (const verbindung of input.verbindungen) {
      expect(stepIds.has(verbindung.vonId)).toBe(true);
      expect(stepIds.has(verbindung.nachId)).toBe(true);
    }
    expect(input.verbindungen.some((v) => v.nachId === 'GHOST-1')).toBe(false);
  });

  it('latestVersionId and latestVersionPublishedAt load into metadata', () => {
    const flow = prozessToFlow(fixtureProzess('statusaenderung-test'));
    expect(flow.metadata.latestVersionId).toBe(
      '019ecb63-80bd-72b1-a134-c8fab6c52ec8',
    );
    expect(flow.metadata.latestVersionPublishedAt).toBe(
      '2026-06-15T13:06:00.664225Z',
    );
  });

  describe('edge derivation on load (Finding 1)', () => {
    it.each(FIXTURE_NAMES)(
      '%s: every loaded edge derives label/automatisierung from its source step',
      (name) => {
        const flow = prozessToFlow(fixtureProzess(name));
        const stepById = new Map(flow.nodes.map((n) => [n.id, schrittData(n)]));

        for (const edge of flow.edges) {
          const source = stepById.get(edge.source);
          const expectedAuto = source?.__typename === 'ProgrammatischerSchritt';
          const verbindung = edge.data!.verbindung;
          const expectedLabel =
            verbindung.name || (expectedAuto ? verbindung.istRelevant : null);

          expect(edge.data!.automatisierung).toBe(expectedAuto);
          expect(edge.label ?? null).toBe(expectedLabel ?? null);
        }
      },
    );

    it('covers at least one automated edge (invariant is not vacuous)', () => {
      const automatedEdges = FIXTURE_NAMES.flatMap((name) => {
        const flow = prozessToFlow(fixtureProzess(name));
        const stepById = new Map(flow.nodes.map((n) => [n.id, schrittData(n)]));
        return flow.edges.filter(
          (edge) =>
            stepById.get(edge.source)?.__typename === 'ProgrammatischerSchritt',
        );
      });
      expect(automatedEdges.length).toBeGreaterThan(0);
    });
  });
});
