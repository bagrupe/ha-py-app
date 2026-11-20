import { describe, it, expect, vi } from 'vitest'

// Verhindert, dass der Import-Graph der News-Integrationen die echte payload.config lädt.
vi.mock('@payload-config', () => ({ default: Promise.resolve({}) }))

import type { CollectionConfig, Config, Field, RelationshipField, Where } from 'payload'
import { Aufrufemedien, Medien, PoiIcons, Veranstaltungsmedien } from '../collections/medien'
import { Kommunen } from '../collections/kommunen'
import { NewsArtikel } from '../collections/news-artikel/news-artikel'
import { Aufrufe } from '../collections/aufrufe/aufrufe'
import { Veranstaltungskalender } from '../collections/veranstaltungen/veranstaltungskalender'
import { Pois } from '../collections/pois/pois'
import { PoiCategories } from '../collections/pois/poi-categories'
import { Sensoren } from '../collections/sensoren/sensoren'
import { SensorArt } from '../collections/sensoren/sensor-art'
import { kommuneField } from '../fields/kommune'
import { untereinheitField } from '../fields/untereinheit-field'
import { Funktionsberechtigung } from '../lib/funktionsberechtigungen'
import { defaultAccessControl } from '../plugins/default-access-control'
import { mockOeUser, mockSuperAdmin, writeArgs } from './__tests__/mock-factories'

const OWN_OE = 'oe-1'
const FOREIGN_OE = 'oe-2'
const KOMMUNE = 'kommune-1'

const doc = (untereinheit: string) => ({ kommune: KOMMUNE, untereinheit })

const applyAccessControl = (collections: CollectionConfig[]) =>
  defaultAccessControl({ collections } as Config).collections as CollectionConfig[]

const untereinheitOptions = (collection: CollectionConfig, user: unknown): string[] => {
  const field = collection.fields.find(
    (f): f is RelationshipField => 'name' in f && f.name === 'untereinheit',
  )
  if (typeof field?.filterOptions !== 'function') {
    throw new Error(`${collection.slug} has no untereinheit filterOptions`)
  }
  const where = field.filterOptions({ user } as never) as Where
  return ((where?.id as { in?: string[] })?.in ?? []) as string[]
}

const grantsUploadTo = (collection: CollectionConfig, permission: Funktionsberechtigung) =>
  untereinheitOptions(collection, mockOeUser(OWN_OE, [permission])).includes(OWN_OE)

const mediaCollection = (slug: string): CollectionConfig => ({
  slug,
  upload: { staticDir: `/tmp/${slug}` },
  fields: [kommuneField({ required: true }), untereinheitField()],
})

const contentCollection = ({
  slug,
  permissions,
  imageField,
}: {
  slug: string
  permissions?: Funktionsberechtigung[]
  imageField: Field
}): CollectionConfig => ({
  slug,
  ...(permissions ? { custom: { funktionsberechtigungen: permissions } } : {}),
  fields: [kommuneField({ required: true }), untereinheitField(), imageField],
})

const uploadAtTopLevel = (relationTo: string): Field => ({
  name: 'bild',
  type: 'upload',
  relationTo: relationTo as never,
})

const uploadInGroup = (relationTo: string): Field => ({
  name: 'bildGruppe',
  type: 'group',
  fields: [uploadAtTopLevel(relationTo)],
})

const uploadInArray = (relationTo: string): Field => ({
  name: 'bilder',
  type: 'array',
  fields: [uploadAtTopLevel(relationTo)],
})

const uploadInBlocks = (relationTo: string): Field => ({
  name: 'inhalte',
  type: 'blocks',
  blocks: [{ slug: 'bild-block', fields: [uploadAtTopLevel(relationTo)] }],
})

