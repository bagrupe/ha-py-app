import * as maplibregl from 'maplibre-gl';
import maplibreWorkerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?worker&url';
import {useEffect, type FC, useId} from 'react';
import MaengelIcon from '../../../../../assets/maengel.svg?raw';
import {SlotValue} from '../../../../../components/ui/slot-value';
import {useKommune} from '../../../../../lib/context/kommune/kommune.tsx';
import {mapTheme} from '../../../../../utils/map-theme.ts';
import 'maplibre-gl/dist/maplibre-gl.css';
import {type AntragDetailAusfuehrung} from '../../detail.generated.ts';

maplibregl.setWorkerUrl(maplibreWorkerUrl);

/**
 * Eigenschaften für die LocationFormularFeld-Komponente.
 * Enthält den Namen des Slots, die Ausführung des Antrags und eine Option zur Darstellung als Karte.
 */
export type LocationFormularFeldProps = {
  slotName: string;
  ausfuehrung: AntragDetailAusfuehrung;
  renderAsMap?: boolean;
};

/**
 * Typ für Standortinformationen mit Adresse und Koordinaten.
 */
type LocationProps = {
  addressString: string;
  coordinates: [lng: number, lat: number];
};

const MAENGELMELDER_TAG = 'Mängelmelder';
const IDEENMELDER_TAG = 'Ideenmelder';

const SVG_NS = 'http://www.w3.org/2000/svg';

/**
 * Bettet ein rohes CMS-Icon-SVG in dieselbe Marker-Grafik ein (Kreis + Pfeilspitze in
 * Orange), die `assets/maengel.svg` für den Mängelmelder bereits fest hinterlegt hat -
 * damit CMS-Icons visuell genauso aussehen wie der statische Mängelmelder-Marker.
 * @param iconSvgMarkup Roher SVG-Inhalt des CMS-Icons (vollständiges `<svg>`-Element).
 * @returns Das zusammengesetzte `<svg>`-Element (Kreis, Pfeilspitze, eingebettetes Icon).
 */
const wrapIconInMarkerSvg = (iconSvgMarkup: string): HTMLElement => {
  const iconDoc = new DOMParser().parseFromString(
    iconSvgMarkup,
    'image/svg+xml',
  );
  const iconRoot = iconDoc.documentElement;

  const marker = document.createElementNS(SVG_NS, 'svg');
  marker.setAttribute('width', '48');
  marker.setAttribute('height', '59');
  marker.setAttribute('viewBox', '0 0 48 59');
  marker.setAttribute('fill', 'none');

  const circle = document.createElementNS(SVG_NS, 'circle');
  circle.setAttribute('cx', '22');
  circle.setAttribute('cy', '22');
  circle.setAttribute('r', '20');
  circle.setAttribute('fill', '#FEE2AA');
  marker.appendChild(circle);

  const pointer = document.createElementNS(SVG_NS, 'path');
  pointer.setAttribute('d', 'M22.5 53L13.4067 37.25L31.5933 37.25L22.5 53Z');
  pointer.setAttribute('fill', '#FEE2AA');
  marker.appendChild(pointer);

  // x/y/width/height auf dem importierten Icon überschreiben, damit es unabhängig von
  // seiner eigenen Originalgröße zentriert und passend in den Kreis eingepasst wird.
  iconRoot.setAttribute('x', '9');
  iconRoot.setAttribute('y', '9');
  iconRoot.setAttribute('width', '26');
  iconRoot.setAttribute('height', '26');
  marker.appendChild(iconRoot);

  return marker as unknown as HTMLElement;
};

/**
 * Komponente zur Darstellung einer Karte mit Marker an gegebenen Koordinaten.
 * Das Marker-Icon richtet sich nach dem Prozess-Tag der Ausführung (Mängelmelder/Ideenmelder
 * bekommen ihr im CMS hochgeladenes Icon, alle anderen Prozesse den statischen Mängel-Fallback).
 * @param coordinates Koordinaten [Längengrad, Breitengrad] für die Kartenmitte und den Marker.
 * @param tags Prozess-Tags der Ausführung, entscheiden über das angezeigte Icon.
 */
