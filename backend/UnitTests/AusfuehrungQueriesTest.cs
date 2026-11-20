using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using API.Features;
using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Prozess.Queries;
using API.Features.Untereinheit;
using API.Infrastructure;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Integration coverage for <see cref="AusfuehrungQueries.GetAusfuehrungen"/> when filtering
/// <see cref="AusfuehrungStatus.Abgeschlossen"/> by <see cref="AusfuehrungQueries.CutoffDays"/> for non–superadmin users.
/// </summary>
[Collection("Api Tests")]
public class AusfuehrungQueriesTest(BackendApiFactory factory) : GraphQLTests(factory) {
    /// <summary>Stable IDs so repeated test runs against a shared DB do not multiply processes.</summary>
    private static readonly Guid TestCutoffProzessId = new("a1c0ffee-0000-4000-8000-000000000001");

    private static readonly Guid TestCutoffVersionId = new("a1c0ffee-0000-4000-8000-000000000002");
    private static readonly Guid TestCutoffEndeSchrittId = new("a1c0ffee-0000-4000-8000-000000000003");

    private const string PlainPassword = "123456";

    private const string QueryAusfuehrungenAbgeschlossen = """
        query AusfuehrungenAbgeschlossen($status: AusfuehrungStatus!, $take: Int!) {
          ausfuehrungen(status: $status, take: $take) {
            items {
              id
            }
          }
        }
        """;

    [Fact]
    public async Task GetAusfuehrungen_Abgeschlossen_Superadmin_sieht_alte_und_neue_Antraege() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (altId, neuId) = await SeedZweiAbgeschlosseneMitOrganisationseinheitZustaendigkeit();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var unsere = await QueryUnsereAbgeschlossenenTestAntraegeAsync(superAdmin, altId, neuId);

