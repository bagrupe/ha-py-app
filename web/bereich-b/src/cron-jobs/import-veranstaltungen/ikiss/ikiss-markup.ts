const escapeHtml = (value: string) =>
  value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;')

const LINK_TYPE_MAIL = '3'
const LINK_TYPE_MEDIA = '4'

// iKISS puts markup into link texts (e.g. i_lt="<br>"); only its text is shown.
const markupText = (document: Document, markup: string): string => {
  const template = document.createElement('template')
  template.innerHTML = markup
  return template.content.textContent ?? ''
}

const renderIkissElement = (element: Element): Node => {
  const document = element.ownerDocument
  const attribute = (name: string) => element.getAttribute(name) ?? ''
  const linkText = markupText(document, attribute('i_lt'))

  if (attribute('i_mod') === 'med' && attribute('i_tp') !== LINK_TYPE_MEDIA && attribute('i_id')) {
    const image = document.createElement('img')
    image.setAttribute('src', attribute('i_id'))
    return image
  }
  if (attribute('i_tp') === LINK_TYPE_MAIL && attribute('i_ma')) {
    const anchor = document.createElement('a')
    anchor.setAttribute('href', `mailto:${attribute('i_ma')}`)
    anchor.textContent = linkText || attribute('i_ma')
    return anchor
  }
  return document.createTextNode(linkText)
}

export const renderIkissElements = (root: ParentNode): void => {
  for (const element of Array.from(root.querySelectorAll('ikiss'))) {
    // HTML ignores `/>` on unknown elements, so everything after `<ikiss … />` is parsed as its children.
    element.after(...Array.from(element.childNodes))
    element.replaceWith(renderIkissElement(element))
  }
}

export const paragraph = (text: string) => `<p>${escapeHtml(text)}</p>`
