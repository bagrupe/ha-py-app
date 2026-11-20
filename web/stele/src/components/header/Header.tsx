import {Link, useLocation} from 'react-router';
import headerBackground from '../../assets/Visual/carousel-artikel-default.png';
import {useLocationContext} from '../../context/location-context';
import ClockCard from './ClockCard';
import ForecastRow from './ForecastRow';

const HapyLogo = () => (
  <img
    alt='Landkreis Hameln-Pyrmont'
    src='/hapy_logo.svg'
    className='h-[86px] w-auto shrink-0 object-contain'
  />
);

export default function Header(props: {className?: string}) {
  const {locationName} = useLocationContext();
  const {search} = useLocation();
  return (
    <header
      className={`flex flex-col gap-6 px-16 py-6 ${props.className}`}
      style={{
        background: `linear-gradient(180deg, rgba(255, 255, 255, 0.00) 0%, #FFF 100%), url(${headerBackground}) lightgray 50% / cover no-repeat`,
      }}
    >
      <div className='flex items-center gap-6'>
        <Link
          to={{pathname: '/', search}}
          aria-label='Zur Startseite'
          className='rounded outline-none focus-visible:ring-2 focus-visible:ring-hameln-600/50'
        >
          <HapyLogo />
        </Link>
        <h1 className='whitespace-nowrap text-display-md text-gray-900'>
          Herzlich willkommen in {locationName}
        </h1>
      </div>
      <div className='flex h-[145px] items-stretch gap-6'>
        <ClockCard />
        <ForecastRow />
      </div>
    </header>
  );
}
