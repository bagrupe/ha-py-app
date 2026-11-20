import {endOfDay, format, parse, parseISO, startOfDay} from 'date-fns';
import {de} from 'date-fns/locale';
import {formatInTimeZone, fromZonedTime, toZonedTime} from 'date-fns-tz';

const DEFAULT_TZ = 'Europe/Berlin';

export const longDateFormatter = new Intl.DateTimeFormat('de-DE', {
  day: '2-digit',
  month: 'long',
  year: 'numeric',
  timeZone: DEFAULT_TZ,
});

export const weekdayFormatter = new Intl.DateTimeFormat('de-DE', {
  weekday: 'long',
  timeZone: DEFAULT_TZ,
});

export const timeFormatter = new Intl.DateTimeFormat('de-DE', {
  hour: '2-digit',
  minute: '2-digit',
  timeZone: DEFAULT_TZ,
});

export const formatLongDate = (
  value: Date | string | null | undefined,
  tz: string = DEFAULT_TZ,
): string => {
  if (!value) return '';
  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) return '';
  return formatInTimeZone(date, tz, 'dd. MMMM yyyy', {locale: de});
};

/**
 * Opaque day-token: `YYYY-MM-DDT00:00:00.000Z` whose calendar fields match the
 * Date's local Y/M/D. Used as the selected-day identifier in the filter UI.
 */
export const toDayTokenIso = (date: Date): string =>
  `${format(date, 'yyyy-MM-dd')}T00:00:00.000Z`;

/** Returns a local Date at midnight for the token's calendar day, or null. */
export const dayTokenToDate = (token: string): Date | null => {
  if (!token) return null;
  const date = parse(token.slice(0, 10), 'yyyy-MM-dd', new Date());
  return Number.isNaN(date.getTime()) ? null : date;
};

const dayTokenToZonedNoon = (token: string, tz: string): Date | null => {
  if (!token) return null;
  const date = parseISO(token);
  if (Number.isNaN(date.getTime())) return null;
  // Reinterpret the token's UTC calendar fields as a wall-clock time in `tz`.
  return toZonedTime(date, tz);
};

/** UTC instant for `00:00:00 <tz>` on the day-token's calendar day. */
export const toDayStartUtcIso = (
  token: string,
  tz: string = DEFAULT_TZ,
): string => {
  const zoned = dayTokenToZonedNoon(token, tz);
  if (!zoned) return '';
  return fromZonedTime(startOfDay(zoned), tz).toISOString();
};

/** UTC instant for `23:59:59 <tz>` on the day-token's calendar day. */
export const toDayEndUtcIso = (
  token: string,
  tz: string = DEFAULT_TZ,
): string => {
  const zoned = dayTokenToZonedNoon(token, tz);
  if (!zoned) return '';
  const utc = fromZonedTime(endOfDay(zoned), tz);
  utc.setUTCMilliseconds(0);
  return utc.toISOString();
};

export const dayLabel = (date: Date, offset: number) => {
  if (offset === 0) return 'Heute';
  if (offset === 1) return 'Morgen';
  return formatInTimeZone(date, DEFAULT_TZ, 'EEEE', {locale: de});
};
