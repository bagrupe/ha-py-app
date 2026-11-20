import { htmlToSlate, payloadHtmlToSlateConfig } from '@slate-serializers/html'
import { getAttributeValue } from 'domutils'

export const transformContentToRichTextRaw = (dataContent: string) =>
  htmlToSlate(dataContent, {
    ...payloadHtmlToSlateConfig,
    elementTags: {
      ...payloadHtmlToSlateConfig.elementTags,
      a: (el) => ({
        type: 'link',
        linkType: el && getAttributeValue(el, 'data-link-type'),
        newTab: el && getAttributeValue(el, 'target') === '_blank',
        url: el && getAttributeValue(el, 'href'),
      }),
      img: (el) => ({
        type: 'img',
        url: el && getAttributeValue(el, 'src'),
      }),
    },
  })
