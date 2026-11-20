---
name: bereich-b-payload-collections
description: "Dictionary of bereich-b (Payload CMS v3) collections — every Payload slug and its exact MongoDB collection name, with pluralization gotchas and phantom/legacy collections. Use when a raw Mongo query, index, or migration needs the physical MongoDB collection behind a Payload slug."
allowed-tools: Bash(docker *)
model: sonnet
---

# bereich-b Collection Dictionary — Payload CMS v3

`web/bereich-b` is **Payload CMS v3** (payload `3.88.0`, Next.js 16). The MongoDB
adapter (`@payloadcms/db-mongodb`) derives each physical collection name by
**mongoose-pluralizing the slug** — there are **no `dbName` overrides** in the
collection configs, so the slug alone determines the Mongo name. Most map by
adding `s`, but a few do not (see Gotchas).

## Connection

- **DB name:** `bereich-b`
- **Container:** `hameln-mongodb`
- **Mongo URI:** `mongodb://admin:password@localhost:27017/bereich-b?authSource=admin`
- **REST/GraphQL routes:** `/cms/api` and `/cms/admin` (dev server on port 3001)

```bash
docker exec hameln-mongodb mongosh --quiet \
  "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" \
  --eval 'db.getCollectionNames().sort().forEach(c => print(c + "\t" + db.getCollection(c).countDocuments()))'
```

## Registered collections (slug → MongoDB collection)

These 20 collections are registered in `src/payload.config.ts` (`payloadCollections`).
Use the **Payload slug** for REST (`/cms/api/<slug>`) and GraphQL; use the
**MongoDB collection** only for raw `mongosh`/index/migration work.

| Payload slug                        | MongoDB collection                    | Notes |
|:------------------------------------|:--------------------------------------|:------|
| `kommunen`                          | `kommunens`                           | Tenants (municipalities) |
| `benutzer`                          | `benutzers`                           | Auth collection (`useAPIKey: true`, `useSessions: false`) |
| `untereinheit`                      | `untereinheits`                       | Organization units |
| `medien`                            | `mediens`                             | Upload |
| `poi-icons`                         | `poi-icons`                           | Upload — already-plural stem, unchanged |
| `veranstaltungsmedien`             | `veranstaltungsmediens`               | Upload |
| `aufrufemedien`                     | `aufrufemediens`                      | Upload |
| `news-artikel`                      | `news-artikels`                       | Versioned → also `_news-artikel_versions` |
| `aufrufe`                           | `aufruves`                            | ⚠ `fe`→`ves` — see Gotchas |
| `veranstaltungskalender`            | `veranstaltungskalenders`             | Events |
| `veranstaltungskalender-kategorie`  | `veranstaltungskalender-kategories`   | `ie`→`ies` |
| `veranstaltungskalender-quelle`     | `veranstaltungskalender-quelles`      | Import sources |
| `poi`                               | `pois`                                | Points of interest |
| `poi-categories`                    | `poi-categories`                      | Already-plural stem, unchanged |
| `poi-supercategories`               | `poi-supercategories`                 | Already-plural stem, unchanged |
| `sensoren`                          | `sensorens`                           | Sensors |
| `sensor-art`                        | `sensor-arts`                         | Sensor types |
| `wettermesspunkte`                  | `wettermesspunktes`                   | `e`→`es` |
| `geo-flaechen`                      | `geo-flaechens`                       | Geographic areas |
| `integration`                       | `integrations`                        | Integration configs |

## Gotchas — do not assume "slug + s"

- **`aufrufe` → `aufruves`** (mongoose pluralizes `…fe` like knife→knives).
  A **phantom empty `aufrufes` collection (0 docs)** also exists from an earlier
  bad pluralization — the real data lives in **`aufruves`**. Never query
  `aufrufes`.
- **Already-plural stems stay unchanged:** `poi-icons`, `poi-categories`,
  `poi-supercategories`.
- **`…ie` → `…ies`:** `veranstaltungskalender-kategorie` → `…-kategories`.
- **Versioned collections** get a sibling `_<slug>_versions`: `news-artikel`
  → `_news-artikel_versions`.

## Payload-internal collections (v3)

| MongoDB collection          | Purpose |
|:----------------------------|:--------|
| `payload-migrations`        | Migration tracking (run via `pnpm migrate`) |
| `payload-preferences`       | Admin UI preferences |
| `payload-locked-documents`  | Document locking (v3) |
| `payload-kvs`               | Key-value store |

## Legacy / non-app collections (NOT registered in v3)

Present in the DB from the v1→v3 restore but **not** managed by this install —
ignore for app work:

| MongoDB collection          | Why it's here |
|:----------------------------|:--------------|
| `gemeinde-informationens`   | v1 leftover collection (no v3 slug registers it) |
| `aufrufes`                  | Phantom empty pluralization of `aufrufe` (real data → `aufruves`) |
| `_preferences`              | v1-era preferences (v3 uses `payload-preferences`) |
| `system.profile`           | MongoDB profiler output, not app data |
