using System.Net;
using System.Text.Json;
using API.Features;
using API.Features.Auth;
using API.Features.Email;
using API.Features.Email.Templates.MaengelMeldung;
using API.Features.PdfGenerator;
using API.Features.Prozess;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using NodaTime;

namespace UnitTests;

public class AusfuehrungPdfTemplateTests {
    private static BlazorRenderer CreateRenderer() {
        var services = new ServiceCollection()
            .AddSingleton<IConfiguration>(new ConfigurationBuilder().Build())
            .AddSingleton<ILoggerFactory>(NullLoggerFactory.Instance)
            .AddSingleton(typeof(ILogger<>), typeof(NullLogger<>))
            .AddSingleton<PdfImageService>()
            .BuildServiceProvider();
        return new BlazorRenderer(new HtmlRenderer(services, NullLoggerFactory.Instance));
    }

    private static async Task<string> RenderHeader(PdfZustaendigkeit zustaendigkeit) =>
        WebUtility.HtmlDecode(await CreateRenderer().RenderComponent<PDFHeader>(new Dictionary<string, object?> {
            { nameof(PDFHeader.ProzessName), "Mängelmelder" },
            { nameof(PDFHeader.AusfuehrungId), Guid.NewGuid() },
            { nameof(PDFHeader.Zustaendigkeit), zustaendigkeit },
        }));

    [Fact]
    public async Task HeaderShowsOrganisationseinheitAndAbteilung() {
        var html = await RenderHeader(new PdfZustaendigkeit("Bauamt", "Tiefbau", null));

        Assert.Contains("Organisationseinheit: Bauamt · Abteilung: Tiefbau", html);
        Assert.DoesNotContain("Dienstleister", html);
    }

    [Fact]
    public async Task HeaderShowsDienstleister() {
        var html = await RenderHeader(new PdfZustaendigkeit(null, null, "Stadtwerke"));

        Assert.Contains("Dienstleister: Stadtwerke", html);
        Assert.DoesNotContain("Organisationseinheit", html);
    }

    [Fact]
    public async Task HeaderShowsNoZustaendigkeitForBuerger() {
        var html = await RenderHeader(PdfZustaendigkeit.None);

        Assert.DoesNotContain("Organisationseinheit", html);
        Assert.DoesNotContain("Abteilung", html);
        Assert.DoesNotContain("Dienstleister", html);
    }

    [Fact]
    public void FromLoadedIgnoresNavigationsOfOtherArt() {
        var zustaendigkeit = new Zustaendigkeit {
            Art = ZustaendigkeitArt.Buerger,
            Dienstleister = new API.Features.Dienstleistungen.Dienstleister { Name = "Stadtwerke", EMailAdressen = [] },
        };

        Assert.Equal(PdfZustaendigkeit.None, PdfZustaendigkeit.FromLoaded(zustaendigkeit));
    }

    [Fact]
    public async Task BodyOmitsMitarbeiterName() {
        var schritt = new FormularSchritt { Titel = "Meldung", Felder = [] };
        var bearbeitung = new Bearbeitung {
            Schritt = schritt,
            User = new BackofficeUser { Vorname = "Erika", Nachname = "Mustermann" },
            UserId = Guid.NewGuid(),
            SlotValues = [],
            CreatedAt = Instant.FromUnixTimeSeconds(0),
        };

        var html = await CreateRenderer().RenderComponent<PDF>(new Dictionary<string, object?> {
            { nameof(PDF.Bearbeitungen), new List<Bearbeitung> { bearbeitung } },
        });

        Assert.Contains("Meldung", html);
        Assert.DoesNotContain("Mustermann", html);
    }

    private static PlainSlotValue LocationValue(string slotName, double longitude, double latitude) => new() {
        SlotName = slotName,
        Value = JsonSerializer.SerializeToElement(new {
            addressString = "Osterstraße 1, Hameln",
            coordinates = new[] { longitude, latitude },
        }),
    };

    private static LocationFormularFeld LocationFeld(string slotName, int order = 0) =>
        new() { SlotName = slotName, AngezeigterName = "Standort", Order = order };

