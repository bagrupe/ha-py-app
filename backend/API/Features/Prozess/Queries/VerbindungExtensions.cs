namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ Verbindung um Abfragen zu den zugehörigen Schritten.</summary>
[ExtendObjectType<Verbindung>]
public class VerbindungExtensions {
    /// <summary>Liefert den Ausgangs-Schritt ("von") der Verbindung.</summary>
    /// <param name="schritt">Die Verbindung, deren Ausgangs-Schritt abgefragt wird.</param>
    /// <param name="dataLoader">DataLoader zum Laden des Schritts.</param>
    /// <returns>Der Ausgangs-Schritt.</returns>
    [GraphQLDescription("Liefert den Ausgangs-Schritt (\"von\") dieser Verbindung.")]
    public async Task<Schritt> GetVon([Parent] Verbindung schritt, ISchrittBySchrittIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(schritt.VonId);
    }

    /// <summary>Liefert den Ziel-Schritt ("nach") der Verbindung.</summary>
    /// <param name="schritt">Die Verbindung, deren Ziel-Schritt abgefragt wird.</param>
    /// <param name="dataLoader">DataLoader zum Laden des Schritts.</param>
    /// <returns>Der Ziel-Schritt.</returns>
    [GraphQLDescription("Liefert den Ziel-Schritt (\"nach\") dieser Verbindung.")]
    public async Task<Schritt> GetNach([Parent] Verbindung schritt, ISchrittBySchrittIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(schritt.NachId);
    }
}
