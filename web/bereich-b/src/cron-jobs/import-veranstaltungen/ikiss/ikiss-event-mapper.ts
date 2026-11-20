import { type SanitizedConfig } from 'payload'
import { type IkissEvent } from '../../../integrations/ikiss/ikiss-events'
import { type IkissImageResolution } from '../../../integrations/ikiss/ikiss-images'
import { resolveAnchors } from '../../../collections/news-artikel/integrations/resolve-anchors'
import { splitHtmlAtImages } from '../../../collections/news-artikel/integrations/split-html-at-images'
import { getDefaultEditorConfig, htmlToLexical } from '../../../lib/html-to-lexical'
import { resolveEventPeriod } from './ikiss-dates'
import { paragraph, renderIkissElements } from './ikiss-markup'

export type IkissEventMappingContext = {
  kommuneId: string
  quelleId: string
  baseUrl: string
  timeZone: string
  payloadConfig?: SanitizedConfig
  resolveImage: (imageId: string) => Promise<IkissImageResolution>
}

const normalizeWhitespace = (text: string) => text.replace(/\s+/g, ' ').trim()

const MEDIA_ID = /\d+[._]\d+[._]\d+/

const toMediaId = (reference: string): string | undefined =>
  MEDIA_ID.exec(reference)?.[0].replace(/_/g, '.')

type Inhalt =
  | { blockType: 'rich-text'; content: unknown }
  | { blockType: 'image-veranstaltungsmedien'; image: string }

const buildInhalte = async (
  event: IkissEvent,
  { baseUrl, payloadConfig, resolveImage }: IkissEventMappingContext,
): Promise<Inhalt[]> => {
  const { JSDOM } = await import('jsdom')
  const { document } = new JSDOM(event.content ?? '').window
  renderIkissElements(document.body)

  const bodyText = normalizeWhitespace(document.body.textContent ?? '')
  const trailingParagraphs = [event.priceInfo, event.contact]
    .filter((text): text is string => !!text && !bodyText.includes(normalizeWhitespace(text)))
    .map(paragraph)
  document.body.insertAdjacentHTML('beforeend', trailingParagraphs.join('\n'))

  resolveAnchors(document.body, baseUrl)

  const editorConfig = await getDefaultEditorConfig(payloadConfig as SanitizedConfig)
  const inhalte: Inhalt[] = []
  for (const segment of splitHtmlAtImages(document)) {
    if (segment.type === 'html') {
      inhalte.push({ blockType: 'rich-text', content: htmlToLexical(segment.value, editorConfig) })
      continue
    }
    const mediaId = toMediaId(segment.src)
    if (!mediaId) continue
    const resolution = await resolveImage(mediaId)
    if (resolution.status === 'imported') {
      inhalte.push({ blockType: 'image-veranstaltungsmedien', image: resolution.image.id })
    }
  }
  return inhalte
}

export const isIkissEventVisible = (
  event: Pick<IkissEvent, 'released' | 'datetimeFrom' | 'datetimeTo'>,
  timeZone: string,
): boolean => !!event.released && !!resolveEventPeriod(event, timeZone)

export const mapIkissEventToVeranstaltung = async (
  event: IkissEvent,
  context: IkissEventMappingContext,
): Promise<Record<string, unknown>> => {
  const period = resolveEventPeriod(event, context.timeZone)

  const coverMediaId = event.image && toMediaId(event.image)
  const cover = coverMediaId ? await context.resolveImage(coverMediaId) : undefined
  const coverId = cover?.status === 'imported' ? cover.image.id : null

  return {
    id: event.id,
    titel: event.title,
    teaser: event.shortContent ?? null,
    visible: isIkissEventVisible(event, context.timeZone),
    timeAndLocation: {
      locationName: event.location ?? null,
      dates: period ? [{ start: period.start.toISOString(), end: period.end.toISOString() }] : [],
    },
    inhalte: await buildInhalte(event, context),
    ...(cover?.status !== 'failed' && { titelbild: { external: false, internal: coverId } }),
    source: [context.quelleId],
    kommune: context.kommuneId,
  }
}
