import {useLocation, useNavigate} from 'react-router';
import {TeaserCard} from '../../components/teaser-card';
import {STELE_CONFIG} from '../../config';
import {useTimerStore} from '../../store/useCountdownStore';
import {AktuellesBlock} from './aktuelles-block';
import {EventsBlock} from './events-block';

export const HomePage = () => {
  const timeRemaining = useTimerStore((state) => state.timeRemaining);
  const navigate = useNavigate();
  const {search} = useLocation();

  return (
    <>
      <AktuellesBlock />
      <EventsBlock />
      {STELE_CONFIG.showPoiMap && (
        <TeaserCard
          ctaLabel='Zur interaktiven Karte'
          backgroundImage={STELE_CONFIG.poiMapCardImage}
          onCtaClick={() => navigate({pathname: '/karte', search})}
        />
      )}
      {import.meta.env.MODE === 'development' && (
        <div>There are {timeRemaining} seconds remaining.</div>
      )}
    </>
  );
};
