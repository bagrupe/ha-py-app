import { Temporal } from 'temporal-polyfill'

/**
 * Mögliche Typen von Aggregationen für Zeitreihen-Daten.
 */
export type AggregationType = 'min' | 'max' | 'first' | 'last' | 'mean'

/**
 * Struktur eines Zeitreihen-Datenpunkts.
 */
export type TimeSeriesAggregation = {
  /** Zeitpunkt des Datenpunkts. */
  timestamp: Temporal.Instant
  /** Aggregationsintervall des Datenpunkts. */
  aggregationInterval: Temporal.Duration
  /** Wert des Datenpunkts. */
  value: number
}

/**
 * Aggregiert Zeitreihen-Daten mit einem neuen Zielintervall und Aggregationstyp.
 *
 * @param data - Ein Array von Zeitreihen-Datenpunkten.
 * @param targetInterval - Ziel-Intervall, in dem die Daten neu aggregiert werden sollen.
 * @param type - Der Typ der Aggregation (z. B. 'min', 'max', 'mean').
 * @returns Eine Liste aggregierter Zeitpunkte und Werte.
 */
export const reaggregateSeries = (
  data: TimeSeriesAggregation[],
  targetInterval: Temporal.Duration,
  type: AggregationType,
): { timestamp: Temporal.Instant; value: number }[] => {
  if (data.length === 0) return []

  const buckets = new Map<string, TimeSeriesAggregation[]>()

  const timestamps = data.map((d) => d.timestamp)
  const start = findInterval(
    Temporal.Instant.fromEpochMilliseconds(Math.min(...timestamps.map((t) => t.epochMilliseconds))),
    targetInterval,
  )
  const end = findInterval(
    Temporal.Instant.fromEpochMilliseconds(Math.max(...timestamps.map((t) => t.epochMilliseconds))),
    targetInterval,
  )

  for (const point of data) {
    const bucketInstant = findInterval(point.timestamp, targetInterval)
    const key = bucketInstant.toString()
    if (!buckets.has(key)) buckets.set(key, [])
    buckets.get(key)!.push(point)
  }

  const results: { timestamp: Temporal.Instant; value: number }[] = []
  let cursor = start

  while (Temporal.Instant.compare(cursor, end) <= 0) {
    const key = cursor.toString()
    const bucketPoints = buckets.get(key) ?? []
    const value = bucketPoints.length > 0 ? reaggregateRaw(type, bucketPoints) : 0

    results.push({ timestamp: cursor, value })
    cursor = cursor.add(targetInterval)
  }

  return results
}

/**
 * Führt die grundlegende Aggregation von Datenpunkten gemäß dem Aggregationstyp aus.
 *
 * @param type - Der Typ der Aggregation (z. B. 'min', 'max', 'mean').
 * @param points - Liste von Zeitreihen-Datenpunkten innerhalb eines Intervalls.
 * @returns Der aggregierte Wert.
 */
export const reaggregateRaw = (type: AggregationType, points: TimeSeriesAggregation[]): number => {
  const sorted = [...points].sort((a, b) => Temporal.Instant.compare(a.timestamp, b.timestamp))

  switch (type) {
    case 'min':
      return Math.min(...points.map((p) => p.value))
    case 'max':
      return Math.max(...points.map((p) => p.value))
    case 'first':
      return sorted[0]?.value ?? 0
    case 'last':
      return sorted[sorted.length - 1]?.value ?? 0
    case 'mean': {
      const weightedSum = points.reduce((sum, p) => {
        const dur = p.aggregationInterval.total({ unit: 'minutes' })
        return sum + p.value * dur
      }, 0)
      const totalWeight = points.reduce(
        (sum, p) => sum + p.aggregationInterval.total({ unit: 'minutes' }),
        0,
      )
      return totalWeight > 0 ? weightedSum / totalWeight : 0
    }
  }
}

/**
 * Rundet einen Zeitstempel auf ein Zielintervall.
 *
 * @param instant - Der ursprüngliche Zeitstempel.
 * @param interval - Das gewünschte Intervall (Dauer), auf das gerundet werden soll.
 * @returns Ein neuer Zeitstempel, der auf das Zielintervall ausgerichtet ist.
 */
export const findInterval = (
  instant: Temporal.Instant,
  interval: Temporal.Duration,
): Temporal.Instant => {
  const intervalMs = interval.total({ unit: 'milliseconds' })
  const instantMs = instant.epochMilliseconds
  const remainderMs = instantMs % intervalMs
  const msToAdd = (intervalMs - remainderMs) % intervalMs
  return instant.add({ milliseconds: msToAdd })
}

/**
 * Sagt einen Aggregationstyp basierend auf einem Schlüssel (z. B. einem Spaltennamen) voraus.
 *
 * @param key - Der Schlüssel, anhand dessen der Aggregationstyp bestimmt wird.
 * @returns Der vorhergesagte Aggregationstyp.
 */
export const inferAggregationType = (key: string): AggregationType => {
  if (key.endsWith('_min')) {
    return 'min'
  } else if (key.endsWith('_max')) {
    return 'max'
  } else if (key.endsWith('_first')) {
    return 'first'
  } else if (key.endsWith('_last')) {
    return 'last'
  }
  return 'mean'
}
