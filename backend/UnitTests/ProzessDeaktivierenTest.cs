using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class ProzessDeaktivierenTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string ProzessDeaktivierenMutation = """
        mutation Deaktivieren($input: ProzessDeaktivierenInput!) {
          prozessDeaktivieren(input: $input) {
            prozess { id deaktiviertAm }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    private const string ProzessAktivierenMutation = """
        mutation Aktivieren($input: ProzessAktivierenInput!) {
          prozessAktivieren(input: $input) {
            prozess { id deaktiviertAm }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    private const string AusfuehrungCreateMutation = """
        mutation AusfuehrungErstellen($input: AusfuehrungCreateInput!) {
          ausfuehrungCreate(input: $input) {
            ausfuehrungResult { ausfuehrung { id } }
          }
        }
        """;

    private const string MeineAusfuehrungenQuery = """
        query Meine {
          my {
            ... on Buerger {
              ausfuehrungen {
                id
                prozessVersion { ersteSchritte { id } }
              }
            }
          }
        }
        """;

    [Fact]
    public async Task ProzessDeaktivieren_Ohne_Prozessverwaltung_Berechtigung_schlaegt_fehl() {
        var (prozessId, _, _) = await SeedProzessMitVersionen(1);
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["prozessDeaktivieren"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task ProzessDeaktivieren_Setzt_DeaktiviertAm_Und_Ist_Idempotent() {
        var (prozessId, _, _) = await SeedProzessMitVersionen(1);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var erstesErgebnis = await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });
        Assert.Null(erstesErgebnis.Errors);
        var erstePayload = erstesErgebnis.Data!["prozessDeaktivieren"] as IReadOnlyDictionary<string, object>;
        Assert.Null(erstePayload!["errors"]);
        var erstesProzess = erstePayload!["prozess"] as IReadOnlyDictionary<string, object>;
        var ersteZeit = erstesProzess!["deaktiviertAm"];
        Assert.NotNull(ersteZeit);

        var zweitesErgebnis = await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });
        Assert.Null(zweitesErgebnis.Errors);
        var zweitePayload = zweitesErgebnis.Data!["prozessDeaktivieren"] as IReadOnlyDictionary<string, object>;
        var zweitesProzess = zweitePayload!["prozess"] as IReadOnlyDictionary<string, object>;
        Assert.Equal(ersteZeit, zweitesProzess!["deaktiviertAm"]);
    }

    [Fact]
    public async Task ProzessAktivieren_Setzt_DeaktiviertAm_Zurueck() {
        var (prozessId, _, _) = await SeedProzessMitVersionen(1);
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        var result = await ExecuteGraphqlAsync(mitarbeiter, ProzessAktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        Assert.Null(result.Errors);
        var payload = result.Data!["prozessAktivieren"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);
        var prozess = payload!["prozess"] as IReadOnlyDictionary<string, object>;
        Assert.Null(prozess!["deaktiviertAm"]);
    }

    [Fact]
    public async Task StartNewAusfuehrung_Fuer_deaktivierten_Prozess_schlaegt_fehl() {
        var (prozessId, versionIds, _) = await SeedProzessMitVersionen(1);
        var buerger = await CreateBuergerAsync();

        await using (var deaktivierenScope = Factory.Services.CreateAsyncScope()) {
            var deaktivierenDb = deaktivierenScope.ServiceProvider.GetRequiredService<DomainContext>();
            var prozess = await deaktivierenDb.Prozesse.AsTracking().FirstAsync(p => p.Id == prozessId);
            prozess.DeaktiviertAm = SystemClock.Instance.GetCurrentInstant();
            await deaktivierenDb.SaveChangesAsync();
        }

        await using var scope = Factory.Services.CreateAsyncScope();
        var walkerFactory = scope.ServiceProvider.GetRequiredService<WalkerFactory>();
        var sharedKey = RandomNumberGenerator.GetBytes(32);

        await Assert.ThrowsAsync<ProzessDeaktiviertException>(() => walkerFactory.StartNewAusfuehrung(
            versionIds[0],
            new Ausfuehrung {
                ProzessVersionId = versionIds[0],
                UserId = buerger.Id,
                CreatedAt = SystemClock.Instance.GetCurrentInstant(),
                Status = AusfuehrungStatus.BearbeitungDurchBuerger,
                SharedKeyEncryptedForBuerger =
                    Convert.ToBase64String(
                        BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
                SharedKeyEncryptedForKommune =
                    Convert.ToBase64String(
                        KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            }));
    }

    [Fact]
    public async Task Bestehende_Ausfuehrung_bleibt_nach_Deaktivierung_fuer_Buerger_abrufbar() {
        var (prozessId, versionIds, _) = await SeedProzessMitVersionen(1);
        var (_, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        var ausfuehrungErgebnis = await ExecuteGraphqlAsync(buergerPrincipal, AusfuehrungCreateMutation,
            new Dictionary<string, object?> {
                ["input"] = new Dictionary<string, object?> {
                    ["prozessVersionId"] = versionIds[0],
                    ["sharedKeyEncryptedForBuerger"] = "foo",
                    ["sharedKeyEncryptedForKommune"] = "bar",
                    ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
                },
            });
        Assert.Null(ausfuehrungErgebnis.Errors);

        await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        var meineErgebnis = await ExecuteGraphqlAsync(buergerPrincipal, MeineAusfuehrungenQuery);
        Assert.Null(meineErgebnis.Errors);
        var my = meineErgebnis.Data!["my"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = ((IEnumerable<object>)my!["ausfuehrungen"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Single();
        Assert.NotNull(ausfuehrung["prozessVersion"]);
    }

    [Fact]
    public async Task Deaktivierter_Prozess_ist_fuer_Buerger_nicht_mehr_sichtbar_fuer_Backoffice_aber_schon() {
        var (prozessId, _, _) = await SeedProzessMitVersionen(1);
        var (_, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        const string query = """
            query Prozesse($kommuneId: UUID!) {
              kommune(kommuneId: $kommuneId) {
                prozesse { id }
              }
            }
            """;
        var variables = new Dictionary<string, object?> { ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id };

        var buergerResult = await ExecuteGraphqlAsync(buergerPrincipal, query, variables);
        Assert.Null(buergerResult.Errors);
        var buergerKommune = buergerResult.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var buergerProzesse = ((IEnumerable<object>)buergerKommune!["prozesse"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Select(p => (string)p["id"]!);
        Assert.DoesNotContain(prozessId.ToString(), buergerProzesse);

        var mitarbeiterResult = await ExecuteGraphqlAsync(mitarbeiter, query, variables);
        Assert.Null(mitarbeiterResult.Errors);
        var mitarbeiterKommune = mitarbeiterResult.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var mitarbeiterProzesse = ((IEnumerable<object>)mitarbeiterKommune!["prozesse"]!)
            .Cast<IReadOnlyDictionary<string, object>>().Select(p => (string)p["id"]!);
        Assert.Contains(prozessId.ToString(), mitarbeiterProzesse);
    }

    [Fact]
    public async Task Deaktivierter_Prozess_hat_fuer_Buerger_keine_currentVersion_mehr_aber_fuer_Backoffice_schon() {
        var (prozessId, _, _) = await SeedProzessMitVersionen(1);
        var (_, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var mitarbeiter =
            await CreateBackofficeUserWithPrincipalAsync([GlobaleFunktionsberechtigung.Prozessverwaltung]);

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            db.Set<ProzessTag>().Add(new ProzessTag {
                Id = Guid.NewGuid(),
                Tag = $"tag-{Guid.NewGuid():N}",
                Prozesse = [await db.Prozesse.AsTracking().FirstAsync(p => p.Id == prozessId)],
            });
            await db.SaveChangesAsync();
        }
        string tag;
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            tag = await db.Set<ProzessTag>().Where(t => t.Prozesse.Any(p => p.Id == prozessId))
                .Select(t => t.Tag).FirstAsync();
        }

        await ExecuteGraphqlAsync(mitarbeiter, ProzessDeaktivierenMutation,
            new Dictionary<string, object?> { ["input"] = new Dictionary<string, object?> { ["id"] = prozessId } });

        const string query = """
            query ByTag($kommuneId: UUID!, $tag: String!) {
              kommune(kommuneId: $kommuneId) {
                prozessByTag(tag: $tag) {
                  id
                  currentVersion { id }
                }
              }
            }
            """;
        var variables = new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["tag"] = tag,
        };

        var buergerResult = await ExecuteGraphqlAsync(buergerPrincipal, query, variables);
        Assert.Null(buergerResult.Errors);
        var buergerKommune = buergerResult.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var buergerProzess = buergerKommune!["prozessByTag"] as IReadOnlyDictionary<string, object>;
        Assert.Null(buergerProzess!["currentVersion"]);

        var mitarbeiterResult = await ExecuteGraphqlAsync(mitarbeiter, query, variables);
        Assert.Null(mitarbeiterResult.Errors);
        var mitarbeiterKommune = mitarbeiterResult.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var mitarbeiterProzess = mitarbeiterKommune!["prozessByTag"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(mitarbeiterProzess!["currentVersion"]);
    }

    /// <summary>Legt einen Prozess mit der angegebenen Anzahl veröffentlichter Versionen an, je mit eigenem EndeSchritt als Start.</summary>
    private async Task<(Guid ProzessId, List<Guid> VersionIds, List<Guid> SchrittIds)> SeedProzessMitVersionen(
        int anzahlVersionen) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = $"ProzessDeaktivierenTest {Guid.NewGuid():N}",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var versionIds = new List<Guid>();
        var schrittIds = new List<Guid>();
        var basisZeitpunkt = Instant.FromUtc(2026, 1, 1, 0, 0, 0);

        for (var i = 0; i < anzahlVersionen; i++) {
            var endeSchritt = new EndeSchritt {
                Id = Guid.NewGuid(),
                SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            };
            var version = new ProzessVersion {
                Id = Guid.NewGuid(),
                Prozess = prozess,
                CreatedAt = basisZeitpunkt.Plus(Duration.FromMinutes(i)),
                PublishedAt = basisZeitpunkt.Plus(Duration.FromMinutes(i)),
                Beschreibungstext = "test",
                Schritte = [endeSchritt],
            };
            db.ProzessVersionen.Add(version);
            await db.SaveChangesAsync();

            version.StartId = endeSchritt.Id;
            await db.SaveChangesAsync();

            versionIds.Add(version.Id);
            schrittIds.Add(endeSchritt.Id);
        }

        return (prozess.Id, versionIds, schrittIds);
    }

    private async Task<Buerger> CreateBuergerAsync() {
        var (buerger, _) = await CreateBuergerWithPrincipalAsync();
        return buerger;
    }

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
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"prozess-deaktivieren-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Prozess",
            Nachname = "DeaktivierenTest",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Admin,
            Funktionsberechtigungen = globaleFunktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };

        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey,
            hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt");
        return new ClaimsPrincipal(identity);
    }
}
