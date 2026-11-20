import {useState} from 'react';
import {CiCircleChevDown, CiClock2} from 'react-icons/ci';
import {MdOutlineCalendarMonth} from 'react-icons/md';

import {useIsTruncated} from '../../hooks/useIsTruncated';
import {Badge} from '../badge';
import {CarouselSlide, type CarouselSlideProps} from './carousel-slide';

export type EventTermin = {
  dateRange: string;
  timeRange: string;
};

export type EventVeranstalter = {
  name: string;
  street: string;
  postalCode: string;
  city: string;
  website?: string;
};

type CarouselSlideVeranstaltungProps = Omit<CarouselSlideProps, 'children'> & {
  termin: EventTermin;
  veranstalter: EventVeranstalter;
  terminLabel?: string;
  veranstalterLabel?: string;
};

const outlinedBadgeClass =
  'border border-gray-300 bg-gray-50 text-gray-900 leading-none';

export const CarouselSlideVeranstaltung = ({
  termin,
  veranstalter,
  terminLabel = 'Nächste Termin',
  veranstalterLabel = 'Veranstalter',
  isExpanded = false,
  onToggleExpand,
  ...rest
}: CarouselSlideVeranstaltungProps) => {
  // Truncation must be measured on each single-line `truncate` element
  // itself (its own scrollWidth vs clientWidth) — a wrapping container never
  // reports overflow here, since the clipped `<p>` never actually grows
  // wider than the container box.
  const {ref: nameRef, isTruncated: nameTruncated} =
    useIsTruncated<HTMLParagraphElement>('horizontal');
  const {ref: streetRef, isTruncated: streetTruncated} =
    useIsTruncated<HTMLParagraphElement>('horizontal');
  const {ref: cityRef, isTruncated: cityTruncated} =
    useIsTruncated<HTMLParagraphElement>('horizontal');
  const {ref: websiteRef, isTruncated: websiteTruncated} =
    useIsTruncated<HTMLParagraphElement>('horizontal');
  const measuredTruncated =
    nameTruncated || streetTruncated || cityTruncated || websiteTruncated;
  // The `truncate` class is swapped for `break-words` while expanded, so the
  // live measurement would otherwise read as "not truncated" the moment the
  // card opens — freeze the collapsed-state reading so a second tap can
  // still close it.
  const [wasTruncated, setWasTruncated] = useState(measuredTruncated);
  if (!isExpanded && wasTruncated !== measuredTruncated) {
    setWasTruncated(measuredTruncated);
  }
  const isTruncated = wasTruncated;
  const showReadMoreHint = isTruncated && !isExpanded;
  const lineClass = isExpanded ? 'break-words' : 'truncate';

  return (
    <CarouselSlide
      {...rest}
      isExpanded={isExpanded}
      // Only truncated cards have anything to reveal — expanding an
      // already-fully-visible card would just grow it for the "weiter in
      // Ns" badge, shifting the image/QR code for no benefit.
      onToggleExpand={isTruncated ? onToggleExpand : undefined}
    >
      <div className='flex min-h-0 min-w-0 flex-col items-start gap-2 overflow-hidden'>
        <p className='shrink-0 text-[12px] font-bold leading-normal text-gray-900'>
          {terminLabel}
        </p>
        <Badge
          label={termin.dateRange}
          icon={MdOutlineCalendarMonth}
          className={`${outlinedBadgeClass} max-w-full shrink-0`}
        />
        <Badge
          label={termin.timeRange}
          icon={CiClock2}
          className={`${outlinedBadgeClass} shrink-0`}
        />
      </div>

      <div
        className={`relative flex min-h-0 min-w-[130px] flex-1 flex-col gap-2 text-[12px] leading-normal text-gray-900 ${
          isExpanded ? '' : 'overflow-hidden'
        }`}
      >
        <p className={`shrink-0 font-bold ${lineClass}`}>{veranstalterLabel}</p>
        <p ref={nameRef} className={`shrink-0 ${lineClass}`}>
          {veranstalter.name}
        </p>
        <p ref={streetRef} className={`shrink-0 ${lineClass}`}>
          {veranstalter.street}
        </p>
        <p ref={cityRef} className={`flex shrink-0 gap-2 ${lineClass}`}>
          <span>{veranstalter.postalCode}</span>
          <span>{veranstalter.city}</span>
        </p>
        {veranstalter.website && (
          <p ref={websiteRef} className={`shrink-0 ${lineClass}`}>
            {veranstalter.website}
          </p>
        )}
        {showReadMoreHint && (
          <span
            aria-hidden
            className='absolute bottom-0 right-0 inline-flex items-center gap-1.5 whitespace-nowrap rounded-full bg-hameln-700 py-1.5 pl-3 pr-4 text-sm font-semibold text-hameln-50 shadow-[0_2px_8px_rgba(0,0,0,0.3)]'
          >
            <CiCircleChevDown className='size-5 shrink-0' />
            Mehr anzeigen
          </span>
        )}
      </div>
    </CarouselSlide>
  );
};
