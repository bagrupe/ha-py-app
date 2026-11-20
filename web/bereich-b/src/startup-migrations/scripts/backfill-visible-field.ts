import { type MongooseAdapter } from '@payloadcms/db-mongodb'
import * as Sentry from '@sentry/nextjs'

import type { StartupMigration } from '../types'

const SLUGS = ['news-artikel', 'veranstaltungskalender'] as const
const FILTER = { visible: { $nin: [true, false] } }
const VERSION_FILTER = { 'version.visible': { $nin: [true, false] } }

type ModelLike = { collection: { name: string } }

export const backfillVisibleFieldMigration: StartupMigration = {
  id: 'backfill-visible-field',
  async run({ db, payload }) {
    const adapter = payload.db as MongooseAdapter
    const collections = adapter.collections as unknown as Record<string, ModelLike | undefined>
    const versions = adapter.versions as unknown as Record<string, ModelLike | undefined>

    for (const slug of SLUGS) {
      try {
        const collModel = collections[slug]
        if (!collModel) {
          payload.logger.warn(
            { migration: 'backfill-visible-field', slug },
            'startupMigration: collection missing from payload config',
          )
          continue
        }
        const collection = collModel.collection.name
        const coll = db.collection(collection)
        const total = await coll.countDocuments()
        const candidates = await coll.countDocuments(FILTER)
        if (candidates > 0) {
          const res = await coll.updateMany(FILTER, { $set: { visible: true } })
          payload.logger.info(
            {
              migration: 'backfill-visible-field',
              collection,
              total,
              candidates,
              matchedCount: res.matchedCount,
              modifiedCount: res.modifiedCount,
            },
            'startupMigration: backfilled visible',
          )
        } else {
          payload.logger.info(
            { migration: 'backfill-visible-field', collection, total },
            'startupMigration: no candidates',
          )
        }

        // Wiederherstellen einer Version ohne `visible` würde den Artikel ausblenden (Read-Filter verlangt visible == true).
        const versionModel = versions[slug]
        if (versionModel) {
          const versionCollection = versionModel.collection.name
          const vRes = await db
            .collection(versionCollection)
            .updateMany(VERSION_FILTER, { $set: { 'version.visible': true } })
          if (vRes.modifiedCount > 0) {
            payload.logger.info(
              {
                migration: 'backfill-visible-field',
                collection: versionCollection,
                modifiedCount: vRes.modifiedCount,
              },
              'startupMigration: backfilled visible on version snapshots',
            )
          }
        }
      } catch (e) {
        payload.logger.error(
          { migration: 'backfill-visible-field', slug, error: String(e) },
          'startupMigration: failed',
        )
        const isProduction = process.env.NODE_ENV === 'production'
        if (!isProduction) {
          throw new Error(`startupMigration backfill-visible-field failed on ${slug}: ${String(e)}`)
        }
        Sentry.captureException(e, {
          tags: { module: 'startup-migrations', migration: 'backfill-visible-field' },
        })
      }
    }
  },
}
