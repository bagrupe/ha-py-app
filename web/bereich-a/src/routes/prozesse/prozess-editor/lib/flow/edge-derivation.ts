import {type SchrittNode, type VerbindungEdge} from './flow.types.ts';

type SchrittData = SchrittNode['data']['schritt'];
type VerbindungData = NonNullable<VerbindungEdge['data']>;

export const isAutomatisierung = (schritt: SchrittData | undefined): boolean =>
  schritt?.__typename === 'ProgrammatischerSchritt';

/** Mirrors editor-pane's edge label derivation: the connection name wins, otherwise
 *  an automated source surfaces its `istRelevant` expression. */
const deriveLabel = (
  verbindung: VerbindungData['verbindung'],
  automatisierung: boolean,
): string | null =>
  verbindung.name || (automatisierung ? verbindung.istRelevant : null);

/** Recomputes the view-only derived edge fields (label + `automatisierung`) from the
 *  edge's current source step. Every load and every mutation that can change an
 *  edge's source must funnel through this so derived state never goes stale. */
export const deriveEdge = (
  edge: VerbindungEdge,
  sourceSchritt: SchrittData | undefined,
): VerbindungEdge => {
  const automatisierung = isAutomatisierung(sourceSchritt);
  const data: VerbindungData = {...edge.data!, automatisierung};
  return {
    ...edge,
    label: deriveLabel(data.verbindung, automatisierung),
    data,
  };
};
