using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Aufbewahrung;

/// <summary>
/// Globale Einstellungen für Aufbewahrung und Löschung von Anträgen.
/// Singleton: es existiert genau ein Datensatz (feste <see cref="SingletonId"/>).
/// Wird ausschließlich von Superadmins gelesen und geändert.
/// </summary>
[GraphQLDescription("Globale Einstellungen für Aufbewahrung/Löschung von Anträgen. Es existiert genau ein Datensatz.")]
public class AufbewahrungsEinstellungen {
    /// <summary>Feste ID, damit immer genau ein Datensatz existiert.</summary>
    public static readonly Guid SingletonId = Guid.Parse("0000a0be-0000-0000-0000-000000000001");

    public Guid Id { get; set; } = SingletonId;

    [GraphQLDescription(
        "Karenzzeit in Minuten zwischen Soft-Löschung und endgültiger Löschung eines Antrags. " +
        "Die UI rechnet Stunden/Tage in Minuten um.")]
    public int HardDeleteVerzoegerungMinuten { get; set; } = 30 * 24 * 60; // Default: 30 Tage

    [GraphQLDescription(
        "Frist in Minuten zwischen Abschluss eines Antrags und dessen Archivierung. " +
        "Die UI rechnet Stunden/Tage in Minuten um.")]
    public int ArchivVerzoegerungMinuten { get; set; } = 180 * 24 * 60; // Default: 180 Tage

    [GraphQLDescription("Ob der Job zur endgültigen Löschung soft-gelöschter Anträge aktiv ist.")]
    public bool HardDeleteAktiv { get; set; }

    [GraphQLDescription("Ob der Job zur Archivierung abgeschlossener Anträge aktiv ist.")]
    public bool ArchivierungAktiv { get; set; }

    [GraphQLIgnore]
    public Guid? AktualisiertVonId { get; set; }

    [GraphQLDescription("Zeitpunkt der letzten Änderung dieser Einstellungen.")]
    public Instant? AktualisiertAm { get; set; }

    /// <summary>Stellt sicher, dass der Singleton-Datensatz existiert (beim App-Start aufrufen).</summary>
    public static async Task EnsureExists(DomainContext db, CancellationToken ct = default) {
        var exists = await db.AufbewahrungsEinstellungen.AsNoTracking()
            .AnyAsync(e => e.Id == SingletonId, ct);
        if (!exists) {
            db.AufbewahrungsEinstellungen.Add(new AufbewahrungsEinstellungen { Id = SingletonId });
            await db.SaveChangesAsync(ct);
        }
    }
}
