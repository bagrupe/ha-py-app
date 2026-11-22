import * as maplibregl from 'maplibre-gl';
import maplibreWorkerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?worker&url';
import {type FC, useEffect, useMemo, useRef} from 'react';
import 'maplibre-gl/dist/maplibre-gl.css';
import {LageGebietStatus} from '../../../__generated__/graphql.ts';
import {
  type DashboardGebietFragment,
  type DashboardLageFragment,
} from './dashboard.generated.ts';

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

// The app's own map theme is tuned for street level and turns into noise at the regional zoom of a Lage.
const REGIONAL_STYLE = 'https://tiles.openfreemap.org/styles/positron';

const LIVE_FARBE = '#C81E1E';
const RUHIG_FARBE = '#6B7280';

export const liveGebietIds = (lage?: DashboardLageFragment) =>
  new Set(
    lage?.gebiete
      .filter((g) => g.status === LageGebietStatus.Live)
      .map((g) => g.gebietId),
  );

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
 * OSM map with the Gebiete as areas and one marker per report. `gebiete` decides both the drawn areas and the
 * initial view; Gebiete in `live` stand out as taking reports, the others are only outlined.
 */
export const LageKarte: FC<{
  gebiete: DashboardGebietFragment[];
  live: ReadonlySet<string>;
  marker: KartenMarker[];
  onMarkerClick?: (id: string) => void;
  className?: string;
}> = ({gebiete, live, marker, onMarkerClick, className}) => {
  const container = useRef<HTMLDivElement>(null);
  const map = useRef<maplibregl.Map | null>(null);
  const markerRefs = useRef<maplibregl.Marker[]>([]);
  const eingepasst = useRef(false);

  const flaechen = useMemo(() => {
    const features = gebiete.flatMap((gebiet) => {
      const geometry = parseGeometry(gebiet.geometry);
      return geometry
        ? [
            {
              type: 'Feature' as const,
              geometry,
              properties: {name: gebiet.name, live: live.has(gebiet.id)},
            },
          ]
        : [];
    });
    return {type: 'FeatureCollection' as const, features};
  }, [gebiete, live]);

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
      style: REGIONAL_STYLE,
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
        const ersteBeschriftung = instance
          .getStyle()
          .layers.find((layer) => layer.type === 'symbol')?.id;
        const live: maplibregl.ExpressionSpecification = ['get', 'live'];
        instance.addLayer(
          {
            id: 'gebiete-fill',
            type: 'fill',
            source: 'gebiete',
            paint: {
              'fill-color': ['case', live, LIVE_FARBE, RUHIG_FARBE],
              'fill-opacity': ['case', live, 0.12, 0.03],
            },
          },
          ersteBeschriftung,
        );
        instance.addLayer(
          {
            id: 'gebiete-line-ruhig',
            type: 'line',
            source: 'gebiete',
            filter: ['!', live],
            paint: {
              'line-color': RUHIG_FARBE,
              'line-width': 1.25,
              'line-dasharray': [3, 2],
            },
          },
          ersteBeschriftung,
        );
        instance.addLayer(
          {
            id: 'gebiete-line-live',
            type: 'line',
            source: 'gebiete',
            filter: live,
            paint: {'line-color': LIVE_FARBE, 'line-width': 3},
          },
          ersteBeschriftung,
        );
        instance.addLayer({
          id: 'gebiete-label',
          type: 'symbol',
          source: 'gebiete',
          layout: {
            'text-field': ['get', 'name'],
            'text-font': [
              'case',
              live,
              ['literal', ['Noto Sans Bold']],
              ['literal', ['Noto Sans Regular']],
            ],
            'text-size': ['case', live, 14, 12],
          },
          paint: {
            'text-color': ['case', live, '#111827', '#4B5563'],
            'text-halo-color': '#FFFFFF',
            'text-halo-width': 2,
          },
        });
      }
      // Only the first time: every refetch passes new Gebiete and must not undo the user's zoom.
      if (bounds && !eingepasst.current) {
        instance.fitBounds(bounds, {padding: 24, duration: 0});
        eingepasst.current = true;
      }
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

export const GebietLegende: FC = () => (
  <>
    <span className='flex items-center gap-1.5'>
      <span
        aria-hidden
        className='h-3 w-4 rounded-sm border-2'
        style={{borderColor: LIVE_FARBE, background: `${LIVE_FARBE}2E`}}
      />
      Gebiet mit aktiver Lage
    </span>
    <span className='flex items-center gap-1.5'>
      <span
        aria-hidden
        className='h-3 w-4 rounded-sm border border-dashed'
        style={{borderColor: RUHIG_FARBE}}
      />
      Gebiet ohne aktive Lage
    </span>
  </>
);
