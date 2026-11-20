import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import {type ReactNode, useState} from 'react';
import {type SubmitHandler} from 'react-hook-form';
import {MdForwardToInbox} from 'react-icons/md';
import {toast} from 'react-toastify';
import {mutationFailed} from 'src/lib/mutation';
import {EmailFormField} from '../../../components/form/fields/email-field/email-field.tsx';
import {SelectFormField} from '../../../components/form/fields/select-field';
import {Form} from '../../../components/form/form.tsx';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button';
import {
  type DienstleisterMitarbeiterInviteInput,
  useDienstleisterEinladenPageQuery,
  useInviteDienstleisterMitarbeiterMutation,
} from './dienstleister-einladen.generated.ts';

/**
 * Dialog-Komponente zum Einladen von Mitarbeitenden eines Dienstleisters.
 * Zeigt ein Formular zur Eingabe der E-Mail und Auswahl des Dienstleisters an.
 * @param onOpenChange Callback zum Öffnen/Schließen des Dialogs
 * @param onInvite Callback nach erfolgreicher Einladung
 * @param dienstleister Liste der verfügbaren Dienstleister mit ID und Name
 */
export const DienstleisterEinladenDialog = ({
  onOpenChange,
  onInvite,
  dienstleister,
}: {
  onOpenChange: (open: boolean) => void;
  onInvite: () => void;
  dienstleister: {id: string; name: string}[];
}) => {
  const builder = useFormBuilder<DienstleisterMitarbeiterInviteInput>({
    defaultValues: {
      email: '',
      dienstleisterId: '',
    },
  });

  const [, inviteDienstleisterMitarbeiter] =
    useInviteDienstleisterMitarbeiterMutation();

  /**
   * Behandelt das Absenden des Einladungsformulars.
   * Prüft die Eingaben und führt die Mutation zum Einladen aus.
   * @param data Formulardaten mit E-Mail und Dienstleister-ID
   */
  const handleSubmit: SubmitHandler<
    DienstleisterMitarbeiterInviteInput
  > = async (data) => {
    if (!data.dienstleisterId) {
      toast.error('Bitte wählen Sie einen Dienstleister aus.');
      return;
    }
    const result = await inviteDienstleisterMitarbeiter({
      input: data,
    });
    if (mutationFailed(result)) return;
    if (!result.data!.dienstleisterMitarbeiterInvite.success) return;
    toast.success('Nutzer wird eingeladen.');
    onInvite();
    onOpenChange(false);
  };

  return (
    <Modal
      title='Dienstleister einladen'
      description='Geben Sie eine E-Mail Adresse ein, um Nutzende einzuladen. Der Empfänger bekommt eine E-Mail mit der Möglichkeit sich mit einem eigenen Passwort zu registrieren.'
      className='max-w-5xl'
    >
      <Form
        builder={builder}
        onSubmit={handleSubmit}
        className='flex flex-col gap-4'
      >
        <div className='flex'>
          <EmailFormField
            on={builder.fields.email}
            label='E-Mail Adresse'
            rules={{required: true}}
            autoComplete='off'
            className='w-1/2'
          />
        </div>
        <SelectFormField
          label='Dienstleister'
          on={builder.fields.dienstleisterId}
          items={dienstleister.map((d) => ({name: d.name, value: d.id}))}
          required
        />
        <div className='mt-4 flex w-full justify-end gap-4'>
          <Button
            type='button'
            variant='text-secondary'
            onClick={() => {
              onOpenChange(false);
            }}
          >
            Abbrechen
          </Button>
          <Button type='submit' endAdornment={<MdForwardToInbox />}>
            Einladung senden
          </Button>
        </div>
      </Form>
    </Modal>
  );
};

/**
 * Button-Komponente zum Anzeigen des Einladen-Dialogs für Dienstleister.
 * Lädt die Dienstleisterdaten und steuert die Sichtbarkeit des Dialogs.
 * Standardmäßig unkontrolliert (eigener Button + eigener Open-State). Werden `open`/
 * `onOpenChange` übergeben, wird kein eigener Trigger-Button gerendert - die Sichtbarkeit
 * wird dann komplett vom Aufrufer gesteuert (z.B. von einem `DropdownMenu.Item`, das nicht
 * verschachtelt in einen `Dialog.Trigger` werden darf, da das mit Radix' Fokus-Handling
 * zwischen Dropdown und Dialog kollidiert).
 * @param children Optionale Inhalte des Standard-Buttons (nur im unkontrollierten Modus)
 * @param onInvite Callback nach erfolgreicher Einladung
 * @param open Kontrollierter Open-State (aktiviert den kontrollierten Modus)
 * @param onOpenChange Callback für Änderungen am kontrollierten Open-State
 */
export const ShowDienstleisterEinladenDialogButton = ({
  children,
  onInvite,
  open: controlledOpen,
  onOpenChange: controlledOnOpenChange,
}: {
  children?: ReactNode;
  onInvite: () => void;
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
}) => {
  const [uncontrolledOpen, setUncontrolledOpen] = useState(false);
  const open = controlledOpen ?? uncontrolledOpen;
  const setOpen = controlledOnOpenChange ?? setUncontrolledOpen;

  const [{data}] = useDienstleisterEinladenPageQuery({
    requestPolicy: 'network-only',
  });

  return (
    <Dialog.Root open={open} onOpenChange={setOpen}>
      {controlledOpen === undefined && (
        <Dialog.Trigger asChild>
          <Button variant='outlined'>{children}</Button>
        </Dialog.Trigger>
      )}
      {/* Force unmount to reset state */}
      {open && (
        <DienstleisterEinladenDialog
          onOpenChange={setOpen}
          onInvite={onInvite}
          dienstleister={data?.dienstleister?.items ?? []}
        />
      )}
    </Dialog.Root>
  );
};
