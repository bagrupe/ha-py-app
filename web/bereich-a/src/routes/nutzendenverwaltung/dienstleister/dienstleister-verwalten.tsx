import {useFormBuilder} from '@atmina/formbuilder';
import {useState} from 'react';
import {InputFormField} from '../../../components/form/fields/input-field';
import {Form} from '../../../components/form/form.tsx';
import {Button} from '../../../components/ui/button';
import {mutationFailed} from '../../../lib/mutation.ts';
import {EditableTextForm} from '../components/editable-text-input.tsx';
import {NeueEMailAdressenFeld} from '../components/email-list-editor.tsx';
import {
  type DienstleisterCreateInput,
  useDienstleisterCreateMutation,
  useDienstleisterDeleteMutation,
  useDienstleisterQuery,
  useDienstleisterUpdateMutation,
} from './dienstleister.generated.ts';

/**
 * Komponente zur Verwaltung von Dienstleistern.
 * Zeigt eine Liste vorhandener Dienstleister an und ermöglicht das Erstellen, Aktualisieren und Löschen.
 */
export const DienstleisterVerwalten = () => {
  const [{data}, refetch] = useDienstleisterQuery({
    requestPolicy: 'network-only',
  });
  const [, createDienstleister] = useDienstleisterCreateMutation();
  const [, updateDienstleister] = useDienstleisterUpdateMutation();
  const [, deleteDienstleister] = useDienstleisterDeleteMutation();

  const dienstleister = data?.dienstleister?.items ?? [];
  const builder = useFormBuilder<DienstleisterCreateInput>({
    defaultValues: {name: '', organisationseinheitIds: []},
  });
  const [neueEMailAdressen, setNeueEMailAdressen] = useState<string[]>([]);

  /**
   * Callback-Funktion zum Erstellen eines neuen Dienstleisters.
   * @param data Die Eingabedaten für den neuen Dienstleister
   */
  const onSubmit = async (data: DienstleisterCreateInput) => {
    const res = await createDienstleister({
      input: {
        ...data,
        organisationseinheitIds: [],
        eMailAdressen: neueEMailAdressen,
      },
    });

    if (mutationFailed(res)) return;

    if (res.data?.dienstleisterCreate.dienstleister) {
      builder.reset();
      setNeueEMailAdressen([]);
      refetch();
    }
  };

  return (
    <div>
      {dienstleister.map((d) => (
        <EditableTextForm
          key={d.id}
          onUpdate={async (data) => {
            const result = await updateDienstleister({
              input: {
                dienstleisterId: d.id,
                name: data.name,
                eMailAdressen: data.eMailAdressen,
                organisationseinheitIds: data.organisationseinheitIds,
              },
            });
            if (
              mutationFailed(result) ||
              result.data!.dienstleisterUpdate.errors?.length
            ) {
              return false;
            }
            refetch();
            return true;
          }}
          onDelete={async () => {
            const result = await deleteDienstleister({id: d.id});
            if (
              mutationFailed(result) ||
              result.data!.dienstleisterDelete.errors?.length
            ) {
              return;
            }
            refetch();
          }}
          object={{
            __typename: d.__typename,
            name: d.name,
            eMailAdressen: d.eMailAdressen,
            organisationseinheitIds: d.organisationseinheiten.map(
              (oe) => oe.id,
            ),
          }}
        />
      ))}
      <Form
        builder={builder}
        onSubmit={onSubmit}
        className='mt-4 flex flex-col gap-2 rounded-md bg-gray-100 p-2'
      >
        <div className='flex gap-4'>
          <InputFormField
            className='flex-1'
            on={builder.fields.name}
            label='Name des Dienstleisters'
            rules={{required: true}}
          />
          <Button variant='solid' className='my-2 shrink-0'>
            + Dienstleister hinzufügen
          </Button>
        </div>
        <NeueEMailAdressenFeld
          value={neueEMailAdressen}
          onChange={setNeueEMailAdressen}
        />
      </Form>
    </div>
  );
};
