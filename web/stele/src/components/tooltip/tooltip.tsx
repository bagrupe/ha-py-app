import {
  type ComponentPropsWithoutRef,
  type CSSProperties,
  forwardRef,
  type ReactNode,
} from 'react';
import {MdClose} from 'react-icons/md';

export type TooltipAlignment = 'top' | 'bottom' | 'left' | 'right';

export type TooltipVariant = 'location' | 'poi';

export type TooltipProps = Omit<ComponentPropsWithoutRef<'div'>, 'children'> & {
  variant: TooltipVariant;
  alignment?: TooltipAlignment;
  children?: ReactNode;
  header?: string;
  onClose?: () => void;
  closeLabel?: string;
};

const POINTER_W = 17;
const POINTER_H = 13;
const POINTER_OFFSET = POINTER_H - 1;

const pointerStyle: Record<TooltipAlignment, CSSProperties> = {
  top: {
    top: -POINTER_OFFSET,
    left: '50%',
    transform: 'translateX(-50%)',
  },
  bottom: {
    bottom: -POINTER_OFFSET,
    left: '50%',
    transform: 'translateX(-50%) rotate(180deg)',
  },
  left: {
    left: -POINTER_OFFSET,
    top: '50%',
    transform: 'translateY(-50%) rotate(-90deg)',
  },
  right: {
    right: -POINTER_OFFSET,
    top: '50%',
    transform: 'translateY(-50%) rotate(90deg)',
  },
};

const Pointer = ({
  alignment,
  fill,
}: {
  alignment: TooltipAlignment;
  fill: string;
}) => (
  <span
    aria-hidden
    className='pointer-events-none absolute'
    style={pointerStyle[alignment]}
  >
    <svg
      width={POINTER_W}
      height={POINTER_H}
      viewBox='0 0 16.4545 13.4304'
      xmlns='http://www.w3.org/2000/svg'
    >
      <path
        d='M6.45453 1.074C7.20255 -0.357998 9.25193 -0.357999 9.99996 1.074L16.4545 13.4304H0L6.45453 1.074Z'
        fill={fill}
      />
    </svg>
  </span>
);

const poiPointerFill: Record<TooltipAlignment, string> = {
  top: '#597D1C',
  bottom: '#FFFFFF',
  left: '#FFFFFF',
  right: '#FFFFFF',
};

export const Tooltip = forwardRef<HTMLDivElement, TooltipProps>(
  (
    {
      variant,
      alignment,
      header,
      onClose,
      closeLabel = 'Schließen',
      className,
      children,
      ...rest
    },
    ref,
  ) => {
    if (variant === 'location') {
      const resolvedAlignment = alignment ?? 'top';
      return (
        <div
          {...rest}
          ref={ref}
          role='tooltip'
          className={`relative inline-flex items-center justify-center rounded-xl bg-white p-4 text-base font-bold leading-none text-hameln-900 drop-shadow-[0_0_3px_rgba(0,0,0,0.25)] ${
            className ?? ''
          }`}
        >
          <Pointer alignment={resolvedAlignment} fill='#FFFFFF' />
          {children}
        </div>
      );
    }

    const resolvedAlignment = alignment ?? 'right';
    return (
      <div
        {...rest}
        ref={ref}
        role='tooltip'
        className={`relative flex w-[400px] max-w-full flex-col gap-4 rounded-xl bg-white pb-4 drop-shadow-[0_0_3px_rgba(0,0,0,0.25)] ${
          className ?? ''
        }`}
      >
        <Pointer
          alignment={resolvedAlignment}
          fill={poiPointerFill[resolvedAlignment]}
        />
        <div className='flex items-center justify-between gap-4 overflow-hidden rounded-t-xl bg-hameln-675 p-4'>
          <p className='line-clamp-2 min-w-0 flex-1 text-base font-bold leading-tight text-white'>
            {header}
          </p>
          <button
            type='button'
            onClick={onClose}
            className='inline-flex shrink-0 items-center gap-2 rounded text-base text-white outline-none transition-opacity hover:opacity-80 focus-visible:ring-2 focus-visible:ring-white/60'
          >
            <MdClose className='size-6' aria-hidden />
            <span>{closeLabel}</span>
          </button>
        </div>
        {children !== undefined && (
          <div className='flex flex-col'>{children}</div>
        )}
      </div>
    );
  },
);
Tooltip.displayName = 'Tooltip';

export type TooltipDetailItem = {
  label: string;
  value: ReactNode;
};

export const TooltipDetailList = ({items}: {items: TooltipDetailItem[]}) => (
  <dl className='flex flex-col gap-[10px]'>
    {items.map((item, index) => (
      <div key={item.label} className='flex flex-col'>
        <div className='flex flex-col gap-1 px-4'>
          <dt className='truncate text-xs leading-tight text-gray-900'>
            {item.label}
          </dt>
          <dd className='whitespace-pre-line break-words text-base leading-tight text-gray-900'>
            {item.value}
          </dd>
        </div>
        {index < items.length - 1 && (
          <div aria-hidden className='mt-[10px] h-px w-full bg-gray-100' />
        )}
      </div>
    ))}
  </dl>
);