    private static Bearbeitung FormularBearbeitung(IEnumerable<FormularFeld> felder, IEnumerable<SlotValue> slotValues) =>
        new() {
            Schritt = new FormularSchritt { Titel = "Meldung", Felder = [.. felder] },
            User = new BackofficeUser { Vorname = "Erika", Nachname = "Mustermann" },
            UserId = Guid.NewGuid(),
            SlotValues = [.. slotValues],
            CreatedAt = Instant.FromUnixTimeSeconds(0),
        };

    private static async Task<string> RenderBody(Bearbeitung bearbeitung,
        IReadOnlyDictionary<string, string> mapImagesBySlotName) =>
        WebUtility.HtmlDecode(await CreateRenderer().RenderComponent<PDF>(new Dictionary<string, object?> {
            { nameof(PDF.Bearbeitungen), new List<Bearbeitung> { bearbeitung } },
            { nameof(PDF.MapImagesBySlotName), mapImagesBySlotName },
        }));

    [Fact]
    public async Task BodyShowsMapWithAttributionUnderLocation() {
        var bearbeitung = FormularBearbeitung([LocationFeld("standort")], [LocationValue("standort", 9.3553, 52.1037)]);

        var html = await RenderBody(bearbeitung,
            new Dictionary<string, string> { { "standort", "data:image/png;base64,AAAA" } });

        Assert.Contains("src=\"data:image/png;base64,AAAA\"", html);
        Assert.Contains("© OpenStreetMap-Mitwirkende", html);
        Assert.Contains("<meta charset=\"utf-8\"", html);
        Assert.Contains("Osterstraße 1, Hameln", html);
        Assert.Contains("9.3553", html);
    }

    [Fact]
    public async Task BodyShowsNoMapWithoutMapImage() {
        var bearbeitung = FormularBearbeitung([LocationFeld("standort")], [LocationValue("standort", 9.3553, 52.1037)]);

        var html = await RenderBody(bearbeitung, new Dictionary<string, string>());

        Assert.DoesNotContain("<img", html);
        Assert.DoesNotContain("OpenStreetMap", html);
        Assert.Contains("Osterstraße 1, Hameln", html);
    }

    [Fact]
    public async Task RendersOneMapPerDistinctCoordinate() {
        var withoutCoordinates = new PlainSlotValue {
            SlotName = "ohneKoordinaten",
            Value = JsonSerializer.SerializeToElement(new { addressString = "Irgendwo" }),
        };
        var encrypted = new EncryptedSlotValue { SlotName = "verschluesselt", Value = new EncryptedValue("n", "t", "c") };
        var bearbeitung = FormularBearbeitung(
            [
                LocationFeld("standort", 0), LocationFeld("treffpunkt", 1), LocationFeld("berlin", 2),
                LocationFeld("ohneKoordinaten", 3), LocationFeld("verschluesselt", 4),
            ],
            [
                LocationValue("standort", 9.3553, 52.1037), LocationValue("treffpunkt", 9.3553, 52.1037),
                LocationValue("berlin", 13.405, 52.52), withoutCoordinates, encrypted,
            ]);
        var tiles = new FakeTileHandler();

        var maps = await AusfuehrungHtml.RenderMapImages([bearbeitung], tiles.CreateService(), "#1d4ed8");

        Assert.Equal(["berlin", "standort", "treffpunkt"], maps.Keys.Order());
        Assert.Same(maps["standort"], maps["treffpunkt"]);
        Assert.Contains(tiles.RequestedUrls, url => url.Contains("/16/34471/21616."));
        Assert.Contains(tiles.RequestedUrls, url => url.Contains("/16/35208/"));
        Assert.Equal(tiles.RequestedUrls.Count, tiles.RequestedUrls.Distinct().Count());
    }

    [Fact]
    public async Task MapFailureFailsTheExport() {
        var bearbeitung = FormularBearbeitung([LocationFeld("standort")], [LocationValue("standort", 9.3553, 52.1037)]);
        var tiles = new FakeTileHandler(_ => new HttpResponseMessage(HttpStatusCode.ServiceUnavailable));

        await Assert.ThrowsAsync<StaticMapException>(() =>
            AusfuehrungHtml.AusfuehrungToHtml(Guid.NewGuid(), "Mängelmelder", PdfZustaendigkeit.None, [bearbeitung],
                CreateRenderer(), tiles.CreateService(), null, null));
    }
}
