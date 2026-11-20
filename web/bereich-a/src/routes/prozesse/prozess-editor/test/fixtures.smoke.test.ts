import {describe, expect, it} from 'vitest';
import {
  loadFixtureProzess,
  loadFixtureResponse,
  type FixtureName,
} from './load-fixtures.ts';

/**
 * Pins the real fixtures so accidental corruption/re-capture drift is caught, and
 * cross-checks the counts against the DB histogram recorded in fixture-manifest.md.
 */

type Expected = {
  prozessId: string;
  versionId: string;
  steps: number;
  edges: number;
  rollen: number;
  stepTypes: Record<string, number>;
};

const EXPECTED: Record<FixtureName, Expected> = {
  'fuehrerschein-verlaengern': {
    prozessId: 'd41d5923-b0b5-5403-b536-00b6d98ca9cc',
    versionId: '0f44d48f-f45a-4cbe-be1b-e968c9fff821',
    steps: 14,
    edges: 18,
    rollen: 0,
    stepTypes: {
      FormularSchritt: 11,
      BezahlenSchritt: 1,
      WarteAufBezahlungAbgeschlossenSchritt: 1,
      EndeSchritt: 1,
    },
  },
  maengelmelder: {
    prozessId: '59cd9327-eb6e-546f-b309-e2297a6578aa',
    versionId: '019e820f-c338-7c47-9f14-47f594fe8f4b',
    steps: 127,
    edges: 605,
    rollen: 1,
    stepTypes: {
      ProgrammatischerSchritt: 71,
      FormularSchritt: 54,
      EndeSchritt: 2,
    },
  },
  'bildung-teilhabe': {
    prozessId: '78965ab6-ec86-5f24-acfd-b8a4932f3bc7',
    versionId: '019d85b9-4cde-7352-9e7b-29ca9e490025',
    steps: 12,
    edges: 13,
    rollen: 0,
    stepTypes: {
      FormularSchritt: 10,
      GovManagerRestExportSchritt: 1,
      EndeSchritt: 1,
    },
  },
  'bildung-teilhabe-variant': {
    prozessId: '01972041-1bbc-7b5a-8d6f-42fc6353f313',
    versionId: '019d676b-ea9c-732f-bf31-f6e6e70f51fb',
    steps: 10,
    edges: 9,
    rollen: 0,
    stepTypes: {
      FormularSchritt: 8,
      GovManagerRestExportSchritt: 1,
      EndeSchritt: 1,
    },
  },
  'statusaenderung-test': {
    prozessId: '019e88ab-c357-726d-8661-7dc08f48a21f',
    versionId: '019ecb63-80bd-72b1-a134-c8fab6c52ec8',
    steps: 5,
    edges: 4,
    rollen: 0,
    stepTypes: {
      WarteAufGovManagerSchritt: 1,
      FormularSchritt: 1,
      EmailForwarderExportSchritt: 1,
      EndeSchritt: 1,
      GovManagerRestExportSchritt: 1,
    },
  },
};

const histogram = (steps: {__typename: string}[]): Record<string, number> =>
  steps.reduce<Record<string, number>>((acc, s) => {
    acc[s.__typename] = (acc[s.__typename] ?? 0) + 1;
    return acc;
  }, {});

describe('serialization fixtures', () => {
  for (const [name, exp] of Object.entries(EXPECTED) as [
    FixtureName,
    Expected,
  ][]) {
    describe(name, () => {
      it('is a clean GraphQL response (no errors, has prozessById)', () => {
        const raw = loadFixtureResponse(name) as Record<string, unknown>;
        expect(raw).not.toHaveProperty('errors');
        expect(loadFixtureProzess(name).id).toBe(exp.prozessId);
      });

      it('matches the recorded version, step, edge, and role counts', () => {
        const prozess = loadFixtureProzess(name);
        const version = prozess.latestVersion!;
        expect(version.id).toBe(exp.versionId);
        expect(version.alleSchritte).toHaveLength(exp.steps);
        const edges = version.alleSchritte.reduce(
          (n, s) => n + s.verbindungen.length,
          0,
        );
        expect(edges).toBe(exp.edges);
        expect(version.rollen).toHaveLength(exp.rollen);
      });

      it('matches the recorded step-type histogram', () => {
        const steps = loadFixtureProzess(name).latestVersion!.alleSchritte;
        expect(histogram(steps)).toEqual(exp.stepTypes);
      });

      it('exposes the nodePosition field for every step and the start node exists', () => {
        const version = loadFixtureProzess(name).latestVersion!;
        const ids = new Set(version.alleSchritte.map((s) => s.id));
        expect(ids.has(version.start!.id)).toBe(true);
        for (const s of version.alleSchritte) {
          // null is valid (a never-arranged step); only `undefined` means capture drift.
          expect(s.nodePosition, `${s.id} has nodePosition field`).not.toBe(
            undefined,
          );
        }
      });

      it('every connection references existing steps (no dangling edges)', () => {
        const steps = loadFixtureProzess(name).latestVersion!.alleSchritte;
        const ids = new Set(steps.map((s) => s.id));
        for (const s of steps) {
          for (const v of s.verbindungen) {
            expect(ids.has(v.vonId), `edge ${v.id} vonId`).toBe(true);
            expect(ids.has(v.nachId), `edge ${v.id} nachId`).toBe(true);
          }
        }
      });
    });
  }
});
