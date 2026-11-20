import {
  type ComponentPropsWithoutRef,
  forwardRef,
  type ReactNode,
  useId,
} from 'react';
import {MdOutlineFilterAlt} from 'react-icons/md';
import {Toggle} from '../toggle';

export type MapFilterProps = Omit<
  ComponentPropsWithoutRef<'section'>,
  'children' | 'title'
> & {
  open?: boolean;
  onOpenChange?: (open: boolean) => void;
  allSelected?: boolean;
  onAllSelectedChange?: (allSelected: boolean) => void;
  title?: string;
  openButtonLabel?: string;
  allSelectedLabel?: string;
  selectedCount?: number;
  onConfirm?: () => void;
  confirmButtonLabel?: string;
  children?: ReactNode;
};

export const MapFilter = forwardRef<HTMLElement, MapFilterProps>(
  (
    {
      open = false,
      onOpenChange,
      allSelected = false,
      onAllSelectedChange,
      title = 'Wonach möchten Sie suchen?',
      openButtonLabel = 'Filter auswählen',
      allSelectedLabel = 'Alle auswählen',
      selectedCount,
      onConfirm,
      confirmButtonLabel = 'Auswahl übernehmen',
      children,
      className,
      ...rest
    },
    ref,
  ) => {
    const titleId = useId();

    return (
      <section
        {...rest}
        ref={ref}
        aria-labelledby={titleId}
        className={`${
          open ? 'flex w-full' : 'inline-flex'
        } relative flex-col overflow-hidden rounded-xl bg-white drop-shadow-[0_0_1.5px_rgba(0,0,0,0.25)] ${
          className ?? ''
        }`}
      >
        <div
          className={`flex min-h-[44px] items-center p-4 ${
            open ? 'justify-between' : 'gap-4'
          }`}
        >
          <h2
            id={titleId}
            className='whitespace-nowrap text-[21px] font-bold leading-none text-gray-900'
          >
            {title}
          </h2>

          {open ? (
            <Toggle
              checked={allSelected}
              onCheckedChange={(value) => onAllSelectedChange?.(value)}
              label={allSelectedLabel}
              aria-label={allSelectedLabel}
            />
          ) : (
            <button
              type='button'
              onClick={() => onOpenChange?.(true)}
              className='relative inline-flex h-[50px] shrink-0 items-center justify-center gap-2 rounded-[10px] bg-hameln-675 px-4 py-2 text-base text-white outline-none transition-colors hover:bg-hameln-700 focus-visible:ring-2 focus-visible:ring-hameln-600/50 active:bg-hameln-800'
            >
              <MdOutlineFilterAlt className='size-6' aria-hidden />
              <span className='whitespace-nowrap'>{openButtonLabel}</span>
              {selectedCount !== undefined && selectedCount > 0 && (
                <span
                  aria-label={`${selectedCount} aktive Filter`}
                  className='pointer-events-none absolute -right-2 -top-2 inline-flex size-6 items-center justify-center rounded-full border-2 border-white bg-hameln-200 text-base font-bold leading-none text-hameln-900'
                >
                  {selectedCount}
                </span>
              )}
            </button>
          )}
        </div>

        {open && children !== undefined && (
          <div className='flex min-h-0 flex-1 flex-col gap-6 overflow-y-auto px-4 pb-20'>
            {children}
          </div>
        )}

        {open && onConfirm && (
          <button
            type='button'
            onClick={onConfirm}
            className='absolute bottom-4 right-4 inline-flex h-[50px] items-center justify-center gap-2 rounded-[10px] bg-hameln-675 px-4 py-2 text-base leading-none text-white shadow-[0_2px_8px_rgba(0,0,0,0.18)] outline-none transition-colors hover:bg-hameln-700 focus-visible:ring-2 focus-visible:ring-hameln-600/50 active:bg-hameln-800'
          >
            {confirmButtonLabel}
          </button>
        )}
      </section>
    );
  },
);
MapFilter.displayName = 'MapFilter';
