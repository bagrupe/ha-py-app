import { backfillVisibleFieldMigration } from './scripts/backfill-visible-field'
import { deleteIkissDraftNewsArtikelMigration } from './scripts/delete-ikiss-draft-news-artikel'
import { deleteRegionHannoverKommuneMigration } from './scripts/delete-region-hannover-kommune'
import { deleteReplacementCharNewsArticlesMigration } from './scripts/delete-replacement-char-news-articles'
import { setNolisArtikelSeitenIdMigration } from './scripts/set-nolis-artikel-seiten-id'
import type { StartupMigration } from './types'

/** Ordered list — new migrations append here. */
export const startupMigrations: StartupMigration[] = [
  backfillVisibleFieldMigration,
  deleteReplacementCharNewsArticlesMigration,
  deleteRegionHannoverKommuneMigration,
  deleteIkissDraftNewsArtikelMigration,
  setNolisArtikelSeitenIdMigration,
]
