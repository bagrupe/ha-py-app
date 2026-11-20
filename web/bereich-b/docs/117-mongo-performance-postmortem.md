# #117 MongoDB Performance Issues — Postmortem

**Date:** 2026-03-30
**Branch:** `117-mongo-db-performance-issues`
**Commit:** `91a3bce` — _fix(bereich-b): eliminate MongoDB performance bottlenecks_

## Problem

The bereich-b importers (IKISS, NOLIS, RSS) run every 10 minutes via cron (`runOnInit: true`). Before the fix, every cron cycle performed **blind upserts** — each article/image triggered an individual `payload.find()` followed by `payload.update()`, regardless of whether the document had changed. Combined with missing compound indexes, this caused:

1. **Full collection scans (COLLSCANs)** on every lookup — `news-artikels` had only the `_id` index
2. **N+1 query pattern** — each of ~1,700 articles and ~3,100 images required its own DB round-trip
3. **Blind writes** — documents were updated even when data was identical, creating unnecessary version documents in `_news-artikel_versions` (34,000+ docs)

### Production Indicators (from server metrics snapshot)

| Metric                                | Value          |
| ------------------------------------- | -------------- |
| `queryExecutor.scanned`               | 96,991,210     |
| `queryExecutor.scannedObjects`        | 11,512,799,267 |
| `queryExecutor.collectionScans.total` | 5,100,412      |
| `_news-artikel_versions` count        | 33,384         |

These numbers accumulated over time from repeated full-collection-scan upserts every 10 minutes.

## Root Causes

### 1. Missing Compound Indexes

`news-artikels` had **zero** application-level indexes. Every `find({importId, kommune})` query during upsert triggered a COLLSCAN across all 1,700+ documents. Same for `veranstaltungsmediens` lookups by `{sourceUrl, kommune}`.

### 2. Blind Upsert Pattern (N+1)

The old `upsert()` function in `src/dataseeder/upsert.ts` did:

```
for each article:
  payload.find({importId, kommune})  → COLLSCAN
  payload.update(article)            → always writes, even if unchanged
```

No change detection, no caching. Every cycle wrote every document.

### 3. No Prefetching

Each importer looked up articles/images one-by-one during the import loop, instead of bulk-loading existing records upfront.

## Fix Summary

### A. Compound Indexes (`ensure-indexes.ts`)

7 indexes created on startup:

| Collection               | Index                        | Purpose               |
| ------------------------ | ---------------------------- | --------------------- |
| `news-artikels`          | `{datum: 1, notified: 1}`    | Notification queries  |
| `news-artikels`          | `{importId: 1, kommune: 1}`  | Import upsert lookups |
| `news-artikels`          | `{kommune: 1}`               | Prefetch filter       |
| `benutzers`              | `{apiKeyIndex: 1}`           | API key auth          |
| `_news-artikel_versions` | `{parent: 1, latest: 1}`     | Version lookups       |
| `veranstaltungsmediens`  | `{sourceUrl: 1, kommune: 1}` | Image upsert lookups  |
| `veranstaltungsmediens`  | `{kommune: 1}`               | Prefetch filter       |

### B. Prefetch Cache (`upsert.ts`)

`prefetchCollection()` bulk-loads all existing documents for a kommune into a `Map` keyed by the upsert key(s). Subsequent `upsert()` calls do `Map.get()` (O(1)) instead of `payload.find()` (COLLSCAN).

### C. Two-Tier Change Detection (`hasDocChanges`)

Before writing, `upsert()` now compares incoming data against the cached existing document:

-   **Tier 1 (cheap):** Scalar fields compared directly — short-circuits on first mismatch
-   **Tier 2 (deferred):** Complex fields (rich text, arrays) normalized and JSON-stringified

If no changes detected, the write is skipped entirely.

### D. UpsertStats Tracking (`upsert-stats.ts`)

Each import cycle now logs a summary: `created / updated / unchanged / skipped` per collection, making it visible how many writes were actually necessary.

## Benchmarks

Profiled with MongoDB level 2 profiling on the same dump (`20260330-mongo-db.dump`, 42,200 documents). Each test: fresh dump restore, multiple import cycles.

