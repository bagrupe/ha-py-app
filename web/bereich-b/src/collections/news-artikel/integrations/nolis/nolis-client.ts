import { z } from 'zod'
export const fetchNolisResponse = async (url: string, token: string, type: string) => {
  const fetchURL = new URL('/seiten/export.php', url)
  fetchURL.searchParams.set('token', token)
  fetchURL.searchParams.set('type', type)

  const response = await fetch(fetchURL, {
    method: 'POST',
    headers: { 'user-agent': 'node' },
  })

  const data = await response.json()
  const parsed = await nolisResponseSchema.safeParseAsync(data)
  if (parsed.error) {
    throw parsed.error
  }
  return parsed.data
}

const nolisDataSchema = z.object({
  id: z.string(),
  titel: z.string(),
  anreisser: z.string(),
  veroeffentlichungsdatum: z.string(),
  mitteilungsinhalt_html: z.string(),
  vorschaubild: z.string().optional(),
})

const nolisResponseSchema = z.object({
  code: z.number(),
  message: z.number(),
  data: z.array(nolisDataSchema),
  version: z.string(),
  debugInfo: z.array(z.unknown()),
})

export type NolisResponse = z.infer<typeof nolisResponseSchema>
export type NolisData = z.infer<typeof nolisDataSchema>
