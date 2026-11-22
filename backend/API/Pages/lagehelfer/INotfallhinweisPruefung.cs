namespace API.Pages.lagehelfer;

/// <summary>Optional text assessment. Register a provider only after operational validation.</summary>
public interface INotfallhinweisPruefung {
    Task<bool> EnthaeltNotfallhinweisAsync(string beschreibung, CancellationToken ct);
}
