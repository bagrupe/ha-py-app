import {type ComponentPropsWithoutRef, forwardRef, useId} from 'react';

export type ToggleProps = Omit<
  ComponentPropsWithoutRef<'button'>,
  'children' | 'onChange'
> & {
  checked?: boolean;
  onCheckedChange?: (checked: boolean) => void;
  label?: string;
};

export const Toggle = forwardRef<HTMLButtonElement, ToggleProps>(
  ({checked = false, onCheckedChange, label, className, ...rest}, ref) => {
    const labelId = useId();
    const hasExternalName =
      rest['aria-label'] != null || rest['aria-labelledby'] != null;
    const button = (
      <button
        {...rest}
        ref={ref}
        type='button'
        role='switch'
        aria-checked={checked}
        aria-labelledby={
          label && !hasExternalName ? labelId : rest['aria-labelledby']
        }
        onClick={() => onCheckedChange?.(!checked)}
        className={`relative inline-flex h-4 w-9 shrink-0 items-center rounded-full outline-none transition-colors duration-150 ease-out focus-visible:ring-2 focus-visible:ring-hameln-600/50 ${
          checked ? 'bg-hameln-200' : 'bg-gray-300'
        } ${label ? '' : className ?? ''}`}
      >
        <span
          aria-hidden
          className={`absolute top-1/2 size-5 -translate-y-1/2 rounded-full transition-[transform,background-color] duration-150 ease-out ${
            checked
              ? 'translate-x-4 bg-hameln-600'
              : 'translate-x-0 bg-[#9A9A9A]'
          }`}
        />
      </button>
    );

    if (!label) return button;

    return (
      <span className={`inline-flex items-center gap-2 ${className ?? ''}`}>
        <span
          id={hasExternalName ? undefined : labelId}
          className='text-base font-normal leading-normal text-gray-900'
        >
          {label}
        </span>
        {button}
      </span>
    );
  },
);
Toggle.displayName = 'Toggle';
