import type {Edge, Node} from '@xyflow/react';
import type {SchrittDaten, VerbindungDaten} from '../domain-types.ts';
import type {ProzessValidationError} from '../validate-prozess.ts';

/** Editable step payload carried on a React Flow node. `prozessToFlow` strips the
 *  graph-owned fields (`verbindungen`, `nodePosition`) and the denormalized role
 *  objects (`schreibtRolle`, `sollZustaendigkeit.liestRolle`) before placing the
 *  step here; node id/position and the derived view fields live on the node. */
export type SchrittNodeData = {
  schritt: SchrittDaten;
  /** derived (start node) — view-only, never serialized */
  isStart?: boolean;
  /** derived (validation) — view-only, never serialized */
  errors?: ProzessValidationError[];
  /** transient drag-over highlight (footprint of the node being dropped) — view-only */
  intersectionCause?: {width?: number; height?: number};
};

export type SchrittNode = Node<SchrittNodeData>;

/** Editable connection payload carried on a React Flow edge.
 *  Source/target/id are owned by `edge.source` / `edge.target` / `edge.id`. */
export type VerbindungEdgeData = {
  verbindung: Omit<VerbindungDaten, 'id' | 'vonId' | 'nachId'>;
  /** derived (source step is programmatic) — view-only, never serialized */
  automatisierung?: boolean;
};

export type VerbindungEdge = Edge<VerbindungEdgeData>;

export type ZustaendigkeitRolle = {id: string; name: string};

/** The only persistent state that is not a node or an edge. */
export type ProcessMetadata = {
  prozessId: string;
  name: string;
  startId: string | null;
  rollen: ZustaendigkeitRolle[];
  istOeffentlich: boolean;
  latestVersionId?: string;
  latestVersionPublishedAt?: string | null;
  hasVersionChanges: boolean;
};

export type ProzessEditorFlow = {
  nodes: SchrittNode[];
  edges: VerbindungEdge[];
  metadata: ProcessMetadata;
};

/** Injectable for deterministic tests (defaults to crypto.randomUUID in prod). */
export type IdFactory = () => string;

export type FlowToVersionOptions = {veroeffentlichen: boolean};
