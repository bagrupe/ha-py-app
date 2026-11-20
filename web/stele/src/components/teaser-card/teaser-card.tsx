import {
  type ComponentPropsWithoutRef,
  forwardRef,
  type ReactNode,
  useId,
} from 'react';
import {MdOutlineAccountBalance, MdArrowForward} from 'react-icons/md';

import poiBackground from '../../assets/Visual/poi.jpg';

export type TeaserCardProps = Omit<
  ComponentPropsWithoutRef<'section'>,
  'children'
> & {
  heading?: string;
  body?: ReactNode;
  ctaLabel?: string;
  onCtaClick?: () => void;
  backgroundImage?: string;
};

const PinShape = ({className}: {className?: string}) => {
  const maskId = useId();
  const pinPath =
    'M20 0C31.0457 0 40 8.9543 40 20C40 28.4351 34.7774 35.6487 27.3899 38.588C26.6633 38.8771 26.0406 39.3918 25.6786 40.0849L22.2725 46.6064C21.5244 48.0382 19.4756 48.0382 18.7275 46.6064L15.553 40.5306C15.1611 39.7804 14.4659 39.2421 13.663 38.9741C5.72346 36.3237 0 28.8307 0 20C0 8.9543 8.9543 0 20 0Z';
  return (
    <svg
      width='40'
      height='48'
      viewBox='0 0 40 48'
      fill='none'
      aria-hidden
      className={className}
    >
      <mask id={maskId} fill='white'>
        <path d={pinPath} />
      </mask>
      <path d={pinPath} fill='white' />
      <path
        d='M22.2725 46.6064L23.1588 47.0695L23.1588 47.0694L22.2725 46.6064ZM18.7275 46.6064L19.6139 46.1434L19.6139 46.1434L18.7275 46.6064ZM15.553 40.5306L14.6667 40.9937L15.553 40.5306ZM27.3899 38.588L27.7596 39.5171L27.3899 38.588ZM25.6786 40.0849L26.5649 40.5479L25.6786 40.0849ZM20 0V1C30.4934 1 39 9.50659 39 20H40H41C41 8.40202 31.598 -1 20 -1V0ZM40 20H39C39 28.0117 34.0403 34.8657 27.0202 37.6588L27.3899 38.588L27.7596 39.5171C35.5146 36.4316 41 28.8586 41 20H40ZM25.6786 40.0849L24.7922 39.622L21.3861 46.1435L22.2725 46.6064L23.1588 47.0694L26.5649 40.5479L25.6786 40.0849ZM22.2725 46.6064L21.3861 46.1434C21.0121 46.8592 19.9879 46.8592 19.6139 46.1434L18.7275 46.6064L17.8412 47.0695C18.9633 49.2172 22.0367 49.2172 23.1588 47.0695L22.2725 46.6064ZM18.7275 46.6064L19.6139 46.1434L16.4393 40.0675L15.553 40.5306L14.6667 40.9937L17.8412 47.0695L18.7275 46.6064ZM13.663 38.9741L13.9797 38.0255C6.43588 35.5073 1 28.3876 1 20H0H-1C-1 29.2739 5.01105 37.1402 13.3464 39.9226L13.663 38.9741ZM0 20H1C1 9.50659 9.50659 1 20 1V0V-1C8.40202 -1 -1 8.40202 -1 20H0ZM15.553 40.5306L16.4393 40.0675C15.9115 39.0573 14.9934 38.3639 13.9797 38.0255L13.663 38.9741L13.3464 39.9226C13.9385 40.1202 14.4106 40.5035 14.6667 40.9937L15.553 40.5306ZM27.3899 38.588L27.0202 37.6588C26.1021 38.0241 25.2795 38.6888 24.7922 39.622L25.6786 40.0849L26.5649 40.5479C26.8016 40.0948 27.2245 39.73 27.7596 39.5171L27.3899 38.588Z'
        fill='#4E4E4E'
        mask={`url(#${maskId})`}
      />
    </svg>
  );
};

