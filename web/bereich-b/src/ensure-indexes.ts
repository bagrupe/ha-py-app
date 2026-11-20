import type { Payload } from 'payload'
import type { MongooseAdapter } from '@payloadcms/db-mongodb'

const indexes: { collection: string; index: Record<string, 1 | -1> }[] = [
  { collection: 'news-artikels', index: { datum: 1, notified: 1 } },
  { collection: 'news-artikels', index: { importId: 1, kommune: 1 } },
  { collection: 'benutzers', index: { apiKeyIndex: 1 } },
  { collection: '_news-artikel_versions', index: { parent: 1, latest: 1 } },
  { collection: 'veranstaltungsmediens', index: { sourceUrl: 1, kommune: 1 } },
  { collection: 'news-artikels', index: { kommune: 1 } },
  { collection: 'veranstaltungsmediens', index: { kommune: 1 } },
  { collection: 'aufruves', index: { kommune: 1 } },
]

export const ensureIndexes = async (payload: Payload) => {
  const db = (payload.db as MongooseAdapter).connection?.db
  if (!db) {
    payload.logger.warn('ensureIndexes: skipped — db connection not available')
    return
  }

  const isProduction = process.env.NODE_ENV === 'production'

  for (const { collection, index } of indexes) {
    try {
      await db.collection(collection).createIndex(index)
      payload.logger.info({ collection, index }, 'ensureIndexes: index ensured')
    } catch (e) {
      payload.logger.error({ collection, index, error: String(e) }, 'ensureIndexes: failed')
      if (!isProduction) {
        throw new Error(`ensureIndexes: critical index failed on ${collection}: ${String(e)}`)
      }
    }
  }
}
