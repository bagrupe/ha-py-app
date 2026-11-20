---
name: ef-core
description: >
  Use when working in the .NET backend/API database layer — the DomainContext, EF Core
  queries, LINQ, migrations, DataLoaders, HotChocolate resolvers that read/write data,
  adding entities or DbSets, NodaTime Instant timestamps, value converters, TPH entities,
  or N+1 issues. Encodes THIS project's actual EF Core 9 + Npgsql + HotChocolate 13
  conventions (pooled DbContext factory, global NoTracking, offset paging, feature-local
  configs) which differ from generic EF Core advice. Keywords: EF Core, Entity Framework,
  DbContext, DomainContext, migration, LINQ, DataLoader, Include, N+1, NodaTime, Instant,
  value converter, IEntityTypeConfiguration, Npgsql, HotChocolate, IQueryable, UseOffsetPaging.
---

# EF Core in the Kommunal-App backend (.NET 8)

## Stack

.NET 8 · EF Core 9 (`Npgsql.EntityFrameworkCore.PostgreSQL` + `.NodaTime` 9.0.3) · PostgreSQL 15 · one `DomainContext` · HotChocolate 13 GraphQL. Everything is organized under `Features/<Domain>/`. There is **no repository/UnitOfWork layer** — resolvers and DataLoaders query `DbSet`s directly.

> This project deviates from generic "EF Core best practice" in several deliberate ways (auto-migrate on startup, pooled factory, NoTracking default, `int` enums, offset paging, no `[UseProjection]`). Match what is here; don't "modernize" silently. Raise it explicitly first.

## Core Principles

1. **One `DomainContext`** at `Features/DomainContext.cs`, registered as a **pooled factory** with a **global `NoTracking`** default and NodaTime (`Program.cs`). `OnModelCreating` uses `ApplyConfigurationsFromAssembly` (`DomainContext.cs`).

2. **How you obtain a context depends on where you are** — the #1 gotcha:
   - In `[QueryType]` / `[MutationType]` / `[ExtendObjectType<T>]` resolvers → inject `DomainContext` **directly** (works because of `RegisterDbContext<DomainContext>(DbContextKind.Pooled)`, `Program.cs`).
   - In `[DataLoader]` static methods → inject `IDbContextFactory<DomainContext>` and open a short-lived `await using var db = await factory.CreateDbContextAsync(ct)`.
   - Injecting the factory into a `[QueryType]`/`[Mutation]` resolver breaks the schema build with `resolve schema type ... (Input)`. The factory belongs **only** inside `[DataLoader]`.

3. **N+1 is solved with `[DataLoader]`, not `.Include()`.** Batch by key and return `IReadOnlyDictionary<K,V>` (to-one) or `ILookup<K,V>` (to-many).

4. **Timestamps are NodaTime `Instant`, never `DateTime`.** Read "now" from the injected `IClock` (registered as `SystemClock.Instance`, `Program.cs`), never `DateTime.UtcNow`.

5. **Writes are deliberate under NoTracking:** `.Add(...)` for inserts; `.AsTracking()` on the load when you load → mutate → `SaveChangesAsync`.

6. **Migrations auto-apply on startup** via `await context.Database.MigrateAsync()` (`Program.cs`). This is intentional here — don't add environment guards; add the migration and it applies on next run.

## Patterns

### Entity + configuration (co-located per feature)

Entity and its `IEntityTypeConfiguration<T>` live in the **same file** inside the feature folder — there is no central `Configurations/` folder. Keys are plain `Guid`; enums persist as `int` (EF default). Data annotations (`[PrimaryKey]`, `[Column(TypeName = "jsonb")]`, `[NotMapped]`) are used alongside fluent config. `[GraphQLDescription]`/`[GraphQLIgnore]` are HotChocolate, not EF.

