import L from 'leaflet';
import {useEffect, useLayoutEffect, useMemo, useRef, useState} from 'react';
import {renderToStaticMarkup} from 'react-dom/server';
import {MapContainer, Marker, Popup, TileLayer, useMap} from 'react-leaflet';
import MarkerClusterGroup from 'react-leaflet-cluster';
import {MapFilter, MapFilterCategory} from '../../components/map-filter';
import {PoiMarker} from '../../components/poi-marker';
import {
  Tooltip as PoiTooltip,
  TooltipDetailList,
} from '../../components/tooltip';
import {STELE_CONFIG} from '../../config';
import {useLocationContext} from '../../context/location-context';
import {compact} from '../../utils/arrayUtils';
import {
  ATTRIBUTION,
  CLUSTER_RADIUS,
  FALLBACK_CENTER,
  INITIAL_ZOOM,
  MARKER_HEIGHT,
  MARKER_WIDTH,
  MAX_ZOOM,
  POI_LIMIT,
  TILE_URL,
} from './constants';
import {type StelePoisQuery, useStelePoisQuery} from './karte.generated';
import {createClusterIcon} from './PoiClusterIcon';
import {usePoiCategoryFilter} from './use-poi-category-filter';

type SelectedPoi = NonNullable<
  NonNullable<NonNullable<StelePoisQuery['pois']>['docs']>[number]
>;

const POPUP_EDGE_PADDING = 16;

const buildPoiIcon = (
  iconUrl: string | null | undefined,
  title: string,
  selected = false,
) =>
  L.divIcon({
    html: renderToStaticMarkup(
      <PoiMarker iconUrl={iconUrl} title={title} selected={selected} />,
    ),
    className: 'poi-marker-icon',
    iconSize: [MARKER_WIDTH, MARKER_HEIGHT],
    iconAnchor: [MARKER_WIDTH / 2, MARKER_HEIGHT],
    popupAnchor: [0, -MARKER_HEIGHT],
  });

const RecenterOnPosition = ({
  position,
}: {
  position: [number, number] | null;
}) => {
  const map = useMap();
  const hasCenteredRef = useRef(false);
  useEffect(() => {
    if (!position || hasCenteredRef.current) return;
    map.setView(position, INITIAL_ZOOM);
    hasCenteredRef.current = true;
  }, [map, position]);
  return null;
};

const HERE_COLOR = '#21A2FF';
const HERE_DOT_SIZE = 24;
const HERE_BLOCK_WIDTH = 200;
const HERE_BLOCK_HEIGHT = 92;

const HereMarker = () => (
  <div
    style={{width: HERE_BLOCK_WIDTH, height: HERE_BLOCK_HEIGHT}}
    className='flex flex-col items-center justify-end gap-4'
  >
    <PoiTooltip variant='location' alignment='bottom'>
      Sie sind hier
    </PoiTooltip>
    <div
      style={{
        width: HERE_DOT_SIZE,
        height: HERE_DOT_SIZE,
        borderRadius: 9999,
        background: HERE_COLOR,
        border: '3px solid white',
        boxShadow: '0 2px 6px rgba(0,0,0,0.3)',
      }}
    />
  </div>
);

const hereIcon = L.divIcon({
  html: renderToStaticMarkup(<HereMarker />),
  className: 'stele-here-icon',
  iconSize: [HERE_BLOCK_WIDTH, HERE_BLOCK_HEIGHT],
  iconAnchor: [HERE_BLOCK_WIDTH / 2, HERE_BLOCK_HEIGHT - HERE_DOT_SIZE / 2],
});

const SelectedPoiLayer = ({
  poi,
  icon,
  topReserved,
  onClose,
}: {
  poi: SelectedPoi;
  icon: L.DivIcon;
  topReserved: number;
  onClose: () => void;
}) => {
  const map = useMap();
  const onCloseRef = useRef(onClose);
  useEffect(() => {
    onCloseRef.current = onClose;
  }, [onClose]);

  useEffect(() => {
    const close = () => onCloseRef.current();
    map.on('zoomstart', close);
    return () => {
      map.off('zoomstart', close);
    };
  }, [map]);

  return (
    <Marker
      key={poi.id ?? 'selected'}
      position={[poi.position[0], poi.position[1]]}
      icon={icon}
      zIndexOffset={1000}
      eventHandlers={{
        add: (e) => (e.target as L.Marker).openPopup(),
        click: onClose,
      }}
    >
      <Popup
        closeButton={false}
        autoClose={false}
        autoPan
        autoPanPaddingTopLeft={L.point(
          POPUP_EDGE_PADDING,
          topReserved + POPUP_EDGE_PADDING,
        )}
        autoPanPaddingBottomRight={L.point(
          POPUP_EDGE_PADDING,
          POPUP_EDGE_PADDING,
        )}
        className='stele-poi-popup'
        eventHandlers={{remove: onClose}}
      >
        <PoiTooltip
          variant='poi'
          alignment='bottom'
          header={poi.title}
          onClose={onClose}
        >
          <TooltipDetailList
            items={compact([
              poi.category
                ? {label: 'Kategorie', value: poi.category.title}
                : null,
              poi.positionString
                ? {label: 'Adresse', value: poi.positionString}
                : null,
              ...(poi.additionalInformation ?? []).flatMap((info) =>
                info?.heading && info.text
                  ? [{label: info.heading, value: info.text}]
                  : [],
              ),
            ])}
          />
        </PoiTooltip>
      </Popup>
    </Marker>
  );
};

