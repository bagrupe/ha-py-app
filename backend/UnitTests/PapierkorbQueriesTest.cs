using System.Security.Claims;
using System.Security.Cryptography;
using API.Features;
using API.Features.Aufbewahrung;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Options;
using API.Seeders;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;
using NodaTime.Testing;

namespace IntegrationTests;

[Collection("Api Tests")]
public class PapierkorbQueriesTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private static readonly Guid TestProzessId = new("a04e1e5d-0000-4000-8000-000000000001");
    private static readonly Guid TestVersionId = new("a04e1e5d-0000-4000-8000-000000000002");
    private static readonly Guid TestEndeSchrittId = new("a04e1e5d-0000-4000-8000-000000000003");
    private static readonly Guid AndereOrganisationseinheitId = new("a04e1e5d-0000-4000-8000-000000000099");

    private const string ListeQuery = """
        query Liste {
          geloeschteAntraege(take: 100) {
            totalCount
            items { id loeschgrund endgueltigGeloeschtAm }
          }
        }
        """;

    private const string SucheQuery = """
        query Suche($search: String) {
          geloeschteAntraege(take: 100, search: $search) {
            totalCount
            items { id }
          }
        }
        """;

    private const string SeiteQuery = """
        query Seite($skip: Int, $take: Int) {
          geloeschteAntraege(skip: $skip, take: $take) { items { id } }
        }
        """;

    private const string DetailQuery = """
        query Detail($id: UUID!) {
          geloeschterAntrag(id: $id) { antrag { id loeschgrund } slotWerte { slotName } verlauf { id } }
        }
        """;

    [Fact]
    public async Task Zustaendiger_sieht_geloeschten_aber_nicht_nicht_geloeschten_Antrag() {
        var (geloescht, aktiv, mitarbeiter) = await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);

        var result = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery);

        Assert.Null(result.Errors);
        var ids = ListenIds(result);
        Assert.Contains(geloescht, ids);
        Assert.DoesNotContain(aktiv, ids);
    }

    [Fact]
    public async Task Nicht_zustaendiger_Nutzer_sieht_Antrag_weder_in_Liste_noch_im_Detail() {
        await EnsureAndereOrganisationseinheitExists();
        var (geloescht, _, mitarbeiter) = await ArrangeZweiAntraege(AndereOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);

        var liste = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery);
        Assert.Null(liste.Errors);
        Assert.DoesNotContain(geloescht, ListenIds(liste));

        var detail = await ExecuteGraphqlAsync(mitarbeiter, DetailQuery,
            new Dictionary<string, object?> { ["id"] = geloescht });
        Assert.Null(detail.Errors);
        Assert.Null(detail.Data!["geloeschterAntrag"]);
    }

    [Fact]
    public async Task Ohne_AntragLoeschung_Berechtigung_schlaegt_Liste_fehl() {
        await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        var ohne = await CreateBackofficeUserWithPrincipalAsync([],
            backofficeAntraegeOrganisationseinheitId: KommuneSeeder.AerzenOrganisationseinheitId);

        var result = await ExecuteGraphqlAsync(ohne, ListeQuery);

        Assert.NotNull(result.Errors);
    }

    [Fact]
    public async Task Antrag_mit_abgelaufener_Hard_Delete_Frist_ist_ausgeblendet_Antrag_in_Frist_hat_Fristdatum() {
        await SetzeEinstellungen(hardDeleteAktiv: true, verzoegerungMinuten: 60);
        var (abgelaufen, imFrist, mitarbeiter) = await ArrangeZweiAntraege(
            KommuneSeeder.AerzenOrganisationseinheitId,
            geloeschtAmErster: Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant() - Duration.FromHours(2),
            geloeschtAmZweiter: Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant() - Duration.FromMinutes(5));

        var result = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery);

        Assert.Null(result.Errors);
        var items = ListenItems(result);
        Assert.DoesNotContain(items, i => (string)i["id"]! == abgelaufen.ToString());
        var imFristItem = Assert.Single(items, i => (string)i["id"]! == imFrist.ToString());
        Assert.NotNull(imFristItem["endgueltigGeloeschtAm"]);
    }

    [Fact]
    public async Task Suche_findet_Antragstyp_per_Teilbegriff() {
        var (geloescht, _, mitarbeiter) = await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);

        var result = await ExecuteGraphqlAsync(mitarbeiter, SucheQuery,
            new Dictionary<string, object?> { ["search"] = "PapierkorbQueriesTest" });

        Assert.Null(result.Errors);
        Assert.Contains(geloescht, ListenIds(result));
    }

    [Theory]
    [InlineData("%")]
    [InlineData("_")]
    [InlineData("\\")]
    public async Task Suche_behandelt_LIKE_Platzhalter_als_normalen_Text(string suchbegriff) {
        var (_, _, mitarbeiter) = await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);

        var result = await ExecuteGraphqlAsync(mitarbeiter, SucheQuery,
            new Dictionary<string, object?> { ["search"] = suchbegriff });

        Assert.Null(result.Errors);
        Assert.Empty(ListenItems(result));
    }

    [Fact]
    public async Task Suche_mit_SQL_Fragment_wird_nicht_ausgefuehrt() {
        var (geloescht, _, mitarbeiter) = await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);

        var result = await ExecuteGraphqlAsync(mitarbeiter, SucheQuery,
            new Dictionary<string, object?> { ["search"] = "x'; DROP TABLE \"Ausfuehrungen\"; --" });

        Assert.Null(result.Errors);
        Assert.Empty(ListenItems(result));

        var danach = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery);
        Assert.Null(danach.Errors);
        Assert.Contains(geloescht, ListenIds(danach));
    }

    [Fact]
    public async Task Antrag_aus_Konto_Loeschung_ohne_ausfuehrende_Person_ist_nicht_im_Papierkorb() {
        var (geloescht, _, mitarbeiter) = await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, _) = await CreateBuergerWithPrincipalAsync();
        var ausKontoLoeschung = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var a = await db.Ausfuehrungen.AsTracking().FirstAsync(x => x.Id == ausKontoLoeschung);
            a.GeloeschtAm = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
            a.GeloeschtVonId = null;
            a.Loeschgrund = "Ehrenamtsbank-Konto gelöscht";
            await db.SaveChangesAsync();
        }

        var liste = await ExecuteGraphqlAsync(mitarbeiter, ListeQuery);
        Assert.Null(liste.Errors);
        Assert.Contains(geloescht, ListenIds(liste));
        Assert.DoesNotContain(ausKontoLoeschung, ListenIds(liste));

        var detail = await ExecuteGraphqlAsync(mitarbeiter, DetailQuery,
            new Dictionary<string, object?> { ["id"] = ausKontoLoeschung });
        Assert.Null(detail.Errors);
        Assert.Null(detail.Data!["geloeschterAntrag"]);
    }

    [Fact]
    public async Task Paginierung_ist_bei_gleichem_Loeschzeitpunkt_stabil_ohne_Duplikate() {
        await SetzeEinstellungen(hardDeleteAktiv: false);
        var (erster, zweiter, mitarbeiter) = await ArrangeZweiAntraege(
            KommuneSeeder.AerzenOrganisationseinheitId,
            geloeschtAmErster: Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant(),
            geloeschtAmZweiter: Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant());
        var gleicherZeitpunkt = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
        await MarkiereGeloescht(erster, gleicherZeitpunkt);
        await MarkiereGeloescht(zweiter, gleicherZeitpunkt);

        var gesehen = new List<Guid>();
        for (var skip = 0; skip < 50; skip++) {
            var seite = await ExecuteGraphqlAsync(mitarbeiter, SeiteQuery,
                new Dictionary<string, object?> { ["skip"] = skip, ["take"] = 1 });
            Assert.Null(seite.Errors);
            var ids = ListenIds(seite);
            if (ids.Count == 0) {
                break;
            }

            gesehen.AddRange(ids);
        }

        Assert.Contains(erster, gesehen);
        Assert.Contains(zweiter, gesehen);
        Assert.Equal(gesehen.Count, gesehen.Distinct().Count());
    }

    [Fact]
    public async Task Detail_liefert_Antrag_des_zustaendigen_Nutzers() {
        var (geloescht, _, mitarbeiter) = await ArrangeZweiAntraege(KommuneSeeder.AerzenOrganisationseinheitId);
        await SetzeEinstellungen(hardDeleteAktiv: false);

        var result = await ExecuteGraphqlAsync(mitarbeiter, DetailQuery,
            new Dictionary<string, object?> { ["id"] = geloescht });

        Assert.Null(result.Errors);
        var detail = result.Data!["geloeschterAntrag"] as IReadOnlyDictionary<string, object>;
        var antrag = detail!["antrag"] as IReadOnlyDictionary<string, object>;
        Assert.Equal(geloescht.ToString(), (string)antrag!["id"]);
        Assert.Equal("Testgrund", (string)antrag["loeschgrund"]);
    }

    private async Task<(Guid Geloescht, Guid Aktiv, ClaimsPrincipal Mitarbeiter)> ArrangeZweiAntraege(
        Guid nutzerOrganisationseinheitId, Instant? geloeschtAmErster = null, Instant? geloeschtAmZweiter = null) {
        await testSeeder.EnsureSeedOrganisationseinheitExists();
        var (_, versionId, schrittId) = await EnsureTestProzessVersionUndSchritt();
        var (buerger, _) = await CreateBuergerWithPrincipalAsync();
        var erster = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());
        var zweiter = await SeedAusfuehrung(versionId, schrittId, buerger.Id, MitAerzenZustaendigkeit());

        var jetzt = Factory.Services.GetRequiredService<FakeClock>().GetCurrentInstant();
        if (geloeschtAmZweiter is null) {
            await MarkiereGeloescht(erster, geloeschtAmErster ?? jetzt);
        } else {
            await MarkiereGeloescht(erster, geloeschtAmErster ?? jetzt);
            await MarkiereGeloescht(zweiter, geloeschtAmZweiter.Value);
        }

        var mitarbeiter = await CreateBackofficeUserWithPrincipalAsync(
            [GlobaleFunktionsberechtigung.AntragLoeschung], nutzerOrganisationseinheitId);
        return (erster, zweiter, mitarbeiter);
    }

    private async Task MarkiereGeloescht(Guid ausfuehrungId, Instant geloeschtAm, Guid? geloeschtVonId = null) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var a = await db.Ausfuehrungen.AsTracking().FirstAsync(x => x.Id == ausfuehrungId);
        a.GeloeschtAm = geloeschtAm;
        a.GeloeschtVonId = geloeschtVonId ?? Guid.NewGuid();
        a.Loeschgrund = "Testgrund";
        await db.SaveChangesAsync();
    }

    private async Task SetzeEinstellungen(bool hardDeleteAktiv, int verzoegerungMinuten = 60) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var e = await db.AufbewahrungsEinstellungen.AsTracking()
            .FirstOrDefaultAsync(x => x.Id == AufbewahrungsEinstellungen.SingletonId);
        if (e is null) {
            e = new AufbewahrungsEinstellungen();
            db.AufbewahrungsEinstellungen.Add(e);
        }

        e.HardDeleteAktiv = hardDeleteAktiv;
        e.HardDeleteVerzoegerungMinuten = verzoegerungMinuten;
        await db.SaveChangesAsync();
    }

    private static IEnumerable<IReadOnlyDictionary<string, object>> ListenItems(HotChocolate.Execution.IQueryResult result) =>
        ((IEnumerable<object>)((IReadOnlyDictionary<string, object>)result.Data!["geloeschteAntraege"]!)["items"]!)
        .Cast<IReadOnlyDictionary<string, object>>();

    private static List<Guid> ListenIds(HotChocolate.Execution.IQueryResult result) =>
        ((IEnumerable<IReadOnlyDictionary<string, object>>)ListenItems(result))
        .Select(i => Guid.Parse((string)i["id"]!)).ToList();

    private static Zustaendigkeit MitAerzenZustaendigkeit() => new() {
        Art = ZustaendigkeitArt.Organisationseinheit,
        OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
    };

    private async Task<(Buerger Entity, ClaimsPrincipal Principal)> CreateBuergerWithPrincipalAsync() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        db.Users.Add(buerger);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(buerger.GetToken(jwtOptions).Claims, "jwt");
        return (buerger, new ClaimsPrincipal(identity));
    }

    private async Task<ClaimsPrincipal> CreateBackofficeUserWithPrincipalAsync(
        List<GlobaleFunktionsberechtigung> globaleFunktionsberechtigungen,
        Guid? backofficeAntraegeOrganisationseinheitId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"papierkorb-test-{Guid.NewGuid():N}@test.local",
            Vorname = "Loeschen",
            Nachname = "Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Funktionsberechtigungen = globaleFunktionsberechtigungen,
            Gruppen = [],
            UntereinheitPermissions = [],
        };
        if (backofficeAntraegeOrganisationseinheitId is { } untereinheitId) {
            user.UntereinheitPermissions.Add(new UntereinheitPermissions {
                UntereinheitId = untereinheitId,
                Funktionsberechtigungen = [
                    FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                    FunktionsberechtigungInOrganisationseinheit.Backoffice,
                ],
            });
        }

        var hasher = scope.ServiceProvider.GetRequiredService<IPasswordHasher<User>>();
        TestUserCrypto.InitializeMitarbeiterCrypto(user, "123456", KommuneSeeder.LandkreisHaPy.KeyEncryptionKey,
            hasher);

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();

        var jwtOptions = scope.ServiceProvider.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(user.GetToken(jwtOptions).Claims, "jwt");
        return new ClaimsPrincipal(identity);
    }

    private async Task EnsureAndereOrganisationseinheitExists() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        if (await db.Untereinheit.AnyAsync(u => u.Id == AndereOrganisationseinheitId)) {
            return;
        }

        db.Untereinheit.Add(new Untereinheit {
            Id = AndereOrganisationseinheitId,
            Name = "Andere Organisationseinheit (Test)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            IsGemeinde = true,
            Regionalschluessel = "03252099",
        });
        await db.SaveChangesAsync();
    }

    private async Task<Guid> SeedAusfuehrung(Guid prozessVersionId, Guid schrittId, Guid buergerUserId,
        Zustaendigkeit istZustaendigkeit) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var id = Guid.NewGuid();
        var sharedKey = RandomNumberGenerator.GetBytes(32);
        db.Ausfuehrungen.Add(new Ausfuehrung {
            Id = id,
            ProzessVersionId = prozessVersionId,
            UserId = buergerUserId,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Status = AusfuehrungStatus.BearbeitungDurchBuerger,
            SchrittId = schrittId,
            SharedKeyEncryptedForBuerger =
                Convert.ToBase64String(
                    BuergerSeeder.UnsafeBuergerRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            SharedKeyEncryptedForKommune =
                Convert.ToBase64String(
                    KommuneSeeder.LandkreisHaPy.UnsafeRsa.Encrypt(sharedKey, RSAEncryptionPadding.OaepSHA512)),
            IstZustaendigkeit = istZustaendigkeit,
            Followers = [],
            Bearbeitungen = [],
        });
        await db.SaveChangesAsync();
        return id;
    }

    private async Task<(Guid prozessId, Guid versionId, Guid schrittId)> EnsureTestProzessVersionUndSchritt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        if (await db.ProzessVersionen.AnyAsync(pv => pv.Id == TestVersionId)) {
            return (TestProzessId, TestVersionId, TestEndeSchrittId);
        }

        var instant = Instant.FromUtc(2020, 1, 1, 0, 0, 0);
        var prozess = new Prozess {
            Id = TestProzessId,
            Name = "PapierkorbQueriesTest (minimal)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };
        var ende = new EndeSchritt {
            Id = TestEndeSchrittId,
            Titel = "Ende",
            NodePosition = new NodePosition { X = 0, Y = 0 },
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
        };
        var version = new ProzessVersion {
            Id = TestVersionId,
            Prozess = prozess,
            CreatedAt = instant,
            PublishedAt = instant,
            Beschreibungstext = "test",
            Schritte = [ende],
            StartId = null,
        };
        db.ProzessVersionen.Add(version);
        await db.SaveChangesAsync();

        version.StartId = TestEndeSchrittId;
        await db.SaveChangesAsync();
        return (TestProzessId, TestVersionId, TestEndeSchrittId);
    }
}
