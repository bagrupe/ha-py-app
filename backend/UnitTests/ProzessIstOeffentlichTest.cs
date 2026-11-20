using API.Features;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

/// <summary>#430: <c>Prozess.istOeffentlich</c> follows the append-only TagHistorie, not the current tags.</summary>
[Collection("Api Tests")]
public class ProzessIstOeffentlichTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string QueryIstOeffentlich = """
        query IstOeffentlich($prozessId: UUID!) {
          my {
            ... on BackofficeUser {
              kommune {
                prozessById(id: $prozessId) { istOeffentlich }
              }
            }
          }
        }
        """;

    [Fact]
    public async Task IstOeffentlich_stays_true_after_the_tag_was_moved_to_another_process() {
        var prozessId = await SeedProzess(withTagHistorie: true);

        Assert.True(await ReadIstOeffentlich(prozessId));
    }

    [Fact]
    public async Task IstOeffentlich_is_false_for_an_untagged_process() {
        var prozessId = await SeedProzess(withTagHistorie: false);

        Assert.False(await ReadIstOeffentlich(prozessId));
    }

    private async Task<bool> ReadIstOeffentlich(Guid prozessId) {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteGraphqlAsync(superAdmin, QueryIstOeffentlich,
            new Dictionary<string, object?> { ["prozessId"] = prozessId });
        Assert.Null(result.Errors);

        var my = (IReadOnlyDictionary<string, object?>)result.Data!["my"]!;
        var kommune = (IReadOnlyDictionary<string, object?>)my["kommune"]!;
        var prozess = (IReadOnlyDictionary<string, object?>)kommune["prozessById"]!;
        return (bool)prozess["istOeffentlich"]!;
    }

    private async Task<Guid> SeedProzess(bool withTagHistorie) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozessId = Guid.NewGuid();
        var tag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
        db.Prozesse.Add(new Prozess {
            Id = prozessId,
            Name = "#430 istOeffentlich",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [],
            TagHistorie = withTagHistorie
                ? [new ProzessTagHistorieEintrag {
                    Id = Guid.NewGuid(), ProzessId = prozessId, Tag = tag, ZugewiesenAm = Instant.FromUtc(2026, 6, 30, 12, 0, 0),
                }]
                : [],
        });
        await db.SaveChangesAsync();
        return prozessId;
    }
}
