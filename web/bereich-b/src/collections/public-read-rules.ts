import type { Where } from 'payload'
import { accessRules } from '../access'

export const publicVisibleRead = accessRules.publicRead({ visible: { equals: true } })

export const publicNewsArtikelRead = accessRules.publicRead(
  (): Where => ({
    and: [
      { _status: { equals: 'published' } },
      { datum: { less_than_equal: new Date() } },
      { visible: { equals: true } },
    ],
  }),
)

export const publicPoiCategoryRead = accessRules.publicRead({
  visible: { equals: true },
  'supercategory.visible': { equals: true },
})

export const publicPoiRead = accessRules.publicRead({
  visible: { equals: true },
  'category.visible': { equals: true },
  'category.supercategory.visible': { equals: true },
})
