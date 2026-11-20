import { describe, expect, test } from 'vitest'
import { computeUpsertedFelder, type SensorData } from '../import-sensoren'

const entry = (deviceData: Record<string, unknown>): SensorData => ({
  timestamp: '2026-09-02T09:00:00.000Z',
  device_name: 'DL-CWS2-1-Pyrmont',
  landkreisapp: 'Glättemeldeanlage Hagener Berg',
  device_data: deviceData,
})

describe('computeUpsertedFelder', () => {
  test('adds numeric device_data fields as before', () => {
    const result = computeUpsertedFelder(
      [entry({ air_temperature_mean: 3.2, humidity_mean: 88 })],
      [],
    )

    expect(result.map((f) => f.name).sort()).toEqual(['air_temperature_mean', 'humidity_mean'])
  })

  test('preserves an existing numeric field, including its werteart, across a re-import', () => {
    const knownFelder = [{ name: 'air_temperature_mean', werteart: 'temperatur-id' }]

    const result = computeUpsertedFelder([entry({ air_temperature_mean: 3.2 })], knownFelder)

    expect(result).toEqual([{ name: 'air_temperature_mean', werteart: 'temperatur-id' }])
  })

  test('keeps the manually sorted order and appends new fields at the end', () => {
    const knownFelder = [
      { name: 'surface_temperature_mean', werteart: 'glaette-id' },
      { name: 'air_temperature_mean', werteart: 'temperatur-id' },
    ]

    const result = computeUpsertedFelder(
      [
        entry({
          air_temperature_mean: 3.2,
          battery_voltage_mean: 3.6,
          surface_temperature_mean: 1.1,
        }),
      ],
      knownFelder,
    )

    expect(result.map((f) => f.name)).toEqual([
      'surface_temperature_mean',
      'air_temperature_mean',
      'battery_voltage_mean',
    ])
  })

  test('keeps a known field and its werteart when it is missing from the result', () => {
    const knownFelder = [{ name: 'humidity_mean', werteart: 'luftfeuchtigkeit-id' }]

    const result = computeUpsertedFelder([entry({ air_temperature_mean: 3.2 })], knownFelder)

    expect(result).toEqual([
      { name: 'humidity_mean', werteart: 'luftfeuchtigkeit-id' },
      { name: 'air_temperature_mean' },
    ])
  })

  test('preserves the categorical alarm_level_last field and its werteart across a re-import', () => {
    const knownFelder = [{ name: 'alarm_level_last', werteart: 'glaette-id' }]

    const result = computeUpsertedFelder(
      [entry({ alarm_level_last: 'SAFE', air_temperature_mean: 3.2 })],
      knownFelder,
    )

    expect(result).toContainEqual({ name: 'alarm_level_last', werteart: 'glaette-id' })
    expect(result).toContainEqual({ name: 'air_temperature_mean' })
  })

  test('does not treat an arbitrary non-numeric field as a sensor field', () => {
    const result = computeUpsertedFelder(
      [entry({ location_description: 'near the bridge', air_temperature_mean: 3.2 })],
      [],
    )

    expect(result.map((f) => f.name)).toEqual(['air_temperature_mean'])
  })
})
