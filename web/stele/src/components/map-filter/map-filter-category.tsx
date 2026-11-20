import {type ComponentPropsWithoutRef, forwardRef} from 'react';
import {type IconType} from 'react-icons';

export type MapFilterCategoryItem = {
  id: string;
  label: string;
  icon?: IconType;
  iconUrl?: string | null;
};

export type MapFilterCategoryProps = Omit<
  ComponentPropsWithoutRef<'section'>,
  'children'
> & {
  name: string;
  categories: MapFilterCategoryItem[];
  selectedIds?: string[];
  onSelectionChange?: (ids: string[]) => void;
};

export const MapFilterCategory = forwardRef<
  HTMLElement,
  MapFilterCategoryProps
>(
  (
    {name, categories, selectedIds = [], onSelectionChange, className, ...rest},
    ref,
  ) => {
    const toggle = (id: string) => {
      const next = selectedIds.includes(id)
        ? selectedIds.filter((x) => x !== id)
        : [...selectedIds, id];
      onSelectionChange?.(next);
    };

    return (
      <section
        {...rest}
        ref={ref}
        className={`flex w-full flex-col gap-4 ${className ?? ''}`}
      >
        <div className='flex items-center gap-[15px]'>
          <h3 className='whitespace-nowrap text-base font-bold leading-none text-hameln-600'>
            {name}
          </h3>
          <div className='h-px flex-1 bg-gray-300' aria-hidden />
        </div>

        <ul className='flex list-none flex-wrap gap-x-5 gap-y-2.5 p-0'>
          {categories.map(({id, label, icon: Icon, iconUrl}) => {
            const active = selectedIds.includes(id);
            return (
              <li key={id} className='flex w-[60px] shrink-0'>
                <button
                  type='button'
                  aria-pressed={active}
                  aria-label={label}
                  onClick={() => toggle(id)}
                  className='group flex w-full flex-col items-center gap-1 outline-none'
                >
                  <span
                    className={`inline-flex size-[60px] items-center justify-center rounded-full text-gray-900 transition-colors duration-150 ease-out group-focus-visible:ring-2 group-focus-visible:ring-hameln-600/50 ${
                      active ? 'bg-hameln-200' : 'bg-gray-100'
                    }`}
                  >
                    {Icon ? (
                      <Icon className='size-12' aria-hidden />
                    ) : iconUrl ? (
                      <img
                        src={iconUrl}
                        alt=''
                        aria-hidden
                        className='size-12 object-contain'
                      />
                    ) : null}
                  </span>
                  <span className='w-full break-words text-center text-xs leading-tight text-gray-900'>
                    {label}
                  </span>
                </button>
              </li>
            );
          })}
        </ul>
      </section>
    );
  },
);
MapFilterCategory.displayName = 'MapFilterCategory';
