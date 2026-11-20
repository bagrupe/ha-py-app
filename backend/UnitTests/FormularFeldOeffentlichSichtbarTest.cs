using API.Features;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Seeders;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

/// <summary>#430: the OeffentlichSichtbar flag of a FormularFeld is stored with a Prozess version and readable again.</summary>
[Collection("Api Tests")]
public class FormularFeldOeffentlichSichtbarTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MutationNeueProzessVersion = """
        mutation NeueProzessVersionErstellen($input: ProzessVersionErstellenInput!) {
          prozessVersionErstellen(input: $input) {
            prozess { id }
            errors { __typename }
          }
        }
        """;

    private const string QueryFelder = """
        query Felder($prozessId: UUID!) {
          my {
            ... on BackofficeUser {
              kommune {
                prozessById(id: $prozessId) {
                  latestVersion {
                    alleSchritte {
                      ... on FormularSchritt {
                        felder { slotName oeffentlichSichtbar }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        """;

    [Fact]
    public async Task OeffentlichSichtbar_is_stored_per_field_and_defaults_to_false() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var prozessId = await CreateProzess();

        var result = await ExecuteQuery(superAdmin, MutationNeueProzessVersion, VersionInput(prozessId));
        Assert.Null(result.Errors);

        var felder = await ReadFelder(superAdmin, prozessId);
        Assert.True(felder["titel"]);
        Assert.False(felder["vorname"]);
    }

    private async Task<Guid> CreateProzess() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "#430 flag storage",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();
        return prozess.Id;
    }

    private async Task<Dictionary<string, bool>> ReadFelder(System.Security.Claims.ClaimsPrincipal user, Guid prozessId) {
        var result = await ExecuteGraphqlAsync(user, QueryFelder,
            new Dictionary<string, object?> { ["prozessId"] = prozessId });
        Assert.Null(result.Errors);

        var my = (IReadOnlyDictionary<string, object?>)result.Data!["my"]!;
        var kommune = (IReadOnlyDictionary<string, object?>)my["kommune"]!;
        var prozess = (IReadOnlyDictionary<string, object?>)kommune["prozessById"]!;
        var version = (IReadOnlyDictionary<string, object?>)prozess["latestVersion"]!;
        return ((IEnumerable<object>)version["alleSchritte"]!)
            .Cast<IReadOnlyDictionary<string, object?>>()
            .Where(schritt => schritt.ContainsKey("felder"))
            .SelectMany(schritt => ((IEnumerable<object>)schritt["felder"]!).Cast<IReadOnlyDictionary<string, object?>>())
            .ToDictionary(feld => (string)feld["slotName"]!, feld => (bool)feld["oeffentlichSichtbar"]!);
    }

    private static Dictionary<string, object?> VersionInput(Guid prozessId) {
        var formularId = Guid.NewGuid();
        var endeId = Guid.NewGuid();
        var buerger = new Dictionary<string, object?> { ["art"] = "BUERGER" };
        return new Dictionary<string, object?> {
            ["prozessId"] = prozessId,
            ["veroeffentlichen"] = false,
            ["zustaendigkeitRollen"] = Array.Empty<object>(),
            ["verbindungen"] = new object[] {
                new Dictionary<string, object?> {
                    ["id"] = Guid.NewGuid(), ["vonId"] = formularId, ["nachId"] = endeId, ["istRelevant"] = new BoolExpression("true"),
                },
            },
            ["schritte"] = new object[] {
                new Dictionary<string, object?> {
                    ["formularSchrittInput"] = new Dictionary<string, object?> {
                        ["id"] = formularId,
                        ["sollZustaendigkeit"] = buerger,
                        ["felder"] = new object[] {
                            StringFeld("titel", order: 0, oeffentlichSichtbar: true),
                            StringFeld("vorname", order: 1, oeffentlichSichtbar: null),
                        },
                    },
                },
                new Dictionary<string, object?> {
                    ["endeSchrittInput"] = new Dictionary<string, object?> {
                        ["id"] = endeId,
                        ["sollZustaendigkeit"] = buerger,
                    },
                },
            },
        };
    }

    private static Dictionary<string, object?> StringFeld(string slotName, int order, bool? oeffentlichSichtbar) {
        var feld = new Dictionary<string, object?> {
            ["id"] = Guid.NewGuid(),
            ["slotName"] = slotName,
            ["order"] = order,
            ["encrypted"] = false,
            ["istRelevant"] = new BoolExpression("true"),
            ["pflichtfeld"] = false,
            ["multiline"] = false,
            ["options"] = Array.Empty<object>(),
        };
        if (oeffentlichSichtbar is { } flag) {
            feld["oeffentlichSichtbar"] = flag;
        }
        return new Dictionary<string, object?> { ["stringFormularFeldInput"] = feld };
    }
}
