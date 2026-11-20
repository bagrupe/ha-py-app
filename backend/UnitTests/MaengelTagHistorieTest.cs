using API.Features;
using API.Features.Auth;
using API.Features.Expressions;
using API.Features.MaengelMelder.Queries;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class MaengelTagHistorieTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MutationAssignProzessTag = """
        mutation AssignProzessTag($input: AssignProzessTagInput!) {
          assignProzessTag(input: $input) {
            prozess { id }
            errors { __typename }
          }
        }
        """;

    private const string QueryMaengelAusfuehrungen = """
        query {
          my {
            ... on BackofficeUser {
              kommune {
                maengelAusfuehrungen { id }
              }
            }
          }
        }
        """;

    [Fact]
    public async Task Ausfuehrung_bleibt_sichtbar_nachdem_das_Tag_auf_einen_anderen_Prozess_umgehaengt_wurde() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        // Muss exakt "Mängelmelder" heißen: GetMaengelByKommuneId filtert fest auf diesen Tag-Namen.
        var tag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
        var (alterTraeger, ausfuehrungId) = await CreateProzessMitAusfuehrung(db, "Alter Mängelmelder-Prozess");
        var (neuerTraeger, _) = await CreateProzessMitAusfuehrung(db, "Neuer Mängelmelder-Prozess");

        db.ProzessTags.Add(tag);
        await db.SaveChangesAsync();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var ersteZuweisung = await ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
            {"prozessId", alterTraeger}, {"tagId", tag.Id},
        });
        Assert.Null(ersteZuweisung.Errors);

        var zweiteZuweisung = await ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
            {"prozessId", neuerTraeger}, {"tagId", tag.Id},
        });
        Assert.Null(zweiteZuweisung.Errors);

        await using var checkScope = Factory.Services.CreateAsyncScope();
        var checkDb = checkScope.ServiceProvider.GetRequiredService<DomainContext>();
        var hatNochTag = await checkDb.Prozesse
            .Where(p => p.Id == alterTraeger)
            .Include(p => p.Tags)
            .Select(p => p.Tags.Any(t => t.Id == tag.Id))
            .FirstAsync();
        Assert.False(hatNochTag);

        var result = await ExecuteQuery(superAdmin, QueryMaengelAusfuehrungen, null);
        Assert.Null(result.Errors);
        var my = (IReadOnlyDictionary<string, object>)result.Data!["my"]!;
        var kommune = (IReadOnlyDictionary<string, object>)my["kommune"]!;
        var maengel = ((IEnumerable<object>)kommune["maengelAusfuehrungen"]!)
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(m => Guid.Parse(m["id"].ToString()!));

        Assert.Contains(ausfuehrungId, maengel);
    }

    private async Task<(Guid ProzessId, Guid AusfuehrungId)> CreateProzessMitAusfuehrung(DomainContext db, string prozessName) {
        var (buergerEntity, _) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, Factory.Services);

        var prozess = new Prozess { Name = prozessName, KommuneId = KommuneSeeder.LandkreisHaPy.Id };
        var prozessVersion = new ProzessVersion {
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"Antrag",
        };

        var endeSchritt = new EndeSchritt {
            ProzessVersion = prozessVersion,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        prozessVersion.Schritte.Add(endeSchritt);

        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = endeSchritt;
        await db.SaveChangesAsync();

        var ausfuehrung = new Ausfuehrung {
            Id = Guid.NewGuid(),
            ProzessVersion = prozessVersion,
            ProzessVersionId = prozessVersion.Id,
            UserId = buergerEntity.Id,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            SharedKeyEncryptedForBuerger = "foo",
            SharedKeyEncryptedForKommune = "bar",
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            SchrittId = endeSchritt.Id,
            Schritt = endeSchritt,
            Followers = [],
        };
        db.Ausfuehrungen.Add(ausfuehrung);
        await db.SaveChangesAsync();

        return (prozess.Id, ausfuehrung.Id);
    }
}