```csharp
// Features/Ehrenamtsbank/EhrenamtsbankKategorie.cs
public class EhrenamtsbankKategorie {
    public Guid Id { get; set; }
    public required string Name { get; set; }
    public Guid? ParentId { get; set; }
    [GraphQLIgnore] public EhrenamtsbankKategorie? Parent { get; set; }
}

public class EhrenamtsbankKategorieConfig : IEntityTypeConfiguration<EhrenamtsbankKategorie> {
    public void Configure(EntityTypeBuilder<EhrenamtsbankKategorie> builder) {
        builder.HasOne(e => e.Parent).WithMany()
            .HasForeignKey(e => e.ParentId).OnDelete(DeleteBehavior.Restrict);
        builder.Property(e => e.Active).HasDefaultValue(true);
    }
}
```

Then declare the set in `DomainContext` and let assembly scanning pick up the config:

```csharp
public DbSet<Ehrenamtsbank.EhrenamtsbankKategorie> EhrenamtsbankKategorien { get; set; } = null!;
```

### Query resolver — return `IQueryable<T>`, let middleware compose

Inject `DomainContext` directly and return `IQueryable<T>` so paging/filtering middleware can push predicates to SQL. This project uses **offset paging** and `[UseFiltering]`. It does **not** use `[UseProjection]`, `[UseSorting]`, or cursor `[UsePaging]` anywhere.

```csharp
// Features/Prozess/Queries/AusfuehrungQueries.cs (shape)
[UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
[UseFiltering]
[Authorize]
[Error(typeof(NotAllowedException))]
public IQueryable<Ausfuehrung> GetAusfuehrungen(DomainContext domainContext, [Service] IClock clock) {
    return domainContext.Ausfuehrungen.AsSplitQuery();
}
```

Use `.AsSplitQuery()` when a query pulls multiple collections — the `MultipleCollectionIncludeWarning` is configured to **throw** in DEBUG (`Program.cs`).

### DataLoader — batch to kill N+1

Static method, factory-owned short-lived context, batched key lookup:

```csharp
// Features/Kommune/Queries/KommuneQueries.cs
[DataLoader]
internal static async Task<IReadOnlyDictionary<Guid, Kommune>> GetKommuneById(
    IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> factory, CancellationToken ct) {
    await using var db = await factory.CreateDbContextAsync(ct);
    return await db.Kommunen.Where(k => ids.Contains(k.Id)).ToDictionaryAsync(k => k.Id, ct);
}
```

The generated `I{Name}DataLoader` interface is injected into field resolvers; use `ToLookupAsync` for to-many relations. Filter soft-deletes explicitly here (e.g. `!u.MarkedForDelete`) — there are no global query filters.

### Mutation — write under NoTracking

```csharp
// Insert: Add() tracks the new graph explicitly
domainContext.Dienstleister.Add(dienstleister);
await domainContext.SaveChangesAsync(ct);

// Update: AsTracking() so the change tracker sees mutations
var user = await domainContext.BackofficeUser.AsTracking()
    .FirstOrDefaultAsync(u => u.Id == id, ct);
user!.Confirmed = true;
await domainContext.SaveChangesAsync(ct);
```

### Value converters

Cross-cutting types are wired **globally** in `ConfigureConventions` (`DomainContext.cs`): `EncryptedValue`, `StringExpression`, `IntExpression`, `BoolExpression`. Per-property converters use `HasConversion<T>()` (e.g. `LowerCaseValueConverter` on email columns). Freeform JSON uses `[Column(TypeName = "jsonb")]` (Npgsql `EnableDynamicJson()` is on).

### TPH inheritance

Hierarchies (`Schritt`, `FormularFeld`, `SlotValue`, `User`, `UserFacingProzess`) use default table-per-hierarchy with an auto-discovered string `Discriminator` column. Each leaf gets its own `DbSet`. Adding a subtype = new class + leaf `DbSet` + config + migration.

## Schema-change workflow

