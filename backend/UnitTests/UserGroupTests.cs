using API.Seeders;

namespace IntegrationTests;

/// <summary>
/// GraphQL entry points for Mitarbeitergruppen (Abteilungen):
/// <list type="bullet">
/// <item><description>Kommune list (Nutzende): <c>my { ... on BackofficeUser { kommune { mitarbeiterGruppen { ... } } } }</c></description></item>
/// <item><description>Per user: <c>mitarbeiter { gruppen { ... } }</c> on the same <c>MitarbeiterGruppe</c> type.</description></item>
/// </list>
/// </summary>
[Collection("Api Tests")]
public class UserGroupTests(BackendApiFactory factory) : GraphQLTests(factory) {

    /// <summary>
    /// Loads all groups for the logged-in user's kommune (with optional <c>organisationseinheiten</c> selection).
    /// </summary>
    private const string QueryMitarbeiterGruppen = """
        query MitarbeiterGruppenMitOrganisationseinheiten {
          my {
            ... on BackofficeUser {
              kommune {
                mitarbeiterGruppen {
                  id
                  name
                  eMailAdressen
                  organisationseinheiten {
                    id
                    name
                  }
                }
              }
            }
          }
        }
        """;

    /// <summary>
    /// Same data as <c>web/bereich-a/.../abteilungen.graphql</c> — assigns OE links for one group.
    /// </summary>
    private const string MutationUpdateAbteilung = """
        mutation UpdateAbteilung($input: UpdateAbteilungInput!) {
          updateAbteilung(input: $input) {
            mitarbeiterGruppe {
              id
              eMailAdressen
              organisationseinheiten {
                id
              }
            }
            errors {
              __typename
            }
          }
        }
        """;

