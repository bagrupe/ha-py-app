namespace API.Features.PushNotifications;

/// <summary>Repräsentiert ein Thema für Push-Benachrichtigungen.</summary>
public interface ITopic {
    /// <summary>Gibt die string-Repräsentation des Themas zurück.</summary>
    string ToString();
}

/// <summary>Basisklasse für Push-Benachrichtigungsthemen mit Umgebungs- und Präfixinformationen.</summary>
/// <param name="environment">Name der Umgebung (z.B. App-Umgebung).</param>
/// <param name="prefix">Präfix des Themas.</param>
/// <param name="ids">Liste von IDs zur eindeutigen Identifikation des Themas.</param>
public abstract class TopicBase(string environment, string prefix, string[] ids) : ITopic {
    /// <summary>Erzeugt die string-Repräsentation des Themas basierend auf Umgebung, Präfix und IDs.</summary>
    public override string ToString() {
        return ids.Length == 0 ? $"{environment}{prefix.ToLower()}" : $"{environment}-{prefix.ToLower()}-{string.Join("-", ids)}";
    }
}

/// <summary>Statische Klasse mit vordefinierten Push-Benachrichtigungsthemen.</summary>
public static class PushTopic {
    /// <summary>Thema für Push-Benachrichtigungen zu Mängeln.</summary>
    /// <param name="environment">Name der Umgebung.</param>
    /// <param name="ausfuehrungId">ID der Ausführung (Mangel).</param>
    public class Mangel(string environment, Guid ausfuehrungId) : TopicBase(environment, nameof(Mangel), [ausfuehrungId.ToString()]);

    /// <summary>Thema für Push-Benachrichtigungen zu Anträgen.</summary>
    /// <param name="environment">Name der Umgebung.</param>
    /// <param name="ausfuehrungId">ID der Ausführung.</param>
    public class Ausfuehrung(string environment, Guid ausfuehrungId) : TopicBase(environment, nameof(Ausfuehrung), [ausfuehrungId.ToString()]);

    /// <summary>Thema für öffentliche News einer Organisationseinheit.</summary>
    /// <param name="environment">Name der Umgebung.</param>
    /// <param name="organisationseinheitId">ID der Organisationseinheit.</param>
    public class PublicNewsForOrganisationseinheit(string environment, Guid organisationseinheitId)
        : TopicBase(environment, nameof(PublicNewsForOrganisationseinheit), [organisationseinheitId.ToString()]);

    /// <summary>Thema für öffentliche News eines Mandanten.</summary>
    /// <param name="environment">Name der Umgebung.</param>
    /// <param name="mandantId">ID des Mandanten.</param>
    public class PublicNewsForMandant(string environment, Guid mandantId)
        : TopicBase(environment, nameof(PublicNewsForMandant), [mandantId.ToString()]);

    /// <summary>
    /// Thema für Push-Benachrichtigungen zu Grenzwertüberschreitungen eines Sensors.
    /// Bewusst OHNE Umgebungs-Präfix (anders als die übrigen Topics hier): das
    /// Sensor-Favorisieren abonniert rein clientseitig direkt in der App (kein
    /// Server-Roundtrip, siehe SensorFavoritenButton), die App kennt den Namen der
    /// Backend-Umgebung dort nicht und kann ihn beim Abonnieren nicht reproduzieren.
    /// </summary>
    /// <param name="sensorId">ID des Sensors (BereichB/Payload-ID, kein Guid).</param>
    public class Sensor(string sensorId) : ITopic {
        public override string ToString() => $"sensor-{sensorId}";
    }
}
