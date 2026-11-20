import { type BasePayload } from 'payload'
import { type Kommune, type Veranstaltungsmedien } from '../../../payload-types'
import { type UpsertCache, prefetchCollection } from '../../../dataseeder/upsert'

export type ImageCache = Map<string, Veranstaltungsmedien>

export const prefetchImages = async (
  payload: BasePayload,
  kommuneId: string,
): Promise<ImageCache> => {
  const { docs } = await payload.find({
    collection: 'veranstaltungsmedien',
    where: { kommune: { equals: kommuneId } },
    pagination: false,
    depth: 0,
    overrideAccess: true,
  })
  const cache: ImageCache = new Map()
  for (const doc of docs) {
    if (doc.sourceUrl) {
      cache.set(doc.sourceUrl, doc)
    }
  }
  return cache
}

export const prefetchImporterCaches = async (
  payload: BasePayload,
  kommune: string | Kommune,
): Promise<{ articleCache: UpsertCache; imageCache: ImageCache }> => {
  const kommuneId = resolveKommuneId(kommune)
  const [articleCache, imageCache] = await Promise.all([
    prefetchCollection('news-artikel', { kommune: { equals: kommuneId } }, ['importId', 'kommune']),
    prefetchImages(payload, kommuneId),
  ])
  return { articleCache, imageCache }
}

export const updateIntegrationResult = async (
  payload: BasePayload,
  id: string | number,
  error?: unknown,
) => {
  await payload.update({
    collection: 'integration',
    id: id,
    data: {
      status: {
        erfolg: error ? 'Fehlgeschlagen' : 'Erfolgreich',
        last_import_date: new Date().toISOString(),
        import_log: error ? `Fehler beim Import: ${error}` : '',
      },
    },
  })
}

export const getImageFromPayloadOrFetchFromRemote = async (
  payload: BasePayload,
  imageUrl: string,
  fileName: string,
  kommuneId: string,
  imageCache?: ImageCache,
) => {
  let persistedImage: Veranstaltungsmedien | undefined

  if (imageCache) {
    persistedImage = imageCache.get(imageUrl)
  } else {
    const { docs } = await payload.find({
      collection: 'veranstaltungsmedien',
      where: {
        kommune: { equals: kommuneId },
        sourceUrl: { equals: imageUrl },
      },
    })
    persistedImage = docs[0]
  }

  if (!persistedImage) {
    const response = await fetch(imageUrl)

    if (!response.ok) {
      throw Error('Could not fetch image from endpoint')
    }

    const arrayBuffer = await response.arrayBuffer()

    const created = await payload.create({
      collection: 'veranstaltungsmedien',
      file: {
        data: Buffer.from(arrayBuffer),
        mimetype: response.headers.get('content-type') ?? 'image/*',
        name: fileName,
        size: arrayBuffer.byteLength,
      },
      data: { sourceUrl: imageUrl, kommune: kommuneId },
    })
    if (imageCache) {
      imageCache.set(imageUrl, created)
    }
    return created
  }

  return persistedImage
}

export const resolveKommuneId = (kommune: string | Kommune) =>
  typeof kommune === 'string' ? kommune : kommune.id
