using API.Features;
using API.Features.Lage;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using NodaTime;

namespace IntegrationTests;

public class LageSeeder(BackendApiFactory factory) {
    private DomainContext NewDb() =>
        factory.Services.CreateScope().ServiceProvider.GetRequiredService<DomainContext>();

    /// <param name="gebietPaths">One entry per Gebiet: its transitions from Inactive, comma-separated ("" stays Inactive).</param>
    public async Task<Lage> SeedLage(Guid untereinheitId, string title, bool closed = false, params string[] gebietPaths) {
        var now = factory.Services.GetRequiredService<IClock>().GetCurrentInstant();
        var actorId = Guid.NewGuid();
        var gebiete = gebietPaths.Select(_ => GebietEinsatzleitungSeeder.NewGebiet(untereinheitId)).ToList();
        var lage = Lage.Create(untereinheitId, title, gebiete, actorId, now);

        foreach (var (gebiet, path) in gebiete.Zip(gebietPaths)) {
            foreach (var step in path.Split(',', StringSplitOptions.RemoveEmptyEntries)) {
                lage.TransitionGebiet(gebiet.Id, Enum.Parse<LageGebietStatus>(step.Trim()), actorId, now);
            }
        }

        if (closed) {
            lage.Status = LageStatus.Closed;
            lage.ClosedAt = now;
            lage.ClosedById = actorId;
        }

        var db = NewDb();
        db.Gebiete.AddRange(gebiete);
        db.Lagen.Add(lage);
        await db.SaveChangesAsync();
        return lage;
    }

    public Task<Lage?> StoredLage(Guid id) =>
        NewDb().Lagen.Include(l => l.LageGebiete).SingleOrDefaultAsync(l => l.Id == id);

    public Task<List<LageGebiet>> StoredPasses(Guid lageId, Guid gebietId) =>
        NewDb().Set<LageGebiet>().Where(lg => lg.LageId == lageId && lg.GebietId == gebietId).ToListAsync();

    public Task<bool> AnyLageTitled(string title) =>
        NewDb().Lagen.AnyAsync(l => l.Title == title);
}
