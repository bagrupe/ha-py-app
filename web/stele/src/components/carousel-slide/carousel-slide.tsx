import {useState, type ReactNode} from 'react';
import {CiClock2} from 'react-icons/ci';

import fallbackVisual from '../../assets/Visual/carousel-artikel-default.png';

export type CarouselSlideProps = {
  date: string;
  headline: string;
  subHeadline?: string;
  headerEnd?: ReactNode;
  image?: string;
  imageFallback?: string;
  imageAlt?: string;
  visual?: ReactNode;
  qrCode?: ReactNode;
  ribbon?: ReactNode;
  isHighlight?: boolean;
  /** When true, the card grows to fit its content instead of clipping it at the fixed height. */
  isExpanded?: boolean;
  /** Makes the whole card tappable; called to toggle `isExpanded`. */
  onToggleExpand?: () => void;
  /** While expanded, shows a "closes in Ns" clock so the auto-collapse doesn't surprise the visitor. */
  autoCollapseSecondsRemaining?: number;
  children?: ReactNode;
  className?: string;
};

// Keeps the teaser high-priority while reserving enough space for the bounded
// body/event-details slot below it.
const SUB_HEADLINE_MAX_LINES = 4;
const SUB_HEADLINE_WITH_QR_MAX_LINES = 3;

const VisualImage = ({
  src,
  imageFallback,
  alt,
}: {
  src: string;
  imageFallback?: string;
  alt: string;
}) => {
  const candidates = Array.from(
    new Set([src, imageFallback, fallbackVisual].filter(Boolean) as string[]),
  );
  const [index, setIndex] = useState(0);

  return (
    <img
      alt={alt}
      src={candidates[index]}
      onError={() => {
        if (index < candidates.length - 1) setIndex(index + 1);
      }}
      className='absolute left-1/2 top-1/2 size-full -translate-x-1/2 -translate-y-1/2 object-cover'
    />
  );
};

export const CarouselSlide = ({
  date,
  headline,
  subHeadline,
  headerEnd,
  image,
  imageFallback,
  imageAlt = '',
  visual,
  qrCode,
  ribbon,
  isHighlight = false,
  isExpanded = false,
  onToggleExpand,
  autoCollapseSecondsRemaining,
  children,
  className,
}: CarouselSlideProps) => (
  <div className={`relative [--ribbon-rail-width:7px] ${className ?? ''}`}>
    <article
      onClick={onToggleExpand}
      role={onToggleExpand ? 'button' : undefined}
      tabIndex={onToggleExpand ? 0 : undefined}
      aria-expanded={onToggleExpand ? isExpanded : undefined}
      onKeyDown={
        onToggleExpand
          ? (e) => {
              if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                onToggleExpand();
              }
            }
          : undefined
      }
      className={`relative flex items-stretch gap-6 overflow-hidden rounded-[12px] drop-shadow-[0_0_1.5px_rgba(0,0,0,0.25)] ${
        isExpanded ? 'min-h-[360px]' : 'h-[360px]'
      } ${onToggleExpand ? 'cursor-pointer' : ''} ${
        isHighlight ? 'border-2 border-hameln-600 bg-gray-50' : 'bg-white'
      }`}
    >
      <div
        className={`relative z-10 w-[301px] shrink-0 overflow-hidden shadow-[0_0_3px_0_rgba(0,0,0,0.25)] ${
          // Capped at the collapsed card height even when the card grows, so
          // the (often low-res) source image never gets upscaled/blurrier
          // than in the collapsed state.
          isExpanded ? 'h-[360px] self-start' : 'self-stretch'
        } ${isHighlight ? 'rounded-l-[10px]' : 'rounded-l-[12px]'}`}
      >
        {visual ?? (
          <VisualImage
            src={image ?? fallbackVisual}
            imageFallback={imageFallback}
            alt={imageAlt}
          />
        )}
      </div>

      {isHighlight && (
        <div
          aria-hidden
          className='pointer-events-none absolute inset-y-0 left-[300px] right-0 overflow-hidden rounded-r-[10px]'
        >
          <img
            alt=''
            src={fallbackVisual}
            className='absolute inset-0 size-full object-cover opacity-40'
          />
          <div className='absolute inset-0 bg-gradient-to-b from-transparent to-white' />
        </div>
      )}

      <div className='relative z-10 flex min-w-0 flex-1 flex-col gap-[10px] py-6 pr-6'>
        <div className='flex w-full items-center justify-between gap-[10px]'>
          <div className='flex min-w-0 items-center gap-2'>
            <p className='shrink-0 text-[12px] leading-normal text-gray-900'>
              {date}
            </p>
            {isExpanded && autoCollapseSecondsRemaining !== undefined && (
              <span className='inline-flex shrink-0 items-center gap-1 whitespace-nowrap rounded-full bg-gray-900/80 py-1 pl-2 pr-2.5 text-xs font-semibold text-white'>
                <CiClock2 className='size-3.5 shrink-0' />
                weiter in {autoCollapseSecondsRemaining}s
              </span>
            )}
          </div>
          {headerEnd && (
            <div className='flex items-center justify-end gap-[10px]'>
              {headerEnd}
            </div>
          )}
        </div>

        <h3
          className={`${
            isExpanded ? '' : 'line-clamp-2'
          } text-[21px] font-bold leading-normal ${
            isHighlight ? 'text-hameln-800' : 'text-hameln-675'
          }`}
        >
          {headline}
        </h3>

        {subHeadline && (
          <p
            style={
              isExpanded
                ? undefined
                : {
                    display: '-webkit-box',
                    WebkitBoxOrient: 'vertical',
                    WebkitLineClamp: qrCode
                      ? SUB_HEADLINE_WITH_QR_MAX_LINES
                      : SUB_HEADLINE_MAX_LINES,
                  }
            }
            className={`${
              isExpanded ? '' : 'overflow-hidden'
            } text-[16px] font-bold leading-6 text-gray-900`}
          >
            {subHeadline}
          </p>
        )}

        <div
          className={`flex flex-1 items-start gap-6 ${
            isExpanded ? 'min-h-0' : 'min-h-0 overflow-hidden'
          }`}
        >
          {children}
          {qrCode && (
            <div className='flex shrink-0 flex-col items-end justify-end self-stretch overflow-hidden'>
              {qrCode}
            </div>
          )}
        </div>
      </div>
    </article>

    {ribbon && (
      <div className='pointer-events-none absolute left-[calc(var(--ribbon-rail-width)*-1)] top-[18px] z-20'>
        {ribbon}
      </div>
    )}
  </div>
);
