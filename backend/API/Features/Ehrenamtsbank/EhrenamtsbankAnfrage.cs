using API.Features.Auth;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Ehrenamtsbank;

/// <summary>
/// Status einer Anfrage
/// </summary>
public enum EhrenamtsbankAnfrageStatus {
    Offen,
    Akzeptiert,
    Vereinbart,
    Erledigt,
    Abgelehnt,
    Zurueckgezogen
}

/// <summary>
/// Repräsentiert eine Anfrage an einen EhrenamtsbankEintrag. Anfragen werden von Interessenten
/// gestellt und dann nach Status behandelt.
/// </summary>
public class EhrenamtsbankAnfrage {
    public Guid Id { get; set; }

    public Guid EintragId { get; set; }
    [GraphQLIgnore] public EhrenamtsbankEintrag Eintrag { get; set; } = null!;

    [GraphQLIgnore] public Guid InteressentId { get; set; }
    [GraphQLIgnore] public Buerger Interessent { get; set; } = null!;

    [GraphQLDescription("Optionale Nachricht für die Anfrage")]
    public string? Nachricht { get; set; }

    [GraphQLDescription("Status der Anfrage")]
    public EhrenamtsbankAnfrageStatus Status { get; set; } = EhrenamtsbankAnfrageStatus.Offen;

    public Instant CreatedAt { get; set; }
    public Instant UpdatedAt { get; set; }

    [GraphQLDescription("Zeitpunkt, zu dem die Anfrage vereinbart wurde")]
    public Instant? VereinbartAt { get; set; }

    [GraphQLDescription("Vorgeschlagene Dauer des Abschlusses in Minuten")]
    public int? ProposedMinutes { get; set; }

    [GraphQLDescription("Vorgeschlagenes Datum, an dem die Leistung erbracht wurde")]
    public LocalDate? ProposedDate { get; set; }

    [GraphQLDescription("Optionale Notiz zum Abschlussvorschlag")]
    public string? ProposedNote { get; set; }

    [GraphQLDescription("Bürger, der den Abschlussvorschlag gemacht hat")]
    public Guid? ProposedById { get; set; }
}

public class EhrenamtsbankAnfrageConfig : IEntityTypeConfiguration<EhrenamtsbankAnfrage> {
    public void Configure(EntityTypeBuilder<EhrenamtsbankAnfrage> builder) {
        builder.Property(a => a.ProposedNote).HasMaxLength(EhrenamtsbankZeitkontoOptions.NoteMaxLength);
        builder.HasOne(a => a.Interessent).WithMany()
            .HasForeignKey(a => a.InteressentId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.HasIndex(a => new { a.EintragId, a.InteressentId }).IsUnique();
        builder.HasIndex(a => a.InteressentId);
        builder.HasIndex(a => a.Status);
    }
}
