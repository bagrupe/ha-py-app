import { z } from 'zod'

export const attributesSchema = z.object({
  url: z.string().optional(),
  length: z.string().optional(),
  type: z.string().optional(),
})

export const customContentField = (key: string) =>
  z.object({ [key]: z.string() }).transform((i) => ({
    content: i[key],
  }))

export const itemSchema = z
  .object({
    title: z.string(),
    subtitle: z.string().optional(),
    link: z.string().optional(),
    description: z.string(),
    pubDate: z.string(),
    guid: z
      .object({ '#text': z.string(), isPermaLink: z.string() })
      .transform((e) => ({ ...e, value: e['#text'] })),
    enclosure: attributesSchema.optional(),
  })
  .passthrough()

export const contentValidationSchema = z.object({ content: z.string() }).required().and(itemSchema)

export const channelSchema = z.object({
  title: z.string(),
  link: z.string(),
  description: z.string(),
  language: z.string().optional(),
  pubDate: z.string().optional(),
  lastBuildDate: z.string().optional(),
  docs: z.string().optional(),
  generator: z.string().optional(),
  managingEditor: z.string().optional(),
  webMaster: z.string().optional(),
  'atom:link': z.object({}),
  item: z.array(itemSchema),
})

export const rssSchema = z
  .object({
    rss: z.object({
      channel: channelSchema,
    }),
  })
  .passthrough()
