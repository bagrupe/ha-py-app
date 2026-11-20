import { type BasePayload } from 'payload'
import { type Integration } from '../../../../payload-types'
import { type UpsertStats } from '../../../../dataseeder/upsert-stats'
import { htmlToLexical, getDefaultEditorConfig } from '../../../../lib/html-to-lexical'
import { upsert } from '../../../../dataseeder/upsert'
import { htmlToPlain, wrapContentInParagraph } from '../../../../utils/html'
import {
  getImageFromPayloadOrFetchFromRemote,
  resolveKommuneId,
  updateIntegrationResult,
  prefetchImporterCaches,
} from '../common'
import { fetchNolisResponse } from './nolis-client'
import { extractNolisImageCaption } from './nolis-caption'

export type NolisIntegration = {
  url: string
  token: string
  type: string
} & Omit<Integration, 'zugangsdaten'>

export const nolisImport = async (
  payload: BasePayload,
  integration: NolisIntegration,
  stats?: UpsertStats,
) => {
  if (!integration.kommune) {
    throw new Error(`Kommune is not set on integration: ${integration.id}`)
  }
  const kommune = integration.kommune

  const response = await fetchNolisResponse(integration.url, integration.token, integration.type)

  const { articleCache, imageCache } = await prefetchImporterCaches(payload, kommune)

  for (const article of response.data ?? []) {
    let titelBild
    if (article.vorschaubild) {
      const imageUrl = article.vorschaubild
      const fileName = imageUrl.split('/').at(-1)?.split('?').at(0) ?? 'kein Name'

      titelBild = await getImageFromPayloadOrFetchFromRemote(
        payload,
        imageUrl,
        fileName,
        resolveKommuneId(kommune),
        imageCache,
      )
    }

    const extractedCaption = extractNolisImageCaption(
      article.mitteilungsinhalt_html,
      Boolean(titelBild),
    )

    const seitenId = integration.konfiguration?.artikelSeitenId
    const originalUrl = seitenId
      ? new URL(`/portal/meldungen/artikel-${article.id}-${seitenId}.html`, integration.url)
      : undefined

    const editorConfig = await getDefaultEditorConfig(payload.config)
    const inhalt = htmlToLexical(wrapContentInParagraph(extractedCaption.contentHtml), editorConfig)

    const teaser = htmlToPlain(article.anreisser)

    await upsert(
      {
        collection: 'news-artikel',
        key: ['importId', 'kommune'],
        data: {
          titel: article.titel,
          importId: article.id,
          kommune: kommune,
          untereinheit: integration.untereinheit,
          _status: new Date(article.veroeffentlichungsdatum) < new Date() ? 'published' : 'draft',
          teaser,
          originalUrl: originalUrl?.toString(),
          titelbilder: titelBild && [
            {
              bild: titelBild.id,
              id: titelBild.id,
              bildunterschrift: extractedCaption.caption,
            },
          ],
          datum: new Date(article.veroeffentlichungsdatum).toISOString(),

          inhalte: [
            {
              blockType: 'rich-text',
              content: inhalt,
            },
          ],
          ordinal: 0,
          integration: integration.id,
        },
      },
      { cache: articleCache, stats },
    )
  }
  await updateIntegrationResult(payload, integration.id)
}
