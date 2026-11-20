using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
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
using Npgsql;

namespace IntegrationTests;

/// <summary>
/// Integration tests for department-scoped Antrag visibility in <see cref="API.Features.Prozess.Queries.AusfuehrungQueries.GetAusfuehrungen"/>.
/// </summary>
[Collection("Api Tests")]
public class AusfuehrungSichtbarkeitTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid TestProzessId = new("b1c0ffee-0000-4000-8000-000000000001");
    private static readonly Guid TestVersionId = new("b1c0ffee-0000-4000-8000-000000000002");
    private static readonly Guid TestEndeSchrittId = new("b1c0ffee-0000-4000-8000-000000000003");
    private static readonly Guid GruppeAId = new("b1c0ffee-0000-4000-8000-000000000010");
    private static readonly Guid GruppeBId = new("b1c0ffee-0000-4000-8000-000000000011");
    private static readonly Guid OtherOrganisationseinheitId = new("b1c0ffee-0000-4000-8000-000000000020");

    private const string PlainPassword = "123456";

    private const string ListeQuery = """
        query Liste($take: Int!) {
          ausfuehrungen(take: $take) {
            items { id }
          }
        }
        """;

    // sharedKeyEncryptedForKommune is non-null and access-checked per item, like the bereich-a list fragment:
    // one rejected item nulls the whole list while totalCount stays intact.
    private const string BackofficeListQuery = """
        query BackofficeList($take: Int!) {
          ausfuehrungen(take: $take) {
            totalCount
            items { id sharedKeyEncryptedForKommune }
          }
        }
        """;

    private const string DetailQuery = """
        query Detail($id: UUID!) {
          ausfuehrung(id: $id) { id }
        }
        """;

    [Fact]
    public async Task GetAusfuehrungen_Abteilungsmatch_ist_sichtbar() {
        await PrepareTestData();
        var antragId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeAId));
        var nutzer = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);

        var ids = await QuerySichtbareAntragIds(nutzer);

        Assert.Contains(antragId, ids);
    }

    [Fact]
    public async Task GetAusfuehrungen_OE_Match_ohne_Abteilungsmatch_ist_nicht_sichtbar() {
        await PrepareTestData();
        var antragId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId));
        var nutzer = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);

        var ids = await QuerySichtbareAntragIds(nutzer);

        Assert.DoesNotContain(antragId, ids);
    }

    [Fact]
    public async Task GetAusfuehrungen_OE_Fallback_ohne_Abteilung_am_Antrag_ist_sichtbar() {
        await PrepareTestData();
        var antragId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: null));
        var nutzer = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);

        var ids = await QuerySichtbareAntragIds(nutzer);

        Assert.Contains(antragId, ids);
    }

    [Fact]
    public async Task GetAusfuehrung_OE_Match_ohne_Abteilungsmatch_wirft_NotAllowed() {
        await PrepareTestData();
        var antragId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId));
        var nutzer = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);

        var result = await ExecuteGraphqlAsync(nutzer, DetailQuery,
            new Dictionary<string, object?> { ["id"] = antragId });

        Assert.NotNull(result.Errors);
        Assert.Equal("NOT_ALLOWED", Assert.Single(result.Errors).Code);
    }

    [Fact]
    public async Task GetAusfuehrungen_Persoenliche_Zuweisung_bleibt_sichtbar() {
        await PrepareTestData();
        var nutzer = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);
        var nutzerId = GetUserIdFromPrincipal(nutzer);
        var antragId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeBId, zugewiesenePersonId: nutzerId));

        var ids = await QuerySichtbareAntragIds(nutzer);

        Assert.Contains(antragId, ids);
    }

    [Fact]
    public async Task GetAusfuehrungen_Abteilung_match_in_other_OE_keeps_list_readable() {
        await PrepareTestData();
        await EnsureOtherOrganisationseinheitExists();
        var antragId = await SeedAusfuehrung(MitZustaendigkeit(gruppeId: GruppeAId,
            organisationseinheitId: OtherOrganisationseinheitId));
        var user = await CreateNutzerMitGruppeUndOeAsync(GruppeAId);

        var result = await ExecuteGraphqlAsync(user, BackofficeListQuery,
            new Dictionary<string, object?> { ["take"] = 100 });

        Assert.Null(result.Errors);
        var root = (IReadOnlyDictionary<string, object>)result.Data!["ausfuehrungen"]!;
        var ids = ((IEnumerable<object>)root["items"])
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]))
            .ToHashSet();
        Assert.Contains(antragId, ids);
    }

    private async Task PrepareTestData() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureTestGruppenExist();
        await EnsureTestProzessVersionUndSchritt();
    }

    private async Task<HashSet<Guid>> QuerySichtbareAntragIds(ClaimsPrincipal nutzer) {
        var result = await ExecuteGraphqlAsync(nutzer, ListeQuery, new Dictionary<string, object?> { ["take"] = 100 });
        Assert.Null(result.Errors);
        var root = result.Data!["ausfuehrungen"] as IReadOnlyDictionary<string, object>;
        var items = (root!["items"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!));
        return items.ToHashSet();
    }

    private async Task<ClaimsPrincipal> CreateNutzerMitGruppeUndOeAsync(Guid gruppeId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        var requestedGruppen = await db.MitarbeiterGruppen
            .AsTracking()
            .Where(g => g.Id == gruppeId)
            .ToListAsync();
        Assert.Single(requestedGruppen);
        var email = $"sichtbarkeit-{Guid.NewGuid():N}@test.local";

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = email,
            Vorname = "Sichtbarkeit",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Gruppen = requestedGruppen,
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

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        return new ClaimsPrincipal(new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt"));
    }

    private Guid GetUserIdFromPrincipal(ClaimsPrincipal principal) {
        var idClaim = principal.Claims.First(c => c.Type == ClaimTypes.NameIdentifier);
        return Guid.Parse(idClaim.Value);
    }

    private static Zustaendigkeit MitZustaendigkeit(Guid? gruppeId, Guid? zugewiesenePersonId = null,
        Guid? organisationseinheitId = null) => new() {
            Art = ZustaendigkeitArt.Organisationseinheit,
            OrganisationseinheitId = organisationseinheitId ?? KommuneSeeder.AerzenOrganisationseinheitId,
            MitarbeiterGruppeId = gruppeId,
            ZugewiesenePersonId = zugewiesenePersonId,
        };

    private async Task<Guid> SeedAusfuehrung(Zustaendigkeit istZustaendigkeit) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var id = Guid.NewGuid();
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = id,
            ProzessVersionId = TestVersionId,
            UserId = SystemUser.UserId,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            SchrittId = TestEndeSchrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = istZustaendigkeit,
            Followers = [],
            Bearbeitungen = [],
        });
        await db.SaveChangesAsync();
        return id;
    }

    private async Task EnsureTestGruppenExist() {
        await EnsureGruppeExists(GruppeAId, "Sichtbarkeit Test Gruppe A");
        await EnsureGruppeExists(GruppeBId, "Sichtbarkeit Test Gruppe B");
    }

    private async Task EnsureGruppeExists(Guid gruppeId, string name) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.MitarbeiterGruppen.AnyAsync(g => g.Id == gruppeId)) {
            return;
        }

        var ordinal = await db.MitarbeiterGruppen.CountAsync(g => g.KommuneId == KommuneSeeder.LandkreisHaPy.Id);
        db.MitarbeiterGruppen.Add(new MitarbeiterGruppe {
            Id = gruppeId,
            Name = name,
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Ordinal = ordinal,
        });
        try {
            await db.SaveChangesAsync();
        } catch (DbUpdateException ex) when (ex.InnerException is PostgresException { SqlState: PostgresErrorCodes.UniqueViolation }) {
            // Parallel test run may have created the group first.
        }
    }

    private async Task EnsureOtherOrganisationseinheitExists() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.Untereinheit.AnyAsync(u => u.Id == OtherOrganisationseinheitId)) {
            return;
        }

        db.Untereinheit.Add(new Untereinheit {
            Id = OtherOrganisationseinheitId,
            Name = "Other OE (visibility test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252097",
        });
        await db.SaveChangesAsync();
    }

    private async Task EnsureTestProzessVersionUndSchritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.ProzessVersionen.AnyAsync(pv => pv.Id == TestVersionId)) {
            return;
        }

        var instant = Instant.FromUtc(2020, 1, 1, 0, 0, 0);
        var prozess = new Prozess {
            Id = TestProzessId,
            Name = "AusfuehrungSichtbarkeitTests (minimal)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        var ende = new EndeSchritt {
            Id = TestEndeSchrittId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var version = new ProzessVersion {
            Id = TestVersionId,
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [ende],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();
        version.StartId = TestEndeSchrittId;
        await db.SaveChangesAsync();
    }
}
