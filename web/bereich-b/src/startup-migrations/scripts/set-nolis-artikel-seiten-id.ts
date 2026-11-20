import { type MongooseAdapter } from '@payloadcms/db-mongodb'
import * as Sentry from '@sentry/nextjs'

import type { StartupMigration } from '../types'

type ModelLike = { collection: { name: string } }

const ID = 'set-nolis-artikel-seiten-id'

const SEITEN_IDS: Record<string, string> = {
  'https://www.hessisch-oldendorf.de': '33910',
  'https://www.coppenbruegge.de': '33850',
  'https://www.emmerthal.de': '33870',
}

export const setNolisArtikelSeitenIdMigration: StartupMigration = {
  id: ID,
  async run({ db, payload }) {
    const adapter = payload.db as MongooseAdapter
    const collections = adapter.collections as unknown as Record<string, ModelLike | undefined>

    try {
      const coll = db.collection(collections['integration']!.collection.name)

      for (const [url, seitenId] of Object.entries(SEITEN_IDS)) {
        const res = await coll.updateMany(
          {
            integrationtype: 'NOLIS',
            url,
            'konfiguration.artikelSeitenId': { $in: [null, ''] },
          },
          { $set: { 'konfiguration.artikelSeitenId': seitenId } },
        )
        if (res.modifiedCount > 0) {
          payload.logger.info(
            { migration: ID, url, modifiedCount: res.modifiedCount },
            'startupMigration: set artikelSeitenId',
          )
        }
      }
    } catch (e) {
      payload.logger.error({ migration: ID, error: String(e) }, 'startupMigration: failed')
      if (process.env.NODE_ENV !== 'production') {
        throw new Error(`startupMigration ${ID} failed: ${String(e)}`)
      }
      Sentry.captureException(e, { tags: { module: 'startup-migrations', migration: ID } })
    }
  },
}
