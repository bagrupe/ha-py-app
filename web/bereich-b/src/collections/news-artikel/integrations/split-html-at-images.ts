export type HtmlSegment = { type: 'html'; value: string } | { type: 'image'; src: string }

const MEDIA_SELECTOR = 'br, hr, img, iframe, video, table'

const hasContent = (element: Element) =>
  element.hasChildNodes() &&
  (element.textContent?.trim() !== '' || element.querySelector(MEDIA_SELECTOR) !== null)

const removeEmptyDescendants = (root: ParentNode) => {
  for (const element of Array.from(root.querySelectorAll('*')).reverse()) {
    if (element.closest('table')) continue
    if (!hasContent(element) && !element.matches(MEDIA_SELECTOR)) element.remove()
  }
}

const imageAnchor = (img: Element): Element => {
  const parent = img.parentElement
  const onlyHoldsImage =
    parent?.tagName === 'A' && parent.children.length === 1 && parent.textContent?.trim() === ''
  return onlyHoldsImage ? parent : img
}

const toHtmlSegment = (container: Element): HtmlSegment[] => {
  removeEmptyDescendants(container)
  return hasContent(container) ? [{ type: 'html', value: container.innerHTML }] : []
}

export const splitHtmlAtImages = (document: Document): HtmlSegment[] => {
  const { body } = document
  const segments: HtmlSegment[] = []

  for (const img of Array.from(body.querySelectorAll('img'))) {
    const anchor = imageAnchor(img)
    const range = document.createRange()
    range.setStart(body, 0)
    range.setEndBefore(anchor)

    const container = document.createElement('div')
    container.append(range.extractContents())
    segments.push(...toHtmlSegment(container))
    segments.push({ type: 'image', src: img.getAttribute('src') ?? '' })
    anchor.remove()
  }

  segments.push(...toHtmlSegment(body))
  return segments
}
