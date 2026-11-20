import {
  createContext,
  type ReactNode,
  useContext,
  useEffect,
  useMemo,
} from 'react';
import {useSearchParams} from 'react-router';
import {STELE_CONFIG} from '../config';
import {
  type KioskHomeWeatherQuery,
  useKioskHomeWeatherQuery,
} from '../routes/home/home.generated';
import {compact} from '../utils/arrayUtils';

const DEFAULT_LOCATION_NAME = 'Hameln';
const LOCATION_STORAGE_KEY = 'stele:locationName';
const LOCATION_PARAM = 'location';
const LAT_PARAM = 'lat';
const LNG_PARAM = 'lng';

type Wettermesspunkt = NonNullable<
  NonNullable<KioskHomeWeatherQuery['wettermesspunkteList']>['docs']
>[number];

interface LocationContextValue {
  locationName: string;
  forecast: NonNullable<Wettermesspunkt>['weather'];
  position: [number, number] | null;
}

const LocationContext = createContext<LocationContextValue | null>(null);

const readUrlLocation = (sp: URLSearchParams): string | null => {
  const value = sp.get(LOCATION_PARAM)?.trim();
  return value && value.length > 0 ? value : null;
};

const parseCoordinate = (
  raw: string | null | undefined,
  limit: number,
): number | null => {
  const trimmed = raw?.trim();
  if (!trimmed) return null;
  const value = Number(trimmed);
  return Number.isFinite(value) && Math.abs(value) <= limit ? value : null;
};

export const readUrlCoordinates = (
  sp: URLSearchParams,
): [number, number] | null => {
  const lat = parseCoordinate(sp.get(LAT_PARAM), 90);
  const lng = parseCoordinate(sp.get(LNG_PARAM), 180);
  return lat !== null && lng !== null ? [lat, lng] : null;
};

type UrlCoordinates =
  | {status: 'absent'}
  | {status: 'invalid'}
  | {status: 'valid'; coordinates: [number, number]};

const readUrlCoordinateState = (sp: URLSearchParams): UrlCoordinates => {
  if (!sp.has(LAT_PARAM) && !sp.has(LNG_PARAM)) {
    return {status: 'absent'};
  }

  const coordinates = readUrlCoordinates(sp);
  return coordinates ? {status: 'valid', coordinates} : {status: 'invalid'};
};

const readStoredLocation = (): string | null => {
  try {
    const v = sessionStorage.getItem(LOCATION_STORAGE_KEY)?.trim();
    return v && v.length > 0 ? v : null;
  } catch {
    return null;
  }
};

export const buildKioskHomeHref = (): string => {
  const location =
    readUrlLocation(new URLSearchParams(window.location.search)) ??
    readStoredLocation();
  const params = new URLSearchParams();
  if (location) params.set(LOCATION_PARAM, location);
  const query = params.toString();
  return query ? `/?${query}` : '/';
};

export const LocationProvider = ({children}: {children: ReactNode}) => {
  const [searchParams] = useSearchParams();
  const locationName =
    readUrlLocation(searchParams) ??
    readStoredLocation() ??
    DEFAULT_LOCATION_NAME;
  const urlCoordinates = useMemo(
    () => readUrlCoordinateState(searchParams),
    [searchParams],
  );
  const coordinateOverride = useMemo(
    () =>
      urlCoordinates.status === 'valid' ? urlCoordinates.coordinates : null,
    [urlCoordinates],
  );

  useEffect(() => {
    try {
      sessionStorage.setItem(LOCATION_STORAGE_KEY, locationName);
    } catch (e) {
      console.error(e);
    }
  }, [locationName]);

  const [{data: kioskHomeWeatherQueryResponse}] = useKioskHomeWeatherQuery({
    variables: {
      locationName,
      kommuneId: STELE_CONFIG.kommuneId,
    },
  });

  const locationContextValue = useMemo<LocationContextValue>(() => {
    const point = compact(
      kioskHomeWeatherQueryResponse?.wettermesspunkteList?.docs,
    )[0];
    const rawLocation = point?.location;
    const weatherPosition: [number, number] | null =
      rawLocation && rawLocation.length >= 2
        ? [rawLocation[0], rawLocation[1]]
        : null;
    return {
      locationName: point?.locationName ?? locationName,
      forecast: point?.weather ?? [],
      position: coordinateOverride ?? weatherPosition,
    };
  }, [kioskHomeWeatherQueryResponse, locationName, coordinateOverride]);

  return (
    <LocationContext.Provider value={locationContextValue}>
      {children}
    </LocationContext.Provider>
  );
};

export const useLocationContext = () => {
  const ctx = useContext(LocationContext);
  if (!ctx) {
    throw new Error(
      'useLocationContext must be used within a LocationProvider',
    );
  }
  return ctx;
};
