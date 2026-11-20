import {Position} from '@xyflow/react';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {
  type ProcessMetadata,
  type ProzessEditorFlow,
  type SchrittNode,
  type VerbindungEdge,
} from '../../lib/flow/flow.types.ts';

/**
 * Synthetic graph builders for graph-op contract tests. Ghosts are editor-only and
 * never appear in GraphQL fixtures, so graph ops are exercised over hand-built graphs.
 */

type SchrittData = SchrittNode['data']['schritt'];

const baseSollZustaendigkeit = () => ({
  art: ZustaendigkeitArt.Buerger,
  dynamischeArten: [] as ZustaendigkeitArt[],
  versendeEMailAnMitarbeiterGruppe: false,
});

export const makeStepData = (
  id: string,
  overrides: Partial<SchrittData> = {},
): SchrittData =>
  ({
    __typename: 'FormularSchritt',
    id,
    titel: id,
    erledigungDurchBuerger: true,
    anweisung: null,
    slots: [],
    felder: [],
    sollZustaendigkeit: baseSollZustaendigkeit(),
    ...overrides,
  }) as SchrittData;

export const makeNode = (
  id: string,
  options: {
    position?: {x: number; y: number};
    schritt?: Partial<SchrittData>;
    measured?: {width: number; height: number};
    selected?: boolean;
  } = {},
): SchrittNode => ({
  id,
  type: 'schritt',
  position: options.position ?? {x: 0, y: 0},
  zIndex: 1,
  sourcePosition: Position.Right,
  targetPosition: Position.Left,
  measured: options.measured,
  selected: options.selected,
  data: {schritt: makeStepData(id, options.schritt ?? {})},
});

type VerbindungData = NonNullable<VerbindungEdge['data']>['verbindung'];

export const makeEdge = (
  id: string,
  source: string,
  target: string,
  verbindung: Partial<VerbindungData> = {},
): VerbindungEdge => ({
  id,
  source,
  target,
  type: 'kommunalEdge',
  reconnectable: true,
  data: {
    verbindung: {
      name: null,
      statusAenderung: null,
      statusAenderungBeschreibung: null,
      istRelevant: 'true',
      ...verbindung,
    },
  },
});

export const makeMetadata = (
  overrides: Partial<ProcessMetadata> = {},
): ProcessMetadata => ({
  prozessId: 'prozess-1',
  name: 'Test Prozess',
  startId: null,
  rollen: [],
  istOeffentlich: false,
  hasVersionChanges: false,
  ...overrides,
});

export const makeFlow = (
  nodes: SchrittNode[],
  edges: VerbindungEdge[],
  metadata: Partial<ProcessMetadata> = {},
): ProzessEditorFlow => ({
  nodes,
  edges,
  metadata: makeMetadata(metadata),
});

export const seqIds = (...ids: string[]) => {
  let i = 0;
  return () => {
    if (i >= ids.length) throw new Error('seqIds exhausted');
    return ids[i++];
  };
};
