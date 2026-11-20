# Running backend integration tests

## Both infras

- Test DB: Postgres from `docker/docker-compose-testing.local.yml` (project `hameln-test`), host port 5433, database `local_test_db`. `TEST_DB_CONNECTION` overrides the connection string.
- Object storage: S3-compatible RustFS from the same compose file on port 9010. `TEST_OBJECT_STORAGE_*` variables override it.
- DB tests are `[Collection("Api Tests")]`, which disables parallelization. `xunit.runner.json` also disables assembly and collection parallelism.
- Never run two test processes against the same DB at the same time.
- Readiness check: `pg_isready -h 127.0.0.1 -p 5433`.
- Run one class: `dotnet test backend/UnitTests/UnitTests.csproj --filter FullyQualifiedName~<Class>`.

## Reset infra

- Start services once: `task backend:start-test-services`. It keeps existing data.
- Run tests as often as needed. No manual reset between runs.
- Before each `GraphQLTests` test, `BackendApiFactory.ResetDB` runs Respawn. It deletes all application data, including archive tables, and keeps `__EFMigrationsHistory`, `__EFMigrationsHistory_Archive` and `DataProtectionKeys`.
- After the wipe, `ResetDB` restores the startup baseline: system user, `AufbewahrungsEinstellungen`, the `BeforeImports` DataSeeders, the Aerzen Untereinheit (`KommuneSeeder.AerzenOrganisationseinheitId`, stands in for the HTTP Gemeinde importer), then the `AfterImports` DataSeeders.
- Which DataSeeders run is decided by their registration in `backend/API/Program.cs` for the `Testing` environment. Check that block to know the exact baseline.
- The seeded superadmin's crypto columns come precomputed from `DataSeeder:SuperAdminCrypto` in `backend/API/appsettings.Testing.json`, so seeding does not generate RSA keys per reset.
- `task backend:reset-test-db` still recreates the containers and volumes. Use it when the schema or container state is broken.

## No-reset infra

- Nothing cleans the DB between tests or between runs. Data from every earlier test stays.
- Before every run: `task backend:reset-test-db`, wait for `pg_isready`, then `CI=true dotnet test ...`. `CI=true` stops `DockerTestUtility` from resetting again inside the run.
- A failure on a DB that was not freshly reset is not evidence. Never call a failure pre-existing without reproducing it on a freshly reset DB.

## Reading failures

- `23505 duplicate key ... "IX_..."`: a test inserted a value that already exists. On the reset infra the other row comes from the baseline seed; on the no-reset infra it can come from any earlier test. Check the seeders and other tests for the same literal.
- Errors like "key not found in the key ring": `DataProtectionKeys` was deleted while the host was running.
