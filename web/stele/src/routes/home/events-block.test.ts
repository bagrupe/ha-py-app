import {describe, expect, it} from 'vitest';
import {findGemeindeIdByName} from './events-block';

const gemeinden = [
  {id: 'hameln-id', label: 'Hameln'},
  {id: 'bad-pyrmont-id', label: 'Bad Pyrmont'},
];

describe('findGemeindeIdByName', () => {
  it('matches a Gemeinde name case-insensitively', () => {
    expect(findGemeindeIdByName(gemeinden, 'hameln')).toBe('hameln-id');
    expect(findGemeindeIdByName(gemeinden, 'bad pyrmont')).toBe(
      'bad-pyrmont-id',
    );
  });

  it('returns undefined when no Gemeinde matches', () => {
    expect(findGemeindeIdByName(gemeinden, 'aerzen')).toBeUndefined();
  });

  it('returns undefined for an empty Gemeinde list', () => {
    expect(findGemeindeIdByName([], 'hameln')).toBeUndefined();
  });
});
