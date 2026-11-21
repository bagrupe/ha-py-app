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

    /// <summary>Prozesse with this tag only accept reports that name a Lage and Gebiet that are live.</summary>
    public const string LageHelferTagName = "LageHelfer";
}

[GraphQLDescription("Ergebnis einer anonymen Einreichung.")]
public record AnonymeAusfuehrungResult(
    [property: GraphQLDescription("Geheimnis für die Statusabfrage ohne Anmeldung. Nur einmal ausgeliefert, also auf dem Gerät speichern.")]
    Guid CorrelationId,
    [property: GraphQLDescription("Laufende Nummer der Meldung (angezeigt als \"E-1042\"). Null außerhalb des LageHelfers.")]
    int? Meldungsnummer);

[GraphQLDescription("Status eines anonym eingereichten Antrags.")]
public record AnonymeAusfuehrungStatus(
    MeldungStatus Status,
    [property: GraphQLDescription("Anzeigetext zum Status, z. B. \"Hilfe ist unterwegs\".")]
    string StatusText,
    Instant CreatedAt,
    Instant? AbgeschlossenAm,
    [property: GraphQLDescription("Laufende Nummer der Meldung (angezeigt als \"E-1042\"). Null außerhalb des LageHelfers.")]
    int? Meldungsnummer,
    [property: GraphQLDescription(
        "Bürgerseitige Status-Historie, ohne Namen der Bearbeitenden: Die CorrelationId ist kein Login.")]
    IReadOnlyList<AnonymerHistorieEintrag> Historie);

[GraphQLDescription("Eintrag im Status-Verlauf eines anonym eingereichten Antrags.")]
public record AnonymerHistorieEintrag(
    Instant CreatedAt,
    string? StatusAenderung,
    string? StatusAenderungBeschreibung,
    [property: GraphQLDescription("Freitextnachricht der Bearbeitenden an die meldende Person (falls vorhanden).")]
    string? Nachricht);

public class AnonymeEinreichungNichtErlaubtException()
    : DomainException("Dieser Prozess kann nicht anonym eingereicht werden.");

public class AnonymeEinreichungUnvollstaendigException()
    : DomainException("Die anonyme Einreichung muss alle Schritte der antragstellenden Person auf einmal enthalten.");

public class LageErforderlichException()
    : DomainException("Für diese Meldung muss eine Lage und ein Gebiet gewählt werden.");
