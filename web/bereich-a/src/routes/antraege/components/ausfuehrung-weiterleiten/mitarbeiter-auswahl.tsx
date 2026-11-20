import {type FC, useState} from 'react';
import {MdCheckCircle, MdSearch} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';
import {InputField} from 'src/components/form/fields/input-field';
import {Button} from 'src/components/ui/button';
import {useDebouncedValue} from 'src/lib/hooks/use-debounced-value';
import {useMitarbeitendeQuery} from './ausfuehrung-weiterleiten.generated';

const PAGE_SIZE = 25;

export type AusgewaehlterMitarbeiter = {id: string; name: string};

type MitarbeiterAuswahlProps = {
  groupId: string | null;
  currentUserId?: string;
  selected: AusgewaehlterMitarbeiter | null;
  onSelect: (mitarbeiter: AusgewaehlterMitarbeiter) => void;
};

type MitarbeiterSeiteProps = Omit<MitarbeiterAuswahlProps, 'selected'> & {
  selectedId?: string;
  search: string;
  page: number;
  istLetzteSeite: boolean;
  onLoadMore: () => void;
};

const MitarbeiterSeite: FC<MitarbeiterSeiteProps> = ({
  groupId,
  currentUserId,
  selectedId,
  onSelect,
  search,
  page,
  istLetzteSeite,
  onLoadMore,
}) => {
  const [{data, fetching}] = useMitarbeitendeQuery({
    variables: {
      groupId,
      search: search === '' ? null : search,
      skip: page * PAGE_SIZE,
      take: PAGE_SIZE,
    },
  });

  const segment =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.mitarbeiter
      : null;
  const mitarbeitende = (segment?.items ?? []).filter(
    (m) => m.id !== currentUserId,
  );

  return (
    <>
      {mitarbeitende.map((m) => {
        const name = `${m.vorname} ${m.nachname}`;
        const istAusgewaehlt = m.id === selectedId;
        return (
          <button
            key={m.id}
            type='button'
            aria-pressed={istAusgewaehlt}
            onClick={() => onSelect({id: m.id, name})}
            className={twMerge(
              'flex w-full items-center gap-3 border-b border-gray-100 px-3 py-2 text-left last:border-b-0 hover:bg-gray-50',
              istAusgewaehlt && 'bg-primary/10 hover:bg-primary/10',
            )}
          >
            <div className='grid size-9 shrink-0 place-items-center rounded-full border-2 border-gray-500 bg-orange-200 text-sm text-gray-700'>
              {(m.vorname.charAt(0) + m.nachname.charAt(0)).toLocaleUpperCase()}
            </div>
            <div className='flex min-w-0 flex-1 flex-col'>
              <span className='truncate'>{name}</span>
              <span className='truncate text-sm text-gray-500'>{m.eMail}</span>
            </div>
            {istAusgewaehlt && (
              <MdCheckCircle className='size-5 shrink-0 text-primary' />
            )}
          </button>
        );
      })}
      {fetching && <div className='px-3 py-2 text-sm text-gray-500'>Lädt…</div>}
      {page === 0 && !fetching && mitarbeitende.length === 0 && (
        <div className='px-3 py-4 text-center text-sm text-gray-500'>
          {search === ''
            ? 'Es gibt keine weiteren Mitarbeitenden in dieser Abteilung.'
            : 'Keine Mitarbeitenden gefunden.'}
        </div>
      )}
      {istLetzteSeite && !fetching && segment?.pageInfo.hasNextPage && (
        <div className='p-2'>
          <Button
            type='button'
            variant='text-secondary'
            className='w-full'
            onClick={onLoadMore}
          >
            Weitere anzeigen
          </Button>
        </div>
      )}
    </>
  );
};

export const MitarbeiterAuswahl: FC<MitarbeiterAuswahlProps> = (props) => {
  const [search, setSearch] = useState('');
  const debouncedSearch = useDebouncedValue(search, 300).trim();
  const [anzahlSeiten, setAnzahlSeiten] = useState({search: '', count: 1});
  const seiten =
    anzahlSeiten.search === debouncedSearch ? anzahlSeiten.count : 1;

  return (
    <div className='flex flex-col gap-3'>
      <InputField
        type='search'
        autoFocus
        onKeyDown={(e) => {
          if (e.key === 'Enter') e.preventDefault();
        }}
        label='Mitarbeitende suchen (Name oder E-Mail)'
        value={search}
        onChange={(e) => setSearch(e.currentTarget.value)}
        endAdornment={<MdSearch className='text-gray-400' />}
      />
      {props.selected && (
        <div className='text-sm text-gray-600'>
          Ausgewählt: <span className='font-bold'>{props.selected.name}</span>
        </div>
      )}
      <div className='max-h-80 overflow-y-auto rounded-md border border-gray-300'>
        {Array.from({length: seiten}, (_, page) => (
          <MitarbeiterSeite
            key={`${debouncedSearch}-${page}`}
            groupId={props.groupId}
            currentUserId={props.currentUserId}
            selectedId={props.selected?.id}
            onSelect={props.onSelect}
            search={debouncedSearch}
            page={page}
            istLetzteSeite={page === seiten - 1}
            onLoadMore={() =>
              setAnzahlSeiten({search: debouncedSearch, count: seiten + 1})
            }
          />
        ))}
      </div>
    </div>
  );
};
