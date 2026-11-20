using API.Features;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Features.Untereinheit;
using API.Infrastructure;
using API.Seeders;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

/// <summary>Integration tests for the Mängelmelder-Kategoriebaum mutations/queries through real GraphQL against a real (test) database.</summary>
[Collection("Api Tests")]
public class KategorieMutationsTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string PlainPassword = "123456";

    private const string MutationKategorieCreate = """
        mutation KategorieCreate($input: KategorieCreateInput!) {
          kategorieCreate(input: $input) {
            kategorie { id name parentId untereinheitId istWurzel }
            errors { __typename }
          }
        }
        """;

    private const string MutationKategorieZustaendigkeitSetzen = """
        mutation KategorieZustaendigkeitSetzen($input: KategorieZustaendigkeitSetzenInput!) {
          kategorieZustaendigkeitSetzen(input: $input) {
            kategorie { id }
            errors { __typename }
          }
        }
        """;

    private const string MutationKategorieRename = """
        mutation KategorieRename($input: KategorieRenameInput!) {
          kategorieRename(input: $input) {
            kategorie { id name }
            errors { __typename }
          }
        }
        """;

    private const string QueryKategorieBaum = """
        query KategorieBaum($untereinheitId: UUID!) {
          kategorieBaum(untereinheitId: $untereinheitId) { id name parentId untereinheitId istWurzel }
        }
        """;

    [Fact]
    public async Task Superadmin_can_create_a_shared_top_level_category() {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var name = $"Straßen-Test-{Guid.NewGuid()}";

        var result = await ExecuteQuery(superAdmin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = null,
            ["untereinheitId"] = null,
            ["name"] = name,
        });

        DenyMutationError(result, "kategorieCreate");
    }

    [Fact]
    public async Task OE_scoped_admin_cannot_create_a_shared_category_even_with_full_zustaendigkeitsverwaltung_permission() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var untereinheitId = KommuneSeeder.AerzenOrganisationseinheitId;
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);

        var admin = await GetUserToken(email, PlainPassword);
        var result = await ExecuteQuery(admin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = null,
            ["untereinheitId"] = null,
            ["name"] = $"Sollte-verboten-sein-{Guid.NewGuid()}",
        });

        AssertMutationError(result, "kategorieCreate", "NotAllowedError");
    }

    [Fact]
    public async Task OE_scoped_admin_can_create_their_own_category_under_a_shared_one() {
        var untereinheitId = await GeoZugeordneteTestUntereinheitAnlegen();
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);

        var geteilteId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: $"Straßen-{Guid.NewGuid()}");

        var admin = await GetUserToken(email, PlainPassword);
        var result = await ExecuteQuery(admin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = geteilteId,
            ["untereinheitId"] = untereinheitId,
            ["name"] = $"Beleuchtung-{Guid.NewGuid()}",
        });

        DenyMutationError(result, "kategorieCreate");
    }

    [Fact]
    public async Task Own_category_cannot_be_created_under_another_untereinheits_own_category() {
        var eigeneUntereinheitId = await GeoZugeordneteTestUntereinheitAnlegen("Aerzen");
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, eigeneUntereinheitId);

        var andereUntereinheitId = await GeoZugeordneteTestUntereinheitAnlegen("Hameln");
        var fremdeEigeneId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: andereUntereinheitId, name: $"Fremde-Kategorie-{Guid.NewGuid()}");

        var admin = await GetUserToken(email, PlainPassword);
        var result = await ExecuteQuery(admin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = fremdeEigeneId,
            ["untereinheitId"] = eigeneUntereinheitId,
            ["name"] = $"Sollte-verboten-sein-{Guid.NewGuid()}",
        });

        AssertMutationError(result, "kategorieCreate", "NotAllowedError");

        // Aufräumen, sonst scheitert der Sync-Export jedes späteren Tests an dieser Geofläche-losen Fixture.
        await using (var cleanupScope = Factory.Services.CreateAsyncScope()) {
            var cleanupDb = cleanupScope.ServiceProvider.GetRequiredService<DomainContext>();
            cleanupDb.Kategorien.RemoveRange(await cleanupDb.Kategorien.AsTracking().Where(k => k.Id == fremdeEigeneId).ToListAsync());
            cleanupDb.Untereinheit.RemoveRange(await cleanupDb.Untereinheit.AsTracking().Where(u => u.Id == andereUntereinheitId).ToListAsync());
            await cleanupDb.SaveChangesAsync();
        }
    }

    [Fact]
    public async Task Creating_two_siblings_with_the_same_name_under_the_same_parent_is_rejected() {
        var name = $"Duplikat-Test-{Guid.NewGuid()}";
        await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: name);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteQuery(superAdmin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = null,
            ["untereinheitId"] = null,
            ["name"] = name,
        });

        AssertMutationError(result, "kategorieCreate", "NotAllowedError");
    }

    [Fact]
    public async Task Kategoriebaum_query_lazily_creates_exactly_one_wurzel_knoten_per_untereinheit() {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var untereinheitId = KommuneSeeder.AerzenOrganisationseinheitId;
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var erstesResult = await ExecuteGraphqlAsync(admin, QueryKategorieBaum, new Dictionary<string, object?> { ["untereinheitId"] = untereinheitId });
        Assert.Null(erstesResult.Errors);
        var ersteWurzelAnzahl = KnotenListe(erstesResult).Count(k => (bool)k["istWurzel"]!);
        Assert.Equal(1, ersteWurzelAnzahl);

        var zweitesResult = await ExecuteGraphqlAsync(admin, QueryKategorieBaum, new Dictionary<string, object?> { ["untereinheitId"] = untereinheitId });
        var zweiteWurzelAnzahl = KnotenListe(zweitesResult).Count(k => (bool)k["istWurzel"]!);
        Assert.Equal(1, zweiteWurzelAnzahl);
    }

    [Fact]
    public async Task Erbt_true_clears_a_previously_set_own_ziel() {
        var untereinheitId = await GeoZugeordneteTestUntereinheitAnlegen();
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var gruppeId = await GruppeAnlegenFuerUntereinheit(untereinheitId);
        var eigeneKategorieId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: untereinheitId, name: $"Eigene-{Guid.NewGuid()}");

        var setzenResult = await ExecuteQuery(admin, MutationKategorieZustaendigkeitSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = eigeneKategorieId,
            ["erbt"] = false,
            ["art"] = ZustaendigkeitArt.Organisationseinheit,
            ["mitarbeiterGruppeId"] = gruppeId,
            ["dienstleisterId"] = null,
        });
        DenyMutationError(setzenResult, "kategorieZustaendigkeitSetzen");

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var kategorie = await db.Kategorien.FirstAsync(k => k.Id == eigeneKategorieId);
            Assert.NotNull(kategorie.Ziel);
        }

        var erbenResult = await ExecuteQuery(admin, MutationKategorieZustaendigkeitSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = eigeneKategorieId,
            ["erbt"] = true,
            ["art"] = ZustaendigkeitArt.Organisationseinheit,
            ["mitarbeiterGruppeId"] = null,
            ["dienstleisterId"] = null,
        });
        DenyMutationError(erbenResult, "kategorieZustaendigkeitSetzen");

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var kategorie = await db.Kategorien.FirstAsync(k => k.Id == eigeneKategorieId);
            Assert.Null(kategorie.Ziel);
        }
    }

    [Fact]
    public async Task Renaming_a_shared_category_also_renames_its_existing_twin_so_its_zustaendigkeit_still_resolves() {
        var untereinheitId = await GeoZugeordneteTestUntereinheitAnlegen();
        var alterName = $"Spielplatz-{Guid.NewGuid()}";
        var neuerName = $"Spielplatz-Neu-{Guid.NewGuid()}";

        var geteilteId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: alterName);
        var zwillingId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: untereinheitId, name: alterName);

        var gruppeId = await GruppeAnlegenFuerUntereinheit(untereinheitId);
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var setzenResult = await ExecuteQuery(admin, MutationKategorieZustaendigkeitSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = zwillingId,
            ["erbt"] = false,
            ["art"] = ZustaendigkeitArt.Organisationseinheit,
            ["mitarbeiterGruppeId"] = gruppeId,
            ["dienstleisterId"] = null,
        });
        DenyMutationError(setzenResult, "kategorieZustaendigkeitSetzen");

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var renameResult = await ExecuteQuery(superAdmin, MutationKategorieRename, new Dictionary<string, object?> {
            ["id"] = geteilteId,
            ["name"] = neuerName,
        });
        DenyMutationError(renameResult, "kategorieRename");

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var zwilling = await db.Kategorien.AsNoTracking().FirstAsync(k => k.Id == zwillingId);
        Assert.Equal(neuerName, zwilling.Name); // kein verwaister Zwilling mit dem alten Namen

        var alle = await db.Kategorien.AsNoTracking().Where(k => k.KommuneId == KommuneSeeder.LandkreisHaPy.Id).ToListAsync();
        var geteilt = alle.Single(k => k.Id == geteilteId);
        var ziel = KategorieOrtZustaendigkeitSchritt.FindeVererbteZustaendigkeit(alle, geteilt, untereinheitId);

        Assert.NotNull(ziel);
        Assert.Equal(gruppeId, ziel!.MitarbeiterGruppeId);
    }

    [Fact]
    public async Task Ausgeblendete_kategorien_query_lists_exactly_what_ausblendungSetzen_hides_for_this_untereinheit() {
        // Eigener Name "Aerzen" statt der geteilten Fixture (die heißt "Aerzen (Test)", passt nicht zur Geo-Zuordnung).
        var untereinheitId = Guid.NewGuid();
        await using (var seedScope = Factory.Services.CreateAsyncScope()) {
            var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();
            seedDb.Untereinheit.Add(new Untereinheit { Id = untereinheitId, Name = "Aerzen", KommuneId = KommuneSeeder.LandkreisHaPy.Id, IsGemeinde = true });
            await seedDb.SaveChangesAsync();
        }

        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var gruenflaechenId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: $"Grünflächen-{Guid.NewGuid()}");
        var strassenId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: $"Straßen-{Guid.NewGuid()}");

        var vorAusblendung = await ExecuteGraphqlAsync(admin, QueryAusgeblendeteKategorien, new Dictionary<string, object?> { ["untereinheitId"] = untereinheitId });
        Assert.Null(vorAusblendung.Errors);
        Assert.Empty((IEnumerable<object>)vorAusblendung.Data!["ausgeblendeteKategorien"]!);

        var ausblendenResult = await ExecuteQuery(admin, MutationKategorieAusblendungSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = gruenflaechenId,
            ["untereinheitId"] = untereinheitId,
        });
        DenyMutationError(ausblendenResult, "kategorieAusblendungSetzen");

        var nachAusblendung = await ExecuteGraphqlAsync(admin, QueryAusgeblendeteKategorien, new Dictionary<string, object?> { ["untereinheitId"] = untereinheitId });
        var ausgeblendet = ((IEnumerable<object>)nachAusblendung.Data!["ausgeblendeteKategorien"]!)
            .Cast<IReadOnlyDictionary<string, object?>>().ToList();
        Assert.Single(ausgeblendet);
        Assert.Equal(gruenflaechenId.ToString(), ausgeblendet[0]["id"]);
        Assert.DoesNotContain(ausgeblendet, k => k["id"]!.Equals(strassenId.ToString()));
    }

    [Fact]
    public async Task KategorieLoeschVorschau_requires_permission_for_the_categorys_own_untereinheit() {
        var eigeneUntereinheitId = await GeoZugeordneteTestUntereinheitAnlegen("Aerzen");
        var eigeneKategorieId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: eigeneUntereinheitId, name: $"Fremde-Kategorie-{Guid.NewGuid()}");

        var andereUntereinheitId = await GeoZugeordneteTestUntereinheitAnlegen("Hameln");
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, andereUntereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var fremdesResult = await ExecuteGraphqlAsync(admin, QueryKategorieLoeschVorschau, new Dictionary<string, object?> { ["id"] = eigeneKategorieId });
        Assert.NotNull(fremdesResult.Errors);

        var eigenesResult = await ExecuteGraphqlAsync(admin, QueryKategorieLoeschVorschau,
            new Dictionary<string, object?> { ["id"] = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: andereUntereinheitId, name: $"Eigene-Kategorie-{Guid.NewGuid()}") });
        Assert.Null(eigenesResult.Errors);
    }

    [Fact]
    public async Task KategorieLoeschVorschau_for_a_shared_category_requires_superadmin() {
        var geteilteId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: $"Straßen-{Guid.NewGuid()}");

        var untereinheitId = await GeoZugeordneteTestUntereinheitAnlegen();
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var alsOeAdmin = await ExecuteGraphqlAsync(admin, QueryKategorieLoeschVorschau, new Dictionary<string, object?> { ["id"] = geteilteId });
        Assert.NotNull(alsOeAdmin.Errors);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var alsSuperadmin = await ExecuteGraphqlAsync(superAdmin, QueryKategorieLoeschVorschau, new Dictionary<string, object?> { ["id"] = geteilteId });
        Assert.Null(alsSuperadmin.Errors);
    }

    [Fact]
    public async Task KategorieLoeschVorschau_breaks_down_own_descendants_of_a_shared_category_by_untereinheit() {
        var geteilteId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: $"Straßen-{Guid.NewGuid()}");

        var aerzenId = await GeoZugeordneteTestUntereinheitAnlegen("Aerzen");
        var hamelnId = await GeoZugeordneteTestUntereinheitAnlegen("Hameln");

        var aerzenKindId = await KategorieAnlegenAlsSuperadmin(parentId: geteilteId, untereinheitId: aerzenId, name: $"Aerzen-Kind-{Guid.NewGuid()}");
        await KategorieAnlegenAlsSuperadmin(parentId: aerzenKindId, untereinheitId: aerzenId, name: $"Aerzen-Enkel-{Guid.NewGuid()}");
        await KategorieAnlegenAlsSuperadmin(parentId: geteilteId, untereinheitId: hamelnId, name: $"Hameln-Kind-{Guid.NewGuid()}");

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteGraphqlAsync(superAdmin, QueryKategorieLoeschVorschau, new Dictionary<string, object?> { ["id"] = geteilteId });
        Assert.Null(result.Errors);

        var vorschau = (IReadOnlyDictionary<string, object?>)result.Data!["kategorieLoeschVorschau"]!;
        Assert.Equal(3, vorschau["anzahlUnterkategorien"]);
        Assert.True((bool)vorschau["istGeteilt"]!);

        var betroffene = ((IEnumerable<object>)vorschau["betroffeneUntereinheiten"]!)
            .Cast<IReadOnlyDictionary<string, object?>>()
            .ToDictionary(b => (string)b["untereinheitName"]!, b => (int)b["anzahlEigeneUnterkategorien"]!);
        Assert.Equal(new Dictionary<string, int> { ["Aerzen"] = 2, ["Hameln"] = 1 }, betroffene);
    }

    [Fact]
    public async Task KategorieLoeschVorschau_has_no_breakdown_for_an_untereinheit_owned_category() {
        var untereinheitId = await GeoZugeordneteTestUntereinheitAnlegen();
        var eigeneId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: untereinheitId, name: $"Eigene-{Guid.NewGuid()}");

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteGraphqlAsync(superAdmin, QueryKategorieLoeschVorschau, new Dictionary<string, object?> { ["id"] = eigeneId });
        Assert.Null(result.Errors);

        var vorschau = (IReadOnlyDictionary<string, object?>)result.Data!["kategorieLoeschVorschau"]!;
        Assert.False((bool)vorschau["istGeteilt"]!);
        Assert.Empty((IEnumerable<object>)vorschau["betroffeneUntereinheiten"]!);
    }

    [Fact]
    public async Task KategorieCreate_rolls_back_the_new_category_if_the_sync_export_fails() {
        var kommuneId = KommuneSeeder.LandkreisHaPy.Id;
        var name = $"Rollback-Test-{Guid.NewGuid()}";
        var kollidierendeProzessIds = new[] { Guid.NewGuid(), Guid.NewGuid() };

        await using (var seedScope = Factory.Services.CreateAsyncScope()) {
            var seedDb = seedScope.ServiceProvider.GetRequiredService<DomainContext>();
            var tag = await seedDb.ProzessTags.AsTracking().Include(t => t.Prozesse)
                .FirstOrDefaultAsync(t => t.Tag == KategorieSyncExport.ProzessTagName);
            if (tag is null) {
                tag = new ProzessTag { Id = Guid.NewGuid(), Tag = KategorieSyncExport.ProzessTagName };
                seedDb.ProzessTags.Add(tag);
            }
            foreach (var id in kollidierendeProzessIds) {
                var kollidierenderProzess = new Prozess { Id = id, Name = $"Kollidierender Mängelmelder (Test) {id}", KommuneId = kommuneId };
                tag.Prozesse.Add(kollidierenderProzess);
                seedDb.Prozesse.Add(kollidierenderProzess);
            }
            await seedDb.SaveChangesAsync();
        }

        try {
            var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
            var result = await ExecuteGraphqlAsync(superAdmin, MutationKategorieCreate, new Dictionary<string, object?> {
                ["parentId"] = null,
                ["untereinheitId"] = null,
                ["name"] = name,
            });

            Assert.NotNull(result.Errors);

            await using var scope = Factory.Services.CreateAsyncScope();
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            Assert.False(await db.Kategorien.AnyAsync(k => k.Name == name));
        } finally {
            await using var cleanupScope = Factory.Services.CreateAsyncScope();
            var cleanupDb = cleanupScope.ServiceProvider.GetRequiredService<DomainContext>();
            cleanupDb.Prozesse.RemoveRange(await cleanupDb.Prozesse.AsTracking().Where(p => kollidierendeProzessIds.Contains(p.Id)).ToListAsync());
            await cleanupDb.SaveChangesAsync();
        }
    }

    [Fact]
    public async Task KategorieBaum_hides_the_own_zwilling_of_a_shared_category_that_is_hidden_for_this_untereinheit() {
        var untereinheitId = await GeoZugeordneteTestUntereinheitAnlegen();
        var email = $"kategorie-admin-{Guid.NewGuid()}@example.com";
        await SeedAdminMitKategorieBerechtigung(email, untereinheitId);
        var admin = await GetUserToken(email, PlainPassword);

        var name = $"Straßen-{Guid.NewGuid()}";
        var geteilteId = await KategorieAnlegenAlsSuperadmin(parentId: null, untereinheitId: null, name: name);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var zwillingResult = await ExecuteQuery(admin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = null,
            ["untereinheitId"] = untereinheitId,
            ["name"] = name,
        });
        DenyMutationError(zwillingResult, "kategorieCreate");

        var vorAusblendung = await ExecuteGraphqlAsync(admin, QueryKategorieBaum, new Dictionary<string, object?> { ["untereinheitId"] = untereinheitId });
        Assert.Equal(2, KnotenListe(vorAusblendung).Count(k => (string)k["name"]! == name));

        var ausblendenResult = await ExecuteQuery(superAdmin, MutationKategorieAusblendungSetzen, new Dictionary<string, object?> {
            ["kategorieId"] = geteilteId,
            ["untereinheitId"] = untereinheitId,
        });
        DenyMutationError(ausblendenResult, "kategorieAusblendungSetzen");

        var nachAusblendung = await ExecuteGraphqlAsync(admin, QueryKategorieBaum, new Dictionary<string, object?> { ["untereinheitId"] = untereinheitId });
        Assert.DoesNotContain(KnotenListe(nachAusblendung), k => (string)k["name"]! == name);
    }

    private const string QueryKategorieLoeschVorschau = """
        query KategorieLoeschVorschau($id: UUID!) {
          kategorieLoeschVorschau(id: $id) {
            anzahlUnterkategorien
            istGeteilt
            betroffeneUntereinheiten { untereinheitName anzahlEigeneUnterkategorien }
          }
        }
        """;

    private const string MutationKategorieAusblendungSetzen = """
        mutation KategorieAusblendungSetzen($input: KategorieAusblendungSetzenInput!) {
          kategorieAusblendungSetzen(input: $input) {
            success
            errors { __typename }
          }
        }
        """;

    private const string QueryAusgeblendeteKategorien = """
        query AusgeblendeteKategorien($untereinheitId: UUID!) {
          ausgeblendeteKategorien(untereinheitId: $untereinheitId) { id name }
        }
        """;

    private static List<IReadOnlyDictionary<string, object?>> KnotenListe(IQueryResult result) =>
        ((IEnumerable<object>)result.Data!["kategorieBaum"]!).Cast<IReadOnlyDictionary<string, object?>>().ToList();

    /// <summary>Legt eine eigene Untereinheit mit garantiert korrektem Namen an (die geteilte Fixture heißt je nach Testreihenfolge "Aerzen" oder "Aerzen (Test)").</summary>
    private async Task<Guid> GeoZugeordneteTestUntereinheitAnlegen(string name = "Aerzen") {
        var id = Guid.NewGuid();
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        db.Untereinheit.Add(new Untereinheit { Id = id, Name = name, KommuneId = KommuneSeeder.LandkreisHaPy.Id, IsGemeinde = true });
        await db.SaveChangesAsync();
        return id;
    }

    private async Task<Guid> KategorieAnlegenAlsSuperadmin(Guid? parentId, Guid? untereinheitId, string name) {
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var result = await ExecuteQuery(superAdmin, MutationKategorieCreate, new Dictionary<string, object?> {
            ["parentId"] = parentId,
            ["untereinheitId"] = untereinheitId,
            ["name"] = name,
        });
        Assert.Null(result.Errors);
        var payload = (IReadOnlyDictionary<string, object?>)result.Data!["kategorieCreate"]!;
        var kategorie = (IReadOnlyDictionary<string, object?>)payload["kategorie"]!;
        return Guid.Parse((string)kategorie["id"]!);
    }

    private async Task<Guid> GruppeAnlegenFuerUntereinheit(Guid untereinheitId) {
        var gruppeId = Guid.NewGuid();
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var ordinal = await db.MitarbeiterGruppen.CountAsync(g => g.KommuneId == KommuneSeeder.LandkreisHaPy.Id);
        var untereinheit = await db.Untereinheit.AsTracking().FirstAsync(u => u.Id == untereinheitId);
        db.MitarbeiterGruppen.Add(new MitarbeiterGruppe {
            Id = gruppeId,
            Name = "Bauhof (Kategoriebaum-Test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Ordinal = ordinal,
            Organisationseinheiten = [untereinheit],
        });
        await db.SaveChangesAsync();
        return gruppeId;
    }

    private async Task SeedAdminMitKategorieBerechtigung(string email, Guid untereinheitId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = email,
            Vorname = "Kategoriebaum",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Admin,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        TestUserCrypto.InitializeMitarbeiterCrypto(user, PlainPassword, KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
        user.UntereinheitPermissions.Add(new UntereinheitPermissions {
            UntereinheitId = untereinheitId,
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
                FunktionsberechtigungInOrganisationseinheit.MaengelmelderZustaendigkeitsverwaltung,
            ],
        });
        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
    }
}
