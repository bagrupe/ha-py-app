import {useFormBuilder} from '@atmina/formbuilder';
import {type FC, useCallback} from 'react';
import {InputFormField} from '../../../../../components/form/fields/input-field';
import {Form} from '../../../../../components/form/form.tsx';
import {Modal} from '../../../../../components/modal/modal.tsx';
import {Button} from '../../../../../components/ui/button';
import {useKommune} from '../../../../../lib/context/kommune/kommune.tsx';
import {mutationFailed} from '../../../../../lib/mutation.ts';
import {
  type ServicePortalLinkUpsertInput,
  useServicePortalLinkQuery,
  useUpsertServicePortalLinkMutation,
} from './service-portal-link.generated.ts';

/**
 * Eigenschaften für den Dialog zum Bearbeiten eines Service-Portal-Links.
 * @property id Die ID des zu bearbeitenden Links oder null für einen neuen Link.
 * @property onAfterSave Callback, das nach dem Speichern ausgeführt wird.
 */
export type ServicePortalLinkBearbeitenDialogProps = {
  id: string | null;
  onAfterSave: () => void;
};

type ServicePortalLinkBearbeitenFormData = ServicePortalLinkUpsertInput;

/**
 * Komponente für den Dialog zur Bearbeitung eines Service-Portal-Links.
 * Lädt bei gegebener ID die Linkdaten, stellt ein Formular zur Bearbeitung bereit und speichert die Änderungen.
 * @param id ID des zu bearbeitenden Links oder null für einen neuen Link.
 * @param onAfterSave Funktion, die nach dem erfolgreichen Speichern aufgerufen wird.
 */
export const ServicePortalLinkBearbeitenDialog: FC<
  ServicePortalLinkBearbeitenDialogProps
> = ({id, onAfterSave}) => {
  const {id: kommuneId} = useKommune();

  const [{data}] = useServicePortalLinkQuery({
    variables: {kommuneId, id: id ?? ''},
    pause: !id,
  });
  const link = data?.kommune.servicePortalLink;
  const builder = useFormBuilder<ServicePortalLinkBearbeitenFormData>({
    values: {
      id: link?.id,
      name: link?.name ?? '',
      url: link?.url ?? '',
    },
  });

  const [, upsertServicePortalLink] = useUpsertServicePortalLinkMutation();

  const onSubmit = useCallback(
    async (form: ServicePortalLinkBearbeitenFormData) => {
      const result = await upsertServicePortalLink({input: form});
      if (
        mutationFailed(result) ||
        !result.data!.servicePortalLinkUpsert.servicePortalLink
      ) {
        return;
      }
      onAfterSave();
    },
    [upsertServicePortalLink, onAfterSave],
  );

  return (
    <Modal title='Link bearbeiten' className='max-w-2xl' global>
      <Form builder={builder} onSubmit={onSubmit}>
        <InputFormField
          on={builder.fields.name}
          label='Name'
          rules={{required: true}}
        />
        <InputFormField
          on={builder.fields.url}
          label='URL'
          rules={{
            validate: (value) => {
              try {
                new URL(value);
                return true;
              } catch {
                return 'Es muss eine valide URL angegeben werden! Stellen Sie sicher, dass die URL mit https:// beginnt.';
              }
            },
          }}
        />

        <div className='mt-4 flex justify-end'>
          <Button>Speichern</Button>
        </div>
      </Form>
    </Modal>
  );
};
