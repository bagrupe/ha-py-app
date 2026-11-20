import * as Dialog from '@radix-ui/react-dialog';
import {type FC} from 'react';
import {twMerge} from 'tailwind-merge';
import {Button} from '../button/Button';

/**
 * Eigenschaften für die `Modal`-Komponente.
 *
 * @param title - Titel der Modale, der im Kopfbereich angezeigt wird.
 * @param description - Optionale Beschreibung, die oberhalb des Inhalts angezeigt wird.
 * @param className - Zusätzliche CSS-Klassen für die Modale.
 * @param buttonText - Schaltflächentext für die Komponente. Wenn kein Schaltflächentext angegeben wird, wird die Schaltfläche nicht angezeigt.
 */
export type ModalProps = {
  title: string;
  description?: string;
  className?: string;
  contentClassName?: string;
  open: boolean;
  buttonText?: string;
  onClickAction?: () => void;
};

export const ControlledModal: FC<ModalProps> = ({
  title,
  description,
  className,
  open,
  buttonText,
  onClickAction,
}) => (
  <Dialog.Root open={open}>
    <Dialog.Portal>
      <Dialog.Overlay className='icy-backdrop data-[state=open]:animate-overlayShow fixed inset-0 z-[2000] flex items-center'>
        {/* TODO: Change width, make responsive? */}
        <Dialog.Content
          className={twMerge(
            'relative mx-auto max-h-fit min-w-24 max-w-lg flex-1 overflow-hidden rounded-xl border-2 border-neutral-300 bg-white shadow-[hsl(206_22%_7%_/_35%)_0px_10px_38px_-10px,_hsl(206_22%_7%_/_20%)_0px_10px_20px_-15px]',
            className,
          )}
        >
          <Dialog.Title className='m-0 rounded-t-xl border-b border-neutral-300 bg-neutral-100 px-5 py-3 text-[17px] font-medium'>
            {title}
          </Dialog.Title>

          <div className='px-5 py-3'>
            <div className='h-full max-h-[70vh] overflow-y-auto'>
              {description && (
                <Dialog.Description className='text-mauve11 mb-5 mt-[10px] text-[15px] leading-normal'>
                  {description}
                </Dialog.Description>
              )}
            </div>

            <div className='mt-4 flex w-full justify-end gap-4'>
              {/* Button is only rendered if the buttonText is supplied */}
              {buttonText ? (
                <Dialog.Close asChild>
                  {/* Existence check since onClickAction might be undefined */}
                  <Button onClick={() => onClickAction?.()} variant='solid'>
                    {buttonText}
                  </Button>
                </Dialog.Close>
              ) : null}
            </div>
          </div>
        </Dialog.Content>
      </Dialog.Overlay>
    </Dialog.Portal>
  </Dialog.Root>
);
