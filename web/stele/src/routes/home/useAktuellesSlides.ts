import {useMemo} from 'react';

import {Aufrufe_QrCode_Type} from '../../__generated__/graphql';
import {STELE_CONFIG} from '../../config';
import {compact} from '../../utils/arrayUtils';
import {formatLongDate} from '../../utils/timeUtils';
import type {
  Aufrufe_Where,
  NewsArtikel_Where,
  SteleAktuellesQuery,
  SteleAufrufInfoFragment,
  SteleNewsArtikelInfoFragment,
} from './aktuelles.generated';
import {useSteleAktuellesQuery} from './aktuelles.generated';

const TOP_THEMA_ORDINAL = 10;

const buildAufrufeWhere = (
  kommuneId: string,
  untereinheitenIds: string[],
): Aufrufe_Where => ({
  kommune: {equals: kommuneId},
  ...(untereinheitenIds.length > 0 && {
    untereinheit: {in: [null, ...untereinheitenIds]},
  }),
});

const buildNewsWhere = (
  kommuneId: string,
  untereinheitenIds: string[],
  ordinal: {equals: number} | {not_equals: number},
): NewsArtikel_Where => ({
  kommune: {equals: kommuneId},
  ordinal,
  ...(untereinheitenIds.length > 0 && {
    untereinheit: {in: [null, ...untereinheitenIds]},
  }),
});

export type AktuellesSlide = {
  id: string;
  kind: 'aufruf' | 'news';
  date: string;
  location: string;
  headline: string;
  subHeadline: string;
  body: string;
  image?: string;
  imageFallback?: string;
  qrCodeSrc?: string;
  ribbon?: string;
};

const resolveKommuneFallback = (
  doc: SteleAufrufInfoFragment | SteleNewsArtikelInfoFragment,
): string | undefined => {
  const img = doc.kommune?.design?.fallbackImage;
  return img?.sizes?.thumbnail?.url ?? img?.url ?? undefined;
};

const resolveLocation = (
  untereinheit: {name?: string} | null | undefined,
  kommune: {name?: string} | null | undefined,
): string => untereinheit?.name ?? kommune?.name ?? '';

const resolveAufrufImage = (doc: SteleAufrufInfoFragment): string | undefined =>
  doc.bild?.internal?.sizes?.thumbnail?.url ??
  doc.bild?.internal?.url ??
  doc.bild?.url ??
  doc.fallbackBildUrl ??
  undefined;

const resolveAufrufQrSrc = (
  doc: SteleAufrufInfoFragment,
  qrEnabled: boolean,
): string | undefined => {
  if (!qrEnabled) return undefined;
  const type = doc.qrCode?.type;
  if (!type || type === Aufrufe_QrCode_Type.None) return undefined;
  return doc.qrCodeUrl ?? undefined;
};

const mapAufrufToSlide = (
  doc: SteleAufrufInfoFragment,
  options: {qrEnabled: boolean},
): AktuellesSlide => ({
  id: doc.id ?? '',
  kind: 'aufruf',
  date: formatLongDate(doc.startDatum),
  location: resolveLocation(doc.untereinheit, doc.kommune),
  headline: doc.titel,
  subHeadline: doc.teaser ?? '',
  body: doc.beschreibungText ?? '',
  image: resolveAufrufImage(doc),
  imageFallback: resolveKommuneFallback(doc),
  qrCodeSrc: resolveAufrufQrSrc(doc, options.qrEnabled),
  ribbon: doc.aufrufende || undefined,
});

const resolveNewsImage = (
  doc: SteleNewsArtikelInfoFragment,
): string | undefined => {
  const bild = doc.titelbilder?.[0]?.bild;
  return (
    bild?.sizes?.thumbnail?.url ?? bild?.url ?? resolveKommuneFallback(doc)
  );
};

const mapNewsArtikelToSlide = (
  doc: SteleNewsArtikelInfoFragment,
): AktuellesSlide => ({
  id: doc.id ?? '',
  kind: 'news',
  date: formatLongDate(doc.datum),
  location: resolveLocation(doc.untereinheit, doc.kommune),
  headline: doc.titel ?? '',
  subHeadline: doc.teaser ?? '',
  body: doc.bodyPlaintext ?? '',
  image: resolveNewsImage(doc),
  imageFallback: resolveKommuneFallback(doc),
});

const buildAktuellesSlides = (
  data: SteleAktuellesQuery | undefined,
  options: {qrEnabled: boolean},
): AktuellesSlide[] => {
  if (!data) return [];
  const aufrufeSlides = compact(data.aufrufeList?.docs).map((doc) =>
    mapAufrufToSlide(doc, options),
  );
  const topThemaSlides = compact(data.topThemaNewsArtikelList?.docs).map(
    mapNewsArtikelToSlide,
  );
  const newsSlides = compact(data.newsArtikelList?.docs).map(
    mapNewsArtikelToSlide,
  );
  return [...aufrufeSlides, ...topThemaSlides, ...newsSlides];
};

export const useAktuellesSlides = () => {
  const {kommuneId, untereinheitenIds, aktuellesNewsLimit} = STELE_CONFIG;
  const [{data, fetching, error}] = useSteleAktuellesQuery({
    variables: {
      aufrufeWhere: buildAufrufeWhere(kommuneId, untereinheitenIds),
      topThemaWhere: buildNewsWhere(kommuneId, untereinheitenIds, {
        equals: TOP_THEMA_ORDINAL,
      }),
      newsWhere: buildNewsWhere(kommuneId, untereinheitenIds, {
        not_equals: TOP_THEMA_ORDINAL,
      }),
      newsLimit: aktuellesNewsLimit,
    },
    pause: kommuneId === '',
  });

  const slides = useMemo(
    () =>
      buildAktuellesSlides(data, {qrEnabled: STELE_CONFIG.aufrufeQrEnabled}),
    [data],
  );

  return {slides, fetching, error};
};
