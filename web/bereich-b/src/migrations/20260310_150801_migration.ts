import { MigrateDownArgs, MigrateUpArgs } from '@payloadcms/db-mongodb'
import {
  migrateTargets,
  type SlateToLexicalAdapter,
  type SlateToLexicalMigrationTarget,
} from '../scripts/slate-to-lexical'

const targets = [
  { collectionSlug: 'news-artikel', field: 'inhalte', type: 'block' },
  { collectionSlug: 'poi', field: 'contents', type: 'block' },
  { collectionSlug: 'veranstaltungskalender', field: 'inhalte', type: 'block' },
  { collectionSlug: 'kommunen', field: 'lizenzen.kartenlizenzen', type: 'inline' },
] as const satisfies readonly SlateToLexicalMigrationTarget[]

export async function up({ payload, session }: MigrateUpArgs): Promise<void> {
  await migrateTargets({
    adapter: payload.db as unknown as SlateToLexicalAdapter,
    logger: payload.logger,
    session,
    targets,
  })
}

export async function down({}: MigrateDownArgs): Promise<void> {
  // No rollback — Slate data is not preserved after conversion
}
