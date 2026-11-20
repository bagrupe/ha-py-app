import * as Dialog from '@radix-ui/react-dialog';
import {useRef, useState, type FC, useEffect} from 'react';
import SVG from 'react-inlinesvg';
import {IconWithCallbackButton} from 'src/components/ui/button/icon-with-callback-button.tsx';
import {mutationFailed} from 'src/lib/mutation.ts';
import Delete from '../../../assets/delete.svg';
import EditSquare from '../../../assets/edit-square.svg';
import Save from '../../../assets/save.svg';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button';
import {
  useAddProzessGroupMutation,
  useDeleteProzessGroupMutation,
  useUpdateProzessGroupMutation,
} from './prozessgroups.generated.ts';

/**
 * Typ für eine Prozessgruppe mit ID und Namen.
 */
type ProzessGruppe = {
  id: string;
  name: string;
};

/**
 * Eigenschaften für die Komponente zur Verwaltung von Prozessgruppen.
 * @param gruppen Liste der Prozessgruppen.
 * @param onSaveDeleteOrUpdate Callback, das nach Speichern, Löschen oder Aktualisieren aufgerufen wird.
 */
export type ProzessGruppenVerwaltenProps = {
  gruppen: ProzessGruppe[];
  onSaveDeleteOrUpdate: () => void;
};

/**
 * Komponente zur Verwaltung von Prozessgruppen mit Anzeige, Bearbeitung und Neuerstellung.
 * Öffnet ein Dialogfenster mit einer Liste editierbarer Prozessgruppen und einer Schaltfläche zum Hinzufügen.
 * @param gruppen Die anzuzeigenden Prozessgruppen.
 * @param onSaveDeleteOrUpdate Funktion, die nach Änderungen ausgeführt wird.
 */
export const ProzessGruppenVerwalten: FC<ProzessGruppenVerwaltenProps> = ({
  gruppen,
  onSaveDeleteOrUpdate,
}) => {
  const [, addProzessGroupMutation] = useAddProzessGroupMutation();

  return (
    <Dialog.Root>
      <Dialog.Trigger asChild>
        <Button variant='outlined'>Prozessgruppen verwalten</Button>
      </Dialog.Trigger>
      <Modal title='Gruppen verwalten'>
        <div className='flex flex-col'>
          <p className='font-bold'>Prozessgruppen:</p>
          {gruppen.map((g) => (
            <EditableTextInput
              key={g.id}
              onSaveDeleteOrUpdate={onSaveDeleteOrUpdate}
              gruppe={g}
            />
          ))}

          <Button
            className='ml-auto mt-3'
            variant='outlined'
            onClick={async () => {
              const result = await addProzessGroupMutation({
                input: {
                  name: 'Neue Prozessgruppe',
                },
              });
              if (
                mutationFailed(result) ||
                result.data!.addProzessGroup.errors?.length ||
                !result.data!.addProzessGroup.prozessGroup
              ) {
                return;
              }
              onSaveDeleteOrUpdate();
            }}
          >
            + Neue Prozessgruppe erstellen
          </Button>
        </div>
      </Modal>
    </Dialog.Root>
  );
};

/**
 * Komponente für ein editierbares Texteingabefeld zur Bearbeitung einer Prozessgruppe.
 * Ermöglicht das Ändern des Gruppennamens, Speichern der Änderung und Löschen der Gruppe.
 * Zeigt Fehlermeldungen bei ungültigen Eingaben oder Fehlern beim Löschen an.
 * @param onSaveDeleteOrUpdate Funktion, die nach Speichern, Löschen oder Aktualisieren ausgeführt wird.
 * @param gruppe Die darzustellende Prozessgruppe.
 */
const EditableTextInput: FC<{
  onSaveDeleteOrUpdate: () => void;
  gruppe: ProzessGruppe;
}> = ({onSaveDeleteOrUpdate, gruppe}) => {
  const inputRef = useRef<HTMLInputElement>(null);
  const [saveEnabled, setSaveEnabled] = useState(false);

  const [error, setError] = useState('');

  const [{fetching: updating}, updateProzessGroupMutation] =
    useUpdateProzessGroupMutation();
  const [, deleteProzessGroupMutation] = useDeleteProzessGroupMutation();

  useEffect(() => {
    if (saveEnabled) {
      inputRef.current?.focus();
    }
  }, [saveEnabled]);

  const handleSave = async () => {
    const inputValue = inputRef.current?.value;

    if (!inputValue) {
      setError('Der Gruppenname darf nicht leer sein.');
      return;
    }

    const result = await updateProzessGroupMutation({
      input: {
        id: gruppe.id,
        name: inputValue,
      },
    });

    if (mutationFailed(result)) return;

    const mutationError = result.data!.updateProzessGroup.errors?.[0]?.message;

    if (mutationError || !result.data!.updateProzessGroup.prozessGroup) {
      setError(mutationError ?? 'Ein Fehler ist aufgetreten.');
      return;
    }

    setError('');
    setSaveEnabled(false);
    onSaveDeleteOrUpdate();
  };

  return (
    <>
      <div className='mt-2 flex items-center justify-between rounded-md border'>
        <input
          ref={inputRef}
          disabled={!saveEnabled}
          className='mr-3 w-full rounded-md p-2 focus:bg-slate-200 focus:outline-none disabled:bg-transparent '
          type='text'
          id={gruppe.id}
          defaultValue={gruppe.name}
        />
        {saveEnabled ? (
          <IconWithCallbackButton
            onClick={handleSave}
            iconSrc={Save}
            disabled={updating}
          />
        ) : (
          <IconWithCallbackButton
            onClick={() => {
              setSaveEnabled(!saveEnabled);
            }}
            iconSrc={EditSquare}
          />
        )}

        <button
          type='button'
          className='material-symbols-outlined mx-2 flex gap-2 text-red-500'
          onClick={async () => {
            const response = await deleteProzessGroupMutation({
              input: {
                id: gruppe.id,
              },
            });
            if (mutationFailed(response)) return;
            const errors = response.data!.deleteProzessGroup?.errors?.[0];
            if (!errors && response.data!.deleteProzessGroup.prozessGroup) {
              setError('');
              onSaveDeleteOrUpdate();
              return;
            }
            if (!errors) {
              setError('Ein Fehler ist aufgetreten.');
              return;
            }
            switch (errors.__typename) {
              case 'ProzessGroupAssignedToProzess':
                setError(
                  'Die Gruppe ist einem Prozess zugeordnet und kann deshalb nicht gelöscht werden.',
                );
                break;
              case 'ProzessGroupNotFound':
                setError(
                  'Die Gruppe existiert nicht und konnte deshalb nicht gelöscht werden.',
                );
                break;
              default:
                setError('Ein Fehler ist aufgetreten.');
            }
          }}
        >
          <SVG src={Delete} className='fill-red-500' />
        </button>
      </div>
      {error && <div className='text-sm text-red-600'>{error}</div>}
    </>
  );
};
