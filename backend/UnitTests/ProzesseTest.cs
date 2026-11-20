using API.Features;
using API.Features.Auth;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

/// <summary>
/// Integration tests for process-version creation and step validation.
/// </summary>
[Collection("Api Tests")]
public class ProzesseTest(BackendApiFactory factory) : GraphQLTests(factory) {
    /// <summary>
    /// Own <see cref="MitarbeiterGruppe"/> for these tests so we never mutate the seeded Sachbearbeiter group
    /// (<see cref="UserGroupTests"/> depends on it via <c>updateAbteilung</c>).
    /// </summary>
    private static readonly Guid ProzessValidationTestGruppeId = new("bada555e-0000-4000-8000-000000000001");

    /// <summary>Second Untereinheit in the same Kommune — used only as “wrong” OE for <see cref="ProzessValidationTestGruppeId"/>.</summary>
    private static readonly Guid SecondOrganisationseinheitId = new("c0ffee00-0000-4000-8000-000000000001");

    private const string MutationUpdateAbteilung = """
        mutation UpdateAbteilung($input: UpdateAbteilungInput!) {
          updateAbteilung(input: $input) {
            mitarbeiterGruppe {
              id
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

    private const string MutationNeueProzessVersion = """
        mutation NeueProzessVersionErstellen($input: ProzessVersionErstellenInput!) {
          prozessVersionErstellen(input: $input) {
            prozess {
              id
            }
            errors {
              __typename
            }
          }
        }
        """;

    /// <summary>
    /// Group + OE are chosen but there is <b>no</b> MitarbeiterGruppe–Untereinheit row (never linked).
    /// For an explicit “linked to OE A, step uses OE B” case, see
    /// <see cref="ProzessVersionErstellen_rejects_mitarbeiter_gruppe_paired_with_wrong_organisationseinheit"/>.
    /// </summary>
    [Fact]
    public async Task ProzessVersionErstellen_rejects_mitarbeiter_gruppe_not_linked_to_organisationseinheit() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureProzessValidationTestMitarbeiterGruppeExists();
        await UnlinkProzessValidationTestGruppeFromAllOrganisationseinheiten();

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "Validation test process",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();

        var versionCountBefore = await db.ProzessVersionen.CountAsync(pv => pv.ProzessId == prozess.Id);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var schrittId = Guid.NewGuid();
        var oeId = KommuneSeeder.AerzenOrganisationseinheitId;

        var input = BuildMinimalProzessVersionErstellenInput(prozess.Id, schrittId, sollZustaendigkeit: new Dictionary<string, object?> {
            ["art"] = "ORGANISATIONSEINHEIT",
            ["mitarbeiterGruppeId"] = ProzessValidationTestGruppeId,
            ["organisationseinheitId"] = oeId,
        });

        var result = await ExecuteQuery(superAdmin, MutationNeueProzessVersion, input);

        Assert.NotNull(result.Errors);
        Assert.NotEmpty(result.Errors);

        await using var scope2 = Factory.Services.CreateAsyncScope();
        var db2 = scope2.ServiceProvider.GetRequiredService<DomainContext>();
        var versionCountAfter = await db2.ProzessVersionen.CountAsync(pv => pv.ProzessId == prozess.Id);
        Assert.Equal(versionCountBefore, versionCountAfter);
    }

    /// <summary>
    /// Group is linked to one Organisationseinheit (Aerzen), but the step references another OE — the pair must be rejected.
    /// This makes the “gehören nicht zusammen” case explicit (not only “never linked”).
    /// </summary>
    [Fact]
    public async Task ProzessVersionErstellen_rejects_mitarbeiter_gruppe_paired_with_wrong_organisationseinheit() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureSecondOrganisationseinheitExists();
        await EnsureProzessValidationTestMitarbeiterGruppeExists();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var aerzenId = KommuneSeeder.AerzenOrganisationseinheitId;

        // Test group is linked only to Aerzen, not to SecondOrganisationseinheitId.
        var linkResult = await ExecuteQuery(superAdmin, MutationUpdateAbteilung, new Dictionary<string, object?> {
            ["id"] = ProzessValidationTestGruppeId,
            ["name"] = "Prozess validation test (do not use in UI)",
            ["eMailAdressen"] = Array.Empty<string>(),
            ["organisationseinheitIds"] = new[] { aerzenId },
        });
        Assert.False(linkResult.Errors?.Any() ?? false);
        var linkPayload = linkResult.Data!["updateAbteilung"] as IReadOnlyDictionary<string, object>;
        var linkErrors = linkPayload!["errors"] as IEnumerable<object>;
        Assert.False(linkErrors?.Any() ?? false);

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "Validation test process (wrong OE pair)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();

        var versionCountBefore = await db.ProzessVersionen.CountAsync(pv => pv.ProzessId == prozess.Id);

        var schrittId = Guid.NewGuid();
        var input = BuildMinimalProzessVersionErstellenInput(prozess.Id, schrittId, sollZustaendigkeit: new Dictionary<string, object?> {
            ["art"] = "ORGANISATIONSEINHEIT",
            ["mitarbeiterGruppeId"] = ProzessValidationTestGruppeId,
            ["organisationseinheitId"] = SecondOrganisationseinheitId,
        });

        var result = await ExecuteQuery(superAdmin, MutationNeueProzessVersion, input);

        Assert.NotNull(result.Errors);
        Assert.NotEmpty(result.Errors);

        await using var scope2 = Factory.Services.CreateAsyncScope();
        var db2 = scope2.ServiceProvider.GetRequiredService<DomainContext>();
        var versionCountAfter = await db2.ProzessVersionen.CountAsync(pv => pv.ProzessId == prozess.Id);
        Assert.Equal(versionCountBefore, versionCountAfter);
    }

    /// <summary>
    /// If a Mitarbeitergruppe is set, an Organisationseinheit (Untereinheit) must always be set.
    /// </summary>
    [Fact]
    public async Task ProzessVersionErstellen_rejects_mitarbeiter_gruppe_without_organisationseinheit() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureProzessValidationTestMitarbeiterGruppeExists();

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "Validation test process (no OE)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.Prozesse.Add(prozess);
        await db.SaveChangesAsync();

        var versionCountBefore = await db.ProzessVersionen.CountAsync(pv => pv.ProzessId == prozess.Id);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var schrittId = Guid.NewGuid();

        var input = BuildMinimalProzessVersionErstellenInput(prozess.Id, schrittId, sollZustaendigkeit: new Dictionary<string, object?> {
            ["art"] = "ORGANISATIONSEINHEIT",
            ["mitarbeiterGruppeId"] = ProzessValidationTestGruppeId,
            ["organisationseinheitId"] = null,
        });

        var result = await ExecuteQuery(superAdmin, MutationNeueProzessVersion, input);

        Assert.NotNull(result.Errors);
        Assert.NotEmpty(result.Errors);

        await using var scope2 = Factory.Services.CreateAsyncScope();
        var db2 = scope2.ServiceProvider.GetRequiredService<DomainContext>();
        var versionCountAfter = await db2.ProzessVersionen.CountAsync(pv => pv.ProzessId == prozess.Id);
        Assert.Equal(versionCountBefore, versionCountAfter);
    }

    private async Task EnsureSecondOrganisationseinheitExists() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.Untereinheit.AnyAsync(u => u.Id == SecondOrganisationseinheitId)) {
            return;
        }

        db.Untereinheit.Add(new Untereinheit {
            Id = SecondOrganisationseinheitId,
            Name = "Second OE (test, Prozess validation group)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = false,
            Regionalschluessel = "03252999",
        });
        await db.SaveChangesAsync();
    }

    private async Task EnsureProzessValidationTestMitarbeiterGruppeExists() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.MitarbeiterGruppen.AnyAsync(g => g.Id == ProzessValidationTestGruppeId)) {
            return;
        }

        var ordinal = await db.MitarbeiterGruppen.CountAsync(g => g.KommuneId == KommuneSeeder.LandkreisHaPy.Id);
        db.MitarbeiterGruppen.Add(new MitarbeiterGruppe {
            Id = ProzessValidationTestGruppeId,
            Name = "Prozess validation test (do not use in UI)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Ordinal = ordinal,
        });
        await db.SaveChangesAsync();
    }

    /// <summary>Clears M:N to Untereinheiten so the “not linked” scenario is stable across test runs and order.</summary>
    private async Task UnlinkProzessValidationTestGruppeFromAllOrganisationseinheiten() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var gruppe = await db.MitarbeiterGruppen
            .Include(g => g.Organisationseinheiten)
            .FirstOrDefaultAsync(g => g.Id == ProzessValidationTestGruppeId);
        if (gruppe is null) {
            return;
        }

        gruppe.Organisationseinheiten.Clear();
        await db.SaveChangesAsync();
    }

    /// <summary>
    /// Minimal valid-shaped <see cref="ProzessVersionErstellenInput"/> for GraphQL execution (see
    /// <c>web/bereich-a/schema.graphql</c>): one <c>EndeSchritt</c>, no Verbindungen, no Rollen.
    /// </summary>
    private static Dictionary<string, object?> BuildMinimalProzessVersionErstellenInput(Guid prozessId, Guid schrittId,
        Dictionary<string, object?> sollZustaendigkeit) =>
        new() {
            ["prozessId"] = prozessId,
            ["veroeffentlichen"] = false,
            ["verbindungen"] = Array.Empty<object>(),
            ["zustaendigkeitRollen"] = Array.Empty<object>(),
            ["schritte"] = new object[] {
                new Dictionary<string, object?> {
                    ["endeSchrittInput"] = new Dictionary<string, object?> {
                        ["id"] = schrittId,
                        ["sollZustaendigkeit"] = sollZustaendigkeit,
                    },
                },
            },
        };
}
