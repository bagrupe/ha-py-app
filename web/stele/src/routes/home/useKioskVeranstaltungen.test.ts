import {describe, expect, it} from 'vitest';

import {mapVeranstaltungsTerminToEvent} from './useKioskVeranstaltungen';

// 2026-05-21T22:30Z = 2026-05-22 00:30 Europe/Berlin (CEST, UTC+2).
const cestEventDoc = {
  id: 'evt-cest',
  titel: 'Konzert nach Mitternacht',
  teaser: 'Open-air event that starts right after midnight Berlin time.',
  start: '2026-05-21T22:30:00.000Z',
  end: '2026-05-22T00:00:00.000Z',
  dates: [{start: '2026-05-21T22:30:00.000Z', end: '2026-05-22T00:00:00.000Z'}],
  titelbild: null,
  category: [],
  locationName: 'Bürgergarten',
  veranstalterAdresse: null,
};

// 2026-01-15T23:30Z = 2026-01-16 00:30 Europe/Berlin (CET, UTC+1).
const cetEventDoc = {
  id: 'evt-cet',
  titel: 'Neujahrslesung',
  teaser: 'Just after midnight in January (CET, UTC+1).',
  start: '2026-01-15T23:30:00.000Z',
  end: '2026-01-16T01:00:00.000Z',
  dates: [{start: '2026-01-15T23:30:00.000Z', end: '2026-01-16T01:00:00.000Z'}],
  titelbild: null,
  category: [],
  locationName: 'Stadtbibliothek',
  veranstalterAdresse: null,
};

const farFuture = Date.UTC(2027, 0, 1);

describe('mapVeranstaltungsTerminToEvent (Europe/Berlin display)', () => {
  it('renders a CEST event with Europe/Berlin wall-clock time', () => {
    const event = mapVeranstaltungsTerminToEvent(
      cestEventDoc as Parameters<typeof mapVeranstaltungsTerminToEvent>[0],
      farFuture,
    );

    expect(event.termin.timeRange).toBe('00:30 - 02:00 Uhr');
    expect(event.termin.dateRange).toBe('Fr., 22.05.2026');
    expect(event.date).toBe('22. Mai 2026');
  });

  it('renders a CET event with Europe/Berlin wall-clock time', () => {
    const event = mapVeranstaltungsTerminToEvent(
      cetEventDoc as Parameters<typeof mapVeranstaltungsTerminToEvent>[0],
      farFuture,
    );

    expect(event.termin.timeRange).toBe('00:30 - 02:00 Uhr');
    expect(event.termin.dateRange).toBe('Fr., 16.01.2026');
    expect(event.date).toBe('16. Januar 2026');
  });
});
