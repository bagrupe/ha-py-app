using NodaTime;

namespace API.Features.Aufbewahrung;

/// <summary>Art des protokollierten Aufbewahrungs-/Lösch-Ereignisses.</summary>
public enum AntragLoeschEreignis {
    /// <summary>Antrag wurde von einem berechtigten Backoffice-Nutzer soft-gelöscht.</summary>
    SoftGeloescht,

    /// <summary>Eine zuvor erfolgte Soft-Löschung wurde rückgängig gemacht.</summary>
    Wiederhergestellt,

    /// <summary>Antrag wurde endgültig (inkl. Crypto-Shredding) aus der Live-DB gelöscht.</summary>
    EndgueltigGeloescht,

    /// <summary>Antrag wurde in die Archiv-DB verschoben.</summary>
    Archiviert,
}

/// <summary>
/// Revisionssicheres Protokoll über Lösch-/Archivierungsereignisse von Anträgen.
/// Bewusst OHNE Fremdschlüssel auf die Ausführung, damit der Eintrag die endgültige
/// Löschung überlebt. Enthält KEINE personenbezogenen Antragsinhalte – nur Metadaten
/// (wer/wann/warum/welche Antrags-Id). So bleibt die Löschung nachvollziehbar, ohne
/// personenbezogene Daten aufzubewahren.
/// </summary>
[GraphQLDescription("Revisionssicheres Protokoll über Lösch-/Archivierungsereignisse eines Antrags (ohne personenbezogene Inhalte).")]
public class AntragLoeschProtokoll {
    public Guid Id { get; init; }

    [GraphQLDescription("Id des betroffenen Antrags (kein FK – überlebt die endgültige Löschung).")]
    public required Guid AusfuehrungId { get; init; }

    [GraphQLDescription("Kommune des Antrags (für Mandantentrennung in Auswertungen).")]
    public Guid? KommuneId { get; init; }

    [GraphQLDescription("Art des Ereignisses.")]
    public required AntragLoeschEreignis Ereignis { get; init; }

    [GraphQLDescription("Id des handelnden Backoffice-Nutzers (bei manuellen Aktionen).")]
    public Guid? AusgefuehrtVonId { get; init; }

    [GraphQLDescription("E-Mail des handelnden Backoffice-Nutzers zum Zeitpunkt der Aktion (für Nachvollziehbarkeit).")]
    public string? AusgefuehrtVonEmail { get; init; }

    [GraphQLDescription("Begründung (bei Soft-Löschung Pflicht).")]
    public string? Grund { get; init; }

    [GraphQLDescription("Zeitpunkt des Ereignisses.")]
    public required Instant Zeitpunkt { get; init; }
}
