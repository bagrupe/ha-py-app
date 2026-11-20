import { type TextField } from 'payload'

import { slugify } from '../utils/slugify'

export const slugField = (options: Omit<TextField, 'type'>): TextField => {
  const { admin, ...rest } = options
  return {
    type: 'text',
    ...rest,
    admin: {
      ...admin,
      components: {
        ...admin?.components,
        Field: '@/components/admin/slug-field#SlugField',
      },
    },
    hooks: {
      beforeValidate: [
        ({ value, data }) => {
          if (!value) {
            const fallback = data?.title ?? data?.name
            return slugify(fallback)
          }
        },
      ],
    },
  } as TextField
}
