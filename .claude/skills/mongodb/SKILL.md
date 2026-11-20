---
name: mongodb
description: "Connect to the local MongoDB instance (hameln-mongodb container), run queries, restore gzip dumps, and profile query performance. Use when a task needs to read or write the bereich-b MongoDB database directly, or to restore a production/staging dump locally."
model: sonnet
allowed-tools: Bash(docker *), Bash(ls *), Bash(file *), Bash(uuidgen)
---

# MongoDB Operations — Kommunal-App

## Connection Details

- **Container:** `hameln-mongodb`
- **Image:** mongo:6.0.4
- **Port:** 27017
- **Credentials:** `admin` / `password`
- **Database:** `bereich-b`
- **Connection URI:** `mongodb://admin:password@localhost:27017/bereich-b?authSource=admin`

## Step 1: Verify the Container

Before any operation, confirm the MongoDB container is running and healthy:

```bash
docker ps --filter "name=hameln-mongodb" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

If not running, start it:

```bash
docker compose -f docker/docker-compose.local.yml -p hameln up -d
```

Wait for healthy status before proceeding.

## Step 2: Connect and Run Queries

Use `mongosh` inside the container for ad-hoc queries:

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "<JS_EXPRESSION>"
```

**Common queries:**

List collections:
```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "db.getCollectionNames()"
```

Count documents in a collection:
```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "db.getCollection('<collection>').countDocuments()"
```

Find a user by email:
```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "db.getCollection('benutzers').findOne({email:'<email>'})"
```

Update a field:
```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "db.getCollection('<collection>').updateOne({<filter>}, {\$set: {<field>: <value>}})"
```

## Step 3: Restore from a Dump

### 3a. Identify the dump file

```bash
ls -lh <path-to-dump>
file <path-to-dump>
```

Dumps in this project are **gzip-compressed archives** (`.dump` files with gzip encoding). Typical location: `dumps/<date>/bereich-b.dump`.

### 3b. Copy the dump into the container

```bash
docker cp <path-to-dump> hameln-mongodb:/tmp/bereich-b.dump
```

### 3c. Restore with mongorestore

```bash
docker exec hameln-mongodb mongorestore \
  --uri="mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" \
  --drop \
  --gzip \
  --archive=/tmp/bereich-b.dump
```

- `--drop` replaces existing collections (ensures clean state matching the dump)
- `--gzip` handles the gzip-compressed archive format
- `--archive` reads from the single archive file (not a directory)

If the dump targets a different database name, add `--nsFrom="<source-db>.*" --nsTo="bereich-b.*"`.

### 3d. Verify the restore

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "db.getCollectionNames().forEach(c => print(c + ': ' + db.getCollection(c).countDocuments()))"
```

### 3e. Clean up the dump from the container

```bash
docker exec hameln-mongodb rm /tmp/bereich-b.dump
```

## Post-Restore Notes

### Always: clear payload-migrations

Production/staging dumps include `payload-migrations` records from when migrations ran in that environment. Restoring such a dump locally causes Payload to skip all migrations (it sees the records and thinks they already ran), leaving relationship fields as strings and rich text in Slate format.

Always clear the collection right after restoring:

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --quiet --eval \
  'print("Cleared: "+db.getCollection("payload-migrations").deleteMany({}).deletedCount)'
```

After this, `pnpm dev` automatically runs all pending migrations on first request via `onInit` in `payload.config.ts` (which calls `payload.db.migrate({ migrations })` when `NODE_ENV !== 'production'`).

### isSuperAdmin flag

After restoring from a production/staging dump, the `admin@example.com` user may be missing the `isSuperAdmin` flag. Fix it:

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval "db.getCollection('benutzers').updateOne({email:'admin@example.com'}, {\$set: {isSuperAdmin: true}})"
```

You may also need to re-run the API key setup (see `bereich-b-authentication` → `references/api-key.md`) if the restored dump has different API keys than your local `.env` / dotnet user-secrets.

## Step 4: Performance Profiling

Use this workflow to benchmark MongoDB query performance — especially before/after comparisons for optimization work.

### 4a. Restore a clean dump

Always start from a known state. Follow Step 3 above to restore the target dump with `--drop`.

### 4b. Drop custom indexes (for "before" baseline)

If profiling *without* custom indexes (to measure the unoptimized state), drop the indexes defined in `web/bereich-b/src/ensure-indexes.ts`. The dump restore does NOT remove indexes that were previously created by running bereich-b.

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --quiet --eval '
// Read ensure-indexes.ts to get the current list — these are the ones added by the app:
const drops = [
  {c: "news-artikels", idx: "datum_1_notified_1"},
  {c: "news-artikels", idx: "importId_1_kommune_1"},
  {c: "news-artikels", idx: "kommune_1"},
  {c: "benutzers", idx: "apiKeyIndex_1"},
  {c: "_news-artikel_versions", idx: "parent_1_latest_1"},
  {c: "veranstaltungsmediens", idx: "sourceUrl_1_kommune_1"},
  {c: "veranstaltungsmediens", idx: "kommune_1"},
];
for (const {c, idx} of drops) {
  try { db.getCollection(c).dropIndex(idx); print("Dropped: " + c + " -> " + idx); }
  catch(e) { print("Skip: " + c + " -> " + idx + " (" + e.message + ")"); }
}
'
```

Verify with:
```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --quiet --eval '
for (const c of ["news-artikels", "veranstaltungsmediens", "benutzers", "_news-artikel_versions"]) {
  print(c + ": " + JSON.stringify(db.getCollection(c).getIndexes().map(i => i.name)));
}
'
```

