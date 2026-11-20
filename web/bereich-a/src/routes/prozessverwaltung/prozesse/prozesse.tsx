import {useFormBuilder} from '@atmina/formbuilder';
import {type FC} from 'react';
import {MdSearch} from 'react-icons/md';
import {InputFormField} from 'src/components/form/fields/input-field';
import {SelectFormField} from 'src/components/form/fields/select-field';
import {PageHeader, PageShell} from '../../../components/page-shell.tsx';
import {PageSizeSelect} from '../../../components/page-size-select.tsx';
import {Pagination, usePage} from '../../../components/pagination.tsx';
import {
  ResponsiveListContainer,
  ResponsiveListHeader,
  ResponsiveListRow,
  responsiveListSlots,
} from '../../../components/responsive-list/responsive-list.tsx';
import {Skeleton} from '../../../components/skeleton.tsx';
import {useAppUiStore} from '../../../lib/app-ui-store.ts';
import {NeuenProzessAnlegenButton} from './components/neuen-prozess-anlegen-button.tsx';
import {ProzessRow} from './components/prozess-row.tsx';
import {PROZESSE_GRID_COLS} from './grid-cols.ts';
import {ProzessGruppenVerwalten} from './prozess-gruppen-verwalten';
import {useProzessUebersichtQuery} from './prozesse.generated';

/**
 * Typ für die Suchparameter in der Prozessübersicht.
 * Enthält Suchbegriff und ausgewählte Gruppe.
 */
type ProzesseSearch = {
  search: string;
  gruppe: string;
};

const queryContext = {
  additionalTypenames: ['ServicePortalLink', 'ProzessVersion', 'Prozess'],
};

/**
 * Komponente zur Anzeige und Verwaltung der Prozessübersicht.
 * Stellt Such- und Filtermöglichkeiten bereit und zeigt die Prozessliste an.
 */
export const Prozesse: FC = () => {
  const formBuilder = useFormBuilder<ProzesseSearch>();
  const page = usePage();
  const seitengroesse = useAppUiStore((s) => s.seitengroessen.prozesse);

  const search = formBuilder.fields.search.$useWatch();
  const gruppe = formBuilder.fields.gruppe.$useWatch();

  const [{data, fetching}, refetch] = useProzessUebersichtQuery({
    variables: {
      groupId: gruppe,
      search: search,
      skip: page * seitengroesse,
      take: seitengroesse,
    },
    context: queryContext,
  });

  const userFacingProzesse =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.prozesseUndLeistungen?.items ?? []
      : [];

  const total =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.prozesseUndLeistungen?.totalCount ?? 0
      : 0;
  const pages = Math.ceil(total / seitengroesse);

  const prozessGroups =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.prozessGroups
      : [];

  const alleTags =
    data?.my.__typename === 'BackofficeUser' ? data.my.kommune.prozessTags : [];

  return (
    <PageShell>
      <PageHeader
        title='Prozessverwaltung'
        description='In der Tabelle finden Sie eine Übersicht aller Prozesse und die Möglichkeit diese zu bearbeiten. Mit der Suche können Sie einzelne Prozesse suchen.'
        actions={
          <>
            <ProzessGruppenVerwalten
              gruppen={prozessGroups}
              onSaveDeleteOrUpdate={async () => {
                refetch({requestPolicy: 'network-only'});
              }}
            />
            <NeuenProzessAnlegenButton />
          </>
        }
      />

      <div className='flex flex-wrap items-center gap-4'>
        <InputFormField
          on={formBuilder.fields.search}
          label='Nach Prozessnamen suchen...'
          endAdornment={<MdSearch className='text-gray-400' />}
          className='w-full sm:w-80'
        />
        <SelectFormField
          on={formBuilder.fields.gruppe}
          label='Nach Gruppen filtern'
          items={[
            {key: 'alle', name: 'Alle Gruppen', value: undefined},
            ...prozessGroups.map((g) => ({
              key: g.id,
              value: g.id,
              name: g.name,
            })),
          ]}
          className='w-60'
        />
      </div>

      <ResponsiveListContainer>
        <ResponsiveListHeader gridCols={PROZESSE_GRID_COLS}>
          <div>Name</div>
          <div>Gruppe</div>
          <div>Version</div>
          <div aria-hidden />
        </ResponsiveListHeader>

        {!fetching && userFacingProzesse.length === 0 ? (
          <p className='px-4 py-6 text-gray-600'>Keine Prozesse gefunden.</p>
        ) : (
          <ul>
            {responsiveListSlots(
              fetching,
              seitengroesse,
              userFacingProzesse.length,
            ).map((i) => (
              <li key={userFacingProzesse[i]?.id ?? i}>
                {fetching || !userFacingProzesse[i] ? (
                  <ResponsiveListRow
                    even={i % 2 === 0}
                    gridCols={PROZESSE_GRID_COLS}
                  >
                    <Skeleton className='w-40' />
                    <Skeleton className='w-24' />
                    <Skeleton className='w-10' />
                    <div className='hidden lg:block' />
                  </ResponsiveListRow>
                ) : (
                  <ProzessRow
                    even={i % 2 === 0}
                    prozess={userFacingProzesse[i]}
                    prozessGroups={prozessGroups}
                    alleTags={alleTags}
                  />
                )}
              </li>
            ))}
          </ul>
        )}
      </ResponsiveListContainer>

      <div className='flex flex-col-reverse items-center gap-3 sm:flex-row sm:justify-between'>
        <PageSizeSelect listKey='prozesse' />
        <Pagination className='bg-white sm:w-auto' totalPages={pages} />
      </div>
    </PageShell>
  );
};
