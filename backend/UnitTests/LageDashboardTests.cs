using System.Security.Claims;
using System.Text.Json;
using API.Features;
using API.Pages.lagehelfer;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using NodaTime;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Lage;
using API.Seeders;
using HotChocolate;
using HotChocolate.Execution;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace IntegrationTests;

/// <summary>Leitstelle and Einsatzleitung acting on LageHelfer reports. Each test seeds its own Lage.</summary>
[Collection("Api Tests")]
public class LageDashboardTests(BackendApiFactory factory) : LageMeldungTestBase(factory) {
    private record Szenario(
        Guid LageId,
        Guid AusfuehrungId,
        Guid CorrelationId,
        MitarbeiterGruppe EinsatzleitungWest,
        MitarbeiterGruppe EinsatzleitungOst,
        ClaimsPrincipal Leitstelle,
        ClaimsPrincipal West,
        ClaimsPrincipal Ost);

    private async Task<Szenario> SeedSzenario(string beschreibung = "Baum blockiert Straße") {
        var untereinheit = await gebietSeeder.SeedUntereinheit();
        var (west, einsatzleitungWest) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var (_, einsatzleitungOst) = await SeedGebietMitEinsatzleitung(untereinheit, "Ost", East);
        var lage = await lageSeeder.SeedLageForGebiet(west, Live);
        var meldeprozess = await SeedMeldeprozess(KommuneSeeder.LandkreisHaPy.Id, lageErforderlich: true);

        var create = await CreateAnonym(meldeprozess, new LageSelectionInput(lage.Id, west.Id), 9.2, 52.2,
            beschreibung);
        Assert.DoesNotContain("Error\"", create.ToJson());
        var correlationId = CorrelationIdOf(create);
        Guid ausfuehrungId;
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            ausfuehrungId = await scope.ServiceProvider.GetRequiredService<DomainContext>().Ausfuehrungen
                .Where(a => a.CorrelationId == correlationId).Select(a => a.Id).SingleAsync();
        }
        await RunZustaendigkeitsschritt(ausfuehrungId);

