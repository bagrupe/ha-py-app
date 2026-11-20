import {describe, expect, it} from 'vitest';

import {toDayEndUtcIso, toDayStartUtcIso} from './timeUtils';

describe('Day bounds in Europe/Berlin', () => {
  it('returns Berlin midnight (UTC instant) for a CEST day', () => {
    // 22.05.2026 in Berlin is CEST (UTC+2) → midnight Berlin = 21.05.2026 22:00 UTC.
    expect(toDayStartUtcIso('2026-05-22T00:00:00.000Z')).toBe(
      '2026-05-21T22:00:00.000Z',
    );
  });

  it('returns Berlin end-of-day (UTC instant) for a CEST day', () => {
    expect(toDayEndUtcIso('2026-05-22T00:00:00.000Z')).toBe(
      '2026-05-22T21:59:59.000Z',
    );
  });

  it('returns Berlin midnight (UTC instant) for a CET day', () => {
    // 15.01.2026 in Berlin is CET (UTC+1) → midnight Berlin = 14.01.2026 23:00 UTC.
    expect(toDayStartUtcIso('2026-01-15T00:00:00.000Z')).toBe(
      '2026-01-14T23:00:00.000Z',
    );
  });

  it('returns Berlin end-of-day (UTC instant) for a CET day', () => {
    expect(toDayEndUtcIso('2026-01-15T00:00:00.000Z')).toBe(
      '2026-01-15T22:59:59.000Z',
    );
  });
});
