using API.Features.Prozess;

namespace API.Features.PmPayment;

/// <summary>Repräsentiert eine Zahlungsanforderung für einen Bezahlen-Schritt einer Ausführung.</summary>
public class PaymentRequest {
    /// <summary>Die eindeutige Id der Zahlungsanforderung.</summary>
    public Guid Id { get; set; }

    /// <summary>Die zugehörige Ausführung der Zahlung.</summary>
    public Ausfuehrung Ausfuehrung { get; init; } = null!;

    /// <summary>Die Id der zugehörigen Ausführung.</summary>
    public Guid AusfuehrungId { get; init; }

    /// <summary>Der Bezahlen-Schritt, für den die Zahlung angefordert wird.</summary>
    public BezahlenSchritt BezahlenSchritt { get; init; } = null!;

    /// <summary>Die Id des Bezahlen-Schritts.</summary>
    public Guid BezahlenSchrittId { get; init; }

    /// <summary>Der Zeitpunkt der Erstellung der Zahlungsanforderung.</summary>
    public DateTimeOffset CreatedAt { get; init; }

    /// <summary>Der Zeitpunkt der Beendigung der Zahlung, falls abgeschlossen.</summary>
    public DateTimeOffset? CompletedAt { get; set; }

    /// <summary>Der Erfolg der Zahlung, falls abgeschlossen.</summary>
    public bool? Success { get; set; }

    /// <summary>Die verwendete Zahlungsmethode, falls bekannt.</summary>
    public string? PaymentMethod { get; set; }
}
