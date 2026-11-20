import { type MongooseAdapter } from '@payloadcms/db-mongodb'
import * as Sentry from '@sentry/nextjs'
import type mongoose from 'mongoose'

import type { StartupMigration } from '../types'

type ModelLike = { collection: { name: string } }

/**
 * Removes `news-artikel` docs that were imported as drafts from an iKISS
 * integration. The old iKISS importer upserted unreleased articles as
 * `_status: 'draft'`; those still surfaced to the push-notification query,
 * which does not filter `_status`. The importer now skips unreleased articles,
 * so this clears the ones already written. Manual drafts (no integration) and
 * all published articles are left untouched. iKISS integration ids are resolved
 * at runtime, never hardcoded so the filter is correct in every environment.
 */
export const deleteIkissDraftNewsArtikelMigration: StartupMigration = {
  id: 'delete-ikiss-draft-news-artikel',
  async run({ db, payload }) {
    const adapter = payload.db as MongooseAdapter
    const collections = adapter.collections as unknown as Record<string, ModelLike | undefined>

    try {
      const ikissIntegrations = await db
        .collection(collections['integration']!.collection.name)
        .find({ integrationtype: 'IKISS' })
        .project<{ _id: mongoose.Types.ObjectId }>({ _id: 1 })
        .toArray()

      if (ikissIntegrations.length === 0) {
        payload.logger.info(
          { migration: 'delete-ikiss-draft-news-artikel' },
          'startupMigration: no iKISS integrations',
        )
        return
      }

      // Relationship ids are stored as ObjectId in v3 but were strings in v1;
      // match both forms so the filter is robust regardless of how it was saved.
      const ikissIds = ikissIntegrations.flatMap((i) => [String(i._id), i._id])
      const filter = { _status: 'draft', integration: { $in: ikissIds } }

      const coll = db.collection(collections['news-artikel']!.collection.name)
      const candidates = await coll.countDocuments(filter)
      if (candidates === 0) {
        payload.logger.info(
          { migration: 'delete-ikiss-draft-news-artikel' },
          'startupMigration: no candidates',
        )
        return
      }

      const res = await coll.deleteMany(filter)
      payload.logger.info(
        {
          migration: 'delete-ikiss-draft-news-artikel',
          candidates,
          deletedCount: res.deletedCount,
        },
        'startupMigration: deleted iKISS draft news-artikels',
      )
    } catch (e) {
      payload.logger.error(
        { migration: 'delete-ikiss-draft-news-artikel', error: String(e) },
        'startupMigration: failed',
      )
      const isProduction = process.env.NODE_ENV === 'production'
      if (!isProduction) {
        throw new Error(`startupMigration delete-ikiss-draft-news-artikel failed: ${String(e)}`)
      }
      Sentry.captureException(e, {
        tags: { module: 'startup-migrations', migration: 'delete-ikiss-draft-news-artikel' },
      })
    }
  },
}
