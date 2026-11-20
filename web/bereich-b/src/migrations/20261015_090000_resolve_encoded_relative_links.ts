import { MigrateDownArgs, MigrateUpArgs } from '@payloadcms/db-mongodb'
import type { MigrationAdapter, MigrationTarget } from '../scripts/migration-batches'
import { loadIntegrationBaseUrls, resolveEncodedLinksInTargets } from '../scripts/resolve-encoded-links'

const TARGETS = [
  { collectionSlug: 'news-artikel', field: 'inhalte', type: 'block' },
  { collectionSlug: 'news-artikel', field: 'inhalte', type: 'block', versions: true },
] as const satisfies readonly MigrationTarget[]

export async function up({ payload, session }: MigrateUpArgs): Promise<void> {
  const adapter = payload.db as unknown as MigrationAdapter
  const baseUrlByIntegrationId = await loadIntegrationBaseUrls(adapter, session)

  await resolveEncodedLinksInTargets({
    adapter,
    baseUrlByIntegrationId,
    logger: payload.logger,
    session,
    targets: TARGETS,
  })
}

export async function down({}: MigrateDownArgs): Promise<void> {
  // No rollback: the encoded urls were dead links.
}
