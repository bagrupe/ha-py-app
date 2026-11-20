import {createElement} from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {beforeEach, describe, expect, it, vi} from 'vitest';

const routerState = vi.hoisted(() => ({
  searchParams: new URLSearchParams(),
}));

vi.mock('react-router', () => ({
  useSearchParams: () => [routerState.searchParams],
}));

vi.mock('../routes/home/home.generated', () => ({
  useKioskHomeWeatherQuery: () => [
    {
      data: {
        wettermesspunkteList: {
          docs: [
            {
              location: [52.1, 10.1],
              locationName: 'Weather station',
              weather: [],
            },
          ],
        },
      },
    },
  ],
}));

import {LocationProvider, useLocationContext} from './location-context';

const WEATHER_POSITION: [number, number] = [52.1, 10.1];

const storageValues = new Map<string, string>();
const sessionStorageMock: Storage = {
  get length() {
    return storageValues.size;
  },
  clear: () => storageValues.clear(),
  getItem: (key) => storageValues.get(key) ?? null,
  key: (index) => [...storageValues.keys()][index] ?? null,
  removeItem: (key) => storageValues.delete(key),
  setItem: (key, value) => storageValues.set(key, value),
};

const renderPosition = (query: string) => {
  routerState.searchParams = new URLSearchParams(query);

  const ContextProbe = () => JSON.stringify(useLocationContext().position);

  const markup = renderToStaticMarkup(
    createElement(LocationProvider, null, createElement(ContextProbe)),
  );

  return JSON.parse(markup) as [number, number] | null;
};

describe('LocationProvider coordinate precedence', () => {
  beforeEach(() => {
    storageValues.clear();
    vi.stubGlobal('sessionStorage', sessionStorageMock);
  });

  it('uses valid URL coordinates', () => {
    expect(renderPosition('lat=53.1&lng=11.1')).toEqual([53.1, 11.1]);
  });

  it('falls back to the weather position when neither URL parameter is present', () => {
    expect(renderPosition('location=Hameln')).toEqual(WEATHER_POSITION);
  });

  it.each(['lat=91&lng=11.1', 'lat=53.1', 'lng=11.1', 'lat=north&lng=11.1'])(
    'falls back to the weather position for invalid URL coordinates: %s',
    (query) => {
      expect(renderPosition(query)).toEqual(WEATHER_POSITION);
    },
  );
});
