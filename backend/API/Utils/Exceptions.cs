namespace API.Utils;

/// <summary>Repräsentiert eine Ausnahme für ungültige E-Mail-Adressen.</summary>
public class InvalidEmailException() : Exception("Die E-Mail Adresse ist ungültig.");

/// <summary>Repräsentiert eine Ausnahme beim Weiterleiten eines Antrags.</summary>
/// <param name="message">Optionale Fehlermeldung.</param>
public class AntragWeiterleitenException : Exception {
    public AntragWeiterleitenException(string? message) : base(message) { }
    public AntragWeiterleitenException(string? message, Exception? innerException) : base(message, innerException) { }
}

/// <summary>Repräsentiert eine Ausnahme, wenn ein Nutzer nicht gefunden wird.</summary>
public class UserNotFoundException : Exception {
    /// <summary>Initialisiert eine neue Instanz mit einer Standardfehlermeldung.</summary>
    public UserNotFoundException()
        : base("Der Nutzer konnte nicht gefunden werden.") { }

    /// <summary>Initialisiert eine neue Instanz mit einer benutzerdefinierten Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung.</param>
    public UserNotFoundException(string message)
        : base(message) { }
}

/// <summary>Repräsentiert eine Ausnahme bei unautorisiertem Zugriff.</summary>
public class UnauthorizedAccessException : Exception {
    /// <summary>Initialisiert eine neue Instanz mit einer Standardfehlermeldung.</summary>
    public UnauthorizedAccessException()
        : base("Sie sind nicht authorisiert diese Aktion durchzuführen.") { }

    /// <summary>Initialisiert eine neue Instanz mit einer benutzerdefinierten Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung.</param>
    public UnauthorizedAccessException(string message)
        : base(message) { }
}

/// <summary>Repräsentiert eine Ausnahme bei einer nicht erlaubten Aktion für eine Kommune.</summary>
public class MismatchingKommuneException : Exception {
    /// <summary>Initialisiert eine neue Instanz mit einer Standardfehlermeldung.</summary>
    public MismatchingKommuneException()
        : base("Die Aktion für diese Kommune ist nicht erlaubt.") { }

    /// <summary>Initialisiert eine neue Instanz mit einer benutzerdefinierten Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung.</param>
    public MismatchingKommuneException(string message)
        : base(message) { }
}

/// <summary>Repräsentiert eine Ausnahme, wenn eine Ausführung nicht gefunden wird.</summary>
public class AusfuehrungNotFoundException : Exception {
    /// <summary>Initialisiert eine neue Instanz mit einer Standardfehlermeldung.</summary>
    public AusfuehrungNotFoundException()
        : base("Die Ausführung konnte nicht gefunden werden.") { }

    /// <summary>Initialisiert eine neue Instanz mit einer benutzerdefinierten Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung.</param>
    public AusfuehrungNotFoundException(string message)
        : base(message) { }
}

/// <summary>Repräsentiert eine Ausnahme, wenn eine Kommune nicht gefunden wird.</summary>
public class KommuneNotFoundException : Exception {
    /// <summary>Initialisiert eine neue Instanz mit einer Standardfehlermeldung.</summary>
    public KommuneNotFoundException()
        : base("Die Kommune konnte nicht gefunden werden.") {
    }

    /// <summary>Initialisiert eine neue Instanz mit einer benutzerdefinierten Fehlermeldung.</summary>
    /// <param name="message">Die Fehlermeldung.</param>
    public KommuneNotFoundException(string message)
        : base(message) {
    }
}
