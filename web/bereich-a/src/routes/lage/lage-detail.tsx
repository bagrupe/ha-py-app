import {useFormBuilder} from '@atmina/formbuilder';
import {format} from 'date-fns';
import {type FC, useState} from 'react';
import {type SubmitHandler} from 'react-hook-form';
import {Link, useParams} from 'react-router';
import {toast} from 'react-toastify';
import {mutationFailed} from 'src/lib/mutation';
import {
  type LageGebietStatus,
  LageStatus,
} from '../../__generated__/graphql.ts';
import {CheckboxCardListFormField} from '../../components/form/fields/checkbox-card-list-field/checkbox-card-list-field.tsx';
import {InputFormField} from '../../components/form/fields/input-field';
import {Form} from '../../components/form/form.tsx';
import {PageHeader, PageShell} from '../../components/page-shell.tsx';
import {Button} from '../../components/ui/button';
import {
  gebietTransitions,
  isOpenGebietStatus,
  StatusBadge,
} from './lage-status.tsx';
import {
  type GebietOptionFragment,
  type LageDetailFragment,
  useAddGebieteToLageMutation,
  useLageByIdQuery,
  useSetLageGebietStatusMutation,
  useUpdateLageMutation,
} from './lage.generated.ts';

const formatDatum = (date?: Date | null) =>
  date ? format(date, 'dd.MM.yyyy HH:mm') : '–';

export const LageDetail = () => {
  const {id} = useParams<{id: string}>();
  const [{data, fetching}] = useLageByIdQuery({variables: {id: id!}});

  if (fetching && !data) return null;

  const lage = data?.lage;
  if (!lage) {
    return (
      <PageShell>
        <PageHeader title='Lage nicht gefunden' />
        <Link to='/lage' className='text-primary underline'>
          Zurück zur Übersicht
        </Link>
      </PageShell>
    );
  }

  return (
    <PageShell>
      <Link to='/lage' className='text-primary underline'>
        ← Alle Lagen
      </Link>
      <PageHeader
        title={lage.title}
        actions={<StatusBadge status={lage.status} className='text-base' />}
      />
      <LageStammdaten lage={lage} />
      <GebieteTabelle lage={lage} />
      <GebieteHinzufuegen lage={lage} gebiete={data.gebiete} />
    </PageShell>
  );
};

type StammdatenFormData = {title: string; note: string};

const LageStammdaten: FC<{lage: LageDetailFragment}> = ({lage}) => {
  const [, updateLage] = useUpdateLageMutation();
  const builder = useFormBuilder<StammdatenFormData>({
    defaultValues: {title: lage.title, note: lage.note ?? ''},
  });

  const handleSubmit: SubmitHandler<StammdatenFormData> = async (form) => {
    const result = await updateLage({
      input: {lageId: lage.id, title: form.title, note: form.note || null},
    });
    if (mutationFailed(result)) return;
    const error = result.data!.updateLage.errors?.[0]?.message;
    if (error) {
      toast.error(error);
      return;
    }
    toast.success('Lage gespeichert.');
  };

  return (
    <Form
      builder={builder}
      onSubmit={handleSubmit}
      className='flex flex-col gap-2 rounded-md bg-gray-100 p-4'
    >
      <InputFormField
        on={builder.fields.title}
        label='Titel'
        rules={{required: true}}
      />
      <InputFormField
        on={builder.fields.note}
        label='Notiz'
        multiLine
        minRows={3}
      />
      <div className='flex items-center justify-between gap-4'>
        <span className='text-sm text-gray-600'>
          Angelegt: {formatDatum(lage.createdAt)} · Zuletzt geändert:{' '}
          {formatDatum(lage.updatedAt)}
        </span>
        <Button variant='solid' disabled={lage.status === LageStatus.Closed}>
          Speichern
        </Button>
      </div>
    </Form>
  );
};

