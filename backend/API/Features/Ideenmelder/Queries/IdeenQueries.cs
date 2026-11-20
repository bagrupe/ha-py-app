using API.Features.Auth;
using API.Features.MaengelMelder.Queries;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Ideenmelder.Queries;

internal static class IdeenZeitfensterFilter {
    internal static bool IstAbgelaufen(Ausfuehrung a, Instant cutoff) {
        return a.Status == AusfuehrungStatus.Abgeschlossen
               && a.AbgeschlossenAm.HasValue
               && a.AbgeschlossenAm.Value < cutoff;
    }

    internal static async Task<Instant> GetCutoff(
        IdeenSichtbarkeitService service, IClock clock, Guid kommuneId) {
        var stunden = await service.GetSichtbarkeitStunden(kommuneId);
        return clock.GetCurrentInstant() - Duration.FromHours(stunden);
    }
}

[ExtendObjectType<Kommune.Kommune>]
public class IdeenQueries {
    public async Task<IEnumerable<Ausfuehrung>> GetIdeenAusfuehrungen(
        IIdeenByKommuneIdDataLoader loader,
        [Parent] Kommune.Kommune kommune,
        [Service] IdeenSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrungen = await loader.LoadAsync(kommune.Id);
        var cutoff = await IdeenZeitfensterFilter.GetCutoff(sichtbarkeitService, clock, kommune.Id);

        return ausfuehrungen.Where(a => !IdeenZeitfensterFilter.IstAbgelaufen(a, cutoff));
    }

    public async Task<Ausfuehrung?> GetIdeeAusfuehrung(
        IIdeeByIdDataLoader loader,
        Guid id,
        [Parent] Kommune.Kommune kommune,
        [Service] IdeenSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrung = await loader.LoadAsync(id);
        // GetIdeeById looks up purely by id (it's a shared batching DataLoader, not
        // Kommune-scoped), so the Kommune-boundary check has to happen here - without
        // it, any Idee id is readable through any Kommune's query context.
        if (ausfuehrung is null || ausfuehrung.ProzessVersion.Prozess.KommuneId != kommune.Id) return null;

        var cutoff = await IdeenZeitfensterFilter.GetCutoff(sichtbarkeitService, clock, kommune.Id);
        return IdeenZeitfensterFilter.IstAbgelaufen(ausfuehrung, cutoff) ? null : ausfuehrung;
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetIdeenByKommuneId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Ausfuehrungen
            .NotDeleted()
            .WithTag("Ideenmelder")
            .Where(a => keys.Contains(a.ProzessVersion.Prozess.KommuneId))
            .Include(ausfuehrung => ausfuehrung.ProzessVersion)
            .ThenInclude(prozessVersion => prozessVersion.Prozess)
            .ToLookupAsync(k => k.ProzessVersion.Prozess.KommuneId, ct);
    }

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Ausfuehrung>> GetIdeeById(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Ausfuehrungen
            .NotDeleted()
            .WithTag("Ideenmelder")
            .Where(a => keys.Contains(a.Id))
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .ToDictionaryAsync(a => a.Id, ct);
    }
}

[ExtendObjectType<User>]
public class UserIdeenQueries {
    public async Task<IEnumerable<Ausfuehrung>> GetIdeen(
        [Parent] User user,
        IIdeenByUserIdDataLoader loader,
        [Service] IdeenSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrungen = await loader.LoadAsync(user.Id);
        var expiredIds = await GetExpiredIdeenIds(ausfuehrungen, sichtbarkeitService, clock);
        return ausfuehrungen.Where(a => !expiredIds.Contains(a.Id));
    }

    internal static async Task<HashSet<Guid>> GetExpiredIdeenIds(
        IEnumerable<Ausfuehrung> ausfuehrungen,
        IdeenSichtbarkeitService sichtbarkeitService,
        IClock clock) {
        var closedInKommunen = ausfuehrungen
            .Where(a => a.Status == AusfuehrungStatus.Abgeschlossen && a.AbgeschlossenAm.HasValue)
            .ToList();

        if (closedInKommunen.Count == 0) return [];

        var now = clock.GetCurrentInstant();
        var cutoffs = new Dictionary<Guid, Instant>();
        foreach (var kommuneId in closedInKommunen
                     .Select(a => a.ProzessVersion.Prozess.KommuneId).Distinct()) {
            var stunden = await sichtbarkeitService.GetSichtbarkeitStunden(kommuneId);
            cutoffs[kommuneId] = now - Duration.FromHours(stunden);
        }

        return closedInKommunen
            .Where(a => cutoffs.TryGetValue(a.ProzessVersion.Prozess.KommuneId, out var cutoff)
                        && IdeenZeitfensterFilter.IstAbgelaufen(a, cutoff))
            .Select(a => a.Id)
            .ToHashSet();
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetIdeenByUserId(IReadOnlyList<Guid> userIds,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Ausfuehrungen
            .NotDeleted()
            .WithTag("Ideenmelder")
            .Where(a => userIds.Contains(a.UserId))
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .ToLookupAsync(a => a.UserId, ct);
    }

    [GraphQLDescription("Liefert alle Ideen, denen dieser Bürger aktuell folgt.")]
    public async Task<IEnumerable<Ausfuehrung>> GetGefolgteIdeen(
        [Parent] User user,
        IGefolgteIdeenByUserIdDataLoader loader,
        [Service] IdeenSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrungen = await loader.LoadAsync(user.Id);
        var expiredIds = await GetExpiredIdeenIds(ausfuehrungen, sichtbarkeitService, clock);
        return ausfuehrungen.Where(a => !expiredIds.Contains(a.Id));
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetGefolgteIdeenByUserId(IReadOnlyList<Guid> userIds,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Buerger
            .Where(b => userIds.Contains(b.Id))
            .Include(b => b.GefolgteAusfuehrungen)
            .ThenInclude(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .SelectMany(b => b.GefolgteAusfuehrungen
                .Where(a => a.GeloeschtAm == null
                            && a.ProzessVersion.Prozess.TagHistorie.Any(h => h.Tag.Tag == "Ideenmelder"))
                .Select(a => new { b.Id, Ausfuehrung = a }))
            .ToLookupAsync(b => b.Id, b => b.Ausfuehrung, ct);
    }
}