describe('an upload collection derives its permissions from the collections referencing it', () => {
  const NESTINGS: [string, (relationTo: string) => Field][] = [
    ['top-level upload field', uploadAtTopLevel],
    ['upload nested in a group', uploadInGroup],
    ['upload nested in an array', uploadInArray],
    ['upload nested in blocks', uploadInBlocks],
  ]

  it.each(NESTINGS)('finds the reference via a %s', (_label, imageField) => {
    const [media] = applyAccessControl([
      mediaCollection('bilder'),
      contentCollection({
        slug: 'inhalt',
        permissions: [Funktionsberechtigung.InhaltspflegePois],
        imageField: imageField('bilder'),
      }),
    ])
    expect(grantsUploadTo(media, Funktionsberechtigung.InhaltspflegePois)).toBe(true)
  })

  it('unions the permissions when several collections share one upload collection', () => {
    const [media] = applyAccessControl([
      mediaCollection('bilder'),
      contentCollection({
        slug: 'inhalt-a',
        permissions: [Funktionsberechtigung.InhaltspflegeVeranstaltungen],
        imageField: uploadAtTopLevel('bilder'),
      }),
      contentCollection({
        slug: 'inhalt-b',
        permissions: [Funktionsberechtigung.InhaltspflegeNewsArtikel],
        imageField: uploadInBlocks('bilder'),
      }),
    ])
    expect(grantsUploadTo(media, Funktionsberechtigung.InhaltspflegeVeranstaltungen)).toBe(true)
    expect(grantsUploadTo(media, Funktionsberechtigung.InhaltspflegeNewsArtikel)).toBe(true)
  })

  it('grants nothing that no referencing collection asked for', () => {
    const [media] = applyAccessControl([
      mediaCollection('bilder'),
      contentCollection({
        slug: 'inhalt',
        permissions: [Funktionsberechtigung.InhaltspflegePois],
        imageField: uploadAtTopLevel('bilder'),
      }),
    ])
    expect(grantsUploadTo(media, Funktionsberechtigung.InhaltspflegeAufrufe)).toBe(false)
    expect(grantsUploadTo(media, Funktionsberechtigung.Inhaltspflege)).toBe(false)
  })

  it('ignores referencing collections that declare no funktionsberechtigungen', () => {
    const [media] = applyAccessControl([
      mediaCollection('bilder'),
      contentCollection({ slug: 'ohne-deklaration', imageField: uploadAtTopLevel('bilder') }),
    ])
    expect(grantsUploadTo(media, Funktionsberechtigung.Inhaltspflege)).toBe(false)
  })

  it('an unreferenced upload collection is left to superadmins', () => {
    const [media] = applyAccessControl([mediaCollection('bilder')])
    for (const permission of Object.values(Funktionsberechtigung)) {
      expect(grantsUploadTo(media, permission)).toBe(false)
    }
    expect(untereinheitOptions(media, mockSuperAdmin())).toEqual([])
  })

  it('keeps two upload collections apart even when they share field instances', () => {
    const shared = mediaCollection('geteilt')
    const [, alias] = applyAccessControl([
      shared,
      { ...shared, slug: 'geteilt-alias' },
      contentCollection({
        slug: 'inhalt',
        permissions: [Funktionsberechtigung.InhaltspflegePois],
        imageField: uploadAtTopLevel('geteilt'),
      }),
    ])
    expect(grantsUploadTo(alias, Funktionsberechtigung.InhaltspflegePois)).toBe(false)
  })
})

const realCollections = applyAccessControl([
  Kommunen,
  Medien,
  PoiIcons,
  Veranstaltungsmedien,
  Aufrufemedien,
  NewsArtikel,
  Aufrufe,
  Veranstaltungskalender,
  Pois,
  PoiCategories,
  Sensoren,
  SensorArt,
])

const bySlug = (slug: string): CollectionConfig => {
  const collection = realCollections.find((c) => c.slug === slug)
  if (!collection) throw new Error(`unknown collection ${slug}`)
  return collection
}

const canWrite = async (
  slug: string,
  operation: 'create' | 'update',
  user: unknown,
  untereinheit: string,
) => {
  const access = bySlug(slug).access?.[operation]
  if (!access) throw new Error(`${slug} has no ${operation} access`)
  return access(writeArgs(user as never, doc(untereinheit)))
}

type Pairing = {
  label: string
  content: string
  media: string
  permission: Funktionsberechtigung
  otherPermission: Funktionsberechtigung
}