const MapComponent: FC<LocationProps & {tags: string[]}> = ({
  coordinates,
  tags,
}) => {
  const idSuffix = useId();
  const {mangelIconUrl, ideenIconUrl} = useKommune();

  const iconUrl = tags.includes(IDEENMELDER_TAG)
    ? ideenIconUrl
    : tags.includes(MAENGELMELDER_TAG)
    ? mangelIconUrl
    : undefined;

  useEffect(() => {
    let cancelled = false;
    let map: maplibregl.Map | undefined;

    const renderMarker = (element: HTMLElement) => {
      if (cancelled) return;

      map = new maplibregl.Map({
        container: `map${idSuffix}`,
        style: mapTheme,
        center: [coordinates[0], coordinates[1]],
        zoom: 14,
        minZoom: 7,
      });
      new maplibregl.Marker({
        element,
        anchor: 'bottom',
      })
        .setLngLat([coordinates[0], coordinates[1]])
        .addTo(map);
    };

    const renderStaticMaengelMarker = () => {
      const doc = new DOMParser().parseFromString(MaengelIcon, 'image/svg+xml');
      renderMarker(doc.documentElement);
    };

    if (iconUrl) {
      // Nur Pfad+Query verwenden, nicht die absolute URL: in Produktion ist der
      // CMS-Host ohnehin derselbe Origin wie Bereich-A, lokal laufen beide aber auf
      // unterschiedlichen Ports (Cross-Origin-Fetch würde an CORS scheitern) - relativ
      // fetchen lässt den Request stattdessen über Bereich-As eigenen /cms-Proxy laufen.
      const relativeIconUrl =
        new URL(iconUrl).pathname + new URL(iconUrl).search;
      fetch(relativeIconUrl)
        .then((res) => res.text())
        .then((iconSvgMarkup) =>
          renderMarker(wrapIconInMarkerSvg(iconSvgMarkup)),
        )
        .catch(renderStaticMaengelMarker);
    } else {
      renderStaticMaengelMarker();
    }

    return () => {
      cancelled = true;
      map?.remove();
    };
    // coordinates ist bei jedem Render ein neues Array - auf Werte statt Referenz prüfen, sonst baut jeder Poll die Karte neu auf.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [idSuffix, coordinates[0], coordinates[1], iconUrl]);

  return (
    <div className='p-4'>
      <div id={`map${idSuffix}`} className='h-96 w-full rounded-md' />
    </div>
  );
};

/**
 * Formularfeld-Komponente zur Anzeige eines Standortwerts.
 * Zeigt entweder die Adresse als Text oder optional eine Karte mit Marker an.
 * @param slotName Name des Slots, dessen Wert angezeigt wird.
 * @param ausfuehrung Daten der Antrag-Ausführung mit Slotwerten.
 * @param renderAsMap Optional, steuert die Darstellung als Karte statt Text.
 */
export const LocationFormularFeld: FC<LocationFormularFeldProps> = ({
  slotName,
  ausfuehrung,
  renderAsMap = false,
}) => {
  const value =
    ausfuehrung.slotValues.find((sv) => sv.slotName === slotName) ?? '';
  const tags = ausfuehrung.prozessVersion.prozess.tags.map((t) => t.tag);

  return (
    <SlotValue<LocationProps> value={value}>
      {(value) =>
        typeof value === 'string' ? (
          value
        ) : renderAsMap ? (
          <MapComponent
            key={ausfuehrung.id}
            addressString={value.addressString}
            coordinates={[value.coordinates[0], value.coordinates[1]]}
            tags={tags}
          />
        ) : (
          <div>{value.addressString}</div>
        )
      }
    </SlotValue>
  );
};
