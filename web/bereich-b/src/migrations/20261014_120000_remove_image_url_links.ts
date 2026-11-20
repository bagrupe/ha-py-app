import { MigrateDownArgs, MigrateUpArgs } from '@payloadcms/db-mongodb'
import type { MigrationAdapter } from '../scripts/migration-batches'
import { removeImageUrlLinksInTargets } from '../scripts/remove-image-url-links'
import { SLATE_LEXICAL_CATCHUP_TARGETS } from './20260602_101500_slate_lexical_catchup'

export async function up({ payload, session }: MigrateUpArgs): Promise<void> {
  await removeImageUrlLinksInTargets({
    adapter: payload.db as unknown as MigrationAdapter,
    logger: payload.logger,
    session,
    targets: SLATE_LEXICAL_CATCHUP_TARGETS,
  })
}

export async function down({}: MigrateDownArgs): Promise<void> {
  // No rollback: the removed links only duplicated image URLs.
}
