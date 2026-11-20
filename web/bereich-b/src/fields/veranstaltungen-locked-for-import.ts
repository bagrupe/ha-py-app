import { type CheckboxField } from 'payload'

export const lockedForImportField = (options: Omit<CheckboxField, 'type'>): CheckboxField => ({
  type: 'checkbox',
  ...options,
  admin: {
    ...options.admin,
    components: {
      Field: '@/components/admin/locked-for-import-field#LockedForImportField',
    },
  },
})