        Assert.Equal(2, unsere.Count);
        Assert.Contains(altId, unsere);
        Assert.Contains(neuId, unsere);
    }

    [Fact]
    public async Task GetAusfuehrungen_Abgeschlossen_Nutzer_sieht_nur_Antrag_innerhalb_Cutoff() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (altId, neuId) = await SeedZweiAbgeschlosseneMitOrganisationseinheitZustaendigkeit();

        var email = $"antrag-cutoff-nutzer-{Guid.NewGuid():N}@test.local";
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
            await SeedNutzerMitAerzenAntraegeBerechtigung(db, hasher, email, BackofficeNutzerArt.Nutzer);
        }

        var nutzer = await GetUserToken(email, PlainPassword);
        var unsere = await QueryUnsereAbgeschlossenenTestAntraegeAsync(nutzer, altId, neuId);

        Assert.Single(unsere);
        Assert.Equal(neuId, unsere[0]);
    }

    [Fact]
    public async Task GetAusfuehrungen_Abgeschlossen_Admin_sieht_nur_Antrag_innerhalb_Cutoff() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (altId, neuId) = await SeedZweiAbgeschlosseneMitOrganisationseinheitZustaendigkeit();

        var email = $"antrag-cutoff-admin-{Guid.NewGuid():N}@test.local";
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
            await SeedNutzerMitAerzenAntraegeBerechtigung(db, hasher, email, BackofficeNutzerArt.Admin);
        }

        var admin = await GetUserToken(email, PlainPassword);
        var unsere = await QueryUnsereAbgeschlossenenTestAntraegeAsync(admin, altId, neuId);

        Assert.Single(unsere);
        Assert.Equal(neuId, unsere[0]);
    }

    [Fact]
    public async Task GetAusfuehrungen_Abgeschlossen_Dienstleister_sieht_nur_Antrag_innerhalb_Cutoff() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (altId, neuId, dienstleisterId) = await SeedZweiAbgeschlosseneMitDienstleisterZustaendigkeit();

        var email = $"antrag-cutoff-dl-{Guid.NewGuid():N}@test.local";
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
            await SeedDienstleisterNutzer(db, hasher, email, dienstleisterId);
        }

        var dlUser = await GetUserToken(email, PlainPassword);
        var unsere = await QueryUnsereAbgeschlossenenTestAntraegeAsync(dlUser, altId, neuId);

        Assert.Single(unsere);
        Assert.Equal(neuId, unsere[0]);
    }

    private async Task<List<Guid>> QueryUnsereAbgeschlossenenTestAntraegeAsync(ClaimsPrincipal user, Guid altId,
        Guid neuId) {
        var result = await ExecuteGraphqlAsync(user, QueryAusfuehrungenAbgeschlossen, new Dictionary<string, object?> {
            ["status"] = AusfuehrungStatus.Abgeschlossen,
            ["take"] = 100,
        });

        Assert.Null(result.Errors);
        var root = result.Data!["ausfuehrungen"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(root);
        var items = root!["items"] as IEnumerable<object>;
        Assert.NotNull(items);

        var ids = items!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!))
            .ToHashSet();

        return ids.Where(id => id == altId || id == neuId).ToList();
    }

    private async Task<(Guid altId, Guid neuId)> SeedZweiAbgeschlosseneMitOrganisationseinheitZustaendigkeit() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var z = new Zustaendigkeit {
            Art = ZustaendigkeitArt.Organisationseinheit,
            OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
        };
        return await SeedZweiAbgeschlosseneIntern(db, z);
    }

    private async Task<(Guid altId, Guid neuId, Guid dienstleisterId)> SeedZweiAbgeschlosseneMitDienstleisterZustaendigkeit() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var dlId = Guid.NewGuid();
        var dl = new Dienstleister {
            Id = dlId,
            MandantId = KommuneSeeder.LandkreisHaPy.Id,
            Name = "Cutoff-Test-Dienstleister",
            EMailAdressen = [$"cutoff-dl-entity-{dlId:N}@test.local"],
        };
        db.Dienstleister.Add(dl);
        await db.SaveChangesAsync();

        var z = new Zustaendigkeit {
            Art = ZustaendigkeitArt.Dienstleister,
            DienstleisterId = dlId,
        };
        var (altId, neuId) = await SeedZweiAbgeschlosseneIntern(db, z);
        return (altId, neuId, dlId);
    }

    private static async Task<(Guid altId, Guid neuId)> SeedZweiAbgeschlosseneIntern(DomainContext db,
        Zustaendigkeit istZustaendigkeit) {
        var (prozessVersionId, schrittId) = await EnsureTestProzessVersionUndSchritt(db);

        var now = SystemClock.Instance.GetCurrentInstant();
        var altAbgeschlossen = now - Duration.FromDays(AusfuehrungQueries.CutoffDays + 30);
        var neuAbgeschlossen = now - Duration.FromDays(10);

        var altId = Guid.NewGuid();
        var neuId = Guid.NewGuid();
        db.Ausfuehrungen.Add(CreateAusfuehrung(altId, prozessVersionId, SystemUser.UserId, schrittId,
            altAbgeschlossen,
            istZustaendigkeit));
        db.Ausfuehrungen.Add(CreateAusfuehrung(neuId, prozessVersionId, SystemUser.UserId, schrittId,
            neuAbgeschlossen,
            istZustaendigkeit));
        await db.SaveChangesAsync();
        return (altId, neuId);
    }

    private static Ausfuehrung CreateAusfuehrung(Guid id, Guid prozessVersionId, Guid buergerUserId, Guid schrittId,
        Instant abgeschlossenAm, Zustaendigkeit istZustaendigkeit) {
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        return new Ausfuehrung {
            Id = id,
            ProzessVersionId = prozessVersionId,
            UserId = buergerUserId,
            CreatedAt = abgeschlossenAm,
            Status = AusfuehrungStatus.Abgeschlossen,
            AbgeschlossenAm = abgeschlossenAm,
            SchrittId = schrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = istZustaendigkeit,
            Followers = [],
            Bearbeitungen = [],
        };
    }

    private static async Task SeedNutzerMitAerzenAntraegeBerechtigung(DomainContext db, IPasswordHasher<User> hasher,
        string email, BackofficeNutzerArt art) {
        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = email,
            Vorname = "Cutoff",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = art,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        TestUserCrypto.InitializeMitarbeiterCrypto(user, PlainPassword,
            KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
        user.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
            ],
        });
        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
    }

    private static async Task SeedDienstleisterNutzer(DomainContext db, IPasswordHasher<User> hasher, string email,
        Guid dienstleisterId) {
        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = email,
            Vorname = "DL",
            Nachname = "CutoffTest",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Dienstleister,
            DienstleisterId = dienstleisterId,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        TestUserCrypto.InitializeMitarbeiterCrypto(user, PlainPassword,
            KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
        user.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
            ],
        });
        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
    }


    /// <summary>
    /// <see cref="Program"/> disables <see cref="API.Seeders.Prozesse.ProzesseSeeder"/> in the Testing environment,
    /// so integration tests that need a <see cref="ProzessVersion"/> must create a minimal one.
    /// </summary>
    private static async Task<(Guid prozessVersionId, Guid schrittId)> EnsureTestProzessVersionUndSchritt(
        DomainContext db) {
        if (await db.ProzessVersionen.AnyAsync(pv => pv.Id == TestCutoffVersionId)) {
            return (TestCutoffVersionId, TestCutoffEndeSchrittId);
        }

        var instant = Instant.FromUtc(2020, 1, 1, 0, 0, 0);
        var prozess = new Prozess {
            Id = TestCutoffProzessId,
            Name = "AusfuehrungQueriesTest (minimal)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        var ende = new EndeSchritt {
            Id = TestCutoffEndeSchrittId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var version = new ProzessVersion {
            Id = TestCutoffVersionId,
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [ende],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();

        version.StartId = TestCutoffEndeSchrittId;
        await db.SaveChangesAsync();
        return (TestCutoffVersionId, TestCutoffEndeSchrittId);
    }
}
