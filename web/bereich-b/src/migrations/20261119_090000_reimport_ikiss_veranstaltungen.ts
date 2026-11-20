import { MigrateDownArgs, MigrateUpArgs } from '@payloadcms/db-mongodb'
import type { Collection } from 'mongodb'

// Only the iKISS importer writes a string here (admin saves reset it to null), so clearing it
// makes the next import re-render exactly the iKISS events with the fixed markup parser.
export async function up({ payload, session }: MigrateUpArgs): Promise<void> {
  const { collection } = payload.db.collections.veranstaltungskalender as unknown as {
    collection: Collection
  }
  const { modifiedCount } = await collection.updateMany(
    { upstreamUpdateDate: { $type: 'string' } },
    { $set: { upstreamUpdateDate: null } },
    { session },
  )
  payload.logger.info(`Marked ${modifiedCount} iKISS Veranstaltungen for re-import`)
}

export async function down({}: MigrateDownArgs): Promise<void> {
  // No rollback: the marker is a cache that the next import writes back.
}
