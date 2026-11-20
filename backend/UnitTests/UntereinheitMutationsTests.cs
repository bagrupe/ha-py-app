using API.Features;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

[Collection("Api Tests")]
public class UntereinheitMutationsTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string MutationUntereinheitDelete = """
        mutation UntereinheitDelete($input: UntereinheitDeleteInput!) {
          untereinheitDelete(input: $input) {
            errors {
              __typename
              ... on Error {
                message
              }
            }
          }
        }
        """;

    [Fact]
    public async Task DeleteFailsWithReadableMessageWhenUntereinheitIsAssignedToAUser() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var untereinheitId = await CreateUntereinheitAssignedToSuperAdmin();

        var result = await ExecuteQuery(superAdmin, MutationUntereinheitDelete, new Dictionary<string, object?> {
            {"untereinheitId", untereinheitId},
        });

        Assert.Null(result.Errors);
        var error = SingleError(result.Data!["untereinheitDelete"]);
        Assert.Equal("UntereinheitAssignedToUser", error["__typename"]);
        Assert.Equal("Die Organisationseinheit ist Nutzenden zugeordnet und kann deswegen nicht gelöscht werden.",
            error["message"]);
    }

    [Fact]
    public async Task DeleteFailsWithReadableMessageWhenUntereinheitDoesNotExist() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteQuery(superAdmin, MutationUntereinheitDelete, new Dictionary<string, object?> {
            {"untereinheitId", Guid.NewGuid()},
        });

        Assert.Null(result.Errors);
        var error = SingleError(result.Data!["untereinheitDelete"]);
        Assert.Equal("UntereinheitNotFoundError", error["__typename"]);
        Assert.Equal("Die Organisationseinheit existiert nicht und konnte deshalb nicht gelöscht werden.",
            error["message"]);
    }

    [Fact]
    public async Task DeleteFailsWithReadableMessageWhenUntereinheitIsAGemeinde() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var result = await ExecuteQuery(superAdmin, MutationUntereinheitDelete, new Dictionary<string, object?> {
            {"untereinheitId", KommuneSeeder.AerzenOrganisationseinheitId},
        });

        Assert.Null(result.Errors);
        var error = SingleError(result.Data!["untereinheitDelete"]);
        Assert.Equal("UntereinheitIsGemeindeError", error["__typename"]);
        Assert.Equal("Die Organisationseinheit ist eine Gemeinde und kann nicht bearbeitet oder gelöscht werden.",
            error["message"]);
    }

    private static IReadOnlyDictionary<string, object> SingleError(object? payload) {
        var errors = ((IReadOnlyDictionary<string, object>)payload!)["errors"] as IEnumerable<object>;
        Assert.NotNull(errors);
        return errors!.Cast<IReadOnlyDictionary<string, object>>().Single();
    }

    private async Task<Guid> CreateUntereinheitAssignedToSuperAdmin() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var untereinheit = db.Untereinheit.Add(new Untereinheit {
            Name = "Zugeordnete Organisationseinheit (Test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = false,
        });

        var backofficeUserId = await db.BackofficeUser
            .Where(u => u.EMail == SuperAdminEmail)
            .Select(u => u.Id)
            .FirstAsync();

        db.UntereinheitPermissions.Add(new UntereinheitPermissions {
            Untereinheit = untereinheit.Entity,
            BackofficeUserId = backofficeUserId,
        });

        await db.SaveChangesAsync();
        return untereinheit.Entity.Id;
    }
}
