import L from 'leaflet';
import 'leaflet.markercluster';
import {renderToStaticMarkup} from 'react-dom/server';
import {
  CLUSTER_MAX_SCALE,
  CLUSTER_MIN_COUNT,
  CLUSTER_MIN_SCALE,
  CLUSTER_SCALE_RANGE,
  CLUSTER_SIZE,
} from './constants';

const clamp = (value: number, min: number, max: number) =>
  Math.min(Math.max(value, min), max);

export const computeClusterScale = (count: number) => {
  const t = clamp((count - CLUSTER_MIN_COUNT) / CLUSTER_SCALE_RANGE, 0, 1);
  return CLUSTER_MIN_SCALE + (CLUSTER_MAX_SCALE - CLUSTER_MIN_SCALE) * t;
};

const formatCount = (count: number) => (count > 99 ? '99+' : String(count));

interface PoiClusterBubbleProps {
  count: number;
}

const PoiClusterBubble = ({count}: PoiClusterBubbleProps) => {
  const scale = computeClusterScale(count);
  return (
    <div
      className='relative flex items-center justify-center'
      style={{width: CLUSTER_SIZE, height: CLUSTER_SIZE}}
    >
      <div
        className='absolute inset-0 rounded-full'
        style={{
          backgroundColor: 'rgba(255, 255, 255, 0.667)',
          transform: `scale(${scale})`,
          transformOrigin: 'center',
        }}
      />
      <div
        className='relative flex items-center justify-center rounded-full border border-gray-900 bg-white text-base font-bold text-gray-900'
        style={{width: CLUSTER_SIZE, height: CLUSTER_SIZE}}
      >
        {formatCount(count)}
      </div>
    </div>
  );
};

export const createClusterIcon = (cluster: L.MarkerCluster): L.DivIcon =>
  L.divIcon({
    html: renderToStaticMarkup(
      <PoiClusterBubble count={cluster.getChildCount()} />,
    ),
    className: 'poi-cluster-icon',
    iconSize: [CLUSTER_SIZE, CLUSTER_SIZE],
    iconAnchor: [CLUSTER_SIZE / 2, CLUSTER_SIZE / 2],
  });
