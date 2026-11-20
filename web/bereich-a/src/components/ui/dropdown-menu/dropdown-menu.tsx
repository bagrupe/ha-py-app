import {
  DropdownMenu as DropdownMenuRoot,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuPortal,
  DropdownMenuTrigger,
} from '@radix-ui/react-dropdown-menu';
import {type ComponentProps, type ElementRef, forwardRef} from 'react';
import {twMerge} from 'tailwind-merge';

/**
 * Hauptkomponente für das Dropdown-Menü, die die Radix UI DropdownMenu-Komponente kapselt.
 *
 * @param props - Eigenschaften, die an die Radix DropdownMenu-Komponente weitergereicht werden.
 */
export const DropdownMenu = (
  props: ComponentProps<typeof DropdownMenuRoot>,
) => <DropdownMenuRoot {...props} />;

DropdownMenu.Trigger = DropdownMenuTrigger;
DropdownMenu.Portal = DropdownMenuPortal;

/**
 * Komponente für den Inhalt des Dropdown-Menüs mit angepasstem Styling und Animationen.
 *
 * @param props - Eigenschaften für das DropdownMenuContent-Element.
 * @param ref - Referenz auf das DOM-Element des Inhalts.
 */
const Content = forwardRef<
  ElementRef<typeof DropdownMenuContent>,
  ComponentProps<typeof DropdownMenuContent>
>((props, ref) => (
  <DropdownMenuContent
    {...props}
    ref={ref}
    sideOffset={16}
    className={twMerge(
      'min-w-56 rounded-md border border-solid border-gray-300 bg-white py-2 shadow-[0_8px_30px_rgba(0,0,0,0.25)] will-change-[opacity,transform] [text-wrap:_nowrap] data-[side=bottom]:animate-slideUpAndFade data-[side=left]:animate-slideRightAndFade data-[side=right]:animate-slideLeftAndFade data-[side=top]:animate-slideDownAndFade',
      props.className,
    )}
  />
));
Content.displayName = 'DropdownMenu.Content';
DropdownMenu.Content = Content;

/**
 * Einzelnes Element im Dropdown-Menü mit spezifischem Styling und Hover-Effekten.
 *
 * @param props - Eigenschaften für das DropdownMenuItem-Element.
 * @param ref - Referenz auf das DOM-Element des Items.
 */
const Item = forwardRef<
  ElementRef<typeof DropdownMenuItem>,
  ComponentProps<typeof DropdownMenuItem>
>((props, ref) => (
  <DropdownMenuItem
    {...props}
    ref={ref}
    className='group relative flex cursor-pointer select-none items-center rounded-[3px] px-5 py-2 leading-none outline-none hover:bg-primary/15 data-[disabled]:pointer-events-none data-[disabled]:opacity-50'
  />
));
Item.displayName = 'DropdownMenu.Item';
DropdownMenu.Item = Item;

/**
 * Visuelle Pfeil-Komponente für das Dropdown-Menü, die den Ausklappbereich anzeigt.
 */
const Arrow = () => (
  <div className='absolute left-1/2 top-0 size-4 -translate-x-2 -translate-y-2 rotate-45 border-l border-t border-l-gray-300 border-t-gray-300 bg-white' />
);
DropdownMenu.Arrow = Arrow;
