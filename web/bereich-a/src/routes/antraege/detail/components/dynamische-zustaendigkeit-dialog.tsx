import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import {type ZustaendigkeitArt} from 'src/__generated__/graphql';
import {Form} from 'src/components/form/form';
import {Modal} from 'src/components/modal/modal';
import {Button} from 'src/components/ui/button';
import {SollZustaendigkeitForm} from 'src/routes/prozesse/prozess-editor/components/form/soll-zustaendigkeit-form';
import {type SchrittSollZustaendigkeitInput} from '../detail.generated';

/**
 * Typ für das Formular mit der Soll-Zuständigkeit.
 */
type Form = {
  sollZustaendigkeit: SchrittSollZustaendigkeitInput;
};

/**
 * Komponente für den Dialog zur Auswahl der nächsten Zuständigkeit.
 * Zeigt ein Formular mit auswählbaren Zuständigkeitsarten und steuert das Öffnen und Schließen des Dialogs.
 * @param onSubmit Callback für das Absenden des Formulars mit den eingegebenen Werten
 * @param open Steuerung, ob der Dialog geöffnet ist
 * @param onClose Callback für das Schließen des Dialogs
 * @param schrittId ID des aktuellen Schritts
 * @param arten Liste der verfügbaren Zuständigkeitsarten
 */
export const DynamischeZustaendigkeitDialog = ({
  onSubmit,
  open,
  onClose: onOpenChange,
  schrittId,
  arten,
}: {
  onSubmit: (values: Form) => void;
  open: boolean;
  onClose: (open: boolean) => void;
  schrittId: string;
  arten: ZustaendigkeitArt[];
}) => {
  const defaultArt = arten.sort()[0];
  const formbuilder = useFormBuilder<Form>({
    values: {
      sollZustaendigkeit: {
        art: defaultArt,
      },
    },
  });

  return (
    <>
      <div className='w-px self-stretch bg-slate-300' />
      <Dialog.Root open={open} onOpenChange={onOpenChange}>
        <Modal title='Nächste Zuständigkeit auswählen' className='max-w-2xl'>
          <Form
            builder={formbuilder}
            onSubmit={onSubmit}
            className='flex flex-col gap-4'
          >
            <SollZustaendigkeitForm
              on={formbuilder.fields.sollZustaendigkeit}
              schrittId={schrittId}
              valueForArt={(art) => ({art})}
              arten={arten}
              abteilungPflicht
              langeNamen
            />
            <div className='flex justify-end gap-4'>
              <Button type='button' onClick={() => onOpenChange(false)}>
                Abbrechen
              </Button>
              <Button type='submit' variant='solid'>
                Weiter
              </Button>
            </div>
          </Form>
        </Modal>
      </Dialog.Root>
    </>
  );
};
