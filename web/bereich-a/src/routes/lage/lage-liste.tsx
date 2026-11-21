import {useFormBuilder} from '@atmina/formbuilder';
import {format} from 'date-fns';
import {useState} from 'react';
import {LageStatus} from '../../__generated__/graphql.ts';
import {SelectFormField} from '../../components/form/fields/select-field';
import {PageHeader, PageShell} from '../../components/page-shell.tsx';
import {
  ResponsiveField,
  ResponsiveListContainer,
  ResponsiveListHeader,
  ResponsiveListRow,
} from '../../components/responsive-list/responsive-list.tsx';
import {Button} from '../../components/ui/button';
import {LageErstellenDialog} from './lage-erstellen-dialog.tsx';
import {lageStatusLabel, StatusBadge} from './lage-status.tsx';
import {useLagenQuery} from './lage.generated.ts';

const GRID_COLS = 'lg:grid-cols-[1fr_9rem_8rem_10rem]';

export const LageListe = () => {
  const [dialogOpen, setDialogOpen] = useState(false);
  const filter = useFormBuilder<{status: LageStatus | undefined}>();
  const status = filter.fields.status.$useWatch();
  const [{data, fetching}] = useLagenQuery({variables: {status}});
  const lagen = data?.lagen ?? [];

  return (
    <PageShell>
      <PageHeader
        title='Lagen'
        description='Lagen und ihre Gebiete verwalten.'
        actions={
          <Button variant='solid' onClick={() => setDialogOpen(true)}>
            + Neue Lage
          </Button>
        }
      />

      <SelectFormField
        on={filter.fields.status}
        label='Nach Status filtern'
        className='w-full sm:w-60'
        items={[
          {key: 'alle', name: 'Alle Status', value: undefined},
          ...Object.values(LageStatus).map((value) => ({
            key: value,
            name: lageStatusLabel[value],
            value,
          })),
        ]}
      />

      <ResponsiveListContainer>
        <ResponsiveListHeader gridCols={GRID_COLS}>
          <div>Titel</div>
          <div>Status</div>
          <div>Gebiete</div>
          <div>Angelegt</div>
        </ResponsiveListHeader>
        {lagen.map((lage, index) => (
          <ResponsiveListRow
            key={lage.id}
            even={index % 2 === 0}
            gridCols={GRID_COLS}
            to={`/lage/${lage.id}`}
          >
            <ResponsiveField label='Titel'>
              <span className='font-semibold'>{lage.title}</span>
            </ResponsiveField>
            <ResponsiveField label='Status'>
              <StatusBadge status={lage.status} />
            </ResponsiveField>
            <ResponsiveField label='Gebiete'>
              {lage.gebiete.length}
            </ResponsiveField>
            <ResponsiveField label='Angelegt'>
              {format(lage.createdAt, 'dd.MM.yyyy HH:mm')}
            </ResponsiveField>
          </ResponsiveListRow>
        ))}
        {!fetching && lagen.length === 0 && (
          <div className='p-6 text-center text-gray-500'>
            Keine Lagen vorhanden.
          </div>
        )}
      </ResponsiveListContainer>

      {dialogOpen && <LageErstellenDialog onOpenChange={setDialogOpen} />}
    </PageShell>
  );
};
