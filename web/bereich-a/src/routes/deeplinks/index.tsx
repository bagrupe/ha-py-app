import {useEffect} from 'react';
import {redirect, type RouteObject} from 'react-router';
import PulseLoader from 'react-spinners/PulseLoader';
import {useTitle} from 'react-use';
import appstoreLogo from '../../assets/apps/appstore.svg';
import playstoreLogo from '../../assets/apps/playstore.svg';

/**
 * Prüft, ob das aktuelle Gerät ein iOS-Gerät oder Simulator ist.
 * @returns true, wenn iOS erkannt wird, sonst false
 */
const iOS = () =>
  [
    'iPad Simulator',
    'iPhone Simulator',
    'iPod Simulator',
    'iPad',
    'iPhone',
    'iPod',
  ].includes(navigator.platform) ||
  // iPad auf iOS 13 Erkennung
  (navigator.userAgent.includes('Mac') && 'ontouchend' in document);

/**
 * Prüft, ob das aktuelle Gerät ein Android-Gerät ist.
 * @returns true, wenn Android erkannt wird, sonst false
 */
const android = () => /android/i.test(navigator.userAgent);

const playstoreLink =
  'https://play.google.com/store/apps/details?id=de.landkreis.hapy.app';
const appstoreLink =
  'https://apps.apple.com/de/app/ha-py-landkreis-app/id6755150329';
const redirectLink = 'https://mitwirkportal.de/Ha-Py-landkreis-app';

/**
 * Komponente zur Anzeige einer Weiterleitungsseite für Deeplinks.
 * Setzt den Seitentitel und leitet nach kurzer Verzögerung zur passenden App-Store-Seite weiter.
 */
export const Deeplinks = () => {
  useTitle('Kommunal App');

  useEffect(() => {
    // Redirect to the app store after 5 seconds delay
    const timeout = setTimeout(() => {
      if (iOS()) window.location.href = appstoreLink;
      else if (android()) window.open(playstoreLink);
    }, 5000);

    return () => clearTimeout(timeout);
  }, []);

  return (
    <div className='flex h-screen flex-col items-center justify-center space-y-4 p-6'>
      <div className='mb-6'>
        <PulseLoader size={20} />
      </div>
      <p>Sie werden gleich weitergeleitet.</p>
      <p>
        Dies ist ein Link der Ha-Py App. Um den Link öffnen zu können, stellen
        Sie sicher, dass Sie die App von Google Play oder dem AppStore
        heruntergeladen haben.
      </p>
      <div className='flex space-x-8'>
        <a href={playstoreLink}>
          <img
            src={playstoreLogo}
            alt='Logo des Google Play Store'
            className='h-16'
          />
        </a>
        <a href={appstoreLink}>
          <img
            src={appstoreLogo}
            alt='Logo des Apple App Store'
            className='h-16'
          />
        </a>
      </div>
    </div>
  );
};

export const deeplinksLoader = async () => {
  const isMobile = iOS() || android();
  if (!isMobile) {
    return redirect(redirectLink);
  }
  return null;
};

/**
 * Route-Definition für die Deeplinks-Seite.
 * Verknüpft den Pfad mit der Deeplinks-Komponente.
 */
export const deeplinksRoute: RouteObject = {
  path: 'deeplinks/*',
  loader: deeplinksLoader,
  element: <Deeplinks />,
};
