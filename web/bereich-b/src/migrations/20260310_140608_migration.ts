import {
  MigrateDownArgs,
  MigrateUpArgs,
} from '@payloadcms/db-mongodb'
import { migrateVersionsV1_V2 } from '@payloadcms/db-mongodb/migration-utils'

export async function up({ req }: MigrateUpArgs): Promise<void> {
  await migrateVersionsV1_V2({ req })
}

export async function down({}: MigrateDownArgs): Promise<void> {
  // No rollback — latest flag is additive
}
