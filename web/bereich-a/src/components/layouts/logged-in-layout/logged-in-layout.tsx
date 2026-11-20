import {useEffect, useMemo} from 'react';
import {Helmet} from 'react-helmet-async';
import {Outlet} from 'react-router';
import {useAuth} from '../../../lib/context/auth/auth.tsx';
import {KommuneProvider} from '../../../lib/context/kommune/kommune.tsx';
import {getDelay} from '../../../utils/calculate-delay-for-interval.ts';
import {OffScreenWrapper} from '../../offscreen.tsx';
import {
  useLoggedInLayoutQuery,
  useRechtstexteQuery,
} from './logged-in-layout.generated.ts';
import {DesktopNavigation} from './navigation/desktop-navigation/desktop-navigation.tsx';
import {MobileNavigationToggle} from './navigation/mobile-navigation/mobile-navigation-toggle.tsx';
import {MobileNavigation} from './navigation/mobile-navigation/mobile-navigation.tsx';

/**
 * Layout für eingeloggte Benutzer. Beinhaltet die Navigation, Hauptinhalte und rechtliche Links wie Impressum und Datenschutz.
 *
 * Lädt Daten für den eingeloggten Benutzer, rendert Navigationen für Desktop und Mobile und stellt den Hauptbereich (`Outlet`) bereit.
 */
export const LoggedInLayout = () => {
  const {user} = useAuth();
  const context = useMemo(() => ({additionalTypenames: ['Ausfuehrung']}), []);
  const [{data, fetching}, refetch] = useLoggedInLayoutQuery({
    pause: !user,
    context,
  });

  useEffect(() => {
    if (fetching) return;

    const delay = getDelay();

    const timerId = setTimeout(() => {
      refetch({requestPolicy: 'cache-and-network'});
    }, delay);
    return () => clearTimeout(timerId);
  }, [fetching, data, refetch]);

  const ausfuehrungenNeuCount = data?.neu?.totalCount;
  const ausfuehrungenInBearbeitungCount = data?.inBearbeitung?.totalCount;
  const ausfuehrungenAbgeschlossenCount = data?.abgeschlossen?.totalCount;

  if (!user || !('kommune' in user)) {
    return null;
  }

  return (
    <KommuneProvider kommuneId={user.kommune.id}>
      <Helmet>
        <title>Anträge</title>
      </Helmet>
      <OffScreenWrapper
        offScreen={
          <MobileNavigation
            ausfuehrungenNeuCount={ausfuehrungenNeuCount}
            ausfuehrungenInBearbeitungCount={ausfuehrungenInBearbeitungCount}
            ausfuehrungenAbgeschlossenCount={ausfuehrungenAbgeschlossenCount}
          />
        }
        offScreenWidth={300}
      >
        <div className='flex h-screen flex-col overflow-hidden print:overflow-visible'>
          <DesktopNavigation
            ausfuehrungenNeuCount={ausfuehrungenNeuCount}
            ausfuehrungenInBearbeitungCount={ausfuehrungenInBearbeitungCount}
            ausfuehrungenAbgeschlossenCount={ausfuehrungenAbgeschlossenCount}
          />
          <MobileNavigationToggle />
          <div
            id='main-content'
            className='relative flex-1 overflow-y-auto overflow-x-hidden print:overflow-visible'
          >
            <Outlet />
          </div>
          <RechtstexteFooter />
        </div>
      </OffScreenWrapper>
    </KommuneProvider>
  );
};

const RechtstexteFooter = () => {
  const [{data}] = useRechtstexteQuery();

  const my = data?.my ?? {};
  const {impressum = '/impressum', privacy = '/datenschutz'} =
    'kommune' in my ? my.kommune.rechtsTexte : {};

  return (
    <div className='flex justify-center gap-x-4 px-4 py-2 text-gray-400 print:hidden'>
      <a
        href={impressum ?? '/impressum'}
        rel='noreferrer noopener'
        target='_blank'
        className='hover:underline'
      >
        Impressum
      </a>
      <a
        href={privacy ?? '/datenschutz'}
        rel='noreferrer noopener'
        target='_blank'
        className='hover:underline'
      >
        Datenschutzerklärung
      </a>
    </div>
  );
};
