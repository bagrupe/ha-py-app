import {format} from 'date-fns';
import {type FC, useState} from 'react';
import {FaRegEye} from 'react-icons/fa';
import {MdSearch} from 'react-icons/md';
import {InputField} from 'src/components/form/fields/input-field';
import {PageHeader, PageShell} from 'src/components/page-shell.tsx';
import {PageSizeSelect} from 'src/components/page-size-select.tsx';
import {Pagination, usePage} from 'src/components/pagination.tsx';
import {
  ResponsiveField,
  ResponsiveListContainer,
  ResponsiveListHeader,
  ResponsiveListRow,
  responsiveListSlots,
} from 'src/components/responsive-list/responsive-list.tsx';
import {Skeleton} from 'src/components/skeleton.tsx';
import {useAppUiStore} from 'src/lib/app-ui-store.ts';
import {useDebouncedValue} from 'src/lib/hooks/use-debounced-value.ts';
import {
  type ArchivierteAntraegeQuery,
  useArchivierteAntraegeQuery,
} from './archiv.generated';

const formatDatum = (d?: Date | null): string =>
  d ? format(d, 'dd.MM.yyyy HH:mm') : '–';

const GRID_COLS = 'lg:grid-cols-[1fr_10rem_10rem_8rem]';

type ArchivEintrag = NonNullable<
  NonNullable<ArchivierteAntraegeQuery['archivierteAntraege']>['items']
>[number];

/**
 * Read-only Liste archivierter Anträge (Berechtigung "Archiv einsehen" erforderlich,
 * per <IfFunktionsberechtigung> auf Routen-Ebene durchgesetzt).
 */
export const ArchivListe: FC = () => {
  const page = usePage();
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.archiv);
  const [search, setSearch] = useState('');
  const debouncedSearch = useDebouncedValue(search, 300);

  const [{data, fetching}] = useArchivierteAntraegeQuery({
    variables: {
      search: debouncedSearch.trim() === '' ? null : debouncedSearch.trim(),
      skip: page * seitengroesse,
      take: seitengroesse,
    },
  });

  const antraege = data?.archivierteAntraege?.items ?? [];
  const total = data?.archivierteAntraege?.totalCount ?? 0;
  const pages = Math.ceil(total / seitengroesse);

  return (
    <PageShell>
      <PageHeader
        title='Archiv'
        description='Archivierte (abgeschlossene) Anträge, schreibgeschützt. Sichtbar für Nutzer:innen mit der Berechtigung „Archiv&rdquo;.'
      />

      <InputField
        type='search'
        value={search}
        onChange={(e) => setSearch(e.currentTarget.value)}
        label='Nach Prozess suchen...'
        endAdornment={<MdSearch className='text-gray-400' />}
        className='w-full sm:w-80'
      />

      <ResponsiveListContainer>
        <ResponsiveListHeader gridCols={GRID_COLS}>
          <div>Prozess</div>
          <div>Abgeschlossen am</div>
          <div>Archiviert am</div>
          <div aria-hidden />
        </ResponsiveListHeader>

        {!fetching && antraege.length === 0 ? (
          <p className='px-4 py-6 text-gray-600'>
            Keine archivierten Anträge gefunden.
          </p>
        ) : (
          <ul>
            {responsiveListSlots(fetching, seitengroesse, antraege.length).map(
              (i) => (
                <li key={antraege[i]?.id ?? i}>
                  {fetching || !antraege[i] ? (
                    <ArchivRowSkeleton even={i % 2 === 0} />
                  ) : (
                    <ArchivRow even={i % 2 === 0} eintrag={antraege[i]} />
                  )}
                </li>
              ),
            )}
          </ul>
        )}
      </ResponsiveListContainer>

      <div className='flex flex-col-reverse items-center gap-3 sm:flex-row sm:justify-between'>
        <PageSizeSelect listKey='archiv' />
        <Pagination className='bg-white sm:w-auto' totalPages={pages} />
      </div>
    </PageShell>
  );
};

const ArchivRow: FC<{even: boolean; eintrag: ArchivEintrag}> = ({
  even,
  eintrag: a,
}) => (
  <ResponsiveListRow to={`/archiv/${a.id}`} even={even} gridCols={GRID_COLS}>
    <ResponsiveField label='Prozess'>
      <span className='font-semibold'>{a.prozessBezeichnung ?? '–'}</span>
    </ResponsiveField>
    <ResponsiveField label='Abgeschlossen am'>
      {formatDatum(a.abgeschlossenAm)}
    </ResponsiveField>
    <ResponsiveField label='Archiviert am'>
      {formatDatum(a.archiviertAm)}
    </ResponsiveField>
    <div className='flex items-center gap-1.5 self-center justify-self-start text-primary lg:justify-self-end'>
      <FaRegEye className='shrink-0' />
      <span className='font-bold'>Ansehen</span>
    </div>
  </ResponsiveListRow>
);

const ArchivRowSkeleton: FC<{even: boolean}> = ({even}) => (
  <ResponsiveListRow even={even} gridCols={GRID_COLS}>
    <Skeleton className='w-40' />
    <Skeleton className='w-32' />
    <Skeleton className='w-32' />
    <div className='hidden lg:block' />
  </ResponsiveListRow>
);
