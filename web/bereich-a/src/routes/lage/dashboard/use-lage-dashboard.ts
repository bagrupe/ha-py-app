import {useEffect, useMemo, useState} from 'react';
import {LageStatus} from '../../../__generated__/graphql.ts';
import {
  type DashboardLageFragment,
  useDashboardMeldungenQuery,
  useDashboardStammdatenQuery,
} from './dashboard.generated.ts';

const POLL_MS = 15_000;

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
    const id = setInterval(() => {
      refetchMeldungen({requestPolicy: 'network-only'});
      refetchStammdaten({requestPolicy: 'network-only'});
    }, POLL_MS);
    return () => clearInterval(id);
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
