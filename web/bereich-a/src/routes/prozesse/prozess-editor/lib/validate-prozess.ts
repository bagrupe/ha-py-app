import {intersection} from 'lodash';
import {ZustaendigkeitArt} from 'src/__generated__/graphql';
import {type VerbindungDaten, type SchrittDaten} from './domain-types.ts';
import {emailRecipient} from './email-benachrichtigung.ts';

/**
 * Repräsentiert einen Validierungsfehler im Prozess.
 */
export type ProzessValidationError = {
  message: string;
};

/**
 * Enthält Validierungsfehler und den zugehörigen Schritt.
 */
export type NodeValidationErrors = {
  errors: ProzessValidationError[];
  schritt: SchrittDaten;
};

/**
 * Ergebnis der Prozessvalidierung mit Status und Fehlern.
 */
export type ProzessValidationResult = {
  valid: boolean;
  totalErrorCount: number;
  errors: Record<string, NodeValidationErrors>;
  globalErrors: ProzessValidationError[];
};

/** Die Schlüssel von `oeGroups` sind zugleich die gültigen OE-IDs der Kommune. */
export type ZustaendigkeitCatalog = {
  oeGroups: Map<string, Set<string>>;
  dienstleisterOEs: Map<string, Set<string>>;
  mitarbeiterGruppenWithoutEmail: Set<string>;
  dienstleisterWithoutEmail: Set<string>;
  /** `implementationAssemblyQualifiedName`s der Programmatischen Schritte mit `liefertZustaendigkeit`. */
  liefertZustaendigkeitImpls?: Set<string>;
};

/**
 * Richtung für die Graphdurchlauf-Funktion.
 */
export enum VisitDirection {
  Up,
  Down,
}

/**
 * Typ für die Tiefensuche-Funktion im Prozessgraphen.
 */
type VisitDfsFunction = (
  nodeIds: string[],
  direction: VisitDirection,
  onVisit: (
    schritt: SchrittDaten,
    neighbors: [incoming: string[], outgoing: string[]],
    isLeafNode: boolean,
  ) => void,
  maxDepth?: number,
  depth?: number,
  visited?: Set<string>,
) => void;

/**
 * Rückgabetyp des Prozessgraph-Besuchers mit Graphstruktur und DFS-Funktion.
 */
export type ProzessVisitorReturn = {
  graph: Record<string, [incoming: string[], outgoing: string[]]>;
  schritte: Map<string, SchrittDaten>;
  visitDfs: VisitDfsFunction;
};

/**
 * Erzeugt eine Struktur zur Traversierung des Prozessgraphen.
 * @param prozessSchritte Alle Schritte des Prozesses.
 * @param prozessVerbindungen Alle Verbindungen des Prozesses.
 * @returns Objekt mit Graph, Schritt-Mapping und DFS-Funktion.
 */
export const createProzessVisitor = (
  prozessSchritte: SchrittDaten[],
  prozessVerbindungen: VerbindungDaten[],
): ProzessVisitorReturn => {
  const graph: Record<string, [incoming: string[], outgoing: string[]]> = {};
  const schritte = new Map<string, SchrittDaten>();

  for (const schritt of prozessSchritte) {
    graph[schritt.id] ??= [[], []];
    schritte.set(schritt.id, schritt);
  }

  for (const verbindung of prozessVerbindungen) {
    graph[verbindung.vonId][1]?.push(verbindung.nachId);
    graph[verbindung.nachId][0]?.push(verbindung.vonId);
  }

  const visitDfs = (
    nodeIds: string[],
    direction: VisitDirection,
    onVisit: (
      schritt: SchrittDaten,
      neighbors: [incoming: string[], outgoing: string[]],
      isLeafNode: boolean,
    ) => void,
    maxDepth = Infinity,
    depth = 0,
    visited = new Set<string>(),
  ) => {
    if (depth >= maxDepth) return;

    for (const nodeId of nodeIds) {
      const [incoming, outgoing] = graph[nodeId] ?? [[], []];

      visited.add(nodeId);

      const next = direction === VisitDirection.Down ? outgoing : incoming;

      const safeNeighbors = next.filter((n) => !visited.has(n));

      onVisit(schritte.get(nodeId)!, [incoming, outgoing], next.length === 0);

      if (safeNeighbors.length === 0) {
        continue;
      } else {
        visitDfs(
          safeNeighbors,
          direction,
          onVisit,
          maxDepth,
          depth + 1,
          visited,
        );
      }
    }
  };

  return {
    graph,
    schritte,
    visitDfs,
  };
};

