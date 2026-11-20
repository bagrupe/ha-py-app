import { describe, it, expect } from 'vitest'
import type { CollectionConfig } from 'payload'
import { kommuneField, hasKommuneField } from './kommune'

describe('hasKommuneField', () => {
  it('returns true when kommune relationship field present', () => {
    const config = {
      slug: 'test',
      fields: [{ name: 'kommune', type: 'relationship', relationTo: 'kommunen' }],
    } as CollectionConfig
    expect(hasKommuneField(config)).toBe(true)
  })

  it('returns false when no kommune field', () => {
    const config = {
      slug: 'test',
      fields: [{ name: 'title', type: 'text' }],
    } as CollectionConfig
    expect(hasKommuneField(config)).toBe(false)
  })

  it('returns false when field named kommune but wrong type', () => {
    const config = {
      slug: 'test',
      fields: [{ name: 'kommune', type: 'text' }],
    } as CollectionConfig
    expect(hasKommuneField(config)).toBe(false)
  })
})

describe('kommuneField beforeValidate hook', () => {
  const field = kommuneField()
  const hook = field.hooks!.beforeValidate![0]

  it('auto-fills kommune on create when user has kommune and value is null', () => {
    const result = hook({
      req: { user: { kommune: 'k-1' } },
      value: null,
      operation: 'create',
    } as never)
    expect(result).toBe('k-1')
  })

  it('preserves existing value on create', () => {
    const result = hook({
      req: { user: { kommune: 'k-1' } },
      value: 'k-existing',
      operation: 'create',
    } as never)
    expect(result).toBeUndefined() // hook returns undefined (falls through), value preserved by Payload
  })

  it('does not modify on update operation', () => {
    const result = hook({
      req: { user: { kommune: 'k-1' } },
      value: null,
      operation: 'update',
    } as never)
    expect(result).toBeNull()
  })

  it('returns value when user has no kommune', () => {
    const result = hook({
      req: { user: { kommune: null } },
      value: 'k-existing',
      operation: 'create',
    } as never)
    expect(result).toBe('k-existing')
  })

  it('returns value when no user', () => {
    const result = hook({
      req: { user: null },
      value: 'k-existing',
      operation: 'create',
    } as never)
    expect(result).toBe('k-existing')
  })
})
