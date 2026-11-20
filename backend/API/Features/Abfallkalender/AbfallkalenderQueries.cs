
namespace API.Features.Abfallkalender;

/// <summary>
/// Stellt Abfragen für den Abfallkalender bereit, um Daten wie Orte, Straßen, Standorte, Fraktionen und Termine abzurufen.
/// </summary>
[ExtendObjectType<Kommune.Kommune>]
public class AbfallkalenderQueries {
    /// <summary>
    /// Ruft eine Liste von Orten ab.
    /// </summary>
    /// <param name="abfallkalenderService">Service zum Abrufen der Ortsdaten.</param>
    /// <returns>Eine Liste von Orten mit ID und Name.</returns>
    public async Task<IEnumerable<Ort>> GetOrte([Service] AbfallkalenderService abfallkalenderService) {
        var orte = await abfallkalenderService.GetOrte();

        return orte.Select(stadt =>
            new Ort(
                stadt.Id.TrimStart(),
                stadt.Name));
    }

    /// <summary>
    /// Ruft eine Liste von Straßen basierend auf der Orts-ID ab.
    /// </summary>
    /// <param name="abfallkalenderService">Service zum Abrufen der Straßendaten.</param>
    /// <param name="ortId">ID des Ortes, für den die Straßen abgerufen werden sollen.</param>
    /// <returns>Eine Liste von Straßen mit ID und Name.</returns>
    public async Task<IEnumerable<Strasse>> GetStrassen([Service] AbfallkalenderService abfallkalenderService,
        string ortId) {
        var strassenByOrtId = await abfallkalenderService.GetStrassenByOrtId(ortId);

        return strassenByOrtId.Select(strasse =>
            new Strasse(
                strasse.Id.TrimStart(),
                strasse.Name));
    }

    /// <summary>
    /// Ruft eine Liste von Standorten basierend auf der Straßen-ID ab.
    /// </summary>
    /// <param name="abfallkalenderService">Service zum Abrufen der Standortdaten.</param>
    /// <param name="strassenId">ID der Straße, für die die Standorte abgerufen werden sollen.</param>
    /// <returns>Eine Liste von Standorten mit ID, Nummer und Zusatz.</returns>
    public async Task<IEnumerable<Standort>> GetStandorte([Service] AbfallkalenderService abfallkalenderService,
        string strassenId) {
        var standorteByStrassenId = await abfallkalenderService.GetStandorteByStrassenId(strassenId);

        return standorteByStrassenId.Select(standort =>
            new Standort(
                standort.Id.TrimStart(),
                standort.Nr, standort.Zusatz));
    }

    /// <summary>
    /// Ruft eine Liste von Fraktionen basierend auf der Standort-ID ab.
    /// </summary>
    /// <param name="abfallkalenderService">Service zum Abrufen der Fraktionsdaten.</param>
    /// <param name="standortId">ID des Standorts, für den die Fraktionen abgerufen werden sollen.</param>
    /// <returns>Eine Liste von Fraktionen mit ID, Name und optionaler Farbe.</returns>
    public async Task<IEnumerable<Fraktion>> GetFraktionen([Service] AbfallkalenderService abfallkalenderService, string standortId) {
        var fraktionen = await abfallkalenderService.GetFraktionen(standortId);

        return fraktionen.Select(fraktion =>
            new Fraktion(
                fraktion.Id,
                fraktion.Name,
                fraktion.Col));
    }

    /// <summary>
    /// Ruft eine gefilterte Liste von Abfallterminen basierend auf einem Zeitraum und einer Standort-ID ab.
    /// </summary>
    /// <param name="abfallkalenderService">Service zum Abrufen der Termindaten.</param>
    /// <param name="von">Startdatum des Zeitraums.</param>
    /// <param name="bis">Enddatum des Zeitraums.</param>
    /// <param name="standortId">ID des Standorts, für den die Termine abgerufen werden sollen.</param>
    /// <returns>Eine Abfrage von Terminen mit relevanten Informationen.</returns>
    [HotChocolate.Data.UseFiltering]
    public async Task<IQueryable<Termin>> GetAbfallkalender([Service] AbfallkalenderService abfallkalenderService,
        DateTime von, DateTime bis, string standortId) {
        var termine = await abfallkalenderService.GetTermine(standortId, von, bis);

        var terminList = termine is null
            ? new List<Termin>()
            : termine.Select(termin => new Termin {
                Datum = termin.BasisDatum,
                Bemerkung = termin.Bemerkung,
                FraktionId = termin.Type,
                Fraktion = termin.Fraktion,
                Turnus = termin.Turnus,
                Verschoben = termin.Verschoben
            });

        return terminList.AsQueryable();
    }
}

/// <summary>
/// Repräsentiert einen Ort mit ID und Name.
/// </summary>
public record Ort(string Id, string Name);

/// <summary>
/// Repräsentiert eine Straße mit ID und Name.
/// </summary>
public record Strasse(string Id, string Name);

/// <summary>
/// Repräsentiert einen Standort mit ID, Nummer und Zusatz.
/// </summary>
public record Standort(string Id, string Nr, string Zusatz);

/// <summary>
/// Repräsentiert eine Fraktion mit ID, Name und optionaler Farbe.
/// </summary>
public record Fraktion(string Id, string Name, string? Col);
