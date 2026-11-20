import * as Collapsible from '@radix-ui/react-collapsible';
import {type ReactNode, useRef, useState} from 'react';
import {MdChevronLeft} from 'react-icons/md';
import {twMerge} from 'tailwind-merge';

// https://www.figma.com/design/v4Z0EWaF24LuqZ61g5bbwL/Kommunal-App?node-id=1720-4272&t=OHMnyPy2p2Sadxkk-0

/**
 * Komponente zur Darstellung eines aufklappbaren Bereichs mit optionalem Standardzustand.
 * Zeigt eine Überschrift und bei Aktivierung den Inhalt an.
 *
 * @param heading - Überschrift des Akkordeons.
 * @param defaultOpen - Gibt an, ob das Akkordeon standardmäßig geöffnet ist.
 * @param children - Inhalt, der im Akkordeon angezeigt wird.
 * @param className - Optionale CSS-Klassen für die äußere Komponente.
 */
export const Accordion = ({
  heading,
  defaultOpen = false,
  children,
  className,
}: {
  heading?: ReactNode;
  defaultOpen?: boolean;
  children?: ReactNode;
  className?: string;
}) => {
  const [open, setOpen] = useState(defaultOpen);
  // Keep content mounted when expanded for the first time (lazy).
  // This benefits for example the map component, which is able to load its resources on demand and only once.
  const mountedRef = useRef<undefined | true>(undefined);

  if (open) {
    // FIXME(react-hooks v7): mutating ref during render breaks under React Compiler.
    // eslint-disable-next-line react-hooks/refs
    mountedRef.current = true;
  }

  return (
    <Collapsible.Root
      defaultOpen={defaultOpen}
      className={twMerge(
        'border-grey-300 w-full overflow-hidden rounded-lg border',
        className,
      )}
    >
      <Collapsible.Trigger asChild>
        <button
          type='button'
          /* -mb-px to collapse heading bottom border & outer border */
          className='-mb-px flex h-11 w-full items-center justify-between gap-4 rounded-t-lg border-b border-gray-300 bg-gray-50 p-2 text-left hover:cursor-pointer'
          onClick={() => setOpen((prev) => !prev)}
        >
          <div className='w-full'>{heading}</div>
          <div className='mr-4 flex size-4 items-center justify-center rounded-full border border-neutral-900'>
            <MdChevronLeft
              className={twMerge(
                'fill-neutral-900 transition-transform',
                open ? 'rotate-90' : '-rotate-90',
              )}
            />
          </div>
        </button>
      </Collapsible.Trigger>
      <Collapsible.Content
        // FIXME(react-hooks v7): reading ref during render breaks under React Compiler.
        // eslint-disable-next-line react-hooks/refs
        forceMount={mountedRef.current}
        className={twMerge(!open && 'hidden')}
      >
        {children}
      </Collapsible.Content>
    </Collapsible.Root>
  );
};
