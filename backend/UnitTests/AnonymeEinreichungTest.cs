using API.Features;
using API.Features.Auth;
using API.Features.Prozess;
using API.Seeders;
using HotChocolate;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class AnonymeEinreichungTest(BackendApiFactory factory) : GraphQLTests(factory) {
    // The shared accessor otherwise keeps the user of whichever test ran before.
    private void ActAnonymously() =>
        Factory.Services.GetRequiredService<IHttpContextAccessor>().HttpContext = new DefaultHttpContext();

    private const string CreateAnonymMutation =
        """
        mutation CreateAnonym($input: AusfuehrungCreateAnonymInput!) {
          ausfuehrungCreateAnonym(input: $input) {
            anonymeAusfuehrungResult {
              correlationId
            }
          }
        }
        """;

    private const string StatusQuery =
        """
        query Status($correlationId: UUID!) {
          ausfuehrungStatusAnonym(correlationId: $correlationId) {
            status
            historie {
              statusAenderung
            }
          }
        }
        """;

    private const string ErsteSchritteQuery =
        """
        query ErsteSchritte($kommuneId: UUID!, $prozessId: UUID!) {
          kommune(kommuneId: $kommuneId) {
            prozessById(id: $prozessId) {
              currentVersion {
                ersteSchritte {
                  id
                }
              }
            }
          }
        }
        """;

    [Fact]
    public async Task TaggedProzess_CanBeSubmittedAndTrackedWithoutLogin() {
        var (prozessId, prozessVersionId, startSchritt, verbindung) = await CreateProzess(anonymErlaubt: true);
        ActAnonymously();

        var ersteSchritte = await ExecuteGraphqlAsync(null, ErsteSchritteQuery, new Dictionary<string, object?> {
            ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
            ["prozessId"] = prozessId,
        });
        Assert.Null(ersteSchritte.Errors);
        Assert.Contains(startSchritt.Id.ToString(), ersteSchritte.ToJson());

        var create = await ExecuteQuery(null, CreateAnonymMutation,
            CreateInput(prozessVersionId, startSchritt.Id, verbindung.Id));
        Assert.Null(create.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)create.Data!["ausfuehrungCreateAnonym"]!;
        var result = (IReadOnlyDictionary<string, object?>)payload["anonymeAusfuehrungResult"]!;
        var correlationId = Guid.Parse(result["correlationId"]!.ToString()!);

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var ausfuehrung = await db.Ausfuehrungen.SingleAsync(a => a.CorrelationId == correlationId);
            Assert.Equal(SystemUser.UserId, ausfuehrung.UserId);
            Assert.Equal("", ausfuehrung.SharedKeyEncryptedForBuerger);
        }

        var status = await ExecuteGraphqlAsync(null, StatusQuery,
            new Dictionary<string, object?> { ["correlationId"] = correlationId });
        Assert.Null(status.Errors);
        var json = status.ToJson();
        Assert.Contains("ABGESCHLOSSEN", json);
        Assert.Contains("Meldung eingegangen", json);
    }

    [Fact]
    public async Task UntaggedProzess_RejectsAnonymousSubmission() {
        var (_, prozessVersionId, startSchritt, verbindung) = await CreateProzess(anonymErlaubt: false);
        ActAnonymously();

        var create = await ExecuteQuery(null, CreateAnonymMutation,
            CreateInput(prozessVersionId, startSchritt.Id, verbindung.Id));

        Assert.NotNull(create.Errors);
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.Ausfuehrungen.AnyAsync(a => a.ProzessVersionId == prozessVersionId));
    }

    [Fact]
    public async Task SubmissionWithoutBuergerSteps_IsRejected() {
        var (_, prozessVersionId, _, _) = await CreateProzess(anonymErlaubt: true);
        ActAnonymously();

        var create = await ExecuteQuery(null, CreateAnonymMutation, new Dictionary<string, object?> {
            ["prozessVersionId"] = prozessVersionId,
            ["sharedKeyEncryptedForKommune"] = "key",
            ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
        });

        Assert.NotNull(create.Errors);
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        Assert.False(await db.Ausfuehrungen.AnyAsync(a => a.ProzessVersionId == prozessVersionId));
    }

    [Fact]
    public async Task UnknownCorrelationId_ReturnsNull() {
        ActAnonymously();
        var status = await ExecuteGraphqlAsync(null, StatusQuery,
            new Dictionary<string, object?> { ["correlationId"] = Guid.NewGuid() });

        Assert.Null(status.Errors);
        Assert.Null(status.Data!["ausfuehrungStatusAnonym"]);
    }

    private static Dictionary<string, object?> CreateInput(Guid prozessVersionId, Guid schrittId, Guid verbindungId) =>
        new() {
            ["prozessVersionId"] = prozessVersionId,
            ["sharedKeyEncryptedForKommune"] = "key",
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                new() {
                    ["schrittId"] = schrittId,
                    ["nextVerbindungId"] = verbindungId,
                    ["slotValues"] = new List<Dictionary<string, object?>>(),
                },
            },
        };

    private async Task<(Guid ProzessId, Guid ProzessVersionId, FormularSchritt StartSchritt, Verbindung Verbindung)>
        CreateProzess(bool anonymErlaubt) {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (prozessVersionId, startSchritt, verbindung) = await testSeeder.CreateProzess(db, "Meldung eingegangen");
        var prozess = await db.Prozesse.AsTracking().Include(p => p.Tags)
            .SingleAsync(p => p.Versionen.Any(v => v.Id == prozessVersionId));

        if (anonymErlaubt) {
            var tag = await db.ProzessTags.AsTracking()
                .FirstOrDefaultAsync(t => t.Tag == AnonymeEinreichung.ProzessTagName);
            if (tag is null) {
                tag = new ProzessTag { Id = Guid.NewGuid(), Tag = AnonymeEinreichung.ProzessTagName };
                db.ProzessTags.Add(tag);
            }
            prozess.Tags.Add(tag);
            await db.SaveChangesAsync();
        }

        return (prozess.Id, prozessVersionId, startSchritt, verbindung);
    }
}