export const KartePage = () => {
  const {position} = useLocationContext();
  const center = position ?? FALLBACK_CENTER;

  const [{data}] = useStelePoisQuery({
    variables: {kommuneId: STELE_CONFIG.kommuneId, limit: POI_LIMIT},
  });

  const [selectedPoiId, setSelectedPoiId] = useState<string | null>(null);

  const clearSelectedPoi = (poiId: string | null | undefined) => {
    setSelectedPoiId((currentPoiId) =>
      currentPoiId === poiId ? null : currentPoiId,
    );
  };

  const pois = useMemo(() => {
    const docs = compact(data?.pois?.docs);
    return docs.filter((p) => p.position.length >= 2);
  }, [data?.pois?.docs]);

  const {
    categoryGroups,
    pendingSelectedIds,
    setPendingSelectedIds,
    allPendingSelected,
    setAllPendingSelected,
    appliedSelectedCount,
    commit,
    revertPending,
    visiblePois,
  } = usePoiCategoryFilter(pois);

  const selectedPoi = useMemo(
    () =>
      selectedPoiId
        ? visiblePois.find((p) => p.id === selectedPoiId)
        : undefined,
    [visiblePois, selectedPoiId],
  );

  const selectedIcon = useMemo(
    () =>
      selectedPoi
        ? buildPoiIcon(selectedPoi.category?.icon?.url, selectedPoi.title, true)
        : null,
    [selectedPoi],
  );

  const poiIcons = useMemo(() => {
    const iconByUrl = new Map<string, L.DivIcon>();
    return visiblePois.map((poi) => {
      const url = poi.category?.icon?.url ?? '';
      let icon = iconByUrl.get(url);
      if (!icon) {
        icon = buildPoiIcon(poi.category?.icon?.url, poi.title);
        iconByUrl.set(url, icon);
      }
      return icon;
    });
  }, [visiblePois]);

  const [filterOpen, setFilterOpen] = useState(false);

  const headerRef = useRef<HTMLElement | null>(null);
  const [headerHeight, setHeaderHeight] = useState(0);

  useLayoutEffect(() => {
    const node = headerRef.current;
    if (!node) return;
    const update = () => setHeaderHeight(node.getBoundingClientRect().height);
    update();
    const observer = new ResizeObserver(update);
    observer.observe(node);
    return () => observer.disconnect();
  }, []);

  return (
    <div className='relative min-h-0 w-full flex-1'>
      <header
        ref={headerRef}
        className='pointer-events-none absolute inset-x-0 top-0 z-[1000] flex max-h-full flex-col items-start p-4'
      >
        <MapFilter
          open={filterOpen}
          onOpenChange={(open) => {
            if (!open) revertPending();
            setFilterOpen(open);
          }}
          allSelected={allPendingSelected}
          onAllSelectedChange={setAllPendingSelected}
          selectedCount={appliedSelectedCount}
          onConfirm={() => {
            commit();
            setFilterOpen(false);
          }}
          className='pointer-events-auto min-h-0'
        >
          {categoryGroups.map((group) => (
            <MapFilterCategory
              key={group.id}
              name={group.name}
              categories={group.items}
              selectedIds={pendingSelectedIds}
              onSelectionChange={setPendingSelectedIds}
            />
          ))}
        </MapFilter>
      </header>
      <MapContainer
        center={center}
        zoom={INITIAL_ZOOM}
        maxZoom={MAX_ZOOM}
        zoomControl={false}
        attributionControl
        className='absolute inset-0'
      >
        <TileLayer
          url={TILE_URL}
          attribution={ATTRIBUTION}
          maxZoom={MAX_ZOOM}
        />
        <RecenterOnPosition position={position} />
        {position && <Marker position={position} icon={hereIcon} />}
        <MarkerClusterGroup
          chunkedLoading
          maxClusterRadius={CLUSTER_RADIUS}
          showCoverageOnHover={false}
          spiderfyOnMaxZoom={false}
          disableClusteringAtZoom={MAX_ZOOM}
          iconCreateFunction={createClusterIcon}
        >
          {visiblePois.map((poi, i) => (
            <Marker
              key={poi.id ?? `${poi.position[0]},${poi.position[1]}`}
              position={[poi.position[0], poi.position[1]]}
              icon={poiIcons[i]}
              eventHandlers={{
                click: () => setSelectedPoiId(poi.id ?? null),
              }}
            />
          ))}
        </MarkerClusterGroup>
        {selectedPoi && selectedIcon && (
          <SelectedPoiLayer
            poi={selectedPoi}
            icon={selectedIcon}
            topReserved={headerHeight}
            onClose={() => clearSelectedPoi(selectedPoi.id)}
          />
        )}
      </MapContainer>
    </div>
  );
};
