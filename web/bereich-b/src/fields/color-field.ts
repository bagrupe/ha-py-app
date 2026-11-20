import { type TextField } from 'payload'

export const colorField = (options: Omit<TextField, 'type'>): TextField => {
  const { admin, ...rest } = options
  return {
    type: 'text',
    ...rest,
    admin: {
      ...admin,
      components: {
        ...admin?.components,
        Field: '@/components/admin/color-field#ColorField',
      },
    },
  } as TextField
}
