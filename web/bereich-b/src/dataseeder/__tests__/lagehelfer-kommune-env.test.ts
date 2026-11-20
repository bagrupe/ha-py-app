import { describe, expect, it } from 'vitest'

import { resolveLageHelferKommuneFromEnv } from '../seed-lagehelfer'

describe('resolveLageHelferKommuneFromEnv', () => {
  it('reads required kommune fields from env', () => {
    const result = resolveLageHelferKommuneFromEnv({
      LAGEHELFER_KOMMUNE_ID: '84a06067-dc9e-46d0-b60a-8258cf7c1ce7',
      LAGEHELFER_KOMMUNE_NAME: 'Kooperative Regionalleitstelle Weserbergland',
    })

    expect(result.bereichAId).toBe('84a06067-dc9e-46d0-b60a-8258cf7c1ce7')
    expect(result.name).toBe('Kooperative Regionalleitstelle Weserbergland')
    expect(result.regionalschluessel).toBe('03252')
    expect(result.defaultPosition).toEqual([51.9786, 9.4264])
  })

  it('parses optional overrides', () => {
    const result = resolveLageHelferKommuneFromEnv({
      LAGEHELFER_KOMMUNE_ID: '11111111-2222-3333-4444-555555555551',
      LAGEHELFER_KOMMUNE_NAME: 'Musterkreis',
      LAGEHELFER_REGIONALSCHLUESSEL: '99999',
      LAGEHELFER_DEFAULT_POSITION: '52.1,9.5',
    })

    expect(result.regionalschluessel).toBe('99999')
    expect(result.defaultPosition).toEqual([52.1, 9.5])
  })

  it('throws when kommune id is missing', () => {
    expect(() =>
      resolveLageHelferKommuneFromEnv({
        LAGEHELFER_KOMMUNE_NAME: 'x',
      }),
    ).toThrow(/LAGEHELFER_KOMMUNE_ID/)
  })
})
