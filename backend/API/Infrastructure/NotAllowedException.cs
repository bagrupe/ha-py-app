namespace API.Infrastructure;

/// <summary>Repräsentiert eine Ausnahme, die ausgelöst wird, wenn eine Aktion nicht erlaubt ist.</summary>
public class NotAllowedException : DomainException {
    /// <summary>Initialisiert eine neue Instanz mit einer Standardfehlermeldung.</summary>
    public NotAllowedException() : base("Sie haben nicht die benötigte Berechtigung für diese Aktion.") { }

    /// <summary>Initialisiert eine neue Instanz mit einer benutzerdefinierten Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung.</param>
    public NotAllowedException(String message) : base(message) { }
}
