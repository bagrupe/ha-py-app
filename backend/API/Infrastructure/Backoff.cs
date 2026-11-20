using NodaTime;

namespace API.Infrastructure;

/// <summary>Repräsentiert einen Backoff-Zustand mit Anzahl der Versuche und Zeitpunkt des letzten Versuchs.</summary>
/// <param name="Number">Anzahl der fehlgeschlagenen Versuche.</param>
/// <param name="LastAttempt">Zeitpunkt des letzten Versuchs.</param>
record SimpleBackoff(int Number, Instant LastAttempt);

/// <summary>Dient zur Verwaltung von Backoff-Logik basierend auf fehlgeschlagenen Versuchen.</summary>
/// <param name="clock">Zeitgeber zur Ermittlung der aktuellen Zeit.</param>
public class BackoffService(IClock clock) {
    private Dictionary<Guid, SimpleBackoff> _backoffs = new();

    /// <summary>Erfasst das Ergebnis eines Versuchs und aktualisiert den Backoff-Zustand entsprechend.</summary>
    /// <param name="id">Eindeutige Kennung des Vorgangs.</param>
    /// <param name="success">Gibt an, ob der Versuch erfolgreich war.</param>
    public void RecordResult(Guid id, bool success) {
        if (success) _backoffs.Remove(id);
        else {
            var lastBackoff = _backoffs.TryGetValue(id, out var existing) ? existing.Number : 0;
            _backoffs[id] = new SimpleBackoff(lastBackoff + 1, clock.GetCurrentInstant());
        }
    }

    /// <summary>Prüft, ob ein Vorgang basierend auf dem Backoff-Zustand aktuell erlaubt ist.</summary>
    /// <param name="id">Eindeutige Kennung des Vorgangs.</param>
    /// <returns>True, wenn der Vorgang erlaubt ist, sonst false.</returns>
    public bool AllowedWithBackoff(Guid id) {
        if (!_backoffs.TryGetValue(id, out var backoff)) return true;

        var allowedAt = backoff.LastAttempt + Duration.FromMinutes(backoff.Number);
        var now = clock.GetCurrentInstant();

        return now >= allowedAt;
    }
}