1. Add/modify the entity + its `IEntityTypeConfiguration` in the feature file.
2. Add/adjust the `DbSet<T>` on `DomainContext`.
3. `dotnet ef migrations add <PascalCaseName>` — `dotnet ef` boots the app host (no design-time factory); it reads connection string **`Domain`**.
4. **Review the generated migration** before running (data loss, index strategy, discriminator changes).
5. It auto-applies on next `dotnet run` (or `dotnet ef database update`).
6. If the change is GraphQL-visible, re-export the stitched schema: `dotnet run -- export-schema-only`, then run downstream codegen (bereich-a `pnpm graphql`, app `task app:gen`).

## Anti-patterns

- ❌ `IDbContextFactory<DomainContext>` in a `[QueryType]`/`[Mutation]`/`[ExtendObjectType]` resolver → schema build error. Inject `DomainContext`. Factory **only** in `[DataLoader]`.
- ❌ Wrapping `DomainContext` in a repository / UnitOfWork. Use `DbSet`s directly.
- ❌ Fixing N+1 with `.Include()` inside a per-parent field resolver. Use a `[DataLoader]`.
- ❌ `DateTime` / `DateTime.UtcNow`. Use `Instant` + injected `IClock`.
- ❌ Assuming entities are tracked. Global default is `NoTracking` — `.AsTracking()` before load-modify-save; `.Add()` for inserts.
- ❌ `.ToListAsync()` then filtering/sorting/projecting in memory. Filter in the DB; for GraphQL return `IQueryable` and let `[UseOffsetPaging]`/`[UseFiltering]` compose.
- ❌ Introducing `[UseProjection]`, `[UseSorting]`, cursor `[UsePaging]`, global query filters, enum-as-string, or snake_case naming "because it's best practice" — none are used here. Match the convention or raise it first.
- ❌ Forgetting `await SaveChangesAsync(ct)` (fire-and-forget bug).

## Decision guide

| Scenario | Do this here |
|----------|-------------|
| Read a list for GraphQL | Return `IQueryable<T>` from a `[QueryType]` + `[UseOffsetPaging]` + `[UseFiltering]` |
| Single entity by id | `[DataLoader]` → `IReadOnlyDictionary<Guid,T>`, injected as `I…ByIdDataLoader` |
| Related data per-parent (N+1) | `[DataLoader]` → `ILookup<Guid,T>` |
| One query, multiple collections | `.AsSplitQuery()` (multi-collection include throws in DEBUG) |
| Insert | inject `DomainContext`, `.Add()`, `await SaveChangesAsync(ct)` |
| Update existing | `.AsTracking()` load → mutate → `SaveChangesAsync` |
| Timestamp | NodaTime `Instant` + injected `IClock` |
| Store an enum | plain `int` (EF default) |
| Encrypted / expression value | value converter via `ConfigureConventions` |
| Freeform JSON column | `[Column(TypeName = "jsonb")]` |
| Schema change | migration → review → auto-applied on startup → re-export GraphQL schema |
| Exercise DB code in a test | integration test via `WebApplicationFactory<API.Program>` against real Postgres (no InMemory) |

## Key files

- `Features/DomainContext.cs` — the context, `DbSet`s, `ConfigureConventions`
- `Program.cs` — Npgsql data source (`Domain` conn string, NodaTime, dynamic JSON)
- `Program.cs` — `AddPooledDbContextFactory` + global `NoTracking`
- `Program.cs` — `RegisterDbContext<DomainContext>(DbContextKind.Pooled)`
- `Program.cs` — `MigrateAsync()` auto-apply on startup
- `Features/<Domain>/<Entity>.cs` — entity + `IEntityTypeConfiguration`
- `Features/<Domain>/Queries/*.cs`, `Mutations/*.cs` — resolvers + DataLoaders
- `Migrations/` + `DomainContextModelSnapshot.cs`
- `backend/UnitTests/AppIntegrationTests.cs` — real-Postgres integration test harness
