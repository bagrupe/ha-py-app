import {
  deepUnparseExpressions,
  type WithUnparsedExpressions,
} from '@kommunalapp/expressions';
import {Position} from '@xyflow/react';
import {ZustaendigkeitArt} from 'src/__generated__/graphql.ts';
import {type ProzessEditorSchritt} from '../../prozess-version-erstellen.generated.ts';
import {type ProzessEditorProzess} from '../../verfuegbare-prozesse.generated.ts';
import {type VerbindungDaten} from '../domain-types.ts';
import {deriveEdge} from '../flow/edge-derivation.ts';
import {
  type IdFactory,
  type ProzessEditorFlow,
  type SchrittNode,
  type VerbindungEdge,
} from '../flow/flow.types.ts';

/** A step as it arrives from the query, expressions flattened to strings. Never a
 *  GhostSchritt — ghosts are editor-only and only ever created by graph operations. */
type LoadedSchritt = WithUnparsedExpressions<ProzessEditorSchritt>;

const defaultCreateId: IdFactory = () => crypto.randomUUID();

const DEFAULT_NODE_POSITION = {x: 100, y: 100};

const seedSchritt = (createId: IdFactory): LoadedSchritt =>
  ({
    id: createId(),
    titel: 'Neuer Schritt',
    verbindungen: [],
    erledigungDurchBuerger: true,
    slots: [],
    versendeEMailAnMitarbeiterGruppe: false,
    anweisung: null,
    sollZustaendigkeit: {
      art: ZustaendigkeitArt.Buerger,
      dynamischeArten: [],
    },
    felder: [
      {
        id: createId(),
        __typename: 'StringFormularFeld',
        angezeigterName: 'Neues Feld',
        multiline: false,
        durchsuchbar: false,
        istRelevant: 'true',
        options: [],
        slotName: 'Neuer Slot',
        order: 0,
        encrypted: false,
        pflichtfeld: false,
        oeffentlichSichtbar: false,
      },
    ],
    __typename: 'FormularSchritt',
  }) as LoadedSchritt;

const toNodeData = (schritt: LoadedSchritt): SchrittNode['data']['schritt'] => {
  const {
    verbindungen,
    nodePosition,
    schreibtRolle,
    sollZustaendigkeit,
    versendeEMailAnMitarbeiterGruppe,
    ...rest
  } = schritt;
  const {liestRolle, ...zustaendigkeit} = sollZustaendigkeit;

  return {
    ...rest,
    sollZustaendigkeit: {
      ...zustaendigkeit,
      versendeEMailAnMitarbeiterGruppe:
        versendeEMailAnMitarbeiterGruppe ?? false,
    },
  } as SchrittNode['data']['schritt'];
};

const toNode = (
  schritt: LoadedSchritt,
  startId: string | null,
): SchrittNode => ({
  id: schritt.id,
  type: 'schritt',
  position: schritt.nodePosition
    ? {x: schritt.nodePosition.x, y: schritt.nodePosition.y}
    : {...DEFAULT_NODE_POSITION},
  zIndex: 1,
  sourcePosition: Position.Right,
  targetPosition: Position.Left,
  data: {schritt: toNodeData(schritt), isStart: schritt.id === startId},
});

const toEdge = (verbindung: VerbindungDaten): VerbindungEdge => {
  const {id, vonId, nachId, ...verbindungData} = verbindung;

  return {
    id,
    source: vonId,
    target: nachId,
    type: 'kommunalEdge',
    reconnectable: true,
    data: {verbindung: verbindungData},
  };
};

export const prozessToFlow = (
  prozess: ProzessEditorProzess,
  options: {createId?: IdFactory} = {},
): ProzessEditorFlow => {
  const createId = options.createId ?? defaultCreateId;
  const latest = prozess.latestVersion;

  const schritte: LoadedSchritt[] = latest
    ? (deepUnparseExpressions(latest.alleSchritte) as LoadedSchritt[])
    : [seedSchritt(createId)];

  const startId = latest?.start?.id ?? schritte[0]?.id ?? null;

  const nodes = schritte.map((schritt) => toNode(schritt, startId));
  const stepById = new Map(nodes.map((node) => [node.id, node.data.schritt]));
  const edges = schritte
    .flatMap((schritt) => schritt.verbindungen as VerbindungDaten[])
    .map((verbindung) => {
      const edge = toEdge(verbindung);
      return deriveEdge(edge, stepById.get(edge.source));
    });

  return {
    nodes,
    edges,
    metadata: {
      prozessId: prozess.id,
      name: prozess.name,
      startId,
      rollen: latest?.rollen ?? [],
      istOeffentlich: prozess.istOeffentlich,
      latestVersionId: latest?.id,
      latestVersionPublishedAt:
        latest?.publishedAt instanceof Date
          ? latest.publishedAt.toISOString()
          : (latest?.publishedAt as string | undefined) ?? null,
      hasVersionChanges: false,
    },
  };
};
