using API.Options;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ NachrichtSchritt um die konfigurierte Maximallänge der Nachricht.</summary>
[ExtendObjectType<NachrichtSchritt>]
public class NachrichtSchrittQueries {
    [GraphQLDescription("Maximale Zeichenlänge der Freitextnachricht (serverseitig validiert).")]
    public int GetNachrichtMaxLength([Service] ProzessOptions options) => options.NachrichtMaxLength;
}

[ExtendObjectType<Ausfuehrung>]
public class AusfuehrungNachrichtQueries {
    [GraphQLDescription("Maximale Zeichenlänge einer Freitextnachricht an die antragstellende Person (serverseitig validiert).")]
    public int GetNachrichtMaxLength([Service] ProzessOptions options) => options.NachrichtMaxLength;
}
