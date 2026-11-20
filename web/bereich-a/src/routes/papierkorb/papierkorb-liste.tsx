import * as Dialog from '@radix-ui/react-dialog';
import {format} from 'date-fns';
import {type FC, useState} from 'react';
import {MdOutlineRestore, MdOutlineVisibility, MdSearch} from 'react-icons/md';
import {Link, useNavigate} from 'react-router';
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
import {ToolTip} from 'src/components/ui/tool-tip.tsx';
import {useAppUiStore} from 'src/lib/app-ui-store.ts';
import {useDebouncedValue} from 'src/lib/hooks/use-debounced-value.ts';
import {AntragWiederherstellen} from './antrag-wiederherstellen.tsx';
import {
  type GeloeschteAntraegeQuery,
  useGeloeschteAntraegeQuery,
} from './papierkorb.generated';

export const formatDatum = (d?: Date | null): string =>
  d ? format(d, 'dd.MM.yyyy HH:mm') : '–';

const GRID_COLS = 'lg:grid-cols-[1.2fr_9.5rem_1.3fr_8rem_10.5rem_7rem]';

type PapierkorbEintrag = NonNullable<
  NonNullable<GeloeschteAntraegeQuery['geloeschteAntraege']>['items']
>[number];

export const PapierkorbListe: FC = () => {
  const page = usePage();
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.papierkorb);
  const [search, setSearch] = useState('');
  const debouncedSearch = useDebouncedValue(search, 300);
  const navigate = useNavigate();

  const [{data, fetching}, reexecute] = useGeloeschteAntraegeQuery({
    variables: {
      search: debouncedSearch.trim() === '' ? null : debouncedSearch.trim(),
      skip: page * seitengroesse,
      take: seitengroesse,
    },
    requestPolicy: 'cache-and-network',
  });

  const antraege = data?.geloeschteAntraege?.items ?? [];
  const total = data?.geloeschteAntraege?.totalCount ?? 0;
  const pages = Math.ceil(total / seitengroesse);

  return (
    <PageShell>
      <PageHeader
        title='Papierkorb'
        description='Gelöschte Anträge, die noch nicht endgültig gelöscht wurden. Hier können sie bis zum Ablauf der Frist wiederhergestellt werden.'
      />

      <InputField
        type='search'
        value={search}
        onChange={(e) => setSearch(e.currentTarget.value)}
        label='Nach Antragstyp suchen...'
        endAdornment={<MdSearch className='text-gray-400' />}
        className='w-full sm:w-96'
      />

      <ResponsiveListContainer>
        <ResponsiveListHeader gridCols={GRID_COLS}>
          <div>Antragstyp</div>
          <div>Gelöscht am</div>
          <div>Löschgrund</div>
          <div>Gelöscht von</div>
          <div>Endgültige Löschung</div>
          <div aria-hidden />
        </ResponsiveListHeader>

        {!fetching && antraege.length === 0 ? (
          <p className='px-4 py-6 text-gray-600'>
            Keine gelöschten Anträge gefunden.
          </p>
        ) : (
          <ul>
            {responsiveListSlots(fetching, seitengroesse, antraege.length).map(
              (i) => (
                <li key={antraege[i]?.id ?? i}>
                  {fetching || !antraege[i] ? (
                    <PapierkorbRowSkeleton even={i % 2 === 0} />
                  ) : (
                    <PapierkorbRow
                      even={i % 2 === 0}
                      eintrag={antraege[i]}
                      onWiederhergestellt={(success) => {
                        if (success && antraege.length === 1 && page > 0) {
                          navigate({search: `?page=${page}`});
                        } else {
                          reexecute({requestPolicy: 'network-only'});
                        }
                      }}
                    />
                  )}
                </li>
              ),
            )}
          </ul>
        )}
      </ResponsiveListContainer>

      <div className='flex flex-col-reverse items-center gap-3 sm:flex-row sm:justify-between'>
        <PageSizeSelect listKey='papierkorb' />
        <Pagination className='bg-white sm:w-auto' totalPages={pages} />
      </div>
    </PageShell>
  );
};

const PapierkorbRow: FC<{
  even: boolean;
  eintrag: PapierkorbEintrag;
  onWiederhergestellt: (success: boolean) => void;
}> = ({even, eintrag: a, onWiederhergestellt}) => {
  const [open, setOpen] = useState(false);

  return (
    <ResponsiveListRow even={even} gridCols={GRID_COLS}>
      <ResponsiveField label='Antragstyp'>
        <span className='font-semibold'>{a.prozessBezeichnung}</span>
      </ResponsiveField>
      <ResponsiveField label='Gelöscht am'>
        {formatDatum(a.geloeschtAm)}
      </ResponsiveField>
      <ResponsiveField label='Löschgrund'>
        <span
          className='line-clamp-2 break-words pr-4'
          title={a.loeschgrund ?? ''}
        >
          {a.loeschgrund ?? '–'}
        </span>
      </ResponsiveField>
      <ResponsiveField label='Gelöscht von'>
        {a.geloeschtVon ?? '–'}
      </ResponsiveField>
      <ResponsiveField label='Endgültige Löschung'>
        {a.endgueltigGeloeschtAm
          ? formatDatum(a.endgueltigGeloeschtAm)
          : 'Keine Frist'}
      </ResponsiveField>
      <div className='flex items-center gap-1 self-center justify-self-start lg:justify-self-end'>
        <ToolTip tip='Ansehen' asChild>
          <Link
            to={`/papierkorb/${a.id}`}
            aria-label='Ansehen'
            className='rounded-full p-2 text-primary hover:bg-black/10'
          >
            <MdOutlineVisibility className='size-6' />
          </Link>
        </ToolTip>
        <Dialog.Root open={open} onOpenChange={setOpen}>
          <ToolTip tip='Wiederherstellen' asChild>
            <Dialog.Trigger asChild>
              <button
                type='button'
                aria-label='Wiederherstellen'
                className='rounded-full p-2 text-primary hover:bg-black/10'
              >
                <MdOutlineRestore className='size-6' />
              </button>
            </Dialog.Trigger>
          </ToolTip>
          <AntragWiederherstellen
            ausfuehrungId={a.id}
            onOpenChange={setOpen}
            onWiederhergestellt={onWiederhergestellt}
          />
        </Dialog.Root>
      </div>
    </ResponsiveListRow>
  );
};

const PapierkorbRowSkeleton: FC<{even: boolean}> = ({even}) => (
  <ResponsiveListRow even={even} gridCols={GRID_COLS}>
    <Skeleton className='w-40' />
    <Skeleton className='w-28' />
    <Skeleton className='w-32' />
    <Skeleton className='w-28' />
    <Skeleton className='w-28' />
    <div className='hidden lg:block' />
  </ResponsiveListRow>
);
