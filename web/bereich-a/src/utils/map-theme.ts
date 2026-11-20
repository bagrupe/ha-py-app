import {
  type ExpressionSpecification,
  type FilterSpecification,
  type StyleSpecification,
} from 'maplibre-gl';

const mapFont = ['Noto Sans Regular'];
const gebaeudeColor = '#d9d9d9';

const label: ExpressionSpecification = [
  'coalesce',
  ['get', 'name_de'],
  ['get', 'name'],
];

const MAJOR_ROADS = [
  'motorway',
  'trunk',
  'primary',
  'secondary',
  'tertiary',
  'minor',
];
const MINOR_ROADS = ['path', 'track', 'service'];
const VEGETATION = ['wood', 'grass', 'farmland', 'wetland'];
const ROCKY = ['rock', 'sand'];
const RAILS = ['rail', 'transit'];

const surfaceLevel: FilterSpecification = [
  'any',
  ['!has', 'brunnel'],
  [
    'all',
    ['!=', 'brunnel', 'Bruecke'],
    ['!=', 'brunnel', 'tunnel'],
    ['!=', 'brunnel', 'bridge'],
  ],
];

/**
 * Definiert das Kartenstil-Objekt für die Kommunal-App.
 * Enthält Konfigurationen für Layer, Quellen, Layout und Darstellung der Karte.
 */
