import {type ProzessVersionErstellenInput} from '../../prozess-version-erstellen.generated.ts';
import {type GhostSchritt, type SchrittDaten} from '../domain-types.ts';
import {
  type FlowToVersionOptions,
  type ProzessEditorFlow,
  type SchrittNode,
} from '../flow/flow.types.ts';
import {schrittZuInput, verbindungZuInput} from '../input-converters.ts';

const isGhost = (schritt: SchrittDaten): schritt is GhostSchritt =>
  schritt.__typename === 'GhostSchritt';

const resolveGovManagerSchrittId = (
  schritt: Exclude<SchrittDaten, GhostSchritt>,
  node: SchrittNode,
  flow: ProzessEditorFlow,
): Exclude<SchrittDaten, GhostSchritt> => {
  if (schritt.__typename !== 'WarteAufGovManagerSchritt') return schritt;
  if (schritt.govManagerSchrittId) return schritt;

  const upstreamId = flow.edges.find((edge) => edge.target === node.id)?.source;
  const upstream = flow.nodes.find(
    (candidate) =>
      candidate.id === upstreamId &&
      candidate.data.schritt.__typename === 'GovManagerRestExportSchritt',
  );

  return upstream ? {...schritt, govManagerSchrittId: upstream.id} : schritt;
};

/**
 * Serializes the live React Flow graph + metadata into the version-create input:
 * `node.position` reconstructs `nodePosition`, `edge.source` / `edge.target`
 * reconstruct `vonId` / `nachId`, ghost nodes and any edge incident to a ghost
 * are excluded (so the payload never references a GHOST-* id), the empty
 * `WarteAufGovManager` reference resolves from its upstream GovManager step, and
 * only roles referenced by a step are emitted.
 */
export const flowToVersionInput = (
  flow: ProzessEditorFlow,
  {veroeffentlichen}: FlowToVersionOptions,
): ProzessVersionErstellenInput => {
  const ghostIds = new Set(
    flow.nodes
      .filter((node) => isGhost(node.data.schritt))
      .map((node) => node.id),
  );

  const schrittNodes = flow.nodes.filter((node) => !isGhost(node.data.schritt));

  const schritte = schrittNodes.map((node) => {
    const schritt = {
      ...node.data.schritt,
      nodePosition: node.position,
    } as Exclude<SchrittDaten, GhostSchritt>;

    return schrittZuInput(resolveGovManagerSchrittId(schritt, node, flow));
  });

  const verbindungen = flow.edges
    .filter((edge) => !ghostIds.has(edge.source) && !ghostIds.has(edge.target))
    .map((edge) =>
      verbindungZuInput({
        ...edge.data!.verbindung,
        id: edge.id,
        vonId: edge.source,
        nachId: edge.target,
      }),
    );

  const usedRollenIds = schrittNodes.flatMap((node) => {
    const schritt = node.data.schritt as Exclude<SchrittDaten, GhostSchritt>;
    return [schritt.schreibtRolleId, schritt.sollZustaendigkeit.liestRolleId];
  });

  const zustaendigkeitRollen = flow.metadata.rollen
    .filter((rolle) => usedRollenIds.includes(rolle.id))
    .map((rolle) => ({id: rolle.id, name: rolle.name}));

  return {
    prozessId: flow.metadata.prozessId,
    schritte,
    verbindungen,
    veroeffentlichen,
    zustaendigkeitRollen,
  };
};
