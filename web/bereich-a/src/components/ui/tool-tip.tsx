import * as Tooltip from '@radix-ui/react-tooltip';
import type {ReactNode} from 'react';
import {MdInfoOutline} from 'react-icons/md';

/**
 * Komponente zur Anzeige eines Tooltips mit optionalem Trigger-Element.
 *
 * @param tip - Der Inhalt des Tooltips, der angezeigt wird.
 * @param asChild - Gibt an, ob das Kind-Element als Trigger verwendet wird.
 * @param children - Optionales Element, das als Trigger für den Tooltip dient.
 */
export const ToolTip = ({
  tip,
  asChild,
  children,
}: {
  tip: ReactNode;
  asChild?: boolean;
  children?: ReactNode;
}) => (
  <Tooltip.Provider>
    <Tooltip.Root>
      <Tooltip.Trigger asChild={children == null ? true : asChild}>
        {children ?? (
          <div>
            <MdInfoOutline />
          </div>
        )}
      </Tooltip.Trigger>
      <Tooltip.Portal>
        <Tooltip.Content
          className='max-w-64 select-none rounded-[4px] bg-white px-[15px] py-[10px] shadow-[hsl(206_22%_7%_/_35%)_0px_10px_38px_-10px,_hsl(206_22%_7%_/_20%)_0px_10px_20px_-15px] will-change-[transform,opacity] data-[state=delayed-open]:data-[side=bottom]:animate-slideUpAndFade data-[state=delayed-open]:data-[side=left]:animate-slideRightAndFade data-[state=delayed-open]:data-[side=right]:animate-slideLeftAndFade data-[state=delayed-open]:data-[side=top]:animate-slideDownAndFade'
          sideOffset={5}
        >
          {tip}
          <Tooltip.Arrow className='fill-white' />
        </Tooltip.Content>
      </Tooltip.Portal>
    </Tooltip.Root>
  </Tooltip.Provider>
);