const PAIRINGS: Pairing[] = [
  {
    label: 'POIs',
    content: 'poi',
    media: 'medien',
    permission: Funktionsberechtigung.InhaltspflegePois,
    otherPermission: Funktionsberechtigung.InhaltspflegeAufrufe,
  },
  {
    label: 'POI-Kategorien',
    content: 'poi-categories',
    media: 'poi-icons',
    permission: Funktionsberechtigung.InhaltspflegePois,
    otherPermission: Funktionsberechtigung.InhaltspflegeAufrufe,
  },
  {
    label: 'Veranstaltungen',
    content: 'veranstaltungskalender',
    media: 'veranstaltungsmedien',
    permission: Funktionsberechtigung.InhaltspflegeVeranstaltungen,
    otherPermission: Funktionsberechtigung.InhaltspflegeAufrufe,
  },
  {
    label: 'Aufrufe',
    content: 'aufrufe',
    media: 'aufrufemedien',
    permission: Funktionsberechtigung.InhaltspflegeAufrufe,
    otherPermission: Funktionsberechtigung.InhaltspflegePois,
  },
  {
    label: 'News',
    content: 'news-artikel',
    media: 'veranstaltungsmedien',
    permission: Funktionsberechtigung.InhaltspflegeNewsArtikel,
    otherPermission: Funktionsberechtigung.InhaltspflegeAufrufe,
  },
]

describe.each(PAIRINGS)(
  '$label: content permission also grants media management',
  ({ content, media, permission, otherPermission }) => {
    const editor = mockOeUser(OWN_OE, [permission])
    const outsider = mockOeUser(OWN_OE, [otherPermission])

    it.each(['create', 'update'] as const)('%s content in own OE → allowed', async (operation) => {
      expect(await canWrite(content, operation, editor, OWN_OE)).toBe(true)
    })

    it.each(['create', 'update'] as const)('%s media in own OE → allowed', async (operation) => {
      expect(await canWrite(media, operation, editor, OWN_OE)).toBe(true)
    })

    it('media is offered the editor’s own OE', () => {
      expect(untereinheitOptions(bySlug(media), editor)).toContain(OWN_OE)
    })

    it.each(['create', 'update'] as const)(
      '%s media in a foreign OE → denied',
      async (operation) => {
        expect(await canWrite(media, operation, editor, FOREIGN_OE)).toBe(false)
      },
    )

    it.each(['create', 'update'] as const)(
      '%s media without the content permission → denied',
      async (operation) => {
        expect(await canWrite(media, operation, outsider, OWN_OE)).toBe(false)
      },
    )

    it('media is not offered to a user without the content permission', () => {
      expect(untereinheitOptions(bySlug(media), outsider)).not.toContain(OWN_OE)
    })

    it('superadmin can still manage the media collection', async () => {
      const access = bySlug(media).access?.create
      expect(await access!(writeArgs(mockSuperAdmin(), doc(OWN_OE)))).toBe(true)
    })
  },
)

describe('real configuration', () => {
  it('veranstaltungsmedien serves both Veranstaltungen and News', () => {
    const media = bySlug('veranstaltungsmedien')
    expect(grantsUploadTo(media, Funktionsberechtigung.InhaltspflegeVeranstaltungen)).toBe(true)
    expect(grantsUploadTo(media, Funktionsberechtigung.InhaltspflegeNewsArtikel)).toBe(true)
  })

  it('kommunen references medien but declares nothing, so medien stays closed to Inhaltspflege', () => {
    expect(grantsUploadTo(bySlug('medien'), Funktionsberechtigung.Inhaltspflege)).toBe(false)
  })

  it('poi-icons is not widened by medien despite the shared upload config', () => {
    expect(grantsUploadTo(bySlug('poi-icons'), Funktionsberechtigung.InhaltspflegePois)).toBe(true)
    expect(grantsUploadTo(bySlug('poi-icons'), Funktionsberechtigung.InhaltspflegeAufrufe)).toBe(
      false,
    )
  })

  it('poi-icons serves Sensoren too, since Sensoren and SensorArt reference it as icon', () => {
    expect(grantsUploadTo(bySlug('poi-icons'), Funktionsberechtigung.InhaltspflegeSensoren)).toBe(
      true,
    )
  })
})
