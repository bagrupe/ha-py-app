import { type Block } from 'payload'
import { generatedString } from '../fields/generated-value'
import { lexicalToHtml } from '../lib/lexical-to-html'

export const RichTextBlock: Block = {
  slug: 'rich-text',
  interfaceName: 'RichTextBlock',
  fields: [
    { name: 'content', type: 'richText' },
    generatedString<{ id: string }, { content?: unknown }>({
      name: 'contentHtml',
      value: (_doc, sibling) => lexicalToHtml(sibling.content),
    }),
  ],
}
