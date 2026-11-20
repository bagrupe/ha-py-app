using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Prozess;
using API.Infrastructure;
using API.Options;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;
using NodaTime.Testing;

namespace IntegrationTests;

/// <summary>
/// Regression coverage for the Kommune-boundary check in <see cref="IdeenQueries.GetIdeeAusfuehrung"/>:
/// an Idee must only be resolvable through its own Kommune's query context, never through another
/// Kommune's, even though the underlying DataLoader looks Ideen up purely by id.
///
/// Also covers Review-Feedback von Loic Ishimwe (MR fix/ideenmelder-marker-und-folgen):
/// <see cref="UserIdeenQueries.GetGefolgteIdeen"/> fehlte der Zeitfenster-Filter, den
/// <see cref="UserIdeenQueries.GetIdeen"/> bereits hatte, sodass eine abgelaufene Idee dort weiterhin
/// auftauchte. Außerdem gab es keine Testabdeckung für die "Ideenmelder"-Tag-Filterung auf
/// ideen/gefolgteIdeen.
/// </summary>
[Collection("Api Tests")]
public class IdeenQueriesTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string QueryIdee = """
        query Idee($kommuneId: UUID!, $ideeId: UUID!) {
          kommune(kommuneId: $kommuneId) {
            id
            ideeAusfuehrung(id: $ideeId) {
              id
            }
          }
        }
        """;

    [Fact]
    public async Task GetIdeeAusfuehrung_ueber_eigene_Kommune_liefert_die_Idee() {
        var (ideeId, eigeneKommuneId, _) = await SeedIdeeMitFremderKommune();

        var result = await QueryIdeeAsync(eigeneKommuneId, ideeId);

        var kommune = result.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var idee = kommune!["ideeAusfuehrung"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(idee);
        Assert.Equal(ideeId, Guid.Parse((string)idee!["id"]));
    }

    [Fact]
    public async Task GetIdeeAusfuehrung_ueber_fremde_Kommune_liefert_null() {
        var (ideeId, _, fremdeKommuneId) = await SeedIdeeMitFremderKommune();

        var result = await QueryIdeeAsync(fremdeKommuneId, ideeId);

        var kommune = result.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        Assert.Null(kommune!["ideeAusfuehrung"]);
    }

    /// <summary>
    /// Regression test for a soft-gelöschte Idee, die weiterhin auf der Karte angezeigt wurde und deren
    /// Detailseite unendlich lud (fehlender .NotDeleted()-Filter in IdeenQueries).
    /// </summary>
    [Fact]
    public async Task Soft_geloeschte_Idee_wird_weder_in_der_Liste_noch_im_Detail_zurueckgegeben() {
        var (ideeId, eigeneKommuneId, _) = await SeedIdeeMitFremderKommune();

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var idee = await db.Ausfuehrungen.AsTracking().SingleAsync(a => a.Id == ideeId);
            idee.GeloeschtAm = SystemClock.Instance.GetCurrentInstant();
            await db.SaveChangesAsync();
        }

        var detailResult = await QueryIdeeAsync(eigeneKommuneId, ideeId);
        var kommune = detailResult.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        Assert.Null(kommune!["ideeAusfuehrung"]);

        var listeResult = await ExecuteGraphqlAsync(null, """
            query IdeenListe($kommuneId: UUID!) {
              kommune(kommuneId: $kommuneId) {
                ideenAusfuehrungen {
                  id
                }
              }
            }
            """, new Dictionary<string, object?> { ["kommuneId"] = eigeneKommuneId });

        Assert.Null(listeResult.Errors);
        var listeKommune = listeResult.Data!["kommune"] as IReadOnlyDictionary<string, object>;
        var ideen = listeKommune!["ideenAusfuehrungen"] as IReadOnlyList<object?>;
        Assert.DoesNotContain(ideen!, i => Guid.Parse((string)((IReadOnlyDictionary<string, object>)i!)["id"]) == ideeId);
    }

    private const string IdeenQuery = """
        query Ideen {
          my {
            ... on Buerger { ideen { id } }
          }
        }
        """;

    private const string GefolgteIdeenQuery = """
        query GefolgteIdeen {
          my {
            ... on Buerger { gefolgteIdeen { id } }
          }
        }
        """;

    [Fact]
    public async Task GetGefolgteIdeen_verbirgt_abgelaufene_Idee_aber_zeigt_aktuelle() {
        var (buerger, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();
        var clock = Factory.Services.GetRequiredService<FakeClock>();
        var now = clock.GetCurrentInstant();

        var abgelaufeneId = await SeedIdee(SystemUser.UserId,
            status: AusfuehrungStatus.Abgeschlossen,
            abgeschlossenAm: now - Duration.FromHours(100),
            folgtBuergerId: buerger.Id);
        var aktuelleId = await SeedIdee(SystemUser.UserId,
            status: AusfuehrungStatus.Abgeschlossen,
            abgeschlossenAm: now - Duration.FromHours(1),
            folgtBuergerId: buerger.Id);

        var result = await ExecuteGraphqlAsync(buergerPrincipal, GefolgteIdeenQuery);

        Assert.Null(result.Errors);
        var ids = ExtractIdeenIds(result, "gefolgteIdeen");
        Assert.DoesNotContain(abgelaufeneId, ids);
        Assert.Contains(aktuelleId, ids);
    }

    [Fact]
    public async Task GetGefolgteIdeen_liefert_nur_Ausfuehrungen_mit_Ideenmelder_Tag() {
        var (buerger, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();

        var ideenmelderId = await SeedIdee(SystemUser.UserId, tag: "Ideenmelder", folgtBuergerId: buerger.Id);
        var maengelId = await SeedIdee(SystemUser.UserId, tag: "MaengelMelder", folgtBuergerId: buerger.Id);

        var result = await ExecuteGraphqlAsync(buergerPrincipal, GefolgteIdeenQuery);

        Assert.Null(result.Errors);
        var ids = ExtractIdeenIds(result, "gefolgteIdeen");
        Assert.Contains(ideenmelderId, ids);
        Assert.DoesNotContain(maengelId, ids);
    }

    [Fact]
    public async Task GetIdeen_liefert_nur_Ausfuehrungen_mit_Ideenmelder_Tag() {
        var (buerger, buergerPrincipal) = await CreateBuergerWithPrincipalAsync();

        var ideenmelderId = await SeedIdee(buerger.Id, tag: "Ideenmelder");
        var maengelId = await SeedIdee(buerger.Id, tag: "MaengelMelder");

        var result = await ExecuteGraphqlAsync(buergerPrincipal, IdeenQuery);

        Assert.Null(result.Errors);
        var ids = ExtractIdeenIds(result, "ideen");
        Assert.Contains(ideenmelderId, ids);
        Assert.DoesNotContain(maengelId, ids);
    }

    private static List<Guid> ExtractIdeenIds(HotChocolate.Execution.IQueryResult result, string field) {
        var my = result.Data!["my"] as IReadOnlyDictionary<string, object>;
        var items = my![field] as IReadOnlyList<object?>;
        return items!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(d => Guid.Parse((string)d["id"]!))
            .ToList();
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

    /// <summary>
    /// Seedet eine Idee (Ausfuehrung) mit konfigurierbarem Tag/Status/AbgeschlossenAm, optional gefolgt
    /// von <paramref name="folgtBuergerId"/> - für die Tag-Scoping- und Zeitfenster-Regressionstests zu
    /// ideen/gefolgteIdeen oben.
    /// </summary>
    private async Task<Guid> SeedIdee(
        Guid ownerUserId,
        string tag = "Ideenmelder",
        AusfuehrungStatus status = AusfuehrungStatus.BearbeitungDurchKommune,
        Instant? abgeschlossenAm = null,
        Guid? folgtBuergerId = null) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozessId = Guid.NewGuid();
        var prozessTag = new ProzessTag { Id = Guid.NewGuid(), Tag = tag };
        var prozess = new Prozess {
            Id = prozessId,
            Name = "IdeenQueriesTest Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [prozessTag],
            TagHistorie = [
                new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(),
                    ProzessId = prozessId,
                    TagId = prozessTag.Id,
                    ZugewiesenAm = SystemClock.Instance.GetCurrentInstant(),
                }
            ],
        };
        var endeSchrittId = Guid.NewGuid();
        var ende = new EndeSchritt {
            Id = endeSchrittId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var instant = SystemClock.Instance.GetCurrentInstant();
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [ende],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();
        version.StartId = endeSchrittId;

        var sharedKey = RandomNumberGenerator.GetBytes(32);
        var ideeId = Guid.NewGuid();
        var ausfuehrung = new Ausfuehrung {
            Id = ideeId,
            ProzessVersionId = version.Id,
            UserId = ownerUserId,
            CreatedAt = instant,
            Status = status,
            AbgeschlossenAm = abgeschlossenAm,
            SchrittId = endeSchrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Followers = [],
            Bearbeitungen = [],
        };
        db.Ausfuehrungen.Add(ausfuehrung);
        await db.SaveChangesAsync();

        if (folgtBuergerId is { } buergerId) {
            var trackedBuerger = await db.Buerger
                .AsTracking()
                .Include(b => b.GefolgteAusfuehrungen)
                .FirstAsync(b => b.Id == buergerId);
            trackedBuerger.GefolgteAusfuehrungen.Add(ausfuehrung);
            await db.SaveChangesAsync();
        }

        return ideeId;
    }

    private async Task<HotChocolate.Execution.IQueryResult> QueryIdeeAsync(Guid kommuneId, Guid ideeId) {
        var result = await ExecuteGraphqlAsync(null, QueryIdee, new Dictionary<string, object?> {
            ["kommuneId"] = kommuneId,
            ["ideeId"] = ideeId,
        });

        Assert.Null(result.Errors);
        return result;
    }

    /// <summary>
    /// Seeds an Idee belonging to <see cref="KommuneSeeder.LandkreisHaPy"/> plus a second, unrelated
    /// Kommune with no relationship to that Idee, so tests can assert the boundary between them.
    /// </summary>
    private async Task<(Guid ideeId, Guid eigeneKommuneId, Guid fremdeKommuneId)> SeedIdeeMitFremderKommune() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var fremdeKommune = new API.Features.Kommune.Kommune {
            Id = Guid.NewGuid(),
            Name = $"Fremde Kommune {Guid.NewGuid():N}",
        };
        db.Kommunen.Add(fremdeKommune);

        var prozessId = Guid.NewGuid();
        var prozessTag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Ideenmelder" };
        var prozess = new API.Features.Prozess.Prozess {
            Id = prozessId,
            Name = "IdeenQueriesTest Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [prozessTag],
            TagHistorie = [
                new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(),
                    ProzessId = prozessId,
                    TagId = prozessTag.Id,
                    ZugewiesenAm = SystemClock.Instance.GetCurrentInstant(),
                }
            ],
        };
        var endeSchrittId = Guid.NewGuid();
        var ende = new EndeSchritt {
            Id = endeSchrittId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var instant = SystemClock.Instance.GetCurrentInstant();
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [ende],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        // ProzessVersion.StartId and EndeSchritt.ProzessVersionId reference each other, so both
        // can't be inserted in the same batch (circular FK) - set StartId only after the initial
        // insert, mirroring AusfuehrungQueriesTest.EnsureTestProzessVersionUndSchritt.
        await db.SaveChangesAsync();
        version.StartId = endeSchrittId;

        var sharedKey = RandomNumberGenerator.GetBytes(32);
        var ideeId = Guid.NewGuid();
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = ideeId,
            ProzessVersionId = version.Id,
            UserId = SystemUser.UserId,
            CreatedAt = instant,
            Status = AusfuehrungStatus.BearbeitungDurchKommune,
            SchrittId = endeSchrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Followers = [],
            Bearbeitungen = [],
        });

        await db.SaveChangesAsync();

        return (ideeId, KommuneSeeder.LandkreisHaPy.Id, fremdeKommune.Id);
    }
}