    private const string MutationUpdateAbteilungMitFehlermeldung = """
        mutation UpdateAbteilung($input: UpdateAbteilungInput!) {
          updateAbteilung(input: $input) {
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
    public async Task UpdateAbteilungFailsWithReadableMessageWhenNameIsEmpty() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var error = await UpdateAbteilungExpectingError(superAdmin, name: "", eMailAdressen: null);

        Assert.Equal("GroupNameInvalid", error["__typename"]);
        Assert.Equal("Der Abteilungsname darf nicht leer sein.", error["message"]);
    }

    [Fact]
    public async Task UpdateAbteilungFailsWithReadableMessageWhenEmailIsInvalid() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var error = await UpdateAbteilungExpectingError(superAdmin, name: "Sachbearbeiter",
            eMailAdressen: ["keine-email"]);

        Assert.Equal("InvalidEmailError", error["__typename"]);
        Assert.Equal("Die E-Mail Adresse ist ungültig.", error["message"]);
    }

    [Fact]
    public async Task UpdateAbteilungFailsWithReadableMessageWhenOneOfMultipleEmailsIsInvalid() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var error = await UpdateAbteilungExpectingError(superAdmin, name: "Sachbearbeiter",
            eMailAdressen: ["gueltig@example.com", "keine-email"]);

        Assert.Equal("InvalidEmailError", error["__typename"]);
        Assert.Equal("Die E-Mail Adresse ist ungültig.", error["message"]);
    }

    private async Task<IReadOnlyDictionary<string, object>> UpdateAbteilungExpectingError(
        System.Security.Claims.ClaimsPrincipal user, string name, string[]? eMailAdressen) {
        var groupId = MitarbeiterSeeder.GetMitarbeiterGruppeId(KommuneSeeder.LandkreisHaPy,
            MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);

        var result = await ExecuteQuery(user, MutationUpdateAbteilungMitFehlermeldung,
            new Dictionary<string, object?> {
                {"id", groupId},
                {"name", name},
                {"eMailAdressen", eMailAdressen ?? []},
                {"organisationseinheitIds", Array.Empty<Guid>()},
            });

        Assert.Null(result.Errors);
        var payload = (IReadOnlyDictionary<string, object>)result.Data!["updateAbteilung"]!;
        var errors = payload["errors"] as IEnumerable<object>;
        Assert.NotNull(errors);
        return errors!.Cast<IReadOnlyDictionary<string, object>>().Single();
    }

    [Fact]
    public async Task UpdateAbteilungStoresAllProvidedEmailsAndNormalizesThem() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var groupId = MitarbeiterSeeder.GetMitarbeiterGruppeId(KommuneSeeder.LandkreisHaPy,
            MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);

        var updateResult = await ExecuteQuery(superAdmin, MutationUpdateAbteilung, new Dictionary<string, object?> {
            {"id", groupId},
            {"name", "Sachbearbeiter"},
            // Duplicate (different case) and surrounding whitespace must be normalized away.
            {"eMailAdressen", new[] {" erste@example.com ", "zweite@example.com", "ERSTE@example.com"}},
            {"organisationseinheitIds", Array.Empty<Guid>()},
        });

        Assert.False(updateResult.Errors?.Any() ?? false);
        var updatePayload = updateResult.Data!["updateAbteilung"] as IReadOnlyDictionary<string, object>;
        var errors = updatePayload!["errors"] as IEnumerable<object>;
        Assert.False(errors?.Any() ?? false);
        var mg = updatePayload["mitarbeiterGruppe"] as IReadOnlyDictionary<string, object>;
        var storedEmails = (mg!["eMailAdressen"] as IEnumerable<object>)!.Cast<string>().ToList();

        Assert.Equal(["erste@example.com", "zweite@example.com"], storedEmails);
    }

    [Fact]
    public async Task UpdateAndQueryUserGroups() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var groupId = MitarbeiterSeeder.GetMitarbeiterGruppeId(KommuneSeeder.LandkreisHaPy,
            MitarbeiterSeeder.MitarbeiterGruppeKey.Sachbearbeiter);
        var oeId = KommuneSeeder.AerzenOrganisationseinheitId;

        await AddUntereinheitToUserGroup(superAdmin, groupId, oeId);
        await RemoveUntereinheitToUserGroup(superAdmin, groupId, oeId);
    }

    private async Task AddUntereinheitToUserGroup(System.Security.Claims.ClaimsPrincipal superAdmin, Guid groupId, Guid oeId) {
        var updateResult = await ExecuteQuery(superAdmin, MutationUpdateAbteilung, new Dictionary<string, object?> {
            {"id", groupId},
            {"name", "Sachbearbeiter"},
            {"eMailAdressen", Array.Empty<string>()},
            {"organisationseinheitIds", new[] {oeId}},
        });

        Assert.False(updateResult.Errors?.Any() ?? false);
        var updatePayload = updateResult.Data!["updateAbteilung"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(updatePayload);
        var errors = updatePayload!["errors"] as IEnumerable<object>;
        Assert.False(errors?.Any() ?? false);
        var mg = updatePayload["mitarbeiterGruppe"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(mg);
        var oes = mg!["organisationseinheiten"] as IEnumerable<object>;
        Assert.NotNull(oes);
        Assert.Contains(oeId.ToString(), ExtractUntereinheitIds(oes!));

        var queryResult = await ExecuteQuery(superAdmin, QueryMitarbeiterGruppen, null);
        Assert.False(queryResult.Errors?.Any() ?? false);

        var my = queryResult.Data!["my"] as IReadOnlyDictionary<string, object>;
        var kommune = my!["kommune"] as IReadOnlyDictionary<string, object>;
        var gruppen = kommune!["mitarbeiterGruppen"] as IEnumerable<object>;
        Assert.NotNull(gruppen);

        var returnedGroups = gruppen!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Single(g => (string)g["id"]! == groupId.ToString());
        var loadedOes = returnedGroups["organisationseinheiten"] as IEnumerable<object>;
        Assert.NotNull(loadedOes);
        Assert.Contains(oeId.ToString(), ExtractUntereinheitIds(loadedOes!));
    }

    private async Task RemoveUntereinheitToUserGroup(System.Security.Claims.ClaimsPrincipal superAdmin, Guid groupId, Guid oeId) {
        var updateResult = await ExecuteQuery(superAdmin, MutationUpdateAbteilung, new Dictionary<string, object?> {
            {"id", groupId},
            {"name", "Sachbearbeiter"},
            {"eMailAdressen", Array.Empty<string>()},
            {"organisationseinheitIds", new Guid[] {}},
        });

        Assert.False(updateResult.Errors?.Any() ?? false);
        var updatePayload = updateResult.Data!["updateAbteilung"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(updatePayload);
        var errors = updatePayload!["errors"] as IEnumerable<object>;
        Assert.False(errors?.Any() ?? false);
        var mg = updatePayload["mitarbeiterGruppe"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(mg);
        var oes = mg!["organisationseinheiten"] as IEnumerable<object>;
        Assert.NotNull(oes);
        Assert.Empty(oes);

        var queryResult = await ExecuteQuery(superAdmin, QueryMitarbeiterGruppen, null);
        Assert.False(queryResult.Errors?.Any() ?? false);

        var my = queryResult.Data!["my"] as IReadOnlyDictionary<string, object>;
        var kommune = my!["kommune"] as IReadOnlyDictionary<string, object>;
        var gruppen = kommune!["mitarbeiterGruppen"] as IEnumerable<object>;
        Assert.NotNull(gruppen);

        var returnedGroups = gruppen!
            .Cast<IReadOnlyDictionary<string, object>>()
            .Single(g => (string)g["id"]! == groupId.ToString());
        var loadedOes = returnedGroups["organisationseinheiten"] as IEnumerable<object>;
        Assert.NotNull(loadedOes);
        Assert.Empty(loadedOes);
    }


    private static IEnumerable<string> ExtractUntereinheitIds(IEnumerable<object> organisationseinheiten) {
        foreach (var item in organisationseinheiten) {
            var dict = item as IReadOnlyDictionary<string, object>;
            if (dict is null) {
                continue;
            }

            yield return dict["id"]!.ToString()!;
        }
    }

}
