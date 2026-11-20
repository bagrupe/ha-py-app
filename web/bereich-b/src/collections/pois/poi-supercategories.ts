import { type CollectionConfig } from 'payload'
import { kommuneField } from '../../fields/kommune'
import { Funktionsberechtigung } from '../../lib/funktionsberechtigungen'
import { publicVisibleRead } from '../public-read-rules'

export const PoiSupercategories: CollectionConfig = {
  slug: 'poi-supercategories',
  labels: { singular: 'POI-Superkategorie', plural: 'POI-Superkategorien' },
  admin: {
    useAsTitle: 'title',
    group: 'POIs',
  },
  custom: {
    funktionsberechtigungen: [Funktionsberechtigung.InhaltspflegePois],
  },
  access: {
    read: publicVisibleRead,
  },
  hooks: {
    beforeDelete: [
      async ({ req, id }) => {
        const dependentCategories = await req.payload.find({
          collection: 'poi-categories',
          limit: 0,
          where: {
            supercategory: {
              equals: id,
            },
          },
        })

        if (dependentCategories.totalDocs > 0) {
          throw new Error(
            `Löschen nicht möglich, da zu dieser Superkategorie noch ${dependentCategories.totalDocs} Kategorien existieren`,
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
      type: 'checkbox',
      name: 'visible',
      label: 'Sichtbar',
      defaultValue: true,
    },
    kommuneField(),
  ],
}
