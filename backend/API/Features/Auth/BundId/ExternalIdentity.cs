using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Auth.BundId;

/// <summary>
/// Verknüpft einen <see cref="Buerger"/> dauerhaft mit einer extern über einen Broker (aktuell
/// nur BundID via Keycloak) authentifizierten Identität. Das Klartext-Subject wird bewusst nicht
/// gespeichert, siehe <see cref="BundIdSubjectHasher"/>.
/// </summary>
public class ExternalIdentity {
    public Guid Id { get; init; }

    /// <summary>Der verknüpfte Bürger.</summary>
    public Guid BuergerId { get; init; }

    /// <summary>Provider der externen Identität, aktuell immer <c>bundid</c>.</summary>
    public required string Provider { get; init; }

    /// <summary>Ausstellender Keycloak-Realm (OIDC-Issuer).</summary>
    public required string Issuer { get; init; }

    /// <summary>HMAC des externen OIDC-Subjects (bPK2), siehe <see cref="BundIdSubjectHasher"/>.</summary>
    public required string SubjectHash { get; init; }

    /// <summary>
    /// Letztes Vertrauensniveau (STORK-QAA-Level als String, z.B. <c>STORK-QAA-Level-1</c>) der
    /// Anmeldung, siehe <see cref="BundIdAssuranceLevel.Extract"/> für die beiden möglichen
    /// Quellen (Keycloaks eigener <c>acr</c>-Claim oder BundIDs Per-Attribut-Trust-Level am
    /// <c>bpk2</c>-Attribut). Rein informativ, aktuell nirgends für Berechtigungsentscheidungen
    /// verwendet.
    /// </summary>
    public string? AssuranceLevel { get; set; }

    /// <summary>Zeitpunkt der erstmaligen Verknüpfung.</summary>
    public required Instant LinkedAt { get; init; }

    /// <summary>Zeitpunkt der letzten erfolgreichen Anmeldung über diese Identität.</summary>
    public Instant LastAuthenticatedAt { get; set; }
}

/// <summary>Konfiguration für die Datenbankentität "ExternalIdentity".</summary>
public class ExternalIdentityEntityTypeConfiguration : IEntityTypeConfiguration<ExternalIdentity> {
    public void Configure(EntityTypeBuilder<ExternalIdentity> builder) {
        builder
            .HasIndex(e => new { e.Provider, e.Issuer, e.SubjectHash })
            .IsUnique();

        builder
            .HasOne<Buerger>()
            .WithMany()
            .HasForeignKey(e => e.BuergerId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