const MISSING_EMAIL_ERROR = {
  abteilung:
    'Die E-Mail-Benachrichtigung ist aktiv, aber zu der gewählten Abteilung ist keine E-Mail-Adresse hinterlegt.',
  dienstleister:
    'Die E-Mail-Benachrichtigung ist aktiv, aber zu dem gewählten Dienstleister ist keine E-Mail-Adresse hinterlegt.',
};

/** Validiert die gespeicherten Werte — unabhängig davon, was die Sidebar gerade anzeigt. */
const validateZustaendigkeit = (
  schritt: SchrittDaten,
  catalog: ZustaendigkeitCatalog,
): ProzessValidationError[] => {
  if (schritt.__typename === 'GhostSchritt') return [];

  const {art, organisationseinheitId, mitarbeiterGruppeId, dienstleisterId} =
    schritt.sollZustaendigkeit;
  const errors: ProzessValidationError[] = [];

  if (art === ZustaendigkeitArt.Organisationseinheit) {
    if (!organisationseinheitId) {
      errors.push({
        message: 'Es muss eine Organisationseinheit gewählt werden.',
      });
    } else if (!catalog.oeGroups.has(organisationseinheitId)) {
      errors.push({
        message: 'Die gewählte Organisationseinheit existiert nicht mehr.',
      });
    } else if (
      mitarbeiterGruppeId &&
      !catalog.oeGroups.get(organisationseinheitId)!.has(mitarbeiterGruppeId)
    ) {
      errors.push({
        message:
          'Die Abteilung gehört nicht zur gewählten Organisationseinheit.',
      });
    }
  } else if (art === ZustaendigkeitArt.Dienstleister) {
    if (!dienstleisterId) {
      errors.push({message: 'Es muss ein Dienstleister gewählt werden.'});
    }
    if (!organisationseinheitId) {
      errors.push({
        message: 'Es muss eine Organisationseinheit gewählt werden.',
      });
    } else if (
      dienstleisterId &&
      !catalog.dienstleisterOEs
        .get(dienstleisterId)
        ?.has(organisationseinheitId)
    ) {
      errors.push({
        message:
          'Die Organisationseinheit gehört nicht zum gewählten Dienstleister.',
      });
    }
  }

  const recipient = emailRecipient(schritt.sollZustaendigkeit, catalog);
  if (
    schritt.sollZustaendigkeit.versendeEMailAnMitarbeiterGruppe &&
    recipient?.id != null &&
    !recipient.hasEmail
  ) {
    errors.push({message: MISSING_EMAIL_ERROR[recipient.kind]});
  }

  return errors;
};

/**
 * Validiert einen Prozess auf Konsistenz und Regeln.
 * @param startId ID des Start-Schritts.
 * @param prozessSchritte Alle Schritte des Prozesses.
 * @param prozessVerbindungen Alle Verbindungen des Prozesses.
 * @param catalog Optionale Referenzdaten für die Zuständigkeitsprüfung.
 * @returns Validierungsergebnis mit Fehlern und Status.
 */
