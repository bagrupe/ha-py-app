import { type GroupField } from 'payload'

export const adresseField = (props: { name: string; label: string }): GroupField => ({
  ...props,
  type: 'group',
  interfaceName: 'Adresse',
  fields: [
    { type: 'text', name: 'name', label: 'Name' },
    {
      type: 'row',
      fields: [
        {
          type: 'text',
          name: 'plz',
          label: 'PLZ',
          admin: { width: 'min-content' },
        },
        { type: 'text', name: 'ort', label: 'Ort' },
      ],
    },
    { type: 'text', name: 'strasse', label: 'Straße' },
    {
      type: 'text',
      name: 'telefon',
      label: 'Telefonnummer',
    },
    {
      type: 'text',
      name: 'url',
      label: 'Link',
    },
    { type: 'text', name: 'email', label: 'E-Mail' },
  ],
})
