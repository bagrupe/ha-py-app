import type { ArrayField, Field, FieldHook, PayloadRequest, TextField } from 'payload'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { getSensorCurrentValueLoader } from './dataloader'
import { deriveShownInApp, rejectFelderSetChangesByEditors, Sensoren } from './sensoren'

vi.mock('./dataloader', async (importOriginal) => ({
  ...(await importOriginal<typeof import('./dataloader')>()),
  getSensorCurrentValueLoader: vi.fn(),
}))

describe('deriveShownInApp', () => {
  it.each([
    {
      name: 'unconfirmed watermark update',
      data: { ausstehendeGefahrenstufe: 'ROT' },
    },
    {
      name: 'confirmed watermark update',
      data: {
        letzteBenachrichtigteGefahrenstufe: 'ROT',
        ausstehendeGefahrenstufe: 'ROT',
      },
    },
    {
      name: 'arbitrary partial update',
      data: { titel: 'Aktualisierter Titel' },
    },
  ])('preserves shownInApp for a $name without felder', ({ data }) => {
    expect(
      deriveShownInApp({
        data,
        originalDoc: { shownInApp: true },
      } as never),
    ).toBe(true)
  })

  it('preserves a false shownInApp value when felder is omitted', () => {
    expect(
      deriveShownInApp({
        data: { titel: 'Aktualisierter Titel' },
        originalDoc: { shownInApp: false },
      } as never),
    ).toBe(false)
  })

  it('defaults to false without felder or an existing document', () => {
    expect(deriveShownInApp({ data: { titel: 'Neuer Sensor' } } as never)).toBe(false)
  })

  it('sets shownInApp to true when an explicitly provided field has a werteart', () => {
    expect(
      deriveShownInApp({
        data: {
          felder: [
            { name: 'temperature', werteart: null },
            { name: 'water_level_last', werteart: 'sensor-art-1' },
          ],
        },
        originalDoc: { shownInApp: false },
      } as never),
    ).toBe(true)
  })

  it('sets shownInApp to false when explicitly provided fields have no werteart', () => {
    expect(
      deriveShownInApp({
        data: { felder: [{ name: 'temperature', werteart: null }] },
        originalDoc: { shownInApp: true },
      } as never),
    ).toBe(false)
  })

  it('sets shownInApp to false when an empty field list is explicitly provided', () => {
    expect(
      deriveShownInApp({
        data: { felder: [] },
        originalDoc: { shownInApp: true },
      } as never),
    ).toBe(false)
  })
})

describe('felder.currentValue', () => {
  const findField = <T extends Field>(fields: Field[], name: string) =>
    fields.find((field) => 'name' in field && field.name === name) as T
  const felder = findField<ArrayField>(Sensoren.fields, 'felder')
  const currentValue = findField<TextField>(felder.fields, 'currentValue')
  const readCurrentValue = currentValue.hooks!.afterRead![0] as FieldHook

  const load = vi.fn()

  beforeEach(() => {
    load.mockReset().mockResolvedValue('18.6')
    vi.mocked(getSensorCurrentValueLoader).mockReturnValue({ load } as never)
  })

  const read = (req: Partial<PayloadRequest>) =>
    readCurrentValue({
      data: { name: 'Elsys-ELT2-10m-2-BadPyrmont' },
      siblingData: { name: 'temperature_mean' },
      req,
    } as never)

  it('resolves the value for REST and GraphQL reads', async () => {
    await expect(read({ payloadAPI: 'REST', user: null })).resolves.toBe('18.6')
  })

  it('resolves the value for the admin edit view', async () => {
    await expect(
      read({ payloadAPI: 'local', user: { id: 'admin', collection: 'benutzer' } } as never),
    ).resolves.toBe('18.6')
    expect(load).toHaveBeenCalledWith(['Elsys-ELT2-10m-2-BadPyrmont', 'temperature_mean'])
  })

  it('skips the sensor database for system Local API calls such as the import cron', async () => {
    await expect(read({ payloadAPI: 'local', user: null })).resolves.toBe('')
    expect(load).not.toHaveBeenCalled()
  })
})

describe('rejectFelderSetChangesByEditors', () => {
  const editor = { user: { id: 'admin', collection: 'benutzer' } }
  const stored = [{ name: 'temperature' }, { name: 'humidity' }, { name: 'pressure' }]

  const run = (value: unknown, req: Partial<PayloadRequest>) =>
    rejectFelderSetChangesByEditors({ value, previousValue: stored, req } as never)

  it('lets editors reorder felder', () => {
    const reordered = [stored[2], stored[0], stored[1]]
    expect(run(reordered, editor as never)).toBe(reordered)
  })

  it.each([
    { change: 'added', value: [...stored, { name: 'battery' }] },
    { change: 'removed', value: stored.slice(1) },
    { change: 'duplicated', value: [...stored.slice(0, 2), stored[0]] },
  ])('rejects felder an editor $change', ({ value }) => {
    expect(() => run(value, editor as never)).toThrow()
  })

  it('lets the import append new felder', () => {
    const imported = [...stored, { name: 'battery' }]
    expect(run(imported, { user: null })).toBe(imported)
  })
})
