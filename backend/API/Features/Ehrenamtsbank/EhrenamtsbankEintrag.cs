using API.Features.Auth;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Ehrenamtsbank;

/// <summary>Art eines Ehrenamtsbank-Eintrags.</summary>
public enum EhrenamtsbankEintragTyp {
    Gesuch,
    Angebot
}

/// <summary>Status-Lebenszyklus eines Ehrenamtsbank-Eintrags.</summary>
public enum EhrenamtsbankEintragStatus {
    Draft,
    PendingReview,
    Active,
    Paused,
    Completed,
    Closed,
    Assigned
}

/// <summary>Dringlichkeit eines Gesuchs.</summary>
public enum EhrenamtsbankDringlichkeit {
    Niedrig,
    Mittel,
    Hoch
}

/// <summary>
/// Ein Hilfegesuch oder Hilfeangebot der Ehrenamtsbank. Typ-spezifische Felder
/// (Urgency, EstimatedDurationMinutes nur für Gesuche; Availability nur für Angebote)
/// sind optional, dürfen aber nur beim jeweils passenden Typ gesetzt sein.
/// </summary>
public class EhrenamtsbankEintrag {
    public Guid Id { get; set; }

    [GraphQLDescription("Gesuch (\"Ich brauche Hilfe\") oder Angebot (\"Ich biete Hilfe\"). Nach Erstellung unveränderlich.")]
    public EhrenamtsbankEintragTyp Typ { get; set; }

    [GraphQLIgnore] public Guid OwnerId { get; set; }
    [GraphQLIgnore] public Buerger Owner { get; set; } = null!;

    public required string Title { get; set; }
    public required string Description { get; set; }

    [GraphQLDescription("Referenz auf die Ehrenamtsbank-Kategorie.")]
    public Guid KategorieId { get; set; }
    [GraphQLIgnore] public EhrenamtsbankKategorie Kategorie { get; set; } = null!;

    [GraphQLDescription("Ort des Eintrags als Referenz auf eine Gemeinde (Untereinheit mit isGemeinde = true).")]
    public Guid UntereinheitId { get; set; }
    [GraphQLIgnore] public Untereinheit.Untereinheit Untereinheit { get; set; } = null!;

    [GraphQLDescription("Bereitschaftsradius in Kilometern. Reine Anzeigeinformation, keine Geo-Suche.")]
    public int? RadiusKm { get; set; }

    public EhrenamtsbankEintragStatus Status { get; set; } = EhrenamtsbankEintragStatus.Draft;

    [GraphQLDescription("Dringlichkeit. Nur bei Gesuchen erlaubt.")]
    public EhrenamtsbankDringlichkeit? Urgency { get; set; }

    [GraphQLDescription("Geschätzter Aufwand in Minuten. Nur bei Gesuchen erlaubt; Formatierung obliegt dem Client.")]
    public int? EstimatedDurationMinutes { get; set; }

    [GraphQLDescription("Freitext-Verfügbarkeit. Nur bei Angeboten erlaubt.")]
    public string? Availability { get; set; }

    [GraphQLDescription("Optionaler Objektspeicher-Schlüssel des Bildes (Präfix ehrenamtsbank/), geladen über GET /api/objects/{imageKey}.")]
    public string? ImageKey { get; set; }

    [GraphQLDescription("Freie Schlagworte, z.B. \"Werkzeug vorhanden\".")]
    public List<string> Tags { get; set; } = [];

    public Instant CreatedAt { get; set; }
    public Instant UpdatedAt { get; set; }

    [GraphQLDescription("Zeitpunkt der letzten Moderationsentscheidung (Freigabe oder Ablehnung).")]
    public Instant? ReviewedAt { get; set; }

    [GraphQLIgnore] public bool IsDeleted { get; set; }

    [GraphQLIgnore] public string? Address { get; set; }
    [GraphQLIgnore] public double? Latitude { get; set; }
    [GraphQLIgnore] public double? Longitude { get; set; }

    [GraphQLIgnore] public ICollection<EhrenamtsbankAnfrage> Anfragen { get; set; } = new HashSet<EhrenamtsbankAnfrage>();
}

public class EhrenamtsbankEintragConfig : IEntityTypeConfiguration<EhrenamtsbankEintrag> {
    public void Configure(EntityTypeBuilder<EhrenamtsbankEintrag> builder) {
        // Inhaber und Moderation bearbeiten denselben Eintrag nebenläufig. Ohne Token würde ein
        // Save, der Status gar nicht anfasst, eine zwischenzeitliche Moderationsentscheidung
        // stillschweigend behalten und damit ungeprüfte Inhalte veröffentlichen.
        builder.Property<uint>("Version")
            .HasColumnName("xmin").HasColumnType("xid")
            .ValueGeneratedOnAddOrUpdate()
            .IsConcurrencyToken();
        builder.Property(e => e.Title).HasMaxLength(150);
        builder.Property(e => e.Address).HasMaxLength(EhrenamtsbankLocationValidation.MaxAddressLength);
        builder.ToTable(t => {
            t.HasCheckConstraint("CK_EhrenamtsbankEintrag_Location_Complete",
                """
                ("Address" IS NULL AND "Latitude" IS NULL AND "Longitude" IS NULL)
                OR ("Address" IS NOT NULL AND "Latitude" IS NOT NULL AND "Longitude" IS NOT NULL)
                """);
            t.HasCheckConstraint("CK_EhrenamtsbankEintrag_Latitude_Range",
                """
                "Latitude" IS NULL OR ("Latitude" >= -90 AND "Latitude" <= 90)
                """);
            t.HasCheckConstraint("CK_EhrenamtsbankEintrag_Longitude_Range",
                """
                "Longitude" IS NULL OR ("Longitude" >= -180 AND "Longitude" <= 180)
                """);
        });
        builder.HasOne(e => e.Owner).WithMany()
            .HasForeignKey(e => e.OwnerId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(e => e.Kategorie).WithMany()
            .HasForeignKey(e => e.KategorieId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(e => e.Untereinheit).WithMany()
            .HasForeignKey(e => e.UntereinheitId).OnDelete(DeleteBehavior.Restrict);
        builder.HasMany(e => e.Anfragen).WithOne(a => a.Eintrag).OnDelete(DeleteBehavior.Cascade);
        builder.HasIndex(e => e.Status);
        builder.HasIndex(e => e.KategorieId);
        builder.HasIndex(e => e.UntereinheitId);
        builder.HasIndex(e => e.OwnerId);
        builder.HasIndex(e => e.ImageKey).IsUnique().HasFilter("NOT \"IsDeleted\"");
    }
}
