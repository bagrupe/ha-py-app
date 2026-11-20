import {forwardRef, type ReactNode} from 'react';

export interface FilterRowBaseFieldProps
  extends React.FieldsetHTMLAttributes<HTMLFieldSetElement> {
  title?: string;
  children: ReactNode;
  triggerIcon?: ReactNode;
  /** Applied to the inner control slot (padding, min height, focus ring). */
  controlSlotClassName?: string;
}

/** Total height matches `FilterRowToggleGroup` / Button row (`h-11` = 44px). */
const fieldsetClassName =
  'relative box-border h-11 min-h-11 max-h-11 w-full min-w-[204px] rounded-md border border-gray-500 p-0';
const legendClassName =
  'absolute left-2 top-0 z-[1] float-none -translate-y-1/2 bg-white px-1';
const legendTextClassName = 'text-sm font-normal leading-4 text-gray-900';

const controlSlotDefaultClassName =
  'flex h-full min-h-0 w-full items-center rounded-md bg-transparent pl-[10px] pr-3 text-base font-normal text-gray-900 focus-within:outline-2 focus-within:-outline-offset-1 focus-within:outline-blue-800';

const FilterRowBaseField = forwardRef<
  HTMLFieldSetElement,
  FilterRowBaseFieldProps
>(function FilterRowBaseField(
  {
    title,
    children,
    triggerIcon,
    className,
    controlSlotClassName,
    ...fieldsetProps
  },
  ref,
) {
  const mergedFieldsetClass = [fieldsetClassName, className]
    .filter(Boolean)
    .join(' ');
  const mergedControlSlotClass = [
    controlSlotDefaultClassName,
    controlSlotClassName,
  ]
    .filter(Boolean)
    .join(' ');

  return (
    <fieldset ref={ref} className={mergedFieldsetClass} {...fieldsetProps}>
      {title != null && title !== '' && (
        <legend className={legendClassName}>
          <span className={legendTextClassName}>{title}</span>
        </legend>
      )}
      <div className={mergedControlSlotClass}>
        {triggerIcon ? (
          <div className='relative size-full min-h-0 min-w-0 flex-1'>
            <div className='size-full pr-7'>{children}</div>
            <span
              aria-hidden
              className='pointer-events-none absolute right-0 top-1/2 flex size-6 -translate-y-1/2 items-center justify-center text-gray-900 [&>svg]:size-6'
            >
              {triggerIcon}
            </span>
          </div>
        ) : (
          children
        )}
      </div>
    </fieldset>
  );
});

export default FilterRowBaseField;
