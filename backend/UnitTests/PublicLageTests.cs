using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Lage;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Features.Untereinheit;
using API.Seeders.LageHelfer;
using HotChocolate;
using HotChocolate.Execution;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;
using static IntegrationTests.GebietEinsatzleitungSeeder;

namespace IntegrationTests;

/// <summary>Each test seeds its own Kommune, because the shared test database keeps Lagen of earlier tests.</summary>
[Collection("Api Tests")]
public class PublicLageTests(BackendApiFactory factory) : LageMeldungTestBase(factory) {
    private const string ActiveLagenQuery = """
        query ActiveLagen($kommuneId: UUID!) {
          activeLagen(kommuneId: $kommuneId) { id title warningText gebiete { id name geometry } }
        }
        """;

    private const string SuggestionQuery = """
        query Suggest($kommuneId: UUID!, $longitude: Float!, $latitude: Float!) {
          suggestedGebiete(kommuneId: $kommuneId, longitude: $longitude, latitude: $latitude) {
            lageId gebietId gebietName
          }
        }
        """;

    [Fact]
    public async Task ActiveLagen_lists_only_live_gebiete_of_open_lagen() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var aktiv = await lageSeeder.SeedLage(untereinheit.Id, "Aktiv", false, Live, "");
        await lageSeeder.SeedLage(untereinheit.Id, "Nur bereit", false, "CalledOut,Ready");
        await lageSeeder.SeedLage(untereinheit.Id, "Geschlossen", true, Live);

        ActAnonymously();
        var result = await ExecuteGraphqlAsync(null, ActiveLagenQuery,
            new Dictionary<string, object?> { ["kommuneId"] = kommuneId });

