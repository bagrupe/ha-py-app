import * as Sentry from '@sentry/nextjs'
import { decode } from 'html-entities'
import { type BasePayload } from 'payload'
import {
  type ImageBlockVeranstaltungsmedien,
  type RichTextBlock,
  type Veranstaltungsmedien,
} from '../../../../payload-types'
import { type IkissIntegration } from '../../../../integrations/ikiss/ikiss-integration'
import { type UpsertCache, upsert } from '../../../../dataseeder/upsert'
import { type UpsertStats } from '../../../../dataseeder/upsert-stats'
import { htmlToPlain } from '../../../../utils/html'
import { htmlToLexical, getDefaultEditorConfig } from '../../../../lib/html-to-lexical'
import { type ImageCache, updateIntegrationResult, prefetchImporterCaches } from '../common'
import { resolveAnchors } from '../resolve-anchors'
import { splitHtmlAtImages } from '../split-html-at-images'
import {
  createIKissRequest,
  decodeIkissResponse,
  fetchIKissResponse,
} from '../../../../integrations/ikiss/ikiss-client'
import { getImageById } from '../../../../integrations/ikiss/ikiss-images'
import {
  IKISS_TIME_ZONE,
  parseIkissTimestamp,
} from '../../../../cron-jobs/import-veranstaltungen/ikiss/ikiss-dates'
import {
  type IKissFetchSettings,
  type IKissSearchSettings,
} from '../../../../integrations/ikiss/ikiss-request-types'
import {
  type ContentResponse,
  type RichText,
} from '../../../../integrations/ikiss/ikiss-response-types'
import {
  ikissXmlBuilder,
  ikissXmlParser,
  isReleased,
  stripCdata,
} from '../../../../integrations/ikiss/ikiss-xml'

function firstParagraphAfter(element: Element): HTMLParagraphElement | null {
  const followingFlag = element.ownerDocument.defaultView?.Node.DOCUMENT_POSITION_FOLLOWING ?? 4
  const paragraphs = Array.from(element.ownerDocument.querySelectorAll('p'))
  return (
    paragraphs.find((paragraph) => element.compareDocumentPosition(paragraph) & followingFlag) ??
    null
  )
}

function removeElementAndEmptyAncestors(element: Element, root: Element): void {
  let parent = element.parentElement
  element.remove()

  while (
    parent &&
    parent !== root &&
    parent.children.length === 0 &&
    parent.textContent?.trim() === ''
  ) {
    const nextParent = parent.parentElement
    parent.remove()
    parent = nextParent
  }
}

function extractTeaserAndRemoveIntro(document: Document): string {
  const firstH1 = document.querySelector('h1')
  const teaserParagraph = firstH1 ? firstParagraphAfter(firstH1) : document.querySelector('p')
  const teaserText = teaserParagraph ? htmlToPlain(teaserParagraph.outerHTML) : ''

  if (firstH1) {
    removeElementAndEmptyAncestors(firstH1, document.body)
    if (teaserParagraph) {
      removeElementAndEmptyAncestors(teaserParagraph, document.body)
    }
  }

  return teaserText
}

const sixMonthAgo: Date = new Date(new Date().setMonth(new Date().getMonth() - 6))

