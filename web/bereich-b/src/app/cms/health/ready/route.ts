import config from '@payload-config'
import { getPayload } from 'payload'
import { buildHealthResponse, pingMongo } from '@/lib/health'

export const dynamic = 'force-dynamic'

export async function GET() {
  const payload = await getPayload({ config })

  return buildHealthResponse({
    mongodb: await pingMongo(payload),
  })
}
