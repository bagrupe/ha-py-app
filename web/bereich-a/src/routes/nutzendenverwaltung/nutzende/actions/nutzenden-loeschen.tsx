import * as Dialog from '@radix-ui/react-dialog';
import {useState} from 'react';
import SVG from 'react-inlinesvg';
import {toast} from 'react-toastify';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {mutationFailed} from 'src/lib/mutation';
import Delete from '../../../../assets/delete.svg';
import {useBackofficeUserDeleteMutation} from './actions.generated';

/**
 * Komponente zum Löschen eines Nutzenden mit Bestätigungsdialog.
 * @param userId ID des zu löschenden Nutzenden
 * @param userName Name des zu löschenden Nutzenden zur Anzeige im Dialog
 * @param disabled Gibt an, ob die Löschfunktion deaktiviert ist
 * @param onDelete Callback, der nach erfolgreichem Löschen ausgeführt wird
 */
export const NutzendenLoeschen = ({
  userId,
  userName,
  disabled,
  onDelete,
}: {
  userId: string;
  userName: string;
  disabled: boolean;
  onDelete: () => void;
}) => {
  const [, deleteUser] = useBackofficeUserDeleteMutation();
  const [isOpen, setIsOpen] = useState(false);

  return (
    <Dialog.Root open={isOpen} onOpenChange={setIsOpen}>
      <Dialog.Trigger asChild disabled={disabled}>
        <Button
          variant='text'
          disabled={disabled}
          type='button'
          className='rounded-full px-2 hover:bg-black/20'
        >
          <SVG src={Delete} className='fill-gray-900' />
        </Button>
      </Dialog.Trigger>

      <Modal title='Nutzenden löschen' className='w-fit'>
        <p className='mb-4 font-bold'>
          Sind Sie sicher, dass Sie {userName} löschen möchten?
        </p>
        <p>Diese Aktion kann nicht rückgängig gemacht werden</p>
        <div className='mt-12 flex w-full justify-between gap-14'>
          <Button
            className='mt-3 min-w-48 self-center'
            variant='destructive'
            onClick={async () => {
              const result = await deleteUser({input: {userId}});
              if (mutationFailed(result)) return;
              const payload = result.data!.backofficeUserDelete;
              if (payload.errors?.length || !payload.backofficeUser) return;
              toast.success(`${userName} gelöscht`);
              setIsOpen(false);
              onDelete();
            }}
          >
            Löschen
          </Button>
          <Dialog.DialogClose asChild>
            <Button
              type='button'
              className='mt-3 min-w-48 self-center'
              variant='outlined'
            >
              Abbrechen
            </Button>
          </Dialog.DialogClose>
        </div>
      </Modal>
    </Dialog.Root>
  );
};
