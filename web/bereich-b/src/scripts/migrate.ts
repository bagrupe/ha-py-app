/**
 * Standalone migration runner for local dev.
 *
 * Runs all pending Payload migrations (relationships-v2-v3, versions-v1-v2,
 * slate-to-lexical) via payload.db.migrate(). Skips already-applied ones.
 *
 * In production, migrations are handled automatically via prodMigrations in
 * payload.config.ts. This script is only needed locally after a dump restore.
 *
 * Usage:
 *   pnpm migrate  (called automatically by pnpm dev)
 */
import 'dotenv/config'
import fs from 'fs'
import { type CollectionSlug, getPayload } from 'payload'
import config from '@payload-config'

// Initializing Payload is required before calling db.migrate(), but the
// application-level onInit work must not run inside this standalone process.
process.env.SKIP_PAYLOAD_ON_INIT = 'true'
process.env.SKIP_IMPORTERS = 'true'

// payload.db.migrate() treats a missing/unreadable migration dir as a log
// line and returns successfully having applied nothing (its existsSync check
// swallows errors), so the outcome must be verified here rather than trusted.
async function run(): Promise<string> {
  const payload = await getPayload({ config })

  const dir = payload.db.migrationDir
  const files = fs
    .readdirSync(dir)
    .filter((f) => /\.(js|ts)$/.test(f) && f !== 'index.ts' && f !== 'index.js')
  if (files.length === 0) {
    throw new Error(`No migration files found in ${dir}`)
  }

  await payload.db.migrate()

  const { totalDocs } = await payload.count({
    collection: 'payload-migrations' as CollectionSlug,
  })
  if (totalDocs < files.length) {
    throw new Error(
      `Verification failed: ${files.length} migration files on disk but only ${totalDocs} recorded as applied`,
    )
  }
  return `Migrations verified: ${totalDocs}/${files.length} applied`
}

// process.exit() truncates pending async stream writes when stdout is a pipe
// (this hid the "No migration directory found" error in the silent-skip
// incidents), and exiting "naturally" hangs on open Payload/mongoose handles —
// so flush the status line via the write callback, then exit.
const exitWith = (code: number, message: string) => {
  const stream = code === 0 ? process.stdout : process.stderr
  stream.write(message + '\n', () => process.exit(code))
}

run().then(
  (msg) => exitWith(0, msg),
  (err) => exitWith(1, `Migration failed: ${err instanceof Error ? err.stack : err}`),
)
