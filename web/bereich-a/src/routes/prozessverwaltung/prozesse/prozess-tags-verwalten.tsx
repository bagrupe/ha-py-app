import * as Dialog from '@radix-ui/react-dialog';
import {type FC, useState} from 'react';
import {MdOutlineSell} from 'react-icons/md';
import {useConfirm} from '../../../components/modal/confirm-modal.tsx';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button';
import {mutationFailed} from '../../../lib/mutation.ts';
import {
  type ProzessTag,
  type UserFacingProzess_Prozess,
  useAssignProzessTagMutation,
} from './prozesse.generated.ts';

export type ProzessTagsVerwaltenProps = {
  prozess: UserFacingProzess_Prozess;
  tags: ProzessTag[];
};

export const ProzessTagsVerwalten: FC<ProzessTagsVerwaltenProps> = ({
  prozess,
  tags,
}) => {
  const [open, setOpen] = useState(false);
  const [error, setError] = useState('');
  const [{fetching}, assignProzessTagMutation] = useAssignProzessTagMutation();
  const confirm = useConfirm();

  const handleAssign = async (tag: ProzessTag) => {
    const bisherigerTraeger = tag.prozesse.find((p) => p.id !== prozess.id);
    if (bisherigerTraeger) {
      const confirmed = await confirm({
        title: 'Tag umhängen',
        content: `Der Tag "${tag.tag}" ist aktuell dem Prozess "${bisherigerTraeger.name}" zugeordnet und wird ihm entzogen.`,
        confirmText: 'Umhängen',
      });
      if (!confirmed) return;
    }

    const result = await assignProzessTagMutation({
      prozessId: prozess.id,
      tagId: tag.id,
    });

    if (mutationFailed(result)) {
      setError('Ein Fehler ist aufgetreten.');
      return;
    }

    const mutationError = result.data!.assignProzessTag.errors?.[0]?.message;
    if (mutationError || !result.data!.assignProzessTag.prozess) {
      setError(mutationError ?? 'Ein Fehler ist aufgetreten.');
      return;
    }

    setError('');
  };

  return (
    <Dialog.Root
      open={open}
      onOpenChange={(nextOpen) => {
        setOpen(nextOpen);
        if (nextOpen) setError('');
      }}
    >
      <Dialog.Trigger asChild>
        <button type='button' className='flex gap-2 font-bold text-primary'>
          <MdOutlineSell />
        </button>
      </Dialog.Trigger>
      <Modal title='Tags verwalten'>
        <div className='space-y-4'>
          <div className='text-sm'>
            Zugeordnete Tags:{' '}
            <span className='font-bold'>
              {prozess.tags.map((t) => t.tag).join(', ') || 'Keine'}
            </span>
          </div>

          <ul className='divide-y divide-neutral-200'>
            {tags.map((tag) => {
              const zugewiesen = prozess.tags.some((t) => t.id === tag.id);
              const andererTraeger = tag.prozesse.find(
                (p) => p.id !== prozess.id,
              );
              return (
                <li
                  key={tag.id}
                  className='flex items-center justify-between gap-4 py-2'
                >
                  <div>
                    <div className='font-semibold'>{tag.tag}</div>
                    {andererTraeger && (
                      <div className='text-sm text-neutral-500'>
                        Aktuell zugeordnet: {andererTraeger.name}
                      </div>
                    )}
                  </div>
                  <Button
                    variant='outlined'
                    disabled={zugewiesen || fetching}
                    onClick={() => handleAssign(tag)}
                  >
                    {zugewiesen ? 'Zugewiesen' : 'Zuweisen'}
                  </Button>
                </li>
              );
            })}
          </ul>

          {error && <div className='text-sm text-red-600'>{error}</div>}
        </div>
      </Modal>
    </Dialog.Root>
  );
};
