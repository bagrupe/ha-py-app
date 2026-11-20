import {type ComponentPropsWithoutRef, forwardRef} from 'react';
import {type IconType} from 'react-icons';
import {tv, type VariantProps} from 'tailwind-variants';

export const badgeVariants = tv({
  slots: {
    base: 'inline-flex items-center gap-[3px] rounded-full py-1 pl-2 pr-3 text-xs leading-[15.5px] whitespace-nowrap',
    icon: 'size-4 shrink-0',
  },
  variants: {
    colorized: {true: '', false: ''},
    highlight: {true: '', false: ''},
  },
  compoundVariants: [
    {
      colorized: true,
      highlight: true,
      class: {base: 'bg-hameln-800 text-hameln-50'},
    },
    {
      colorized: true,
      highlight: false,
      class: {base: 'bg-hameln-200 text-hameln-800'},
    },
    {
      colorized: false,
      highlight: true,
      class: {base: 'bg-gray-900 text-gray-50'},
    },
    {
      colorized: false,
      highlight: false,
      class: {base: 'bg-gray-100 text-gray-900'},
    },
  ],
  defaultVariants: {
    colorized: false,
    highlight: false,
  },
});

type BadgeVariants = VariantProps<typeof badgeVariants>;

export type BadgeProps = Omit<ComponentPropsWithoutRef<'span'>, 'children'> &
  BadgeVariants & {
    label: string;
    icon?: IconType;
  };

export const Badge = forwardRef<HTMLSpanElement, BadgeProps>(
  ({label, icon: Icon, colorized, highlight, className, ...rest}, ref) => {
    const {base, icon} = badgeVariants({colorized, highlight});

    return (
      <span {...rest} ref={ref} className={base({className})}>
        {Icon && <Icon className={icon()} aria-hidden />}
        <span className='min-w-0 truncate'>{label}</span>
      </span>
    );
  },
);
Badge.displayName = 'Badge';
