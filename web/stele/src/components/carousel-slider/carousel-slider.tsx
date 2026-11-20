import Autoplay from 'embla-carousel-autoplay';
import useEmblaCarousel, {
  type UseEmblaCarouselType,
} from 'embla-carousel-react';
import {
  Children,
  Fragment,
  useCallback,
  useEffect,
  useMemo,
  useState,
  isValidElement,
  type ReactNode,
} from 'react';

export type CarouselSliderProps = {
  heading?: string;
  /**
   * Optional marker rendered on the right of the heading. Pass a single node
   * to show it for every slide, or an array indexed in lockstep with children
   * to show a different marker per active slide (nulls are allowed).
   */
  headerEnd?: ReactNode | ReactNode[];
  /** Autoplay delay in milliseconds. Defaults to VITE_CAROUSEL_SLIDER_AUTOPLAY_DELAY_MS or 10000 (10s). */
  autoplayDelayMs?: number;
  /** When true, autoplay is stopped (e.g. while a slide is expanded). Resumes when set back to false. */
  autoplayPaused?: boolean;
  /**
   * Called whenever the visible slide changes (swipe or dot selection),
   * including the initial mount. Use this to reset any per-slide UI state
   * (e.g. an "expanded" card) that shouldn't survive a slide change.
   */
  onSlideChange?: (index: number) => void;
  /**
   * Rendered in place of the carousel when there are no slides. When omitted,
   * the whole component collapses to `null` on empty (preserving the legacy
   * behaviour for callers that want the block to disappear entirely).
   */
  emptyState?: ReactNode;
  /** Rendered below the heading, above the slides; persists across all states. */
  toolbar?: ReactNode;
  /**
   * Forces a fresh slides container (and a fresh embla instance) when this
   * changes. Use instead of a `key` on `<CarouselSlider>` so the surrounding
   * frame — including `toolbar` — keeps its state across resets.
   */
  slidesKey?: string | number;
  children: ReactNode;
  className?: string;
};

type EmblaApi = NonNullable<UseEmblaCarouselType[1]>;
type EmblaEvent = Parameters<EmblaApi['on']>[0];

const SELECTION_EVENTS = [
  'select',
  'reInit',
] as const satisfies readonly EmblaEvent[];

const fallbackAutoplayDelayMs = 10_000;
const configuredAutoplayDelayMs = Number(
  import.meta.env.VITE_CAROUSEL_SLIDER_AUTOPLAY_DELAY_MS,
);
const defaultAutoplayDelayMs =
  Number.isFinite(configuredAutoplayDelayMs) && configuredAutoplayDelayMs > 0
    ? configuredAutoplayDelayMs
    : fallbackAutoplayDelayMs;

const getSlides = (children: ReactNode): ReactNode[] =>
  Children.toArray(children).flatMap((child) =>
    isValidElement<{children?: ReactNode}>(child) && child.type === Fragment
      ? getSlides(child.props.children)
      : child,
  );

const useSelectedScrollSnap = (emblaApi: EmblaApi | undefined) => {
  const [selectedIndex, setSelectedIndex] = useState(0);

  useEffect(() => {
    if (!emblaApi) return;
    const onSelect = () => setSelectedIndex(emblaApi.selectedScrollSnap());
    onSelect();
    SELECTION_EVENTS.forEach((event) => emblaApi.on(event, onSelect));
    return () => {
      SELECTION_EVENTS.forEach((event) => emblaApi.off(event, onSelect));
    };
  }, [emblaApi]);

  return selectedIndex;
};

type CarouselSliderDotsProps = {
  count: number;
  selectedIndex: number;
  onSelect: (index: number) => void;
};

const CarouselSliderDots = ({
  count,
  selectedIndex,
  onSelect,
}: CarouselSliderDotsProps) => (
  <div className='max-w-full overflow-x-auto px-1'>
    <div
      className='flex w-max gap-2 sm:gap-3 md:gap-4 lg:gap-6'
      role='tablist'
      aria-label='Slide auswählen'
    >
      {Array.from({length: count}, (_, i) => {
        const isActive = i === selectedIndex;
        return (
          <button
            key={i}
            type='button'
            role='tab'
            aria-selected={isActive}
            aria-label={`Slide ${i + 1} von ${count}`}
            onClick={() => onSelect(i)}
            className={`size-2.5 shrink-0 rounded-full transition-colors sm:size-3 md:size-3.5 lg:size-4 ${
              isActive ? 'bg-hameln-700' : 'border border-gray-500 bg-gray-50'
            }`}
          />
        );
      })}
    </div>
  </div>
);

const resolveHeaderEnd = (
  headerEnd: ReactNode | ReactNode[] | undefined,
  index: number,
): ReactNode => {
  if (headerEnd === undefined) return null;
  if (Array.isArray(headerEnd)) return headerEnd[index] ?? null;
  return headerEnd;
};

type CarouselSliderFrameProps = Pick<
  CarouselSliderProps,
  'heading' | 'className' | 'toolbar'
> & {
  headerEnd?: ReactNode;
  /** Used as React key on the marker container so it crossfades when the active slide changes. */
  headerEndKey?: string | number;
  children: ReactNode;
};

