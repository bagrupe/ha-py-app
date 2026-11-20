using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Lage;

public enum LageGebietStatus {
    Inactive = 0,
    CalledOut = 1,
    Ready = 2,
    Live = 3,
    Ended = 4,
    Done = 5
}

public class LageGebiet {
    public Guid Id { get; set; }
    public Guid LageId { get; set; }
    [GraphQLIgnore] public Lage Lage { get; set; } = null!;
    public Guid GebietId { get; set; }
    public Gebiet Gebiet { get; set; } = null!;

    public LageGebietStatus Status { get; set; } = LageGebietStatus.Inactive;
    public Instant? CalledOutAt { get; set; }
    public Guid? CalledOutById { get; set; }
    public Instant? ReadyAt { get; set; }
    public Guid? ReadyById { get; set; }
    public Instant? LiveAt { get; set; }
    public Guid? LiveById { get; set; }
    public Instant? EndedAt { get; set; }
    public Guid? EndedById { get; set; }
    public Instant? DoneAt { get; set; }
    public Guid? DoneById { get; set; }

    public void TransitionTo(LageGebietStatus to, Guid byId, Instant at) {
        if (!LageGebietStateMachine.IsAllowed(Status, to)) {
            throw new InvalidOperationException($"LageGebiet cannot transition from {Status} to {to}.");
        }
        Status = to;
        switch (to) {
            case LageGebietStatus.CalledOut:
                CalledOutAt = at;
                CalledOutById = byId;
                break;
            case LageGebietStatus.Ready:
                ReadyAt = at;
                ReadyById = byId;
                break;
            case LageGebietStatus.Live:
                LiveAt = at;
                LiveById = byId;
                break;
            case LageGebietStatus.Ended:
                EndedAt = at;
                EndedById = byId;
                break;
            case LageGebietStatus.Done:
                DoneAt = at;
                DoneById = byId;
                break;
        }
    }
}

public class LageGebietConfig : IEntityTypeConfiguration<LageGebiet> {
    public void Configure(EntityTypeBuilder<LageGebiet> builder) {
        builder.HasKey(lg => lg.Id);
        builder.HasIndex(lg => new { lg.LageId, lg.GebietId }, "IX_LageGebiete_LageId_GebietId");
        builder.HasIndex(lg => new { lg.LageId, lg.GebietId }, "IX_LageGebiete_LageId_GebietId_Open")
            .IsUnique()
            .HasFilter("\"Status\" IN (0, 1, 2, 3)");
        builder.HasOne(lg => lg.Lage).WithMany(l => l.LageGebiete)
            .HasForeignKey(lg => lg.LageId).OnDelete(DeleteBehavior.Restrict);
        builder.HasOne(lg => lg.Gebiet).WithMany(g => g.LageGebiete)
            .HasForeignKey(lg => lg.GebietId).OnDelete(DeleteBehavior.Restrict);
    }
}
