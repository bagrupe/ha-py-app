using System.Security.Claims;
using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Auth.Mutations;
using API.Features.Dienstleistungen;
using API.Features.Expressions;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.PushNotifications;
using API.Features.Untereinheit;
using API.Options;
using API.Seeders;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using NodaTime;

namespace IntegrationTests;

/// <summary>
/// End-to-end-Prüfung des Backoffice-Streams: die Mutationen persistieren Lebenszyklus-Ereignisse
/// (<see cref="VerlaufsEintrag"/>), und das Feld <c>verlauf</c> liefert genau diese persistierten Ereignisse
/// wieder aus. Der bürgerseitige Stream <c>historie</c> (rekonstruierte Edge-Labels) ist davon getrennt
/// (vgl. <see cref="AusfuehrungPushNotificationsTest"/>).
/// </summary>
[Collection("Api Tests")]
public class VorgangsverlaufTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private const string AusfuehrungErstellenMutation =
        """
        mutation AusfuehrungErstellen($input: AusfuehrungCreateInput!) {
          ausfuehrungCreate(input: $input) {
            ausfuehrungResult { ausfuehrung { id } shouldContinue }
          }
        }
        """;

    private const string AusfuehrungUpdateZugewiesenePersonMutation =
        """
        mutation AusfuehrungUpdateZugewiesenePerson($ausfuehrungId: UUID!, $userId: UUID!) {
          ausfuehrungUpdateZugewiesenePerson(input: { ausfuehrungId: $ausfuehrungId, userId: $userId }) {
            ausfuehrung { id }
          }
        }
        """;

    private const string AusfuehrungContinueMutation =
        """
        mutation AusfuehrungContinue($input: AusfuehrungContinueInput!) {
          ausfuehrungContinue(input: $input) {
            ausfuehrungResult { ausfuehrung { id } }
          }
        }
        """;

    private const string AusfuehrungWeiterleitenMutation =
        """
        mutation AusfuehrungWeiterleiten($ausfuehrungId: UUID!, $empfaengerId: UUID!) {
          ausfuehrungWeiterleiten(input: {
            ausfuehrungId: $ausfuehrungId
            weiterleitungEmpfaenger: INTERN
            empfaengerId: $empfaengerId
          }) {
            ausfuehrung { id }
            errors { ... on Error { message } }
          }
        }
        """;

    private const string AusfuehrungWeiterleitenExternMutation =
        """
        mutation AusfuehrungWeiterleitenExtern($ausfuehrungId: UUID!, $empfaengerEmail: String!, $weiterleitungArt: WeiterleitungArt!, $nachricht: String) {
          ausfuehrungWeiterleiten(input: {
            ausfuehrungId: $ausfuehrungId
            empfaengerEmail: $empfaengerEmail
            weiterleitungEmpfaenger: EXTERN
            weiterleitungArt: $weiterleitungArt
            nachricht: $nachricht
          }) {
            ausfuehrung { id }
            errors { __typename ... on Error { message } }
          }
        }
        """;

    private const string TestUserPassword = "123456";

    private const string ManuellAbgeschlossenText =
        "Der Prozess wurde manuell abgeschlossen. Es werden keine weiteren Statusmeldungen folgen.";

    [Fact]
    public async Task Verlauf_IstFuerBuergerNichtZugaenglich() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var (_, prozessVersionId, _, _) = await CreateProzess(db);
        var (_, buergerPrincipal) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buergerPrincipal);

        var result = await ExecuteGraphqlAsync(buergerPrincipal,
            """
            query AntragVerlauf($ausfuehrungId: UUID!) {
              ausfuehrung(id: $ausfuehrungId) {
                verlauf { id }
              }
            }
            """,
            new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId });

        Assert.NotNull(result.Errors);
        var error = Assert.Single(result.Errors);
        Assert.Equal("NOT_ALLOWED", error.Code);
    }

    [Fact]
    public async Task AntragEingang_WirdInVerlaufProtokolliert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (prozessId, prozessVersionId, _, _) = await CreateProzess(db);
        var (_, buergerPrincipal) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);

        await CreateAusfuehrung(prozessVersionId, buergerPrincipal);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var verlauf = await LadeVerlauf(superAdmin, prozessId);

        Assert.Contains(verlauf, h => h.StatusAenderung == "Antrag eingegangen");
    }

    [Fact]
    public async Task Uebernahme_WirdMitBenutzernameInVerlaufProtokolliert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();

        var (prozessId, prozessVersionId, _, _) = await CreateProzess(db);
        var (_, buergerPrincipal) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);

        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buergerPrincipal);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);

        var uebernahme = await ExecuteGraphqlAsync(superAdmin, AusfuehrungUpdateZugewiesenePersonMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["userId"] = superAdminEntity.Id,
            });
        Assert.Null(uebernahme.Errors);

        var verlauf = await LadeVerlauf(superAdmin, prozessId);

        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Vorgang übernommen");
        var erwarteterName = VorgangsverlaufService.NameVon(superAdminEntity);
        Assert.Equal($"Vorgang wurde von {erwarteterName} übernommen", eintrag.StatusAenderungBeschreibung);
        Assert.Equal(erwarteterName, eintrag.Benutzer);
    }

    [Fact]
    public async Task VollstaendigerDurchlauf_TrenntPersistiertenVerlaufVonRekonstruierterHistorie() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.PersoenlicheDaten.Id, fixture.PersoenlicheDatenNachKontakt.Id,
            ("name", "Max Mustermann"), ("geburtsdatum", "1990-01-01"));
        await WalkStep(buerger, ausfuehrungId, fixture.Kontakt.Id, fixture.KontaktNachPruefung.Id,
            ("email", "max@example.com"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);

        await WalkStep(superAdmin, ausfuehrungId, fixture.Pruefung.Id, fixture.PruefungNachEnde.Id,
            ("entscheidung", "Genehmigt"));

        // Backoffice: nur persistierte Lebenszyklus-Ereignisse (Stream P), keine free-text Edge-Labels.
        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        Assert.Equal(
            new[] {
                "Antrag eingegangen", "Weiterleitung an Organisationseinheit", "Vorgang übernommen",
                "Vorgang abgeschlossen",
            },
            verlauf.Select(h => h.StatusAenderung));
        Assert.DoesNotContain(verlauf, h => string.IsNullOrWhiteSpace(h.StatusAenderung));

        // Bürger: nur rekonstruierte Edge-Labels (Stream E), keine persistierten internen Ereignisse.
        var historie = await LadeHistorie(superAdmin, fixture.ProzessId);
        Assert.Equal(new[] { "Antrag in Prüfung", "Bescheid erstellt" }, historie.Select(h => h.StatusAenderung));
    }

    [Fact]
    public async Task SubmitEdgeMitEingangsLabel_LiefertHistorieUndVerlaufJeGenauEinmalEingang() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        // QA-Reproduktion (#246): eine Absenden-Kante, deren StatusAenderung exakt "Antrag eingegangen" lautet,
        // kollidierte im alten gemergten Resolver mit dem persistierten Eingang → doppelter Eintrag.
        var (prozessId, prozessVersionId, startSchrittId, verbindungId) =
            await CreateProzess(db, submitStatusAenderung: "Antrag eingegangen");
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, startSchrittId, verbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var historie = await LadeHistorie(superAdmin, prozessId);
        Assert.Single(historie, h => h.StatusAenderung == "Antrag eingegangen");

        var verlauf = await LadeVerlauf(superAdmin, prozessId);
        Assert.Single(verlauf, h => h.StatusAenderung == "Antrag eingegangen");
    }

    [Fact]
    public async Task Verlauf_OhnePersistierteEintraege_IstLeerUndWirdNichtRekonstruiert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.PersoenlicheDaten.Id, fixture.PersoenlicheDatenNachKontakt.Id,
            ("name", "Max Mustermann"), ("geburtsdatum", "1990-01-01"));
        await WalkStep(buerger, ausfuehrungId, fixture.Kontakt.Id, fixture.KontaktNachPruefung.Id,
            ("email", "max@example.com"));

        // Altbestand vor !235 simulieren: keine persistierten Verlaufseinträge.
        var persistierte = await db.VerlaufsEintraege.AsTracking()
            .Where(v => v.AusfuehrungId == ausfuehrungId).ToListAsync();
        db.VerlaufsEintraege.RemoveRange(persistierte);
        await db.SaveChangesAsync();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        // verlauf = Stream P only: keine persistierten Zeilen -> leer, KEINE Rekonstruktion.
        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        Assert.Empty(verlauf);

        // historie (Stream E) bleibt rekonstruiert -> Edge-Label ist weiterhin sichtbar.
        var historie = await LadeHistorie(superAdmin, fixture.ProzessId);
        Assert.Equal(new[] { "Antrag in Prüfung" }, historie.Select(h => h.StatusAenderung));
    }

    [Fact]
    public async Task KonfigurierteStatusAenderung_WirdRekonstruiertNichtDoppeltPersistiert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.PersoenlicheDaten.Id, fixture.PersoenlicheDatenNachKontakt.Id,
            ("name", "Max Mustermann"), ("geburtsdatum", "1990-01-01"));
        await WalkStep(buerger, ausfuehrungId, fixture.Kontakt.Id, fixture.KontaktNachPruefung.Id,
            ("email", "max@example.com"));

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .OrderBy(v => v.CreatedAt)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(new[] { VerlaufsEreignisArt.Eingang, VerlaufsEreignisArt.WeiterleitungOrganisationseinheit },
            persistierteArten);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var historie = await LadeHistorie(superAdmin, fixture.ProzessId);
        Assert.Single(historie, h => h.StatusAenderung == "Antrag in Prüfung");
    }

    [Fact]
    public async Task StilleVerbindung_PersistiertNurEingang_HistorieBleibtLeer() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.PersoenlicheDaten.Id, fixture.PersoenlicheDatenNachKontakt.Id,
            ("name", "Max Mustermann"), ("geburtsdatum", "1990-01-01"));

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(new[] { VerlaufsEreignisArt.Eingang }, persistierteArten);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        Assert.Equal(new[] { "Antrag eingegangen" }, verlauf.Select(h => h.StatusAenderung));

        // Stille Kante (StatusAenderung = null) erzeugt keinen Edge-Eintrag -> historie leer.
        var historie = await LadeHistorie(superAdmin, fixture.ProzessId);
        Assert.Empty(historie);
    }

    [Fact]
    public async Task StillerSchrittZumEndeSchritt_ProtokolliertAbschluss() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var (prozessId, prozessVersionId, startSchrittId, verbindungId) = await CreateProzess(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, startSchrittId, verbindungId, ("foo", "bar"));

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .OrderBy(v => v.CreatedAt)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(new[] { VerlaufsEreignisArt.Eingang, VerlaufsEreignisArt.Abschluss }, persistierteArten);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var verlauf = await LadeVerlauf(superAdmin, prozessId);

        Assert.Equal(new[] { "Antrag eingegangen", "Vorgang abgeschlossen" },
            verlauf.Select(h => h.StatusAenderung));
        var abschluss = Assert.Single(verlauf, h => h.StatusAenderung == "Vorgang abgeschlossen");
        Assert.Null(abschluss.Benutzer);
    }

    [Fact]
    public async Task StillerSchrittMitWechselZurOrganisationseinheit_ProtokolliertWeiterleitung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var (prozessId, prozessVersionId, startSchrittId, verbindungId) = await CreateProzessMitStillemWechsel(db,
            new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            });
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, startSchrittId, verbindungId, ("foo", "bar"));

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .OrderBy(v => v.CreatedAt)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(new[] { VerlaufsEreignisArt.Eingang, VerlaufsEreignisArt.WeiterleitungOrganisationseinheit },
            persistierteArten);

        var untereinheitName = await db.Untereinheit
            .Where(u => u.Id == KommuneSeeder.AerzenOrganisationseinheitId)
            .Select(u => u.Name)
            .SingleAsync();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var verlauf = await LadeVerlauf(superAdmin, prozessId);

        Assert.Equal(new[] { "Antrag eingegangen", "Weiterleitung an Organisationseinheit" },
            verlauf.Select(h => h.StatusAenderung));
        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Weiterleitung an Organisationseinheit");
        Assert.Equal($"Vorgang an Organisationseinheit {untereinheitName} übergeben",
            eintrag.StatusAenderungBeschreibung);
        Assert.Equal(untereinheitName, eintrag.Ziel);
        Assert.Null(eintrag.Benutzer);
    }

    [Fact]
    public async Task VerbindungMitLeererStatusAenderung_ErzeugtKeinenPhantomEintrag() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var (prozessId, prozessVersionId, startSchrittId, verbindungId) = await CreateProzessMitStillemWechsel(db,
            new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            }, statusAenderung: "");
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, startSchrittId, verbindungId, ("foo", "bar"));

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .OrderBy(v => v.CreatedAt)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(new[] { VerlaufsEreignisArt.Eingang, VerlaufsEreignisArt.WeiterleitungOrganisationseinheit },
            persistierteArten);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var verlauf = await LadeVerlauf(superAdmin, prozessId);

        Assert.Equal(new[] { "Antrag eingegangen", "Weiterleitung an Organisationseinheit" },
            verlauf.Select(h => h.StatusAenderung));
        Assert.DoesNotContain(verlauf, h => string.IsNullOrWhiteSpace(h.StatusAenderung));

        // Leere StatusAenderung erzeugt keinen (Phantom-)Edge-Eintrag in der historie.
        var historie = await LadeHistorie(superAdmin, prozessId);
        Assert.Empty(historie);
    }

    [Fact]
    public async Task StillerSchrittMitWechselZumDienstleister_ProtokolliertWeiterleitung() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var dienstleister = new Dienstleister {
            Id = Guid.NewGuid(),
            Name = "ABC GmbH",
            EMailAdressen = [$"dienstleister-{Guid.NewGuid():N}@example.com"],
            MandantId = KommuneSeeder.LandkreisHaPy.Id,
        };
        db.Dienstleister.Add(dienstleister);
        await db.SaveChangesAsync();

        var (prozessId, prozessVersionId, startSchrittId, verbindungId) = await CreateProzessMitStillemWechsel(db,
            new Zustaendigkeit { Art = ZustaendigkeitArt.Dienstleister, DienstleisterId = dienstleister.Id });
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(prozessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, startSchrittId, verbindungId, ("foo", "bar"));

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .OrderBy(v => v.CreatedAt)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(new[] { VerlaufsEreignisArt.Eingang, VerlaufsEreignisArt.WeiterleitungDienstleister },
            persistierteArten);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var verlauf = await LadeVerlauf(superAdmin, prozessId);

        Assert.Equal(new[] { "Antrag eingegangen", "Weiterleitung an Dienstleister" },
            verlauf.Select(h => h.StatusAenderung));
        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Weiterleitung an Dienstleister");
        Assert.Equal($"Vorgang an Dienstleister {dienstleister.Name} übergeben", eintrag.StatusAenderungBeschreibung);
        Assert.Equal(dienstleister.Name, eintrag.Ziel);
    }

    [Fact]
    public async Task WeiterleitungExternZurAnsicht_ProtokolliertWeiterleitungAnsicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        const string empfaengerEmail = "extern@example.com";

        var result = await ExecuteGraphqlAsync(superAdmin, AusfuehrungWeiterleitenExternMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["empfaengerEmail"] = empfaengerEmail,
                ["weiterleitungArt"] = "KOPIEREN",
            });
        Assert.Null(result.Errors);
        var payload = result.Data!["ausfuehrungWeiterleiten"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);

        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Weiterleitung zur Ansicht");
        Assert.Equal($"Vorgang zur Ansicht an {empfaengerEmail} weitergeleitet", eintrag.StatusAenderungBeschreibung);
        Assert.Equal(VorgangsverlaufService.NameVon(superAdminEntity), eintrag.Benutzer);
        Assert.Equal(empfaengerEmail, eintrag.Ziel);
        Assert.DoesNotContain(verlauf, h => h.StatusAenderung == "Vorgang abgeschlossen");
    }

    [Fact]
    public async Task WeiterleitungExternZurAbgabe_ProtokolliertWeiterleitungUndAbschluss() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        const string empfaengerEmail = "extern@example.com";
        const string nachricht = "Ihre Meldung wurde an die zuständige Stelle abgegeben.";
        var firebase = (RecordingFirebasePushMessagingService)Factory.Services
            .GetRequiredService<IFirebasePushMessagingService>();
        firebase.Reset();

        var result = await ExecuteGraphqlAsync(superAdmin, AusfuehrungWeiterleitenExternMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["empfaengerEmail"] = empfaengerEmail,
                ["weiterleitungArt"] = "SCHLIESSEN",
                ["nachricht"] = nachricht,
            });
        Assert.Null(result.Errors);
        var payload = result.Data!["ausfuehrungWeiterleiten"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        var persistierteArten = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId)
            .OrderBy(v => v.CreatedAt)
            .Select(v => v.Art)
            .ToListAsync();
        Assert.Equal(
            new[] {
                VerlaufsEreignisArt.Eingang, VerlaufsEreignisArt.WeiterleitungAbgabe, VerlaufsEreignisArt.Abschluss,
            },
            persistierteArten);

        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);

        Assert.Equal(new[] { "Antrag eingegangen", "Weiterleitung zur Abgabe", "Vorgang abgeschlossen" },
            verlauf.Select(h => h.StatusAenderung));
        var weiterleitung = Assert.Single(verlauf, h => h.StatusAenderung == "Weiterleitung zur Abgabe");
        Assert.Equal($"Vorgang zur Bearbeitung an {empfaengerEmail} weitergeleitet",
            weiterleitung.StatusAenderungBeschreibung);
        Assert.Equal(VorgangsverlaufService.NameVon(superAdminEntity), weiterleitung.Benutzer);
        Assert.Equal(nachricht, weiterleitung.Nachricht);
        Assert.DoesNotContain(verlauf, h => h.StatusAenderung == ManuellAbgeschlossenText);

        var environmentOptions = Factory.Services.GetRequiredService<IOptions<EnvironmentOptions>>();
        var push = Assert.Single(firebase.Messages);
        Assert.Equal(new PushTopic.Ausfuehrung(environmentOptions.Value.Name, ausfuehrungId).ToString(), push.Topic);
        Assert.Equal("Neue Nachricht zu Ihrem Antrag", push.Notification.Title);
        Assert.DoesNotContain(nachricht, push.Notification.Body);
    }

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    public async Task WeiterleitungExternZurAbgabe_OhneNachricht_WirdAbgelehntUndSchliesstNicht(string? nachricht) {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var firebase = (RecordingFirebasePushMessagingService)Factory.Services
            .GetRequiredService<IFirebasePushMessagingService>();
        firebase.Reset();

        var result = await WeiterleitenZurAbgabe(superAdmin, ausfuehrungId, nachricht);

        Assert.Equal("NachrichtRequiredError", AbgabeFehler(result)?.Typ);
        var ausfuehrung = await db.Ausfuehrungen.AsNoTracking().FirstAsync(a => a.Id == ausfuehrungId);
        Assert.NotEqual(AusfuehrungStatus.Abgeschlossen, ausfuehrung.Status);
        Assert.DoesNotContain(await db.VerlaufsEintraege.Where(v => v.AusfuehrungId == ausfuehrungId).ToListAsync(),
            v => v.Art is VerlaufsEreignisArt.WeiterleitungAbgabe or VerlaufsEreignisArt.Abschluss);
        Assert.Empty(firebase.Messages);
    }

    [Fact]
    public async Task WeiterleitungExternZurAbgabe_ZuLangeNachricht_WirdAbgelehntUndSchliesstNicht() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var maxLength = Factory.Services.GetRequiredService<ProzessOptions>().NachrichtMaxLength;

        var result = await WeiterleitenZurAbgabe(superAdmin, ausfuehrungId, new string('a', maxLength + 1));

        var fehler = AbgabeFehler(result);
        Assert.Equal("NachrichtTooLongError", fehler?.Typ);
        Assert.Contains(maxLength.ToString(), fehler?.Meldung);
        var ausfuehrung = await db.Ausfuehrungen.AsNoTracking().FirstAsync(a => a.Id == ausfuehrungId);
        Assert.NotEqual(AusfuehrungStatus.Abgeschlossen, ausfuehrung.Status);
    }

    [Fact]
    public async Task WeiterleitungExternZurAbgabe_NachrichtMitMaximalLaenge_WirdAkzeptiert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var maxLength = Factory.Services.GetRequiredService<ProzessOptions>().NachrichtMaxLength;

        var result = await WeiterleitenZurAbgabe(superAdmin, ausfuehrungId, new string('a', maxLength));

        Assert.Null(AbgabeFehler(result));
        var ausfuehrung = await db.Ausfuehrungen.AsNoTracking().FirstAsync(a => a.Id == ausfuehrungId);
        Assert.Equal(AusfuehrungStatus.Abgeschlossen, ausfuehrung.Status);
    }

    [Fact]
    public async Task WeiterleitungExternZurAbgabe_AufBereitsAbgeschlossenemAntrag_WirdAbgelehntOhneZweitenPush() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var firebase = (RecordingFirebasePushMessagingService)Factory.Services
            .GetRequiredService<IFirebasePushMessagingService>();

        Assert.Null(AbgabeFehler(await WeiterleitenZurAbgabe(superAdmin, ausfuehrungId, "Erste Abgabe")));
        firebase.Reset();
        var zweite = await WeiterleitenZurAbgabe(superAdmin, ausfuehrungId, "Zweite Abgabe");

        Assert.Equal("AntragWeiterleitenError", AbgabeFehler(zweite)?.Typ);
        Assert.Empty(firebase.Messages);
        var abgaben = await db.VerlaufsEintraege.CountAsync(v =>
            v.AusfuehrungId == ausfuehrungId && v.Art == VerlaufsEreignisArt.WeiterleitungAbgabe);
        Assert.Equal(1, abgaben);
    }

    [Fact]
    public async Task WeiterleitungExternZurAbgabe_NachrichtNurFuerMelderSichtbarUndPushAnMangelTopic() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: "Mangel behoben",
            asMaengelmelder: true);
        var (_, submitter) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var (_, stranger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, submitter);
        await WalkStep(submitter, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        var firebase = (RecordingFirebasePushMessagingService)Factory.Services
            .GetRequiredService<IFirebasePushMessagingService>();
        firebase.Reset();

        const string nachricht = "Wir haben Ihre Meldung an das Straßenbauamt abgegeben.";
        var result = await WeiterleitenZurAbgabe(superAdmin, ausfuehrungId, $"  {nachricht}  ");
        Assert.Null(AbgabeFehler(result));

        Assert.Equal(nachricht, await LoadMangelAbschlussMessage(submitter, ausfuehrungId));
        Assert.Equal(nachricht, await LoadMangelAbschlussMessage(superAdmin, ausfuehrungId));
        Assert.Null(await LoadMangelAbschlussMessage(stranger, ausfuehrungId));
        Assert.Null(await LoadMangelAbschlussMessage(new ClaimsPrincipal(new ClaimsIdentity()), ausfuehrungId));

        var eintrag = await db.VerlaufsEintraege.AsNoTracking().SingleAsync(v =>
            v.AusfuehrungId == ausfuehrungId && v.Art == VerlaufsEreignisArt.WeiterleitungAbgabe);
        Assert.Equal(nachricht, eintrag.Nachricht);

        var environmentOptions = Factory.Services.GetRequiredService<IOptions<EnvironmentOptions>>();
        var push = Assert.Single(firebase.Messages);
        Assert.Equal(new PushTopic.Mangel(environmentOptions.Value.Name, ausfuehrungId).ToString(), push.Topic);
        Assert.DoesNotContain(nachricht, push.Notification.Body);
    }

    [Fact]
    public async Task WeiterleitungExternZurAnsicht_BrauchtKeineNachrichtUndSendetKeinenPush() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);
        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var firebase = (RecordingFirebasePushMessagingService)Factory.Services
            .GetRequiredService<IFirebasePushMessagingService>();
        firebase.Reset();

        var result = await ExecuteGraphqlAsync(superAdmin, AusfuehrungWeiterleitenExternMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["empfaengerEmail"] = "extern@example.com",
                ["weiterleitungArt"] = "KOPIEREN",
            });

        Assert.Null(AbgabeFehler(result));
        Assert.Empty(firebase.Messages);
    }

    private async Task<IQueryResult> WeiterleitenZurAbgabe(ClaimsPrincipal user,
        Guid ausfuehrungId, string? nachricht) =>
        await ExecuteGraphqlAsync(user, AusfuehrungWeiterleitenExternMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["empfaengerEmail"] = "extern@example.com",
                ["weiterleitungArt"] = "SCHLIESSEN",
                ["nachricht"] = nachricht,
            });

    private static (string Typ, string Meldung)? AbgabeFehler(IQueryResult result) {
        if (result.Errors is { Count: > 0 } errors) return ("GraphQL", errors[0].Message);
        var payload = result.Data!["ausfuehrungWeiterleiten"] as IReadOnlyDictionary<string, object>;
        if (payload!["errors"] is not IReadOnlyList<object> { Count: > 0 } list) return null;
        var fehler = (IReadOnlyDictionary<string, object>)list[0];
        return ((string)fehler["__typename"], (string)fehler["message"]);
    }

    private async Task<string?> LoadMangelAbschlussMessage(ClaimsPrincipal? user, Guid ausfuehrungId) {
        var result = await ExecuteGraphqlAsync(user,
            """
            query MangelAbschlussNachricht($kommuneId: UUID!, $id: UUID!) {
              kommune(kommuneId: $kommuneId) {
                mangelAusfuehrung(id: $id) {
                  historie { statusAenderung nachricht }
                }
              }
            }
            """,
            new Dictionary<string, object?> {
                ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
                ["id"] = ausfuehrungId,
            });
        Assert.Null(result.Errors);

        var kommune = (IReadOnlyDictionary<string, object>)result.Data!["kommune"]!;
        var mangel = (IReadOnlyDictionary<string, object>)kommune["mangelAusfuehrung"];
        var historie = ((IReadOnlyList<object>)mangel["historie"]).Cast<IReadOnlyDictionary<string, object?>>();

        return Assert.Single(historie, h => h["statusAenderung"] as string == ManuellAbgeschlossenText)["nachricht"]
            as string;
    }

    [Fact]
    public async Task ZuweisungAnAnderePerson_ProtokolliertZustaendigkeitswechselMitZiel() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        var anderePerson = await CreateBackofficeUserAsync(scope.ServiceProvider, db, "Erika", "Empfängerin");

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, anderePerson.Id);

        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);

        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Zuständigkeitswechsel");
        Assert.Equal($"Zuständigkeit geändert zu {VorgangsverlaufService.NameVon(anderePerson)}",
            eintrag.StatusAenderungBeschreibung);
        Assert.Equal(VorgangsverlaufService.NameVon(superAdminEntity), eintrag.Benutzer);
        Assert.Equal(VorgangsverlaufService.NameVon(anderePerson), eintrag.Ziel);
        Assert.DoesNotContain(verlauf, h => h.StatusAenderung == "Vorgang übernommen");
    }

    [Fact]
    public async Task WeiterleitungInternAnMitarbeiter_ProtokolliertZustaendigkeitswechselMitZiel() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);
        await SetOrganisationseinheitZustaendigkeit(db, ausfuehrungId);

        // Beide brauchen OE-Berechtigung für Aerzen; OE-Fallback greift, weil keine Abteilung am Antrag hinterlegt ist.
        var absender = await CreateBackofficeUserAsync(scope.ServiceProvider, db, "Sina", "Sachbearbeiterin",
            mitAerzenBerechtigung: true, mitLogin: true);
        var empfaenger = await CreateBackofficeUserAsync(scope.ServiceProvider, db, "Erik", "Empfänger",
            mitAerzenBerechtigung: true);

        var absenderPrincipal = await GetUserToken(absender.EMail, TestUserPassword);
        var weiterleitung = await ExecuteGraphqlAsync(absenderPrincipal, AusfuehrungWeiterleitenMutation,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["empfaengerId"] = empfaenger.Id,
            });
        Assert.Null(weiterleitung.Errors);
        var payload = weiterleitung.Data!["ausfuehrungWeiterleiten"] as IReadOnlyDictionary<string, object>;
        Assert.Null(payload!["errors"]);

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);

        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Zuständigkeitswechsel");
        Assert.Equal($"Zuständigkeit geändert zu {VorgangsverlaufService.NameVon(empfaenger)}",
            eintrag.StatusAenderungBeschreibung);
        Assert.Equal(VorgangsverlaufService.NameVon(absender), eintrag.Benutzer);
        Assert.Equal(VorgangsverlaufService.NameVon(empfaenger), eintrag.Ziel);
    }

    [Fact]
    public async Task ManuellAbgeschlossen_SynthetischerEintragInHistorie_PersistierterAbschlussInVerlauf() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.PersoenlicheDaten.Id, fixture.PersoenlicheDatenNachKontakt.Id,
            ("name", "Max Mustermann"), ("geburtsdatum", "1990-01-01"));
        await WalkStep(buerger, ausfuehrungId, fixture.Kontakt.Id, fixture.KontaktNachPruefung.Id,
            ("email", "max@example.com"));

        // Manuell abgeschlossen (Altbestand: bevor ein Abschluss persistiert wurde).
        var abgeschlossenAm = SystemClock.Instance.GetCurrentInstant();
        var ausfuehrung = await db.Ausfuehrungen.AsTracking().FirstAsync(a => a.Id == ausfuehrungId);
        ausfuehrung.ManuellAbgeschlossen = abgeschlossenAm;
        ausfuehrung.AbgeschlossenAm = abgeschlossenAm;
        ausfuehrung.Status = AusfuehrungStatus.Abgeschlossen;
        await db.SaveChangesAsync();

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);

        // Bürger-Stream: rekonstruiertes Edge-Label + synthetischer manueller Abschluss (immer, ohne Guard).
        var historie = await LadeHistorie(superAdmin, fixture.ProzessId);
        Assert.Equal(new[] { "Antrag in Prüfung", ManuellAbgeschlossenText }, historie.Select(h => h.StatusAenderung));

        // Backoffice-Stream: nur persistierte Ereignisse, kein synthetischer manueller Abschluss.
        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        Assert.Equal(new[] { "Antrag eingegangen", "Weiterleitung an Organisationseinheit" },
            verlauf.Select(h => h.StatusAenderung));
        Assert.DoesNotContain(verlauf, h => h.StatusAenderung == ManuellAbgeschlossenText);

        // Persistierter Abschluss taucht in verlauf auf; historie behält den synthetischen Eintrag
        // (getrennte Streams -> keine Dopplung, kein Guard nötig).
        db.VerlaufsEintraege.Add(new VerlaufsEintrag {
            AusfuehrungId = ausfuehrungId,
            CreatedAt = SystemClock.Instance.GetCurrentInstant(),
            Art = VerlaufsEreignisArt.Abschluss,
        });
        await db.SaveChangesAsync();

        verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        Assert.Equal(
            new[] { "Antrag eingegangen", "Weiterleitung an Organisationseinheit", "Vorgang abgeschlossen" },
            verlauf.Select(h => h.StatusAenderung));

        historie = await LadeHistorie(superAdmin, fixture.ProzessId);
        Assert.Equal(new[] { "Antrag in Prüfung", ManuellAbgeschlossenText }, historie.Select(h => h.StatusAenderung));
    }

    [Fact]
    public async Task RekonstruierteEintraege_EnthaltenAusfuehrendenMitarbeiter() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await TestProcessSeeder.SeedRenewDrivingLicense(db);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.PersoenlicheDaten.Id, fixture.PersoenlicheDatenNachKontakt.Id,
            ("name", "Max Mustermann"), ("geburtsdatum", "1990-01-01"));
        await WalkStep(buerger, ausfuehrungId, fixture.Kontakt.Id, fixture.KontaktNachPruefung.Id,
            ("email", "max@example.com"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);

        await WalkStep(superAdmin, ausfuehrungId, fixture.Pruefung.Id, fixture.PruefungNachEnde.Id,
            ("entscheidung", "Genehmigt"));

        var historie = await LadeHistorie(superAdmin, fixture.ProzessId);

        var buergerEintrag = Assert.Single(historie, h => h.StatusAenderung == "Antrag in Prüfung");
        Assert.Null(buergerEintrag.Benutzer);
        var mitarbeiterEintrag = Assert.Single(historie, h => h.StatusAenderung == "Bescheid erstellt");
        Assert.Equal(VorgangsverlaufService.NameVon(superAdminEntity), mitarbeiterEintrag.Benutzer);
    }

    [Fact]
    public async Task NachrichtSchritt_NachrichtErscheintMitAbschlussStatusInHistorie() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: "Mangel behoben");
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        await WalkStep(superAdmin, ausfuehrungId, fixture.NachrichtSchrittId, fixture.AbschlussVerbindungId,
            ("nachricht", "Der Mangel wurde behoben. Vielen Dank für Ihre Meldung!"));

        var historie = await LadeHistorieMitNachricht(superAdmin, fixture.ProzessId);

        var eintrag = Assert.Single(historie, h => h.StatusAenderung == "Mangel behoben");
        Assert.Equal("Der Mangel wurde behoben. Vielen Dank für Ihre Meldung!", eintrag.Nachricht);
    }

    [Fact]
    public async Task NachrichtSchritt_OhneKantenLabel_NachrichtErscheintTrotzdemInHistorie() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: null);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        await WalkStep(superAdmin, ausfuehrungId, fixture.NachrichtSchrittId, fixture.AbschlussVerbindungId,
            ("nachricht", "Zur Info: der Bauhof war heute vor Ort."));

        var historie = await LadeHistorieMitNachricht(superAdmin, fixture.ProzessId);

        var eintrag = Assert.Single(historie);
        Assert.Null(eintrag.StatusAenderung);
        Assert.Equal("Zur Info: der Bauhof war heute vor Ort.", eintrag.Nachricht);
    }

    [Fact]
    public async Task NachrichtSchritt_MessageIsOnlyVisibleToSubmitterAndBackoffice() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: "Mangel behoben",
            asMaengelmelder: true);
        var (_, submitter) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var (_, stranger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, submitter);

        await WalkStep(submitter, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        await WalkStep(superAdmin, ausfuehrungId, fixture.NachrichtSchrittId, fixture.AbschlussVerbindungId,
            ("nachricht", "Bitte melden Sie sich unter 05151 123456."));

        Assert.Equal("Bitte melden Sie sich unter 05151 123456.", await LoadMangelMessage(submitter, ausfuehrungId));
        Assert.Equal("Bitte melden Sie sich unter 05151 123456.", await LoadMangelMessage(superAdmin, ausfuehrungId));
        Assert.Null(await LoadMangelMessage(stranger, ausfuehrungId));
        Assert.Null(await LoadMangelMessage(new ClaimsPrincipal(new ClaimsIdentity()), ausfuehrungId));
    }

    [Fact]
    public async Task NachrichtSchritt_OhneNachrichtUndOhneKantenLabel_ErzeugtKeinenHistorieEintrag() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: null);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        await WalkStep(superAdmin, ausfuehrungId, fixture.NachrichtSchrittId, fixture.AbschlussVerbindungId);

        var historie = await LadeHistorieMitNachricht(superAdmin, fixture.ProzessId);

        Assert.Empty(historie);
    }

    [Fact]
    public async Task NachrichtSchritt_WirdAlsBuergerKommunikationImVerlaufProtokolliert() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: "Mangel behoben");
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        await WalkStep(superAdmin, ausfuehrungId, fixture.NachrichtSchrittId, fixture.AbschlussVerbindungId,
            ("nachricht", "Der Mangel wurde behoben. Vielen Dank für Ihre Meldung!"));

        var persistiert = await db.VerlaufsEintraege
            .Where(v => v.AusfuehrungId == ausfuehrungId && v.Art == VerlaufsEreignisArt.BuergerKommunikation)
            .SingleAsync();
        Assert.Equal("Der Mangel wurde behoben. Vielen Dank für Ihre Meldung!", persistiert.Nachricht);

        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        var erwarteterName = VorgangsverlaufService.NameVon(superAdminEntity);

        var eintrag = Assert.Single(verlauf, h => h.StatusAenderung == "Bürger Kommunikation");
        Assert.Equal($"Nachricht von {erwarteterName} an die einreichende Person gesendet",
            eintrag.StatusAenderungBeschreibung);
        Assert.Equal(erwarteterName, eintrag.Benutzer);
        Assert.Equal("Der Mangel wurde behoben. Vielen Dank für Ihre Meldung!", eintrag.Nachricht);
    }

    [Fact]
    public async Task NachrichtSchritt_OhneNachricht_ErzeugtKeinenBuergerKommunikationEintrag() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: null);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);
        await WalkStep(superAdmin, ausfuehrungId, fixture.NachrichtSchrittId, fixture.AbschlussVerbindungId);

        Assert.False(await db.VerlaufsEintraege.AnyAsync(v =>
            v.AusfuehrungId == ausfuehrungId && v.Art == VerlaufsEreignisArt.BuergerKommunikation));

        var verlauf = await LadeVerlauf(superAdmin, fixture.ProzessId);
        Assert.DoesNotContain(verlauf, h => h.StatusAenderung == "Bürger Kommunikation");
    }

    [Fact]
    public async Task NachrichtSchritt_ZuLangeNachricht_WirdAbgelehnt() {
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        await testSeeder.EnsureSeedOrganisationseinheitExists();

        var maxLength = scope.ServiceProvider.GetRequiredService<ProzessOptions>().NachrichtMaxLength;

        var fixture = await CreateProzessMitNachrichtSchritt(db, abschlussStatusAenderung: null);
        var (_, buerger) = await CreateBuergerWithPrincipalAsync(db, scope.ServiceProvider);
        var ausfuehrungId = await CreateAusfuehrung(fixture.ProzessVersionId, buerger);

        await WalkStep(buerger, ausfuehrungId, fixture.StartSchrittId, fixture.SubmitVerbindungId, ("foo", "bar"));

        var superAdmin = await GetUserToken(SuperAdminEmail, SuperAdminPassword);
        var superAdminEntity = await db.BackofficeUser.FirstAsync(u => u.EMail == SuperAdminEmail);
        await Uebernehmen(superAdmin, ausfuehrungId, superAdminEntity.Id);

        var tooLong = new string('x', maxLength + 1);
        var result = await ExecuteQuery(superAdmin,
            """
            mutation AusfuehrungContinue($input: AusfuehrungContinueInput!) {
              ausfuehrungContinue(input: $input) {
                ausfuehrungResult { ausfuehrung { id } }
                errors { __typename ... on Error { message } }
              }
            }
            """,
            new Dictionary<string, object?> {
                ["ausfuehrungId"] = ausfuehrungId,
                ["bearbeitungen"] = new List<Dictionary<string, object?>> {
                    new() {
                        ["schrittId"] = fixture.NachrichtSchrittId,
                        ["nextVerbindungId"] = fixture.AbschlussVerbindungId,
                        ["slotValues"] = new List<Dictionary<string, object?>> {
                            new() {
                                ["name"] = "nachricht",
                                ["value"] = new Dictionary<string, object?> {
                                    ["plainValue"] = JsonSerializer.SerializeToElement(tooLong),
                                },
                            },
                        },
                    },
                },
                ["naechsteIstZustaendigkeit"] = null,
            });

        Assert.Null(result.Errors);
        var payload = result.Data!["ausfuehrungContinue"] as IReadOnlyDictionary<string, object>;
        var errors = payload!["errors"] as IReadOnlyList<object>;
        var error = Assert.Single(errors!.Cast<IReadOnlyDictionary<string, object?>>());
        Assert.Equal("NachrichtTooLongError", error["__typename"]);

        Assert.False(await db.Bearbeitungen.AnyAsync(b =>
            b.AusfuehrungId == ausfuehrungId && b.SchrittId == fixture.NachrichtSchrittId));
        Assert.False(await db.VerlaufsEintraege.AnyAsync(v =>
            v.AusfuehrungId == ausfuehrungId && v.Art == VerlaufsEreignisArt.BuergerKommunikation));
    }

    private async Task Uebernehmen(ClaimsPrincipal user, Guid ausfuehrungId, Guid userId) {
        var result = await ExecuteGraphqlAsync(user, AusfuehrungUpdateZugewiesenePersonMutation,
            new Dictionary<string, object?> { ["ausfuehrungId"] = ausfuehrungId, ["userId"] = userId });
        Assert.Null(result.Errors);
    }

    private async Task WalkStep(ClaimsPrincipal user, Guid ausfuehrungId, Guid schrittId, Guid verbindungId,
        params (string Name, object Value)[] slots) {
        var slotValues = slots.Select(s => new Dictionary<string, object?> {
            ["name"] = s.Name,
            ["value"] = new Dictionary<string, object?> { ["plainValue"] = JsonSerializer.SerializeToElement(s.Value) },
        }).ToList();

        var result = await ExecuteQuery(user, AusfuehrungContinueMutation, new Dictionary<string, object?> {
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

    private Task<List<(string? StatusAenderung, string? StatusAenderungBeschreibung, string? Benutzer, string? Ziel,
            string? Nachricht)>>
        LadeHistorie(ClaimsPrincipal user, Guid prozessId) => LadeTimeline(user, prozessId, "historie");

    private Task<List<(string? StatusAenderung, string? StatusAenderungBeschreibung, string? Benutzer, string? Ziel,
            string? Nachricht)>>
        LadeVerlauf(ClaimsPrincipal user, Guid prozessId) => LadeTimeline(user, prozessId, "verlauf");

    private async Task<List<(string? StatusAenderung, string? StatusAenderungBeschreibung, string? Benutzer,
            string? Ziel, string? Nachricht)>>
        LadeTimeline(ClaimsPrincipal user, Guid prozessId, string feld) {
        var query = $$"""
            query AntragTimeline($prozessId: UUID!) {
              ausfuehrungen(prozessId: $prozessId, take: 10) {
                items {
                  id
                  {{feld}} { statusAenderung statusAenderungBeschreibung benutzer ziel nachricht }
                }
              }
            }
            """;

        var result = await ExecuteGraphqlAsync(user, query,
            new Dictionary<string, object?> { ["prozessId"] = prozessId });
        Assert.Null(result.Errors);

        var ausfuehrungen = result.Data!["ausfuehrungen"] as IReadOnlyDictionary<string, object>;
        var items = ausfuehrungen!["items"] as IReadOnlyList<object>;

        return items!
            .Cast<IReadOnlyDictionary<string, object>>()
            .SelectMany(item => (item[feld] as IReadOnlyList<object>)!.Cast<IReadOnlyDictionary<string, object?>>())
            .Select(h => (
                h["statusAenderung"] as string,
                h["statusAenderungBeschreibung"] as string,
                h["benutzer"] as string,
                h["ziel"] as string,
                h["nachricht"] as string))
            .ToList();
    }

    private async Task<string?> LoadMangelMessage(ClaimsPrincipal? user, Guid ausfuehrungId) {
        var result = await ExecuteGraphqlAsync(user,
            """
            query MangelNachricht($kommuneId: UUID!, $id: UUID!) {
              kommune(kommuneId: $kommuneId) {
                mangelAusfuehrung(id: $id) {
                  historie { statusAenderung nachricht }
                }
              }
            }
            """,
            new Dictionary<string, object?> {
                ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id,
                ["id"] = ausfuehrungId,
            });
        Assert.Null(result.Errors);

        var kommune = (IReadOnlyDictionary<string, object>)result.Data!["kommune"]!;
        var mangel = (IReadOnlyDictionary<string, object>)kommune["mangelAusfuehrung"];
        var historie = ((IReadOnlyList<object>)mangel["historie"]).Cast<IReadOnlyDictionary<string, object?>>();

        return Assert.Single(historie, h => h["statusAenderung"] as string == "Mangel behoben")["nachricht"] as string;
    }

    private async Task<List<(string? StatusAenderung, string? Nachricht)>> LadeHistorieMitNachricht(
        ClaimsPrincipal user, Guid prozessId) {
        var result = await ExecuteGraphqlAsync(user,
            """
            query AntragHistorieMitNachricht($prozessId: UUID!) {
              ausfuehrungen(prozessId: $prozessId, take: 10) {
                items {
                  id
                  historie { statusAenderung nachricht }
                }
              }
            }
            """,
            new Dictionary<string, object?> { ["prozessId"] = prozessId });
        Assert.Null(result.Errors);

        var ausfuehrungen = result.Data!["ausfuehrungen"] as IReadOnlyDictionary<string, object>;
        var items = ausfuehrungen!["items"] as IReadOnlyList<object>;

        return items!
            .Cast<IReadOnlyDictionary<string, object>>()
            .SelectMany(item =>
                (item["historie"] as IReadOnlyList<object>)!.Cast<IReadOnlyDictionary<string, object?>>())
            .Select(h => (h["statusAenderung"] as string, h["nachricht"] as string))
            .ToList();
    }

    private async Task<Guid> CreateAusfuehrung(Guid prozessVersionId, ClaimsPrincipal buergerPrincipal) {
        var result = await ExecuteQuery(buergerPrincipal, AusfuehrungErstellenMutation, new Dictionary<string, object?> {
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

    private static async Task<(Guid ProzessId, Guid ProzessVersionId, Guid StartSchrittId, Guid VerbindungId)>
        CreateProzess(DomainContext db, string? submitStatusAenderung = null) {
        var prozessId = Guid.NewGuid();
        var prozessVersionId = Guid.NewGuid();

        var prozess = new Prozess {
            Id = prozessId,
            Name = "Vorgangsverlauf-Test",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var prozessVersion = new ProzessVersion {
            Id = prozessVersionId,
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"Vorgangsverlauf",
        };

        var startSchritt = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = new List<FormularFeld> { new StringFormularFeld { SlotName = "foo", Order = 0 } },
        };

        var endeSchritt = new EndeSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
        };

        prozessVersion.Schritte.Add(startSchritt);
        prozessVersion.Schritte.Add(endeSchritt);

        var verbindung = new Verbindung {
            Von = startSchritt,
            Nach = endeSchritt,
            StatusAenderung = submitStatusAenderung,
        };
        startSchritt.Verbindungen.Add(verbindung);

        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = startSchritt;
        await db.SaveChangesAsync();

        return (prozessId, prozessVersionId, startSchritt.Id, verbindung.Id);
    }

    /// <summary>
    /// Prozess mit stiller Verbindung (StatusAenderung = null bzw. leer), deren Zielschritt die Zuständigkeit
    /// vom Bürger auf <paramref name="zielZustaendigkeit"/> wechselt.
    /// </summary>
    private static async Task<(Guid ProzessId, Guid ProzessVersionId, Guid StartSchrittId, Guid VerbindungId)>
        CreateProzessMitStillemWechsel(DomainContext db, Zustaendigkeit zielZustaendigkeit,
            string? statusAenderung = null) {
        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "Vorgangsverlauf-Test (stiller Wechsel)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        var prozessVersion = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"Vorgangsverlauf",
        };

        var startSchritt = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = new List<FormularFeld> { new StringFormularFeld { SlotName = "foo", Order = 0 } },
        };

        var kommuneSchritt = new FormularSchritt {
            SollZustaendigkeit = zielZustaendigkeit,
            Felder = new List<FormularFeld> { new StringFormularFeld { SlotName = "entscheidung", Order = 0 } },
        };

        prozessVersion.Schritte.Add(startSchritt);
        prozessVersion.Schritte.Add(kommuneSchritt);

        var verbindung = new Verbindung { Von = startSchritt, Nach = kommuneSchritt, StatusAenderung = statusAenderung };
        startSchritt.Verbindungen.Add(verbindung);

        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = startSchritt;
        await db.SaveChangesAsync();

        return (prozess.Id, prozessVersion.Id, startSchritt.Id, verbindung.Id);
    }

    /// <summary>
    /// Prozess Start (Bürger) → Nachricht-Schritt (Organisationseinheit) → Ende. Die Submit-Kante ist still;
    /// die Abschluss-Kante trägt optional ein Statuslabel.
    /// </summary>
    private static async Task<(Guid ProzessId, Guid ProzessVersionId, Guid StartSchrittId, Guid SubmitVerbindungId,
            Guid NachrichtSchrittId, Guid AbschlussVerbindungId)>
        CreateProzessMitNachrichtSchritt(DomainContext db, string? abschlussStatusAenderung,
            bool asMaengelmelder = false) {
        var prozess = new Prozess {
            Id = Guid.NewGuid(),
            Name = "Vorgangsverlauf-Test (Nachricht)",
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
        };

        if (asMaengelmelder) {
            var maengelTag = new ProzessTag { Id = Guid.NewGuid(), Tag = "Mängelmelder" };
            prozess.Tags.Add(maengelTag);
            prozess.TagHistorie.Add(new ProzessTagHistorieEintrag {
                Id = Guid.NewGuid(),
                ProzessId = prozess.Id,
                TagId = maengelTag.Id,
                ZugewiesenAm = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            });
        }

        var prozessVersion = new ProzessVersion {
            Id = Guid.NewGuid(),
            Prozess = prozess,
            CreatedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            PublishedAt = Instant.FromUtc(2026, 6, 9, 12, 0, 0),
            Beschreibungstext = (StringExpression)"Vorgangsverlauf",
        };

        var startSchritt = new FormularSchritt {
            SollZustaendigkeit = new Zustaendigkeit { Art = ZustaendigkeitArt.Buerger },
            Felder = new List<FormularFeld> { new StringFormularFeld { SlotName = "foo", Order = 0 } },
        };

        var nachrichtSchritt = new NachrichtSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
        };

        var endeSchritt = new EndeSchritt {
            SollZustaendigkeit = new Zustaendigkeit {
                Art = ZustaendigkeitArt.Organisationseinheit,
                OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
            },
        };

        prozessVersion.Schritte.Add(startSchritt);
        prozessVersion.Schritte.Add(nachrichtSchritt);
        prozessVersion.Schritte.Add(endeSchritt);

        var submitVerbindung = new Verbindung { Von = startSchritt, Nach = nachrichtSchritt };
        startSchritt.Verbindungen.Add(submitVerbindung);

        var abschlussVerbindung = new Verbindung {
            Von = nachrichtSchritt,
            Nach = endeSchritt,
            StatusAenderung = abschlussStatusAenderung,
        };
        nachrichtSchritt.Verbindungen.Add(abschlussVerbindung);

        await db.ProzessVersionen.AddAsync(prozessVersion);
        await db.SaveChangesAsync();

        prozessVersion.Start = startSchritt;
        await db.SaveChangesAsync();

        return (prozess.Id, prozessVersion.Id, startSchritt.Id, submitVerbindung.Id, nachrichtSchritt.Id,
            abschlussVerbindung.Id);
    }

    private static async Task SetOrganisationseinheitZustaendigkeit(DomainContext db, Guid ausfuehrungId) {
        var ausfuehrung = await db.Ausfuehrungen.AsTracking()
            .Include(a => a.IstZustaendigkeit)
            .FirstAsync(a => a.Id == ausfuehrungId);
        ausfuehrung.IstZustaendigkeit.Art = ZustaendigkeitArt.Organisationseinheit;
        ausfuehrung.IstZustaendigkeit.OrganisationseinheitId = KommuneSeeder.AerzenOrganisationseinheitId;
        ausfuehrung.IstZustaendigkeit.MitarbeiterGruppeId = null;
        await db.SaveChangesAsync();
    }

    private static async Task<BackofficeUser> CreateBackofficeUserAsync(IServiceProvider services, DomainContext db,
        string vorname, string nachname, bool mitAerzenBerechtigung = false, bool mitLogin = false) {
        var user = new BackofficeUser {
            Id = Guid.NewGuid(),
            EMail = $"verlauf-{Guid.NewGuid():N}@example.com",
            Vorname = vorname,
            Nachname = nachname,
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Art = BackofficeNutzerArt.Nutzer,
            Gruppen = [],
            UntereinheitPermissions = [],
        };

        if (mitLogin) {
            var hasher = services.GetRequiredService<IPasswordHasher<User>>();
            TestUserCrypto.InitializeMitarbeiterCrypto(user, TestUserPassword,
                KommuneSeeder.LandkreisHaPy.KeyEncryptionKey, hasher);
        }

        if (mitAerzenBerechtigung) {
            user.UntereinheitPermissions.Add(new UntereinheitPermissions {
                UntereinheitId = KommuneSeeder.AerzenOrganisationseinheitId,
                Funktionsberechtigungen = [
                    FunktionsberechtigungInOrganisationseinheit.Backoffice,
                    FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege,
                ],
            });
        }

        db.BackofficeUser.Add(user);
        await db.SaveChangesAsync();
        return user;
    }

    private static async Task<(Buerger Entity, ClaimsPrincipal Principal)> CreateBuergerWithPrincipalAsync(
        DomainContext db, IServiceProvider services) {
        var buerger = new Buerger { PersonalDataKeyEncryptedForBuerger = "foo" };
        await db.Users.AddAsync(buerger);
        await db.SaveChangesAsync();

        var jwtOptions = services.GetRequiredService<IOptions<JWTOptions>>().Value;
        var identity = new ClaimsIdentity(buerger.GetToken(jwtOptions).Claims, "jwt");
        return (buerger, new ClaimsPrincipal(identity));
    }
}
