import { type CollectionConfig } from 'payload'
import { accessRules } from '../access'
import { kommuneField } from '../fields/kommune'
import { isSuperAdmin } from '../utils/is-super-admin'

export const Untereinheit: CollectionConfig = {
  slug: 'untereinheit',
  labels: {
    singular: 'Untereinheit',
    plural: 'Untereinheit',
  },
  access: {
    read: () => true,
    create: accessRules.superAdmin,
    update: accessRules.superAdmin,
    delete: accessRules.superAdmin,
  },
  admin: {
    useAsTitle: 'name',
    hidden: ({ user }) => !isSuperAdmin(user),
  },
  fields: [
    { name: 'id', type: 'text', required: true },
    {
      name: 'name',
      type: 'text',
      required: true,
    },
    {
      name: 'isGemeinde',
      type: 'checkbox',
      label: 'Ist diese Untereinheit eine Gemeinde?',
    },
    {
      name: 'regionalschluessel',
      type: 'text',
      label: 'Amtlicher Regionalschlüssel',
      admin: {
        condition: (_, siblingData) => siblingData.isGemeinde,
      },
    },
    kommuneField(),
  ],
}
