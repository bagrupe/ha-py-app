using API.Features.Prozess;

namespace API.Features.GovManager;

/// <summary>Repräsentiert eine Anfrage an den GovManager mit zugehörigen Metadaten und Statusinformationen.</summary>
public class GovManagerRequest {
    /// <summary>Eindeutige Kennung der Anfrage.</summary>
    public Guid Id { get; set; }

    /// <summary>Die zugehörige Ausführung der Anfrage.</summary>
    public Ausfuehrung Ausfuehrung { get; init; } = null!;

    /// <summary>Die ID der zugehörigen Ausführung.</summary>
    public Guid AusfuehrungId { get; init; }

    /// <summary>Zeitpunkt der Erstellung der Anfrage.</summary>
    public DateTimeOffset CreatedAt { get; init; }

    /// <summary>Zeitpunkt der Fertigstellung der Anfrage, falls abgeschlossen.</summary>
    public DateTimeOffset? CompletedAt { get; set; }

    /// <summary>Gibt an, ob die Anfrage erfolgreich war.</summary>
    public bool? Success { get; set; }

    /// <summary>Der zugehörige Schritt im GovManager-Exportprozess.</summary>
    public GovManagerRestExportSchritt GovManagerSchritt { get; set; } = null!;

    /// <summary>ID des zugehörigen GovManager-Schritts.</summary>
    public Guid GovManagerSchrittId { get; init; }

    /// <summary>Enthält die Antwort des GovManagers als JSON-String.</summary>
    public string? ResponseBody { get; set; }
}
