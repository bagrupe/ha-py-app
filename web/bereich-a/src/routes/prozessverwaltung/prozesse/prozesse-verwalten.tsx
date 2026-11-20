import * as Dialog from '@radix-ui/react-dialog';
import {type FC, useState} from 'react';
import SVG from 'react-inlinesvg';
import EditSquare from '../../../assets/edit-square.svg';
import {RadioField} from '../../../components/form/fields/radio-field/radio-field.tsx';
import {Modal} from '../../../components/modal/modal.tsx';
import {Button} from '../../../components/ui/button';
import {mutationFailed} from '../../../lib/mutation.ts';
import {
  type UserFacingProzess,
  type ProzessGroup,
  useSetGroupToProzessMutation,
} from './prozesse.generated.ts';

/**
 * Eigenschaften für die Komponente ProzesseVerwalten.
 * Enthält den anzuzeigenden Prozess und die verfügbaren Gruppen.
 */
export type ProzesseVerwaltenProps = {
  prozess: UserFacingProzess;
  gruppen: ProzessGroup[];
};

/**
 * Komponente zur Verwaltung von Prozessen und deren Gruppenzuordnung.
 * Zeigt Details des Prozesses an und ermöglicht das Zuordnen oder Entfernen von Gruppen.
 *
 * @param prozess Der anzuzeigende Prozess mit seinen Details.
 * @param gruppen Die Liste der verfügbaren Gruppen zur Auswahl.
 */
export const ProzesseVerwalten: FC<ProzesseVerwaltenProps> = ({
  prozess,
  gruppen,
}) => {
  const [{fetching}, setGroupToProzessMutation] =
    useSetGroupToProzessMutation();
  const [open, setOpen] = useState(false);
  const [selectedGroupId, setSelectedGroupId] = useState(
    prozess.group?.id ?? undefined,
  );

  const handleSubmit = async () => {
    const result = await setGroupToProzessMutation({
      prozessId: prozess.id,
      groupId: selectedGroupId,
    });

    if (
      mutationFailed(result) ||
      !result.data!.setGroupToProzess.userFacingProzess
    ) {
      return;
    }

    setOpen(false);
  };

  return (
    <Dialog.Root
      open={open}
      onOpenChange={(nextOpen) => {
        setOpen(nextOpen);
        if (nextOpen) {
          setSelectedGroupId(prozess.group?.id ?? undefined);
        }
      }}
    >
      <Dialog.Trigger asChild>
        <button type='button' className='flex gap-2 font-bold text-primary'>
          <SVG src={EditSquare} className='fill-primary' />
        </button>
      </Dialog.Trigger>
      <Modal title='Prozesse verwalten'>
        <div className='space-y-6'>
          <div className='my-3 flex flex-col rounded-lg border border-neutral-300 bg-neutral-100 p-4 sm:flex-row'>
            <div className='flex-col pr-7'>
              <div className='text-sm'>Name</div>
              <div className='font-bold'>{prozess.name}</div>
            </div>
            {prozess.__typename == 'Prozess' && (
              <div className='flex-col pr-7'>
                <div className='text-sm'>Version</div>
                <div className='font-bold'>{prozess.versionenCount}</div>
              </div>
            )}
          </div>

          <div>
            <div className='flex items-center'>
              <div className='mr-4 whitespace-nowrap font-bold'>
                Zugehörige Gruppe:
              </div>
              <div className='h-px w-full border-0 bg-neutral-300' />
            </div>

            <RadioField
              items={[
                {name: 'Keine Gruppe', value: undefined},
                ...gruppen.map((g) => ({
                  name: g.name,
                  value: g.id,
                })),
              ]}
              value={selectedGroupId}
              onChange={(value) => setSelectedGroupId(value ?? undefined)}
            />
          </div>

          <div className='flex justify-end'>
            <Button
              variant='outlined'
              submittingState={fetching}
              onClick={handleSubmit}
            >
              Übernehmen
            </Button>
          </div>
        </div>
      </Modal>
    </Dialog.Root>
  );
};
