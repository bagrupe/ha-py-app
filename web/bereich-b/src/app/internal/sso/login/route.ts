import { createHash, timingSafeEqual } from 'crypto'
import configPromise from '@payload-config'
import { getPayload } from 'payload'
import { z } from 'zod'
import { formatZodErrors } from '@/lib/zod'
import { ssoLogin } from '@/sso'

const ssoLoginSchema = z.object({
  email: z.string().trim().min(1).email(),
  type: z.string().optional(),
  kommuneId: z.string().trim().min(1).optional().nullable(),
  bereichAUserId: z.string().trim().min(1),
})

// Stellt ein gültiges Payload-JWT für beliebige E-Mails aus und darf deshalb nie ohne Shared Secret arbeiten.
const isAuthorized = (request: Request): boolean => {
  const secret = process.env.INTERNAL_API_SECRET
  if (!secret) {
    console.error('INTERNAL_API_SECRET is not set — refusing /internal/sso/login request.')
    return false
  }
  const provided = request.headers.get('x-internal-api-secret')
  if (!provided) return false
  const expectedHash = createHash('sha256').update(secret).digest()
  const providedHash = createHash('sha256').update(provided).digest()
  return timingSafeEqual(expectedHash, providedHash)
}

export async function POST(request: Request) {
  try {
    if (!isAuthorized(request)) {
      return Response.json({ error: 'Unauthorized' }, { status: 401 })
    }

    const body = await request.json()
    const validation = ssoLoginSchema.safeParse(body)

    if (!validation.success) {
      return Response.json({ error: formatZodErrors(validation.error) }, { status: 400 })
    }

    const payload = await getPayload({ config: configPromise })
    const token = await ssoLogin(payload, validation.data)

    return new Response(token, { status: 200, headers: { 'Content-Type': 'text/plain' } })
  } catch (error) {
    if (error instanceof SyntaxError) {
      return Response.json({ error: 'Invalid JSON body' }, { status: 400 })
    }

    console.error('SSO login failed', error)
    return Response.json({ error: 'Internal Server Error' }, { status: 500 })
  }
}
