---
name: postgresql
description: "Connect to the local PostgreSQL instance (hameln-postgres container), run queries, find tables, restore dumps, and troubleshoot. Use when a task needs to read or write the backend PostgreSQL database directly, or when a table or column name is uncertain."
allowed-tools: Bash(docker *), Bash(ls *), Grep, Glob, Read
model: sonnet
---

# PostgreSQL Operations — Kommunal-App

## Connection Details

- **Container:** `hameln-postgres`
- **Port:** 5432
- **Credentials:** `admin` / `password` (from `.env.postgres.example`)
- **Database:** `db`
- **All queries run via:** `docker exec hameln-postgres psql -U admin -d db -c "<SQL>"`

## Step 1: Verify the Container

Before any operation, confirm the PostgreSQL container is running:

```bash
docker ps --filter "name=hameln-postgres" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

If not running, start it:

```bash
docker compose -f docker/docker-compose.local.yml -p hameln up -d
```

## Step 2: Find the Right Table Name

The .NET backend uses EF Core with **German table names** that don't always match the C# entity names. Always verify against the actual database.

### List all tables

```bash
docker exec hameln-postgres psql -U admin -d db -c "\dt"
```

### Known table mappings (Entity -> Table)

| C# Entity / Domain Concept     | Actual Table Name                  | Notes                                        |
|:--------------------------------|:-----------------------------------|:---------------------------------------------|
| UserFacingProzess / Prozess     | `UserFacingProzesse`               | TPH: Discriminator = 'Prozess', 'ServicePortalLink' |
| ProzessVersion                  | `ProzessVersionen`                 | **Not** `ProzessVersions`                    |
| Schritt / GovManagerRestExport  | `Schritte`                         | TPH: multiple discriminators                 |
| Ausfuehrung                     | `Ausfuehrungen`                    | Process execution instances                  |
| Bearbeitung                     | `Bearbeitungen`                    | Step submissions with slot values            |
| SlotValue                       | `SlotValues`                       | Form field values (encrypted or plain)       |
| Kommune                         | `Kommunen`                         |                                              |
| User                            | `Users`                            |                                              |
| ProzessGroup                    | `ProzessGroups`                    |                                              |
| ProzessTag                      | `ProzessTags`                      |                                              |
| FormularFeld                    | `FormularFelder`                   |                                              |
| Untereinheit                    | `Untereinheit`                     |                                              |
| GovManagerRequest               | `GovManagerRequests`               |                                              |
| PaymentRequest                  | `PaymentRequests`                  |                                              |
| Verbindung                      | `Verbindungen`                     |                                              |
| EmailOutboxItem                 | `EmailOutboxItems`                 |                                              |
| EF Migrations                   | `__EFMigrationsHistory`            | Migration history                            |

### When a table name is unknown

1. **Check the database directly** — always the most reliable:
   ```bash
   docker exec hameln-postgres psql -U admin -d db -c "\dt" | grep -i "<keyword>"
   ```

2. **Check the EF entity configuration** in the codebase:
   ```
   backend/API/Features/DomainContext.cs     — DbSet declarations
   backend/API/Features/*/                   — Entity classes
   backend/API/Migrations/                   — Migration files with actual CREATE TABLE names
   ```

3. **Search migrations for column names** when you know a column but not the table:
   ```bash
   grep -r '"<ColumnName>"' backend/API/Migrations/ | head -5
   ```

### Describe a table (columns, types, constraints)

```bash
docker exec hameln-postgres psql -U admin -d db -c "\d \"<TableName>\""
```

Example:
```bash
docker exec hameln-postgres psql -U admin -d db -c "\d \"UserFacingProzesse\""
```

### List indexes on a table

```bash
docker exec hameln-postgres psql -U admin -d db -c "\di" | grep -i "<table>"
```

## Step 3: Run Queries

### Basic SELECT

```bash
docker exec hameln-postgres psql -U admin -d db -c "SELECT * FROM \"<Table>\" WHERE \"Id\" = '<uuid>';"
```

**Important syntax notes:**
- Table and column names are **case-sensitive** — always double-quote them: `"UserFacingProzesse"`, `"KommuneId"`
- Use single quotes for string/UUID values: `'78965ab6-...'`
- PostgreSQL uses `true`/`false` for booleans (not 0/1)

### Common query patterns

**Get a Prozess with its GovManager export config:**
```sql
SELECT
    p."Id", p."Name",
    s."MandantenSchluessel", s."VorgangsTyp", s."VorgangsSchluessel",
    s."ExportFilePartsAsPdf", s."ExportParts"
FROM "UserFacingProzesse" p
JOIN "ProzessVersionen" v ON v."ProzessId" = p."Id"
JOIN "Schritte" s ON s."ProzessVersionId" = v."Id"
WHERE p."Id" = '<uuid>'
  AND s."Discriminator" = 'GovManagerRestExportSchritt';
```

**Get all Prozesse for a Kommune:**
```sql
SELECT "Id", "Name" FROM "UserFacingProzesse"
WHERE "KommuneId" = '<kommune-uuid>' AND "Discriminator" = 'Prozess';
```

**Get Ausfuehrung (execution) with submitted data:**
```sql
SELECT a.*, b.*, sv.*
FROM "Ausfuehrungen" a
LEFT JOIN "Bearbeitungen" b ON b."AusfuehrungId" = a."Id"
LEFT JOIN "SlotValues" sv ON sv."BearbeitungId" = b."Id"
WHERE a."Id" = '<ausfuehrung-uuid>';
```

**Get GovManager request status for a process execution:**
```sql
SELECT * FROM "GovManagerRequests" WHERE "AusfuehrungId" = '<ausfuehrung-uuid>';
```

**Get a Kommune by name:**
```sql
SELECT * FROM "Kommunen" WHERE "Name" ILIKE '%hameln%';
```

**Count rows in a table:**
```sql
SELECT COUNT(*) FROM "<Table>";
```

### Formatting output

For wide results, use expanded display:
```bash
docker exec hameln-postgres psql -U admin -d db -c "\x" -c "SELECT * FROM \"<Table>\" WHERE \"Id\" = '<uuid>';"
```

For JSON columns, pretty-print with:
```sql
SELECT jsonb_pretty("ExportParts") FROM "Schritte" WHERE "Id" = '<uuid>';
```

## Step 4: Troubleshoot Queries

### ERROR: relation "X" does not exist

The table name is wrong. This is the most common issue — EF Core uses German pluralization that is not always predictable.

1. List all tables: `\dt`
2. Search by keyword: `\dt *prozess*` or `\dt` piped through grep
3. Check the entity's `DbSet` name in `DomainContext.cs`

### ERROR: column "X" does not exist

Column names are case-sensitive in PostgreSQL when quoted. Check the actual column names:

```bash
docker exec hameln-postgres psql -U admin -d db -c "\d \"<TableName>\""
```

Common pitfalls:
- `"ProzessId"` not `"prozessId"` — EF Core uses PascalCase
- TPH columns (like `MandantenSchluessel`) only exist on rows with the right Discriminator — they will be NULL for other discriminator values

### Query returns empty results

1. **Check the Discriminator** — TPH tables (`UserFacingProzesse`, `Schritte`) store multiple entity types. Add the `"Discriminator"` filter:
   ```sql
   SELECT DISTINCT "Discriminator" FROM "<Table>";
   ```

2. **Check if the ID exists at all:**
   ```sql
   SELECT "Id" FROM "<Table>" WHERE "Id" = '<uuid>';
   ```

3. **Check JOIN relationships** — verify the foreign key column name:
   ```bash
   docker exec hameln-postgres psql -U admin -d db -c "\d \"<Table>\"" | grep -i "fk\|references\|<related>"
   ```

### Query is slow

1. **Use EXPLAIN ANALYZE** to see the query plan:
   ```sql
   EXPLAIN ANALYZE SELECT ... ;
   ```

2. **Check for missing indexes:**
   ```bash
   docker exec hameln-postgres psql -U admin -d db -c "\di"
   ```

3. **Check table sizes:**
   ```sql
   SELECT relname, n_live_tup FROM pg_stat_user_tables ORDER BY n_live_tup DESC;
   ```

### Connection refused

- Verify the container is running: `docker ps --filter "name=hameln-postgres"`
- Ensure you're using `docker exec`, not connecting from host directly (avoids password/auth issues)
- Database name is `db`, not `kommunal-app` or `postgres`

### View EF migration history

```sql
SELECT "MigrationId" FROM "__EFMigrationsHistory" ORDER BY "MigrationId" DESC LIMIT 10;
```

## Step 5: Restore from a Dump

Dump files are **PostgreSQL custom format** (created with `pg_dump -Fc`). Restore using `pg_restore`.

```bash
# 1. Copy dump into container
docker cp ~/Downloads/database_dumps/<dump-file>.dump hameln-postgres:/tmp/

# 2. Terminate active connections to the database
docker exec hameln-postgres psql -U admin -d postgres -c \
  "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'db' AND pid <> pg_backend_pid();"

# 3. Drop and recreate the database
docker exec hameln-postgres psql -U admin -d postgres -c "DROP DATABASE IF EXISTS db;"
docker exec hameln-postgres psql -U admin -d postgres -c "CREATE DATABASE db OWNER admin;"

# 4. Restore (custom format, skip owner/acl to avoid permission issues)
docker exec hameln-postgres pg_restore -U admin -d db --no-owner --no-acl /tmp/<dump-file>.dump

# 5. Verify restore
docker exec hameln-postgres psql -U admin -d db -c \
  "SELECT relname AS table, n_live_tup AS row_count FROM pg_stat_user_tables ORDER BY relname;"

# 6. Clean up
docker exec hameln-postgres rm /tmp/<dump-file>.dump
```

**Important notes:**
- Connect to the `postgres` database (not `db`) when dropping/creating — you can't drop a database you're connected to
- `--no-owner --no-acl` avoids errors when the dump was created by a different user
- If the dump is plain SQL (not custom format), use `psql` instead of `pg_restore`:
  ```bash
  docker exec -i hameln-postgres psql -U admin -d db < /path/to/dump.sql
  ```

## Your Task

Based on the user's request (`$ARGUMENTS`), execute the appropriate operations above. Always verify the container is healthy first. When table names are uncertain, check the database directly before running queries.
