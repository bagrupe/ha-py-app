import poiBackground from './assets/Visual/poi.jpg';

const fallbackAktuellesNewsLimit = 10;
const configuredAktuellesNewsLimit = Number(
  import.meta.env.VITE_AKTUELLES_NEWS_LIMIT,
);
const aktuellesNewsLimit =
  Number.isFinite(configuredAktuellesNewsLimit) &&
  configuredAktuellesNewsLimit > 0
    ? configuredAktuellesNewsLimit
    : fallbackAktuellesNewsLimit;

const untereinheitenIds = (import.meta.env.VITE_UNTEREINHEITEN_IDS ?? '')
  .split(',')
  .map((id) => id.trim())
  .filter((id) => id.length > 0);

const aufrufeQrEnabled =
  (import.meta.env.VITE_AUFRUFE_QR_ENABLED ?? '').toLowerCase() === 'true';

const showPoiMap =
  (import.meta.env.VITE_SHOW_POI_MAP ?? '').toLowerCase() === 'true';

const poiMapCardImage =
  (import.meta.env.VITE_POI_MAP_CARD_IMAGE ?? '').trim() || poiBackground;

export const STELE_CONFIG: {
  kommuneId: string;
  untereinheitenIds: string[];
  aktuellesNewsLimit: number;
  aufrufeQrEnabled: boolean;
  showPoiMap: boolean;
  poiMapCardImage: string;
} = {
  kommuneId: import.meta.env.VITE_KOMMUNE_ID ?? '',
  untereinheitenIds,
  aktuellesNewsLimit,
  aufrufeQrEnabled,
  showPoiMap,
  poiMapCardImage,
};
