using API.Features.Auth;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.MaengelMelder.Queries;

public static class MaengelQueryableExtension {
    public static IQueryable<Ausfuehrung> WithTag(this IQueryable<Ausfuehrung> ausfuehrungen, string tag) {
        return ausfuehrungen
            .Where(a => a.ProzessVersion.Prozess.TagHistorie.Any(h => h.Tag.Tag == tag));
    }
}

internal static class MaengelZeitfensterFilter {
    internal static bool IstAbgelaufen(Ausfuehrung a, Instant cutoff) {
        return a.Status == AusfuehrungStatus.Abgeschlossen
               && a.AbgeschlossenAm.HasValue
               && a.AbgeschlossenAm.Value < cutoff;
    }

    internal static async Task<Instant> GetCutoff(
        MaengelSichtbarkeitService service, IClock clock, Guid kommuneId) {
        var stunden = await service.GetSichtbarkeitStunden(kommuneId);
        return clock.GetCurrentInstant() - Duration.FromHours(stunden);
    }
}

[ExtendObjectType<Kommune.Kommune>]
public class MaengelQueries {
    public async Task<IEnumerable<Ausfuehrung>> GetMaengelAusfuehrungen(
        IMaengelByKommuneIdDataLoader loader,
        [Parent] Kommune.Kommune kommune,
        [Service] MaengelSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrungen = await loader.LoadAsync(kommune.Id);
        var cutoff = await MaengelZeitfensterFilter.GetCutoff(sichtbarkeitService, clock, kommune.Id);

        return ausfuehrungen.Where(a => !MaengelZeitfensterFilter.IstAbgelaufen(a, cutoff));
    }

    public async Task<Ausfuehrung?> GetMangelAusfuehrung(
        IMangelByIdDataLoader loader,
        Guid id,
        [Parent] Kommune.Kommune kommune,
        [Service] MaengelSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrung = await loader.LoadAsync(id);
        // GetMangelById looks up purely by id (it's a shared batching DataLoader, not
        // Kommune-scoped), so the Kommune-boundary check has to happen here - without
        // it, any Mangel id is readable through any Kommune's query context.
        if (ausfuehrung is null || ausfuehrung.ProzessVersion.Prozess.KommuneId != kommune.Id) return null;

        var cutoff = await MaengelZeitfensterFilter.GetCutoff(sichtbarkeitService, clock, kommune.Id);
        return MaengelZeitfensterFilter.IstAbgelaufen(ausfuehrung, cutoff) ? null : ausfuehrung;
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetMaengelByKommuneId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Ausfuehrungen
            .NotDeleted()
            .WithTag("Mängelmelder")
            .Where(a => keys.Contains(a.ProzessVersion.Prozess.KommuneId))
            .Include(ausfuehrung => ausfuehrung.ProzessVersion)
            .ThenInclude(prozessVersion => prozessVersion.Prozess)
            .ToLookupAsync(k => k.ProzessVersion.Prozess.KommuneId, ct);
    }

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Ausfuehrung>> GetMangelById(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Ausfuehrungen
            .NotDeleted()
            .WithTag("Mängelmelder")
            .Where(a => keys.Contains(a.Id))
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .ToDictionaryAsync(a => a.Id, ct);
    }
}

[ExtendObjectType<User>]
public class UserMaengelQueries {
    public async Task<IEnumerable<Ausfuehrung>> GetMaengel(
        [Parent] User user,
        IMaengelByUserIdDataLoader loader,
        [Service] MaengelSichtbarkeitService sichtbarkeitService,
        [Service] IClock clock) {
        var ausfuehrungen = await loader.LoadAsync(user.Id);
        var expiredIds = await GetExpiredMaengelIds(ausfuehrungen, sichtbarkeitService, clock);
        return ausfuehrungen.Where(a => !expiredIds.Contains(a.Id));
    }

    internal static async Task<HashSet<Guid>> GetExpiredMaengelIds(
        IEnumerable<Ausfuehrung> ausfuehrungen,
        MaengelSichtbarkeitService sichtbarkeitService,
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
                        && MaengelZeitfensterFilter.IstAbgelaufen(a, cutoff))
            .Select(a => a.Id)
            .ToHashSet();
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetMaengelByUserId(IReadOnlyList<Guid> userIds,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Ausfuehrungen
            .NotDeleted()
            .WithTag("Mängelmelder")
            .Where(a => userIds.Contains(a.UserId))
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .ToLookupAsync(a => a.UserId, ct);
    }
}
