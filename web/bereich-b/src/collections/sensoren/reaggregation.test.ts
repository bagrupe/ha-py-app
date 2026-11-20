import { Temporal } from 'temporal-polyfill'
import { describe, test, expect } from 'vitest'
import {
  type AggregationType,
  type TimeSeriesAggregation,
  findInterval,
  reaggregateRaw,
  reaggregateSeries,
} from './reaggregation'

describe(findInterval.name, () => {
  const round = (iso: string, interval: string): string => {
    const dt = Temporal.Instant.from(iso)
    const dur = Temporal.Duration.from(interval)
    return findInterval(dt, dur).toString()
  }

  test('rounds to next 10-minute boundary', () => {
    expect(round('2024-01-01T00:00:00Z', 'PT10M')).toBe('2024-01-01T00:00:00Z')
    expect(round('2024-01-01T00:00:01Z', 'PT10M')).toBe('2024-01-01T00:10:00Z')
    expect(round('2024-01-01T00:09:59Z', 'PT10M')).toBe('2024-01-01T00:10:00Z')
    expect(round('2024-01-01T00:10:00Z', 'PT10M')).toBe('2024-01-01T00:10:00Z')
    expect(round('2024-01-01T00:10:01Z', 'PT10M')).toBe('2024-01-01T00:20:00Z')
  })
})

describe(reaggregateRaw.name, () => {
  test.each([
    ['min', [5, 3, 9], 3],
    ['max', [1, 8, 4], 8],
    ['first', [7, 2, 9], 7],
    ['last', [4, 6, 1], 1],
  ] as [AggregationType, number[], number][])('aggregates type "%s"', (type, values, expected) => {
    const points = values.map((value, i) => ({
      value,
      timestamp: Temporal.Instant.from(`2024-01-01T00:0${i}:00Z`),
      aggregationInterval: Temporal.Duration.from({ minutes: 10 }),
    }))
    expect(reaggregateRaw(type, points)).toBe(expected)
  })

  test('computes weighted mean', () => {
    const points: TimeSeriesAggregation[] = [
      {
        timestamp: Temporal.Instant.from('2024-01-01T00:00:00Z'),
        aggregationInterval: Temporal.Duration.from({ minutes: 10 }),
        value: 2,
      },
      {
        timestamp: Temporal.Instant.from('2024-01-01T00:10:00Z'),
        aggregationInterval: Temporal.Duration.from({ minutes: 20 }),
        value: 4,
      },
      {
        timestamp: Temporal.Instant.from('2024-01-01T00:30:00Z'),
        aggregationInterval: Temporal.Duration.from({ minutes: 30 }),
        value: 6,
      },
    ]

    // (2×10 + 4×20 + 6×30) / (10+20+30) = (20 + 80 + 180) / 60 = 280 / 60 = 4.666...
    expect(reaggregateRaw('mean', points)).toBeCloseTo(4.6666, 3)
  })

  test('returns 0 for mean if total weight is 0', () => {
    const points: TimeSeriesAggregation[] = [
      {
        value: 5,
        timestamp: Temporal.Instant.from('2024-01-01T00:00:00Z'),
        aggregationInterval: Temporal.Duration.from('PT0M'),
      },
    ]

    expect(reaggregateRaw('mean', points)).toBe(0)
  })

  test('returns 0 on empty input', () => {
    expect(reaggregateRaw('mean', [])).toBe(0)
    expect(reaggregateRaw('first', [])).toBe(0)
    expect(reaggregateRaw('last', [])).toBe(0)
    expect(reaggregateRaw('min', [])).toBe(Number.POSITIVE_INFINITY) // Math.min(...[]) = ∞
    expect(reaggregateRaw('max', [])).toBe(Number.NEGATIVE_INFINITY) // Math.max(...[]) = -∞
  })
})

describe(reaggregateSeries.name, () => {
  test('fills missing buckets with 0', () => {
    const tenMin = Temporal.Duration.from('PT10M')
    const oneHour = Temporal.Duration.from('PT1H')

    const points: TimeSeriesAggregation[] = [
      {
        timestamp: Temporal.Instant.from('2024-01-01T00:10:00Z'),
        aggregationInterval: tenMin,
        value: 2,
      },
      {
        timestamp: Temporal.Instant.from('2024-01-01T02:10:00Z'),
        aggregationInterval: tenMin,
        value: 3,
      },
    ]

    const result = reaggregateSeries(points, oneHour, 'mean')

    expect(result).toEqual([
      {
        timestamp: Temporal.Instant.from('2024-01-01T01:00:00Z'),
        value: 2,
      },
      {
        timestamp: Temporal.Instant.from('2024-01-01T02:00:00Z'),
        value: 0,
      },
      {
        timestamp: Temporal.Instant.from('2024-01-01T03:00:00Z'),
        value: 3,
      },
    ])
  })
})
