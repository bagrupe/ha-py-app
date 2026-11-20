import {createBrowserRouter, type RouteObject} from 'react-router';
import {STELE_CONFIG} from './config';
import {LocationProvider} from './context/location-context';
import {HomePage} from './routes/home/home';
import {KartePage} from './routes/karte/karte';
import {StelLayout} from './StelLayout';

const childRoutes: Array<RouteObject & {enabled?: boolean}> = [
  {path: '/', element: <HomePage />},
  {path: '/karte', element: <KartePage />, enabled: STELE_CONFIG.showPoiMap},
  {path: '*', element: <HomePage />},
];

const enabledChildren: RouteObject[] = childRoutes
  .filter((r) => r.enabled !== false)
  .map(({enabled: _enabled, ...route}) => route);

export const router = createBrowserRouter([
  {
    element: (
      <LocationProvider>
        <StelLayout />
      </LocationProvider>
    ),
    children: enabledChildren,
  },
]);
