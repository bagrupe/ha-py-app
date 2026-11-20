import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import {type ReactNode, useMemo, useState} from 'react';
import {type SubmitHandler} from 'react-hook-form';
import {MdForwardToInbox} from 'react-icons/md';
import {toast} from 'react-toastify';
import {mutationFailed} from 'src/lib/mutation';
import {BackofficeNutzerArt} from '../../../__generated__/graphql.ts';
import {CheckboxCardListFormField} from '../../../components/form/fields/checkbox-card-list-field/checkbox-card-list-field.tsx';
import {EmailFormField} from '../../../components/form/fields/email-field/email-field.tsx';
import {RadioFormField} from '../../../components/form/fields/radio-field/radio-field.tsx';
import {Form} from '../../../components/form/form.tsx';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button';
import {
  useInviteBackofficeUserMutation,
  useNutzendenEinladenPageQuery,
} from './nutzenden-einladen.generated.ts';

type NutzendenEinladenFormData = {
  email: string;
  art: BackofficeNutzerArt;
  organisationseinheitIds: string[];
  abteilungIds: string[];
};

/**
 * Dialog-Komponente zum Einladen von Nutzenden.
 * Zeigt ein Formular zur Eingabe der E-Mail, Auswahl der Nutzerart sowie der zugehörigen Organisationseinheiten und Abteilungen.
 * @param isSuperadmin Gibt an, ob der aktuelle Nutzer Superadmin-Rechte besitzt
 * @param onOpenChange Callback zum Öffnen oder Schließen des Dialogs
 * @param onInvite Callback nach erfolgreicher Einladung
 * @param organisationseinheiten Liste der verfügbaren Organisationseinheiten mit ID und Name
 * @param abteilungen Liste der verfügbaren Abteilungen mit ID und Name
 */
export const NutzendenEinladenDialog = ({
  isSuperadmin,
  onOpenChange,
  onInvite,
  organisationseinheiten,
  abteilungen,
}: {
  isSuperadmin: boolean;
  onOpenChange: (open: boolean) => void;
  onInvite: () => void;
  organisationseinheiten: {id: string; name: string}[];
  abteilungen: {id: string; name: string}[];
}) => {
  const builder = useFormBuilder<NutzendenEinladenFormData>({
    defaultValues: {
      email: '',
      art: BackofficeNutzerArt.Nutzer,
      organisationseinheitIds: [],
      abteilungIds: [],
    },
  });

  const [, inviteBackofficeUser] = useInviteBackofficeUserMutation();

  /**
   * Behandelt das Absenden des Einladungsformulars.
   * Prüft die Eingaben und führt die Mutation zum Einladen aus.
   * @param data Formulardaten mit E-Mail, Nutzerart, Organisationseinheiten und Abteilungen
   */
  const handleSubmit: SubmitHandler<NutzendenEinladenFormData> = async (
    data,
  ) => {
    if (data.organisationseinheitIds.length == 0) {
      toast.error('Bitte wählen Sie mindestens eine Organisationseinheit aus.');
      return;
    }
    const result = await inviteBackofficeUser({
      input: data,
    });
    if (mutationFailed(result)) return;
    if (!result.data!.result.success) return;
    toast.success('Nutzer wird eingeladen.');
    onInvite();
    onOpenChange(false);
  };

  return (
    <Modal
      title='Nutzenden einladen'
      description='Geben Sie eine E-Mail Adresse ein, um Nutzende einzuladen. Der Empfänger bekommt eine E-Mail mit der Möglichkeit sich mit einem eigenen Passwort zu registrieren.'
      className='max-w-5xl'
      contentClassName='pb-0'
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

          <RadioFormField
            on={builder.fields.art}
            items={[
              {
                name: 'Nutzer',
                value: BackofficeNutzerArt.Nutzer,
              },
              {
                name: 'Admin',
                value: BackofficeNutzerArt.Admin,
                disabled: !isSuperadmin,
              },
              {
                name: 'Superadmin',
                value: BackofficeNutzerArt.Superadmin,
                disabled: !isSuperadmin,
              },
            ]}
            orientation='horizontal'
            className='w-1/2 pl-10'
          />
        </div>

        <CheckboxCardListFormField
          label='Organisationseinheiten:'
          items={organisationseinheiten}
          on={builder.fields.organisationseinheitIds}
        />

        <CheckboxCardListFormField
          label='Abteilungen:'
          items={abteilungen}
          on={builder.fields.abteilungIds}
        />

        <div className='sticky bottom-0 z-10 flex w-full justify-end gap-4 border-t border-gray-200 bg-white py-3'>
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
 * Button-Komponente zum Öffnen des Nutzenden-Einladen-Dialogs.
 * Lädt die notwendigen Daten und steuert die Sichtbarkeit des Dialogs.
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
export const ShowNutzendenEinladenDialogButton = ({
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

  const [{data}] = useNutzendenEinladenPageQuery({
    requestPolicy: 'network-only',
  });

  const [organisationseinheiten, abteilungen] = useMemo(() => {
    if (!data || data.my.__typename !== 'BackofficeUser') return [[], []];
    const isSuperadmin = data.my.art === BackofficeNutzerArt.Superadmin;

    if (isSuperadmin) {
      return [
        data.my.mandant.organisationseinheiten,
        data.my.mandant.abteilungen,
      ];
    } else {
      return [
        data.my.organisationseinheiten.map((e) => ({
          id: e.untereinheitId,
          name: e.untereinheit.name,
        })),
        data.my.mandant.abteilungen,
      ];
    }
  }, [data]);

  return (
    <Dialog.Root open={open} onOpenChange={setOpen}>
      {controlledOpen === undefined && (
        <Dialog.Trigger asChild>
          <Button variant='outlined'>{children}</Button>
        </Dialog.Trigger>
      )}
      {/* Force unmount to reset state */}
      {open && (
        <NutzendenEinladenDialog
          isSuperadmin={
            data?.my.__typename === 'BackofficeUser' &&
            data.my.art === BackofficeNutzerArt.Superadmin
          }
          onOpenChange={setOpen}
          onInvite={onInvite}
          organisationseinheiten={organisationseinheiten}
          abteilungen={abteilungen}
        />
      )}
    </Dialog.Root>
  );
};
