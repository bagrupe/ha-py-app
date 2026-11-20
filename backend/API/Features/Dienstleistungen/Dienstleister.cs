using API.Features.Auth;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Dienstleistungen;

/// <summary>
/// Repräsentiert einen Dienstleister mit zugehörigen Daten und Beziehungen.
/// </summary>
[ObjectType]
public class Dienstleister {
    /// <summary>
    /// Eindeutige Identifikation des Dienstleisters.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Zugehöriger Mandant (Kommune) des Dienstleisters.
    /// </summary>
    public Kommune.Kommune Mandant { get; init; } = null!;

    /// <summary>
    /// ID des zugehörigen Mandanten.
    /// </summary>
    public Guid MandantId { get; init; }

    /// <summary>
    /// Name des Dienstleisters.
    /// </summary>
    public required String Name { get; set; }

    /// <summary>
    /// E-Mail-Adressen des Dienstleisters.
    /// </summary>
    public required List<String> EMailAdressen { get; set; }

    /// <summary>
    /// Liste der zugehörigen Mitarbeiter (Backoffice-Benutzer).
    /// </summary>
    [GraphQLIgnore]
    public List<BackofficeUser> Mitarbeiter { get; set; } = [];

    /// <summary>
    /// Liste der zugeordneten Organisationseinheiten.
    /// </summary>
    [GraphQLIgnore]
    public List<Untereinheit.Untereinheit> Organisationseinheiten { get; set; } = [];
}

/// <summary>
/// Verknüpft Dienstleister mit Organisationseinheiten in einer Many-to-Many-Beziehung.
/// </summary>
public class DienstleisterOrganisationseinheit {
    /// <summary>
    /// ID des Dienstleisters.
    /// </summary>
    public Guid DienstleisterId { get; init; }

    /// <summary>
    /// Referenz auf den Dienstleister.
    /// </summary>
    public Dienstleister Dienstleister { get; init; } = null!;

    /// <summary>
    /// ID der Organisationseinheit.
    /// </summary>
    public Guid OrganisationseinheitId { get; init; }

    /// <summary>
    /// Referenz auf die Organisationseinheit.
    /// </summary>
    public Untereinheit.Untereinheit Organisationseinheit { get; init; } = null!;
}

/// <summary>
/// Konfiguriert die Entity Framework Core-Mappingregeln für Dienstleister.
/// </summary>
public class DienstleisterEntityTypeConfiguration : IEntityTypeConfiguration<Dienstleister> {
    /// <summary>
    /// Definiert die Datenbankkonfiguration für die Dienstleister-Entität.
    /// </summary>
    /// <param name="builder">Builder zur Konfiguration der Entität.</param>
    public void Configure(EntityTypeBuilder<Dienstleister> builder) {
        builder
            .PrimitiveCollection(d => d.EMailAdressen)
            .HasDefaultValueSql("'{}'")
            .ElementType().HasConversion<LowerCaseValueConverter>();
        builder.HasMany(d => d.Organisationseinheiten).WithMany().UsingEntity<DienstleisterOrganisationseinheit>(
            r => r.HasOne(e => e.Organisationseinheit).WithMany().OnDelete(DeleteBehavior.Cascade),
            l => l.HasOne(e => e.Dienstleister).WithMany());
    }
}
