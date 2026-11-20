using System.Security.Claims;
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

namespace IntegrationTests;

[Collection("Api Tests")]
public class ProzessTagMutationTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MutationAssignProzessTag = """
        mutation AssignProzessTag($input: AssignProzessTagInput!) {
          assignProzessTag(input: $input) {
            prozess {
              id
              tags { id }
            }
            errors {
              __typename
              ... on Error {
                message
              }
            }
          }
        }
        """;

    private const string QueryProzessTags = """
        query {
          my {
            ... on BackofficeUser {
              kommune {
                prozessTags {
                  id
                  prozesse { id name }
                }
              }
            }
          }
        }
        """;

    [Fact]
    public async Task GetProzessTags_requires_prozessverwaltung_berechtigung() {
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, QueryProzessTags, null);

        Assert.NotNull(result.Errors);
    }

    [Fact]
    public async Task GetProzessTags_does_not_expose_prozesse_of_other_kommunen() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var andereKommune = db.Kommunen.Add(new API.Features.Kommune.Kommune {
            Name = $"Andere Kommune {Guid.NewGuid()}",
        });
        await db.SaveChangesAsync();

        var tag = new ProzessTag { Tag = $"Cross-Kommune-Tag-{Guid.NewGuid()}" };
        var eigenerProzess = new Prozess {
            Name = "Eigener Prozess",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Tags = [tag],
        };
        var fremderProzess = new Prozess {
            Name = "Fremder Prozess",
            KommuneId = andereKommune.Entity.Id,
            Tags = [tag],
        };
        db.Prozesse.AddRange(eigenerProzess, fremderProzess);
        await db.SaveChangesAsync();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteQuery(superAdmin, QueryProzessTags, null);

        Assert.Null(result.Errors);
        var my = (IReadOnlyDictionary<string, object>)result.Data!["my"]!;
        var kommune = (IReadOnlyDictionary<string, object>)my["kommune"]!;
        var prozessTags = (IEnumerable<object>)kommune["prozessTags"]!;
        var unserTag = prozessTags
            .Cast<IReadOnlyDictionary<string, object>>()
            .Single(t => (string)t["id"] == tag.Id.ToString());
        var prozessNamen = ((IEnumerable<object>)unserTag["prozesse"]!)
            .Cast<IReadOnlyDictionary<string, object>>()
            .Select(p => (string)p["name"]);

        Assert.Contains("Eigener Prozess", prozessNamen);
        Assert.DoesNotContain("Fremder Prozess", prozessNamen);
    }

    [Fact]
    public async Task AssignProzessTag_moves_tag_from_previous_prozess_to_new_one() {
        var (prozessA, prozessB, tag) = await CreateTwoProzesseWithSharedTagOnFirst();
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
            {"prozessId", prozessB}, {"tagId", tag},
        });

        Assert.Null(result.Errors);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var tagsByProzess = await db.Prozesse
            .Where(p => p.Id == prozessA || p.Id == prozessB)
            .Include(p => p.Tags)
            .ToDictionaryAsync(p => p.Id, p => p.Tags.Select(t => t.Id).ToList());

        Assert.DoesNotContain(tag, tagsByProzess[prozessA]);
        Assert.Contains(tag, tagsByProzess[prozessB]);
    }

    [Fact]
    public async Task AssignProzessTag_only_one_of_two_truly_concurrent_assignments_to_different_prozesse_wins() {
        await using var setupScope = Factory.Services.CreateAsyncScope();
        var setupDb = setupScope.ServiceProvider.GetRequiredService<DomainContext>();

        var tag = new ProzessTag { Tag = $"Race-Tag-{Guid.NewGuid()}" };
        var prozessA = new Prozess { Name = "Race-Test A", KommuneId = KommuneSeeder.LandkreisHaPy.Id };
        var prozessB = new Prozess { Name = "Race-Test B", KommuneId = KommuneSeeder.LandkreisHaPy.Id };
        setupDb.Prozesse.AddRange(prozessA, prozessB);
        setupDb.ProzessTags.Add(tag);
        await setupDb.SaveChangesAsync();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var results = await Task.WhenAll(
            ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
                {"prozessId", prozessA.Id}, {"tagId", tag.Id},
            }),
            ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
                {"prozessId", prozessB.Id}, {"tagId", tag.Id},
            }));

        foreach (var result in results) Assert.Null(result.Errors);

        await using var verifyScope = Factory.Services.CreateAsyncScope();
        var verifyDb = verifyScope.ServiceProvider.GetRequiredService<DomainContext>();
        var traeger = await verifyDb.Prozesse
            .Where(p => p.Id == prozessA.Id || p.Id == prozessB.Id)
            .Include(p => p.Tags)
            .Where(p => p.Tags.Any(t => t.Id == tag.Id))
            .Select(p => p.Id)
            .ToListAsync();

        Assert.Single(traeger);
    }

    [Fact]
    public async Task AssignProzessTag_returns_error_when_prozess_does_not_exist() {
        var (_, _, tag) = await CreateTwoProzesseWithSharedTagOnFirst();
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
            {"prozessId", Guid.NewGuid()}, {"tagId", tag},
        });

        Assert.Null(result.Errors);
        var error = SingleError(result.Data!["assignProzessTag"]);
        Assert.Equal("ProzessNotFound", error["__typename"]);
    }

    [Fact]
    public async Task AssignProzessTag_returns_error_when_tag_does_not_exist() {
        var (_, prozessB, _) = await CreateTwoProzesseWithSharedTagOnFirst();
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteQuery(superAdmin, MutationAssignProzessTag, new Dictionary<string, object?> {
            {"prozessId", prozessB}, {"tagId", Guid.NewGuid()},
        });

        Assert.Null(result.Errors);
        var error = SingleError(result.Data!["assignProzessTag"]);
        Assert.Equal("ProzessTagNotFound", error["__typename"]);
    }

    private static IReadOnlyDictionary<string, object> SingleError(object? payload) {
        var errors = ((IReadOnlyDictionary<string, object>)payload!)["errors"] as IEnumerable<object>;
        Assert.NotNull(errors);
        return errors!.Cast<IReadOnlyDictionary<string, object>>().Single();
    }

    private async Task<(Guid ProzessA, Guid ProzessB, Guid Tag)> CreateTwoProzesseWithSharedTagOnFirst() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var tag = new ProzessTag { Tag = $"Test-Tag-{Guid.NewGuid()}" };
        var prozessA = new Prozess { Name = "Tag-Test A", KommuneId = KommuneSeeder.LandkreisHaPy.Id, Tags = [tag] };
        var prozessB = new Prozess { Name = "Tag-Test B", KommuneId = KommuneSeeder.LandkreisHaPy.Id };

        db.Prozesse.AddRange(prozessA, prozessB);
        await db.SaveChangesAsync();

        return (prozessA.Id, prozessB.Id, tag.Id);
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"prozess-tag-test-{Guid.NewGuid():N}@test.local",
            Vorname = "ProzessTag",
            Nachname = "Test",
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
