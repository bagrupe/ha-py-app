import {Popover} from '@base-ui/react/popover';
import {Toggle} from '@base-ui/react/toggle';
import {ToggleGroup} from '@base-ui/react/toggle-group';
import {type ReactNode} from 'react';
import {Button} from '../button/Button';
import FilterRowBaseField from './FilterRowBaseField';

export type FilterRowChipItem = {
  id: string;
  label: string;
};

export interface FilterRowChipPopoverProps {
  id?: string;
  title?: string;
  triggerIcon?: ReactNode;
  /** Shown on the trigger when no chip is selected (e.g. "Alle Gemeinden"). */
  placeholder: string;
  panelTitle?: string;
  items: FilterRowChipItem[];
  selectedIds: string[];
  onSelectedIdsChange: (ids: string[]) => void;
}

const triggerButtonClassName =
  'flex size-full min-h-0 min-w-0 flex-1 cursor-pointer items-center overflow-hidden text-ellipsis whitespace-nowrap border-0 bg-transparent p-0 text-left text-base font-normal leading-normal text-gray-900 outline-none focus:outline-none';

const buildTriggerLabel = (
  items: FilterRowChipItem[],
  selectedIds: string[],
  placeholder: string,
): string => {
  if (selectedIds.length === 0) return placeholder;
  if (selectedIds.length === 1) {
    return (
      items.find((item) => item.id === selectedIds[0])?.label ?? placeholder
    );
  }
  return `${selectedIds.length} ausgewählt`;
};

/**
 * Touch-optimized multi-select filter control for the filter row: a trigger
 * button (matching the other filter-row fields) that opens a popover with a
 * chip-style multi-select list. Selection is applied immediately.
 */
export default function FilterRowChipPopover({
  id,
  title,
  triggerIcon,
  placeholder,
  panelTitle,
  items,
  selectedIds,
  onSelectedIdsChange,
}: FilterRowChipPopoverProps) {
  const triggerLabel = buildTriggerLabel(items, selectedIds, placeholder);

  return (
    <Popover.Root>
      <FilterRowBaseField title={title} triggerIcon={triggerIcon}>
        <Popover.Trigger id={id} className={triggerButtonClassName}>
          {triggerLabel}
        </Popover.Trigger>
      </FilterRowBaseField>
      <Popover.Portal>
        <Popover.Positioner sideOffset={8} align='start' className='z-50'>
          <Popover.Popup className='max-w-[min(90vw,480px)] rounded-md border border-gray-300 bg-white p-4 shadow-lg'>
            {panelTitle && (
              <p className='mb-3 text-sm font-bold text-gray-900'>
                {panelTitle}
              </p>
            )}
            <ToggleGroup
              multiple
              value={selectedIds}
              onValueChange={(next) => onSelectedIdsChange(next as string[])}
              className='flex flex-wrap gap-2'
            >
              {items.map((item) => (
                <Toggle
                  key={item.id}
                  value={item.id}
                  aria-label={item.label}
                  render={
                    <Button
                      variant='toggle'
                      className='h-11 min-h-11 whitespace-nowrap rounded-full px-4 py-0'
                    >
                      {item.label}
                    </Button>
                  }
                />
              ))}
            </ToggleGroup>
          </Popover.Popup>
        </Popover.Positioner>
      </Popover.Portal>
    </Popover.Root>
  );
}