### COLLSCAN Comparison

| Metric                              | Before (main) | After (#117) | Change              |
| ----------------------------------- | ------------- | ------------ | ------------------- |
| **Total COLLSCANs (profiled)**      | 101           | 0\*          | **-100%**           |
| **IXSCAN ops**                      | 0             | 539          | all queries indexed |
| news-artikels docs examined         | 83,184        | 1            | **-99.999%**        |
| veranstaltungsmediens docs examined | 145,728       | 1            | **-99.999%**        |
| benutzers docs examined             | 308           | 0            | -100%               |
| Max query time                      | 5ms           | 0ms          | -100%               |

_\*Only `system.profile` itself had COLLSCANs (9 ops on the profiling collection) — zero on application collections._

### Operation Breakdown

| Metric               | Before | After |
| -------------------- | ------ | ----- |
| Total profiled ops   | 524    | 592   |
| Queries              | 356    | 536   |
| Inserts              | 23     | 1     |
| Updates              | 23     | 1     |
| Slow queries (>50ms) | 0      | 0     |
| Slow queries (>10ms) | 0      | 0     |

The "after" run has more queries but they're all IXSCAN (0ms each). The dramatically lower insert/update count shows change detection working — most documents are `unchanged` and skipped.

### Index Size Tradeoff

| Collection              | Before (nindexes / totalIndexSize) | After (nindexes / totalIndexSize) |
| ----------------------- | ---------------------------------- | --------------------------------- |
| news-artikels           | 1 / 77 KB                          | 4 / 356 KB                        |
| \_news-artikel_versions | 6 / 2.8 MB                         | 7 / 2.9 MB                        |
| veranstaltungsmediens   | 3 / 315 KB                         | 5 / 696 KB                        |

Index size increase is ~650 KB total — negligible vs the performance gain.

### Server-Level Metrics (cumulative)

| Metric                  | Before     | After      |
| ----------------------- | ---------- | ---------- |
| `scannedObjects`        | 21,435,766 | 24,877,283 |
| `collectionScans.total` | 8,387      | 9,658      |

Note: Server metrics are cumulative across the MongoDB instance lifetime (not reset by dump restore), so they include pre-profiling activity. The profiled-operation-level data above is the meaningful comparison.

## Files Changed

| File                                                                               | Change                                                            |
| ---------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `src/ensure-indexes.ts`                                                            | **New** — 7 compound indexes created on startup                   |
| `src/dataseeder/upsert.ts`                                                         | Prefetch cache, `hasDocChanges`, two-tier comparison              |
| `src/dataseeder/upsert-stats.ts`                                                   | **New** — per-collection create/update/unchanged/skipped tracking |
| `src/dataseeder/__tests__/has-doc-changes.test.ts`                                 | **New** — unit tests for change detection                         |
| `src/server.ts`                                                                    | Chain `ensureIndexes()` before `setupCronJobs()`                  |
| `src/collections/news-artikel/integrations/common.ts`                              | `prefetchImporterCaches()` helper                                 |
| `src/collections/news-artikel/integrations/integration-runner.ts`                  | Pass `UpsertStats` through import cycle                           |
| `src/collections/news-artikel/integrations/ikiss/ikiss-importer.ts`                | Use prefetch cache + stats                                        |
| `src/collections/news-artikel/integrations/nolis/nolis-importer.ts`                | Use prefetch cache + stats                                        |
| `src/collections/news-artikel/integrations/rss/rss-importer.ts`                    | Use prefetch cache + stats                                        |
| `src/collections/news-artikel/integrations/ikiss/ikiss-html-to-slate-converter.ts` | Normalize for stable comparison                                   |

## Recommendations

1. **Monitor `UpsertStats` logs in production** — if `unchanged` counts are high (expected), the optimization is working. If `updated` counts spike, content sources are actively changing.
2. **Consider adding indexes for other collections** as query patterns emerge (e.g., `veranstaltungskalenders`, `pois`).
3. **Version collection growth** — `_news-artikel_versions` (34K docs, 100MB) will grow slower now that unchanged articles aren't re-written, but periodic cleanup of old versions could reduce storage.
