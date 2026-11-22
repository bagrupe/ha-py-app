import * as maplibregl from 'maplibre-gl';
import maplibreWorkerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?worker&url';
import {type FC, useEffect, useMemo, useRef} from 'react';
import {mapTheme} from '../../../utils/map-theme.ts';
import 'maplibre-gl/dist/maplibre-gl.css';
import {type DashboardGebietFragment} from './dashboard.generated.ts';

maplibregl.setWorkerUrl(maplibreWorkerUrl);

export type KartenMarker = {
  id: string;
  lng: number;
  lat: number;
  label?: string;
  zahl?: number;
  farbe: string;
  klaerung?: boolean;
  ausgewaehlt?: boolean;
};

type Position = [number, number];
type Geometry =
  | {type: 'Polygon'; coordinates: Position[][]}
  | {type: 'MultiPolygon'; coordinates: Position[][][]};

const parseGeometry = (geometry?: string | null): Geometry | undefined => {
  if (!geometry) return undefined;
  try {
    const parsed = JSON.parse(geometry) as Geometry;
    return parsed.type === 'Polygon' || parsed.type === 'MultiPolygon'
      ? parsed
      : undefined;
  } catch {
    return undefined;
  }
};

const positionsOf = (geometry: Geometry): Position[] =>
  geometry.type === 'Polygon'
    ? geometry.coordinates.flat()
    : geometry.coordinates.flat(2);

const GEBIET_FARBEN = ['#3B4CCA', '#0E6E7A', '#B8327A', '#5E7A1F', '#C2410C'];

const markerElement = (marker: KartenMarker, onClick?: () => void) => {
  const root = document.createElement('button');
  root.type = 'button';
  root.className = 'flex items-center gap-1 focus:outline-none';
  root.setAttribute(
    'aria-label',
    `${marker.label ?? 'Ereignis'}${marker.klaerung ? ', in Klärung' : ''}`,
  );
  const dot = document.createElement('span');
  dot.className = `flex size-7 items-center justify-center rounded-full border-2 text-xs font-bold text-white shadow ${
    marker.ausgewaehlt ? 'border-gray-900 ring-2 ring-white' : 'border-white'
  }`;
  dot.style.background = marker.klaerung
    ? 'rgb(var(--color-warning))'
    : marker.farbe;
  dot.textContent = marker.klaerung ? '!' : String(marker.zahl ?? '');
  root.appendChild(dot);
  if (marker.label) {
    const label = document.createElement('span');
    label.className =
      'rounded bg-white px-1.5 py-0.5 text-xs font-semibold text-gray-900 shadow';
    label.textContent = marker.label;
    root.appendChild(label);
  }
  if (onClick) root.addEventListener('click', onClick);
  return root;
};

/**
 * OSM map with the Gebiete as shaded areas and one marker per report. `gebiete` decides both the drawn areas
 * and the initial view.
 */
export const LageKarte: FC<{
  gebiete: DashboardGebietFragment[];
  marker: KartenMarker[];
  onMarkerClick?: (id: string) => void;
  className?: string;
}> = ({gebiete, marker, onMarkerClick, className}) => {
  const container = useRef<HTMLDivElement>(null);
  const map = useRef<maplibregl.Map | null>(null);
  const markerRefs = useRef<maplibregl.Marker[]>([]);

  const flaechen = useMemo(() => {
    const features = gebiete.flatMap((gebiet, index) => {
      const geometry = parseGeometry(gebiet.geometry);
      return geometry
        ? [
            {
              type: 'Feature' as const,
              geometry,
              properties: {
                name: gebiet.name,
                farbe: GEBIET_FARBEN[index % GEBIET_FARBEN.length],
              },
            },
          ]
        : [];
    });
    return {type: 'FeatureCollection' as const, features};
  }, [gebiete]);

  const bounds = useMemo(() => {
    const positions = flaechen.features.flatMap((f) => positionsOf(f.geometry));
    if (positions.length === 0) return undefined;
    const lngs = positions.map((p) => p[0]);
    const lats = positions.map((p) => p[1]);
    return new maplibregl.LngLatBounds(
      [Math.min(...lngs), Math.min(...lats)],
      [Math.max(...lngs), Math.max(...lats)],
    );
  }, [flaechen]);

  useEffect(() => {
    if (!container.current) return;
    const instance = new maplibregl.Map({
      container: container.current,
      style: mapTheme,
      center: [9.36, 52.1],
      zoom: 9,
      attributionControl: {compact: true},
    });
    instance.addControl(
      new maplibregl.NavigationControl({showCompass: false}),
      'top-right',
    );
    map.current = instance;
    return () => {
      instance.remove();
      map.current = null;
    };
  }, []);

  useEffect(() => {
    const instance = map.current;
    if (!instance) return;
    const apply = () => {
      const source = instance.getSource('gebiete') as
        | maplibregl.GeoJSONSource
        | undefined;
      if (source) {
        source.setData(flaechen);
      } else {
        instance.addSource('gebiete', {type: 'geojson', data: flaechen});
        instance.addLayer({
          id: 'gebiete-fill',
          type: 'fill',
          source: 'gebiete',
          paint: {'fill-color': ['get', 'farbe'], 'fill-opacity': 0.08},
        });
        instance.addLayer({
          id: 'gebiete-line',
          type: 'line',
          source: 'gebiete',
          paint: {
            'line-color': ['get', 'farbe'],
            'line-width': 1.5,
            'line-opacity': 0.7,
          },
        });
        instance.addLayer({
          id: 'gebiete-label',
          type: 'symbol',
          source: 'gebiete',
          layout: {
            'text-field': ['get', 'name'],
            'text-font': ['Noto Sans Regular'],
            'text-size': 12,
          },
          paint: {
            'text-color': '#4E4E4E',
            'text-halo-color': '#FFFFFF',
            'text-halo-width': 1.5,
          },
        });
      }
      if (bounds) instance.fitBounds(bounds, {padding: 24, duration: 0});
    };
    if (instance.isStyleLoaded()) apply();
    else instance.once('load', apply);
  }, [flaechen, bounds]);

  useEffect(() => {
    const instance = map.current;
    if (!instance) return;
    markerRefs.current.forEach((m) => m.remove());
    markerRefs.current = marker.map((m) =>
      new maplibregl.Marker({
        element: markerElement(
          m,
          onMarkerClick ? () => onMarkerClick(m.id) : undefined,
        ),
        anchor: 'left',
        offset: [-14, 0],
      })
        .setLngLat([m.lng, m.lat])
        .addTo(instance),
    );
  }, [marker, onMarkerClick]);

  return (
    <div
      ref={container}
      className={className ?? 'h-[440px] w-full overflow-hidden rounded-lg'}
    />
  );
};
