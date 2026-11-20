using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using API.Features;
using API.Features.Ehrenamtsbank;
using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit;
using API.Seeders;
using HotChocolate;
using HotChocolate.Execution;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Snapshooter.Xunit;

namespace IntegrationTests;

[Collection("Api Tests")]
public class MiscGraphQLTests(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string dienstLeisterEmail = "dienst@leist.er";
    private readonly BackendApiFactory _factory = factory;



    [Fact]
    public async Task AssureSuperAdminIsSet() {
        // This ensures the server is actually bootstrapped
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetService<DomainContext>();

        var superadmin = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        Assert.NotNull(superadmin);

        // once respawn works, we can test this too. Since we add users the count might be
        // above 1
        // var backofficeUserCount = await db.BackofficeUser.CountAsync();
        // Assert.Equal(1, backofficeUserCount);
    }

    [Fact]
    public async Task LoginAsSuperAdmin() {
        var email = SuperAdminEmail;
        var rawPassword = SuperAdminPassword;

        var passwordPayload = crypto.GetServerLoginPassword(rawPassword, email);
        var loginInput = new Dictionary<string, object?> {
            { "email", email },
            { "password", passwordPayload }
        };

        var result = await ExecuteQuery(null, """
            mutation Login($input: LoginInput!) {
                login(input: $input) {
                    result
                    token
                }
            }
        """, loginInput);

        var queryResult = result.ExpectQueryResult();

        Assert.Null(queryResult.Errors);
        var loginResponse = queryResult.Data["login"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(loginResponse);
        Assert.Equal("SUCCESS", loginResponse["result"].ToString());
        Assert.NotNull(loginResponse["token"]);
    }


    [Fact]
    public async Task GetProgrammatischeSchritte_ExecutesAgainstRealApp() {
        // Arrange: Extract the fully configured GraphQL executor from your real app
        var executorResolver = _factory.Services.GetRequiredService<IRequestExecutorResolver>();
        var executor = await executorResolver.GetRequestExecutorAsync();

        var identity = new ClaimsIdentity("TestAuthType");
        var mockUser = new ClaimsPrincipal(identity);

        var request = QueryRequestBuilder.New()
            .SetQuery("{ programmatischeSchritte { name } }")
            .SetUser(mockUser)
            .Create();

        // Act
        var result = await executor.ExecuteAsync(request);
        var queryResult = result.ExpectQueryResult();

        // Assert
        Assert.NotNull(result);
        Assert.Null(queryResult.Errors);
        queryResult.ToJson().MatchSnapshot();
    }


    [Fact]
    public async Task EhrenamtsbankKategorien_ReturnsEffectivelyActiveCategoriesWithFields() {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var root = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Test Root",
            Active = true,
            RequiresClearance = true,
            Sort = 20
        };
        var child = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Test Child",
            Active = true,
            RequiresClearance = false,
            ParentId = root.Id,
            Sort = 10
        };
        var inactiveParent = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Inactive Parent",
            Active = false,
            RequiresClearance = false,
            Sort = 30
        };
        var childOfInactiveParent = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Child Of Inactive Parent",
            Active = true,
            RequiresClearance = true,
            ParentId = inactiveParent.Id,
            Sort = 40
        };

        db.EhrenamtsbankKategorien.AddRange(root, child, inactiveParent, childOfInactiveParent);
        await db.SaveChangesAsync();

        var result = await ExecuteGraphqlAsync(null, """
            query EhrenamtsbankKategorien {
                ehrenamtsbankKategorien {
                    id
                    name
                    active
                    requiresClearance
                    parentId
                    sort
                }
            }
        """);

        Assert.Null(result.Errors);

        var categoriesById = Categories(result)
            .ToDictionary(category => Guid.Parse(category["id"]!.ToString()!));

        Assert.Contains(root.Id, categoriesById.Keys);
        Assert.Contains(child.Id, categoriesById.Keys);
        Assert.DoesNotContain(inactiveParent.Id, categoriesById.Keys);
        Assert.DoesNotContain(childOfInactiveParent.Id, categoriesById.Keys);

        Assert.Equal("Test Root", categoriesById[root.Id]["name"]);
        Assert.Equal(true, categoriesById[root.Id]["active"]);
        Assert.Equal(true, categoriesById[root.Id]["requiresClearance"]);
        Assert.Null(categoriesById[root.Id]["parentId"]);
        Assert.Equal(20, categoriesById[root.Id]["sort"]);

        Assert.Equal("Test Child", categoriesById[child.Id]["name"]);
        Assert.Equal(true, categoriesById[child.Id]["requiresClearance"]);
        Assert.Equal(root.Id, Guid.Parse(categoriesById[child.Id]["parentId"]!.ToString()!));
        Assert.Equal(10, categoriesById[child.Id]["sort"]);
    }

    [Fact]
    public async Task EhrenamtsbankKategorien_FiltersByInheritedClearanceAndParentAndSortsByName() {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var rootWithoutClearanceA = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Filter Test Alpha",
            Active = true,
            RequiresClearance = false,
            Sort = 1
        };
        var rootWithoutClearanceZ = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Filter Test Zulu",
            Active = true,
            RequiresClearance = false,
            Sort = 2
        };
        var rootWithClearance = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Filter Test Clearance Root",
            Active = true,
            RequiresClearance = true
        };
        var childInheritingClearance = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Filter Test Inheriting Child",
            Active = true,
            RequiresClearance = false,
            ParentId = rootWithClearance.Id
        };
        var childWithoutClearance = new EhrenamtsbankKategorie {
            Id = Guid.NewGuid(),
            Name = "Filter Test Clean Child",
            Active = true,
            RequiresClearance = false,
            ParentId = rootWithoutClearanceA.Id
        };

        db.EhrenamtsbankKategorien.AddRange(
            rootWithoutClearanceA,
            rootWithoutClearanceZ,
            rootWithClearance,
            childInheritingClearance,
            childWithoutClearance);
        await db.SaveChangesAsync();

        Task<IQueryResult> QueryRootsAsync(string direction) => ExecuteGraphqlAsync(null, """
            query RootCategories($direction: SortEnumType!) {
                ehrenamtsbankKategorien(
                    where: {
                        parentId: { eq: null }
                        requiresClearance: { eq: false }
                    }
                    order: [{ name: $direction }]
                ) {
                    id
                    name
                }
            }
        """, new Dictionary<string, object?> {
            ["direction"] = direction
        });

        var expectedRootIds = new HashSet<Guid> {
            rootWithoutClearanceA.Id,
            rootWithoutClearanceZ.Id
        };

        var descendingResult = await QueryRootsAsync("DESC");

        Assert.Null(descendingResult.Errors);
        var rootIds = CategoryIds(descendingResult);
        Assert.Contains(rootWithoutClearanceA.Id, rootIds);
        Assert.Contains(rootWithoutClearanceZ.Id, rootIds);
        Assert.DoesNotContain(rootWithClearance.Id, rootIds);
        Assert.DoesNotContain(childInheritingClearance.Id, rootIds);
        Assert.DoesNotContain(childWithoutClearance.Id, rootIds);
        Assert.Equal(
            ["Filter Test Zulu", "Filter Test Alpha"],
            CategoryNames(descendingResult, expectedRootIds));

        var ascendingResult = await QueryRootsAsync("ASC");

        Assert.Null(ascendingResult.Errors);
        Assert.Equal(
            ["Filter Test Alpha", "Filter Test Zulu"],
            CategoryNames(ascendingResult, expectedRootIds));

        Task<IQueryResult> QueryChildrenAsync(Guid parentId, bool requiresClearance) =>
            ExecuteGraphqlAsync(null, """
                query ChildCategories($parentId: UUID!, $requiresClearance: Boolean!) {
                    ehrenamtsbankKategorien(
                        where: {
                            parentId: { eq: $parentId }
                            requiresClearance: { eq: $requiresClearance }
                        }
                    ) {
                        id
                    }
                }
            """, new Dictionary<string, object?> {
                ["parentId"] = parentId,
                ["requiresClearance"] = requiresClearance
            });

        var inheritedResult = await QueryChildrenAsync(rootWithClearance.Id, true);

        Assert.Null(inheritedResult.Errors);
        Assert.Contains(childInheritingClearance.Id, CategoryIds(inheritedResult));

        var notInheritedResult = await QueryChildrenAsync(rootWithClearance.Id, false);

        Assert.Null(notInheritedResult.Errors);
        Assert.DoesNotContain(childInheritingClearance.Id, CategoryIds(notInheritedResult));

        var cleanChildResult = await QueryChildrenAsync(rootWithoutClearanceA.Id, false);

        Assert.Null(cleanChildResult.Errors);
        var cleanChildIds = CategoryIds(cleanChildResult);
        Assert.Contains(childWithoutClearance.Id, cleanChildIds);
        Assert.DoesNotContain(rootWithoutClearanceA.Id, cleanChildIds);
        Assert.DoesNotContain(rootWithoutClearanceZ.Id, cleanChildIds);
        Assert.DoesNotContain(childInheritingClearance.Id, cleanChildIds);
    }

    private static IReadOnlyList<Guid> CategoryIds(IQueryResult result) =>
        Categories(result)
            .Select(category => Guid.Parse(category["id"]!.ToString()!))
            .ToList();

    private static IReadOnlyList<string> CategoryNames(
        IQueryResult result, IReadOnlySet<Guid> ids) =>
        Categories(result)
            .Where(category => ids.Contains(Guid.Parse(category["id"]!.ToString()!)))
            .Select(category => category["name"]!.ToString()!)
            .ToList();

    private static IEnumerable<IReadOnlyDictionary<string, object?>> Categories(IQueryResult result) {
        var data = Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(result.Data);
        var categories = Assert.IsAssignableFrom<IReadOnlyList<object?>>(data["ehrenamtsbankKategorien"]);
        return categories.Select(category =>
            Assert.IsAssignableFrom<IReadOnlyDictionary<string, object?>>(category));
    }


    [Fact]
    public async Task CreateNewDienstleister2() {
        using var scope = _factory.Services.CreateScope();
        var db = scope.ServiceProvider.GetService<DomainContext>();

        // create a new Dienstleister
        var query = """
            mutation DienstleisterCreate($input: DienstleisterCreateInput!) {
                dienstleisterCreate(input: $input) {
                    dienstleister {
                    id
                    }
                    errors {
                    ... on Error {
                        message
                    }
                    }
                }
                }
        """;
        var parameters = new Dictionary<string, object?> {
                {"eMailAdressen" , new[] {"blubb2@bla"}},
                {"name" , "bla2"},
                {"organisationseinheitIds" , new Guid[] {KommuneSeeder.AerzenOrganisationseinheitId}}};

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteQuery(superAdmin, query, parameters);
        var queryResult = result.ExpectQueryResult();
        Assert.Null(queryResult.Errors);
        var data = queryResult.Data!["dienstleisterCreate"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(data);

        Assert.Null(data["errors"]);

        var dienstleister = data["dienstleister"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(dienstleister);

        var idValue = dienstleister["id"]?.ToString();
        Assert.NotNull(idValue);

        Guid dienstleisterId = Guid.Parse(idValue);

        // invite a Dienstleister Mitarbeiter
        var dienstleisterResult = await ExecuteQuery(superAdmin, """
        mutation DienstleisterMitarbeiterInvite($input: DienstleisterMitarbeiterInviteInput!) {
            dienstleisterMitarbeiterInvite(input: $input) {
                success
            }
        }
        """, new Dictionary<string, object?> {
            {"email", dienstLeisterEmail},
            {"dienstleisterId", dienstleisterId}
        });
        Assert.Null(dienstleisterResult.Errors);


        var dienstleisterBackofficeUser = await db!.BackofficeUser
            .AsNoTracking()
            .Include(u => u.UntereinheitPermissions)
            .FirstAsync(u => u.EMail == dienstLeisterEmail);

        Assert.Contains(FunktionsberechtigungInOrganisationseinheit.Backoffice, dienstleisterBackofficeUser.UntereinheitPermissions[0].Funktionsberechtigungen);
        Assert.Contains(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege, dienstleisterBackofficeUser.UntereinheitPermissions[0].Funktionsberechtigungen);


        var funktionsberechtigungenService = scope.ServiceProvider.GetRequiredService<FunktionsberechtigungenService>();
        var helpers = await funktionsberechtigungenService.GetHelpers(dienstleisterBackofficeUser.Id);
        Assert.Equal(Berechtigungsstatus.Ok, helpers.InOrganisationseinheit(KommuneSeeder.AerzenOrganisationseinheitId, FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege));

        // Dienstleister Mitarbeiter accepts the invitation
        var personalKeyPair = await crypto.GenerateKeyPair();
        const string Password = "Test12345678!";
        var encryptedPersonalKey = await crypto.EncryptPersonalKey(Password, dienstleisterBackofficeUser.EMail, personalKeyPair);
        var password = crypto.GetServerLoginPassword(Password, dienstleisterBackofficeUser.EMail);
        var registrationResult = await ExecuteQuery(null, """
                    mutation AcceptInvitation($input: RegisterBackofficeUserInput!) {
                        registerBackofficeUser(input: $input) {
                            result
                        }
                    }
                """, new Dictionary<string, object?> {
                    {"derivedPassword", password},
                    {"encryptedPrivateKey", new EncryptedValue(encryptedPersonalKey.Encrypted.Nonce, encryptedPersonalKey.Encrypted.Tag, encryptedPersonalKey.Encrypted.Cipher)},
                    {"invitationCode", dienstleisterBackofficeUser.InvitationCode},
                    {"nachname", "Doe"},
                    {"vorname", "John"},
                    {"publicKey", await crypto.ExportPublicKey(personalKeyPair)},
                    {"salt", encryptedPersonalKey.Salt}
                });

        Assert.Null(registrationResult.Errors);

        // check that the permissions are still there
        Assert.Equal(Berechtigungsstatus.Ok, helpers.InOrganisationseinheit(KommuneSeeder.AerzenOrganisationseinheitId, FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege));

        var newUntereinheit = db!.Untereinheit.Add(new Untereinheit {
            Name = "Neue Untereinheit",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = false,
        });
        await db!.SaveChangesAsync();

        // change the Dienstleister, add OE
        var updateDienstleisterReseult = await ExecuteQuery(superAdmin,
        """
            mutation DienstleisterUpdate($input: DienstleisterUpdateInput!) {
            dienstleisterUpdate(input: $input) {
                errors {
                ... on Error {
                    message
                }
                }
            }
            }
        """, new Dictionary<string, object?> {
           {"dienstleisterId", dienstleisterId},
                {"eMailAdressen" , new[] {"blubb2@bla"}},
                {"name" , "bla2"},
                {"organisationseinheitIds" , new Guid[] {KommuneSeeder.AerzenOrganisationseinheitId, newUntereinheit.Entity.Id}}
        });
        Assert.Null(updateDienstleisterReseult.Errors);

        // helers is a stateful object, need to get a new one:
        helpers = await funktionsberechtigungenService.GetHelpers(dienstleisterBackofficeUser.Id);
        Assert.Equal(Berechtigungsstatus.Ok, helpers.InOrganisationseinheit(KommuneSeeder.AerzenOrganisationseinheitId, FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege));
        Assert.Equal(Berechtigungsstatus.Ok, helpers.InOrganisationseinheit(newUntereinheit.Entity.Id, FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege));


        // userConfirm queues mail; KommuneDesign is stubbed via FakeBereichBGraphQLHttpMessageHandler on "BereichBClient".
        var superAdminUser = await db!.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);

        // Confirm Dienstleister-Mitarbeiter
        var confirmResult = await ExecuteQuery(superAdmin, """
                mutation UserConfirm($input: UserConfirmInput!) {
                    userConfirm(input: $input) {
                        boolean
                    }
                }
                """, new Dictionary<string, object?> {
                    {"organizationPrivateKey", superAdminUser.OrganisationPrivateKey},
                    {"userId", dienstleisterBackofficeUser.Id}
                });
        Assert.Null(confirmResult.Errors);


        // login a new User, and check the Berechtigungen:
        var loginInput = new Dictionary<string, object?> {
                    { "email", dienstLeisterEmail },
                    { "password", password }
                };

        var diesnstLeisterLoginResult = await ExecuteQuery(null, """
                    mutation Login($input: LoginInput!) {
                        login(input: $input) {
                            result
                            token
                        }
                    }
                """, loginInput);
        var loginResponse = diesnstLeisterLoginResult.Data!["login"] as IReadOnlyDictionary<string, object>;
        var token = loginResponse!["token"] as string;

        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);

        var identity = new ClaimsIdentity(jwtToken.Claims, "jwt");

        var dienstleiseterPrinicpal = new ClaimsPrincipal(identity);
        var dienstleisterMyResult = await ExecuteQuery(dienstleiseterPrinicpal, """

          query My {
            my @export(exportName: "User") {
              ...User
            }
          }

          fragment User on User {
            __typename
            id
            publicKey
            ... on Buerger {
              personalPrivateKey {
                ...EncryptedValue
              }
              personalPrivateKeySalt
            }
            ... on Mitarbeiter {
              eMail
              vorname
              nachname
              organisationPrivateKey
              # Kommune.name is stitched to the remote CMS (HttpClient "BereichB"); omit in integration tests.
              kommune {
                id
                privateKey {
                  ...EncryptedValue
                }
              }
              organisationPrivateKey
              gruppen {
                id
              }
            }
            ... on BackofficeUser {
              art
              isKommuneAdmin
              personalPrivateKey {
                ...EncryptedValue
              }
              personalPrivateKeySalt
              organisationseinheiten {
                id: organisationseinheitId
                meta: organisationseinheit {
                  name
                }
                funktionsberechtigungen: alleFunktionsberechtigungen
              }
              funktionsberechtigungen
            }
          }

          fragment EncryptedValue on EncryptedValue {
            cipher
            nonce
            tag
          }


        """, null);
        Assert.Null(dienstleisterMyResult.Errors);

        // // FIXME: checks for IDs which differ, need to find a way to fix this:
        // // dienstleisterMyResult.ExpectQueryResult().ToJson().MatchSnapshot();

    }


}