export const mapTheme: StyleSpecification = {
  bearing: 0,
  center: [9.7424, 52.3739],
  glyphs: 'https://tiles.openfreemap.org/fonts/{fontstack}/{range}.pbf',
  layers: [
    {
      id: 'background',
      paint: {
        'background-color': '#f8f9fa',
      },
      type: 'background',
    },
    {
      filter: ['in', 'class', ...VEGETATION],
      id: 'landuse_greens',
      paint: {
        'fill-color': '#d2edae',
      },
      source: 'openmaptiles',
      'source-layer': 'landcover',
      type: 'fill',
    },
    {
      filter: ['in', 'class', ...ROCKY],
      id: 'rocky_terrain',
      paint: {
        'fill-color': '#848884',
      },
      source: 'openmaptiles',
      'source-layer': 'landcover',
      type: 'fill',
    },
    {
      filter: ['all', ['==', '$type', 'LineString']],
      id: 'waterway',
      paint: {
        'line-color': '#a0cfdf',
        'line-width': ['step', ['zoom'], 1.4, 8, 0.5, 20, 15],
      },
      source: 'openmaptiles',
      'source-layer': 'waterway',
      type: 'line',
    },
    {
      id: 'water',
      paint: {
        'fill-color': '#a0cfdf',
      },
      source: 'openmaptiles',
      'source-layer': 'water',
      type: 'fill',
    },
    {
      filter: ['==', '$type', 'Polygon'],
      id: 'area-verkehr',
      paint: {
        'fill-color': '#FFFFFF',
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'fill',
    },
    {
      id: 'building-gebaeude',
      paint: {
        'fill-color': '#f8f9fa',
        'fill-outline-color': '#2e2e2e',
      },
      source: 'openmaptiles',
      'source-layer': 'building',
      type: 'fill',
    },
    {
      id: 'building-bauwerk',
      paint: {
        'fill-color': '#f8f9fa',
        'fill-outline-color': '#2e2e2e',
      },
      source: 'openmaptiles',
      'source-layer': 'building',
      type: 'fill',
    },
    {
      filter: ['==', 'class', 'residential'],
      id: 'building-siedlung',
      paint: {
        'fill-color': '#F8F9FA',
        'fill-outline-color': '#2e2e2e',
      },
      source: 'openmaptiles',
      'source-layer': 'landuse',
      type: 'fill',
    },
    {
      id: 'Gebaeude2D_alle',
      paint: {
        'fill-color': '#F1F3F4',
        'fill-outline-color': gebaeudeColor,
      },
      source: 'openmaptiles',
      'source-layer': 'building',
      type: 'fill',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['all', ['in', 'class', ...MINOR_ROADS], ['==', 'brunnel', 'tunnel']],
      ],
      id: 'tunnel_minor',
      layout: {
        'line-cap': 'butt',
        'line-join': 'miter',
      },
      paint: {
        'line-color': '#efefef',
        'line-dasharray': [0.36, 0.18],
        'line-width': ['step', ['zoom'], 1.55, 4, 0.25, 20, 30],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['all', ['in', 'class', ...MAJOR_ROADS], ['==', 'brunnel', 'tunnel']],
      ],
      id: 'tunnel_major',
      layout: {
        'line-cap': 'butt',
        'line-join': 'miter',
      },
      paint: {
        'line-color': '#fff',
        'line-dasharray': [0.28, 0.14],
        'line-width': ['step', ['zoom'], 1.4, 6, 0.5, 20, 30],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['all', ['in', 'class', ...MINOR_ROADS], surfaceLevel],
      ],
      id: 'road_minor',
      layout: {
        'line-cap': 'round',
        'line-join': 'round',
      },
      paint: {
        'line-color': '#efefef',
        'line-width': ['step', ['zoom'], 1.55, 4, 0.25, 20, 30],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: ['all', ['==', '$type', 'LineString'], ['in', 'class', ...RAILS]],
      id: 'track',
      layout: {
        'line-cap': 'round',
        'line-join': 'round',
      },
      paint: {
        'line-color': '#9e9e9e',
        'line-width': ['step', ['zoom'], 1.4, 4, 0.25, 20, 10],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['all', ['in', 'class', ...MAJOR_ROADS], surfaceLevel],
      ],
      id: 'road_major',
      layout: {
        'line-cap': 'round',
        'line-join': 'round',
      },
      paint: {
        'line-color': '#fff',
        'line-width': ['step', ['zoom'], 1.4, 6, 0.5, 20, 30],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['all', ['in', 'class', ...MINOR_ROADS], ['==', 'brunnel', 'bridge']],
      ],
      id: 'bridge_minor',
      layout: {
        'line-cap': 'butt',
        'line-join': 'miter',
      },
      paint: {
        'line-color': '#dedede',
        'line-gap-width': ['step', ['zoom'], 1.55, 4, 0.25, 20, 30],
        'line-width': ['step', ['zoom'], 1.6, 12, 0.5, 20, 10],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['all', ['in', 'class', ...MAJOR_ROADS], ['==', 'brunnel', 'bridge']],
      ],
      id: 'bridge_major',
      layout: {
        'line-cap': 'butt',
        'line-join': 'miter',
      },
      paint: {
        'line-color': '#dedede',
        'line-gap-width': ['step', ['zoom'], 1.55, 4, 0.25, 20, 30],
        'line-width': ['step', ['zoom'], 1.6, 12, 0.5, 20, 10],
      },
      source: 'openmaptiles',
      'source-layer': 'transportation',
      type: 'line',
    },
    {
      filter: ['all', ['==', '$type', 'Point'], ['<=', 'rank', 1]],
      id: 'poi_label',
      layout: {
        'text-anchor': 'top',
        'text-field': label,
        'text-font': mapFont,
        'text-max-width': 8,
        'text-offset': [0, 0.5],
        'text-size': 11,
      },
      minzoom: 15,
      paint: {
        'text-color': '#666',
        'text-halo-blur': 1,
        'text-halo-color': 'rgba(255,255,255,0.75)',
        'text-halo-width': 1,
      },
      source: 'openmaptiles',
      'source-layer': 'poi',
      type: 'symbol',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'LineString'],
        ['in', 'class', ...MAJOR_ROADS],
      ],
      id: 'road_major_label',
      layout: {
        'symbol-placement': 'line',
        'text-field': label,
        'text-font': mapFont,
        'text-letter-spacing': 0.1,
        'text-size': ['step', ['zoom'], 1.4, 10, 8, 20, 14],
        'text-transform': 'uppercase',
      },
      source: 'openmaptiles',
      'source-layer': 'transportation_name',
      paint: {
        'text-color': '#666',
        'text-halo-color': 'rgba(255,255,255,0.75)',
        'text-halo-width': 2,
      },
      type: 'symbol',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'Point'],
        [
          'in',
          'class',
          'county',
          'suburb',
          'neighbourhood',
          'village',
          'hamlet',
        ],
      ],
      id: 'place_label_other',
      layout: {
        'text-field': label,
        'text-font': mapFont,
        'text-max-width': 6,
        'text-rotation-alignment': 'viewport',
        'text-size': 12,
      },
      minzoom: 8,
      paint: {
        'text-color': '#666',
        'text-halo-blur': 1,
        'text-halo-color': 'rgba(255,255,255,0.75)',
        'text-halo-width': 1,
      },
      source: 'openmaptiles',
      'source-layer': 'place',
      type: 'symbol',
    },
    {
      filter: [
        'all',
        ['==', '$type', 'Point'],
        ['in', 'class', 'city', 'town'],
      ],
      id: 'place_label_city',
      layout: {
        'text-field': label,
        'text-font': mapFont,
        'text-max-width': 10,
        'text-rotation-alignment': 'viewport',
        'text-size': 12,
      },
      maxzoom: 16,
      paint: {
        'text-color': '#666',
        'text-halo-blur': 1,
        'text-halo-color': 'rgba(255,255,255,0.75)',
        'text-halo-width': 1,
      },
      source: 'openmaptiles',
      'source-layer': 'place',
      type: 'symbol',
    },
    {
      filter: ['all', ['==', '$type', 'Point'], ['==', 'class', 'country']],
      id: 'country_label',
      layout: {
        'text-field': label,
        'text-font': mapFont,
        'text-max-width': 10,
        'text-rotation-alignment': 'viewport',
        'text-size': 14,
      },
      maxzoom: 12,
      paint: {
        'text-color': '#666',
        'text-halo-blur': 1,
        'text-halo-color': 'rgba(255,255,255,0.75)',
        'text-halo-width': 1,
      },
      source: 'openmaptiles',
      'source-layer': 'place',
      type: 'symbol',
    },
  ],
  name: 'bm_web_col',
  pitch: 0,
  sources: {
    openmaptiles: {
      attribution:
        '<a href="https://openfreemap.org" target="_blank">OpenFreeMap</a> | <a href="https://www.openmaptiles.org/" target="_blank">&copy; OpenMapTiles</a> | Daten von <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>',
      type: 'vector',
      url: 'https://tiles.openfreemap.org/planet',
    },
  },
  version: 8,
  zoom: 26,
};