const CarouselSliderFrame = ({
  heading,
  headerEnd,
  headerEndKey,
  toolbar,
  children,
  className,
}: CarouselSliderFrameProps) => (
  <section className={`flex flex-col gap-3 px-16 py-6 ${className ?? ''}`}>
    {heading &&
      (headerEnd ? (
        <div className='flex items-center justify-between gap-6'>
          <h2 className='text-[21px] font-bold leading-normal text-gray-900'>
            {heading}
          </h2>
          <div
            key={headerEndKey}
            className='flex shrink-0 animate-marker-in items-center'
            aria-live='polite'
          >
            {headerEnd}
          </div>
        </div>
      ) : (
        <h2 className='text-[21px] font-bold leading-normal text-gray-900'>
          {heading}
        </h2>
      ))}
    {toolbar}
    {children}
  </section>
);

const EmblaCarouselSliderImpl = ({
  slides,
  autoplayDelayMs,
  autoplayPaused,
  onSelectedIndexChange,
  onSlideChange,
}: {
  slides: ReactNode[];
  autoplayDelayMs: number;
  autoplayPaused: boolean;
  onSelectedIndexChange: (index: number) => void;
  onSlideChange?: (index: number) => void;
}) => {
  const [emblaRef, emblaApi] = useEmblaCarousel(
    {loop: true, align: 'start', containScroll: false},
    [Autoplay({delay: autoplayDelayMs, stopOnInteraction: false})],
  );

  const selectedIndex = useSelectedScrollSnap(emblaApi);

  useEffect(() => {
    onSelectedIndexChange(selectedIndex);
  }, [selectedIndex, onSelectedIndexChange]);

  useEffect(() => {
    onSlideChange?.(selectedIndex);
    // Only the index itself should retrigger this - `onSlideChange` is
    // typically an inline callback that changes identity every render.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [selectedIndex]);

  useEffect(() => {
    const autoplay = emblaApi?.plugins().autoplay;
    if (!autoplay) return;
    if (autoplayPaused) {
      autoplay.stop();
    } else {
      autoplay.play();
    }
  }, [emblaApi, autoplayPaused]);

  const scrollTo = useCallback(
    (index: number) => emblaApi?.scrollTo(index),
    [emblaApi],
  );

  return (
    <div className='flex flex-col items-center gap-6'>
      <div
        ref={emblaRef}
        className='w-full'
        style={{overflow: 'clip', overflowClipMargin: '8px'}}
      >
        <div className='-ml-6 flex touch-pan-y items-stretch'>
          {slides.map((slide, i) => (
            <div
              key={i}
              className='min-w-0 flex-[0_0_100%] self-stretch pl-6 [&>*]:size-full'
            >
              {slide}
            </div>
          ))}
        </div>
      </div>
      <CarouselSliderDots
        count={slides.length}
        selectedIndex={selectedIndex}
        onSelect={scrollTo}
      />
    </div>
  );
};

export const CarouselSlider = ({
  heading,
  headerEnd,
  autoplayDelayMs = defaultAutoplayDelayMs,
  autoplayPaused = false,
  onSlideChange,
  emptyState,
  toolbar,
  slidesKey,
  children,
  className,
}: CarouselSliderProps) => {
  const slides = useMemo(() => getSlides(children), [children]);
  const [selectedIndex, setSelectedIndex] = useState(0);

  // Reset the header marker index whenever the slide set is swapped out
  // (e.g. a filter changes the results), so it never briefly points at a
  // stale slide left over from the previous set.
  const [indexResetForKey, setIndexResetForKey] = useState(slidesKey);
  if (indexResetForKey !== slidesKey) {
    setIndexResetForKey(slidesKey);
    setSelectedIndex(0);
  }

  if (slides.length === 0 && emptyState === undefined) return null;

  // `toolbar` (and everything else in `CarouselSliderFrame`) is always
  // rendered through this single call, regardless of slide count: if the
  // frame itself were swapped between differently-typed subtrees depending
  // on `slides.length` (as before), React would remount it - and with it
  // any open popover state in `toolbar` - every time the result count
  // crosses the 0/1/multiple boundary (e.g. a Gemeinde filter suddenly
  // matching an event). Only the body below varies.
  let body: ReactNode;
  let resolvedHeaderEnd: ReactNode = null;
  let headerEndKey: string | number = 0;

  if (slides.length === 0) {
    body = (
      <div className='flex w-full items-center justify-center py-8 text-base text-gray-700'>
        {emptyState}
      </div>
    );
  } else if (slides.length === 1) {
    resolvedHeaderEnd = resolveHeaderEnd(headerEnd, 0);
    body = (
      <div key={slidesKey} className='w-full [&>*]:size-full'>
        {slides[0]}
      </div>
    );
  } else {
    resolvedHeaderEnd = resolveHeaderEnd(headerEnd, selectedIndex);
    headerEndKey = selectedIndex;
    body = (
      <EmblaCarouselSliderImpl
        key={slidesKey}
        slides={slides}
        autoplayDelayMs={autoplayDelayMs}
        autoplayPaused={autoplayPaused}
        onSelectedIndexChange={setSelectedIndex}
        onSlideChange={onSlideChange}
      />
    );
  }

  return (
    <CarouselSliderFrame
      heading={heading}
      headerEnd={resolvedHeaderEnd}
      headerEndKey={headerEndKey}
      toolbar={toolbar}
      className={className}
    >
      {body}
    </CarouselSliderFrame>
  );
};
