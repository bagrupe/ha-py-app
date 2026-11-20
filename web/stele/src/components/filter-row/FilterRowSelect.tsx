import {forwardRef, type ReactNode} from 'react';
import FilterRowBaseField from './FilterRowBaseField';

export type FilterRowItems<Value> = ReadonlyArray<{
  label: string;
  value: Value;
}>;

export type FilterRowNativeSelectProps = Omit<
  React.ComponentPropsWithoutRef<'select'>,
  'children'
> & {
  title?: string;
  items?: FilterRowItems<string | number>;
  triggerIcon?: ReactNode;
};

const selectClassName =
  'h-full min-h-0 w-full min-w-0 flex-1 cursor-pointer appearance-none bg-transparent py-0 text-base font-normal leading-normal text-gray-900 outline-none focus:outline-none';

const selectTriggerIconClassName = 'pr-10';

const FilterRowNativeSelect = forwardRef<
  HTMLSelectElement,
  FilterRowNativeSelectProps
>(function FilterRowNativeSelect(
  {title, items, triggerIcon, className, id, ...selectProps},
  ref,
) {
  const mergedSelectClass = [
    selectClassName,
    triggerIcon ? selectTriggerIconClassName : null,
    className,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <FilterRowBaseField title={title} triggerIcon={triggerIcon}>
      <select ref={ref} id={id} className={mergedSelectClass} {...selectProps}>
        <option value=''> </option>
        {items?.map(({label, value}) => (
          <option key={String(value)} value={String(value)}>
            {label}
          </option>
        ))}
      </select>
    </FilterRowBaseField>
  );
});

export default FilterRowNativeSelect;
