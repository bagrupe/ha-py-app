import {InfoCircledIcon} from '@radix-ui/react-icons';
import {useCallback, useEffect} from 'react';
import {useClient} from 'urql';
import {AusfuehrungStatus} from '../../../__generated__/graphql.ts';
import {PageShell} from '../../../components/page-shell.tsx';
import {PageSizeSelect} from '../../../components/page-size-select.tsx';
import {Pagination, usePage} from '../../../components/pagination.tsx';
import {ToolTip} from '../../../components/ui/tool-tip.tsx';
import {useAppUiStore} from '../../../lib/app-ui-store.ts';
import {MAX_PAGE_SIZE} from '../../../lib/constants.ts';
import {getDelay} from '../../../utils/calculate-delay-for-interval.ts';
import {
  AusfuehrungenDocument,
  type AusfuehrungFragment,
  useAusfuehrungenQuery,
} from '../ausfuehrungen.generated';
import {AusfuehrungenCsvExportButton} from '../components/ausfuehrungen-csv-export-button.tsx';
import {AusfuehrungenFilter} from '../components/ausfuehrungen-filter.tsx';
import {AusfuehrungenList} from '../components/ausfuehrungen-list.tsx';

/**
 * Komponente zur Anzeige der Liste abgeschlossener Anträge mit Filter- und Paginierungsfunktion.
 * Nutzt den globalen UI-Status für den Antragstyp-Filter und lädt die Daten über eine GraphQL-Abfrage.
 * Stellt eine Tabelle mit den Anträgen dar und zeigt eine Paginierung an.
 */
export const AbgeschlosseneAntraege = () => {
  const page = usePage();
  const urqlClient = useClient();

  const antragsartFilter = useAppUiStore((s) => s.antragsartFilter);
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.antraege);

  const [{data, fetching}, refetch] = useAusfuehrungenQuery({
    variables: {
      status: AusfuehrungStatus.Abgeschlossen,
      prozessId: antragsartFilter,
      skip: page * seitengroesse,
      take: seitengroesse,
    },
  });

  useEffect(() => {
    if (fetching) return;
    const delay = getDelay();

    const timerId = setTimeout(() => {
      refetch({requestPolicy: 'network-only'});
    }, delay);

    return () => clearTimeout(timerId);
  }, [fetching, refetch]);

  const loadAllAusfuehrungenForExport = useCallback(async () => {
    const all: AusfuehrungFragment[] = [];
    let skip = 0;
    let totalCount = Number.POSITIVE_INFINITY;
    while (skip < totalCount) {
      const {data: pageData, error} = await urqlClient
        .query(
          AusfuehrungenDocument,
          {
            status: AusfuehrungStatus.Abgeschlossen,
            prozessId: antragsartFilter,
            skip,
            take: MAX_PAGE_SIZE,
          },
          {requestPolicy: 'network-only'},
        )
        .toPromise();
      if (error) throw error;
      const segment = pageData?.ausfuehrungen;
      const items = segment?.items ?? [];
      if (items.length === 0) break;
      totalCount = segment.totalCount;
      all.push(...items);
      skip += MAX_PAGE_SIZE;
      if (items.length < MAX_PAGE_SIZE) break;
    }
    return all;
  }, [urqlClient, antragsartFilter]);

  const hasData = data !== undefined;
  const ausfuehrungen = data?.ausfuehrungen?.items ?? [];
  const total = data?.ausfuehrungen?.totalCount ?? 0;
  const pages = Math.ceil(total / seitengroesse);

  return (
    <PageShell>
      <div className='flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between'>
        <hgroup className='flex items-center gap-2'>
          <h1 className='text-2xl font-bold'>Abgeschlossene Anträge</h1>
          <ToolTip
            tip={
              <p>
                In der Tabelle finden Sie alle abgeschlossenen Anträge.
                Zusätzlich können Sie nach Antragstypen filtern oder gezielte
                Anträge suchen.
              </p>
            }
          >
            <InfoCircledIcon className='text-gray-400' />
          </ToolTip>
        </hgroup>
        <div className='flex shrink-0 items-center gap-2'>
          <AusfuehrungenCsvExportButton
            ausfuehrungen={ausfuehrungen}
            loadAllAusfuehrungenForExport={loadAllAusfuehrungenForExport}
            totalCountForExport={total}
          />
          <AusfuehrungenFilter />
        </div>
      </div>
      {(fetching && !hasData) || ausfuehrungen.length > 0 ? (
        <>
          <AusfuehrungenList
            ausfuehrungen={ausfuehrungen}
            loading={fetching && !hasData}
          />
          <div className='flex flex-col-reverse items-center gap-3 sm:flex-row sm:justify-between'>
            <PageSizeSelect listKey='antraege' />
            <Pagination className='bg-white sm:w-auto' totalPages={pages} />
          </div>
        </>
      ) : (
        <p className='mt-12 font-bold'>Keine abgeschlossenen Anträge</p>
      )}
    </PageShell>
  );
};
