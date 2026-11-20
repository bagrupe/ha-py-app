using System.Text.Json.Nodes;
using API.Features;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Lage;
using API.Options;
using API.Seeders.LageHelfer;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

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

    private async Task RunSeeder(EnvironmentOptions? environment = null) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var seederOptions = new DataSeederOptions {
            LageHelferEnabled = true,
            LageHelferSeedPath = ExampleSeedPath,
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
