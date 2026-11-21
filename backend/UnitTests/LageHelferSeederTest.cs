using System.Text.Json.Nodes;
using API.Features;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Lage;
using API.Features.Prozess;
using API.Options;
using API.Seeders.LageHelfer;
using HotChocolate;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using Path = System.IO.Path;

namespace IntegrationTests;

[Collection("LageHelfer Seeder Tests")]
public class LageHelferSeederTest(LageHelferSeederApiFactory factory) : GraphQLTests(factory), IAsyncLifetime {
    private readonly LageHelferSeederApiFactory _lageHelferFactory = factory;

    public new async Task InitializeAsync() => await _lageHelferFactory.ResetDatabaseAsync();
    private const string DemoKeyEncryptionKey = "fbqTzzZyfSPyAGBbyJZ30EMimLVpcNr+Crv8AvzHohU=";

    private static string ExampleSeedPath =>
        Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "API",
            "Seeders", "LageHelfer", "Data", "example"));

    private static LageHelferSeedDocument ExampleDocument => LageHelferSeedLoader.Load(ExampleSeedPath);

    private async Task RunSeeder(EnvironmentOptions? environment = null, string? seedPath = null) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var seederOptions = new DataSeederOptions {
            LageHelferEnabled = true,
            LageHelferSeedPath = seedPath ?? ExampleSeedPath,
            LageHelferKeyEncryptionKey = DemoKeyEncryptionKey,
        };
        var seeder = environment is null
            ? ActivatorUtilities.CreateInstance<LageHelferSeeder>(scope.ServiceProvider, seederOptions)
            : ActivatorUtilities.CreateInstance<LageHelferSeeder>(scope.ServiceProvider, environment, seederOptions);
        await seeder.Execute();
    }

    private async Task<DomainContext> NewDbAsync() {
        var factory = Factory.Services.GetRequiredService<IDbContextFactory<DomainContext>>();
        return await factory.CreateDbContextAsync();
    }

    private DomainContext NewDb() =>
        Factory.Services.GetRequiredService<IDbContextFactory<DomainContext>>().CreateDbContext();

    [Fact]
    public async Task Seeds_Kommune_Untereinheiten_Gebiete_and_Nutzer() {
        var doc = ExampleDocument;
        await RunSeeder();

        var db = NewDb();
        var kommune = await db.Kommunen.SingleAsync(k => k.Id == doc.Kommune.Id);
        Assert.Equal(doc.Kommune.Name, kommune.Name);

        var bereichCount = doc.Organisationseinheiten.Sum(o => o.Bereiche.Count);
        var einsatzleitungCount = doc.Organisationseinheiten
            .SelectMany(o => o.Bereiche)
            .Count(b => !string.IsNullOrWhiteSpace(b.Einsatzleitung));
        Assert.Equal(doc.Organisationseinheiten.Count,
            await db.Untereinheit.CountAsync(u => u.KommuneId == doc.Kommune.Id));

        var extraAbteilungen = doc.Organisationseinheiten.Sum(o => o.Abteilungen.Count);
        Assert.Equal(einsatzleitungCount + extraAbteilungen,
            await db.MitarbeiterGruppen.CountAsync(g => g.KommuneId == doc.Kommune.Id));
        Assert.Equal(einsatzleitungCount, await db.GebietEinsatzleitungen.CountAsync());

        var gebiete = await db.Gebiete
            .Where(g => g.Untereinheit.KommuneId == doc.Kommune.Id)
            .ToListAsync();
        Assert.Equal(bereichCount, gebiete.Count);
        Assert.Contains(gebiete, g => g.Name == "Walddorf" && g.Geometry is null);
        Assert.All(gebiete.Where(g => g.Geometry is not null),
            g => Assert.Contains(JsonNode.Parse(g.Geometry!)!["type"]!.GetValue<string>(),
                new[] { "Polygon", "MultiPolygon" }));

        var nutzer = await db.BackofficeUser
            .Where(u => u.KommuneId == doc.Kommune.Id)
            .ToListAsync();
        Assert.Equal(doc.Demo!.Nutzer.Count, nutzer.Count);
    }

    [Fact]
    public async Task Can_be_run_twice_without_duplicating_data() {
        await RunSeeder();
        var db = NewDb();
        var untereinheiten = await db.Untereinheit.CountAsync();
        var gebiete = await db.Gebiete.CountAsync();
        var nutzer = await db.BackofficeUser.CountAsync();

        await RunSeeder();

        db = NewDb();
        Assert.Equal(untereinheiten, await db.Untereinheit.CountAsync());
        Assert.Equal(gebiete, await db.Gebiete.CountAsync());
        Assert.Equal(nutzer, await db.BackofficeUser.CountAsync());
    }

    [Fact]
    public async Task Seeds_globale_LageHelfer_berechtigung_for_demo_nutzer() {
        var doc = ExampleDocument;
        await RunSeeder();

        var db = NewDb();
        var nutzerId = LageHelferSeedData.NutzerId(doc.IdNamespace, "einsatzleitung-nord");
        var user = await db.BackofficeUser.AsNoTracking().SingleAsync(u => u.Id == nutzerId);
        Assert.Contains(GlobaleFunktionsberechtigung.LageHelfer, user.Funktionsberechtigungen);
    }

    [Fact]
    public async Task Lage_can_be_created_for_seeded_Organisationseinheit() {
        var doc = ExampleDocument;
        await RunSeeder();

        var db = NewDb();
        var oeKey = doc.Organisationseinheiten[0].Key;
        var oeId = LageHelferSeedData.OrganisationseinheitId(doc.IdNamespace, oeKey);
        var gebiete = await db.Gebiete.Where(g => g.UntereinheitId == oeId).ToListAsync();

        var lage = Lage.Create(oeId, "Hochwasser", gebiete, Guid.NewGuid(),
            NodaTime.SystemClock.Instance.GetCurrentInstant());
        Assert.Equal(gebiete.Count, lage.LageGebiete.Count);
    }

    [Fact]
    public async Task Production_seeds_structure_but_not_demo_users() {
        var doc = ExampleDocument;
        await RunSeeder(new EnvironmentOptions { Name = "Production" });

        var db = NewDb();
        Assert.Equal(1, await db.Kommunen.CountAsync(k => k.Id == doc.Kommune.Id));
        Assert.Equal(doc.Organisationseinheiten.Sum(o => o.Bereiche.Count),
            await db.Gebiete.CountAsync(g => g.Untereinheit.KommuneId == doc.Kommune.Id));

        var demoNutzerIds = doc.Demo!.Nutzer
            .Select(n => LageHelferSeedData.NutzerId(doc.IdNamespace, n.Key))
            .ToHashSet();
        var demoUsers = await db.BackofficeUser
            .Where(u => u.KommuneId == doc.Kommune.Id && demoNutzerIds.Contains(u.Id))
            .ToListAsync();
        Assert.Empty(demoUsers);
    }

    [Fact]
    public async Task Geometry_in_open_Lage_is_not_overwritten_on_second_run() {
        var doc = ExampleDocument;
        await RunSeeder();

        await using var db = await NewDbAsync();
        var nordstadtId = LageHelferSeedData.GebietId(doc.IdNamespace, "Nordstadt");
        var oeId = LageHelferSeedData.OrganisationseinheitId(doc.IdNamespace, "Nordkreis");
        var gebiete = await db.Gebiete.Where(g => g.UntereinheitId == oeId).ToListAsync();
        var lage = Lage.Create(oeId, "Testlage", gebiete, Guid.NewGuid(), SystemClock.Instance.GetCurrentInstant());
        db.Lagen.Add(lage);
        await db.SaveChangesAsync();

        var original = (await db.Gebiete.AsNoTracking().FirstAsync(g => g.Id == nordstadtId)).Geometry;
        var mutated = """{"type":"Polygon","coordinates":[[[0,0],[0.1,0],[0.1,0.1],[0,0]]]}""";
        await db.Gebiete.Where(g => g.Id == nordstadtId).ExecuteUpdateAsync(s => s.SetProperty(g => g.Geometry, mutated));

        await using (var verify = await NewDbAsync()) {
            Assert.True(await verify.LageGebiete.AsNoTracking()
                .Where(lg => lg.GebietId == nordstadtId && lg.Status != LageGebietStatus.Ended
                    && lg.Status != LageGebietStatus.Done)
                .AnyAsync(lg => lg.Lage.Status != LageStatus.Closed && lg.Lage.DeletedAt == null));
            Assert.True(JsonNode.DeepEquals(JsonNode.Parse(mutated),
                JsonNode.Parse((await verify.Gebiete.AsNoTracking().FirstAsync(g => g.Id == nordstadtId)).Geometry!)));
        }

        await RunSeeder();

        await using var afterDb = await NewDbAsync();
        var after = await afterDb.Gebiete.AsNoTracking().FirstAsync(g => g.Id == nordstadtId);
        Assert.True(JsonNode.DeepEquals(JsonNode.Parse(mutated), JsonNode.Parse(after.Geometry!)));
        Assert.False(JsonNode.DeepEquals(JsonNode.Parse(original!), JsonNode.Parse(after.Geometry!)));
    }

    private Guid MeldeprozessId => LageHelferSeedData.ProzessId(ExampleDocument.IdNamespace, "ereignis-melden");

    [Fact]
    public async Task Seeds_meldeprozess_with_anonym_tag_and_is_idempotent() {
        await RunSeeder();
        await RunSeeder();

        var db = NewDb();
        var prozess = await db.Prozesse.AsSplitQuery().Include(p => p.Tags).Include(p => p.Versionen)
            .SingleAsync(p => p.Id == MeldeprozessId);
        Assert.Equal("Ereignis melden", prozess.Name);
        Assert.Equal(ExampleDocument.Kommune.Id, prozess.KommuneId);
        Assert.Single(prozess.Versionen);
        Assert.Equal([AnonymeEinreichung.ProzessTagName, AnonymeEinreichung.LageHelferTagName],
            prozess.Tags.Select(t => t.Tag).Order());
        Assert.Single(await db.ProzessTags.Where(t => t.Tag == AnonymeEinreichung.ProzessTagName).ToListAsync());
        Assert.Equal(2, await db.ProzessTagHistorie.CountAsync(h => h.ProzessId == MeldeprozessId));
    }

    [Fact]
    public async Task Changed_kategorien_publish_a_new_version_and_keep_the_old_one() {
        await RunSeeder();

        var changedSeed = Path.Combine(Path.GetTempPath(), "lagehelfer-seed-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(changedSeed);
        File.Copy(Path.Combine(ExampleSeedPath, "flaechen.geojson"), Path.Combine(changedSeed, "flaechen.geojson"));
        File.WriteAllText(Path.Combine(changedSeed, "seed.json"),
            File.ReadAllText(Path.Combine(ExampleSeedPath, "seed.json"))
                .Replace("\"Blitzeis\"]", "\"Blitzeis\", \"Hochwasser\"]"));
        await RunSeeder(seedPath: changedSeed);
        await RunSeeder(seedPath: changedSeed);

        var db = NewDb();
        var versionen = await db.ProzessVersionen.Where(v => v.ProzessId == MeldeprozessId).ToListAsync();
        Assert.Equal(2, versionen.Count);
    }

    [Fact]
    public async Task Seeded_meldeprozess_runs_from_anonymous_report_to_hilfe_unterwegs() {
        await RunSeeder();
        var db = NewDb();
        // The database reset wipes the SystemUser that app startup normally guarantees.
        await SystemUser.EnsureSystemUserExists(db);
        var version = await db.ProzessVersionen.AsSplitQuery().Where(v => v.ProzessId == MeldeprozessId)
            .Include(v => v.Schritte).ThenInclude(s => s.Verbindungen).SingleAsync();
        var lebensgefahr = version.Schritte.Single(s => s.Id == version.StartId);
        var meldung = version.Schritte.OfType<FormularSchritt>().Single(s => s.Titel == "Angaben zum Ereignis");
        var pruefung = version.Schritte.Single(s => s.Titel == "Meldung prüfen");
        var einsatz = version.Schritte.Single(s => s.Titel == "Einsatz läuft");
        var fluessenstadtGebiet = LageHelferSeedData.GebietId(ExampleDocument.IdNamespace, "Fluessenstadt");
        var lage = await SeedLiveLage(fluessenstadtGebiet);

        Factory.Services.GetRequiredService<IHttpContextAccessor>().HttpContext = new DefaultHttpContext();
        var create = await ExecuteQuery(null, """
            mutation CreateAnonym($input: AusfuehrungCreateAnonymInput!) {
              ausfuehrungCreateAnonym(input: $input) {
                anonymeAusfuehrungResult { correlationId }
              }
            }
            """, new Dictionary<string, object?> {
            ["prozessVersionId"] = version.Id,
            ["sharedKeyEncryptedForKommune"] = "key",
            ["lage"] = new Dictionary<string, object?> { ["lageId"] = lage.Id, ["gebietId"] = fluessenstadtGebiet },
            ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                Bearbeitung(lebensgefahr, lebensgefahr.Verbindungen.Single(v => v.NachId == meldung.Id),
                    (EreignismeldungVorlage.LebensgefahrSlot, "Nein")),
                Bearbeitung(meldung, meldung.Verbindungen.Single(),
                    (EreignismeldungVorlage.StandortSlot, new Dictionary<string, object?> {
                        ["addressString"] = "Fluessenstadt",
                        ["coordinates"] = new List<object> { 9.2, 51.95 },
                    }),
                    (EreignismeldungVorlage.KategorieSlot, "Unwetter")),
            },
        });
        Assert.True(create.Errors is null, create.ToJson());
        var correlationId = Guid.Parse(create.ToJson().Split("\"correlationId\": \"")[1][..36]);

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var runner = ActivatorUtilities.CreateInstance<ProgrammatischerSchrittRunner>(scope.ServiceProvider);
            await runner.Execute(JobExecutionContextTestHelper.Create("test"));
        }

        var ausfuehrung = await NewDb().Ausfuehrungen.SingleAsync(a => a.CorrelationId == correlationId);
        Assert.Equal(pruefung.Id, ausfuehrung.SchrittId);
        var fluessenstadt = LageHelferSeedData.EinsatzleitungId(ExampleDocument.IdNamespace, "Fluessenstadt");
        Assert.Equal(fluessenstadt, ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId);

        var walkerFactory = Factory.Services.GetRequiredService<WalkerFactory>();
        await using (var walker = await walkerFactory.ContinueAusfuehrung(ausfuehrung.Id)) {
            walker.Step(LageHelferSeedData.NutzerId(ExampleDocument.IdNamespace, "superadmin"), pruefung.Verbindungen.Single(v => v.NachId == einsatz.Id).Id, [], null);
            await walker.SaveChangesAsync();
        }

        ausfuehrung = await NewDb().Ausfuehrungen.SingleAsync(a => a.Id == ausfuehrung.Id);
        Assert.Equal(einsatz.Id, ausfuehrung.SchrittId);
        Assert.Equal(fluessenstadt, ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId);

        Factory.Services.GetRequiredService<IHttpContextAccessor>().HttpContext = new DefaultHttpContext();
        var status = await ExecuteGraphqlAsync(null, """
            query Status($correlationId: UUID!) {
              ausfuehrungStatusAnonym(correlationId: $correlationId) {
                historie { createdAt statusAenderung statusAenderungBeschreibung nachricht }
              }
            }
            """, new Dictionary<string, object?> { ["correlationId"] = correlationId });
        Assert.True(status.Errors is null, status.ToJson());
        Assert.Contains(EreignismeldungVorlage.StatusHilfeUnterwegs, status.ToJson());
        // The Superadmin clicked "Hilfe einleiten"; a CorrelationId must not reveal who that was.
        Assert.DoesNotContain("Superadmin", status.ToJson());

        var mitName = await ExecuteGraphqlAsync(null, """
            query Status($correlationId: UUID!) {
              ausfuehrungStatusAnonym(correlationId: $correlationId) { historie { benutzer } }
            }
            """, new Dictionary<string, object?> { ["correlationId"] = correlationId });
        Assert.NotNull(mitName.Errors);
    }

    private async Task<Lage> SeedLiveLage(Guid gebietId) {
        await using var db = await NewDbAsync();
        var gebiet = await db.Gebiete.SingleAsync(g => g.Id == gebietId);
        var now = Factory.Services.GetRequiredService<IClock>().GetCurrentInstant();
        var actorId = LageHelferSeedData.NutzerId(ExampleDocument.IdNamespace, "superadmin");
        var lage = Lage.Create(gebiet.UntereinheitId, "Hochwasser", [gebiet], actorId, now);
        foreach (var status in new[] { LageGebietStatus.CalledOut, LageGebietStatus.Ready, LageGebietStatus.Live }) {
            lage.TransitionGebiet(gebiet.Id, status, actorId, now);
        }
        db.Lagen.Add(lage);
        await db.SaveChangesAsync();
        return lage;
    }

    private static Dictionary<string, object?> Bearbeitung(Schritt schritt, Verbindung verbindung,
        params (string Slot, object Value)[] slots) =>
        new() {
            ["schrittId"] = schritt.Id,
            ["nextVerbindungId"] = verbindung.Id,
            ["slotValues"] = slots.Select(s => new Dictionary<string, object?> {
                ["name"] = s.Slot,
                ["value"] = new Dictionary<string, object?> { ["plainValue"] = System.Text.Json.JsonSerializer.SerializeToElement(s.Value) },
            }).ToList(),
        };

    [Theory]
    [InlineData("Production", false)]
    [InlineData("Staging", true)]
    [InlineData("Testing", true)]
    public void Demo_is_only_forbidden_in_Production(string environment, bool allowed) {
        using var scope = Factory.Services.CreateScope();
        var seeder = ActivatorUtilities.CreateInstance<LageHelferSeeder>(
            scope.ServiceProvider, new EnvironmentOptions { Name = environment });

        Assert.Equal(allowed, seeder.IsDemoAllowedInCurrentEnvironment);
    }
}
