import { type MongooseAdapter } from '@payloadcms/db-mongodb'
import * as Sentry from '@sentry/nextjs'
import type mongoose from 'mongoose'

import type { StartupMigration } from '../types'

const REPLACEMENT_CHAR_REGEX = /�/
const FILTER = {
  $or: [{ titel: REPLACEMENT_CHAR_REGEX }, { teaser: REPLACEMENT_CHAR_REGEX }],
}

type ModelLike = { collection: { name: string } }

/**
 * Removes `news-artikel` docs whose `titel` or `teaser` contains U+FFFD
 * (REPLACEMENT CHARACTER) — the result of decoding an ISO-8859-15 iKISS
 * response as UTF-8. The iKISS importer now decodes with the declared
 * charset, so the next cron cycle will re-import these articles cleanly.
 */
export const deleteReplacementCharNewsArticlesMigration: StartupMigration = {
  id: 'delete-replacement-char-news-articles',
  async run({ db, payload }) {
    const adapter = payload.db as MongooseAdapter
    const collections = adapter.collections as unknown as Record<string, ModelLike | undefined>
    const versions = adapter.versions as unknown as Record<string, ModelLike | undefined>

    try {
      const collName = collections['news-artikel']!.collection.name
      const coll = db.collection(collName)

      const candidates = await coll
        .find(FILTER)
        .project<{ _id: mongoose.Types.ObjectId }>({ _id: 1 })
        .toArray()
      if (candidates.length === 0) {
        payload.logger.info(
          { migration: 'delete-replacement-char-news-articles' },
          'startupMigration: no candidates',
        )
        return
      }

      // `parent` ist vor der Relationships-Migration ein Hex-String, danach eine ObjectId — beide Formen matchen.
      const versionModel = versions['news-artikel']
      if (versionModel) {
        const parentIds = candidates.map((d) => d._id)
        const vRes = await db.collection(versionModel.collection.name).deleteMany({
          parent: { $in: [...parentIds, ...parentIds.map((id) => id.toHexString())] },
        })
        payload.logger.info(
          {
            migration: 'delete-replacement-char-news-articles',
            collection: versionModel.collection.name,
            deletedCount: vRes.deletedCount,
          },
          'startupMigration: deleted versions of garbled news-artikels',
        )
      }

      const res = await coll.deleteMany(FILTER)
      payload.logger.info(
        {
          migration: 'delete-replacement-char-news-articles',
          candidates: candidates.length,
          deletedCount: res.deletedCount,
        },
        'startupMigration: deleted news-artikels with garbled text',
      )
    } catch (e) {
      payload.logger.error(
        { migration: 'delete-replacement-char-news-articles', error: String(e) },
        'startupMigration: failed',
      )
      const isProduction = process.env.NODE_ENV === 'production'
      if (!isProduction) {
        throw new Error(
          `startupMigration delete-replacement-char-news-articles failed: ${String(e)}`,
        )
      }
      Sentry.captureException(e, {
        tags: { module: 'startup-migrations', migration: 'delete-replacement-char-news-articles' },
      })
    }
  },
}
