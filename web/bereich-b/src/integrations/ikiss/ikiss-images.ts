import { type BasePayload } from 'payload'
import parseInt from 'lodash/parseInt'
import { type Veranstaltungsmedien } from '../../payload-types'
import {
  type ImageCache,
  getImageFromPayloadOrFetchFromRemote,
  resolveKommuneId,
} from '../../collections/news-artikel/integrations/common'
import { createIKissRequest, decodeIkissResponse, fetchIKissResponse } from './ikiss-client'
import { type IkissIntegration } from './ikiss-integration'
import { type IKissFetchSettings } from './ikiss-request-types'
import { type ContentResponse, type Tdata } from './ikiss-response-types'
import { ikissXmlBuilder, ikissXmlParser } from './ikiss-xml'

export type IkissImageResolution =
  | { status: 'imported'; image: Veranstaltungsmedien }
  | { status: 'notAnImage' }
  | { status: 'failed'; error: unknown }

// iKISS media can be documents (e.g. a PDF attached as an event image ! Edge case but has happened); only these are importable.
const IMAGE_PATH = /\.(png|jpe?g|gif|webp)(\?|$)/i
// iKISS renders every image as _t, _k, _m, _g and _r; _r is the large one.
const LARGE_RENDITION_PATH = /_r\.\w+(\?|$)/

const pickImagePath = (files: Tdata[]): string | undefined => {
  const images = files.filter(({ media_path }) => IMAGE_PATH.test(media_path))
  const largeRendition = images.find(({ media_path }) => LARGE_RENDITION_PATH.test(media_path))
  const widest = images.sort((a, b) => parseInt(b.width, 10) - parseInt(a.width, 10))[0]
  return (largeRendition ?? widest)?.media_path
}

export const getImageById = async (
  payload: BasePayload,
  imageId: string | undefined,
  baseImageUrl: string,
  integration: IkissIntegration,
  imageCache?: ImageCache,
): Promise<IkissImageResolution> => {
  if (!imageId) {
    return { status: 'notAnImage' }
  }

  try {
    if (!integration.kommune) {
      throw new Error('iKISS integration has no Kommune')
    }

    const fetchSettings: IKissFetchSettings = {
      set_fetch_mask: 2,
      set_data: {
        id: imageId,
      },
      set_include_sub_categories: 3,
      set_language: 'de',
    }
    const mediaQuery = createIKissRequest(
      'fetch',
      'media',
      'full',
      {
        name: integration.benutzername,
        password: integration.passwort,
      },
      fetchSettings,
    )

    const mediaResponse = await fetchIKissResponse(
      integration.url,
      ikissXmlBuilder.build(mediaQuery),
    )
    if (!mediaResponse.ok) {
      throw new Error(`iKISS media fetch responded with HTTP ${mediaResponse.status}`)
    }

    const responseJson: ContentResponse = ikissXmlParser.parse(
      await decodeIkissResponse(mediaResponse),
    )
    const files = responseJson.ikiss.result.tmedia?.tdata_list.tdata ?? []
    const mediaPath = pickImagePath(Array.isArray(files) ? files : [files])
    if (!mediaPath) {
      payload.logger.info({ imageId }, 'Skipped iKISS media %s: not an image', imageId)
      return { status: 'notAnImage' }
    }

    const imageUrl = baseImageUrl + mediaPath
    const fileName = imageUrl.split('/').at(-1)?.split('?').at(0) ?? 'kein Name'
    const image = await getImageFromPayloadOrFetchFromRemote(
      payload,
      imageUrl,
      fileName,
      resolveKommuneId(integration.kommune),
      imageCache,
    )
    return { status: 'imported', image }
  } catch (error) {
    return { status: 'failed', error }
  }
}
