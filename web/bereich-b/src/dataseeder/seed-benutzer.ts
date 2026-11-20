import { getPayload, type Payload } from 'payload'
import config from '@payload-config'
import { upsert } from './upsert'
import { UpsertStats } from './upsert-stats'

// Sentinel bereichAId for the Payload-only super-admin. The field is required
// and immutable on the Benutzer collection, but this user has no backend
// counterpart — it exists solely so the backend can auth against Bereich-B.
const PAYLOAD_SUPERADMIN_BEREICH_A_ID = '3347c4df-2fd2-4d6a-b11b-39490da2735c'

const requireEnv = (name: string): string => {
  const value = process.env[name]
  if (!value) {
    throw new Error(
      `seedBenutzer: missing required environment variable '${name}'. ` +
        'This value must be set for the backend <-> bereich-b sync to authenticate.',
    )
  }
  return value
}

const maskSecret = (value: string): string => {
  if (value.length <= 4) return '*'.repeat(value.length)
  return `${'*'.repeat(value.length - 4)}${value.slice(-4)}`
}

export const seedBenutzer = async (payloadArg?: Payload) => {
  const payload = payloadArg ?? (await getPayload({ config }))
  const email = requireEnv('PAYLOAD_SUPERADMIN_EMAIL')
  const password = requireEnv('PAYLOAD_SUPERADMIN_PASSWORD')
  const apiKey = requireEnv('PAYLOAD_API_KEY')

  payload.logger.info(
    { email, apiKey: maskSecret(apiKey) },
    `seedBenutzer: upserting super-admin '${email}' with apiKey '${maskSecret(apiKey)}'`,
  )

  const stats = new UpsertStats()
  await upsert(
    {
      collection: 'benutzer',
      key: 'email',
      data: {
        email,
        password,
        apiKey,
        enableAPIKey: true,
        isSuperAdmin: true,
        bereichAId: PAYLOAD_SUPERADMIN_BEREICH_A_ID,
      },
    },
    { payload, stats },
  )
  stats.flush(payload.logger)
}
