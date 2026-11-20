import { type BasePayload } from 'payload'
import { type Integration } from '../../../../payload-types'
import { type UpsertStats } from '../../../../dataseeder/upsert-stats'
import { upsert } from '../../../../dataseeder/upsert'
import { htmlToLexical, getDefaultEditorConfig } from '../../../../lib/html-to-lexical'
import {
  getImageFromPayloadOrFetchFromRemote,
  resolveKommuneId,
  updateIntegrationResult,
  prefetchImporterCaches,
} from '../common'
import { resolveAnchorsInHtml } from '../resolve-anchors'
import { fetchRSSResponse } from './rss-client'
import { customContentField, itemSchema, rssSchema } from './rss-schema'

export const rssImport = async (
  payload: BasePayload,
  integration: Integration,
  stats?: UpsertStats,
) => {
  const maybeJsonResponse = await fetchRSSResponse(integration.url)

  const rssJson = await rssSchema.safeParseAsync(maybeJsonResponse)

  if (!rssJson.success && !rssJson.data) {
    const errorMessage = `Feed konnte nicht geparsed werden: ${rssJson.error}`
    await updateIntegrationResult(payload, integration.id, errorMessage)
    return
  }

  if (!integration.kommune) {
    throw new Error(`Kommune is not set on integration: ${integration.id}`)
  }
  const kommune = integration.kommune

  const { channel } = rssJson.data.rss
  const items = channel.item
  const errorMessages = []

  const { articleCache, imageCache } = await prefetchImporterCaches(payload, kommune)

  for (const item of items) {
    const safeItemSchema = itemSchema.and(
      customContentField(integration.konfiguration?.content ?? 'content'),
    )

    const safeItemParseResult = await safeItemSchema.safeParseAsync(item)

    if (safeItemParseResult.error) {
      errorMessages.push(safeItemParseResult.error)
      continue
    }

    const { data } = safeItemParseResult
    let titelBild
    if (data.enclosure?.url) {
      const imageUrl = data.enclosure.url
      const fileName = imageUrl.split('/').at(-1)?.split('?').at(0) ?? 'kein Name'

      titelBild = await getImageFromPayloadOrFetchFromRemote(
        payload,
        imageUrl,
        fileName,
        resolveKommuneId(kommune),
        imageCache,
      )
    }

    const editorConfig = await getDefaultEditorConfig(payload.config)
    const lexicalContent = htmlToLexical(
      resolveAnchorsInHtml(data.content, item.link ?? channel.link),
      editorConfig,
    )
    const block = {
      blockType: 'rich-text' as const,
      content: lexicalContent,
    }

    await upsert(
      {
        collection: 'news-artikel',
        key: ['importId', 'kommune'],
        data: {
          titel: item.subtitle ? `${item.title} - ${item.subtitle}` : item.title,
          // Zumindest aus dem Bad-Pyrmont-Feed wissen wir, dass die guid nicht immer eindeutig ist, was zu
          // Dubletten führen kann. Als Ersatz können wir das optionale "link"-Feld abrufen, welches i.d.R.
          // einen Permalink zur Artikelquelle darstellt und somit zur Feststellung eines bereits importierten
          // Artikels genutzt werden kann.
          importId: item.link ?? item.guid.value,
          kommune: kommune,
          untereinheit: integration.untereinheit,
          _status: new Date(item.pubDate) < new Date() ? 'published' : 'draft',
          titelbilder: titelBild && [
            {
              bild: titelBild.id,
              id: titelBild.id,
            },
          ],
          teaser: item.description,
          datum: new Date(item.pubDate).toISOString(),
          inhalte: [block],
          ordinal: 0,
          integration: integration.id,
        },
      },
      { cache: articleCache, stats },
    )
  }

  const errorMessage =
    errorMessages.length !== 0
      ? `Feed enthält Items, die nicht geparst werden konnten: ${JSON.stringify(errorMessages)}`
      : undefined

  await updateIntegrationResult(payload, integration.id, errorMessage)
}