export const iKissImport = async (
  payload: BasePayload,
  integration: IkissIntegration,
  stats?: UpsertStats,
) => {
  if (!integration.kommune) {
    throw new Error('Integration is missing required kommune field')
  }
  const kommune = integration.kommune

  const errors: { articleId: string; error: string }[] = []
  let totalArticles = 0
  let succeeded = 0

  const { articleCache, imageCache } = await prefetchImporterCaches(payload, kommune)

  for (const kategorie of integration.konfiguration?.kategorien ?? []) {
    if (!kategorie.kategorie) {
      throw `Required field Id of Kategorie is not set on integration: ${kommune}`
    }

    const articles = await getArticles(kategorie.kategorie, integration)
    totalArticles += articles.length

    for (const id of articles) {
      try {
        await getArticleByIdAndUpload(
          payload,
          id,
          kategorie?.gewichtung ?? 0,
          integration,
          articleCache,
          imageCache,
          stats,
        )
        succeeded++
      } catch (e) {
        errors.push({ articleId: id, error: String(e) })
        payload.logger.error(
          { articleId: id, kommune: kommune, error: String(e) },
          'Failed to import article %s',
          id,
        )
        Sentry.captureException(e, {
          tags: {
            module: 'import-ikiss',
            articleId: id,
            kommune: String(kommune),
          },
        })
      }
    }
  }

  payload.logger.info(
    {
      total: totalArticles,
      succeeded,
      failed: errors.length,
      kommune: kommune,
    },
    'iKISS import complete: %d/%d succeeded, %d failed',
    succeeded,
    totalArticles,
    errors.length,
  )

  if (errors.length > 0) {
    const summary = errors.map((e) => `${e.articleId} (${e.error.substring(0, 80)})`).join(', ')
    Sentry.captureMessage(`iKISS import: ${errors.length}/${totalArticles} articles failed`, {
      level: 'error',
      tags: { module: 'import-ikiss', kommune: String(kommune) },
      extra: { errors },
    })
    throw `${errors.length} of ${totalArticles} articles failed: ${summary}`
  }
}

export const getArticles = async (filterCategory: string, integration: IkissIntegration) => {
  const searchSettings: IKissSearchSettings = {
    set_language: 'de',
    set_include_sub_categories: 1,
    set_search_params: {
      categorie: filterCategory,
    },
    search_result_format: 'object_id, object_title, title, description, data_content, author, date',
  }

  const newsAktuellesQuery = createIKissRequest(
    'search',
    'content',
    'full',
    {
      name: integration.benutzername,
      password: integration.passwort,
    },
    searchSettings,
  )

  const xmlResponseAktuellesNews = await fetchIKissResponse(
    integration.url,
    ikissXmlBuilder.build(newsAktuellesQuery),
  )

  if (!xmlResponseAktuellesNews) {
    console.warn('Could not fetch IKISSResponse')
    return []
  }

  const xmlResponseAktuellesNewsText = await decodeIkissResponse(xmlResponseAktuellesNews)

  const responseAktuellesNewsJson: ContentResponse = ikissXmlParser.parse(
    xmlResponseAktuellesNewsText,
  )

  let newsJson = responseAktuellesNewsJson?.ikiss?.result?.tcontent_list?.tcontent ?? []

  newsJson = Array.isArray(newsJson) ? newsJson : [newsJson]

  const newsAktuellesObjectIds: string[] = []
  newsJson.forEach((n) => {
    const articleDate = parseIkissTimestamp(n.date, IKISS_TIME_ZONE)
    if (articleDate && articleDate > sixMonthAgo) {
      newsAktuellesObjectIds.push(n.object_id)
    }
  })

  return newsAktuellesObjectIds
}

