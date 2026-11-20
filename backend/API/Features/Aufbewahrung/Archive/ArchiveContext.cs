using System.Text.Json;
using API.Features.Prozess;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Aufbewahrung.Archive;

/// <summary>
/// Ein archivierter (abgeschlossener) Antrag in der separaten Archiv-Datenbank.
/// Bewusst selbst-enthaltend: die vollständigen (weiterhin verschlüsselten) Antragsdaten
/// liegen als JSON in <see cref="Inhalt"/>. Das vermeidet, das gesamte relationale Modell
/// in der Archiv-DB zu spiegeln, und hält das Archiv einfach und robust.
/// </summary>
public class ArchivierterAntrag {
    public Guid Id { get; set; }
    public Guid KommuneId { get; set; }
    public Guid ProzessVersionId { get; set; }

    /// <summary>Denormalisiert zur Auffindbarkeit (Prozessname zum Zeitpunkt der Archivierung).</summary>
    public string? ProzessBezeichnung { get; set; }

    public AusfuehrungStatus Status { get; set; }
    public Instant CreatedAt { get; set; }
    public Instant? AbgeschlossenAm { get; set; }
    public Instant ArchiviertAm { get; set; }

    // Zuständigkeit zum Zeitpunkt der Archivierung – wird benötigt, damit die Archiv-Sichtbarkeit
    // exakt der Live-Antragsliste entspricht (nur eigener Zuständigkeitsbereich). Fail-closed:
    // alte Einträge ohne diese Werte (null) sind für Nicht-Superadmins nicht sichtbar.
    public ZustaendigkeitArt ZustaendigkeitArt { get; set; }
    public Guid? ZustaendigkeitOrganisationseinheitId { get; set; }
    public Guid? ZustaendigkeitMitarbeiterGruppeId { get; set; }
    public Guid? ZustaendigkeitZugewiesenePersonId { get; set; }
    public Guid? ZustaendigkeitDienstleisterId { get; set; }

    /// <summary>Verschlüsselter Schlüssel für die Kommune – wandert mit, damit berechtigter Zugriff entschlüsseln kann.</summary>
    public string SharedKeyEncryptedForKommune { get; set; } = "";

    /// <summary>Vollständiger, weiterhin verschlüsselter Antragsinhalt als JSON (jsonb).</summary>
    public JsonDocument Inhalt { get; set; } = null!;
}

/// <summary>
/// Zweiter DbContext für die separate Archiv-Datenbank (eigene Connection-String "Archive",
/// eigener Docker-Stack auf Port 5434). Hat eigene Migrationen (History-Tabelle in der Archiv-DB).
/// </summary>
public class ArchiveContext : DbContext {
    public ArchiveContext(DbContextOptions<ArchiveContext> options) : base(options) { }

    public DbSet<ArchivierterAntrag> ArchivierteAntraege { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder) {
        modelBuilder.Entity<ArchivierterAntrag>(e => {
            e.HasKey(x => x.Id);
            e.Property(x => x.Inhalt).HasColumnType("jsonb");
            e.HasIndex(x => x.KommuneId);
            e.HasIndex(x => x.ProzessVersionId);
            e.HasIndex(x => x.AbgeschlossenAm);
        });
    }
}
