using NodaTime;

namespace API.Utils;

/// <summary>Stellt Hilfsmethoden für Datum und Zeit bereit.</summary>
public static class DateTime {
    /// <summary>Gibt das aktuelle Datum in der Zeitzone Europe/Berlin zurück.</summary>
    /// <returns>Das heutige Datum als LocalDate.</returns>
    public static LocalDate Today() {
        Instant now = SystemClock.Instance.GetCurrentInstant();
        DateTimeZone tz = DateTimeZoneProviders.Tzdb["Europe/Berlin"];
        return now.InZone(tz).Date;
    }
}
