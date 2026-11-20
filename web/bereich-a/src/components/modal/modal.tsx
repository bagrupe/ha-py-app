import * as Dialog from '@radix-ui/react-dialog';
import {Cross2Icon} from '@radix-ui/react-icons';
import {type FC, type ReactNode, useEffect, useState} from 'react';
import {twMerge} from 'tailwind-merge';

/**
 * Eigenschaften für die `Modal`-Komponente.
 *
 * @param title - Titel der Modale, der im Kopfbereich angezeigt wird.
 * @param description - Optionale Beschreibung, die oberhalb des Inhalts angezeigt wird.
 * @param children - Inhalt der Modale.
 * @param className - Zusätzliche CSS-Klassen für die Modale.
 * @param global - Gibt an, ob die Modale global (fixiert) oder relativ zu ihrem Container gerendert wird. Standardmäßig `false`.
 */
export type ModalProps = {
  title: string;
  description?: string;
  children: ReactNode;
  className?: string;
  contentClassName?: string;
  global?: boolean;
};

/**
 * Komponente zur Darstellung einer Modale.
 *
 * @param props - Eigenschaften wie Titel, Beschreibung und Inhalt.
 *
 * Unterstützt die optionale Fixierung der Modale auf globaler Ebene und die Platzierung basierend auf dem `main-content`-Container.
 */
export const Modal: FC<ModalProps> = ({
  title,
  description,
  children,
  className,
  contentClassName,
  global = false,
}) => {
  const [mounted, setMounted] = useState(false);
  const mainContent: HTMLElement | undefined | null =
    global || !mounted ? undefined : document.getElementById('main-content');

  useEffect(() => {
    // Wenn die Modale sofort gerendert wird (open=true), existiert das `main-content`-Element möglicherweise noch nicht.
    // FIXME(react-hooks v7): synchronous setState in effect; refactor to derive `mounted`.
    // eslint-disable-next-line react-hooks/set-state-in-effect
    setMounted(true);
  }, []);

  return (
    mounted && (
      <Dialog.Portal container={mainContent}>
        <Dialog.Overlay
          className={twMerge(
            'icy-backdrop inset-0 z-10 flex items-center data-[state=open]:animate-overlayShow',
            global ? 'fixed' : 'sticky',
          )}
        >
          <Dialog.Content
            className={twMerge(
              'relative mx-auto max-h-fit min-w-24 max-w-5xl flex-1 overflow-hidden rounded-[10px] bg-white shadow-[0px_0px_3px_0px_rgba(0,0,0,0.25)]',
              className,
            )}
            {
              /* Unterdrückt Warnung bezüglich fehlender Beschreibung */
              ...(!description ? {'aria-describedby': undefined} : undefined)
            }
          >
            <Dialog.Title
              className={twMerge(
                'm-0 rounded-t-[10px] border-b border-gray-300 bg-gray-50 px-5 py-3 text-base font-bold',
              )}
            >
              {title}
            </Dialog.Title>

            <div
              className={twMerge(
                'h-full max-h-[70vh] overflow-y-auto px-5 py-3',
                contentClassName,
              )}
            >
              {description && (
                <Dialog.Description className='text-mauve11 mb-5 mt-[10px] text-[15px] leading-normal'>
                  {description}
                </Dialog.Description>
              )}

              {children}

              <Dialog.Close asChild>
                <button
                  className='absolute right-[10px] top-[10px] inline-flex size-[25px] appearance-none items-center justify-center rounded-full focus:outline-none'
                  aria-label='Close'
                >
                  <Cross2Icon />
                </button>
              </Dialog.Close>
            </div>
          </Dialog.Content>
        </Dialog.Overlay>
      </Dialog.Portal>
    )
  );
};
