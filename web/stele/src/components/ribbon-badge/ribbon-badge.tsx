import {type ComponentPropsWithoutRef, forwardRef} from 'react';

export type RibbonBadgeProps = Omit<
  ComponentPropsWithoutRef<'span'>,
  'children'
> & {
  label: string;
};

export const RibbonBadge = forwardRef<HTMLSpanElement, RibbonBadgeProps>(
  ({label, className, ...rest}, ref) => (
    <span
      {...rest}
      ref={ref}
      className={`relative inline-flex min-h-6 items-stretch text-[12px] leading-none text-hameln-50 drop-shadow-[0_0_1.5px_rgba(0,0,0,0.25)] ${
        className ?? ''
      }`}
    >
      <span
        aria-hidden
        className='absolute left-0 top-[-6px] size-[7px] rounded-tl-[4px] bg-hameln-900'
      />
      <span
        aria-hidden
        className='w-[7px] shrink-0 rounded-bl-[4px] bg-hameln-700'
      />
      <span className='inline-flex min-h-6 items-center rounded-r-[99px] bg-hameln-700 py-1 pl-px pr-3'>
        {label}
      </span>
    </span>
  ),
);
RibbonBadge.displayName = 'RibbonBadge';
