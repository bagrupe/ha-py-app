import { load } from 'cheerio'

const inlineElements = new Set([
  'a',
  'abbr',
  'b',
  'bdi',
  'bdo',
  'br',
  'button',
  'cite',
  'code',
  'data',
  'dfn',
  'em',
  'i',
  'input',
  'kbd',
  'label',
  'mark',
  'q',
  'ruby',
  's',
  'samp',
  'small',
  'span',
  'strong',
  'sub',
  'sup',
  'time',
  'u',
  'var',
])

export const containsOnlyInlineElementsOrText = (html: string): boolean => {
  const $ = load(html)
  const root = $('body')

  let onlyInlineContent = true

  root.contents().each((_, element) => {
    if (element.type === 'text') return
    if (element.type === 'tag' && inlineElements.has(element.name)) return
    onlyInlineContent = false
    return false
  })

  return onlyInlineContent
}

/**
 * Optionally wraps the html string in a paragraph tag if the given html only contains text or inline nodes.
 */
export const wrapContentInParagraph = (html: string) => {
  if (containsOnlyInlineElementsOrText(html)) {
    return `<p>${html}</p>`
  }

  return html
}

export function htmlToPlain(html: string) {
  const $ = load(html)

  function processNode(node: Node) {
    if (node.type === 'text') {
      return node.data
    }

    if (node.type === 'tag') {
      const tag = node.name.toLowerCase()
      let text = ''

      if (tag === 'br') {
        return '\n'
      }

      for (const child of node.children || []) {
        text += processNode(child)
      }

      return text
    }

    return ''
  }

  let output = ''
  const children = $.root()[0].children

  type Node = (typeof children)[0]

  for (const node of children) {
    output += processNode(node)
  }

  return output
    .split('\n')
    .map((s) => s.trim().replaceAll(/\s+/g, ' '))
    .filter(Boolean)
    .join('\n')
}
