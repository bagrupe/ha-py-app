import type { CollectionConfig } from 'payload'
import { kommuneField } from '../../fields/kommune'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { publicPoiCategoryRead } from '../public-read-rules'

export const PoiCategories: CollectionConfig = {
  slug: 'poi-categories',
  labels: { singular: 'POI-Kategorie', plural: 'POI-Kategorien' },
  admin: {
    useAsTitle: 'title',
    group: 'POIs',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegePois],
  },
  access: {
    read: publicPoiCategoryRead,
  },
  hooks: {
    beforeDelete: [
      async ({ req, id }) => {
        const dependentPOIs = await req.payload.find({
          collection: 'poi',
          limit: 0,
          where: {
            category: {
              equals: id,
            },
          },
        })

        if (dependentPOIs.totalDocs > 0) {
          throw new Error(
            `Löschen nicht möglich, da zu dieser Kategorie noch ${dependentPOIs.totalDocs} POIs existieren`,
          )
        }
      },
    ],
  },
  fields: [
    {
      name: 'title',
      type: 'text',
      label: 'Titel',
      required: true,
    },
    {
      relationTo: 'poi-supercategories',
      type: 'relationship',
      name: 'supercategory',
      label: 'Superkategorie',
      required: true,
    },
    {
      name: 'icon',
      type: 'upload',
      label: 'Icon',
      relationTo: 'poi-icons',
      required: true,
    },
    {
      type: 'checkbox',
      name: 'visible',
      label: 'Sichtbar',
      defaultValue: true,
    },
    kommuneField(),
  ],
}
