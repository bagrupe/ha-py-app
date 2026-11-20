import {de} from 'date-fns/locale';
import {formatInTimeZone} from 'date-fns-tz';
import {useMemo} from 'react';

import type {
  EventTermin,
  EventVeranstalter,
} from '../../components/carousel-slide/carousel-slide-veranstaltung';
import {STELE_CONFIG} from '../../config';
import {compact} from '../../utils/arrayUtils';
import {formatLongDate, toDayEndUtcIso} from '../../utils/timeUtils';
import type {KioskVeranstaltungsTermineListQuery} from './veranstaltungen.generated';
import {useKioskVeranstaltungsTermineListQuery} from './veranstaltungen.generated';

const EVENT_LIMIT = 10;
const DISPLAY_TZ = 'Europe/Berlin';

const formatTerminDate = (instant: Date): string =>
  formatInTimeZone(instant, DISPLAY_TZ, 'EE, dd.MM.yyyy', {locale: de});

const formatTerminTime = (instant: Date): string =>
  formatInTimeZone(instant, DISPLAY_TZ, 'HH:mm', {locale: de});

const cetDay = (instant: Date): string =>
  formatInTimeZone(instant, DISPLAY_TZ, 'yyyy-MM-dd');

const isSameCETDay = (start: Date, end: Date) => cetDay(start) === cetDay(end);

export type KioskVeranstaltung = {
  id: string;
  date: string;
  titel: string;
  teaser: string;
  image?: string;
  locationName?: string;
  termin: EventTermin;
  veranstalter: EventVeranstalter;
};

type VeranstaltungsTerminDoc = Exclude<
  NonNullable<
    NonNullable<
      KioskVeranstaltungsTermineListQuery['veranstaltungsTermine']
    >['docs']
  >[number],
  null
>;

const formatTerminDateRange = (
  start?: string | null,
  end?: string | null,
): string => {
  if (!start) return '';
  const startDate = new Date(start);
  if (Number.isNaN(startDate.getTime())) return '';
  if (!end) return formatTerminDate(startDate);

  const endDate = new Date(end);
  if (isSameCETDay(startDate, endDate)) return formatTerminDate(startDate);
  return `${formatTerminDate(startDate)} - ${formatTerminDate(endDate)}`;
};

const formatTerminTimeRange = (
  start?: string | null,
  end?: string | null,
): string => {
  if (!start) return '';
  const startTime = formatTerminTime(new Date(start));
  if (!end) return `${startTime} Uhr`;
  return `${startTime} - ${formatTerminTime(new Date(end))} Uhr`;
};

const resolveTitelbildUrl = (
  doc: VeranstaltungsTerminDoc,
): string | undefined =>
  doc.titelbild?.internal?.url ?? doc.titelbild?.url ?? undefined;

type VeranstaltungsTerminDateEntry = NonNullable<
  NonNullable<VeranstaltungsTerminDoc['dates']>[number]
>;

const isUpcomingTerminDate = (
  entry: VeranstaltungsTerminDateEntry,
  nowMs: number,
): boolean => {
  const reference = entry.end ?? entry.start;
  if (!reference) return false;
  const refMs = new Date(reference).getTime();
  return Number.isFinite(refMs) && refMs >= nowMs;
};

// Joins all upcoming entries from doc.dates[] as a comma-separated string.
// Falls back to the doc's own start/end range when no entries qualify.
const formatUpcomingTermineDateRange = (
  doc: VeranstaltungsTerminDoc,
  nowMs: number,
): string => {
  const upcoming = compact(doc.dates ?? [])
    .filter((d) => isUpcomingTerminDate(d, nowMs))
    .map((d) => formatTerminDateRange(d.start, d.end))
    .filter(Boolean);

  if (upcoming.length > 0) return upcoming.join(', ');
  return formatTerminDateRange(doc.start, doc.end);
};

// Maps a VeranstaltungsTermin document (from the CMS) to a KioskVeranstaltung object.
export const mapVeranstaltungsTerminToEvent = (
  doc: VeranstaltungsTerminDoc,
  nowMs: number,
): KioskVeranstaltung => {
  const adresse = doc.veranstalterAdresse;

  return {
    id: doc.id ?? '',
    date: formatLongDate(doc.start),
    titel: doc.titel ?? '',
    teaser: doc.teaser ?? '',
    image: resolveTitelbildUrl(doc),
    locationName: doc.locationName ?? undefined,
    termin: {
      dateRange: formatUpcomingTermineDateRange(doc, nowMs),
      timeRange: formatTerminTimeRange(doc.start, doc.end),
    },
    veranstalter: {
      name: adresse?.name ?? doc.locationName ?? '',
      street: adresse?.strasse ?? '',
      postalCode: adresse?.plz ?? '',
      city: adresse?.ort ?? '',
      website: adresse?.url ?? undefined,
    },
  };
};

const buildKioskVeranstaltungen = (
  data: KioskVeranstaltungsTermineListQuery | undefined,
): KioskVeranstaltung[] => {
  if (!data?.veranstaltungsTermine?.docs) return [];
  const nowMs = Date.now();
  return compact(data.veranstaltungsTermine.docs).map((doc) =>
    mapVeranstaltungsTerminToEvent(doc, nowMs),
  );
};

// Fetches the newest events belonging to the selected kommune and untereinheiten and returns them as a KioskVeranstaltung objects.
export const useKioskVeranstaltungen = (
  from?: string,
  to?: string,
  categoryIds?: string[],
  untereinheitenIds?: string[],
) => {
  const {kommuneId, untereinheitenIds: configUntereinheitenIds} = STELE_CONFIG;
  // An explicit (user-selected) Gemeinde filter takes precedence over the
  // Stele's configured default scope; an empty selection falls back to it.
  const effectiveUntereinheitenIds =
    untereinheitenIds && untereinheitenIds.length > 0
      ? untereinheitenIds
      : configUntereinheitenIds;

  const [{data, fetching, error}] = useKioskVeranstaltungsTermineListQuery({
    variables: {
      kommune: kommuneId,
      limit: EVENT_LIMIT,
      // Avoid pagination bug
      page: 1,
      // Newest events first.
      sortDirection: 'desc',
      ...(effectiveUntereinheitenIds.length > 0 && {
        untereinheiten: effectiveUntereinheitenIds,
      }),
      // By default, the starting time is the beginning of the day (00:00:00).
      ...(from && {von: from}),
      // Ensure that the end date is at the end of the day (23:59:59).
      ...(to && {bis: toDayEndUtcIso(to)}),
      // No selection = no category filter = all categories.
      ...(categoryIds && categoryIds.length > 0 && {categoryIds}),
    },
    pause: kommuneId === '',
  });

  // Builds the KioskVeranstaltung objects from the server data.
  const events = useMemo(() => buildKioskVeranstaltungen(data), [data]);

  return {events, fetching, error};
};
