# Fresh fixtures

Each test creates the data it asserts about. xUnit Test Patterns calls this a Fresh Fixture. A Shared Fixture (a pre-seeded world that tests read from) is not used: it couples tests through data, so one test's change breaks another.

## Unique values

Generate identifiers and unique-indexed values per test, on both infras.

```csharp
var gebiet = new Gebiet {
    Id = Guid.NewGuid(),
    UntereinheitId = untereinheit.Id,
    Name = $"Gebiet {Guid.NewGuid():N}",
    Geometry = Polygon,
};
var email = $"backoffice-test-{Guid.NewGuid():N}@test.local";
```

- No-reset infra: required, because rows pile up across the whole run.
- Reset infra: the DB holds only the baseline seed plus the test's own rows. Unique values still prevent collisions with that seed (for example a hardcoded phone number that a registered DataSeeder also uses).

## Scoped assertions

Assert on the test's own ids.

```csharp
Assert.Contains(ids, id => id == gebiet.Id);
Assert.DoesNotContain(ids, id => id == fremdesGebiet.Id);
var row = Assert.Single(rows, r => r.Id == gebiet.Id);
```

- No-reset infra: never assert global counts, "all rows" or empty lists. Other tests' rows are present.
- Reset infra: the only foreign rows are the baseline seed. Scoped assertions still keep tests independent of what the baseline contains.

## DAMP over DRY

The test body shows the facts the assertion depends on and hides everything else.

```csharp
[Fact]
public async Task Nutzer_sieht_nur_Gebiete_seiner_Untereinheit() {
    var eigene = await seeder.SeedUntereinheit();
    var fremde = await seeder.SeedUntereinheit();
    var eigenesGebiet = NewGebiet(eigene.Id);
    var fremdesGebiet = NewGebiet(fremde.Id);
    await seeder.SeedGebiet(eigenesGebiet);
    await seeder.SeedGebiet(fremdesGebiet);
    var nutzer = await testSeeder.CreateBackofficeUserPrincipal();

    var ids = LoadedGebietIds(await QueryGebiete(nutzer));

    Assert.Contains(eigenesGebiet.Id, ids);
    Assert.DoesNotContain(fremdesGebiet.Id, ids);
}
```

Crypto setup, password hashes, JWT minting, unique emails and required-but-irrelevant columns belong in helpers, not in the test body.

## Refactoring test code

Refactor is part of the TDD loop and applies to tests. When the same setup appears a third time, extract it into a seeder method or helper.
