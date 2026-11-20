import type { CollectionConfig } from 'payload'
import { describe, expect, it } from 'vitest'
import { SLATE_LEXICAL_CATCHUP_TARGETS } from '../migrations/20260602_101500_slate_lexical_catchup'
import { payloadCollections } from '../payload.config'
import type { SlateToLexicalMigrationTarget } from './slate-to-lexical'

type SchemaBlock = {
  fields: SchemaField[]
  slug: string
}

type SchemaField = {
  blocks?: SchemaBlock[]
  fields?: SchemaField[]
  name?: string
  tabs?: { fields: SchemaField[]; name?: string }[]
  type: string
}

function appendPath(path: string[], name?: string): string[] {
  return name ? [...path, name] : path
}

function containsRichText(fields: SchemaField[]): boolean {
  return fields.some((field) => {
    if (field.type === 'richText') return true
    if (field.type === 'tabs') {
      return field.tabs?.some((tab) => containsRichText(tab.fields)) ?? false
    }
    return field.fields ? containsRichText(field.fields) : false
  })
}

function collectFieldTargets(
  collectionSlug: string,
  fields: SchemaField[],
  path: string[],
): SlateToLexicalMigrationTarget[] {
  return fields.flatMap((field): SlateToLexicalMigrationTarget[] => {
    if (field.type === 'richText') {
      return [{ collectionSlug, field: appendPath(path, field.name).join('.'), type: 'inline' }]
    }

    if (field.type === 'blocks') {
      const blocksWithRichText =
        field.blocks?.filter((block) => containsRichText(block.fields)) ?? []
      const unsupportedBlock = blocksWithRichText.find(
        (block) =>
          block.slug !== 'rich-text' ||
          !block.fields.some(
            (blockField) => blockField.type === 'richText' && blockField.name === 'content',
          ) ||
          block.fields.some(
            (blockField) =>
              (blockField.type === 'richText' && blockField.name !== 'content') ||
              (blockField.type !== 'richText' && containsRichText([blockField])),
          ),
      )
      if (unsupportedBlock) {
        throw new Error(
          `Add migration support for richText fields in ${collectionSlug}.${field.name} block ${unsupportedBlock.slug}`,
        )
      }
      return blocksWithRichText.length > 0
        ? [{ collectionSlug, field: appendPath(path, field.name).join('.'), type: 'block' }]
        : []
    }

    if (field.type === 'array' && field.fields && containsRichText(field.fields)) {
      throw new Error(
        `Add migration support for richText fields in ${collectionSlug}.${field.name} array`,
      )
    }

    if (field.type === 'tabs') {
      return (
        field.tabs?.flatMap((tab) =>
          collectFieldTargets(collectionSlug, tab.fields, appendPath(path, tab.name)),
        ) ?? []
      )
    }

    return field.fields
      ? collectFieldTargets(collectionSlug, field.fields, appendPath(path, field.name))
      : []
  })
}

function collectSchemaTargets(collections: CollectionConfig[]): SlateToLexicalMigrationTarget[] {
  return collections.flatMap((collection) => {
    const targets = collectFieldTargets(collection.slug, collection.fields as SchemaField[], [])
    return collection.versions
      ? [...targets, ...targets.map((target) => ({ ...target, versions: true }))]
      : targets
  })
}

function targetKey(target: SlateToLexicalMigrationTarget): string {
  return `${target.versions ? 'versions' : 'live'}:${target.collectionSlug}.${target.field}:${target.type}`
}

describe('Slate -> Lexical catch-up targets', () => {
  it('covers every configured richText field and version collection', () => {
    expect(SLATE_LEXICAL_CATCHUP_TARGETS.map(targetKey).sort()).toEqual(
      collectSchemaTargets(payloadCollections).map(targetKey).sort(),
    )
  })
})
