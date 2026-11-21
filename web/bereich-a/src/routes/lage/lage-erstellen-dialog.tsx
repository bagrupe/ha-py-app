import {useFormBuilder} from '@atmina/formbuilder';
import * as Dialog from '@radix-ui/react-dialog';
import {type FC} from 'react';
import {type SubmitHandler} from 'react-hook-form';
import {useNavigate} from 'react-router';
import {toast} from 'react-toastify';
import {mutationFailed} from 'src/lib/mutation';
import {CheckboxCardListFormField} from '../../components/form/fields/checkbox-card-list-field/checkbox-card-list-field.tsx';
import {InputFormField} from '../../components/form/fields/input-field';
import {SelectFormField} from '../../components/form/fields/select-field';
import {Form} from '../../components/form/form.tsx';
import {Modal} from '../../components/modal/modal.tsx';
import {Button} from '../../components/ui/button';
import {
  useCreateLageMutation,
  useLageErstellenOptionenQuery,
} from './lage.generated.ts';

type LageErstellenFormData = {
  title: string;
  note: string;
  untereinheitId: string | undefined;
  gebietIds: string[];
};

export const LageErstellenDialog: FC<{
  onOpenChange: (open: boolean) => void;
}> = ({onOpenChange}) => {
  const navigate = useNavigate();
  const [{data}] = useLageErstellenOptionenQuery();
  const [, createLage] = useCreateLageMutation();
  const builder = useFormBuilder<LageErstellenFormData>({
    defaultValues: {
      title: '',
      note: '',
      untereinheitId: undefined,
      gebietIds: [],
    },
  });
  const untereinheitId = builder.fields.untereinheitId.$useWatch();

  const untereinheiten =
    data?.my.__typename === 'BackofficeUser'
      ? data.my.kommune.untereinheiten
      : [];
  const gebiete = (data?.gebiete ?? []).filter(
    (gebiet) => gebiet.untereinheitId === untereinheitId,
  );

  const handleSubmit: SubmitHandler<LageErstellenFormData> = async (form) => {
    const result = await createLage({
      input: {
        untereinheitId: form.untereinheitId!,
        title: form.title,
        note: form.note || null,
        gebietIds: form.gebietIds,
      },
    });
    if (mutationFailed(result)) return;
    const {lage, errors} = result.data!.createLage;
    if (errors?.length || !lage) {
      toast.error(errors?.[0]?.message ?? 'Lage konnte nicht angelegt werden.');
      return;
    }
    onOpenChange(false);
    navigate(`/lage/${lage.id}`);
  };

  return (
    <Dialog.Root open onOpenChange={onOpenChange}>
      <Modal title='Neue Lage anlegen' className='max-w-2xl'>
        <Form
          builder={builder}
          onSubmit={handleSubmit}
          className='flex flex-col gap-4'
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
          <SelectFormField
            on={builder.fields.untereinheitId}
            label='Untereinheit'
            rules={{required: true}}
            items={untereinheiten.map((untereinheit) => ({
              key: untereinheit.id,
              name: untereinheit.name,
              value: untereinheit.id,
            }))}
          />
          {untereinheitId && (
            <CheckboxCardListFormField
              label='Gebiete:'
              items={gebiete}
              on={builder.fields.gebietIds}
            />
          )}
          <div className='flex justify-end gap-2 pb-2'>
            <Button type='button' onClick={() => onOpenChange(false)}>
              Abbrechen
            </Button>
            <Button type='submit' variant='solid'>
              Lage anlegen
            </Button>
          </div>
        </Form>
      </Modal>
    </Dialog.Root>
  );
};
