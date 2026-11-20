import { type CollectionSlug, type GroupField } from 'payload'

export const localOrExternalImage = (
  props: { name: string; label?: GroupField['label'] },
  relationCollection: CollectionSlug,
): GroupField => ({
  ...props,
  type: 'group',
  fields: [
    {
      name: 'external',
      label: 'Externes Bild',
      type: 'checkbox',
    },
    {
      name: 'url',
      label: 'Link zu externem Bild',
      type: 'text',
      admin: {
        condition: (_, siblingData) => siblingData.external,
      },
    },
    {
      name: 'internal',
      label: 'Lokales Bild',
      type: 'upload',
      relationTo: relationCollection,
      admin: {
        condition: (_, siblingData) => !siblingData.external,
      },
    },
  ],
})
