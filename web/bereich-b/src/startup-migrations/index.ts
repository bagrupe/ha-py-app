/**
 * Startup migrations run once each time bereich-b boots, from `onInit` in
 * `payload.config.ts` (after Payload has connected to MongoDB). They are
 * **data** migrations — idempotent business-logic fixes — and are distinct
 * from Payload's native **schema** migrations in `src/migrations/`.
 *
 * Layout: **`scripts/`** holds individual migration modules (one file per
 * migration). **`types.ts`**, **`registry.ts`**, and this file define how
 * migrations are typed, ordered, and executed.
 *
 * **Adding a migration**
 *
 * 1. Add `scripts/<name>.ts` exporting a `StartupMigration`:
 *    `{ id: string; run: (ctx: MigrationContext) => Promise<void> }`.
 *    Import types from `../types`. Use `ctx.db` for native MongoDB access;
 *    use `ctx.payload` for the logger or Payload APIs.
 * 2. Import it in `registry.ts` and append it to `startupMigrations`. Execution
 *    order follows that array — put dependencies before dependents.
 * 3. Keep migrations **idempotent** — they re-run on every boot.
 */

import type { Payload } from 'payload'
import { type MongooseAdapter } from '@payloadcms/db-mongodb'

import { startupMigrations } from './registry'

export type { MigrationContext, StartupMigration } from './types'

export const runStartupMigrations = async (payload: Payload) => {
  const db = (payload.db as MongooseAdapter).connection?.db
  if (!db) {
    payload.logger.warn('runStartupMigrations: skipped — db connection not available')
    return
  }

  const ctx = { db, payload }

  for (const migration of startupMigrations) {
    const start = Date.now()
    await migration.run(ctx)
    payload.logger.info(
      { migration: migration.id, ms: Date.now() - start },
      'startupMigration: finished',
    )
  }
}
