# Where test setup code goes

| Kind of code | Home |
|---|---|
| Feature-specific entities (Gebiete, Einträge, Gruppen, ...) | `<Feature>Seeder` class in `backend/UnitTests/` |
| Cross-cutting actors (backoffice users, Bürger, their `ClaimsPrincipal`s) | `TestSeeder` |
| Query wrappers and result readers | private helpers in the test class |
| App baseline data | `backend/API/Seeders/` (never test data) |

## Feature seeder

A `<Feature>Seeder(BackendApiFactory factory)` class, built like `TestSeeder`.

- Static `New*` methods build entities in memory and write nothing. Tests use them to hold ids before seeding.
- `Seed*` methods write to the DB, each through its own scope and `DomainContext`.
- Entities that already exist are attached, not re-added.

```csharp
public class GebietSeeder(BackendApiFactory factory) {
    private DomainContext NewDb() =>
        factory.Services.CreateScope().ServiceProvider.GetRequiredService<DomainContext>();

    public static MitarbeiterGruppe NewMitarbeiterGruppe(Untereinheit owner) => new() {
        Id = Guid.NewGuid(),
        Name = $"Gruppe {Guid.NewGuid():N}",
        KommuneId = owner.KommuneId,
        Organisationseinheiten = [owner],
    };

    public async Task SeedMitarbeiterGruppen(Untereinheit owner, params MitarbeiterGruppe[] gruppen) {
        var db = NewDb();
        db.Untereinheit.Attach(owner);
        db.MitarbeiterGruppen.AddRange(gruppen);
        await db.SaveChangesAsync();
    }
}
```

The test class holds an instance (`private readonly GebietSeeder seeder = new(factory);`) and can `using static` the seeder for the `New*` methods.

## Actors in TestSeeder

Every `GraphQLTests` subclass has a `testSeeder` field. Actors are created there once, with defaults for everything a test does not care about.

```csharp
public async Task<ClaimsPrincipal> CreateBackofficeUserPrincipal(
    BackofficeNutzerArt art = BackofficeNutzerArt.Nutzer,
    List<GlobaleFunktionsberechtigung>? funktionsberechtigungen = null) { ... }
```

If the needed actor helper does not exist yet, add it to `TestSeeder` instead of writing another inline `new BackofficeUser { ... }` in a test class.

## Gotcha: backoffice user crypto

`CurrentUserAccessor.User()` rejects a Mitarbeiter without `OrganisationPrivateKey`. A backoffice user built for a test needs `TestUserCrypto.InitializeMitarbeiterCrypto(user, password, kommune.KeyEncryptionKey, hasher)` before saving, even when the JWT is minted directly with `user.GetToken(jwtOptions)` and no login happens.

```csharp
var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
TestUserCrypto.InitializeMitarbeiterCrypto(
    user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
db.BackofficeUser.Add(user);
await db.SaveChangesAsync();

var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
return new ClaimsPrincipal(new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt"));
```

## App seeders are not test setup

`backend/API/Seeders/` defines the app's own baseline (Kommunen, superadmins, dev demo data). A DataSeeder registered for the `Testing` environment in `backend/API/Program.cs` runs at host startup and, on the reset infra, before every test. Adding test data there makes every test start with it.
