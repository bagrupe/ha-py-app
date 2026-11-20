import { describe, expect, it } from 'vitest'

import boundaries from '../import-veranstaltungen/data/osm-grenzen.json'
import { getBundledBoundary } from '../import-veranstaltungen/utils/bundled-boundaries'

describe('bundled boundaries', () => {
  it('exposes every entry of the data file by regional key', () => {
    for (const entry of boundaries) {
      expect(getBundledBoundary(entry.regionalschluessel)?.regionalschluessel).toBe(
        entry.regionalschluessel,
      )
    }
  })

  it('returns nothing for a key that is not bundled', () => {
    expect(getBundledBoundary('does-not-exist')).toBeUndefined()
  })

  it('gives every entry its own stable sha256 hash', () => {
    const hashes = boundaries.map((entry) => getBundledBoundary(entry.regionalschluessel)!.hash)

    expect(hashes.every((hash) => /^[0-9a-f]{64}$/.test(hash))).toBe(true)
    expect(new Set(hashes).size).toBe(boundaries.length)
    expect(getBundledBoundary(boundaries[0].regionalschluessel)!.hash).toBe(hashes[0])
  })
})
