import {InfoCircledIcon} from '@radix-ui/react-icons';
import {useEffect} from 'react';
import {AusfuehrungStatus} from '../../../__generated__/graphql.ts';
import {PageShell} from '../../../components/page-shell.tsx';
import {PageSizeSelect} from '../../../components/page-size-select.tsx';
import {Pagination, usePage} from '../../../components/pagination.tsx';
import {ToolTip} from '../../../components/ui/tool-tip.tsx';
import {useAppUiStore} from '../../../lib/app-ui-store.ts';
import {getDelay as getDelay} from '../../../utils/calculate-delay-for-interval.ts';
import {useAusfuehrungenQuery} from '../ausfuehrungen.generated';
import {AusfuehrungenFilter} from '../components/ausfuehrungen-filter.tsx';
import {AusfuehrungenList} from '../components/ausfuehrungen-list.tsx';

/**
 * Komponente zur Anzeige der neuen Anträge, die zur Bearbeitung stehen.
 * Lädt paginierte Anträge mit Filtermöglichkeit und zeigt diese in einer Liste an.
 * Enthält eine Filterkomponente und eine Paginierung.
 */
export const NeueAntraege = () => {
  const page = usePage();

  const antragsartFilter = useAppUiStore((s) => s.antragsartFilter);
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.antraege);

  const [{data, fetching}, refetch] = useAusfuehrungenQuery({
    variables: {
      status: AusfuehrungStatus.BearbeitungDurchKommune,
      prozessId: antragsartFilter,
      zugewiesen: false,
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

  const hasData = data !== undefined;
  const ausfuehrungen = data?.ausfuehrungen?.items ?? [];
  const total = data?.ausfuehrungen?.totalCount ?? 0;
  const pages = Math.ceil(total / seitengroesse);

  return (
    <PageShell>
      <div className='flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between'>
        <hgroup className='flex items-center gap-2'>
          <h1 className='text-2xl font-bold'>Neue Anträge</h1>
          <ToolTip
            tip={
              <p>
                In der Tabelle finden Sie alle neuen Anträge, welche zur
                Bearbeitung stehen. Zusätzlich können Sie nach Antragstypen
                filtern oder gezielte Anträge suchen.
              </p>
            }
          >
            <InfoCircledIcon className='text-gray-400' />
          </ToolTip>
        </hgroup>
        <AusfuehrungenFilter />
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
        <p className='mt-12 font-bold'>Keine neuen Anträge</p>
      )}
    </PageShell>
  );
};
