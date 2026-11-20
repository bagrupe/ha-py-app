import {describe, expect, it} from 'vitest';

import {readUrlCoordinates} from './location-context';

const params = (query: string) => new URLSearchParams(query);

describe('readUrlCoordinates', () => {
  it('returns [lat, lng] when both are valid', () => {
    expect(readUrlCoordinates(params('lat=51.986134&lng=9.220473'))).toEqual([
      51.986134, 9.220473,
    ]);
  });

  it('accepts negative coordinates', () => {
    expect(readUrlCoordinates(params('lat=-33.8688&lng=151.2093'))).toEqual([
      -33.8688, 151.2093,
    ]);
  });

  it('accepts zero coordinates (not treated as missing)', () => {
    expect(readUrlCoordinates(params('lat=0&lng=0'))).toEqual([0, 0]);
  });

  it('trims surrounding whitespace before parsing', () => {
    expect(
      readUrlCoordinates(params('lat=%2051.98%20&lng=%209.22%20')),
    ).toEqual([51.98, 9.22]);
  });

  it('returns null when only lat is set', () => {
    expect(readUrlCoordinates(params('lat=51.986134'))).toBeNull();
  });

  it('returns null when only lng is set', () => {
    expect(readUrlCoordinates(params('lng=9.220473'))).toBeNull();
  });

  it('returns null when neither is set', () => {
    expect(readUrlCoordinates(params('location=Bad%20Pyrmont'))).toBeNull();
  });

  it('returns null when a value is empty', () => {
    expect(readUrlCoordinates(params('lat=&lng=9.22'))).toBeNull();
  });

  it('returns null when a value is non-numeric', () => {
    expect(readUrlCoordinates(params('lat=north&lng=9.22'))).toBeNull();
    expect(readUrlCoordinates(params('lat=51.98&lng=east'))).toBeNull();
  });

  it('returns null when lat is out of range', () => {
    expect(readUrlCoordinates(params('lat=91&lng=9.22'))).toBeNull();
    expect(readUrlCoordinates(params('lat=-91&lng=9.22'))).toBeNull();
  });

  it('returns null when lng is out of range', () => {
    expect(readUrlCoordinates(params('lat=51.98&lng=181'))).toBeNull();
    expect(readUrlCoordinates(params('lat=51.98&lng=-181'))).toBeNull();
  });
});
