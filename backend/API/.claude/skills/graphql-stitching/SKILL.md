---
name: graphql-stitching
description: >
  Use when working on how the .NET backend/API integrates the Payload CMS (BereichB) — the
  stitched remote schema and @delegate fields in Stitching.graphql, the generated BereichB.graphql
  remote schema, adding or fixing a delegated field, the StrawberryShake IBereichBClient for
  server-to-server calls to Payload, JSON/serialization quirks in stitched fields, $fields scoped
  variables, type-name collisions, or the Internal/BereichB named schemas. Also use when a stitched
  field returns wrong/empty data, a Kommune field unexpectedly comes from the CMS, or a Payload
  type name clashes with a backend type. For building the .NET GraphQL surface itself (queries,
  mutations, scalars, errors, auth, schema export) see the hotchocolate skill; for EF/DataLoaders
  see ef-core. Keywords: schema stitching, delegate, Stitching.graphql, BereichB.graphql,
  AddRemoteSchemaFromFile, IBereichBClient, StrawberryShake, FixStitchedJsonTypeInterceptor,
  StitchingFieldResolverHelperMiddleware, RenameType, $fields, $arguments, Payload CMS,
  Kommune.name, Internal schema, ignoreRootTypes.
---

# Stitching & the BereichB (Payload CMS) integration

## Two separate integrations — don't conflate them

The backend talks to Payload CMS/BereichB in **two independent ways, over two different named HttpClients**:

| Purpose | Mechanism | Named client | Wired at |
|---|---|---|---|
| Client-facing federated schema (browser/app read CMS data through one schema) | schema **stitching**: `AddRemoteSchemaFromFile("BereichB", …)` + `@delegate` | **"BereichB"** | `Program.cs` (grep `AddBereichBClient`, `AddRemoteSchemaFromFile`) |
| Backend server-to-server (sync jobs, services write/read CMS) | **StrawberryShake** `IBereichBClient` | **"BereichBClient"** | `Program.cs` |

Rule of thumb: a **client asks for CMS data through the API** → stitching. The **backend itself needs to call CMS** (importers, synchronizers, design lookups, push jobs) → `IBereichBClient`.

## Stitching (client-facing)

### The files
- **`BereichB.graphql`** (~25k lines) — the Payload CMS remote schema, **generated in bereich-b** (`pnpm graphql`). Loaded with `AddRemoteSchemaFromFile("BereichB", "BereichB.graphql", ignoreRootTypes: true)` (`Program.cs`). `ignoreRootTypes` keeps Payload's `Query`/`Mutation` roots out of the local roots, so the **only** access is through curated `@delegate` fields.
- **`Stitching.graphql`** (~129 lines) — hand-written type extensions merged via `AddTypeExtensionsFromFile("./Stitching.graphql")` (`Program.cs`).
- **`AddPayloadCmsTypes()`** (`Infrastructure/PayloadCmsExtensions.cs`) — registers Payload's `AnyType` scalars (`JSONObject`, `EmailAddress`) on both the Default and "BereichB" schemas.

### Three kinds of `@delegate`
```graphql
# 1. Root passthrough — expose a BereichB root query as a local camelCase field
extend type Query {
  newsArtikel(id: String!): NewsArtikel @delegate(schema: "BereichB", path: "NewsArtikel")
}

# 2. Cross-schema join on the LOCAL Kommune, feeding a remote lookup with $fields:id
extend type Kommune {
  name: String! @delegate(schema: "BereichB", path: "KommuneByBereichAId(kommuneId: $fields:id).name")
}

# 3. Delegation to the private "Internal" schema (sensor history), consuming several parent fields
extend type Sensoren_Felder {
  historie(duration: HistoryMode!): [SensorHistorieEintrag!]!
    @delegate(schema: "Internal",
      path: "historie(sensorname: $fields:sensorname, feldname: $fields:name, duration: $arguments:duration, fetch: $fields:hasHistorie)")
}
```
`$arguments:x` forwards a field argument; `$fields:x` feeds a parent field into the remote path.

> **GOTCHA — `Kommune.name` is served by Payload, not Postgres.** The local `Kommune` entity has a real `Name` column (`Features/Kommune/Kommune.cs:9`, not `[GraphQLIgnore]`), but the `@delegate` **overrides the local resolver**, so `name` / `design` / legal text come from the CMS. Verify before assuming a `Kommune` field reads from the DB.

### Add or change a delegated field (backend side)
1. Confirm the target type/field exists in `BereichB.graphql`. If not, it must be added on the Payload side and `BereichB.graphql` regenerated first.
2. Add an `@delegate` entry to `Stitching.graphql` — root passthrough, or a `$fields:…` join on a local type. `path` is the BereichB field path; args auto-forward by name.
3. `dotnet run -- export-schema-only`, then downstream codegen (see the **hotchocolate** skill).

