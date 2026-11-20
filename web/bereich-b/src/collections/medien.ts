import * as path from 'path'
import { type CollectionConfig, type Field } from 'payload'
import { kommuneField } from '../fields/kommune'
import { untereinheitField } from '../fields/untereinheit-field'
import { getSha1Hash } from '../utils/get-sha1-hash'

const medienUpload = {
  staticDir: path.resolve(process.cwd(), 'uploads/media'),
  mimeTypes: ['image/*'],
  imageSizes: [
    {
      name: 'thumbnail',
      width: 400,
      height: 300,
    },
  ],
  adminThumbnail: 'thumbnail',
} as const satisfies NonNullable<CollectionConfig['upload']>

const sha1Field = (): Field => ({
  name: 'sha1',
  type: 'text',
  admin: {
    readOnly: true,
    // Hide, but only in the UI
    condition: () => false,
  },
  hooks: {
    beforeValidate: [
      ({ data, req }) => {
        if (data && req.file?.data) {
          data.sha1 = getSha1Hash(req.file.data)
        }
      },
    ],
  },
})

const medienFields = ({ kommuneRequired = true }: { kommuneRequired?: boolean } = {}): Field[] => [
  kommuneField({ required: kommuneRequired }),
  untereinheitField(),
]

export const Medien: CollectionConfig = {
  slug: 'medien',
  labels: { singular: 'Medium', plural: 'Medien' },
  upload: medienUpload,
  access: {
    read: () => true,
  },
  disableDuplicate: true,
  admin: {
    useAsTitle: 'filename',
    description: 'Hier können Medien verwaltet werden.',
    group: 'Inhalte',
  },
  fields: [sha1Field(), ...medienFields()],
}

export const PoiIcons: CollectionConfig = {
  ...Medien,
  slug: 'poi-icons',
  labels: { singular: 'POI Icon', plural: 'POI Icons' },
  upload: {
    ...medienUpload,
    staticDir: path.resolve(process.cwd(), 'uploads/media/poi-icons'),
    mimeTypes: ['image/svg+xml'],
  },
  admin: {
    ...Medien.admin,
    description: 'Hier können POI Icons verwaltet werden.',
    group: 'POIs',
  },
  fields: [sha1Field(), ...medienFields()],
  access: {
    read: () => true,
  },
  hooks: {
    beforeDelete: [
      async ({ req, id }) => {
        const payload = req.payload
        const poiCategories = await payload.find({
          collection: 'poi-categories',
          where: {
            icon: {
              equals: id,
            },
          },
        })

        if (poiCategories.totalDocs > 0) {
          throw new Error(
            'Dieses Icon wird noch von einer POI Kategorie verwendet und kann deshalb nicht gelöscht werden.',
          )
        }
      },
    ],
  },
}

export const Veranstaltungsmedien: CollectionConfig = {
  ...Medien,
  slug: 'veranstaltungsmedien',
  labels: { singular: 'Veranstaltungsmedium', plural: 'Veranstaltungsmedien' },
  upload: {
    ...medienUpload,
    staticDir: path.resolve(process.cwd(), 'uploads/media/event-media'),
    mimeTypes: ['image/*'],
  },
  admin: {
    // hidden: true,
    ...Medien.admin,
    description: 'Hier können Veranstaltungsbilder verwaltet werden.',
  },
  fields: [
    {
      name: 'sourceUrl',
      type: 'text',
      admin: {
        readOnly: true,
      },
    },
    ...medienFields({ kommuneRequired: false }),
  ],
}

export const Aufrufemedien: CollectionConfig = {
  ...Medien,
  slug: 'aufrufemedien',
  labels: { singular: 'Aufrufmedium', plural: 'Aufrufmedien' },
  upload: {
    ...medienUpload,
    staticDir: path.resolve(process.cwd(), 'uploads/media/aufrufe-media'),
    mimeTypes: ['image/*'],
  },
  admin: {
    ...Medien.admin,
    description: 'Hier können Bilder für Aufrufe verwaltet werden.',
  },
  fields: medienFields(),
}
