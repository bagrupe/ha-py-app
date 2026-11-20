import { load, type CheerioAPI } from 'cheerio'

export type NolisCaptionExtraction = {
  contentHtml: string
  caption?: string
}

const blockElements = new Set([
  'address',
  'article',
  'aside',
  'blockquote',
  'div',
  'footer',
  'header',
  'main',
  'p',
  'section',
])

const captionPrefix =
  /^(?:(?:bild(?:unterschrift|nachweis)?)(?:\s*\d+)?|foto(?:s)?|text\s+und\s+foto(?:s)?|copyright(?:\s+foto)?)[\s:–-]/i
const brSeparator = /(?:\s*<br\s*\/?>\s*)+/gi

const normalizeText = (value: string): string => value.replaceAll(/\s+/g, ' ').trim()

const htmlToText = (html: string): string => normalizeText(load(html, null, false).text())

const creditEnd =
  /©\s*(?:(?:fotos?|bild)\b\s*:?\s*[^\s©]+(?:\s+[^\s©]+){0,5}|[^\s©]+(?:\s+[^\s©]+)?)\s*$/i
const creditSplit = /^.*?©\s*(?:(?:fotos?|bild)\b\s*:?\s*)?[^\s©]+(?:\s+[^\s©]+)?/is
const maxCaptionLength = 600

const endsWithCredit = (text: string): boolean =>
  text.length <= maxCaptionLength && creditEnd.test(text)

const isCaptionText = (value: string): boolean => {
  const text = normalizeText(value)
  return captionPrefix.test(text) || endsWithCredit(text)
}

type BrExtraction = { kind: 'none' } | { kind: 'caption'; contentHtml: string; caption: string }

const extractAfterBreak = (html: string): BrExtraction => {
  const matches = Array.from(html.matchAll(brSeparator))
  if (matches.length === 0) return { kind: 'none' }

  const parts: { text: string; separator: string }[] = []
  let start = 0
  let separator = ''
  for (const match of matches) {
    const index = match.index ?? 0
    parts.push({ text: html.slice(start, index), separator })
    start = index + match[0].length
    separator = match[0]
  }
  parts.push({ text: html.slice(start), separator })

  const isCaption = parts.map(() => false)

  let index = parts.length - 1
  while (index >= 0 && htmlToText(parts[index].text) === '') index--
  while (index > 0 && isCaptionText(htmlToText(parts[index].text))) {
    isCaption[index] = true
    index--
    while (index > 0 && htmlToText(parts[index].text) === '') index--
  }

  for (let i = 1; i < parts.length; i++) {
    const text = htmlToText(parts[i].text)
    if (endsWithCredit(text)) isCaption[i] = true
  }

  if (!isCaption.includes(true)) return { kind: 'none' }

  const kept = parts.filter((_, i) => !isCaption[i])
  const contentHtml = kept
    .map((part, i) => (i === 0 ? part.text : part.separator + part.text))
    .join('')
    .trimEnd()
  const caption = htmlToText(parts[isCaption.indexOf(true)].text)

  return { kind: 'caption', contentHtml, caption }
}

const extractFromBlockElements = (
  $: CheerioAPI,
): { kind: 'none' } | { kind: 'caption'; caption: string } => {
  const root = $.root()
  const children = root
    .contents()
    .toArray()
    .filter((node) => node.type !== 'text' || normalizeText(node.data) !== '')
  const trailingCaptions: (typeof children)[number][] = []

  for (let index = children.length - 1; index >= 0; index--) {
    const node = children[index]
    if (node.type !== 'tag' || !blockElements.has(node.name.toLowerCase())) break
    if ($(node).find('br').length > 0) break

    const text = normalizeText($(node).text())
    if (!isCaptionText(text)) break
    trailingCaptions.unshift(node)
  }

  if (trailingCaptions.length > 0) {
    const caption = normalizeText($(trailingCaptions[0]).text())
    for (const node of trailingCaptions) $(node).remove()
    return { kind: 'caption', caption }
  }

  const last = children.at(-1)
  if (last?.type !== 'tag' || !blockElements.has(last.name.toLowerCase())) {
    return { kind: 'none' }
  }

  const element = $(last)
  const result = extractAfterBreak(element.html() ?? '')
  if (result.kind === 'caption') element.html(result.contentHtml)
  return result.kind === 'caption' ? { kind: 'caption', caption: result.caption } : result
}

export const extractNolisImageCaption = (
  contentHtml: string,
  hasPreviewImage: boolean,
): NolisCaptionExtraction => {
  if (contentHtml.trim() === '') {
    return { contentHtml }
  }

  const $ = load(contentHtml, null, false)
  const blockResult = extractFromBlockElements($)
  const hasBlockElements = $.root()
    .children()
    .toArray()
    .some((node) => blockElements.has(node.name.toLowerCase()))
  const result =
    blockResult.kind === 'caption'
      ? { ...blockResult, contentHtml: $.root().html() ?? '' }
      : hasBlockElements
        ? ({ kind: 'none' } as const)
        : extractAfterBreak(contentHtml)

  if (result.kind === 'none' || htmlToText(result.contentHtml) === '') {
    return { contentHtml }
  }

  const credits = result.caption.split('©').length - 1
  const caption =
    credits > 1 ? (creditSplit.exec(result.caption)?.[0].trim() ?? result.caption) : result.caption
  return { contentHtml: result.contentHtml, caption: hasPreviewImage ? caption : undefined }
}
