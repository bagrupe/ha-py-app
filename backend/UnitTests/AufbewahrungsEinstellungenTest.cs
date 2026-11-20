using System.Security.Claims;
using API.Features;
using API.Features.Aufbewahrung;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Funktionsberechtigungen;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace IntegrationTests;

/// <summary>
/// Deckt Loics generellen Review-Hinweis ab ("jede neue Query/Mutation sollte mindestens einen
/// Test haben") für <see cref="AufbewahrungsEinstellungenQueries"/> und
/// <see cref="Mutations.AufbewahrungsEinstellungenMutation"/>, die zuvor ungetestet waren.
/// </summary>
[Collection("Api Tests")]
public class AufbewahrungsEinstellungenTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string GetQuery = """
        query Einstellungen {
          aufbewahrungsEinstellungen {
            hardDeleteVerzoegerungMinuten
            archivVerzoegerungMinuten
            hardDeleteAktiv
            archivierungAktiv
          }
        }
        """;

    private const string UpdateMutation = """
        mutation Update($input: AufbewahrungsEinstellungenAktualisierenInput!) {
          aufbewahrungsEinstellungenAktualisieren(input: $input) {
            einstellungen {
              hardDeleteVerzoegerungMinuten
              archivVerzoegerungMinuten
              hardDeleteAktiv
              archivierungAktiv
              aktualisiertAm
            }
            errors { ... on Error { message } }
          }
        }
        """;

    [Fact]
    public async Task GetAufbewahrungsEinstellungen_Ohne_Berechtigung_schlaegt_fehl() {
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, GetQuery);

        Assert.NotNull(result.Errors);
    }

    [Fact]
    public async Task GetAufbewahrungsEinstellungen_Mit_Berechtigung_liefert_Werte() {
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AufbewahrungVerwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, GetQuery);

        Assert.Null(result.Errors);
        var einstellungen = result.Data!["aufbewahrungsEinstellungen"] as IReadOnlyDictionary<string, object>;
        Assert.NotNull(einstellungen);
    }

    [Fact]
    public async Task Aktualisieren_Ohne_Berechtigung_liefert_Fehler_im_Payload() {
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync([]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, UpdateMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["hardDeleteVerzoegerungMinuten"] = 60,
                ["archivVerzoegerungMinuten"] = 120,
                ["hardDeleteAktiv"] = false,
                ["archivierungAktiv"] = false,
            },
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["aufbewahrungsEinstellungenAktualisieren"] as IReadOnlyDictionary<string, object>;
        Assert.NotEmpty((IEnumerable<object>)payload!["errors"]!);
    }

    [Fact]
    public async Task Aktualisieren_Mit_Berechtigung_speichert_und_liefert_neue_Werte() {
        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AufbewahrungVerwaltung]);

        var result = await ExecuteGraphqlAsync(mitarbeiter, UpdateMutation, new Dictionary<string, object?> {
            ["input"] = new Dictionary<string, object?> {
                ["hardDeleteVerzoegerungMinuten"] = 4242,
                ["archivVerzoegerungMinuten"] = 1337,
                ["hardDeleteAktiv"] = true,
                ["archivierungAktiv"] = true,
            },
        });

        Assert.Null(result.Errors);
        var payload = result.Data!["aufbewahrungsEinstellungenAktualisieren"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);
        var einstellungen = payload["einstellungen"] as IReadOnlyDictionary<string, object>;
        Assert.Equal(4242L, Convert.ToInt64(einstellungen!["hardDeleteVerzoegerungMinuten"]));
        Assert.Equal(1337L, Convert.ToInt64(einstellungen["archivVerzoegerungMinuten"]));
        Assert.True((bool)einstellungen["hardDeleteAktiv"]);
        Assert.True((bool)einstellungen["archivierungAktiv"]);
        Assert.NotNull(einstellungen["aktualisiertAm"]);

        var erneutGelesen = await ExecuteGraphqlAsync(mitarbeiter, GetQuery);
        var erneut = erneutGelesen.Data!["aufbewahrungsEinstellungen"] as IReadOnlyDictionary<string, object>;
        Assert.Equal(4242L, Convert.ToInt64(erneut!["hardDeleteVerzoegerungMinuten"]));
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"aufbewahrung-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Aufbewahrung",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
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
