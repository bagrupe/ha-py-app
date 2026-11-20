import {type VerbindungDaten} from './domain-types.ts';
import {
  edgeToVerbindungDaten,
  nodeToSchrittDaten,
} from './flow/flow-to-domain.ts';
import {
  type ProcessMetadata,
  type SchrittNode,
  type VerbindungEdge,
} from './flow/flow.types.ts';
import {
  type ProzessValidationResult,
  type ZustaendigkeitCatalog,
  validateProzess,
} from './validate-prozess.ts';

/**
 * Pure validation over the React Flow graph. Produces the same result as the legacy
 * `validateProzess(metadata.startId, schritte, verbindungen)` by adapting nodes/edges
 * back into the domain shape and delegating. Dangling edges and missing node ids are
 * surfaced as validation errors, never runtime crashes.
 */
export const validateGraph = (
  nodes: SchrittNode[],
  edges: VerbindungEdge[],
  metadata: ProcessMetadata,
  catalog?: ZustaendigkeitCatalog,
): ProzessValidationResult => {
  const schritte = nodes.map((node) =>
    nodeToSchrittDaten(node, metadata.rollen),
  );
  const nodeIds = new Set(schritte.map((s) => s.id));

  const verbindungen: VerbindungDaten[] = [];
  const danglingEdges: VerbindungEdge[] = [];
  for (const edge of edges) {
    if (nodeIds.has(edge.source) && nodeIds.has(edge.target)) {
      verbindungen.push(edgeToVerbindungDaten(edge));
    } else {
      danglingEdges.push(edge);
    }
  }

  const result = validateProzess(
    metadata.startId ?? '',
    schritte,
    verbindungen,
    catalog,
  );

  if (danglingEdges.length === 0) return result;

  return {
    ...result,
    valid: false,
    totalErrorCount: result.totalErrorCount + danglingEdges.length,
    globalErrors: [
      ...result.globalErrors,
      ...danglingEdges.map(() => ({
        message:
          'Eine Verbindung verweist auf einen nicht vorhandenen Schritt.',
      })),
    ],
  };
};
