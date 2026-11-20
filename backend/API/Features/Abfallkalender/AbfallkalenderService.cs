using System.Xml.Serialization;
using API.Features.Abfallkalender.DTO;
using API.Options;
using Flurl;

namespace API.Features.Abfallkalender;

/// <summary>
/// Service für den Zugriff auf die Abfallkalender-Daten über die KAW-API.
/// </summary>
public class AbfallkalenderService {
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly KawHamelnOptions _options;

    /// <summary>
    /// Initialisiert den Service mit den erforderlichen Abhängigkeiten.
    /// </summary>
    /// <param name="httpClientFactory">Factory zur Erstellung von HTTP-Clients.</param>
    /// <param name="options">Konfigurationsoptionen für die KAW-API.</param>
    public AbfallkalenderService(IHttpClientFactory httpClientFactory, KawHamelnOptions options) {
        _httpClientFactory = httpClientFactory;
        _options = options;
    }

    /// <summary>
    /// Ruft eine Liste von Städten ab.
    /// </summary>
    /// <returns>Ein Array von Städten.</returns>
    public async Task<Stadt[]> GetOrte() {
        var url = new Url(_options.RestUrl);
        url.SetQueryParams(new { ApplicationName = KawApplicationNames.Orte, SubmitAction = KawActions.GetOrte });

        var response = await SendRequest(url);

        if (!response.IsSuccessStatusCode) {
            throw new Exception($"KAW request failed with status code {response.StatusCode}.");
        }

        var dto = await DeserializeKawResponse(response);
        return dto?.Servlet.Dialog.StaedteList?.StaedteListeNested.Staedte ?? Array.Empty<Stadt>();
    }

    /// <summary>
    /// Ruft eine Liste von Straßen basierend auf der Orts-ID ab.
    /// </summary>
    /// <param name="ortId">ID des Ortes.</param>
    /// <returns>Ein Array von Straßen.</returns>
    public async Task<DTO.Strasse[]> GetStrassenByOrtId(string ortId) {
        var url = new Url(_options.RestUrl);
        url.SetQueryParams(new {
            ApplicationName = KawApplicationNames.Orte,
            SubmitAction = KawActions.GetStrassenByOrtId,
            IDCITY = ortId,
        });

        var response = await SendRequest(url);
        if (!response.IsSuccessStatusCode) {
            throw new Exception($"KAW request failed with status code {response.StatusCode}.");
        }

        var dto = await DeserializeKawResponse(response);
        return dto?.Servlet.Dialog.StrassenList?.StrassenListNested.Strassen ?? Array.Empty<DTO.Strasse>();
    }

    /// <summary>
    /// Ruft eine Liste von Standorten basierend auf der Straßen-ID ab.
    /// </summary>
    /// <param name="strassenId">ID der Straße.</param>
    /// <returns>Ein Array von Standorten.</returns>
    public async Task<DTO.Standort[]> GetStandorteByStrassenId(string strassenId) {
        var url = new Url(_options.RestUrl);
        url.SetQueryParams(new {
            ApplicationName = KawApplicationNames.Orte,
            SubmitAction = KawActions.GetStandorteByStrasseId,
            IDSTREET = strassenId,
        });

        var response = await SendRequest(url);
        if (!response.IsSuccessStatusCode) {
            throw new Exception($"KAW request failed with status code {response.StatusCode}.");
        }

        var dto = await DeserializeKawResponse(response);
        return dto?.Servlet.Dialog.StandortList?.StandortListNested.Standorte ?? Array.Empty<DTO.Standort>();
    }

    /// <summary>
    /// Ruft eine Liste von Terminen für einen Standort und einen Zeitraum ab.
    /// </summary>
    /// <param name="standortId">ID des Standorts.</param>
    /// <param name="von">Startdatum des Zeitraums.</param>
    /// <param name="bis">Enddatum des Zeitraums.</param>
    /// <returns>Ein Array von Terminen oder null.</returns>
    public async Task<DTO.Termin[]?> GetTermine(string standortId, DateTime von, DateTime bis) {
        var url = new Url(_options.RestUrl);
        url.SetQueryParams(new {
            ApplicationName = KawApplicationNames.Termine,
            SubmitAction = KawActions.GetAbfuhrTermin,
            IDSTANDORT = standortId,
            From = von.ToString("yyyy-MM-dd"),
            Until = bis.ToString("yyyy-MM-dd"),
        });

        var response = await SendRequest(url);
        if (!response.IsSuccessStatusCode) {
            throw new Exception($"KAW request failed with status code {response.StatusCode}.");
        }

        var dto = await DeserializeKawResponse(response);

        return dto?.Servlet.Dialog.TerminList?.TerminListNested.Termine;
    }

    /// <summary>
    /// Ruft eine Liste von Fraktionen basierend auf der Standort-ID ab.
    /// </summary>
    /// <param name="standortId">ID des Standorts.</param>
    /// <returns>Ein Array von Fraktionen.</returns>
    public async Task<DTO.Fraktion[]> GetFraktionen(string standortId) {
        var url = new Url(_options.RestUrl);
        url.SetQueryParams(new {
            ApplicationName = KawApplicationNames.Fraktionen,
            SubmitAction = KawActions.GetFraktionen,
            IDSTANDORT = standortId
        });

        var response = await SendRequest(url);

        if (!response.IsSuccessStatusCode) {
            throw new Exception($"KAW request failed with status code {response.StatusCode}.");
        }

        var dto = await DeserializeKawResponse(response);
        return dto?.Servlet.Dialog.FraktionenList?.FraktionenListeNested.Fraktionen ?? Array.Empty<DTO.Fraktion>();
    }

    /// <summary>
    /// Deserialisiert die Antwort der KAW-API in ein KawXml-Objekt.
    /// </summary>
    /// <param name="response">HTTP-Antwort der API.</param>
    /// <returns>Ein KawXml-Objekt oder null.</returns>
    private static async Task<KawXml?> DeserializeKawResponse(HttpResponseMessage response) {
        var serializer = new XmlSerializer(typeof(KawXml));
        var deserialized = serializer.Deserialize(await response.Content.ReadAsStreamAsync());

        if (deserialized is KawXml kawXml) {
            return kawXml;
        }

        return null;
    }

    /// <summary>
    /// Sendet eine HTTP-Anfrage an die angegebene URL.
    /// </summary>
    /// <param name="url">URL der Anfrage.</param>
    /// <returns>Die HTTP-Antwort.</returns>
    private async Task<HttpResponseMessage> SendRequest(Url url) {
        using var client = _httpClientFactory.CreateClient("kaw-hameln");
        var message = new HttpRequestMessage(HttpMethod.Get, url);

        var response = await client.SendAsync(message);
        return response;
    }
}

/// <summary>
/// Stellt die möglichen Aktionen der KAW-API bereit.
/// </summary>
public static class KawActions {
    public const string GetOrte = "citiesRequest";
    public const string GetStrassenByOrtId = "streetsRequest";
    public static readonly string GetStandorteByStrasseId = "numbersRequest";
    public static readonly string GetFraktionen = "fraktionenRequest";
    public static readonly string GetAbfuhrTermin = "termineRequest";
}

/// <summary>
/// Stellt die Anwendungsnamen der KAW-API bereit.
/// </summary>
public static class KawApplicationNames {
    public const string Termine = "Abfuhrtermine";
    public const string Orte = "Locations";
    public const string Fraktionen = "AbfuhrtermineFraktionen";
}
