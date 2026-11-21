using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;
using API.Features.Auth;
using API.Features.Dienstleistungen;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Prozess;

/// <summary>Definiert die möglichen Status einer Ausführung.</summary>
public enum AusfuehrungStatus {
    BearbeitungDurchBuerger,
    BearbeitungDurchKommune,
    Abgeschlossen,
}

[GraphQLDescription("Repräsentiert einen laufenden Antrag bzw. eine Ausführung eines Prozesses. Enthält Status, Nutzerbezug und aktuelle Zuständigkeit.")]
public class Ausfuehrung {
    public Guid Id { get; init; }
    [GraphQLDescription("Version des Prozesses, auf der diese Ausführung basiert.")]
    public ProzessVersion ProzessVersion { get; init; } = null!;
    public Guid ProzessVersionId { get; init; }
    [GraphQLDescription("Nutzer, der die Ausführung gestartet hat.")]
    public User User { get; init; } = null!;
    public required Guid UserId { get; init; }

    [GraphQLDescription("Aktuelle Zuständigkeit, steuert Bearbeitungsrechte und Sichtbarkeit im Backoffice.")]
    public Zustaendigkeit IstZustaendigkeit { get; init; } = new();

    [GraphQLDescription("Zeitpunkt, zu dem die Ausführung manuell abgeschlossen wurde.")]
    public Instant? ManuellAbgeschlossen { get; set; }

    [GraphQLDescription("Zeitpunkt, zu dem die Ausführung abgeschlossen wurde (automatisch oder manuell).")]
    public Instant? AbgeschlossenAm { get; set; }

    // ---- Soft-Delete (nur Backoffice-Nutzer mit Funktionsberechtigung 'Anträge löschen') -----
    // GeloeschtAm == null  =>  Antrag ist NICHT gelöscht und in allen normalen Ansichten sichtbar.
    // Wird per Mutation gesetzt (Superadmins bestehen die Berechtigungsprüfung automatisch,
    // andere Backoffice-Nutzer nur mit zugewiesener Funktionsberechtigung); ein zeitversetzter
    // Job löscht danach endgültig.
    [GraphQLIgnore]
    [GraphQLDescription("Zeitpunkt der Soft-Löschung. Null bedeutet: nicht gelöscht.")]
    public Instant? GeloeschtAm { get; set; }

    [GraphQLIgnore]
    [GraphQLDescription("Id des Backoffice-Nutzers, der die Soft-Löschung ausgelöst hat.")]
    public Guid? GeloeschtVonId { get; set; }

    [GraphQLIgnore]
    [GraphQLDescription("Begründung der Löschung (Pflichtangabe bei der Soft-Löschung).")]
    public string? Loeschgrund { get; set; }

    [GraphQLIgnore]
    public ICollection<Bearbeitung> Bearbeitungen { get; set; } = new List<Bearbeitung>();
    public required Instant CreatedAt { get; init; }

    [GraphQLIgnore]
    public required string SharedKeyEncryptedForBuerger { get; init; }

    [GraphQLIgnore]
    public required string SharedKeyEncryptedForKommune { get; init; }

    [GraphQLIgnore]
    public ICollection<Buerger> Followers { get; init; } = null!;
    [GraphQLDescription("Aktueller Status der Ausführung (z.B. Bearbeitung durch Bürger, Backoffice oder abgeschlossen).")]
    public required AusfuehrungStatus Status { get; set; }
    [GraphQLIgnore]
    public Guid SchrittId { get; set; }
    [GraphQLIgnore]
    public Schritt Schritt { get; set; } = null!;

    /// <summary>
    /// Secret handed to an anonymous submitter; whoever holds it can read the status without logging in.
    /// Null for every Ausführung started by a logged-in user.
    /// </summary>
    [GraphQLIgnore]
    public Guid? CorrelationId { get; init; }
}

/// <summary>Definiert die Art der Zuständigkeit einer Ausführung.</summary>
public enum ZustaendigkeitArt {
    Buerger,
    Organisationseinheit,
    Dienstleister,
    Dynamisch
}

/**
 * Bildet die aktuelle Zuständigkeit einer Ausführung ab.
 * Zuständigkeit bestimmt, wer die Bearbeitung des Prozesses übernehmen darf und steuert die Sichtbarkeit im Backoffice.
 * Sie kann vordefiniert auf Prozessschritten sein oder manuell vergeben werden.
 */
[Owned]
[GraphQLDescription(
    "Beschreibt, wer aktuell für die Bearbeitung eines Antrags zuständig ist. Kann Bürger, Organisationseinheit, Dienstleister oder dynamisch sein." +
    "Je nach Art der Zuständigkeit können unterschiedliche Eigenschaften gesetzt sein aus welchen die Zuständige Instanz ermittelt werden kann.")]
public record Zustaendigkeit {
    [GraphQLDescription("Bürger, Organisationseinheit, Dienstleister oder dynamisch.")]
    public ZustaendigkeitArt Art { get; set; } = ZustaendigkeitArt.Buerger;

