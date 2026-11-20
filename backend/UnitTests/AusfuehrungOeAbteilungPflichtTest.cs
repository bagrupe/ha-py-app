using System.Security.Claims;
using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Expressions;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Seeders;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

[Collection("Api Tests")]
public class AusfuehrungOeAbteilungPflichtTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid AndereOeId = new("5e0a2d7c-6a52-4d8e-9d0b-2f6d2b0c7a11");

    private const string ContinueMutation =
        """
        mutation AusfuehrungContinue($input: AusfuehrungContinueInput!) {
          ausfuehrungContinue(input: $input) {
            ausfuehrungResult { ausfuehrung { id } }
          }
        }
        """;

    [Fact]
    public async Task OeOhneAbteilung_WirdAbgelehnt() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(KommuneSeeder.AerzenOrganisationseinheitId, null));

        AssertAbgelehnt(result, "Abteilung");
        await AssertZustaendigkeitUnveraendert(f);
    }

    [Fact]
    public async Task OeOhneAbteilung_WirdAuchBeiOeOhneAbteilungenAbgelehnt() {
        var f = await ErstelleSzenario(abteilungInAerzen: false);

        var result = await UebergebeAn(f, Oe(KommuneSeeder.AerzenOrganisationseinheitId, null));

        AssertAbgelehnt(result, "Abteilung");
        await AssertZustaendigkeitUnveraendert(f);
    }

    [Fact]
    public async Task OeOhneOrganisationseinheit_WirdAbgelehnt() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(null, f.AbteilungAerzenId));

        AssertAbgelehnt(result, "Organisationseinheit");
        await AssertZustaendigkeitUnveraendert(f);
    }

    [Fact]
    public async Task AbteilungEinerAnderenOe_WirdAbgelehnt() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(KommuneSeeder.AerzenOrganisationseinheitId, f.AbteilungAndereOeId));

        AssertAbgelehnt(result, "gehört nicht zur gewählten");
        await AssertZustaendigkeitUnveraendert(f);
    }

    [Fact]
    public async Task GeloeschteAbteilung_WirdAbgelehnt() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(KommuneSeeder.AerzenOrganisationseinheitId, f.GeloeschteAbteilungId));

        AssertAbgelehnt(result, "gehört nicht zur gewählten");
        await AssertZustaendigkeitUnveraendert(f);
    }

    [Fact]
    public async Task UnbekannteAbteilung_WirdAbgelehnt() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(KommuneSeeder.AerzenOrganisationseinheitId, Guid.NewGuid()));

        AssertAbgelehnt(result, "gehört nicht zur gewählten");
        await AssertZustaendigkeitUnveraendert(f);
    }

    [Fact]
    public async Task OeMitPassenderAbteilung_WirdAkzeptiert() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(KommuneSeeder.AerzenOrganisationseinheitId, f.AbteilungAerzenId));

        Assert.Null(result.Errors);
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var ausfuehrung = await db.Ausfuehrungen.Include(a => a.IstZustaendigkeit)
            .FirstAsync(a => a.Id == f.AusfuehrungId);
        Assert.Equal(f.DynamischerSchrittId, ausfuehrung.SchrittId);
        Assert.Equal(ZustaendigkeitArt.Organisationseinheit, ausfuehrung.IstZustaendigkeit.Art);
        Assert.Equal(KommuneSeeder.AerzenOrganisationseinheitId, ausfuehrung.IstZustaendigkeit.OrganisationseinheitId);
        Assert.Equal(f.AbteilungAerzenId, ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId);
    }

    [Fact]
    public async Task OeMitPassenderAbteilungDerAnderenOe_WirdAkzeptiert() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, Oe(AndereOeId, f.AbteilungAndereOeId));

        Assert.Null(result.Errors);
    }

    [Fact]
    public async Task Dienstleister_OhneAbteilung_VerhaeltSichWieBisher() {
        var f = await ErstelleSzenario();

        var result = await UebergebeAn(f, new Dictionary<string, object?> {
            ["art"] = "DIENSTLEISTER",
            ["organisationseinheitId"] = KommuneSeeder.AerzenOrganisationseinheitId,
            ["dienstleisterId"] = f.DienstleisterId,
            ["mitarbeiterGruppeId"] = null,
        });

        Assert.Null(result.Errors);
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var ausfuehrung = await db.Ausfuehrungen.Include(a => a.IstZustaendigkeit)
            .FirstAsync(a => a.Id == f.AusfuehrungId);
        Assert.Equal(ZustaendigkeitArt.Dienstleister, ausfuehrung.IstZustaendigkeit.Art);
        Assert.Equal(f.DienstleisterId, ausfuehrung.IstZustaendigkeit.DienstleisterId);
    }

    private static Dictionary<string, object?> Oe(Guid? oeId, Guid? abteilungId) => new() {
        ["art"] = "ORGANISATIONSEINHEIT",
        ["organisationseinheitId"] = oeId,
        ["mitarbeiterGruppeId"] = abteilungId,
    };

    private static void AssertAbgelehnt(HotChocolate.Execution.IQueryResult result, string meldungEnthaelt) {
        Assert.NotNull(result.Errors);
        Assert.Contains(result.Errors!, e => e.Message.Contains(meldungEnthaelt));
    }

    private async Task AssertZustaendigkeitUnveraendert(Szenario f) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var ausfuehrung = await db.Ausfuehrungen.Include(a => a.IstZustaendigkeit)
            .FirstAsync(a => a.Id == f.AusfuehrungId);
        Assert.Equal(f.SachbearbeiterSchrittId, ausfuehrung.SchrittId);
        Assert.Equal(KommuneSeeder.AerzenOrganisationseinheitId, ausfuehrung.IstZustaendigkeit.OrganisationseinheitId);
        Assert.Null(ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId);
    }

    private async Task<HotChocolate.Execution.IQueryResult> UebergebeAn(Szenario f,
        Dictionary<string, object?> naechsteZustaendigkeit) {
        var dynamischeDefaults = new Dictionary<string, object?> {
            ["dienstleisterId"] = null,
            ["liestRolleId"] = null,
            ["dynamischeArten"] = null,
        };
        foreach (var (key, value) in naechsteZustaendigkeit) dynamischeDefaults[key] = value;

        return await ExecuteQuery(f.SuperAdmin, ContinueMutation, new Dictionary<string, object?> {
            ["ausfuehrungId"] = f.AusfuehrungId,
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                new() {
                    ["schrittId"] = f.SachbearbeiterSchrittId,
                    ["nextVerbindungId"] = f.VerbindungZuDynamischId,
                    ["slotValues"] = new List<Dictionary<string, object?>>(),
                },
            },
            ["naechsteIstZustaendigkeit"] = dynamischeDefaults,
        });
    }

    private record Szenario(
        ClaimsPrincipal SuperAdmin,
        Guid AusfuehrungId,
        Guid SachbearbeiterSchrittId,
        Guid DynamischerSchrittId,
        Guid VerbindungZuDynamischId,
        Guid AbteilungAerzenId,
        Guid AbteilungAndereOeId,
        Guid GeloeschteAbteilungId,
        Guid DienstleisterId);

    private async Task<Szenario> ErstelleSzenario(bool abteilungInAerzen = true) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        await EnsureAndereOeExists(db);

        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;
        var aerzen = await db.Untereinheit.AsTracking()
            .FirstAsync(u => u.Id == KommuneSeeder.AerzenOrganisationseinheitId);
        var andere = await db.Untereinheit.AsTracking().FirstAsync(u => u.Id == AndereOeId);

        var abteilungAerzen = NeueAbteilung(kommuneId, "Abteilung Aerzen");
        if (abteilungInAerzen) abteilungAerzen.Organisationseinheiten.Add(aerzen);
        var abteilungAndere = NeueAbteilung(kommuneId, "Abteilung Andere OE");
        abteilungAndere.Organisationseinheiten.Add(andere);
        var geloescht = NeueAbteilung(kommuneId, "Gelöschte Abteilung");
        geloescht.IsDeleted = true;
        geloescht.Organisationseinheiten.Add(aerzen);
        db.MitarbeiterGruppen.AddRange(abteilungAerzen, abteilungAndere, geloescht);

        var dienstleisterId = Guid.NewGuid();
        db.Dienstleister.Add(new Dienstleister {
            Id = dienstleisterId,
            Name = "OE-Abteilung-Test-Dienstleister",
            EMailAdressen = [$"oe-abteilung-dl-{dienstleisterId:N}@test.local"],
            MandantId = kommuneId,
        });

        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "OE-Abteilung-Pflicht-Test",
            KommuneId = kommuneId,
        };
        var version = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"OE-Abteilung-Pflicht",
        };
        var start = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = new List<FormularFeld> { new StringFormularFeld { SlotName = "foo", Order = 0 } },
        };
        var sachbearbeiter = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
            Felder = new List<FormularFeld>(),
        };
        var dynamisch = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Dynamisch,
                DynamischeArten = [ZustaendigkeitArt.Organisationseinheit, ZustaendigkeitArt.Dienstleister],
            },
            Felder = new List<FormularFeld>(),
        };
        var ende = new EndeSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
        };
        version.Schritte.Add(start);
        version.Schritte.Add(sachbearbeiter);
        version.Schritte.Add(dynamisch);
        version.Schritte.Add(ende);

        var startZuSach = new Verbindung { Von = start, Nach = sachbearbeiter };
        start.Verbindungen.Add(startZuSach);
        var sachZuDynamisch = new Verbindung { Von = sachbearbeiter, Nach = dynamisch };
        sachbearbeiter.Verbindungen.Add(sachZuDynamisch);
        dynamisch.Verbindungen.Add(new Verbindung { Von = dynamisch, Nach = ende });

        await db.ProzessVersionen.AddAsync(version);
        await db.SaveChangesAsync();
        version.Start = start;
        await db.SaveChangesAsync();

        var (_, buerger) = await testSeeder.CreateBuergerWithPushPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await ErstelleAusfuehrung(buerger, version.Id);
        await Walk(buerger, ausfuehrungId, start.Id, startZuSach.Id,
            new List<Dictionary<string, object?>> {
                new() {
                    ["name"] = "foo",
                    ["value"] = new Dictionary<string, object?> {
                        ["plainValue"] = JsonSerializer.SerializeToElement("bar"),
                    },
                },
            });

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminId = (await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail)).Id;
        var uebernehmen = await ExecuteGraphqlAsync(superAdmin,
            """
            mutation U($ausfuehrungId: UUID!, $userId: UUID!) {
              ausfuehrungUpdateZugewiesenePerson(input: { ausfuehrungId: $ausfuehrungId, userId: $userId }) {
                ausfuehrung { id }
              }
            }
            """,
            new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId, ["userId"] = superAdminId });
        Assert.Null(uebernehmen.Errors);

        return new Szenario(superAdmin, ausfuehrungId, sachbearbeiter.Id, dynamisch.Id, sachZuDynamisch.Id,
            abteilungAerzen.Id, abteilungAndere.Id, geloescht.Id, dienstleisterId);
    }

    private static MitarbeiterGruppe NeueAbteilung(Guid kommuneId, string name) => new() {
        Id = Guid.NewGuid(),
        Name = $"{name} {Guid.NewGuid():N}",
        KommuneId = kommuneId,
    };

    private static async Task EnsureAndereOeExists(DomainContext db) {
        if (await db.Untereinheit.AnyAsync(u => u.Id == AndereOeId)) return;
        db.Untereinheit.Add(new Untereinheit {
            Id = AndereOeId,
            Name = "Andere OE (Abteilung-Pflicht-Test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252098",
        });
        await db.SaveChangesAsync();
    }

    private async Task<Guid> ErstelleAusfuehrung(ClaimsPrincipal buerger, Guid prozessVersionId) {
        var result = await ExecuteQuery(buerger,
            """
            mutation AusfuehrungErstellen($input: AusfuehrungCreateInput!) {
              ausfuehrungCreate(input: $input) {
                ausfuehrungResult { ausfuehrung { id } shouldContinue }
              }
            }
            """,
            new Dictionary<string, object?> {
                ["prozessVersionId"] = prozessVersionId,
                ["sharedKeyEncryptedForBuerger"] = "foo",
                ["sharedKeyEncryptedForKommune"] = "bar",
                ["bearbeitungen"] = new List<Dictionary<string, object?>>(),
            });
        Assert.Null(result.Errors);
        var create = result.Data!["ausfuehrungCreate"] as IReadOnlyDictionary<string, object>;
        var ausfuehrungResult = create!["ausfuehrungResult"] as IReadOnlyDictionary<string, object>;
        var ausfuehrung = ausfuehrungResult!["ausfuehrung"] as IReadOnlyDictionary<string, object>;
        return Guid.Parse(ausfuehrung!["id"].ToString()!);
    }

    private async Task Walk(ClaimsPrincipal user, Guid ausfuehrungId, Guid schrittId, Guid verbindungId,
        List<Dictionary<string, object?>> slotValues) {
        var result = await ExecuteQuery(user, ContinueMutation, new Dictionary<string, object?> {
            ["ausfuehrungId"] = ausfuehrungId,
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                new() {
                    ["schrittId"] = schrittId,
                    ["nextVerbindungId"] = verbindungId,
                    ["slotValues"] = slotValues,
                },
            },
            ["naechsteIstZustaendigkeit"] = null,
        });
        Assert.Null(result.Errors);
    }
}
