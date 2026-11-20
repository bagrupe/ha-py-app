import { readFileSync } from 'fs'

import type { Payload } from 'payload'
import { type PoiCategory, type PoiIcon, type PoiSupercategory } from '../payload-types'
import { dataseederAsset } from './assets'
import { getKommuneId } from './seed-kommunen'
import { upsert } from './upsert'

type PoiCategoryScaffold = {
  [key: string]: string[]
}

const categoryStructure: PoiCategoryScaffold = {
  Kommune: [],
  Bildung: ['Kindergarten'],
  'Kunst & Kultur': ['Kunstgalerie', 'Museum'],
  'Sport & Freizeit': ['Schwimmbad'],
}

type SeedCoordinatesScaffold = {
  [key: string]: [number, number]
}

const seedCoordinates: SeedCoordinatesScaffold = {
  'Landkreis Hameln-Pyrmont': [52.048585, 9.250617],
}

export const seedPois = async (payload?: Payload) => {
  const kommunen = await Promise.all(
    [{ kommuneName: 'Landkreis Hameln-Pyrmont', titelbild: 'hameln.jpg' }].map(
      async ({ kommuneName }) => ({
        kommune: await getKommuneId(kommuneName, payload),
        kommuneName: kommuneName,
      }),
    ),
  )

  for (const { kommune, kommuneName } of kommunen) {
    // Upload Supercategories
    const supercategoriesDocs: PoiSupercategory[] = []
    for (const key in categoryStructure) {
      const supercategory = await upsert(
        {
          collection: 'poi-supercategories',
          key: ['kommune', 'title'],
          data: {
            kommune: kommune,
            title: key,
            visible: true,
          },
        },
        { payload },
      )
      if (supercategory) {
        supercategoriesDocs.push(supercategory)
      }
    }

    // Upload Poi Icons
    const poiIconsDocs: PoiIcon[] = []
    for (const key in categoryStructure) {
      const categorieNames = categoryStructure[key]
      for (const i in categorieNames) {
        console.info(`${kommuneName}-${categorieNames[i]}`)

        const buffer = readFileSync(dataseederAsset(`media/icons/${categorieNames[i]}.svg`))

        const poiIcon = await upsert(
          {
            collection: 'poi-icons',
            key: ['kommune', 'filename'],
            data: {
              kommune: kommune,
              filename: `${kommuneName}-${categorieNames[i]}.svg`,
            },
            overwriteExistingFiles: true,
            file: {
              data: buffer,
              name: `${kommuneName}-${categorieNames[i]}.svg`,
              mimetype: 'image/svg+xml',
              size: buffer.byteLength,
            },
          },
          { payload },
        )
        if (poiIcon) {
          poiIconsDocs.push(poiIcon)
        }
      }
    }

    //Upload Poi Categories
    const poiCategoriesDocs: PoiCategory[] = []
    for (const key in categoryStructure) {
      const categorieNames = categoryStructure[key]
      for (const i in categorieNames) {
        const categoryName = categorieNames[i]
        const regex = new RegExp(`${categoryName}.*.svg$`)
        const icon = poiIconsDocs.filter((poiIcon) => regex.test(poiIcon.filename ?? ''))
        const supercategory = supercategoriesDocs.filter(
          (supercategory) => supercategory.title == key,
        )
        const poiCategory = await upsert(
          {
            collection: 'poi-categories',
            key: ['kommune', 'title'],
            data: {
              kommune: kommune,
              title: categoryName,
              icon: icon[0].id,
              supercategory: supercategory[0].id,
              visible: true,
            },
          },
          { payload },
        )
        if (poiCategory) {
          poiCategoriesDocs.push(poiCategory)
        }
      }
    }

    const kommmuneCoordinates: [number, number] = [
      seedCoordinates[kommuneName][0],
      seedCoordinates[kommuneName][1],
    ]
    // Upload POI
    const loopFactor = 2
    for (let i = 0; i < poiCategoriesDocs.length * loopFactor; i++) {
      const index = Math.floor(i / loopFactor)
      const position = getRandomCoordinatesFromSeed(kommmuneCoordinates)
      await upsert(
        {
          collection: 'poi',
          key: ['kommune', 'title'],
          data: {
            kommune,
            title: poiCategoriesDocs[index].title + ' ' + i,
            category: poiCategoriesDocs[index].id,
            position: position,
          },
        },
        { payload },
      )
    }
  }
}

function getRandomCoordinatesFromSeed(coordinates: [number, number]): [number, number] {
  const maxDistanceKm = 5
  const kmToDeg = 1 / 111 // approximately 1 degree latitude is 111 km

  const maxDeviation = maxDistanceKm * kmToDeg

  // Generate random deviation for latitude and longitude
  const latDeviation = (Math.random() * 2 - 1) * maxDeviation
  const lngDeviation =
    ((Math.random() * 2 - 1) * maxDeviation) / Math.cos((coordinates[0] * Math.PI) / 180)

  // Calculate new coordinates
  const newLat = coordinates[0] + latDeviation
  const newLng = coordinates[1] + lngDeviation

  return [newLat, newLng]
}
