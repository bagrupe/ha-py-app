import {useFormBuilder} from '@atmina/formbuilder';
import {type FC, useCallback} from 'react';
import {InputFormField} from '../../../../../components/form/fields/input-field';
import {Form} from '../../../../../components/form/form.tsx';
import {Modal} from '../../../../../components/modal/modal.tsx';
import {Button} from '../../../../../components/ui/button';
import {useKommune} from '../../../../../lib/context/kommune/kommune.tsx';
import {mutationFailed} from '../../../../../lib/mutation.ts';
import {
  type ProzessUpsertInput,
  useProzessQuery,
  useUpsertProzessMutation,
} from './prozess.generated.ts';

/**
 * Eigenschaften für den Dialog zum Bearbeiten eines Prozesses.
 * @property id Die ID des zu bearbeitenden Prozesses oder null für einen neuen Prozess.
 * @property onAfterSave Callback, das nach dem Speichern des Prozesses ausgeführt wird.
 */
export type ProzessBearbeitenDialogProps = {
  id: string | null;
  onAfterSave: () => void;
};

type ProzessBearbeitenFormData = ProzessUpsertInput;

/**
 * Komponente für den Dialog zur Bearbeitung eines Prozesses.
 * Lädt bei gegebener ID die Prozessdaten, stellt ein Formular zur Bearbeitung bereit und speichert die Änderungen.
 * @param id ID des zu bearbeitenden Prozesses oder null für einen neuen Prozess.
 * @param onAfterSave Funktion, die nach dem erfolgreichen Speichern aufgerufen wird.
 */
export const ProzessBearbeitenDialog: FC<ProzessBearbeitenDialogProps> = ({
  id,
  onAfterSave,
}) => {
  const {id: kommuneId} = useKommune();

  const [{data}] = useProzessQuery({
    variables: {kommuneId, id: id ?? ''},
    pause: !id,
  });
  const prozess = data?.kommune.prozessById;
  const builder = useFormBuilder<ProzessBearbeitenFormData>({
    values: {
      id: prozess?.id,
      name: prozess?.name ?? '',
    },
  });

  const [, upsertProzess] = useUpsertProzessMutation();

  const onSubmit = useCallback(
    async (form: ProzessBearbeitenFormData) => {
      const result = await upsertProzess({input: form});
      if (mutationFailed(result) || !result.data!.prozessUpsert.prozess) {
        return;
      }
      onAfterSave();
    },
    [upsertProzess, onAfterSave],
  );

  return (
    <Modal title='Prozess bearbeiten' className='max-w-2xl' global>
      <Form builder={builder} onSubmit={onSubmit}>
        <InputFormField
          on={builder.fields.name}
          label='Name'
          rules={{required: true}}
        />
        <div className='mt-4 flex justify-end'>
          <Button>Speichern</Button>
        </div>
      </Form>
    </Modal>
  );
};
