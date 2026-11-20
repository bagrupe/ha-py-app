import camelCase from 'lodash/camelCase'
import upperFirst from 'lodash/upperFirst'
import { type Block } from 'payload'
import { type Config } from '../payload-types'

export const ImageBlock = (relationCollection: keyof Config['collections']): Block => ({
  slug: `image-${relationCollection}`,
  interfaceName: `ImageBlock${upperFirst(camelCase(relationCollection))}`,
  labels: { singular: 'Bild', plural: 'Bilder' },
  fields: [
    {
      name: 'image',
      label: 'Bild',
      type: 'upload',
      required: true,
      relationTo: relationCollection,
    },
  ],
})
