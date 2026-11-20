import { type CollectionConfig, traverseFields } from 'payload'
import {
  type Funktionsberechtigung,
  funktionsberechtigungenOf,
} from '../lib/funktionsberechtigungen'

const referencedUploadSlugs = (collection: CollectionConfig): string[] => {
  const slugs = new Set<string>()
  traverseFields({
    fields: collection.fields,
    callback: ({ field }) => {
      if (field.type !== 'upload') return
      for (const slug of [field.relationTo].flat()) slugs.add(slug)
    },
  })
  return [...slugs]
}

export const deriveUploadFunktionsberechtigungen = (
  collections: CollectionConfig[],
): CollectionConfig[] => {
  const derived = new Map<string, Set<Funktionsberechtigung>>()
  for (const collection of collections) {
    if (collection.upload) derived.set(collection.slug, new Set())
  }

  for (const collection of collections) {
    const funktionsberechtigungen = funktionsberechtigungenOf(collection.custom)
    if (!funktionsberechtigungen?.length) continue
    for (const slug of referencedUploadSlugs(collection)) {
      const target = derived.get(slug)
      if (!target) continue
      for (const funktionsberechtigung of funktionsberechtigungen) target.add(funktionsberechtigung)
    }
  }

  return collections.map((collection) => {
    const funktionsberechtigungen = derived.get(collection.slug)
    if (!funktionsberechtigungen) return collection
    return {
      ...collection,
      custom: { ...collection.custom, funktionsberechtigungen: [...funktionsberechtigungen] },
    }
  })
}
