import { expect, test } from 'vitest'
import { customContentField, itemSchema, rssSchema } from '../rss-schema'
import { schemaTestData } from './testdata'

test('Should accept schema', async () => {
  const rssJson = await rssSchema
    .passthrough()
    .safeParseAsync(schemaTestData.schemaWithMissingCustomContentKey)
  expect(rssJson.success).toBe(true)
})

test('Should fail on schema when items missing', async () => {
  const rssJson = await rssSchema.passthrough().safeParseAsync([1])
  expect(rssJson.success).toBe(false)
})

test('Should validate schema', async () => {
  const rssJson = await rssSchema
    .passthrough()
    .safeParseAsync(schemaTestData.schemaWithMissingCustomContentKey)
  if (!rssJson.success) {
    expect.fail('Testdata should have passed schema parsing')
  }

  const items = rssJson.data.rss.channel.item

  const invalidItems = []

  for (const item of items) {
    const safeItemSchema = itemSchema.and(customContentField('content:encoded'))

    const safeItemParseResult = await safeItemSchema.safeParseAsync(item)

    if (safeItemParseResult.error) {
      invalidItems.push(item)
    }
  }
  expect(invalidItems.length).toBe(1)
})
