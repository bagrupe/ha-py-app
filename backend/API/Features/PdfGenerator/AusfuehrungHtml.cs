using System.Reflection;
using System.Text.Json;
using API.Features.Email;
using API.Features.Email.Templates.MaengelMeldung;
using API.Features.EmailForwarder;
using API.Features.Prozess;
using Path = System.IO.Path;

namespace API.Features.PdfGenerator;

/// <summary>Stellt Methoden zur Umwandlung einer Ausführung in HTML-Inhalte für die PDF-Erzeugung bereit.</summary>
public static class AusfuehrungHtml {
    /// <summary>Erzeugt MultipartFormDataContent mit HTML- und CSS-Dateien basierend auf einer Ausführung und deren Bearbeitungen.</summary>
    /// <param name="ausfuehrungId">Die Id der Ausführung.</param>
    /// <param name="prozessName">Der Name des Prozesses.</param>
    /// <param name="zustaendigkeit">Die zuständige Stelle, die in der Kopfzeile erscheint.</param>
    /// <param name="bearbeitungen">Liste der Bearbeitungen der Ausführung.</param>
    /// <param name="blazorRenderer">Renderer zum Erzeugen der HTML-Komponenten.</param>
    /// <param name="staticMapService">Erzeugt die Kartenbilder für Standortfelder.</param>
    /// <param name="primaryColor">Optionale Primärfarbe für das Design.</param>
    /// <param name="logoUrl">Optionale URL für das Logo.</param>
    /// <param name="ct">Cancellation token.</param>
    /// <returns>Ein MultipartFormDataContent mit den generierten HTML- und CSS-Dateien für die PDF-Erstellung.</returns>
    /// <exception cref="StaticMapException">Ein Kartenbild konnte nicht erzeugt werden.</exception>
    public static async Task<MultipartFormDataContent> AusfuehrungToHtml(
        Guid ausfuehrungId,
        string prozessName,
        PdfZustaendigkeit zustaendigkeit,
        List<Bearbeitung> bearbeitungen, BlazorRenderer blazorRenderer, StaticMapService staticMapService,
        string? primaryColor, string? logoUrl, CancellationToken ct = default) {
        var mapImagesBySlotName = await RenderMapImages(bearbeitungen, staticMapService, primaryColor, ct);
        var multipartFormDataContent = new MultipartFormDataContent();

        var outputCss = await File.ReadAllTextAsync(Path.Combine(
            Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!, "Features", "Email", "Templates",
            "CSS", "output.css"));
        multipartFormDataContent.Add(new StringContent(outputCss), "files", "output.css");


        var pdfHtml = await blazorRenderer.RenderComponent<PDF>(new Dictionary<string, object?> {
            { nameof(PDF.Bearbeitungen), bearbeitungen }, { nameof(PDF.PrimaryColor), primaryColor },
            { nameof(PDF.MapImagesBySlotName), mapImagesBySlotName },
        });
        multipartFormDataContent.Add(new StringContent(pdfHtml), "files", "index.html");

        var pdfHeaderHtml = await blazorRenderer.RenderComponent<PDFHeader>(new Dictionary<string, object?> {
            { nameof(PDFHeader.ProzessName), prozessName },
            { nameof(PDFHeader.AusfuehrungId), ausfuehrungId },
            { nameof(PDFHeader.LogoUrl), logoUrl },
            { nameof(PDFHeader.Zustaendigkeit), zustaendigkeit },
        });
        multipartFormDataContent.Add(new StringContent(pdfHeaderHtml), "files", "header.html");
        multipartFormDataContent.Add(new StringContent("1.3"), "marginTop");

        var pdfFooterHtml = await blazorRenderer.RenderComponent<PDFFooter>();
        multipartFormDataContent.Add(new StringContent(pdfFooterHtml), "files", "footer.html");
        multipartFormDataContent.Add(new StringContent("0.5"), "marginBottom");

        multipartFormDataContent.Add(new StringContent("true"), "pdfua");

        return multipartFormDataContent;
    }

    /// <summary>Renders one map per Location slot that has coordinates, keyed by slot name.</summary>
    /// <exception cref="StaticMapException">A map could not be rendered.</exception>
    public static async Task<Dictionary<string, string>> RenderMapImages(IEnumerable<Bearbeitung> bearbeitungen,
        StaticMapService staticMapService, string? pinColor, CancellationToken ct = default) {
        var mapsByCoordinates = new Dictionary<(double Longitude, double Latitude), string>();
        var mapsBySlotName = new Dictionary<string, string>();
        foreach (var bearbeitung in bearbeitungen) {
            if (bearbeitung.Schritt is not FormularSchritt formularSchritt) continue;

            foreach (var feld in formularSchritt.Felder.OfType<LocationFormularFeld>()) {
                if (bearbeitung.SlotValues.FirstOrDefault(sv => sv.SlotName == feld.SlotName) is not PlainSlotValue slotValue ||
                    ReadCoordinates(slotValue.Value) is not { } coordinates) {
                    continue;
                }

                if (!mapsByCoordinates.TryGetValue(coordinates, out var mapDataUri)) {
                    mapDataUri = await staticMapService.RenderPngDataUri(coordinates.Longitude, coordinates.Latitude,
                        pinColor, ct);
                    mapsByCoordinates[coordinates] = mapDataUri;
                }

                mapsBySlotName[feld.SlotName] = mapDataUri;
            }
        }

        return mapsBySlotName;
    }

    private static (double Longitude, double Latitude)? ReadCoordinates(JsonElement location) {
        if (location.ValueKind != JsonValueKind.Object ||
            !location.TryGetProperty("coordinates", out var coordinates) ||
            coordinates.ValueKind != JsonValueKind.Array || coordinates.GetArrayLength() < 2 ||
            coordinates[0].ValueKind != JsonValueKind.Number || coordinates[1].ValueKind != JsonValueKind.Number) {
            return null;
        }

        return (coordinates[0].GetDouble(), coordinates[1].GetDouble());
    }
}