const PoiCluster = () => (
  <div
    className='pointer-events-none relative h-12 w-14 drop-shadow-[0_0_3px_rgba(0,0,0,0.25)]'
    aria-hidden
  >
    <PinShape className='absolute left-4 top-0' />
    <PinShape className='absolute left-2 top-0' />
    <div className='absolute left-0 top-0'>
      <PinShape />
      <MdOutlineAccountBalance
        className='absolute left-2 top-2 size-6 text-hameln-600'
        aria-hidden
      />
    </div>
  </div>
);

const MapIllustration = () => {
  const gradientId = useId();
  return (
    <svg
      viewBox='0 0 499 261'
      fill='none'
      aria-hidden
      className='size-full'
      preserveAspectRatio='xMinYMin meet'
    >
      <defs>
        <linearGradient
          id={gradientId}
          x1='499'
          y1='70.7007'
          x2='183.5'
          y2='70.7007'
          gradientUnits='userSpaceOnUse'
        >
          <stop stopColor='#D1D1D1' stopOpacity='0' />
          <stop offset='1' stopColor='#D1D1D1' />
        </linearGradient>
      </defs>
      <g
        stroke={`url(#${gradientId})`}
        strokeWidth='5'
        strokeLinecap='round'
        strokeLinejoin='round'
      >
        <path d='M196.018 47.0089C196.018 47.0089 214.273 47.5549 219.638 40.0533C225.003 32.5517 231.983 23.9343 231.983 23.9343L211.567 9.97563L223.389 -57.6814' />
        <path d='M226.165 -57.6824C226.165 -57.6824 230.77 -50.062 232.693 -49.3261C234.616 -48.5902 251.257 -59.0592 253.18 -58.7506C255.103 -58.442 285.323 -35.7472 285.323 -35.7472C285.323 -35.7472 259.376 -7.8773 252.444 2.42556C245.513 12.7284 232.005 23.9571 232.005 23.9571' />
        <path d='M285.297 -35.7698C285.297 -35.7698 301.012 -29.9536 301.677 -9.98888C302.342 9.97587 311.339 40.0061 317.131 48.1724C322.924 56.3388 360.883 119.557 360.883 119.557C360.883 119.557 430.415 95.8647 442 94.2742C453.585 92.6836 495.722 75.8287 498.357 73.7397' />
        <path d='M0 105.859C0 105.859 24.8313 115.331 29.5792 124.826C34.327 134.322 35.3716 141.159 46.4341 146.429C57.4966 151.699 83.3012 156.969 94.886 163.806C106.471 170.643 126.483 179.071 138.614 165.919C139.207 165.278 139.753 164.613 140.228 163.949C149.415 151.177 137.403 136.103 144.406 119.58C151.789 102.203 198.01 82.9028 198.01 82.9028C195.802 75.14 195.707 68.9678 196.015 64.7659C196.561 57.288 198.698 52.5402 196.015 47.0327C196.015 47.0327 194.164 43.2344 190.104 40.5993C179.493 33.7387 170.781 43.8279 153.593 44.3501C136.406 44.8724 101.509 -35.6751 58.5411 -68.4116C18.0656 -89.3497 27.9412 -104.4 0 -104.4' />
        <path d='M168.146 241.576C168.146 241.576 173.321 209.718 138.377 166.275' />
        <path d='M142.793 158.94C142.793 158.94 162.093 154.548 181.179 164.068C200.266 173.587 217.026 172.923 223.554 164.4C230.082 155.878 244.516 132.138 244.516 124.684C244.516 117.23 237.537 86.9625 198.011 83.8052' />
        <path d='M197.298 54.0835C197.298 54.0835 218.734 65.7158 237.227 74.2857C255.72 82.8555 266.854 124.613 266.854 124.613' />
        <path d='M244.516 124.684L340.968 129.575L360.886 119.557L367.2 132.138C367.2 132.138 376.981 132.138 376.981 141.397C376.981 150.655 382.132 159.913 382.132 159.913C382.132 159.913 422.75 149.895 438.181 142.299C453.611 134.702 472.627 159.913 472.627 159.913C472.627 159.913 484.449 168.792 490.123 172.828C495.796 176.863 498.384 175.32 498.384 175.32' />
        <path d='M308.209 127.912L332.637 162.5L340.969 129.574L367.201 132.138' />
        <path d='M285.3 249.482L282.784 219.333L276.754 216.104L233.786 193.053' />
        <path d='M327.554 251.713C327.554 251.713 300.254 236.472 295.815 227.594C291.376 218.715 282.806 219.332 282.806 219.332' />
        <path d='M276.753 216.104C276.753 216.104 336.742 187.902 342.131 188.852C347.52 189.801 347.852 175.629 347.852 175.629L332.611 162.501C332.611 162.501 271.34 172.828 237.369 191.392C219.28 200.175 208.478 199.321 207.837 192.033C207.197 184.745 197.962 170.05 197.962 170.05' />
        <path d='M367.199 260.402C367.199 260.402 367.128 239.203 359.294 229.684C351.46 220.164 342.178 188.852 342.178 188.852' />
        <path d='M366.582 251.714L418.263 219.333C418.263 219.333 416.981 206.752 438.845 191.962C460.708 177.172 478.632 164.424 478.632 164.424L490.098 172.852C490.098 172.852 486.466 191.321 499 206.752' />
        <path d='M347.612 178.88C347.612 178.88 368.788 171.996 373.963 165.491C379.138 158.987 382.106 159.913 382.106 159.913' />
      </g>
    </svg>
  );
};

