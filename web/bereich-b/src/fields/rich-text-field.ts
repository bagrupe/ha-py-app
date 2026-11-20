import { type RichTextField } from 'payload'
import {
  HeadingFeature,
  OrderedListFeature,
  UnorderedListFeature,
  LinkFeature,
  lexicalEditor,
} from '@payloadcms/richtext-lexical'

type Options = {
  name: string
} & Omit<RichTextField, 'type'>

export const richTextField = (options: Options): RichTextField => ({
  type: 'richText',
  editor: lexicalEditor({
    features: [
      HeadingFeature({ enabledHeadingSizes: ['h1', 'h2', 'h3', 'h4'] }),
      OrderedListFeature(),
      UnorderedListFeature(),
      LinkFeature(),
    ],
  }),
  ...options,
})
