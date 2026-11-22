/** @vitest-environment jsdom */
import {act, renderHook} from '@testing-library/react';
import {afterEach, beforeEach, describe, expect, it, vi} from 'vitest';
import {useNeueMeldungen} from './use-lage-dashboard.ts';

const ids = (...list: string[]) => list.map((id) => ({id}));

describe('useNeueMeldungen', () => {
  beforeEach(() => vi.useFakeTimers());
  afterEach(() => vi.useRealTimers());

  it('does not flag the first load, only later arrivals, and clears them again', () => {
    const {result, rerender} = renderHook(
      ({meldungen, bereit}) => useNeueMeldungen(meldungen, bereit, 3_000),
      {initialProps: {meldungen: ids(), bereit: false}},
    );

    rerender({meldungen: ids('a', 'b'), bereit: true});
    expect([...result.current]).toEqual([]);

    rerender({meldungen: ids('a', 'b', 'c'), bereit: true});
    expect([...result.current]).toEqual(['c']);

    act(() => void vi.advanceTimersByTime(3_000));
    expect([...result.current]).toEqual([]);
  });

  it('does not flag a report again when it was already known', () => {
    const {result, rerender} = renderHook(
      ({meldungen}) => useNeueMeldungen(meldungen, true, 3_000),
      {initialProps: {meldungen: ids('a')}},
    );

    rerender({meldungen: ids('a', 'b')});
    act(() => void vi.advanceTimersByTime(3_000));
    rerender({meldungen: ids('a', 'b')});

    expect([...result.current]).toEqual([]);
  });
});