    /// <summary>Organisationseinheit, die aktuell zuständig ist (bei Organisationseinheit-Zuständigkeit).</summary>
    [DeleteBehavior(DeleteBehavior.SetNull)]
    [GraphQLDescription("Organisationseinheit, die aktuell zuständig ist (falls ZustaendigkeitArt.Organisationseinheit).")]
    public Untereinheit.Untereinheit? Organisationseinheit { get; init; } = null!;
    public Guid? OrganisationseinheitId { get; set; }

    [DeleteBehavior(DeleteBehavior.SetNull)]
    [GraphQLDescription("Mitarbeitergruppe, die aktuell zuständig ist (falls ZustaendigkeitArt.Organisationseinheit).")]
    public MitarbeiterGruppe? MitarbeiterGruppe { get; init; }
    public Guid? MitarbeiterGruppeId { get; set; }

    [DeleteBehavior(DeleteBehavior.SetNull)]
    [GraphQLDescription("Dienstleister, der aktuell zuständig ist (falls ZustaendigkeitArt.Dienstleister).")]
    public Dienstleister? Dienstleister { get; init; } = null!;
    public Guid? DienstleisterId { get; set; }

    [DeleteBehavior(DeleteBehavior.SetNull)]
    [GraphQLDescription("Konkret zugewiesene Person, die aktuell zuständig ist (optional).")]
    public Mitarbeiter? ZugewiesenePerson { get; set; }
    public Guid? ZugewiesenePersonId { get; set; }

    [GraphQLDescription("Rolle, die beim Eintritt in einen Schritt gelesen wird (bei ZustaendigkeitArt.Dynamisch).")]
    public ZustaendigkeitRolle? LiestRolle { get; init; }
    public Guid? LiestRolleId { get; set; }

    [GraphQLDescription("Mögliche Arten für eine dynamische Zuständigkeit (z.B. Bürger, Organisationseinheit, Dienstleister) (bei ZustaendigkeitArt.Dynamisch).")]
    public List<ZustaendigkeitArt> DynamischeArten { get; set; } = [];
}

[GraphQLDescription("Repräsentiert die Bearbeitung eines Schritts innerhalb einer Ausführung. Kombiniert Nutzer, Schritt und Daten zu Slots.")]
public class Bearbeitung {
    public Guid Id { get; init; }
    public Ausfuehrung Ausfuehrung { get; init; } = null!;
    public Guid AusfuehrungId { get; init; }

    [GraphQLDescription("Prozessschritt, der in dieser Bearbeitung ausgeführt wurde.")]
    public Schritt Schritt { get; init; } = null!;
    public Guid SchrittId { get; init; }

    [GraphQLIgnore]
    public ICollection<SlotValue> SlotValues { get; set; } = null!;
    [GraphQLDescription("Benutzer, der diese Bearbeitung durchgeführt hat.")]
    public User User { get; init; } = null!;
    public required Guid UserId { get; init; }
    [GraphQLDescription("Zeitpunkt der Bearbeitung.")]
    public required Instant CreatedAt { get; init; }

    [GraphQLDescription("Verbindung, die als nächster Schritt gewählt wurde (entscheidet über den weiteren Verlauf der Ausführung).")]
    public Verbindung NextVerbindung { get; init; } = null!;
    public Guid NextVerbindungId { get; init; }

    [GraphQLDescription("Zuständigkeit, die zum Zeitpunkt dieser Bearbeitung galt (für Historie und Rollenübergabe).")]
    public Zustaendigkeit WarZustaendigkeit { get; init; } = null!;
}

/// <summary>Repräsentiert einen Eintrag in der Historie mit Zeitstempel und Statusänderung.</summary>
[NotMapped]
public class Historie {
    public Guid Id { get; init; }
    public Instant CreatedAt { get; init; }
    public string? StatusAenderung { get; init; }
    public string? StatusAenderungBeschreibung { get; init; }
    [GraphQLDescription("Ausführender Benutzer des Ereignisses (falls vorhanden).")]
    public string? Benutzer { get; init; }
    [GraphQLDescription("Zielperson bzw. Zielorganisation des Ereignisses (falls vorhanden).")]
    public string? Ziel { get; init; }
    [GraphQLDescription("Freitextnachricht des Bearbeitenden aus einem Nachricht-Schritt (falls vorhanden).")]
    public string? Nachricht { get; init; }
}

/// <summary>Art eines Verlaufsereignisses im Lebenszyklus einer Ausführung.</summary>
public enum VerlaufsEreignisArt {
    Eingang,
    Uebernahme,
    WeiterleitungAnsicht,
    WeiterleitungAbgabe,
    WeiterleitungDienstleister,
    WeiterleitungOrganisationseinheit,
    Zustaendigkeitswechsel,
    Abschluss,
    BuergerKommunikation,
}

