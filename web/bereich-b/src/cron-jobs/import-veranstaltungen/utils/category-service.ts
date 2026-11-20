import { getPayload } from 'payload'
import config from '@payload-config'
import { upsert } from '../../../dataseeder/upsert'
import { type D4Veranstaltung } from '../fetch-all-veranstaltungen'

export const ensureCategoriesExist = async (
  veranstaltungen: D4Veranstaltung[],
  kommuneId: string,
) => {
  const allCategories = veranstaltungen.reduce((acc: string[], veranstaltung) => {
    const categories = veranstaltung.categories.map((category) => category.value)
    return [...acc, ...categories]
  }, [])

  const uniqueCategories = [...new Set(allCategories)].filter((category) => category !== '')

  for (const category of uniqueCategories) {
    await upsert({
      collection: 'veranstaltungskalender-kategorie',
      key: ['label', 'kommune'],
      data: {
        kommune: kommuneId,
        label: category,
      },
    })
  }
}

export const getCategoryIds = async (
  veranstaltung: D4Veranstaltung,
  kommuneId: string,
): Promise<string[]> => {
  const categories = veranstaltung.categories
    .map((category) => category.value)
    .filter((category) => category !== '')

  const categoryIds: string[] = []

  const payload = await getPayload({ config })
  for (const category of categories) {
    const categoryDoc = await payload.find({
      collection: 'veranstaltungskalender-kategorie',
      where: {
        and: [
          {
            label: {
              equals: category,
            },
          },
          {
            kommune: {
              equals: kommuneId,
            },
          },
        ],
      },
    })

    if (categoryDoc.docs.length === 1) {
      categoryIds.push(categoryDoc.docs[0].id)
    } else {
      console.info(
        `Category "${category}" not found for Veranstaltung "${veranstaltung.id}". Skipping the category.`,
      )
    }
  }

  return categoryIds
}