export const validateProzess = (
  startId: string,
  prozessSchritte: SchrittDaten[],
  prozessVerbindungen: VerbindungDaten[],
  catalog?: ZustaendigkeitCatalog,
): ProzessValidationResult => {
  const errors: Record<string, NodeValidationErrors> = {};
  const globalErrors: ProzessValidationError[] = [];

  const getTotalErrorCount = () =>
    Object.values(errors).reduce((acc, ne) => acc + ne.errors.length, 0) +
    globalErrors.length;

  // Über ALLE Schritte prüfen (nicht nur erreichbare): der Serializer sendet beim Speichern
  // ebenfalls alle Schritte.
  if (catalog) {
    for (const schritt of prozessSchritte) {
      for (const error of validateZustaendigkeit(schritt, catalog)) {
        (errors[schritt.id] ??= {schritt, errors: []}).errors.push(error);
      }
    }
  }

  if (!startId) {
    globalErrors.push({
      message: 'Ein Prozess benötigt genau einen Start-Schritt.',
    });
    return {
      valid: false,
      totalErrorCount: getTotalErrorCount(),
      errors: errors,
      globalErrors,
    };
  }

  const {graph, schritte, visitDfs} = createProzessVisitor(
    prozessSchritte,
    prozessVerbindungen,
  );

  const possibleStartNodes = Object.entries(graph).filter(
    ([, [inc]]) => inc.length === 0,
  );

  let hasEndeSchritt = false;

  visitDfs(
    possibleStartNodes.map(([id]) => id),
    VisitDirection.Down,
    (schritt, [incoming, outgoing]) => {
      const addError = (error: ProzessValidationError, id = schritt.id) => {
        errors[id] ??= {
          schritt,
          errors: [],
        };
        errors[id].errors.push(error);
      };

      const isStart = schritt.id === startId;
      const isEnde = schritt.__typename === 'EndeSchritt';

      if (isEnde) {
        hasEndeSchritt = true;
      }

      if (!isEnde) {
        let reachesEnd = false;
        visitDfs(outgoing, VisitDirection.Down, (s) => {
          if (s.__typename === 'EndeSchritt') {
            reachesEnd = true;
          }
        });

        if (!reachesEnd) {
          addError({
            message: 'Pfad führt nicht in einen Ende-Schritt',
          });
        }
      }

      const prevNodes: SchrittDaten[] = [];
      const nextNodes: SchrittDaten[] = [];

      visitDfs(incoming, VisitDirection.Up, (s) => prevNodes.push(s), 1);
      visitDfs(outgoing, VisitDirection.Down, (s) => nextNodes.push(s), 1);

      const liefertZustaendigkeitSelbst =
        schritt.__typename === 'ProgrammatischerSchritt' &&
        (catalog?.liefertZustaendigkeitImpls?.has(
          schritt.implementationAssemblyQualifiedName,
        ) ??
          false);

      if (schritt.__typename === 'GhostSchritt') {
        addError({
          message: `Platzhalter müssen vor dem Speichern entfernt oder ersetzt werden.`,
        });
      } else {
        if (schritt.sollZustaendigkeit.liestRolleId) {
          const rollen = collectAvailableRollen(
            {graph, schritte, visitDfs},
            incoming,
          );

          if (!rollen.includes(schritt.sollZustaendigkeit.liestRolleId)) {
            addError({
              message: `Rolle "${schritt.sollZustaendigkeit.liestRolle?.name}" ist nicht von allen eingehenden Verbindungen gesetzt.`,
            });
          }
        }

        if (
          !liefertZustaendigkeitSelbst &&
          schritt.sollZustaendigkeit.art === ZustaendigkeitArt.Buerger &&
          nextNodes.some(
            (s) =>
              s.__typename !== 'GhostSchritt' &&
              s.sollZustaendigkeit.art === ZustaendigkeitArt.Dynamisch &&
              !s.sollZustaendigkeit.liestRolleId,
          )
        ) {
          addError({
            message: `Ein Schritt mit Zuständigkeit Bürger darf nicht vor einem Schritt mit dynamischer Zuständigkeit stattfinden.`,
          });
        }
      }

      if (
        schritt.__typename === 'ProgrammatischerSchritt' &&
        !liefertZustaendigkeitSelbst &&
        nextNodes.some(
          (s) =>
            s.__typename !== 'GhostSchritt' &&
            s.sollZustaendigkeit.art === ZustaendigkeitArt.Dynamisch &&
            !s.sollZustaendigkeit.liestRolleId,
        )
      ) {
        addError({
          message: `Ein Programmatischer Schritt darf nicht vor einem Schritt mit Dynamischer Zuständigkeit (ohne Rolle) stattfinden.`,
        });
      }

      if (!isStart && prevNodes.length === 0) {
        addError({
          message: `${
            schritt.__typename === 'GhostSchritt' ? 'Platzhalter' : 'Schritt'
          } benötigt mindestens eine eingehende Verbindung`,
        });
      }

      if (!isEnde && nextNodes.length === 0) {
        addError({
          message: `${
            schritt.__typename === 'GhostSchritt' ? 'Platzhalter' : 'Schritt'
          } benötigt mindestens eine ausgehende Verbindung`,
        });
      }
    },
  );

  if (!hasEndeSchritt) {
    globalErrors.push({
      message: 'Ein Prozess benötigt mindestens einen Ende-Schritt.',
    });
  }

  if (possibleStartNodes.length !== 1) {
    globalErrors.push({
      message: 'Ein Prozess muss durchgängig verbunden sein.',
    });
  }

  const totalErrorCount = getTotalErrorCount();

  return {
    valid: totalErrorCount === 0,
    totalErrorCount,
    errors,
    globalErrors,
  };
};