### 4c. Enable profiling

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --quiet --eval '
db.setProfilingLevel(0);     // must disable before dropping
db.system.profile.drop();    // clear old data
db.setProfilingLevel(2);     // level 2 = all ops (use 1 with slowms for prod-like)
print("Profiling enabled at level 2");
'
```

### 4d. Record baseline server metrics

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --quiet --eval '
const qe = db.serverStatus().metrics.queryExecutor;
print("scanned: " + qe.scanned);
print("scannedObjects: " + qe.scannedObjects);
print("collectionScans.total: " + qe.collectionScans.total);
'
```

**Important:** `serverStatus().metrics.queryExecutor` is cumulative across the MongoDB instance lifetime — it is NOT reset by dump restore or profile drop. Only the `system.profile` collection data is per-session. Always note the baseline before triggering the workload.

### 4e. Trigger the workload

The importers run via cron every 10 minutes with `runOnInit: true`. To speed up profiling:

1. Temporarily change the cron schedule in `web/bereich-b/src/cron-jobs/import-integrations.ts`:
   ```typescript
   const everyMinute = '* * * * *'; // TEMP: profiling — was */10
   ```
2. Save the file — ts-node-dev hot-reload will restart bereich-b, triggering `runOnInit` and then firing every minute.
3. Wait ~90 seconds for at least one full import cycle.
4. **Revert the cron change immediately after profiling.**

### 4f. Capture profile results

```bash
docker exec hameln-mongodb mongosh "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --quiet --eval '
const result = {};

// Profile summary
result.profileSummary = {
  totalOps: db.system.profile.countDocuments(),
  slowQueries_gt50ms: db.system.profile.countDocuments({millis: {$gt: 50}}),
  slowQueries_gt10ms: db.system.profile.countDocuments({millis: {$gt: 10}}),
  collscans: db.system.profile.countDocuments({planSummary: /COLLSCAN/}),
  indexScans: db.system.profile.countDocuments({planSummary: /IXSCAN/}),
  inserts: db.system.profile.countDocuments({op: "insert"}),
  updates: db.system.profile.countDocuments({op: "update"}),
  queries: db.system.profile.countDocuments({op: "query"}),
};

// COLLSCAN breakdown by collection
result.collscanBreakdown = [];
db.system.profile.aggregate([
  {$match: {planSummary: /COLLSCAN/}},
  {$group: {
    _id: "$ns", count: {$sum: 1},
    totalMillis: {$sum: "$millis"}, maxMillis: {$max: "$millis"},
    totalDocsExamined: {$sum: "$docsExamined"}
  }},
  {$sort: {totalDocsExamined: -1}}
]).forEach(doc => result.collscanBreakdown.push(doc));

// IXSCAN breakdown
result.ixscanBreakdown = [];
db.system.profile.aggregate([
  {$match: {planSummary: /IXSCAN/}},
  {$group: {
    _id: "$ns", count: {$sum: 1},
    totalMillis: {$sum: "$millis"}, maxMillis: {$max: "$millis"},
    totalDocsExamined: {$sum: "$docsExamined"},
    totalKeysExamined: {$sum: "$keysExamined"}
  }},
  {$sort: {count: -1}}
]).forEach(doc => result.ixscanBreakdown.push(doc));

// Top 10 slowest
result.top10Slowest = [];
db.system.profile.find({}, {
  op:1, ns:1, millis:1, planSummary:1,
  "command.filter":1, docsExamined:1, nreturned:1, keysExamined:1
}).sort({millis:-1}).limit(10).forEach(doc => result.top10Slowest.push({
  op: doc.op, ns: doc.ns, millis: doc.millis,
  planSummary: doc.planSummary,
  docsExamined: doc.docsExamined, keysExamined: doc.keysExamined,
  nreturned: doc.nreturned, filter: doc.command?.filter
}));

// Server metrics (cumulative)
const qe = db.serverStatus().metrics.queryExecutor;
result.serverMetrics = {
  scanned: Number(qe.scanned),
  scannedObjects: Number(qe.scannedObjects),
  collectionScansTotal: Number(qe.collectionScans.total)
};

print(JSON.stringify(result, null, 2));
'
```

Save the output to `web/bereich-b/docs/<issue>-benchmarks-<before|after>.json`.

### 4g. Before/After comparison workflow

For a full before/after benchmark (e.g., testing index or caching changes):

1. **Before run:** checkout the base branch (e.g., `main`), restore dump, drop custom indexes (4b), enable profiling (4c), trigger workload (4e), capture results (4f)
2. **After run:** checkout the feature branch, restore the SAME dump, enable profiling (4c), trigger workload (4e — `ensureIndexes` will add indexes on startup), capture results (4f)
3. Compare the two JSON files — key metrics: COLLSCANs, docs examined, IXSCAN counts, insert/update counts

## Step 5: Writing a Postmortem

After collecting benchmarks, create a postmortem at `web/bereich-b/docs/<issue>-mongo-performance-postmortem.md`. See `web/bereich-b/docs/117-mongo-performance-postmortem.md` as a reference template. Structure:

1. **Problem** — what was observed, production indicators (serverStatus metrics, COLLSCAN counts)
2. **Root Causes** — missing indexes, N+1 patterns, blind writes, etc.
3. **Fix Summary** — indexes added, caching strategy, change detection, stats tracking
4. **Benchmarks** — before/after comparison tables from the JSON files:
   - COLLSCAN vs IXSCAN counts
   - Docs examined per collection
   - Insert/update counts (shows change detection effectiveness)
   - Index size tradeoff
5. **Files Changed** — table of modified files and what each change does
6. **Recommendations** — monitoring, future index candidates, version collection cleanup

## Your Task

Based on the user's request (`$ARGUMENTS`), execute the appropriate operations above. Always verify the container is healthy first. When restoring, follow all steps in order including cleanup.
