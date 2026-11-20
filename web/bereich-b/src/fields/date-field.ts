import { type DateField } from 'payload'

export type DateFieldOptions = Omit<DateField, 'type' | 'date'>

export const dateField = ({ admin, ...rest }: DateFieldOptions): DateField => ({
  ...rest,
  type: 'date',
  admin: {
    ...admin,
    components: {
      Field: '@/components/admin/custom-date-field#CustomDateField',
    },
  },
})
