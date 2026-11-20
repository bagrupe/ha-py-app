namespace API.Infrastructure;

/// <summary>Basisklasse für domänenspezifische Ausnahmen in der Kommunal-App.</summary>
public abstract class DomainException : Exception {
    /// <summary>Initialisiert eine neue Instanz der DomainException mit einer optionalen Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung der Ausnahme.</param>
    protected DomainException(string? message) : base(message) {
    }
}
