interface PoiMarkerProps {
  iconUrl?: string | null;
  title: string;
  selected?: boolean;
}

const SELECTED_FILL = '#597D1C';
const DEFAULT_FILL = 'white';
const STROKE_COLOR = '#4E4E4E';
const INNER_RING_COLOR = 'white';
const INNER_RING_WIDTH = 5;

const PIN_PATH =
  'M20 0C31.0457 0 40 8.9543 40 20C40 28.4351 34.7774 35.6487 27.3899 38.588C26.6633 38.8771 26.0406 39.3918 25.6786 40.0849L22.2725 46.6064C21.5244 48.0382 19.4756 48.0382 18.7275 46.6064L15.553 40.5306C15.1611 39.7804 14.4659 39.2421 13.663 38.9741C5.72346 36.3237 0 28.8307 0 20C0 8.9543 8.9543 0 20 0Z';

const PIN_STROKE_OVERLAY =
  'M22.2725 46.6064L23.1588 47.0695L23.1588 47.0694L22.2725 46.6064ZM18.7275 46.6064L19.6139 46.1434L19.6139 46.1434L18.7275 46.6064ZM15.553 40.5306L14.6667 40.9937L15.553 40.5306ZM27.3899 38.588L27.7596 39.5171L27.3899 38.588ZM25.6786 40.0849L26.5649 40.5479L25.6786 40.0849ZM20 0V1C30.4934 1 39 9.50659 39 20H40H41C41 8.40202 31.598 -1 20 -1V0ZM40 20H39C39 28.0117 34.0403 34.8657 27.0202 37.6588L27.3899 38.588L27.7596 39.5171C35.5146 36.4316 41 28.8586 41 20H40ZM25.6786 40.0849L24.7922 39.622L21.3861 46.1435L22.2725 46.6064L23.1588 47.0694L26.5649 40.5479L25.6786 40.0849ZM22.2725 46.6064L21.3861 46.1434C21.0121 46.8592 19.9879 46.8592 19.6139 46.1434L18.7275 46.6064L17.8412 47.0695C18.9633 49.2172 22.0367 49.2172 23.1588 47.0695L22.2725 46.6064ZM18.7275 46.6064L19.6139 46.1434L16.4393 40.0675L15.553 40.5306L14.6667 40.9937L17.8412 47.0695L18.7275 46.6064ZM13.663 38.9741L13.9797 38.0255C6.43588 35.5073 1 28.3876 1 20H0H-1C-1 29.2739 5.01105 37.1402 13.3464 39.9226L13.663 38.9741ZM0 20H1C1 9.50659 9.50659 1 20 1V0V-1C8.40202 -1 -1 8.40202 -1 20H0ZM15.553 40.5306L16.4393 40.0675C15.9115 39.0573 14.9934 38.3639 13.9797 38.0255L13.663 38.9741L13.3464 39.9226C13.9385 40.1202 14.4106 40.5035 14.6667 40.9937L15.553 40.5306ZM27.3899 38.588L27.0202 37.6588C26.1021 38.0241 25.2795 38.6888 24.7922 39.622L25.6786 40.0849L26.5649 40.5479C26.8016 40.0948 27.2245 39.73 27.7596 39.5171L27.3899 38.588Z';

export const PoiMarker = ({
  iconUrl,
  title,
  selected = false,
}: PoiMarkerProps) => {
  const fill = selected ? SELECTED_FILL : DEFAULT_FILL;
  return (
    <div
      className='relative flex flex-col items-center'
      style={{width: 40, height: 48}}
    >
      <svg
        width='40'
        height='48'
        viewBox='0 0 40 48'
        fill='none'
        xmlns='http://www.w3.org/2000/svg'
        className='absolute inset-0'
        style={{zIndex: 'auto'}}
        aria-hidden='true'
      >
        <mask id='poi-marker-mask' fill='white'>
          <path d={PIN_PATH} />
        </mask>
        <path d={PIN_PATH} fill={fill} />
        {selected && (
          <path
            d={PIN_PATH}
            stroke={INNER_RING_COLOR}
            strokeWidth={INNER_RING_WIDTH}
            fill='none'
            mask='url(#poi-marker-mask)'
          />
        )}
        <path
          d={PIN_STROKE_OVERLAY}
          fill={STROKE_COLOR}
          mask='url(#poi-marker-mask)'
        />
      </svg>
      <div
        className='relative flex items-center justify-center'
        style={{width: 40, height: 40}}
      >
        {iconUrl && (
          <img
            src={iconUrl}
            alt={title}
            className='object-contain'
            style={{width: 24, height: 24}}
          />
        )}
      </div>
    </div>
  );
};
