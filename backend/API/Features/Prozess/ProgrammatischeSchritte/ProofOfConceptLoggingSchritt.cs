namespace API.Features.Prozess.ProgrammatischeSchritte;

/// <summary>Ein programmatischer Schritt, der eine einfache Log-Nachricht ausgibt (Proof of Concept).</summary>
[SchrittName("Logging (Proof of Concept)")]
public class ProofOfConceptLoggingSchritt : ProgrammatischerSchrittExecutable {
    private readonly ILogger<ProofOfConceptLoggingSchritt> _logger;

    /// <summary>Initialisiert eine neue Instanz mit einem Logger.</summary>
    /// <param name="logger">Der Logger zum Ausgeben von Informationen.</param>
    public ProofOfConceptLoggingSchritt(ILogger<ProofOfConceptLoggingSchritt> logger) {
        _logger = logger;
    }

    /// <summary>Führt den Schritt aus und protokolliert eine Informationsnachricht.</summary>
    /// <param name="walker">Der aktuelle Walker mit Verbindungsinformationen.</param>
    /// <returns>Das Ergebnis des Schritts mit der Id der ersten aktuellen Verbindung.</returns>
    public Task<ProgrammatischerSchrittResult> ExecuteAsync(Walker walker) {
        _logger.LogInformation("Programmatischer Schritt ausgeführt!");
        return Task.FromResult(new ProgrammatischerSchrittResult(walker.CurrentVerbindungen[0].Id));
    }
}
