using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Auth.KeyEscrow;

public class BuergerKeyEscrow {
    public required Guid BuergerId { get; init; }
    public required byte[] EncryptedPrivateKey { get; set; }
    public required int KeyVersion { get; set; }
    public required Instant CreatedAt { get; init; }
    public required Instant UpdatedAt { get; set; }
    public Instant? RetrievalWindowStart { get; set; }
    public int RetrievalCount { get; set; }
}

public class BuergerKeyEscrowEntityTypeConfiguration : IEntityTypeConfiguration<BuergerKeyEscrow> {
    public void Configure(EntityTypeBuilder<BuergerKeyEscrow> builder) {
        builder.HasKey(e => e.BuergerId);

        builder
            .HasOne<Buerger>()
            .WithOne()
            .HasForeignKey<BuergerKeyEscrow>(e => e.BuergerId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