        Assert.True(result.Errors is null, result.ToJson());
        var lagen = JsonDocument.Parse(result.ToJson()).RootElement.GetProperty("data").GetProperty("activeLagen");
        var lage = Assert.Single(lagen.EnumerateArray());
        Assert.Equal(aktiv.Id, lage.GetProperty("id").GetGuid());
        var gebiet = Assert.Single(lage.GetProperty("gebiete").EnumerateArray());
        var livePass = aktiv.LageGebiete.Single(lg => lg.Status == LageGebietStatus.Live);
        Assert.Equal(livePass.GebietId, gebiet.GetProperty("id").GetGuid());
    }

    [Fact]
    public async Task SuggestedGebiete_returns_the_live_gebiet_containing_the_point() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (west, _) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var (east, _) = await SeedGebietMitEinsatzleitung(untereinheit, "East", East);
        var lageWest = await lageSeeder.SeedLageForGebiet(west, Live);
        await lageSeeder.SeedLageForGebiet(east, "CalledOut");

        ActAnonymously();
        var inWest = await Suggest(kommuneId, 9.2, 52.2);
        var inEast = await Suggest(kommuneId, 9.8, 52.2);

        var suggestion = Assert.Single(inWest.EnumerateArray());
        Assert.Equal(lageWest.Id, suggestion.GetProperty("lageId").GetGuid());
        Assert.Equal(west.Id, suggestion.GetProperty("gebietId").GetGuid());
        Assert.Empty(inEast.EnumerateArray());
    }

    [Fact]
    public async Task Report_with_chosen_gebiet_is_linked_and_routed_to_that_gebiet_not_the_standort() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var (east, eastEinsatzleitung) = await SeedGebietMitEinsatzleitung(untereinheit, "East", East);
        var lage = await lageSeeder.SeedLageForGebiet(east, Live);
        var meldeprozess = await SeedMeldeprozess(kommuneId, lageErforderlich: true);

        // The person reports from home in West about an event they chose to file under East.
        var create = await CreateAnonym(meldeprozess, new LageSelectionInput(lage.Id, east.Id), lng: 9.2, lat: 52.2);
        Assert.True(create.Errors is null, create.ToJson());
        Assert.DoesNotContain("Error\"", create.ToJson());

        await using var scope = Factory.Services.CreateAsyncScope();
        var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
        var ausfuehrung = await db.Ausfuehrungen.SingleAsync(a => a.ProzessVersionId == meldeprozess.VersionId);
        var pass = (await lageSeeder.StoredPasses(lage.Id, east.Id)).Single();
        Assert.Equal(pass.Id, ausfuehrung.LageGebietId);

        await RunZustaendigkeitsschritt(ausfuehrung.Id);

        var nachZuordnung = await scope.ServiceProvider.GetRequiredService<IDbContextFactory<DomainContext>>()
            .CreateDbContext().Ausfuehrungen.SingleAsync(a => a.Id == ausfuehrung.Id);
        Assert.Equal(eastEinsatzleitung.Id, nachZuordnung.IstZustaendigkeit.MitarbeiterGruppeId);
    }

    [Fact]
    public async Task Report_for_a_gebiet_that_is_not_live_is_rejected() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (west, _) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var lage = await lageSeeder.SeedLageForGebiet(west, "CalledOut,Ready");
        var meldeprozess = await SeedMeldeprozess(kommuneId);

        var create = await CreateAnonym(meldeprozess, new LageSelectionInput(lage.Id, west.Id), lng: 9.2, lat: 52.2);

        Assert.Null(create.Errors);
        Assert.Contains("LageGebietNotLiveError", create.ToJson());
        Assert.True(await NoAusfuehrungFor(meldeprozess.VersionId));
    }

    [Fact]
    public async Task Report_for_a_live_gebiet_of_another_kommune_is_rejected() {
        var (_, fremdeUntereinheit) = await SeedKommuneMitUntereinheit();
        var (fremdesGebiet, _) = await SeedGebietMitEinsatzleitung(fremdeUntereinheit, "Fremd", West);
        var fremdeLage = await lageSeeder.SeedLageForGebiet(fremdesGebiet, Live);
        var (kommuneId, _) = await SeedKommuneMitUntereinheit();
        var meldeprozess = await SeedMeldeprozess(kommuneId);

        var create = await CreateAnonym(meldeprozess, new LageSelectionInput(fremdeLage.Id, fremdesGebiet.Id),
            lng: 9.2, lat: 52.2);

        Assert.Contains("LageGebietNotLiveError", create.ToJson());
        Assert.True(await NoAusfuehrungFor(meldeprozess.VersionId));
    }

    [Fact]
    public async Task ActiveLagen_lists_open_meldungen_with_status_description_and_coordinates_only() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (west, _) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var lage = await lageSeeder.SeedLageForGebiet(west, Live);
        var meldeprozess = await SeedMeldeprozess(kommuneId, lageErforderlich: true);
        var auswahl = new LageSelectionInput(lage.Id, west.Id);
        Assert.Null((await CreateAnonym(meldeprozess, auswahl, 9.21, 52.21, "Keller überflutet")).Errors);
        Assert.Null((await CreateAnonym(meldeprozess, auswahl, 9.22, 52.22, "Schon erledigt")).Errors);
        await using (var scope = Factory.Services.CreateAsyncScope()) {
            await scope.ServiceProvider.GetRequiredService<DomainContext>().Ausfuehrungen
                .Where(a => a.ProzessVersionId == meldeprozess.VersionId && a.Status != AusfuehrungStatus.Abgeschlossen)
                .OrderByDescending(a => a.CreatedAt).Take(1)
                .ExecuteUpdateAsync(a => a.SetProperty(x => x.Status, AusfuehrungStatus.Abgeschlossen));
        }

        ActAnonymously();
        var result = await ExecuteGraphqlAsync(null, """
            query ActiveLagen($kommuneId: UUID!) {
              activeLagen(kommuneId: $kommuneId) { meldungen { status statusText description longitude latitude } }
            }
            """, new Dictionary<string, object?> { ["kommuneId"] = kommuneId });

        Assert.True(result.Errors is null, result.ToJson());
        var meldung = Assert.Single(JsonDocument.Parse(result.ToJson()).RootElement.GetProperty("data")
            .GetProperty("activeLagen")[0].GetProperty("meldungen").EnumerateArray());
        Assert.Equal("EINGEGANGEN", meldung.GetProperty("status").GetString());
        Assert.Equal("Meldung ist eingegangen", meldung.GetProperty("statusText").GetString());
        Assert.Equal("Keller überflutet", meldung.GetProperty("description").GetString());
        Assert.Equal(9.21, meldung.GetProperty("longitude").GetDouble());
        Assert.Equal(52.21, meldung.GetProperty("latitude").GetDouble());
    }

    [Fact]
    public async Task Report_with_up_to_three_photos_is_stored() {
        var (meldeprozess, auswahl) = await SeedLiveMeldeprozess();

        var create = await CreateAnonym(meldeprozess, auswahl, 9.2, 52.2, fotos: [FakeFoto, FakeFoto, FakeFoto]);

        Assert.True(create.Errors is null, create.ToJson());
        Assert.DoesNotContain("Error\"", create.ToJson());
        await using var scope = Factory.Services.CreateAsyncScope();
        var fotos = await scope.ServiceProvider.GetRequiredService<DomainContext>().PlainSlotValues
            .SingleAsync(sv => sv.SlotName == EreignismeldungVorlage.BilderSlot
                && sv.Bearbeitung.Ausfuehrung.ProzessVersionId == meldeprozess.VersionId);
        Assert.Equal(3, fotos.Value.GetArrayLength());
    }

    [Fact]
    public async Task Report_with_more_than_three_photos_is_rejected() {
        var (meldeprozess, auswahl) = await SeedLiveMeldeprozess();

        var create = await CreateAnonym(meldeprozess, auswahl, 9.2, 52.2,
            fotos: [FakeFoto, FakeFoto, FakeFoto, FakeFoto]);

        Assert.Null(create.Errors);
        Assert.Contains("ZuVieleDateienError", create.ToJson());
        Assert.True(await NoAusfuehrungFor(meldeprozess.VersionId));
    }

    [Fact]
    public async Task MeldungStatus_is_eingegangen_until_the_einsatzleitung_takes_the_report_over() {
        var (meldeprozess, auswahl) = await SeedLiveMeldeprozess();
        var create = await CreateAnonym(meldeprozess, auswahl, 9.2, 52.2);
        var correlationId = CorrelationIdOf(create);
        Assert.Equal("EINGEGANGEN", await AnonymerStatus(correlationId));

        await using (var scope = Factory.Services.CreateAsyncScope()) {
            var db = scope.ServiceProvider.GetRequiredService<DomainContext>();
            var ausfuehrungId = await db.Ausfuehrungen.Where(a => a.CorrelationId == correlationId)
                .Select(a => a.Id).SingleAsync();
            db.VerlaufsEintraege.Add(new VerlaufsEintrag {
                AusfuehrungId = ausfuehrungId,
                Art = VerlaufsEreignisArt.Uebernahme,
                CreatedAt = scope.ServiceProvider.GetRequiredService<IClock>().GetCurrentInstant(),
            });
            await db.SaveChangesAsync();
        }

        Assert.Equal("IN_BEARBEITUNG", await AnonymerStatus(correlationId));
    }

    private async Task<string?> AnonymerStatus(Guid correlationId) {
        ActAnonymously();
        var result = await ExecuteGraphqlAsync(null, """
            query Status($correlationId: UUID!) { ausfuehrungStatusAnonym(correlationId: $correlationId) { status } }
            """, new Dictionary<string, object?> { ["correlationId"] = correlationId });
        Assert.True(result.Errors is null, result.ToJson());
        return JsonDocument.Parse(result.ToJson()).RootElement.GetProperty("data")
            .GetProperty("ausfuehrungStatusAnonym").GetProperty("status").GetString();
    }

    [Fact]
    public async Task LageHelfer_report_without_lage_is_rejected() {
        var (kommuneId, _) = await SeedKommuneMitUntereinheit();
        var meldeprozess = await SeedMeldeprozess(kommuneId, lageErforderlich: true);

        var create = await CreateAnonym(meldeprozess, lage: null, lng: 9.2, lat: 52.2);

        Assert.Null(create.Errors);
        Assert.Contains("LageErforderlichError", create.ToJson());
        Assert.True(await NoAusfuehrungFor(meldeprozess.VersionId));
    }

    private async Task<JsonElement> Suggest(Guid kommuneId, double lng, double lat) {
        var result = await ExecuteGraphqlAsync(null, SuggestionQuery, new Dictionary<string, object?> {
            ["kommuneId"] = kommuneId,
            ["longitude"] = lng,
            ["latitude"] = lat,
        });
        Assert.True(result.Errors is null, result.ToJson());
        return JsonDocument.Parse(result.ToJson()).RootElement.GetProperty("data").GetProperty("suggestedGebiete")
            .Clone();
    }
}
