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

[Collection("Api Tests")]
public class MitteilungenQueriesTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MitteilungenQuery = """
        query Mitteilungen {
          my {
            ... on Buerger { mitteilungen { id } }
          }
        }
        """;

    [Fact]
    public async Task Abgelaufener_abgeschlossener_Mangel_wird_ausgelassen_aktueller_bleibt() {
        var (buerger, principal) = await CreateBuergerWithPrincipalAsync();
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();

        var abgelaufen = await Seed(buerger.Id, "Mängelmelder", AusfuehrungStatus.Abgeschlossen,
            now - Duration.FromHours(100));
        var aktuell = await Seed(buerger.Id, "Mängelmelder", AusfuehrungStatus.Abgeschlossen,
            now - Duration.FromHours(1));
        var offen = await Seed(buerger.Id, "Mängelmelder", AusfuehrungStatus.BearbeitungDurchKommune, null);

        var ids = await QueryIds(principal);

        Assert.DoesNotContain(abgelaufen, ids);
        Assert.Contains(aktuell, ids);
        Assert.Contains(offen, ids);
    }

    [Fact]
    public async Task Abgelaufene_abgeschlossene_Idee_wird_ausgelassen_aktuelle_bleibt() {
        var (buerger, principal) = await CreateBuergerWithPrincipalAsync();
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();

        var abgelaufen = await Seed(buerger.Id, "Ideenmelder", AusfuehrungStatus.Abgeschlossen,
            now - Duration.FromHours(100));
        var aktuell = await Seed(buerger.Id, "Ideenmelder", AusfuehrungStatus.Abgeschlossen,
            now - Duration.FromHours(1));

        var ids = await QueryIds(principal);

        Assert.DoesNotContain(abgelaufen, ids);
        Assert.Contains(aktuell, ids);
    }

    [Fact]
    public async Task Alter_abgeschlossener_Antrag_ohne_Mangel_Tag_bleibt_sichtbar() {
        var (buerger, principal) = await CreateBuergerWithPrincipalAsync();
        var now = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();

        var antrag = await Seed(buerger.Id, "Antrag", AusfuehrungStatus.Abgeschlossen,
            now - Duration.FromHours(1000));

        var ids = await QueryIds(principal);

        Assert.Contains(antrag, ids);
    }

    [Fact]
    public async Task Soft_geloeschter_Mangel_wird_ausgelassen() {
        var (buerger, principal) = await CreateBuergerWithPrincipalAsync();

        var id = await Seed(buerger.Id, "Mängelmelder", AusfuehrungStatus.BearbeitungDurchKommune, null);
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var mangel = await db.Ausfuehrungen.AsTracking().SingleAsync(a => a.Id == id);
            mangel.GeloeschtAm = SystemClock.Instance.GetCurrentInstant();
            await db.SaveChangesAsync();
        }

        var ids = await QueryIds(principal);

        Assert.DoesNotContain(id, ids);
    }

    private async Task<List<Guid>> QueryIds(ClaimsPrincipal principal) {
        var result = await ExecuteGraphqlAsync(principal, MitteilungenQuery);
        Assert.Null(result.Errors);
        var my = result.Data!["my"] as IReadOnlyDictionary<string, object>;
        var items = my!["mitteilungen"] as IReadOnlyList<object?>;
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

    private async Task<Guid> Seed(Guid ownerUserId, string tag, AusfuehrungStatus status, Instant? abgeschlossenAm) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var instant = SystemClock.Instance.GetCurrentInstant();

        var prozessId = Guid.NewGuid();
        var prozessTag = new ProzessTag { Id = Guid.NewGuid(), Tag = tag };
        var prozess = new Prozess {
            Id = prozessId,
            Name = "MitteilungenQueriesTest Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [prozessTag],
            TagHistorie = [
                new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(),
                    ProzessId = prozessId,
                    TagId = prozessTag.Id,
                    ZugewiesenAm = instant,
                }
            ],
        };
        var endeSchrittId = Guid.NewGuid();
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [
                new EndeSchritt {
                    Id = endeSchrittId,
                    Titel = "Ende",
                    NodePosition = new NodePosition { X = 0, Y = 0 },
                    SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
                }
            ],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();
        version.StartId = endeSchrittId;

        var sharedKey = RandomNumberGenerator.GetBytes(32);
        var id = Guid.NewGuid();
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = id,
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
        });
        await db.SaveChangesAsync();
        return id;
    }
}
