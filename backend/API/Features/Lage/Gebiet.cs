using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace API.Features.Lage;

public class Gebiet {
    public Guid Id { get; set; }
    public Guid UntereinheitId { get; set; }
    [GraphQLIgnore] public Untereinheit.Untereinheit Untereinheit { get; set; } = null!;
    public required string Name { get; set; }
    public string? Geometry { get; set; }

    [GraphQLIgnore] public ICollection<LageGebiet> LageGebiete { get; set; } = new HashSet<LageGebiet>();
}

public class GebietConfig : IEntityTypeConfiguration<Gebiet> {
    public void Configure(EntityTypeBuilder<Gebiet> builder) {
        builder.Property(g => g.Geometry).HasColumnType("jsonb");
        builder.HasIndex(g => new { g.UntereinheitId, g.Name }).IsUnique();
        builder.HasOne(g => g.Untereinheit).WithMany()
            .HasForeignKey(g => g.UntereinheitId).OnDelete(DeleteBehavior.Restrict);
    }
}
