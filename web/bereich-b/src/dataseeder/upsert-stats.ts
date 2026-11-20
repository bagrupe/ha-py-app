import type { BasePayload } from 'payload'

type Logger = BasePayload['logger']
type Action = 'created' | 'updated' | 'unchanged' | 'skipped'
type Entry = {
  created: number
  updated: number
  unchanged: number
  skipped: number
}

export class UpsertStats {
  private stats = new Map<string, Entry>()

  private getEntry(collection: string): Entry {
    let entry = this.stats.get(collection)
    if (!entry) {
      entry = { created: 0, updated: 0, unchanged: 0, skipped: 0 }
      this.stats.set(collection, entry)
    }
    return entry
  }

  track(collection: string, action: Action) {
    this.getEntry(collection)[action]++
  }

  flush(logger: Logger) {
    for (const [collection, counts] of this.stats.entries()) {
      logger.info(
        { collection, ...counts },
        `upsert summary [${collection}]: ${counts.created} created, ${counts.updated} updated, ${counts.unchanged} unchanged, ${counts.skipped} skipped`,
      )
    }
    this.stats.clear()
  }
}
