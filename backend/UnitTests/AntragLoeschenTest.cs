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

namespace IntegrationTests;

/// <summary>
/// Deckt das Review-Feedback von Loic Ishimwe (MR 324-loeschen-und-archivierung-von-antraegen) ab:
/// GeloeschtAm/Loeschgrund dürfen nur für berechtigte Backoffice-Nutzer sichtbar sein (nicht für
/// Bürger:innen), und AntragSoftLoeschen/AntragWiederherstellen müssen dieselbe Zuständigkeits-
/// prüfung wie die Live-Antragsliste durchsetzen (nicht nur die globale Funktionsberechtigung).
/// </summary>
[Collection("Api Tests")]
public class AntragLoeschenTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid TestProzessId = new("a04e1e5c-0000-4000-8000-000000000001");
    private static readonly Guid TestVersionId = new("a04e1e5c-0000-4000-8000-000000000002");
    private static readonly Guid TestEndeSchrittId = new("a04e1e5c-0000-4000-8000-000000000003");

    /// <summary>Andere Organisationseinheit als Aerzen, um "hat BackofficeAntraege, aber nicht für
    /// diesen Antrag zuständig" von "hat gar keine BackofficeAntraege-Berechtigung" zu unterscheiden.</summary>
    private static readonly Guid AndereOrganisationseinheitId = new("a04e1e5c-0000-4000-8000-000000000099");

    private const string SoftLoeschenMutation = """
        mutation Loeschen($input: AntragSoftLoeschenInput!) {
          antragSoftLoeschen(input: $input) {
            ausfuehrung { id geloeschtAm }
            errors { ... on Error { message } }
          }
        }
        """;

    private const string WiederherstellenMutation = """
        mutation Wiederherstellen($input: AntragWiederherstellenInput!) {
          antragWiederherstellen(input: $input) {
            ausfuehrung { id geloeschtAm }
            errors { ... on Error { message } }
          }
        }
        """;

    private const string MeineAusfuehrungenQuery = """
        query Meine {
          my {
            ... on Buerger { ausfuehrungen { id } }
          }
        }
        """;

    private const string AusfuehrungGeloeschtAmQuery = """
        query Einzel($id: UUID!) {
          ausfuehrung(id: $id) { id geloeschtAm loeschgrund }
        }
        """;

    [Fact]
    public async Task AntragSoftLoeschen_Zustaendiger_Nutzer_kann_loeschen_und_Antrag_verschwindet_fuer_Buerger() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var ausfuehrungId = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());

        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AntragLoeschung],
            backofficeAntraegeOrganisationseinheitId: KommuneSeeder.AerzenOrganisationseinheitId);

        var result = await ExecuteGraphqlAsync(mitarbeiter, SoftLoeschenMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId, ["grund"] = "Testgrund" },
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["antragSoftLoeschen"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = payload!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(ausfuehrung!["geloeschtAm"]);

        var meine = await ExecuteGraphqlAsync(buergerPrincipal, MeineAusfuehrungenQuery);
        Assert.Null(meine.Errors);
        var my = meine.Data!["my"] as IReadOnlyDictionary<string, object>;
        var items = (my!["ausfuehrungen"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!));
        Assert.DoesNotContain(ausfuehrungId, items);

        var einzel = await ExecuteGraphqlAsync(buergerPrincipal, AusfuehrungGeloeschtAmQuery,
            new Dictionary<string, object?> { ["id"] = ausfuehrungId });
        Assert.NotNull(einzel.Errors);
    }

    [Fact]
    public async Task AntragSoftLoeschen_Ohne_AntragLoeschung_Berechtigung_schlaegt_fehl() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, _) = await CreateBuergerWithPrincipalAsync();
        var ausfuehrungId = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());

        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([], backofficeAntraegeOrganisationseinheitId:
            KommuneSeeder.AerzenOrganisationseinheitId);

        var result = await ExecuteGraphqlAsync(mitarbeiter, SoftLoeschenMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId, ["grund"] = "Testgrund" },
        });

        // AntragSoftLoeschen nutzt [Error(typeof(NotAllowedException))] (Mutation-Convention) -
        // Fehler landen im typisierten Payload-Feld "errors", nicht in result.Errors (top-level).
        Assert.Null(result.Errors);
        var payload = result.Data!["antragSoftLoeschen"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task AntragSoftLoeschen_Ohne_Zustaendigkeit_fuer_diesen_Antrag_schlaegt_fehl() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureAndereOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, _) = await CreateBuergerWithPrincipalAsync();
        var ausfuehrungId = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());

        // Hat die globale Berechtigung UND BackofficeAntraege - aber nur für eine ANDERE
        // Organisationseinheit als die, für die dieser Antrag zuständig ist. Genau der vom
        // Review beschriebene Fall (Zuständigkeit fehlt trotz Berechtigung).
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AntragLoeschung],
            backofficeAntraegeOrganisationseinheitId: AndereOrganisationseinheitId);

        var result = await ExecuteGraphqlAsync(mitarbeiter, SoftLoeschenMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId, ["grund"] = "Testgrund" },
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["antragSoftLoeschen"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task AntragWiederherstellen_macht_Soft_Loeschung_rueckgaengig() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var ausfuehrungId = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());

        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AntragLoeschung],
            backofficeAntraegeOrganisationseinheitId: KommuneSeeder.AerzenOrganisationseinheitId);

        await ExecuteGraphqlAsync(mitarbeiter, SoftLoeschenMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId, ["grund"] = "Testgrund" },
        });

        var result = await ExecuteGraphqlAsync(mitarbeiter, WiederherstellenMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId },
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["antragWiederherstellen"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = payload!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
        Assert.Null(ausfuehrung!["geloeschtAm"]);

        var meine = await ExecuteGraphqlAsync(buergerPrincipal, MeineAusfuehrungenQuery);
        Assert.Null(meine.Errors);
        var my = meine.Data!["my"] as IReadOnlyDictionary<string, object>;
        var items = (my!["ausfuehrungen"] as IEnumerable<object>)!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!));
        Assert.Contains(ausfuehrungId, items);
    }

    [Fact]
    public async Task GeloeschtAm_ist_fuer_Buerger_nicht_abfragbar_fuer_berechtigten_Mitarbeiter_schon() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var ausfuehrungId = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());

        var buergerResult = await ExecuteGraphqlAsync(buergerPrincipal, AusfuehrungGeloeschtAmQuery,
            new Dictionary<string, object?> { ["id"] = ausfuehrungId });
        Assert.NotNull(buergerResult.Errors);

        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AntragLoeschung],
            backofficeAntraegeOrganisationseinheitId: KommuneSeeder.AerzenOrganisationseinheitId);
        var mitarbeiterResult = await ExecuteGraphqlAsync(mitarbeiter, AusfuehrungGeloeschtAmQuery,
            new Dictionary<string, object?> { ["id"] = ausfuehrungId });
        Assert.Null(mitarbeiterResult.Errors);
    }

    private static Zustaendigkeit MitAerzenZustaendigkeit() => new() {
        Art = ZustaendigkeitArt.Organisationseinheit,
        OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
    };

    private async Task<(Buerger Entity, ClaimsPrincipal Principal)> CreateBuergerWithPrincipalAsync() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(buerger.GetToken(jwtOptions).Claims, "jwt");
        return (buerger, new ClaimsPrincipal(identity));
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen,
        Guid? backofficeAntraegeOrganisationseinheitId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"loeschen-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Loeschen",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Funktionsberechtigungen = globaleFunktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        if (backofficeAntraegeOrganisationseinheitId is { } untereinheitId) {
            user.UntereinheitPermissions.Add(new UntereinheitPermissions {
                UntereinheitId = untereinheitId,
                Funktionsberechtigungen = [
                    FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                    FunktionsberechtigungInOrganisationseinheit.Backoffice,
                ],
            });
        }

        // CurrentUserAccessor.User() lehnt Mitarbeiter ohne OrganisationPrivateKey als
        // unauthentifiziert ab - Crypto-Bootstrap wie beim echten Login nötig, obwohl dieser Test
        // das JWT direkt baut statt die Login-Mutation zu durchlaufen.
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey,
            hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt");
        return new ClaimsPrincipal(identity);
    }

    private async Task EnsureAndereOrganisationseinheitExists() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.Untereinheit.AnyAsync(u => u.Id == AndereOrganisationseinheitId)) {
            return;
        }

        db.Untereinheit.Add(new Untereinheit {
            Id = AndereOrganisationseinheitId,
            Name = "Andere Organisationseinheit (Test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252099",
        });
        await db.SaveChangesAsync();
    }

    private async Task<Guid> SeedAusfuehrung(Guid prozessVersionId, Guid schrittId, Guid buergerUserId,
        Zustaendigkeit istZustaendigkeit) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var id = Guid.NewGuid();
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = id,
            ProzessVersionId = prozessVersionId,
            UserId = buergerUserId,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
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
        });
        await db.SaveChangesAsync();
        return id;
    }

    /// <summary>
    /// <see cref="Program"/> disables <see cref="API.Seeders.Prozesse.ProzesseSeeder"/> in the Testing
    /// environment, so integration tests that need a <see cref="ProzessVersion"/> must create a minimal one.
    /// </summary>
    private async Task<(Guid prozessId, Guid versionId, Guid schrittId)> EnsureTestProzessVersionUndSchritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        if (await db.ProzessVersionen.AnyAsync(pv => pv.Id == TestVersionId)) {
            return (TestProzessId, TestVersionId, TestEndeSchrittId);
        }

        var instant = Instant.FromUtc(2020, 1, 1, 0, 0, 0);
        var prozess = new Prozess {
            Id = TestProzessId,
            Name = "AntragLoeschenTest (minimal)",
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
        return (TestProzessId, TestVersionId, TestEndeSchrittId);
    }
}
