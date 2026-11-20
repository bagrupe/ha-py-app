import { type MongooseAdapter } from '@payloadcms/db-mongodb'
import * as Sentry from '@sentry/nextjs'
import mongoose from 'mongoose'

import type { StartupMigration } from '../types'

/** Legacy Kommune document id for "Region Hannover" — delete only this id, never match by name. */
const REGION_HANNOVER_KOMMUNE_ID = '65ae4370f399a4b34dcd3594'

/** Every collection (slug) that includes a `kommune` relationship except `kommunen` and `news-artikel`. */
const SLUGS_WITH_KOMMUNE_FIELD: string[] = [
  'benutzer',
  'untereinheit',
  'veranstaltungskalender',
  'veranstaltungskalender-kategorie',
  'veranstaltungskalender-quelle',
  'aufrufe',
  'poi',
  'poi-categories',
  'poi-supercategories',
  'poi-icons',
  'medien',
  'veranstaltungsmedien',
  'aufrufemedien',
  'wettermesspunkte',
  'geo-flaechen',
  'sensoren',
  'sensor-art',
  'integration',
]

function kommuneReferenceFilter(id: mongoose.Types.ObjectId, idHex: string) {
  return {
    $or: [{ kommune: id }, { kommune: idHex }],
  }
}

type ModelLike = { collection: { name: string } }

/**
 * Removes the Kommune with id {@link REGION_HANNOVER_KOMMUNE_ID} and all documents that
 * reference it via `kommune`. Matching is **only** by that id (stored as ObjectId and/or
 * string), so a future Kommune named "Region Hannover" with a different id is unaffected.
 *
 * Idempotent: safe on every process start; after the first successful run there is nothing left to delete.
 */
export const deleteRegionHannoverKommuneMigration: StartupMigration = {
  id: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
  async run({ db, payload }) {
    const adapter = payload.db as MongooseAdapter
    const collections = adapter.collections as unknown as Record<string, ModelLike | undefined>
    const versions = adapter.versions as unknown as Record<string, ModelLike | undefined>

    let targetId: mongoose.Types.ObjectId
    try {
      targetId = new mongoose.Types.ObjectId(REGION_HANNOVER_KOMMUNE_ID)
    } catch (e) {
      payload.logger.error(
        {
          migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
          error: String(e),
        },
        'startupMigration: invalid kommune id',
      )
      return
    }

    const filter = kommuneReferenceFilter(targetId, REGION_HANNOVER_KOMMUNE_ID)

    try {
      const newsSlug = 'news-artikel'
      const newsCollName = collections[newsSlug]!.collection.name

      const articleIds = await db
        .collection(newsCollName)
        .find(filter)
        .project<{ _id: mongoose.Types.ObjectId }>({ _id: 1 })
        .toArray()

      const versionModel = versions[newsSlug]
      if (versionModel && articleIds.length > 0) {
        const versionCollName = versionModel.collection.name
        const parentIds = articleIds.map((d: { _id: mongoose.Types.ObjectId }) => d._id)
        // `parent` ist vor der Relationships-Migration ein Hex-String, danach eine ObjectId — beide Formen matchen.
        const vRes = await db.collection(versionCollName).deleteMany({
          parent: { $in: [...parentIds, ...parentIds.map((id) => id.toHexString())] },
        })
        payload.logger.info(
          {
            migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
            collection: versionCollName,
            deletedCount: vRes.deletedCount,
          },
          'startupMigration: deleted news-artikel versions',
        )
      }

      const newsRes = await db.collection(newsCollName).deleteMany(filter)
      payload.logger.info(
        {
          migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
          collection: newsCollName,
          deletedCount: newsRes.deletedCount,
        },
        'startupMigration: deleted news-artikels',
      )

      for (const slug of SLUGS_WITH_KOMMUNE_FIELD) {
        const collModel = collections[slug]
        if (!collModel) {
          payload.logger.warn(
            {
              migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
              slug,
            },
            'startupMigration: collection missing from payload config',
          )
          continue
        }
        const name = collModel.collection.name
        const res = await db.collection(name).deleteMany(filter)
        if (res.deletedCount > 0) {
          payload.logger.info(
            {
              migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
              collection: name,
              deletedCount: res.deletedCount,
            },
            'startupMigration: deleted documents',
          )
        }
      }

      const kommunenName = collections.kommunen!.collection.name
      const kommuneRes = await db.collection(kommunenName).deleteOne({ _id: targetId })
      if (kommuneRes.deletedCount > 0) {
        payload.logger.info(
          {
            migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
            collection: kommunenName,
            deletedCount: kommuneRes.deletedCount,
          },
          'startupMigration: deleted kommune document',
        )
      } else {
        payload.logger.info(
          { migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594' },
          'startupMigration: kommune already absent (nothing to delete)',
        )
      }
    } catch (e) {
      payload.logger.error(
        {
          migration: 'delete-region-hannover-kommune-65ae4370f399a4b34dcd3594',
          error: String(e),
        },
        'startupMigration: failed',
      )
      const isProduction = process.env.NODE_ENV === 'production'
      if (!isProduction) {
        throw new Error(
          `startupMigration delete-region-hannover-kommune-65ae4370f399a4b34dcd3594 failed: ${String(e)}`,
        )
      }
      Sentry.captureException(e, {
        tags: { module: 'startup-migrations', migration: 'delete-region-hannover-kommune' },
      })
    }
  },
}
