import {useState} from 'react';
import {CiCircleChevDown} from 'react-icons/ci';

import {useFitLineClamp} from '../../hooks/useFitLineClamp';
import {useIsTruncated} from '../../hooks/useIsTruncated';
import {CarouselSlide, type CarouselSlideProps} from './carousel-slide';

type CarouselSlideArtikelProps = Omit<CarouselSlideProps, 'children'> & {
  body: string;
};

// Must track the `leading-6` (24px) on the body paragraph below.
const BODY_LINE_HEIGHT = 24;

export const CarouselSlideArtikel = ({
  body,
  isHighlight = false,
  isExpanded = false,
  onToggleExpand,
  ...rest
}: CarouselSlideArtikelProps) => {
  const {ref, lines} = useFitLineClamp<HTMLDivElement>(BODY_LINE_HEIGHT);
  const {ref: pRef, isTruncated: measuredTruncated} =
    useIsTruncated<HTMLParagraphElement>();
  // The clamp (and with it, any truncation) is lifted while expanded, so the
  // live measurement would otherwise read as "not truncated" the moment the
  // card opens — freeze the collapsed-state reading so a second tap can
  // still close it.
  const [wasTruncated, setWasTruncated] = useState(measuredTruncated);
  if (!isExpanded && wasTruncated !== measuredTruncated) {
    setWasTruncated(measuredTruncated);
  }
  const isTruncated = wasTruncated;
  const showReadMoreHint = isTruncated && !isExpanded;

  return (
    <CarouselSlide
      {...rest}
      isHighlight={isHighlight}
      isExpanded={isExpanded}
      // Only truncated cards have anything to reveal — expanding an
      // already-fully-visible card would just grow it for the "weiter in
      // Ns" badge, shifting the image/QR code for no benefit.
      onToggleExpand={isTruncated ? onToggleExpand : undefined}
    >
      <div
        ref={ref}
        className={`relative min-w-0 flex-1 self-stretch ${
          isExpanded ? '' : 'overflow-hidden'
        }`}
      >
        <p
          ref={pRef}
          style={
            isExpanded
              ? undefined
              : {
                  display: '-webkit-box',
                  WebkitBoxOrient: 'vertical',
                  WebkitLineClamp: lines,
                }
          }
          className={`text-[16px] leading-6 text-gray-900 ${
            isExpanded ? '' : 'overflow-hidden'
          }`}
        >
          {body}
        </p>
        {showReadMoreHint && (
          <span
            aria-hidden
            className='absolute bottom-1 right-1 inline-flex items-center gap-1.5 whitespace-nowrap rounded-full bg-hameln-700 py-1.5 pl-3 pr-4 text-sm font-semibold text-hameln-50 shadow-[0_2px_8px_rgba(0,0,0,0.3)]'
          >
            <CiCircleChevDown className='size-5 shrink-0' />
            Zum Lesen antippen
          </span>
        )}
      </div>
    </CarouselSlide>
  );
};
