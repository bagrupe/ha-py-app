using API.Options;

namespace API.Features.PdfGenerator;

/// <summary>Stellt Funktionen zum Erzeugen von PDFs über den Gotenberg-Dienst bereit.</summary>
public class GotenbergService(GotenbergOptions options, IHttpClientFactory httpClientFactory) {
    /// <summary>Sendet HTML- oder Dokumentinhalte an den Gotenberg-Server und erhält die PDF-Antwort.</summary>
    /// <param name="content">Der zu konvertierende Inhalt als HttpContent.</param>
    /// <param name="endpoint">Der Gotenberg-Endpunkt, der verwendet werden soll.</param>
    /// <param name="ct">Cancellation token for the current conversion.</param>
    /// <returns>Die HTTP-Antwort mit dem generierten PDF.</returns>
    public async Task<HttpResponseMessage> RenderToPdf(HttpContent content, GotenbergEndpoint endpoint,
        CancellationToken ct = default) {
        using var httpClient = httpClientFactory.CreateClient();

        var response = await httpClient.SendAsync(new HttpRequestMessage {
            RequestUri = new Uri(options.Url + GotenbergEndpointPath(endpoint)),
            Method = HttpMethod.Post,
            Content = content,
        }, ct);

        if (!response.IsSuccessStatusCode) {
            throw new InvalidOperationException(
                $"Gotenberg request failed with status code {response.StatusCode} and reason {await response.Content.ReadAsStringAsync(ct)}");
        }

        return response;
    }

    private static string GotenbergEndpointPath(GotenbergEndpoint endpoint) =>
        endpoint switch {
            GotenbergEndpoint.LibreOffice => "/forms/libreoffice/convert",
            GotenbergEndpoint.Chromium => "/forms/chromium/convert/html",
            _ => throw new ArgumentException("Invalid string value for endpoint", nameof(endpoint)),
        };
}

/// <summary>Definiert die verfügbaren Endpunkte des Gotenberg-Dienstes.</summary>
public enum GotenbergEndpoint {
    LibreOffice,
    Chromium
}
