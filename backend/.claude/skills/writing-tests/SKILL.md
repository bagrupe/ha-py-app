---
name: writing-tests
description: >
  Use when writing, changing, running or debugging .NET backend integration tests in
  backend/UnitTests (GraphQLTests, BackendApiFactory, TestSeeder, "Api Tests" collection).
  Covers detecting which test-database infra the checkout uses, running tests on it,
  per-test fresh fixtures, and feature seeder classes for test setup. Keywords: xUnit,
  integration test, dotnet test, GraphQLTests, BackendApiFactory, ResetDB, Respawn,
  TestSeeder, test seeder, fixture, reset-test-db, start-test-services, Api Tests.
---

# Writing backend integration tests

Integration tests live in `backend/UnitTests`. They boot the API through `BackendApiFactory` (a `WebApplicationFactory<API.Program>`) against a dedicated Postgres and execute GraphQL through `GraphQLTests` helpers (`ExecuteGraphqlAsync`, `GetUserToken`, `Principal`, `Anonymous`, `Payload`, `AssertMutationError`).

## Step 1: detect the test infra

The checkout is in one of two states. Check before writing or running anything.

```sh
grep -n "InitializeAsync\|_respawner.ResetAsync" backend/UnitTests/AppIntegrationTests.cs
grep -n "backend:start-test-services" Taskfile.yml
ls backend/UnitTests/DockerTestUtility.cs
```

| Signal | Reset infra | No-reset infra |
|---|---|---|
| `GraphQLTests.InitializeAsync` | calls `Factory.ResetDB()` | empty or commented-out `ResetDB` |
| `BackendApiFactory.ResetDB` | runs `_respawner.ResetAsync(...)` | Respawn code commented out |
| Root `Taskfile.yml` | has `backend:start-test-services` | only `backend:reset-test-db` |
| `DockerTestUtility.ResetTestDBForLocalTests()` | absent | present (runs `task backend:reset-test-db` on macOS outside CI) |

## Step 2: read the reference that applies

- [references/running-tests.md](references/running-tests.md): starting services, running a class, what state a test starts from.
- [references/fresh-fixtures.md](references/fresh-fixtures.md): how each test builds and asserts on its own data.
- [references/creating-seeding-tests.md](references/creating-seeding-tests.md): where setup code goes (feature seeders, `TestSeeder`, app seeders).

## Rules that hold on both infras

- DB tests are `[Collection("Api Tests")]` and derive from `GraphQLTests`. The collection runs serialized and shares one `BackendApiFactory`.
- Each test creates the data it asserts about. No test depends on another test's data or on order.
- Test data never goes into `backend/API/Seeders/`.
- Values in unique-indexed columns (email, phone) are generated per test, never hardcoded literals.
