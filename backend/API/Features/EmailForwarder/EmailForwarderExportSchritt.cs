using API.Features.Expressions;
using API.Features.Prozess;

namespace API.Features.EmailForwarder;

/// <summary>
/// Repräsentiert einen Schritt im EmailForwarder-Workflow zum Export und Versand von E-Mails.
/// </summary>
[ObjectType]
public class EmailForwarderExportSchritt : Schritt {
    /// <summary>
    /// Gibt die Slots dieses Schritts zurück. Dieser Schritt verwendet keine Slots.
    /// </summary>
    public override IEnumerable<Slot> Slots { get; } = [];

    /// <summary>
    /// Gibt an, dass die Erledigung dieses Schritts nicht durch den Bürger erfolgt.
    /// </summary>
    public override bool ErledigungDurchBuerger => false;

    /// <summary>
    /// Ausdruck zur Bestimmung der Empfänger-E-Mail-Adresse.
    /// </summary>
    public required StringExpression EmailAddress { get; init; }

    /// <summary>
    /// Ausdruck zur Bestimmung des Betreffs der E-Mail.
    /// </summary>
    public required StringExpression Subject { get; init; }

    /// <summary>
    /// Ausdruck zur Bestimmung des Inhalts der E-Mail.
    /// </summary>
    public required StringExpression Body { get; init; }
}
