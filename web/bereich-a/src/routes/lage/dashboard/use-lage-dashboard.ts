import {useEffect, useMemo, useRef, useState} from 'react';
import {LageStatus} from '../../../__generated__/graphql.ts';
import {
  type DashboardLageFragment,
  useDashboardMeldungenQuery,
  useDashboardStammdatenQuery,
} from './dashboard.generated.ts';

const POLL_MELDUNGEN_MS = 3_000;
// Stammdaten carry the Gebiet geometries, so they are polled far less often than the reports.
const POLL_STAMMDATEN_MS = 15_000;

const aktuellsteLage = (lagen: DashboardLageFragment[]) =>
  lagen.find((l) => l.status === LageStatus.Active) ??
  lagen.find((l) => l.status === LageStatus.Created) ??
  lagen[0];

/** Keeps "jetzt" moving so waiting times tick without a refetch. */
export const useNow = (intervalMs = 30_000) => {
  const [now, setNow] = useState(() => Date.now());
  useEffect(() => {
    const id = setInterval(() => setNow(Date.now()), intervalMs);
    return () => clearInterval(id);
  }, [intervalMs]);
  return now;
};

/**
 * Ids of reports that appeared after the first load, for `dauerMs` each. The first load never counts as new,
 * otherwise every reload would flash the whole list.
 */
export const useNeueMeldungen = (
  meldungen: {id: string}[],
  bereit: boolean,
  dauerMs = 3_000,
): ReadonlySet<string> => {
  const bekannt = useRef<Set<string> | null>(null);
  const timers = useRef(new Set<ReturnType<typeof setTimeout>>());
  const [neu, setNeu] = useState<ReadonlySet<string>>(new Set());

  useEffect(() => {
    if (!bereit) return;
    const bisher = bekannt.current;
    bekannt.current = new Set(meldungen.map((m) => m.id));
    if (!bisher) return;
    const hinzu = [...bekannt.current].filter((id) => !bisher.has(id));
    if (hinzu.length === 0) return;
    setNeu((aktuell) => new Set([...aktuell, ...hinzu]));
    const timer = setTimeout(() => {
      timers.current.delete(timer);
      setNeu((aktuell) => {
        const rest = new Set(aktuell);
        hinzu.forEach((id) => rest.delete(id));
        return rest;
      });
    }, dauerMs);
    timers.current.add(timer);
  }, [meldungen, bereit, dauerMs]);

  useEffect(() => {
    const offen = timers.current;
    return () => offen.forEach(clearTimeout);
  }, []);

  return neu;
};

/**
 * Everything both dashboards need: the current Lage, its reports (open and archived), Gebiete with their
 * Einsatzleitungen, and all Einheiten. Polls, because the API has no subscriptions.
 */
export const useLageDashboard = (lageId?: string) => {
  const [stammdaten, refetchStammdaten] = useDashboardStammdatenQuery({
    requestPolicy: 'cache-and-network',
  });
  const lagen = useMemo(
    () => stammdaten.data?.lagen ?? [],
    [stammdaten.data?.lagen],
  );
  const lage = lageId
    ? lagen.find((l) => l.id === lageId)
    : aktuellsteLage(lagen);

  const [meldungen, refetchMeldungen] = useDashboardMeldungenQuery({
    variables: {lageId: lage?.id ?? ''},
    pause: !lage,
    requestPolicy: 'cache-and-network',
  });
  // A new data object means a finished fetch, so its arrival time is the "Aktualisiert" stamp.
  const aktualisiert = useMemo(
    () => (meldungen.data ? new Date() : null),
    [meldungen.data],
  );

  useEffect(() => {
    if (!lage) return;
    const pollIfVisible = (refetch: () => void) => () => {
      if (!document.hidden) refetch();
    };
    const ids = [
      setInterval(
        pollIfVisible(() => refetchMeldungen({requestPolicy: 'network-only'})),
        POLL_MELDUNGEN_MS,
      ),
      setInterval(
        pollIfVisible(() => refetchStammdaten({requestPolicy: 'network-only'})),
        POLL_STAMMDATEN_MS,
      ),
    ];
    return () => ids.forEach(clearInterval);
  }, [lage, refetchMeldungen, refetchStammdaten]);

  const gebiete = useMemo(() => {
    const alle = stammdaten.data?.gebiete ?? [];
    const inLage = new Set(lage?.gebiete.map((g) => g.gebietId));
    return lage ? alle.filter((g) => inLage.has(g.id)) : alle;
  }, [stammdaten.data?.gebiete, lage]);
  const einsatzleitungen = useMemo(() => {
    const byId = new Map<
      string,
      {id: string; name: string; gebiete: string[]}
    >();
    for (const gebiet of gebiete) {
      for (const el of gebiet.einsatzleitungen) {
        const entry = byId.get(el.id) ?? {
          id: el.id,
          name: el.name,
          gebiete: [],
        };
        entry.gebiete.push(gebiet.name);
        byId.set(el.id, entry);
      }
    }
    return [...byId.values()].sort((a, b) => a.name.localeCompare(b.name));
  }, [gebiete]);

  return {
    loading: stammdaten.fetching && !stammdaten.data,
    lagen,
    lage,
    meldungen: meldungen.data?.lageMeldungen ?? [],
    gebiete,
    einsatzleitungen,
    einheiten: stammdaten.data?.einheiten ?? [],
    aktualisiert,
    refetch: () => {
      refetchMeldungen({requestPolicy: 'network-only'});
      refetchStammdaten({requestPolicy: 'network-only'});
    },
  };
};

export type LageDashboardData = ReturnType<typeof useLageDashboard>;
export type Einsatzleitung = LageDashboardData['einsatzleitungen'][number];
