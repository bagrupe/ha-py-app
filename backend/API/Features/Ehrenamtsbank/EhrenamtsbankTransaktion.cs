using API.Features.Auth;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Ehrenamtsbank;

public enum EhrenamtsbankTransaktionStatus {
    Confirmed,
    Cancelled,
    Adjusted
}

public enum EhrenamtsbankTransaktionCreatedBy {
    System,
    Admin
}

public class EhrenamtsbankTransaktion {
    public Guid Id { get; set; }

    [GraphQLDescription("Anfrage, aus deren Abschluss die Buchung entstanden ist")]
    public Guid AnfrageId { get; set; }
    [GraphQLIgnore] public EhrenamtsbankAnfrage Anfrage { get; set; } = null!;

    [GraphQLDescription("Eintrag zur Anfrage, zum Zeitpunkt der Buchung kopiert")]
    public Guid EintragId { get; set; }
    [GraphQLIgnore] public EhrenamtsbankEintrag Eintrag { get; set; } = null!;

    [GraphQLDescription("Bürger, der die Zeit geleistet hat")]
    public Guid GiverId { get; set; }
    [GraphQLIgnore] public Buerger Giver { get; set; } = null!;

    [GraphQLDescription("Bürger, der die Zeit erhalten hat")]
    public Guid ReceiverId { get; set; }
    [GraphQLIgnore] public Buerger Receiver { get; set; } = null!;

    [GraphQLDescription("Gebuchte Dauer in Minuten")]
    public int Minutes { get; set; }

    [GraphQLDescription("Tag, an dem die Leistung erbracht wurde")]
    public LocalDate PerformedOn { get; set; }

    public EhrenamtsbankTransaktionStatus Status { get; set; } = EhrenamtsbankTransaktionStatus.Confirmed;

    [GraphQLDescription("Optionale Notiz aus dem Abschlussvorschlag")]
    public string? Note { get; set; }

    public Instant CreatedAt { get; set; }

    [GraphQLDescription("Urheber der Buchung: automatisch aus dem Abschluss-Flow oder manuell")]
    public EhrenamtsbankTransaktionCreatedBy CreatedBy { get; set; } = EhrenamtsbankTransaktionCreatedBy.System;
}

public class EhrenamtsbankTransaktionConfig : IEntityTypeConfiguration<EhrenamtsbankTransaktion> {
    public void Configure(EntityTypeBuilder<EhrenamtsbankTransaktion> builder) {
        builder.Property(t => t.Note).HasMaxLength(EhrenamtsbankZeitkontoOptions.NoteMaxLength);
        builder.HasOne(t => t.Anfrage).WithMany()
            .HasForeignKey(t => t.AnfrageId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(t => t.Eintrag).WithMany()
            .HasForeignKey(t => t.EintragId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(t => t.Giver).WithMany()
            .HasForeignKey(t => t.GiverId)
            .OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(t => t.Receiver).WithMany()
            .HasForeignKey(t => t.ReceiverId)
            .OnDelete(DeleteBehavior.Restrict);
        // Prevents double booking even when both parties confirm at the same time.
        builder.HasIndex(t => t.AnfrageId).IsUnique();
        builder.HasIndex(t => t.GiverId);
        builder.HasIndex(t => t.ReceiverId);
    }
}