const GebieteTabelle: FC<{lage: LageDetailFragment}> = ({lage}) => {
  const [{fetching}, setStatus] = useSetLageGebietStatusMutation();
  const closed = lage.status === LageStatus.Closed;

  const transition = async (gebietId: string, status: LageGebietStatus) => {
    const result = await setStatus({
      input: {lageId: lage.id, gebietId, status},
    });
    if (mutationFailed(result)) return;
    const error = result.data!.setLageGebietStatus.errors?.[0]?.message;
    if (error) toast.error(error);
  };

  return (
    <section className='flex flex-col gap-2'>
      <h2 className='text-xl font-bold'>Gebiete</h2>
      {lage.gebiete.length === 0 && (
        <p className='text-gray-500'>
          Dieser Lage sind noch keine Gebiete zugeordnet.
        </p>
      )}
      {lage.gebiete.map((lageGebiet) => (
        <div
          key={lageGebiet.id}
          className='flex flex-wrap items-center gap-4 rounded-xl border border-gray-300 bg-white p-4'
        >
          <div className='min-w-0 flex-1'>
            <div className='font-semibold'>{lageGebiet.gebiet.name}</div>
            <div className='text-sm text-gray-600'>
              Einsatzleitung:{' '}
              {lageGebiet.gebiet.einsatzleitungen
                .map((gruppe) => gruppe.name)
                .join(', ') || 'keine zugeordnet'}
            </div>
          </div>
          <StatusBadge status={lageGebiet.status} />
          <div className='flex gap-2'>
            {!closed &&
              gebietTransitions[lageGebiet.status].map((next) => (
                <Button
                  key={next.status}
                  variant={next.variant}
                  disabled={fetching}
                  onClick={() => transition(lageGebiet.gebietId, next.status)}
                >
                  {next.label}
                </Button>
              ))}
          </div>
        </div>
      ))}
    </section>
  );
};

const GebieteHinzufuegen: FC<{
  lage: LageDetailFragment;
  gebiete: GebietOptionFragment[];
}> = ({lage, gebiete}) => {
  const [open, setOpen] = useState(false);
  const [, addGebiete] = useAddGebieteToLageMutation();
  const builder = useFormBuilder<{gebietIds: string[]}>({
    defaultValues: {gebietIds: []},
  });

  const withOpenPass = new Set(
    lage.gebiete
      .filter((lageGebiet) => isOpenGebietStatus(lageGebiet.status))
      .map((lageGebiet) => lageGebiet.gebietId),
  );
  const available = gebiete.filter(
    (gebiet) =>
      gebiet.untereinheitId === lage.untereinheitId &&
      !withOpenPass.has(gebiet.id),
  );

  if (lage.status === LageStatus.Closed) return null;

  const handleSubmit: SubmitHandler<{gebietIds: string[]}> = async (form) => {
    if (form.gebietIds.length === 0) return;
    const result = await addGebiete({
      input: {lageId: lage.id, gebietIds: form.gebietIds},
    });
    if (mutationFailed(result)) return;
    const error = result.data!.addGebieteToLage.errors?.[0]?.message;
    if (error) {
      toast.error(error);
      return;
    }
    builder.reset();
    setOpen(false);
  };

  if (!open) {
    return (
      <div>
        <Button
          onClick={() => setOpen(true)}
          disabled={available.length === 0}
          title={
            available.length === 0
              ? 'Alle Gebiete der Untereinheit sind bereits aktiv zugeordnet.'
              : undefined
          }
        >
          + Gebiete hinzufügen
        </Button>
      </div>
    );
  }

  return (
    <Form
      builder={builder}
      onSubmit={handleSubmit}
      className='flex flex-col gap-4 rounded-md bg-gray-100 p-4'
    >
      <CheckboxCardListFormField
        label='Gebiete hinzufügen:'
        items={available}
        on={builder.fields.gebietIds}
      />
      <div className='flex justify-end gap-2'>
        <Button type='button' onClick={() => setOpen(false)}>
          Abbrechen
        </Button>
        <Button variant='solid'>Hinzufügen</Button>
      </div>
    </Form>
  );
};