/// <summary>
/// Persistierter, unveränderlicher Verlaufseintrag für den Lebenszyklus einer Ausführung.
/// Wird ausschließlich vom VorgangsverlaufService angelegt (append-only; es gibt keine Update-/Delete-Mutation).
/// </summary>
public class VerlaufsEintrag {
    public Guid Id { get; init; }
    [GraphQLIgnore]
    public Ausfuehrung Ausfuehrung { get; init; } = null!;
    public Guid AusfuehrungId { get; init; }
    public required Instant CreatedAt { get; init; }
    public required VerlaufsEreignisArt Art { get; init; }

    /// <summary>Ausführender Backoffice-Benutzer; null bei bürgerseitigen Ereignissen (z.B. Eingang).</summary>
    public Guid? BenutzerId { get; init; }

    /// <summary>Name des ausführenden Benutzers zum Ereigniszeitpunkt (revisionssicherer Snapshot).</summary>
    public string? BenutzerName { get; init; }

    /// <summary>Zielperson bzw. Zielorganisation des Ereignisses (falls vorhanden).</summary>
    public string? Zielbeschreibung { get; init; }

    /// <summary>Freitextnachricht an die einreichende Person (nur bei BuergerKommunikation).</summary>
    public string? Nachricht { get; init; }
}

public class AusfuehrungEntityTypeConfiguration : IEntityTypeConfiguration<Ausfuehrung> {
    public void Configure(EntityTypeBuilder<Ausfuehrung> builder) {
        builder.HasOne(a => a.ProzessVersion).WithMany().HasForeignKey(a => a.ProzessVersionId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(a => a.Schritt).WithMany().HasForeignKey(a => a.SchrittId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.HasIndex(a => a.CorrelationId).IsUnique();
    }
}

/// <summary>Konfiguration der Entity Framework Core Entity für VerlaufsEintrag.</summary>
public class VerlaufsEintragConfig : IEntityTypeConfiguration<VerlaufsEintrag> {
    public void Configure(EntityTypeBuilder<VerlaufsEintrag> builder) {
        builder.HasOne(v => v.Ausfuehrung).WithMany().HasForeignKey(v => v.AusfuehrungId)
            .OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(v => v.AusfuehrungId);
    }
}

/// <summary>Abstrakte Basisklasse für Werte, die in einem Formular-Slot im Rahmen einer Bearbeitung gespeichert werden.</summary>
[InterfaceType]
[GraphQLDescription("Repräsentiert einen Wert, der in einem Slot eines Formulars im Rahmen einer Bearbeitung gespeichert wurde.")]
public abstract class SlotValue {
    public Guid Id { get; init; }
    public Bearbeitung Bearbeitung { get; init; } = null!;
    [GraphQLDescription("Name des Slots, auf den sich der gespeicherte Wert bezieht.")]
    public required string SlotName { get; init; }
    [GraphQLDescription("Gibt an, ob ein Wert (z.B. Upload) im Backoffice freigegeben wurde.")]
    public bool? IstFreigegeben { get; set; }
}

/// <summary>Speichert einen verschlüsselten Wert für einen Formular-Slot.</summary>
[ObjectType]
[GraphQLDescription("Speichert einen verschlüsselten Wert für einen Slot.")]
public class EncryptedSlotValue : SlotValue {
    [GraphQLDescription("Verschlüsselter Wert des Slots.")]
    public required EncryptedValue Value { get; init; }
}

/// <summary>Speichert einen unverschlüsselten Wert für einen Formular-Slot.</summary>
[ObjectType]
[GraphQLDescription("Speichert einen unverschlüsselten Wert für einen Slot.")]
public class PlainSlotValue : SlotValue {
    [GraphQLDescription("Unverschlüsselter Wert des Slots.")]
    public required JsonElement Value { get; init; }
}

/// <summary>Erweitert IQueryable von Ausführungen um Filter für öffentliche Ausführungen.</summary>
public static class AusfuehrungQueryableExtensions {
    internal static readonly string[] PublicTags = ["Mängelmelder", "Ideenmelder"];

    /// <summary>Filtert Ausführungen, die einen öffentlich sichtbaren Tag (Mängelmelder, Ideenmelder) im zugehörigen Prozess besitzen.</summary>
    public static IQueryable<Ausfuehrung> OnlyPublic(this IQueryable<Ausfuehrung> ausfuehrungen) {
        return ausfuehrungen.Where(a => a.ProzessVersion.Prozess.TagHistorie.Any(h => PublicTags.Contains(h.Tag.Tag)));
    }

    /// <summary>Blendet soft-gelöschte Anträge aus (GeloeschtAm == null). In allen Backoffice-/Bürger-Listen verwenden.</summary>
    public static IQueryable<Ausfuehrung> NotDeleted(this IQueryable<Ausfuehrung> ausfuehrungen) {
        return ausfuehrungen.Where(a => a.GeloeschtAm == null);
    }
}
