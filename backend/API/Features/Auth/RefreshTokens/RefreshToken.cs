using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Auth.RefreshTokens;

public static class RefreshTokenProvider {
    public const string BundId = "bundid";
    public const string Sms = "sms";
}

public enum RefreshTokenRevokedReason {
    Rotated,
    SupersededByRetry,
    LoggedOut,
    ReuseDetected,
    AccountInvalid
}

public class RefreshToken {
    public Guid Id { get; init; }

    public required Guid BuergerId { get; init; }

    public required string TokenHash { get; init; }

    public string? AssuranceLevel { get; init; }

    public required string Provider { get; init; }

    /// <summary>Nur bei <see cref="RefreshTokenRevokedReason.Rotated"/> und <see cref="RefreshTokenRevokedReason.SupersededByRetry"/> gesetzt.</summary>
    public Guid? ReplacedById { get; set; }

    public required Instant CreatedAt { get; init; }
    public required Instant ExpiresAt { get; init; }

    public Instant? RevokedAt { get; set; }

    /// <summary>Leer bei Zeilen, die vor Einführung des Grundes widerrufen wurden.</summary>
    public RefreshTokenRevokedReason? RevokedReason { get; set; }

    public static string GenerateRawToken() => Convert.ToBase64String(RandomNumberGenerator.GetBytes(32));

    public static string HashRawToken(string rawToken) =>
        Convert.ToHexString(SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(rawToken))).ToLowerInvariant();

    public static (RefreshToken Entity, string RawToken) Create(
        Guid buergerId, string provider, string? assuranceLevel, Instant now, int lifetimeDays, Guid? id = null) {
        var rawToken = GenerateRawToken();
        var entity = new RefreshToken {
            Id = id ?? Guid.NewGuid(),
            BuergerId = buergerId,
            TokenHash = HashRawToken(rawToken),
            AssuranceLevel = assuranceLevel,
            Provider = provider,
            CreatedAt = now,
            ExpiresAt = now.Plus(Duration.FromDays(lifetimeDays)),
        };
        return (entity, rawToken);
    }
}

public class RefreshTokenEntityTypeConfiguration : IEntityTypeConfiguration<RefreshToken> {
    public void Configure(EntityTypeBuilder<RefreshToken> builder) {
        builder.HasIndex(t => t.TokenHash).IsUnique();
        builder.HasIndex(t => t.BuergerId);
        builder.Property(t => t.RevokedReason).HasConversion<string>();

        builder
            .HasOne<Buerger>()
            .WithMany()
            .HasForeignKey(t => t.BuergerId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