/**
 * Ermittelt die Schnittmenge mehrerer Mengen von Strings.
 * @param sets Array von Mengen.
 * @returns Menge mit gemeinsamen Elementen aller Eingabemengen.
 */
const intersectSets = (sets: Set<string>[]): Set<string> => {
  if (sets.length === 0) return new Set();
  return new Set(intersection(...sets.map((s) => Array.from(s))));
};

/**
 * Liefert die Rollen-IDs eines Schritts, falls vorhanden.
 * @param node Schritt-Daten.
 * @returns Menge mit der Rollen-ID oder leer.
 */
const getNodeRollen = (node: SchrittDaten): Set<string> =>
  node.__typename !== 'GhostSchritt' && node.schreibtRolleId
    ? new Set([node.schreibtRolleId])
    : new Set();

/**
 * Ermittelt alle gültigen Rollen, die für eingehende Verbindungen eines Knotens verfügbar sind.
 * @param param0 Prozessgraph mit Schritten und DFS-Funktion.
 * @param incoming IDs der eingehenden Knoten.
 * @returns Array der gültigen Rollen-IDs.
 */
export const collectAvailableRollen = (
  {graph, schritte, visitDfs}: ProzessVisitorReturn,
  incoming: string[],
) => {
  const upwardsReachableNodes = new Set<string>();
  const accumulatedRollenIds = new Map<string, Set<string>>();

  visitDfs(incoming, VisitDirection.Up, (s) => {
    upwardsReachableNodes.add(s.id);
    accumulatedRollenIds.set(s.id, getNodeRollen(s));
  });

  let changed = true;
  while (changed) {
    changed = false;

    for (const nodeId of upwardsReachableNodes) {
      const incomingIds = graph[nodeId][0];
      const filteredIncomingIds = incomingIds.filter((inc) => inc !== nodeId);

      if (filteredIncomingIds.length === 0) continue;

      const incomingSets = filteredIncomingIds
        .filter((inc) => upwardsReachableNodes.has(inc))
        .map((inc) => accumulatedRollenIds.get(inc) ?? new Set<string>());

      const intersection = intersectSets(incomingSets);

      const node = schritte.get(nodeId)!;
      const ownRollen = getNodeRollen(node);
      const newSet = new Set([...intersection, ...ownRollen]);

      const currentSet = accumulatedRollenIds.get(nodeId) ?? new Set();

      if (
        newSet.size !== currentSet.size ||
        [...newSet].some((x) => !currentSet.has(x))
      ) {
        accumulatedRollenIds.set(nodeId, newSet);
        changed = true;
      }
    }
  }

  const finalSets = incoming.map(
    (id) => accumulatedRollenIds.get(id) ?? new Set<string>(),
  );

  return Array.from(intersectSets(finalSets));
};
