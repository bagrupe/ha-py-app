using API.Features.Auth;
using API.Features.Expressions;
using API.Features.Lage;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Features.Untereinheit;
using Microsoft.Extensions.DependencyInjection;
using static IntegrationTests.GebietEinsatzleitungSeeder;

namespace IntegrationTests;

/// <summary>
/// Each test seeds its own Kommune: the no-reset test DB keeps Gebiete of earlier tests, and those overlap.
/// </summary>
[Collection("Api Tests")]
public class GebietEinsatzleitungZustaendigkeitSchrittTest(BackendApiFactory factory) : GraphQLTests(factory) {
    private readonly GebietEinsatzleitungSeeder gebietSeeder = new(factory);
    private readonly LageSeeder lageSeeder = new(factory);

    private const string West = """{"type":"Polygon","coordinates":[[[9.0,52.0],[9.5,52.0],[9.5,52.5],[9.0,52.5],[9.0,52.0]]]}""";
    private const string East = """{"type":"Polygon","coordinates":[[[9.5,52.0],[10.0,52.0],[10.0,52.5],[9.5,52.5],[9.5,52.0]]]}""";
    private const string WestAndEast = """{"type":"Polygon","coordinates":[[[9.0,52.0],[10.0,52.0],[10.0,52.5],[9.0,52.5],[9.0,52.0]]]}""";

    private static readonly EvaluatingVisitor.ParsedLocation InWest = new(9.2, 52.2);
    private static readonly EvaluatingVisitor.ParsedLocation InEast = new(9.8, 52.2);
    private static readonly EvaluatingVisitor.ParsedLocation Outside = new(11.0, 52.2);

    private GebietEinsatzleitungZustaendigkeitSchritt Schritt =>
        Factory.Services.GetRequiredService<GebietEinsatzleitungZustaendigkeitSchritt>();

    private async Task<(Guid KommuneId, Untereinheit Untereinheit)> SeedKommuneMitUntereinheit() {
        var kommune = await gebietSeeder.SeedKommune();
        return (kommune.Id, await gebietSeeder.SeedUntereinheit(kommune.Id));
    }

    private async Task<(Gebiet Gebiet, MitarbeiterGruppe Einsatzleitung)> SeedGebietMitEinsatzleitung(
        Untereinheit untereinheit, string name, string geometry) {
        var einsatzleitung = NewMitarbeiterGruppe(untereinheit);
        await gebietSeeder.SeedMitarbeiterGruppen(untereinheit, einsatzleitung);
        var gebiet = NewGebiet(untereinheit.Id);
        gebiet.Name = name;
        gebiet.Geometry = geometry;
        await gebietSeeder.SeedGebiet(gebiet, einsatzleitung);
        return (gebiet, einsatzleitung);
    }

    [Fact]
    public async Task Assigns_the_einsatzleitung_of_the_gebiet_containing_the_standort() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        var (east, eastEinsatzleitung) = await SeedGebietMitEinsatzleitung(untereinheit, "East", East);

        var treffer = await Schritt.ErmittleEinsatzleitung(kommuneId, InEast);

        Assert.NotNull(treffer);
        Assert.Equal(east.Id, treffer.GebietId);
        Assert.Equal(ZustaendigkeitArt.Organisationseinheit, treffer.Zustaendigkeit.Art);
        Assert.Equal(untereinheit.Id, treffer.Zustaendigkeit.OrganisationseinheitId);
        Assert.Equal(eastEinsatzleitung.Id, treffer.Zustaendigkeit.MitarbeiterGruppeId);
    }

    [Fact]
    public async Task Returns_null_when_no_gebiet_contains_the_standort() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        await SeedGebietMitEinsatzleitung(untereinheit, "West", West);

        Assert.Null(await Schritt.ErmittleEinsatzleitung(kommuneId, Outside));
    }

    [Fact]
    public async Task Ignores_gebiete_of_other_kommunen() {
        var (_, fremdeUntereinheit) = await SeedKommuneMitUntereinheit();
        await SeedGebietMitEinsatzleitung(fremdeUntereinheit, "West", West);
        var (eigeneKommuneId, _) = await SeedKommuneMitUntereinheit();

        Assert.Null(await Schritt.ErmittleEinsatzleitung(eigeneKommuneId, InWest));
    }

    [Fact]
    public async Task Prefers_the_overlapping_gebiet_whose_lage_is_live() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        await SeedGebietMitEinsatzleitung(untereinheit, "A ohne Lage", WestAndEast);
        var (live, liveEinsatzleitung) = await SeedGebietMitEinsatzleitung(untereinheit, "B live", West);
        await lageSeeder.SeedLageForGebiet(live, "CalledOut, Ready, Live");

        var treffer = await Schritt.ErmittleEinsatzleitung(kommuneId, InWest);

        Assert.NotNull(treffer);
        Assert.True(treffer.LageIstLive);
        Assert.Equal(liveEinsatzleitung.Id, treffer.Zustaendigkeit.MitarbeiterGruppeId);
    }

    [Theory]
    [InlineData("CalledOut, Ready", false)]
    [InlineData("CalledOut, Ready, Live, Ended", false)]
    [InlineData("CalledOut, Ready, Live", true)]
    public async Task Counts_only_a_live_gebiet_as_accepting_meldungen(string path, bool expectedLive) {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (gebiet, _) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        await lageSeeder.SeedLageForGebiet(gebiet, path);

        var treffer = await Schritt.ErmittleEinsatzleitung(kommuneId, InWest);

        Assert.NotNull(treffer);
        Assert.Equal(expectedLive, treffer.LageIstLive);
    }

    [Fact]
    public async Task Does_not_count_a_live_gebiet_of_a_closed_lage() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (gebiet, _) = await SeedGebietMitEinsatzleitung(untereinheit, "West", West);
        await lageSeeder.SeedLageForGebiet(gebiet, "CalledOut, Ready, Live", closed: true);

        var treffer = await Schritt.ErmittleEinsatzleitung(kommuneId, InWest);

        Assert.NotNull(treffer);
        Assert.False(treffer.LageIstLive);
    }

    [Fact]
    public async Task Skips_a_gebiet_whose_only_einsatzleitung_was_deleted() {
        var (kommuneId, untereinheit) = await SeedKommuneMitUntereinheit();
        var (_, geloeschteEinsatzleitung) = await SeedGebietMitEinsatzleitung(untereinheit, "A geloescht", WestAndEast);
        var (_, verbleibende) = await SeedGebietMitEinsatzleitung(untereinheit, "B aktiv", West);
        await gebietSeeder.DeleteMitarbeiterGruppe(geloeschteEinsatzleitung.Id);

        var treffer = await Schritt.ErmittleEinsatzleitung(kommuneId, InWest);

        Assert.NotNull(treffer);
        Assert.Equal(verbleibende.Id, treffer.Zustaendigkeit.MitarbeiterGruppeId);
    }
}
