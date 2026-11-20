import {type ComponentPropsWithoutRef, forwardRef} from 'react';

import ellipse from '../../assets/Visual/ellipse.png';

export type AufrufAktionMarkerProps = Omit<
  ComponentPropsWithoutRef<'span'>,
  'children'
> & {
  label?: string;
};

export const AufrufAktionMarker = forwardRef<
  HTMLSpanElement,
  AufrufAktionMarkerProps
>(({label = 'Aufruf-Aktion', className, ...rest}, ref) => (
  <span
    {...rest}
    ref={ref}
    className={`inline-flex items-center gap-[6px] text-[16px] font-normal leading-normal text-gray-900 ${
      className ?? ''
    }`}
  >
    <img
      src={ellipse}
      alt=''
      aria-hidden
      className='size-6 shrink-0 select-none object-contain'
      draggable={false}
    />
    {label}
  </span>
));
AufrufAktionMarker.displayName = 'AufrufAktionMarker';
