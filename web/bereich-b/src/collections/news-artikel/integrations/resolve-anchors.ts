import { JSDOM } from 'jsdom'

const HAS_SCHEME = /^[a-z][a-z\d+.-]*:/i

const absolutize = (href: string, baseUrl: string): string => {
  if (HAS_SCHEME.test(href) || href.startsWith('#')) return href
  try {
    return new URL(href, baseUrl).toString()
  } catch {
    return href
  }
}

const unwrap = (anchor: Element) => anchor.replaceWith(...Array.from(anchor.childNodes))

/**
 * Payload's lexical link hook URI-encodes anything that fails its URL validation,
 * so relative hrefs must be absolute before they reach the editor state.
 * Anchors without a usable href carry no destination and are replaced by their content.
 */
export const resolveAnchors = (root: ParentNode, baseUrl: string): void => {
  for (const anchor of Array.from(root.querySelectorAll('a'))) {
    const href = anchor.getAttribute('href')?.trim() ?? ''
    if (href === '') {
      unwrap(anchor)
      continue
    }
    anchor.setAttribute('href', absolutize(href, baseUrl))
  }
}

export const resolveAnchorsInHtml = (html: string, baseUrl: string): string => {
  const { body } = new JSDOM(html).window.document
  resolveAnchors(body, baseUrl)
  return body.innerHTML
}
