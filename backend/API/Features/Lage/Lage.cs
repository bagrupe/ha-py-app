using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using NodaTime;

namespace API.Features.Lage;

public enum LageStatus {
    Created = 0,
    Closed = 1,
    Active = 2
}

public class Lage {
    public Guid Id { get; set; }
    public Guid UntereinheitId { get; set; }
    [GraphQLIgnore] public Untereinheit.Untereinheit Untereinheit { get; set; } = null!;
    public required string Title { get; set; }
    public string? Note { get; set; }
    public string? WarningText { get; set; }
    public LageStatus Status { get; set; } = LageStatus.Created;
    public Guid CreatedById { get; set; }
    public Instant CreatedAt { get; set; }
    public Instant UpdatedAt { get; set; }
    public Instant? ClosedAt { get; set; }
    public Guid? ClosedById { get; set; }
    public Instant? ArchivedAt { get; set; }
    [GraphQLIgnore] public Instant? DeletedAt { get; set; }

    /// <summary>Every pass of every Gebiet, including ended ones superseded by a re-add.</summary>
    [GraphQLIgnore]
    public ICollection<LageGebiet> LageGebiete { get; set; } = new HashSet<LageGebiet>();

    /// <summary>The current pass of each Gebiet</summary>
    [GraphQLName("gebiete")]
    public IEnumerable<LageGebiet> CurrentPasses() =>
        LageGebiete.GroupBy(lg => lg.GebietId).Select(passes => CurrentPassOf(passes)!);

    [GraphQLIgnore]
    public LageGebiet? CurrentPass(Guid gebietId) => CurrentPassOf(LageGebiete.Where(lg => lg.GebietId == gebietId));

    private static LageGebiet? CurrentPassOf(IEnumerable<LageGebiet> passesOfOneGebiet) =>
        passesOfOneGebiet
            .OrderByDescending(lg => LageGebietStateMachine.IsOpen(lg.Status))
            .ThenByDescending(lg => lg.DoneAt ?? lg.EndedAt)
            .FirstOrDefault();

    public static Lage Create(Guid untereinheitId, string title, IEnumerable<Gebiet> gebieteOfUntereinheit,
        Guid createdById, Instant now) {
        var lage = new Lage {
            Id = Guid.NewGuid(),
            UntereinheitId = untereinheitId,
            Title = title,
            CreatedById = createdById,
            CreatedAt = now,
            UpdatedAt = now,
        };
        foreach (var gebiet in gebieteOfUntereinheit) {
            lage.AddGebiet(gebiet);
        }
        return lage;
    }

    /// <summary> The first Gebiet going live makes the Lage active.</summary>
    public void TransitionGebiet(Guid gebietId, LageGebietStatus to, Guid byId, Instant at) {
        if (Status == LageStatus.Closed) {
            throw new InvalidOperationException($"Lage {Id} is closed.");
        }
        var pass = CurrentPass(gebietId)
            ?? throw new InvalidOperationException($"Gebiet {gebietId} is not part of Lage {Id}.");
        pass.TransitionTo(to, byId, at);
        if (to == LageGebietStatus.Live) {
            Status = LageStatus.Active;
        }
    }

    /// <summary>Starts a new Inactive pass; a Gebiet whose earlier pass has ended may be added again.</summary>
    public void AddGebiet(Gebiet gebiet) {
        if (Status == LageStatus.Closed) {
            throw new InvalidOperationException($"Lage {Id} is closed.");
        }
        if (gebiet.UntereinheitId != UntereinheitId) {
            throw new ArgumentException($"Gebiet {gebiet.Id} does not belong to Untereinheit {UntereinheitId}.");
        }
        if (HasOpenPass(gebiet.Id)) {
            throw new InvalidOperationException($"Gebiet {gebiet.Id} already has an open pass in Lage {Id}.");
        }
        LageGebiete.Add(new LageGebiet { LageId = Id, GebietId = gebiet.Id });
    }

    [GraphQLIgnore]
    public bool HasOpenPass(Guid gebietId) =>
        LageGebiete.Any(lg => lg.GebietId == gebietId && LageGebietStateMachine.IsOpen(lg.Status));
}

public class LageConfig : IEntityTypeConfiguration<Lage> {
    public void Configure(EntityTypeBuilder<Lage> builder) {
        builder.HasIndex(l => l.Status);
        builder.HasOne(l => l.Untereinheit).WithMany()
            .HasForeignKey(l => l.UntereinheitId).OnDelete(DeleteBehavior.Restrict);
    }
}