### The two stitching infrastructure pieces (why they exist — don't remove them)
- **`FixStitchedJsonTypeInterceptor`** (`Infrastructure/FixStitchedJsonTypeInterceptor.cs`, registered `Program.cs`) — fixes stitched `JSON`-scalar serialization. Stitched JSON fields arrive as HotChocolate AST node wrappers; the interceptor injects middleware that unpacks them (`UnpackNodes`) and re-serializes to real JSON. Without it, Payload `JSON` fields serialize as node wrappers instead of primitives.
- **`StitchingFieldResolverHelperMiddleware`** (`Infrastructure/StitchingFieldResolverHelper.cs`, registered `Program.cs`) — global field middleware that makes `$fields:…` scoped variables resolve against local objects (flattens value nodes and camelCases the parent dictionary). **Fragile:** it inspects the runtime stack for an internal HotChocolate type name, so a HC upgrade can break it — re-test stitched `$fields` joins after upgrades.

### Named schemas
- **"Default"** (`Schema.DefaultName`) — the main federated schema exported to frontends.
- **"BereichB"** — the remote Payload schema slot used by `@delegate`.
- **"Internal"** (`Program.cs`, `AddLocalSchema("Internal", …).AddQueryType<SensorenExtensions>()`) — a private local schema whose only job is to back `Sensoren_Felder.historie`; its resolver (`Features/BereichB/SensorenExtensions.cs`) fetches from the BereichB REST API via a `[DataLoader]`.

### Type-name collisions
`RenameType("Untereinheit", "BereichBUntereinheit", "BereichB")` (`Program.cs`) — the local EF `Untereinheit` and the remote Payload `Untereinheit` collide; the remote one is renamed so both coexist. Expect a **`BereichB`-prefixed** name (`BereichBUntereinheit`, `BereichBKommune_Lizenzen`, …) whenever a Payload type name clashes with a backend type.

## StrawberryShake `IBereichBClient` (server-to-server)

- Lives in `Clients/BereichBClient/`. Config `.graphqlrc.json` (client `BereichBClient`, namespace `API.Clients.BereichBClient`); codegen runs via **MSBuild** (`API.csproj:96-101`) from hand-written `.graphql` operation docs (`untereinheiten.graphql`, `user.graphql`, `kommune.graphql`, `news-artikel.graphql`, …). `schema.extensions.graphql` carries the StrawberryShake directives; `Clients/BereichBClient/schema.graphql` is that client's copy of the Payload schema.
- Registered `Program.cs`: `AddBereichBClient().ConfigureHttpClient(...)` sets `BaseAddress = {BereichB:ApiUrl}/graphql` and header `Authorization: benutzer API-Key {BereichB:SuperAdminApiKey}`.
- Injected as `IBereichBClient` into services/jobs: `Features/BereichB/UntereinheitenSynchronizer.cs`, `BackofficeUserSynchronizer.cs`, `Features/Kommune/Design.cs`, `Features/MaengelMelder/MaengelSichtbarkeitService.cs`, push-notification jobs, `Scripts/ImportKategorieBaum/`.
- **To add an operation:** add/extend a `.graphql` doc under `Clients/BereichBClient/`, build (MSBuild regenerates the typed client), inject `IBereichBClient`, call the generated method. If Payload's schema changed, refresh `Clients/BereichBClient/schema.graphql` first.

## Gotchas

- The stitching client **"BereichB"** and the server-to-server client **"BereichBClient"** are different HttpClients. Integration tests stub only "BereichBClient" (+ "BereichBInternal" for SSO) — querying a stitched-only field (e.g. `Kommune.name`) in a test needs the "BereichB" client stubbed too (`UnitTests/AppIntegrationTests.cs`).
- `ignoreRootTypes: true` means you **cannot** query a Payload root directly through the backend — only via a `@delegate` you added.
- `$fields:x` requires `StitchingFieldResolverHelperMiddleware`; stitched `JSON` requires `FixStitchedJsonTypeInterceptor`. Both are registered in `Program.cs` (208 / 220) — removing either silently breaks stitched joins / JSON fields.
- The Payload side runs on **v3** now (Next.js). The stitching contract is `BereichB.graphql` + `@delegate`; changes to Payload collections require regenerating `BereichB.graphql` from bereich-b.

## Key files

- `Stitching.graphql`, `BereichB.graphql` — stitching definitions + generated remote schema
- `Program.cs` — grep `AddBereichBClient` (data source + both clients), `AddRemoteSchemaFromFile` / `AddTypeExtensionsFromFile` (remote schema + type extensions), `RenameType`, `AddLocalSchema` (named schemas)
- `Infrastructure/FixStitchedJsonTypeInterceptor.cs`, `Infrastructure/StitchingFieldResolverHelper.cs`, `Infrastructure/PayloadCmsExtensions.cs`
- `Clients/BereichBClient/` — StrawberryShake client (config, ops, generated code)
- `Features/BereichB/` — synchronizers + `SensorenExtensions` (Internal schema)
- Building the .NET GraphQL surface → **hotchocolate** skill; EF/DataLoaders → **ef-core** skill.
