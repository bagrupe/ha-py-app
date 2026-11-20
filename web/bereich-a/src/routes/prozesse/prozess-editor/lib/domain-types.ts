import {type WithUnparsedExpressions} from '@kommunalapp/expressions';
import {type XYPosition} from '@xyflow/react';
import {type ProzessEditorVerbindungFragment} from '../prozess-editor-verbindung.generated.ts';
import {
  type ProzessEditorSchritt,
  type SchrittSollZustaendigkeitInput,
} from '../prozess-version-erstellen.generated.ts';

/**
 * Editor-only placeholder step. Not part of the GraphQL `Schritt` union — only ever
 * created by graph operations (detach) and stripped before save.
 */
export type GhostSchritt = {
  __typename: 'GhostSchritt';
  id: string;
  titel?: string;
  slots: never[];
  nodePosition?: XYPosition | null;
};

export type SollZustaendigkeit = SchrittSollZustaendigkeitInput & {
  versendeEMailAnMitarbeiterGruppe: boolean;
};

type WithNestedEmailFlag<S> = S extends {sollZustaendigkeit: infer Z}
  ? Omit<S, 'versendeEMailAnMitarbeiterGruppe' | 'sollZustaendigkeit'> & {
      sollZustaendigkeit: Z &
        Pick<SollZustaendigkeit, 'versendeEMailAnMitarbeiterGruppe'>;
    }
  : S;

export type SchrittDaten =
  | WithNestedEmailFlag<WithUnparsedExpressions<ProzessEditorSchritt>>
  | GhostSchritt;

/**
 * A connection as the editor holds it, with expression scalars flattened to strings.
 */
export type VerbindungDaten =
  WithUnparsedExpressions<ProzessEditorVerbindungFragment>;

/**
 * A responsibility role referenced by step data via id and resolved for display through
 * process metadata.
 */
export type ZustaendigkeitRolle = {
  id: string;
  name: string;
};
