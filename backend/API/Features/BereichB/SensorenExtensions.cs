using API.Options;

namespace API.Features.BereichB;

/// <summary>
/// Definiert die verfügbaren Modi für die Historie eines Sensors.
/// </summary>
public enum HistoryMode {
    LastDay, LastWeek
}

/// <summary>
/// Erweiterungsmethoden für den HistoryMode, um ihn in eine Zeitdauer als String umzuwandeln.
/// </summary>
static class HistoryModeToStringExtensions {
    /// <summary>
    /// Wandelt den HistoryMode in einen entsprechenden Zeitdauer-String um.
    /// </summary>
    /// <param name="historyMode">Der zu konvertierende HistoryMode.</param>
    /// <returns>Die Zeitdauer als String.</returns>
    public static string ToDurationString(this HistoryMode historyMode) => historyMode switch {
        HistoryMode.LastDay => "24h",
        HistoryMode.LastWeek => "7d",
        _ => throw new ArgumentOutOfRangeException(nameof(historyMode), historyMode, null)
    };
}

/// <summary>
/// Repräsentiert einen Eintrag der Sensorhistorie, wie er von der API geliefert wird.
/// </summary>
record SensorHistorieEintragFromApi(string TimeIsoString, double Value);

/// <summary>
/// Repräsentiert einen Eintrag der Sensorhistorie mit Zeitstempel und Wert.
/// </summary>
public record SensorHistorieEintrag(DateTimeOffset Time, double Value);

/// <summary>
/// Bietet Erweiterungen für die Verarbeitung von Sensordaten.
/// </summary>
public class SensorenExtensions {
    /// <summary>
    /// Lädt die Historie eines Sensors basierend auf den angegebenen Parametern.
    /// </summary>
    /// <param name="sensorname">Der Name des Sensors.</param>
    /// <param name="feldname">Der Name des Feldes.</param>
    /// <param name="duration">Die gewünschte Zeitdauer der Historie.</param>
    /// <param name="fetch">Gibt an, ob die Daten abgerufen werden sollen.</param>
    /// <param name="loader">Der DataLoader zum Abrufen der Daten.</param>
    /// <returns>Eine Liste von Sensorhistorie-Einträgen.</returns>
    public async Task<List<SensorHistorieEintrag>> Historie(string sensorname, string feldname, HistoryMode duration, bool fetch,
        ISensorHistorieBySensorAndFeldnameDataLoader loader) {
        if (!fetch) return [];

        return await loader.LoadAsync((sensorname, feldname, duration));
    }

    /// <summary>
    /// Lädt die Sensorhistorie für eine Gruppe von Sensoren und Feldern.
    /// </summary>
    /// <param name="keys">Die Schlüssel, die Sensorname, Feldname und HistoryMode enthalten.</param>
    /// <param name="httpClientFactory">Die HttpClientFactory für HTTP-Anfragen.</param>
    /// <param name="bereichBOptions">Die Optionen für Bereich B.</param>
    /// <param name="ct">Das CancellationToken für die Anfrage.</param>
    /// <returns>Ein Dictionary mit den geladenen Historiedaten.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<(string Sensorname, string Feldname, HistoryMode HistoryMode),
            List<SensorHistorieEintrag>>>
        GetSensorHistorieBySensorAndFeldname(
            IReadOnlyList<(string Sensorname, string Feldname, HistoryMode HistoryMode)> keys,
            IHttpClientFactory httpClientFactory, BereichBOptions bereichBOptions, CancellationToken ct) {
        var client = httpClientFactory.CreateClient();
        client.BaseAddress = new Uri(bereichBOptions.ApiUrl + "/");

        var grouped = keys.GroupBy(k => (k.Sensorname, k.HistoryMode));
        var requests = grouped.Select(async g =>
            new {
                Felder = await GetFelderFromSensor(g.Key.Sensorname, g.Select(r => r.Feldname), g.Key.HistoryMode, client),
                g.Key.Sensorname,
                g.Key.HistoryMode,
            });
        var results = await Task.WhenAll(requests);

        var result =
            new Dictionary<(string Sensorname, string Feldname, HistoryMode HistoryMode),
                List<SensorHistorieEintrag>>();

        foreach (var historie in results) {
            var sensor = historie.Sensorname;
            var history = historie.HistoryMode;
            foreach (var feld in historie.Felder) {
                result[(sensor, feld.Key, history)] = feld.Value;
            }
        }

        return result;
    }

    /// <summary>
    /// Ruft die Felder eines Sensors für eine bestimmte Historie ab.
    /// </summary>
    /// <param name="sensorname">Der Name des Sensors.</param>
    /// <param name="feldnamen">Die Namen der Felder.</param>
    /// <param name="historyMode">Der Modus der Historie.</param>
    /// <param name="httpClient">Der HttpClient für die Anfrage.</param>
    /// <returns>Ein Dictionary mit den Feldern und ihren Historiedaten.</returns>
    private static async Task<IReadOnlyDictionary<string, List<SensorHistorieEintrag>>> GetFelderFromSensor(
        string sensorname, IEnumerable<string> feldnamen, HistoryMode historyMode, HttpClient httpClient) {
        var url =
            $"sensoren/{sensorname}/historie?feldnamen={string.Join(",", feldnamen)}&timeframe={historyMode.ToDurationString()}";
        var response = await httpClient.GetFromJsonAsync<Dictionary<string, List<SensorHistorieEintragFromApi>>>(url);

        return response?.Select(entry => new KeyValuePair<string, List<SensorHistorieEintrag>>(entry.Key,
                entry.Value.Select(eintrag =>
                    new SensorHistorieEintrag(DateTimeOffset.Parse(eintrag.TimeIsoString),
                        eintrag.Value)).ToList()))
            .ToDictionary() ?? new Dictionary<string, List<SensorHistorieEintrag>>();
    }
}
