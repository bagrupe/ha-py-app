using API.Infrastructure;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>Anonymous submission of an Ausführung, allowed only for Prozesse carrying <see cref="ProzessTagName"/>.</summary>
/// <remarks>
/// The tag is created directly in the database and then assigned like any other tag. Only the current tags count,
/// not the tag history, so removing the tag closes anonymous submission again.
/// </remarks>
public static class AnonymeEinreichung {
    public const string ProzessTagName = "Anonym";
}

[GraphQLDescription("Ergebnis einer anonymen Einreichung.")]
public record AnonymeAusfuehrungResult(
    [property: GraphQLDescription("Geheimnis für die Statusabfrage ohne Anmeldung. Nur einmal ausgeliefert, also auf dem Gerät speichern.")]
    Guid CorrelationId);

[GraphQLDescription("Status eines anonym eingereichten Antrags.")]
public record AnonymeAusfuehrungStatus(
    AusfuehrungStatus Status,
    Instant CreatedAt,
    Instant? AbgeschlossenAm,
    [property: GraphQLDescription("Bürgerseitige Status-Historie, wie sie auch angemeldete Bürger:innen sehen.")]
    IReadOnlyList<Historie> Historie);

public class AnonymeEinreichungNichtErlaubtException()
    : DomainException("Dieser Prozess kann nicht anonym eingereicht werden.");

public class AnonymeEinreichungUnvollstaendigException()
    : DomainException("Die anonyme Einreichung muss alle Schritte der antragstellenden Person auf einmal enthalten.");
