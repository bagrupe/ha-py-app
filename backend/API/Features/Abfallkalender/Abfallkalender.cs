namespace API.Features.Abfallkalender;

/// <summary>
/// Repräsentiert den Abfallkalender mit einer Liste von Terminen.
/// </summary>
public class Abfallkalender {
    /// <summary>
    /// Liste der Abfuhrtermine.
    /// </summary>
    public List<Termin> Termine { get; set; } = new();
}

/// <summary>
/// Repräsentiert einen Abfuhrtermin mit relevanten Informationen.
/// </summary>
public class Termin {
    /// <summary>
    /// Datum des Termins.
    /// </summary>
    public string Datum { get; set; } = null!;

    /// <summary>
    /// ID der zugehörigen Fraktion.
    /// </summary>
    public string FraktionId { get; set; } = null!;

    /// <summary>
    /// Name der zugehörigen Fraktion.
    /// </summary>
    public string Fraktion { get; set; } = null!;

    /// <summary>
    /// Gibt an, ob der Termin verschoben wurde.
    /// </summary>
    public string? Verschoben { get; set; }

    /// <summary>
    /// Turnus des Termins.
    /// </summary>
    public string Turnus { get; set; } = null!;

    /// <summary>
    /// Zusätzliche Bemerkungen zum Termin.
    /// </summary>
    public string? Bemerkung { get; set; }
}
