using System.Security.Claims;
using System.Text.Json;
using API.Features;
using API.Features.Aufbewahrung.Archive;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// Deckt Loics generellen Review-Hinweis ab ("jede neue Query/Mutation sollte mindestens einen
/// Test haben") für <see cref="ArchivQueries"/>, die zuvor ungetestet war - insbesondere die
/// Berechtigungs- und Zuständigkeits-Filterung (dieselbe Logik wie die Live-Antragsliste).
/// </summary>
[Collection("Api Tests")]
public class ArchivQueriesTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid AndereOrganisationseinheitId = new("a2c817e5-a11e-4000-8000-000000000001");

    private const string ListeQuery = """
        query Liste($search: String) {
          archivierteAntraege(search: $search) {
            totalCount
            items { id prozessBezeichnung }
          }
        }
        """;

    private const string DetailQuery = """
        query Detail($id: UUID!) {
          archivierterAntrag(id: $id) { id prozessBezeichnung }
        }
        """;

    [Fact]
    public async Task GetArchivierteAntraege_Ohne_ArchivEinsicht_schlaegt_fehl() {
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([], mitAerzenBackofficeAntraege: true);

        var result = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery);

        Assert.NotNull(result.Errors);
    }

    [Fact]
    public async Task GetArchivierteAntraege_Superadmin_sieht_archivierten_Antrag() {
        var antragId = await SeedArchivierterAntrag(MitAerzenZustaendigkeit());
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteGraphqlAsync(superAdmin, ListeQuery,
            new Dictionary<string, object?> { ["search"] = null });

        Assert.Null(result.Errors);
        var liste = result.Data!["archivierteAntraege"] as IReadOnlyDictionary<string, object>;
        var items = (liste!["items"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!));
        Assert.Contains(antragId, items);
    }

    [Fact]
    public async Task GetArchivierteAntraege_Nutzer_ohne_passende_Zustaendigkeit_sieht_ihn_nicht() {
        var antragId = await SeedArchivierterAntrag(MitAerzenZustaendigkeit());
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.ArchivEinsicht],
            mitAerzenBackofficeAntraege: false,
            backofficeAntraegeOrganisationseinheitId: AndereOrganisationseinheitId);

        var result = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery,
            new Dictionary<string, object?> { ["search"] = null });

        Assert.Null(result.Errors);
        var liste = result.Data!["archivierteAntraege"] as IReadOnlyDictionary<string, object>;
        var items = (liste!["items"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!));
        Assert.DoesNotContain(antragId, items);
    }

    [Fact]
    public async Task GetArchivierteAntraege_Nutzer_mit_passender_Zustaendigkeit_sieht_ihn() {
        var antragId = await SeedArchivierterAntrag(MitAerzenZustaendigkeit());
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.ArchivEinsicht],
            mitAerzenBackofficeAntraege: true);

        var result = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery,
            new Dictionary<string, object?> { ["search"] = null });

        Assert.Null(result.Errors);
        var liste = result.Data!["archivierteAntraege"] as IReadOnlyDictionary<string, object>;
        var items = (liste!["items"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!));
        Assert.Contains(antragId, items);
    }

    [Fact]
    public async Task GetArchivierterAntrag_Superadmin_findet_Detail() {
        var antragId = await SeedArchivierterAntrag(MitAerzenZustaendigkeit());
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteGraphqlAsync(superAdmin, DetailQuery,
            new Dictionary<string, object?> { ["id"] = antragId });

        Assert.Null(result.Errors);
        var detail = result.Data!["archivierterAntrag"] as IReadOnlyDictionary<string, object>;
        Assert.Equal(antragId, Guid.Parse((string)detail!["id"]!));
    }

    [Fact]
    public async Task GetArchivierterAntrag_liefert_gerenderten_Verlauf() {
        var verlaufsEintragId = Guid.NewGuid();
        var now = SystemClock.Instance.GetCurrentInstant();
        var antragId = await SeedArchivierterAntragMitVerlauf(MitAerzenZustaendigkeit(), verlaufsEintragId, now);
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        const string detailMitVerlaufQuery = """
            query DetailMitVerlauf($id: UUID!) {
              archivierterAntrag(id: $id) {
                verlauf { id statusAenderung statusAenderungBeschreibung benutzer }
              }
            }
            """;

        var result = await ExecuteGraphqlAsync(superAdmin, detailMitVerlaufQuery,
            new Dictionary<string, object?> { ["id"] = antragId });

        Assert.Null(result.Errors);
        var detail = result.Data!["archivierterAntrag"] as IReadOnlyDictionary<string, object>;
        var verlauf = (detail!["verlauf"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>().ToList();
        var eintrag = Assert.Single(verlauf);
        Assert.Equal(verlaufsEintragId, Guid.Parse((string)eintrag["id"]!));
        Assert.Equal("Vorgang übernommen", (string)eintrag["statusAenderung"]!);
        Assert.Equal("Vorgang wurde von Regressionstest übernommen", (string)eintrag["statusAenderungBeschreibung"]!);
        Assert.Equal("Regressionstest", (string)eintrag["benutzer"]!);
    }

    [Fact]
    public async Task GetArchivierterAntrag_Nutzer_ohne_passende_Zustaendigkeit_findet_ihn_nicht() {
        var antragId = await SeedArchivierterAntrag(MitAerzenZustaendigkeit());
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.ArchivEinsicht],
            mitAerzenBackofficeAntraege: false,
            backofficeAntraegeOrganisationseinheitId: AndereOrganisationseinheitId);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DetailQuery,
            new Dictionary<string, object?> { ["id"] = antragId });

        Assert.Null(result.Errors);
        Assert.Null(result.Data!["archivierterAntrag"]);
    }

    private static Zustaendigkeit MitAerzenZustaendigkeit() => new() {
        Art = ZustaendigkeitArt.Organisationseinheit,
        OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
    };

    private async Task<Guid> SeedArchivierterAntrag(Zustaendigkeit zustaendigkeit) {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await using var scope = Factory.Services.CreateAsyncScope();
        var archive = scope.ServiceProvider.GetRequiredService<ArchiveContext>();

        var id = Guid.NewGuid();
        var now = SystemClock.Instance.GetCurrentInstant();
        archive.ArchivierteAntraege.Add(new ArchivierterAntrag {
            Id = id,
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            ProzessVersionId = Guid.NewGuid(),
            ProzessBezeichnung = "ArchivQueriesTest",
            Status = AusfuehrungStatus.Abgeschlossen,
            CreatedAt = now,
            AbgeschlossenAm = now,
            ArchiviertAm = now,
            ZustaendigkeitArt = zustaendigkeit.Art,
            ZustaendigkeitOrganisationseinheitId = zustaendigkeit.OrganisationseinheitId,
            SharedKeyEncryptedForKommune = "",
            Inhalt = JsonDocument.Parse("{}"),
        });
        await archive.SaveChangesAsync();
        return id;
    }

    private async Task<Guid> SeedArchivierterAntragMitVerlauf(
        Zustaendigkeit zustaendigkeit, Guid verlaufsEintragId, Instant createdAt) {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await using var scope = Factory.Services.CreateAsyncScope();
        var archive = scope.ServiceProvider.GetRequiredService<ArchiveContext>();

        var id = Guid.NewGuid();
        var dto = new AntragArchivDto(
            id, Guid.NewGuid(), AusfuehrungStatus.Abgeschlossen, createdAt.ToString(), createdAt.ToString(),
            "", "", [], [
                new VerlaufsEintragArchivDto(
                    verlaufsEintragId, createdAt.ToString(), VerlaufsEreignisArt.Uebernahme,
                    Guid.NewGuid(), "Regressionstest", null, null),
            ], [], []);

        archive.ArchivierteAntraege.Add(new ArchivierterAntrag {
            Id = id,
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            ProzessVersionId = Guid.NewGuid(),
            ProzessBezeichnung = "ArchivQueriesTest (Verlauf)",
            Status = AusfuehrungStatus.Abgeschlossen,
            CreatedAt = createdAt,
            AbgeschlossenAm = createdAt,
            ArchiviertAm = createdAt,
            ZustaendigkeitArt = zustaendigkeit.Art,
            ZustaendigkeitOrganisationseinheitId = zustaendigkeit.OrganisationseinheitId,
            SharedKeyEncryptedForKommune = "",
            Inhalt = JsonSerializer.SerializeToDocument(dto),
        });
        await archive.SaveChangesAsync();
        return id;
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen,
        bool mitAerzenBackofficeAntraege,
        Guid? backofficeAntraegeOrganisationseinheitId = null) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var untereinheitId = mitAerzenBackofficeAntraege
            ? KommuneSeeder.AerzenOrganisationseinheitId
            : backofficeAntraegeOrganisationseinheitId;

        if (untereinheitId is { } id && id == AndereOrganisationseinheitId) {
            await EnsureAndereOrganisationseinheitExists(db);
        }

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"archiv-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Archiv",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Funktionsberechtigungen = globaleFunktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        if (untereinheitId is { } einheitId) {
            user.UntereinheitPermissions.Add(new UntereinheitPermissions {
                UntereinheitId = einheitId,
                Funktionsberechtigungen = [
                    FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                    FunktionsberechtigungInOrganisationseinheit.Backoffice,
                ],
            });
        }

        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey,
            hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt");
        return new ClaimsPrincipal(identity);
    }

    private static async Task EnsureAndereOrganisationseinheitExists(DomainContext db) {
        if (await db.Untereinheit.AnyAsync(u => u.Id == AndereOrganisationseinheitId)) {
            return;
        }

        db.Untereinheit.Add(new Untereinheit {
            Id = AndereOrganisationseinheitId,
            Name = "Andere Organisationseinheit (ArchivQueriesTest)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252098",
        });
        await db.SaveChangesAsync();
    }
}