export const TeaserCard = forwardRef<HTMLElement, TeaserCardProps>(
  (
    {
      heading = 'Entdecken Sie die Region mit der Karte',
      body = 'Ihr Kompass für das Hameln-Pyrmont. Navigieren Sie sich durch die Vielfalt unseres Landkreises und planen Sie Ihr nächstes Abenteuer.',
      ctaLabel = 'Zur interaktiven Karte',
      onCtaClick,
      backgroundImage = poiBackground,
      className,
      ...rest
    },
    ref,
  ) => {
    const headingId = useId();
    return (
      <section
        {...rest}
        ref={ref}
        aria-labelledby={headingId}
        className={`px-16 py-6 ${className ?? ''}`}
      >
        <article className='relative aspect-[952/368] w-full overflow-hidden rounded-xl shadow-[0_0_1.5px_rgba(0,0,0,0.25)]'>
          <img
            src={backgroundImage}
            alt=''
            aria-hidden
            className='absolute inset-0 size-full object-cover'
            draggable={false}
          />
          <div
            aria-hidden
            className='absolute inset-0'
            style={{
              background:
                'linear-gradient(-90deg, rgba(255, 255, 255, 0.2) 18.33%, rgba(251, 251, 251, 0.9) 73.319%)',
            }}
          />
          <div
            aria-hidden
            className='pointer-events-none absolute left-0'
            style={{
              top: '-10%',
              width: '52.42%',
              aspectRatio: '499 / 261',
            }}
          >
            <MapIllustration />
          </div>

          <div className='absolute inset-x-6 bottom-6 flex items-end gap-4 rounded-lg bg-gray-50 px-4 pb-4 pt-8'>
            <div className='absolute -top-5 left-4'>
              <PoiCluster />
            </div>

            <div className='flex min-w-0 flex-1 flex-col gap-1 text-gray-900'>
              <h2
                id={headingId}
                className='text-[21px] font-bold leading-tight'
              >
                {heading}
              </h2>
              <p className='text-base leading-tight'>{body}</p>
            </div>

            <button
              type='button'
              onClick={onCtaClick}
              className='inline-flex h-[50px] shrink-0 items-center justify-center gap-2 rounded-[10px] bg-hameln-675 px-4 py-2 text-base text-white outline-none transition-colors hover:bg-hameln-700 focus-visible:ring-2 focus-visible:ring-hameln-600/50 active:bg-hameln-800'
            >
              {ctaLabel}
              <MdArrowForward className='size-6' aria-hidden />
            </button>
          </div>
        </article>
      </section>
    );
  },
);
TeaserCard.displayName = 'TeaserCard';
