import {readFileSync} from 'node:fs';
import {dirname, join} from 'node:path';
import {fileURLToPath} from 'node:url';

const FIXTURE_DIR = join(dirname(fileURLToPath(import.meta.url)), 'fixtures');

export type FixtureName =
  | 'fuehrerschein-verlaengern'
  | 'maengelmelder'
  | 'bildung-teilhabe'
  | 'bildung-teilhabe-variant'
  | 'statusaenderung-test';

export const FIXTURE_NAMES: FixtureName[] = [
  'fuehrerschein-verlaengern',
  'maengelmelder',
  'bildung-teilhabe',
  'bildung-teilhabe-variant',
  'statusaenderung-test',
];

export function loadFixtureResponse(name: FixtureName): {
  my: {kommune: {prozessById: ProzessLike}};
} {
  return JSON.parse(
    readFileSync(join(FIXTURE_DIR, `${name}.graphql-response.json`), 'utf8'),
  );
}

export function loadFixtureProzess(name: FixtureName): ProzessLike {
  return loadFixtureResponse(name).my.kommune.prozessById;
}

export type ProzessLike = {
  id: string;
  name: string;
  latestVersion: {
    id: string;
    start: {id: string} | null;
    rollen: {id: string; name: string}[];
    alleSchritte: SchrittLike[];
  } | null;
};

export type SchrittLike = {
  __typename: string;
  id: string;
  nodePosition: {x: number; y: number} | null;
  verbindungen: {id: string; vonId: string; nachId: string}[];
};
