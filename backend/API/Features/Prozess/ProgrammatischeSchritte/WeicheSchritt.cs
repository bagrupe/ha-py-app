using API.Features.Expressions;

namespace API.Features.Prozess.ProgrammatischeSchritte;

/// <summary>Repräsentiert einen programmatischen Schritt vom Typ "Weiche", der basierend auf Bedingungen eine passende Verbindung auswählt.</summary>
[SchrittName("Weiche")]
public class WeicheSchritt(ILogger<WeicheSchritt> logger, EvaluatingVisitorService evaluatingVisitorService) : ProgrammatischerSchrittExecutable {
    /// <summary>Führt die Auswertung der Verbindungen durch und gibt die erste passende Verbindung zurück.</summary>
    /// <param name="walker">Der aktuelle Ausführungszustand mit Verbindungs- und Prozessinformationen.</param>
    /// <returns>Das Ergebnis mit der Id der ausgewählten Verbindung.</returns>
    public Task<ProgrammatischerSchrittResult> ExecuteAsync(Walker walker) {
        logger.LogDebug("Weiche in Schritt ID: {SchrittId} (Ausführung ID: {AusfuehrungId})", walker.CurrentSchritt.Id, walker.Ausfuehrung.Id);

        // `AlwaysTrue` Bedingungen als letztes evaluieren ("Default"-Fall).
        foreach (var verbindung in walker.CurrentVerbindungen.OrderBy(x => x.IstRelevant.AlwaysTrue)) {
            var istRelevant = evaluatingVisitorService.Evaluate(
                verbindung.IstRelevant,
                walker.CurrentSlotValues(),
                walker.Prozess.KommuneId
            );
            logger.LogDebug(
                "Verbindung {Outcome}: Ziel-Schritt ID {NachId} ({Name}); IstRelevant: {IstRelevant}",
                istRelevant ? "eingeschlossen" : "ausgeschlossen",
                verbindung.NachId,
                verbindung.Name,
                verbindung.IstRelevant
            );
            if (istRelevant) {
                return Task.FromResult(new ProgrammatischerSchrittResult(verbindung.Id));
            }
        }

        logger.LogError("Weiche konnte keine geeignete Verbindung finden. Dies stellt einen Fehler im Prozess dar. Es wurde die erste Verbindung gewählt, um die Ausführung nicht zu blockieren.");
        return Task.FromResult(new ProgrammatischerSchrittResult(walker.CurrentVerbindungen[0].Id));
    }
}
