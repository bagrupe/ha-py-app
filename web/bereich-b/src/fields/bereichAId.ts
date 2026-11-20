import { type TextField } from 'payload'
import { fieldAccessRules } from '../access'

export const bereichAId = (
  { required }: { required: boolean } = { required: true },
): TextField => ({
  name: 'bereichAId',
  type: 'text',
  required: required,
  access: {
    update: fieldAccessRules.forbidden,
  },
  index: true,
})