export const getArticleByIdAndUpload = async (
  payload: BasePayload,
  id: string,
  ordinal: number,
  integration: IkissIntegration,
  articleCache?: UpsertCache,
  imageCache?: ImageCache,
  stats?: UpsertStats,
) => {
  if (!integration.kommune) {
    throw new Error('Integration is missing required kommune field')
  }
  const kommune = integration.kommune

  const fetchSettings: IKissFetchSettings = {
    set_fetch_mask: 33,
    set_data: {
      id: id,
    },
    set_include_sub_categories: 3,
    set_language: 'de',
  }

  const fetchArticleByIdQuery = createIKissRequest(
    'fetch',
    'content',
    'full',
    {
      name: integration.benutzername,
      password: integration.passwort,
    },
    fetchSettings,
  )

  const xmlResponseArticle = await fetchIKissResponse(
    integration.url,
    ikissXmlBuilder.build(fetchArticleByIdQuery),
  )

  const xmlResponseArticleText = await decodeIkissResponse(xmlResponseArticle)
  const responseArticleJson: ContentResponse = ikissXmlParser.parse(xmlResponseArticleText)

  const articleJson = responseArticleJson.ikiss.result.tcontent

  if (articleJson && isReleased(articleJson.release)) {
    const { JSDOM } = await import('jsdom')
    const baseUrl = integration.url
    const baseImageUrl = baseUrl + '/media/custom'
    const importImage = async (imageId: string) => {
      const resolution = await getImageById(payload, imageId, baseImageUrl, integration, imageCache)
      if (resolution.status === 'failed') {
        payload.logger.warn(
          { articleId: id, imageId, error: String(resolution.error) },
          'Skipping image %s of iKISS article %s: %s',
          imageId,
          id,
          String(resolution.error),
        )
      }
      return resolution.status === 'imported' ? resolution.image : undefined
    }

    // stripCdata handles both CDATA-wrapped and raw HTML content
    const htmlContent = stripCdata(String(articleJson.data_content))

    // Parse HTML to extract images and split content into segments
    const dom = new JSDOM(htmlContent)
    const doc = dom.window.document

    const teaserText = extractTeaserAndRemoveIntro(doc)
    resolveAnchors(doc.body, baseUrl)

    const editorConfig = await getDefaultEditorConfig(payload.config)
    const inhalteBlocks: (RichTextBlock | ImageBlockVeranstaltungsmedien)[] = []

    const htmlSegments = splitHtmlAtImages(doc)

    for (const segment of htmlSegments) {
      if (segment.type === 'html') {
        const lexicalContent = htmlToLexical(segment.value, editorConfig)
        inhalteBlocks.push({ blockType: 'rich-text', content: lexicalContent } as RichTextBlock)
      } else {
        const imageIdMatch = segment.src.match(/\d+_\d+_\d+/)
        if (imageIdMatch) {
          const imageId = imageIdMatch[0].replace(/_/g, '.')
          const image = await importImage(imageId)
          if (image) {
            inhalteBlocks.push({
              blockType: 'image-veranstaltungsmedien',
              image: image.id,
            } as ImageBlockVeranstaltungsmedien)
          }
        }
      }
    }

    const image_ids = articleJson?.tLayout?.rand_bilder
      ? [articleJson?.tLayout?.rand_bilder]
      : articleJson?.tLayout?.trand_bilder_list?.rand_bilder

    const images: Veranstaltungsmedien[] = []
    if (image_ids) {
      for (const image_id of image_ids) {
        const image = await importImage(image_id)
        if (image) images.push(image)
      }
    }

    const title = htmlToPlain(decode(stripCdata(String(articleJson.tTpFields.title))))
    const date = parseIkissTimestamp(articleJson.date, IKISS_TIME_ZONE)?.toISOString()

    const sanitizedInhalte = inhalteBlocks

    await upsert(
      {
        collection: 'news-artikel',
        key: ['importId', 'kommune'],
        data: {
          titel: title,
          importId: id,
          kommune: kommune,
          untereinheit: integration.untereinheit,
          _status: 'published',
          teaser: teaserText,
          datum: date,
          inhalte: sanitizedInhalte as (RichTextBlock | ImageBlockVeranstaltungsmedien)[],
          titelbilder:
            images.map((image) => ({
              bild: image.id,
              id: image.id,
            })) ?? [],
          ordinal: ordinal,
          integration: integration.id,
        },
      },
      { cache: articleCache, stats },
    )
  } else if (articleJson) {
    // No longer released in iKISS: remove an existing local record so it stops
    // being publicly visible. If none exists the article was never imported
    // (the never-released case) and nothing is created.
    const { docs } = await payload.find({
      collection: 'news-artikel',
      where: {
        and: [{ importId: { equals: id } }, { kommune: { equals: kommune } }],
      },
      limit: 1,
      depth: 0,
    })
    const existing = docs[0]
    if (existing) {
      await payload.delete({ collection: 'news-artikel', id: existing.id })
      payload.logger.info({ articleId: id, kommune }, 'Removed unreleased iKISS article %s', id)
    } else {
      payload.logger.info({ articleId: id, kommune }, 'Skipping unreleased iKISS article %s', id)
    }
  }
  await updateIntegrationResult(payload, integration.id)
}

export const getTeaserText = (content: RichText): string => {
  const p = content.find((subContent) => subContent.type === 'p')
  const teaser = p ? p.children[0].text : ''
  return teaser
}
