import { getPayload } from 'payload'
import config from '@payload-config'
import { type Kommune } from '../../../payload-types'
import { upsert } from '../../../dataseeder/upsert'

export type EndpointVeranstaltung = {
  name: string
  experienceValue: string
  licenseKey?: string
}

export const getEndpointsVeranstaltungen = (): EndpointVeranstaltung[] => {
  const niedersachsenHub: EndpointVeranstaltung = {
    name: 'Niedersachsenhub',
    experienceValue: 'open-data-niedersachsen-tourismus',
  }
  const destinationOneHamelnPyrmont: EndpointVeranstaltung = {
    name: 'Destination One',
    experienceValue: 'landkreis-hameln-pyrmont',
    licenseKey: process.env.VERANSTALTUNGEN_HAPY_DEST_ONE_KEY,
  }
  return [niedersachsenHub, destinationOneHamelnPyrmont]
}

export const getEndpointIds = async (endpointName: string, kommuneId: string) => {
  const payload = await getPayload({ config })
  const sourceDocs = await payload.find({
    collection: 'veranstaltungskalender-quelle',
    where: {
      and: [
        {
          name: {
            equals: endpointName,
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

  return sourceDocs.docs.length === 1 ? [sourceDocs.docs[0].id] : []
}
export async function upsertEndpoint(kommune: Kommune, endpoint: EndpointVeranstaltung) {
  await upsert({
    collection: 'veranstaltungskalender-quelle',
    key: ['name', 'kommune'],
    data: {
      kommune: kommune.id,
      name: endpoint.name,
    },
  })
}
