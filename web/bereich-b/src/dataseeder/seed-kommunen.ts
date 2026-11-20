import { getPayload, type Payload } from 'payload'

import config from '@payload-config'
import { dataseederAsset } from './assets'
import { getMediaId, seedMedien } from './seed-medien'
import { upsert } from './upsert'
import { DEFAULT_KARTENLIZENZEN } from '../lib/default-kartenlizenzen'

export const seedKommunen = async (payloadArg?: Payload) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const hannover = await upsert(
    {
      collection: 'kommunen',
      key: 'bereichAId',
      data: {
        name: 'Region Hannover',
        bereichAId: 'e954b80e-9594-454b-bdc8-693b10a75825',
        regionalschluessel: '03241',
        design: {
          colors: { primary: '#15579D', primaryLight: '#C1DCF6' },
          fonts: { headings: 'RobotoSlab', body: 'NotoSans' },
        },
        analytics: {},
        lizenzen: { kartenlizenzen: DEFAULT_KARTENLIZENZEN },
        legal: {},
        maengelmelder: {},
        defaultPosition: [52.37655, 9.741046],
      },
    },
    { payload },
  )

  if (!hannover?.id) {
    console.info('Could not seed Kommune: Region Hannover')
    return
  }

  await seedMedien(dataseederAsset('media/hannover'), undefined, hannover.id, payload)

  await payload.update({
    id: hannover.id,
    collection: 'kommunen',
    data: {
      design: {
        logo: await getMediaId('region-hannover-small.png', hannover.id, payload),
      },
    },
    overrideAccess: true,
  })

  // |--------------------------------HAPY--------------------------------------------|

  const hapy = await upsert(
    {
      collection: 'kommunen',
      key: 'bereichAId',
      data: {
        name: 'Landkreis Hameln-Pyrmont',
        bereichAId: '5a1aefef-809f-403d-a14c-27051353c7d4',
        regionalschluessel: '03252',
        design: {
          colors: { primary: '#74A220', primaryLight: '#DAEFA7' },
          fonts: { headings: 'Mulish', body: 'Mulish' },
        },
        analytics: {},
        lizenzen: { kartenlizenzen: DEFAULT_KARTENLIZENZEN },
        legal: {
          impressum: 'https://www.hameln-pyrmont.de/Schnellnavigation/Impressum/',
          privacy: 'https://www.hameln-pyrmont.de/Schnellnavigation/Datenschutz/',
        },
        maengelmelder: {},
        defaultPosition: [52.101818, 9.375807],
      },
    },
    { payload },
  )

  if (!hapy?.id) {
    console.info('Could not seed Kommune: Landkreis Hameln-Pyrmont')
    return
  }

  await seedMedien(dataseederAsset('media/hapy'), undefined, hapy.id, payload)

  await payload.update({
    id: hapy.id,
    collection: 'kommunen',
    data: {
      design: {
        logo: await getMediaId('landkreis-hapy-small.png', hapy.id, payload),
      },
    },
    overrideAccess: true,
  })
}

export const getKommuneId = async (name: string, payloadArg?: Payload) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const { docs } = await payload.find({
    collection: 'kommunen',
    where: { name: { equals: name } },
    overrideAccess: true,
  })

  if (docs.length === 0) {
    throw new Error(`Could not associate ${name} with any Id`)
  }

  return docs[0].id
}
