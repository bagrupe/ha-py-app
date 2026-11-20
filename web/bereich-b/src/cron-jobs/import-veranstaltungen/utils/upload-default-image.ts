import { getPayload } from 'payload'
import config from '@payload-config'
import { type Veranstaltungsmedien } from '../../../payload-types'
import { type D4Veranstaltung } from '../fetch-all-veranstaltungen'

export const uploadDefaultImage = async (
  veranstaltung: D4Veranstaltung,
  kommuneId: string,
): Promise<Veranstaltungsmedien | undefined> => {
  const imageUrl = veranstaltung.media_objects.find(
    (mediaObject) => mediaObject.rel === 'default',
  )?.url

  if (!imageUrl) return undefined

  const payload = await getPayload({ config })
  const { docs } = await payload.find({
    collection: 'veranstaltungsmedien',
    where: {
      kommune: { equals: kommuneId },
      sourceUrl: { equals: imageUrl },
    },
  })

  if (docs[0]) return docs[0]

  try {
    const response = await fetch(imageUrl)
    if (!response.ok) {
      throw new Error('Could not fetch image from endpoint')
    }
    const arrayBuffer = await response.arrayBuffer()
    const fileName = imageUrl.split('/').at(-1)!

    const image = await payload.create({
      collection: 'veranstaltungsmedien',
      file: {
        data: Buffer.from(arrayBuffer),
        mimetype: response.headers.get('content-type') ?? 'image/*',
        name: fileName,
        size: arrayBuffer.byteLength,
      },
      data: { sourceUrl: imageUrl, kommune: kommuneId },
    })
    console.info(`Image "${fileName}" created.`)
    return image
  } catch (error) {
    console.error(error)
  }

  return undefined
}