        return new Szenario(lage.Id, ausfuehrungId, correlationId, einsatzleitungWest, einsatzleitungOst,
            await LageHelfer(BackofficeNutzerArt.Admin),
            await LageHelfer(BackofficeNutzerArt.Nutzer, einsatzleitungWest.Id),
            await LageHelfer(BackofficeNutzerArt.Nutzer, einsatzleitungOst.Id));
    }

    private Task<ClaimsPrincipal> LageHelfer(BackofficeNutzerArt art, params Guid[] gruppen) =>
        testSeeder.CreateBackofficeUserPrincipal(art, [GlobaleFunktionsberechtigung.LageHelfer], gruppen.ToList());

    private const string MeldungFields = """
        id meldungsnummer ereignisStatus klaerungSeit klaerungGrund klaerungKommentar verwerfenGrund anzahlBestaetigungen
        klasse benoetigteAusruestung moeglicherNotfall notfallPruefung externeStelle externKommentar
        einheit { id name }
        istZustaendigkeit { mitarbeiterGruppeId }
        """;

    private async Task<JsonElement[]> LageMeldungen(ClaimsPrincipal caller, Guid lageId, bool? offen = null) {
        var data = await Data(caller, $$"""
            query($lageId: UUID!, $offen: Boolean) { lageMeldungen(lageId: $lageId, offen: $offen) { {{MeldungFields}} } }
            """, new Dictionary<string, object?> { ["lageId"] = lageId, ["offen"] = offen });
        return data.GetProperty("lageMeldungen").EnumerateArray().Select(e => e.Clone()).ToArray();
    }

    private async Task<string> EreignisStatus(Szenario s) =>
        Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId)).GetProperty("ereignisStatus").GetString()!;

    private async Task<string> BuergerStatus(Guid correlationId) {
        ActAnonymously();
        var data = await Data(null, """
            query($correlationId: UUID!) { ausfuehrungStatusAnonym(correlationId: $correlationId) { status meldungsnummer } }
            """, new Dictionary<string, object?> { ["correlationId"] = correlationId });
        return data.GetProperty("ausfuehrungStatusAnonym").GetProperty("status").GetString()!;
    }

    private async Task<JsonElement> Mutation(ClaimsPrincipal? caller, string field, string inputType,
        Dictionary<string, object?> input, string selection = $"ausfuehrung {{ {MeldungFields} }}") {
        var result = await ExecuteGraphqlAsync(caller, $$"""
            mutation($input: {{inputType}}!) {
              {{field}}(input: $input) { {{selection}} errors { __typename ... on Error { message } } }
            }
            """, new Dictionary<string, object?> { ["input"] = input });
        Assert.True(result.Errors is null, result.ToJson());
        return JsonDocument.Parse(result.ToJson()).RootElement.GetProperty("data").GetProperty(field).Clone();
    }

    private static JsonElement Ok(JsonElement payload) {
        Assert.Equal(JsonValueKind.Null, payload.GetProperty("errors").ValueKind);
        return payload;
    }

    private static void Fails(JsonElement payload, string errorTypename) =>
        Assert.Equal(errorTypename, payload.GetProperty("errors")[0].GetProperty("__typename").GetString());

    private async Task<JsonElement> Data(ClaimsPrincipal? caller, string query, Dictionary<string, object?> variables) {
        var result = await ExecuteGraphqlAsync(caller, query, variables);
        Assert.True(result.Errors is null, result.ToJson());
        return JsonDocument.Parse(result.ToJson()).RootElement.GetProperty("data").Clone();
    }

    [Theory]
    [InlineData(false)]
    [InlineData(true)]
    public async Task RueckrufVomKontaktformularBisZumAbschluss(bool mitMeldung) {
        var s = await SeedSzenario();
        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var publicId = await db.Ausfuehrungen.Where(a => a.Id == s.AusfuehrungId)
            .Select(a => a.PublicId).SingleAsync();
        var url = $"/lagehelfer/Kontakt?kommuneId={KommuneSeeder.LandkreisHaPy.Id}&rueckruf=true" +
            (mitMeldung ? $"&meldungId={publicId}" : $"&lageId={s.LageId}");
        using var client = Factory.CreateClient();
        var formular = await client.GetStringAsync(url);
        string Feld(string name) {
            var match = System.Text.RegularExpressions.Regex.Match(formular,
                $"<input[^>]*name=\"{name}\"[^>]*value=\"([^\"]+)\"");
            Assert.True(match.Success, name);
            return System.Net.WebUtility.HtmlDecode(match.Groups[1].Value);
        }
        var vorgang = Feld("Vorgang");
        using var antwort = await client.PostAsync(url, new FormUrlEncodedContent(new Dictionary<string, string> {
            ["Vorgang"] = vorgang, ["Nummer"] = "05151 12345",
            ["__RequestVerificationToken"] = Feld("__RequestVerificationToken"),
        }));
        antwort.EnsureSuccessStatusCode();
        Assert.Contains("bei der Leitstelle eingegangen", await antwort.Content.ReadAsStringAsync());
        const string liste = "query($id: UUID!) { lageKontakte(lageId: $id, offeneRueckrufe: true) { id meldungId telefonnummer } }";
        var variables = new Dictionary<string, object?> { ["id"] = s.LageId };
        var eintrag = Assert.Single((await Data(s.Leitstelle, liste, variables)).GetProperty("lageKontakte").EnumerateArray());
        Assert.Equal(Guid.Parse(vorgang), eintrag.GetProperty("id").GetGuid());
        Assert.Equal("0515112345", eintrag.GetProperty("telefonnummer").GetString());
        if (mitMeldung) Assert.Equal(publicId, eintrag.GetProperty("meldungId").GetGuid());
        else Assert.Equal(JsonValueKind.Null, eintrag.GetProperty("meldungId").ValueKind);
        await Data(s.Leitstelle, "mutation($id: UUID!) { rueckrufAbschliessen(input: {id: $id}) { __typename } }",
            new Dictionary<string, object?> { ["id"] = Guid.Parse(vorgang) });
        Assert.Empty((await Data(s.Leitstelle, liste, variables)).GetProperty("lageKontakte").EnumerateArray());
    }

    [Fact]
    public async Task FreiwilligeNummerWirdZurMeldungGespeichertOhneRueckrufticket() {
        var s = await SeedSzenario();
        await using var scope = Factory.Services.CreateAsyncScope();
        var services = scope.ServiceProvider;
        var db = services.GetRequiredService<DomainContext>();
        var meldung = await db.Ausfuehrungen.SingleAsync(a => a.Id == s.AusfuehrungId);
        var context = new DefaultHttpContext { RequestServices = services };
        var kontakt = new KontaktModel(db, services.GetRequiredService<IClock>()) {
            PageContext = new PageContext { HttpContext = context },
            TempData = new TempDataDictionary(context, services.GetRequiredService<ITempDataProvider>()),
            KommuneId = KommuneSeeder.LandkreisHaPy.Id,
            Vorgang = Guid.NewGuid(),
            MeldungId = meldung.PublicId,
            Nummer = "05151 12345",
        };
        kontakt.TempData[MeldenModel.ConfirmationKey] = $"Meldungs-Nr. {meldung.CorrelationId}";
        await kontakt.OnPostAsync(CancellationToken.None);
        Assert.True(kontakt.Gespeichert);
        var gespeichert = await db.LageKontakte.SingleAsync(k => k.Id == kontakt.Vorgang);
        Assert.Equal(meldung.PublicId, gespeichert.MeldungId);
        Assert.False(gespeichert.Rueckruf);
        var liste = await Data(s.Leitstelle,
            "query($id: UUID!) { lageKontakte(lageId: $id, offeneRueckrufe: true) { id } }",
            new Dictionary<string, object?> { ["id"] = s.LageId });
        Assert.Empty(liste.GetProperty("lageKontakte").EnumerateArray());
    }

    private Task<JsonElement> EinheitZuweisen(ClaimsPrincipal caller, Guid ausfuehrungId, Guid? einheitId) =>
        Mutation(caller, "meldungEinheitZuweisen", "MeldungEinheitZuweisenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["einheitId"] = einheitId });

    private Task<JsonElement> Fortsetzen(ClaimsPrincipal caller, Guid ausfuehrungId, string aktion) =>
        Mutation(caller, "meldungFortsetzen", "MeldungFortsetzenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["aktion"] = aktion });

    private Task<JsonElement> Abgeben(ClaimsPrincipal caller, Guid ausfuehrungId, string grund, string? kommentar) =>
        Mutation(caller, "meldungAnLeitstelleAbgeben", "MeldungAnLeitstelleAbgebenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["grund"] = grund, ["kommentar"] = kommentar });

    private Task<JsonElement> ExternUebergeben(ClaimsPrincipal caller, Guid ausfuehrungId, string stelle) =>
        Mutation(caller, "meldungExternUebergeben", "MeldungExternUebergebenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["stelle"] = stelle, ["kommentar"] = "Radlader nötig" });

    private Task<JsonElement> NotfallPruefen(ClaimsPrincipal caller, Guid ausfuehrungId, string ergebnis) =>
        Mutation(caller, "meldungNotfallPruefen", "MeldungNotfallPruefenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["ergebnis"] = ergebnis });

    private Task<JsonElement> Meldeweg(ClaimsPrincipal caller, Guid lageId, bool offen) =>
        Mutation(caller, "setLageMeldeweg", "SetLageMeldewegInput",
            new() { ["lageId"] = lageId, ["offen"] = offen }, "lage { meldewegPausiertSeit }");

    private Task<JsonElement> Umverteilen(ClaimsPrincipal caller, Guid ausfuehrungId, Guid gruppeId) =>
        Mutation(caller, "meldungUmverteilen", "MeldungUmverteilenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["mitarbeiterGruppeId"] = gruppeId });

    private Task<JsonElement> Verwerfen(ClaimsPrincipal caller, Guid ausfuehrungId, string begruendung) =>
        Mutation(caller, "meldungVerwerfen", "MeldungVerwerfenInput",
            new() { ["ausfuehrungId"] = ausfuehrungId, ["begruendung"] = begruendung });

    private async Task<Guid> CreateEinheit(ClaimsPrincipal caller, Guid gruppeId, string name) {
        var payload = Ok(await Mutation(caller, "createEinheit", "CreateEinheitInput",
            new() { ["name"] = name, ["mitarbeiterGruppeId"] = gruppeId }, "einheit { id name }"));
        return payload.GetProperty("einheit").GetProperty("id").GetGuid();
    }

    [Fact]
    public async Task Report_gets_a_meldungsnummer_and_only_its_einsatzleitung_and_the_leitstelle_see_it() {
        var s = await SeedSzenario();

        var meldung = Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId));
        Assert.True(meldung.GetProperty("meldungsnummer").GetInt32() >= 1000);
        Assert.Equal("EINGEGANGEN", meldung.GetProperty("ereignisStatus").GetString());
        Assert.Single(await LageMeldungen(s.West, s.LageId));
        Assert.Empty(await LageMeldungen(s.Ost, s.LageId));
    }

    [Fact]
    public async Task Einheit_then_hilfe_then_abschluss_moves_dashboard_and_citizen_status() {
        var s = await SeedSzenario();
        var einheitId = await CreateEinheit(s.West, s.EinsatzleitungWest.Id, "HLF 20");

        var zugewiesen = Ok(await EinheitZuweisen(s.West, s.AusfuehrungId, einheitId)).GetProperty("ausfuehrung");
        Assert.Equal("ZUGEWIESEN", zugewiesen.GetProperty("ereignisStatus").GetString());
        Assert.Equal("HLF 20", zugewiesen.GetProperty("einheit").GetProperty("name").GetString());
        Assert.Equal("IN_BEARBEITUNG", await BuergerStatus(s.CorrelationId));

        Ok(await Fortsetzen(s.West, s.AusfuehrungId, "HILFE_EINLEITEN"));
        Assert.Equal("IN_BEARBEITUNG", await EreignisStatus(s));
        Assert.Equal("HILFE_UNTERWEGS", await BuergerStatus(s.CorrelationId));

        Ok(await Fortsetzen(s.West, s.AusfuehrungId, "EINSATZ_ABSCHLIESSEN"));
        Assert.Equal("ERLEDIGT", await EreignisStatus(s));
        Assert.Equal("ABGESCHLOSSEN", await BuergerStatus(s.CorrelationId));
    }

    [Fact]
    public async Task Einsatz_abschliessen_right_after_assignment_initiates_help_first() {
        var s = await SeedSzenario();
        Ok(await EinheitZuweisen(s.West, s.AusfuehrungId, await CreateEinheit(s.West, s.EinsatzleitungWest.Id, "TLF")));

        Ok(await Fortsetzen(s.West, s.AusfuehrungId, "EINSATZ_ABSCHLIESSEN"));

        Assert.Equal("ERLEDIGT", await EreignisStatus(s));
    }

    [Fact]
    public async Task Einheit_of_another_einsatzleitung_cannot_be_assigned() {
        var s = await SeedSzenario();
        var fremdeEinheit = await CreateEinheit(s.Ost, s.EinsatzleitungOst.Id, "RW Ost");

        Fails(await EinheitZuweisen(s.West, s.AusfuehrungId, fremdeEinheit),
            "EinheitGehoertNichtZurEinsatzleitungError");
        Fails(await EinheitZuweisen(s.Ost, s.AusfuehrungId, fremdeEinheit), "MeldungNotFoundError");
    }

    [Fact]
    public async Task Abgegebene_meldung_waits_in_klaerung_until_the_leitstelle_hands_it_to_another_einsatzleitung() {
        var s = await SeedSzenario();
        Fails(await Abgeben(s.West, s.AusfuehrungId, "SONSTIGES", "  "), "BegruendungErforderlichError");

        var abgegeben = Ok(await Abgeben(s.West, s.AusfuehrungId, "AUSRUESTUNG_FEHLT", "Kettensäge fehlt"))
            .GetProperty("ausfuehrung");
        Assert.Equal("IN_KLAERUNG", abgegeben.GetProperty("ereignisStatus").GetString());
        Assert.Equal("AUSRUESTUNG_FEHLT", abgegeben.GetProperty("klaerungGrund").GetString());
        Assert.Equal("Kettensäge fehlt", abgegeben.GetProperty("klaerungKommentar").GetString());
        Fails(await EinheitZuweisen(s.West, s.AusfuehrungId, null), "MeldungInKlaerungError");
        Fails(await Umverteilen(s.West, s.AusfuehrungId, s.EinsatzleitungOst.Id), "NotAllowedError");

        var umverteilt = Ok(await Umverteilen(s.Leitstelle, s.AusfuehrungId, s.EinsatzleitungOst.Id))
            .GetProperty("ausfuehrung");

        Assert.Equal("EINGEGANGEN", umverteilt.GetProperty("ereignisStatus").GetString());
        Assert.Equal(JsonValueKind.Null, umverteilt.GetProperty("klaerungSeit").ValueKind);
        Assert.Equal(JsonValueKind.Null, umverteilt.GetProperty("klaerungGrund").ValueKind);
        Assert.Equal(s.EinsatzleitungOst.Id,
            umverteilt.GetProperty("istZustaendigkeit").GetProperty("mitarbeiterGruppeId").GetGuid());
        Assert.Empty(await LageMeldungen(s.West, s.LageId));
        Assert.Single(await LageMeldungen(s.Ost, s.LageId));
    }

    [Fact]
    public async Task Only_the_leitstelle_can_discard_a_report_and_it_needs_a_reason() {
        var s = await SeedSzenario();
        Fails(await Verwerfen(s.West, s.AusfuehrungId, "Doppelt"), "NotAllowedError");
        Fails(await Verwerfen(s.Leitstelle, s.AusfuehrungId, ""), "BegruendungErforderlichError");

        var verworfen = Ok(await Verwerfen(s.Leitstelle, s.AusfuehrungId, "Doppelt gemeldet"))
            .GetProperty("ausfuehrung");

        Assert.Equal("VERWORFEN", verworfen.GetProperty("ereignisStatus").GetString());
        Assert.Equal("ABGESCHLOSSEN", await BuergerStatus(s.CorrelationId));
        Assert.Empty(await LageMeldungen(s.Leitstelle, s.LageId, offen: true));
        Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId, offen: false));
        Fails(await Verwerfen(s.Leitstelle, s.AusfuehrungId, "Nochmal"), "MeldungAbgeschlossenError");
    }

    [Fact]
    public async Task Citizens_confirm_an_open_report_and_everyone_sees_the_count() {
        var s = await SeedSzenario();
        var publicId = (await PublicMeldung()).GetProperty("id").GetGuid();

        await Bestaetigen(publicId, null);
        var zweite = Ok(await Bestaetigen(publicId, [FakeFoto]));

        Assert.Equal(2, zweite.GetProperty("meldungBestaetigenResult").GetProperty("anzahlBestaetigungen").GetInt32());
        var oeffentlich = await PublicMeldung();
        Assert.Equal(2, oeffentlich.GetProperty("anzahlBestaetigungen").GetInt32());
        Assert.Equal("Unwetter", oeffentlich.GetProperty("kategorie").GetString());
        Assert.Equal(2, Assert.Single(await LageMeldungen(s.West, s.LageId))
            .GetProperty("anzahlBestaetigungen").GetInt32());
        Fails(await Bestaetigen(publicId, [FakeFoto, FakeFoto, FakeFoto, FakeFoto]), "ZuVieleDateienError");
        Fails(await Bestaetigen(Guid.NewGuid(), null), "MeldungNotFoundError");

        async Task<JsonElement> PublicMeldung() {
            ActAnonymously();
            var data = await Data(null, """
                query($kommuneId: UUID!) {
                  activeLagen(kommuneId: $kommuneId) { id meldungen { id kategorie anzahlBestaetigungen } }
                }
                """, new Dictionary<string, object?> { ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id });
            return data.GetProperty("activeLagen").EnumerateArray()
                .Single(l => l.GetProperty("id").GetGuid() == s.LageId)
                .GetProperty("meldungen")[0].Clone();
        }
    }

    private Task<JsonElement> Bestaetigen(Guid publicId, string[]? fotos) {
        ActAnonymously();
        return Mutation(null, "meldungBestaetigen", "MeldungBestaetigenInput",
            new() { ["publicId"] = publicId, ["fotos"] = fotos is null ? null : JsonSerializer.SerializeToElement(fotos) },
            "meldungBestaetigenResult { anzahlBestaetigungen }");
    }

    [Fact]
    public async Task Closing_the_lage_ends_reporting_and_confirmations() {
        var s = await SeedSzenario();
        Ok(await Mutation(s.Leitstelle, "updateLageWarningText", "UpdateLageWarningTextInput",
            new() { ["lageId"] = s.LageId, ["warningText"] = "Hier melden statt 112 anrufen." }, "lage { id }"));
        var stored = await lageSeeder.StoredLage(s.LageId);
        Assert.Equal("Hier melden statt 112 anrufen.", stored!.WarningText);

        var closed = Ok(await Mutation(s.Leitstelle, "closeLage", "CloseLageInput", new() { ["lageId"] = s.LageId },
            "lage { status gebiete { status } }")).GetProperty("lage");

        Assert.Equal("CLOSED", closed.GetProperty("status").GetString());
        Assert.All(closed.GetProperty("gebiete").EnumerateArray(),
            g => Assert.Equal("ENDED", g.GetProperty("status").GetString()));
        Fails(await Mutation(s.Leitstelle, "closeLage", "CloseLageInput", new() { ["lageId"] = s.LageId },
            "lage { id }"), "LageClosedError");
        Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId, offen: true));

        await using var scope = Factory.Services.CreateAsyncScope();
        var publicId = await scope.ServiceProvider.GetRequiredService<DomainContext>().Ausfuehrungen
            .Where(a => a.Id == s.AusfuehrungId).Select(a => a.PublicId!.Value).SingleAsync();
        Fails(await Bestaetigen(publicId, null), "LageGebietNotLiveError");
    }
    [Fact]
    public async Task A_reason_other_than_sonstiges_needs_no_comment() {
        var s = await SeedSzenario();

        var abgegeben = Ok(await Abgeben(s.West, s.AusfuehrungId, "KEINE_EINHEIT_FREI", null))
            .GetProperty("ausfuehrung");

        Assert.Equal("KEINE_EINHEIT_FREI", abgegeben.GetProperty("klaerungGrund").GetString());
        Assert.Equal(JsonValueKind.Null, abgegeben.GetProperty("klaerungKommentar").ValueKind);
    }

    [Fact]
    public async Task Leitstelle_hands_a_report_to_the_bauhof_which_closes_it() {
        var s = await SeedSzenario();
        Ok(await Abgeben(s.West, s.AusfuehrungId, "KEIN_FALL_FUER_FEUERWEHR", null));
        Fails(await ExternUebergeben(s.West, s.AusfuehrungId, "BAUHOF"), "NotAllowedError");

        var uebergeben = Ok(await ExternUebergeben(s.Leitstelle, s.AusfuehrungId, "BAUHOF")).GetProperty("ausfuehrung");

        Assert.Equal("EXTERN_UEBERGEBEN", uebergeben.GetProperty("ereignisStatus").GetString());
        Assert.Equal("BAUHOF", uebergeben.GetProperty("externeStelle").GetString());
        Assert.Equal("Radlader nötig", uebergeben.GetProperty("externKommentar").GetString());
        Assert.Equal("ABGESCHLOSSEN", await BuergerStatus(s.CorrelationId));
        Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId, offen: false));
    }

    [Fact]
    public async Task New_reports_get_a_rule_based_class_and_equipment_which_the_einsatzleitung_can_correct() {
        var s = await SeedSzenario("Baum liegt quer über der Fahrbahn");
        var meldung = Assert.Single(await LageMeldungen(s.West, s.LageId));
        Assert.Equal("A", meldung.GetProperty("klasse").GetString());
        Assert.Equal(["Motorkettensäge"],
            meldung.GetProperty("benoetigteAusruestung").EnumerateArray().Select(a => a.GetString()));
        Assert.False(meldung.GetProperty("moeglicherNotfall").GetBoolean());

        var korrigiert = Ok(await Mutation(s.West, "meldungEinschaetzungSetzen", "MeldungEinschaetzungSetzenInput",
            new() {
                ["ausfuehrungId"] = s.AusfuehrungId,
                ["klasse"] = "C",
                ["benoetigteAusruestung"] = new[] { "Motorkettensäge", " Absperrung " },
            })).GetProperty("ausfuehrung");

        Assert.Equal("C", korrigiert.GetProperty("klasse").GetString());
        Assert.Equal(["Motorkettensäge", "Absperrung"],
            korrigiert.GetProperty("benoetigteAusruestung").EnumerateArray().Select(a => a.GetString()));
    }

    [Fact]
    public async Task A_possible_emergency_is_flagged_and_only_the_leitstelle_resolves_it() {
        var s = await SeedSzenario("Baum aufs Haus gefallen, Nachbarin noch drin");
        var meldung = Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId));
        Assert.True(meldung.GetProperty("moeglicherNotfall").GetBoolean());
        Assert.Equal("A", meldung.GetProperty("klasse").GetString());
        Fails(await NotfallPruefen(s.West, s.AusfuehrungId, "KEIN_NOTFALL"), "NotAllowedError");

        var geprueft = Ok(await NotfallPruefen(s.Leitstelle, s.AusfuehrungId, "KEIN_NOTFALL")).GetProperty("ausfuehrung");
        Assert.Equal("KEIN_NOTFALL", geprueft.GetProperty("notfallPruefung").GetString());
        Assert.Equal("EINGEGANGEN", geprueft.GetProperty("ereignisStatus").GetString());

        var anEls = Ok(await NotfallPruefen(s.Leitstelle, s.AusfuehrungId, "AN_ELS_UEBERGEBEN"))
            .GetProperty("ausfuehrung");
        Assert.Equal("EXTERN_UEBERGEBEN", anEls.GetProperty("ereignisStatus").GetString());
        Assert.Equal("ELS", anEls.GetProperty("externeStelle").GetString());
    }

    [Fact]
    public async Task Taking_the_meldeweg_offline_stops_reports_and_confirmations_until_it_is_back_online() {
        var s = await SeedSzenario();
        Fails(await Meldeweg(s.West, s.LageId, false), "NotAllowedError");

        var offline = Ok(await Meldeweg(s.Leitstelle, s.LageId, false)).GetProperty("lage");
        Assert.NotEqual(JsonValueKind.Null, offline.GetProperty("meldewegPausiertSeit").ValueKind);
        Assert.DoesNotContain(await ActiveLageIds(), id => id == s.LageId);
        Fails(await Bestaetigen(await PublicIdOf(s.AusfuehrungId), null), "LageGebietNotLiveError");
        Assert.Single(await LageMeldungen(s.Leitstelle, s.LageId, offen: true));

        var online = Ok(await Meldeweg(s.Leitstelle, s.LageId, true)).GetProperty("lage");
        Assert.Equal(JsonValueKind.Null, online.GetProperty("meldewegPausiertSeit").ValueKind);
        Assert.Contains(await ActiveLageIds(), id => id == s.LageId);
        Ok(await Bestaetigen(await PublicIdOf(s.AusfuehrungId), null));
    }

    [Fact]
    public async Task A_new_einheit_gets_the_standard_equipment_of_its_vehicle_type_unless_given() {
        var s = await SeedSzenario();

        var standard = Ok(await Mutation(s.West, "createEinheit", "CreateEinheitInput",
            new() { ["name"] = "DLK 23/12 West", ["mitarbeiterGruppeId"] = s.EinsatzleitungWest.Id },
            "einheit { ausruestung }")).GetProperty("einheit");
        var eigene = Ok(await Mutation(s.West, "createEinheit", "CreateEinheitInput",
            new() {
                ["name"] = "Bagger West",
                ["mitarbeiterGruppeId"] = s.EinsatzleitungWest.Id,
                ["ausruestung"] = new[] { "Radlader" },
            }, "einheit { ausruestung }")).GetProperty("einheit");

        Assert.Equal(["Drehleiter", "Motorkettensäge", "Absperrung"],
            standard.GetProperty("ausruestung").EnumerateArray().Select(a => a.GetString()));
        Assert.Equal(["Radlader"], eigene.GetProperty("ausruestung").EnumerateArray().Select(a => a.GetString()));
    }

    [Fact]
    public async Task Einsatzleitung_edits_and_deletes_its_own_einheiten_only() {
        var s = await SeedSzenario();
        var hlf = await CreateEinheit(s.West, s.EinsatzleitungWest.Id, "HLF 20 West");
        await CreateEinheit(s.West, s.EinsatzleitungWest.Id, "TLF West");
        Ok(await EinheitZuweisen(s.West, s.AusfuehrungId, hlf));

        Task<JsonElement> Update(ClaimsPrincipal caller, string? name, string[]? ausruestung) =>
            Mutation(caller, "updateEinheit", "UpdateEinheitInput",
                new() { ["einheitId"] = hlf, ["name"] = name, ["ausruestung"] = ausruestung },
                "einheit { name ausruestung }");

        var geaendert = Ok(await Update(s.West, " HLF 10 West ", [" Pumpe", "Seilwinde", "Pumpe"]))
            .GetProperty("einheit");
        Assert.Equal("HLF 10 West", geaendert.GetProperty("name").GetString());
        Assert.Equal(["Pumpe", "Seilwinde"],
            geaendert.GetProperty("ausruestung").EnumerateArray().Select(a => a.GetString()));
        Assert.Equal("HLF 10 West",
            Ok(await Update(s.Leitstelle, null, [])).GetProperty("einheit").GetProperty("name").GetString());
        Fails(await Update(s.West, "TLF West", null), "EinheitNameVergebenError");
        Fails(await Update(s.West, " ", null), "EinheitNameErforderlichError");
        Fails(await Update(s.Ost, "Fremd", null), "NotAllowedError");

        Ok(await Mutation(s.West, "deleteEinheit", "DeleteEinheitInput", new() { ["einheitId"] = hlf },
            "einheit { id }"));
        var meldung = Assert.Single(await LageMeldungen(s.West, s.LageId));
        Assert.Equal(JsonValueKind.Null, meldung.GetProperty("einheit").ValueKind);
        Assert.Equal("EINGEGANGEN", meldung.GetProperty("ereignisStatus").GetString());
    }

    private async Task<Guid[]> ActiveLageIds() {
        ActAnonymously();
        var data = await Data(null, "query($kommuneId: UUID!) { activeLagen(kommuneId: $kommuneId) { id } }",
            new Dictionary<string, object?> { ["kommuneId"] = KommuneSeeder.LandkreisHaPy.Id });
        return data.GetProperty("activeLagen").EnumerateArray().Select(l => l.GetProperty("id").GetGuid()).ToArray();
    }

    private async Task<Guid> PublicIdOf(Guid ausfuehrungId) {
        await using var scope = Factory.Services.CreateAsyncScope();
        return await scope.ServiceProvider.GetRequiredService<DomainContext>().Ausfuehrungen
            .Where(a => a.Id == ausfuehrungId).Select(a => a.PublicId!.Value).SingleAsync();
    }
}
