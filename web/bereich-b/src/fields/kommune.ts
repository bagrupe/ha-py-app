import { type CollectionConfig, type GlobalConfig, type RelationshipField } from 'payload'
import { getId } from '../utils/get-id'
import { isSuperAdmin } from '../utils/is-super-admin'

export const kommuneField = (
  {
    required,
  }: {
    required: boolean
  } = { required: true },
): RelationshipField => ({
  name: 'kommune',
  type: 'relationship',
  relationTo: 'kommunen',
  admin: {
    position: 'sidebar',
    condition: (data, siblingData, { user }) => isSuperAdmin(user),
  },
  hooks: {
    beforeValidate: [
      ({ req: { user }, value, operation }) => {
        if (operation !== 'create' || !user?.kommune) return value
        const userKommuneId = getId(user.kommune)
        if (userKommuneId && value == null) {
          return userKommuneId
        }
      },
    ],
  },
  required,
})

export const hasKommuneField = (collectionConfig: CollectionConfig | GlobalConfig) =>
  collectionConfig.fields.some(
    (field) => field.type === 'relationship' && field.name === 'kommune',
  ) ?? false
