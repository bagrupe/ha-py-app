import type { Connection } from 'mongoose'
import type { Payload } from 'payload'

export type MigrationContext = {
  // Mongoose's bundled mongodb `Db` — must match `payload.db.connection.db`,
  // not a separately-resolved `mongodb` version, or the types diverge.
  db: NonNullable<Connection['db']>
  payload: Payload
}

export type StartupMigration = {
  /** Stable id for logs (kebab-case). */
  id: string
  run: (ctx: MigrationContext) => Promise<void>
}
