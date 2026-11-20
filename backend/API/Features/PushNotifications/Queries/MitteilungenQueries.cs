using API.Features.Auth;
using API.Features.Ideenmelder;
using API.Features.Ideenmelder.Queries;
using API.Features.MaengelMelder;
using API.Features.MaengelMelder.Queries;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.PushNotifications.Queries;

/// <summary>Stellt Abfragen für Mitteilungen eines Bürgers bereit.</summary>
[ExtendObjectType<Buerger>]
public class MitteilungenQueries {
    /// <summary>Lädt alle Mitteilungen (Ausführungen) für den angegebenen Bürger.</summary>
    /// <param name="buerger">Der Bürger, dessen Mitteilungen geladen werden sollen.</param>
    /// <param name="loader">DataLoader zum effizienten Laden der Bearbeitungen.</param>
    /// <returns>Eine Auflistung der Ausführungen des Bürgers.</returns>
    public async Task<IEnumerable<Ausfuehrung>> GetMitteilungen([Parent] Buerger buerger,
        IBearbeitungenByUserIdDataLoader loader, [Service] IDbContextFactory<DomainContext> dbContextFactory,
        [Service] MaengelSichtbarkeitService maengelSichtbarkeitService,
        [Service] IdeenSichtbarkeitService ideenSichtbarkeitService, [Service] IClock clock, CancellationToken ct) {
        var ausfuehrungen = (await loader.LoadAsync(buerger.Id, ct)).ToList();

        var abgeschlossenIds = ausfuehrungen
            .Where(a => a.Status == AusfuehrungStatus.Abgeschlossen && a.AbgeschlossenAm.HasValue)
            .Select(a => a.Id)
            .ToList();
        if (abgeschlossenIds.Count == 0) return ausfuehrungen;

        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        var abgeschlosseneMaengel = await LoadAbgeschlosseneMitTag(db, abgeschlossenIds, "Mängelmelder", ct);
        var abgeschlosseneIdeen = await LoadAbgeschlosseneMitTag(db, abgeschlossenIds, "Ideenmelder", ct);

        var expiredIds = await UserMaengelQueries.GetExpiredMaengelIds(abgeschlosseneMaengel, maengelSichtbarkeitService, clock);
        expiredIds.UnionWith(await UserIdeenQueries.GetExpiredIdeenIds(abgeschlosseneIdeen, ideenSichtbarkeitService, clock));
        return ausfuehrungen.Where(a => !expiredIds.Contains(a.Id));
    }

    private static Task<List<Ausfuehrung>> LoadAbgeschlosseneMitTag(DomainContext db, List<Guid> ids, string tag,
        CancellationToken ct) {
        return db.Ausfuehrungen
            .NotDeleted()
            .WithTag(tag)
            .Where(a => ids.Contains(a.Id))
            .Include(a => a.ProzessVersion)
            .ThenInclude(pv => pv.Prozess)
            .ToListAsync(ct);
    }

    /// <summary>Lädt Bearbeitungen für mehrere Bürger-IDs und gruppiert sie nach Benutzer-ID.</summary>
    /// <param name="buergerIds">Liste der Bürger-IDs, für die Bearbeitungen geladen werden.</param>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Ein Lookup mit Bürger-ID als Schlüssel und den zugehörigen Ausführungen als Wert.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetBearbeitungenByUserId(IReadOnlyList<Guid> buergerIds,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        var ownAusfuehrungen =
            await db.Ausfuehrungen.NotDeleted().Where(a => buergerIds.Contains(a.UserId))
                .ToLookupAsync(a => a.UserId, ct);

        var followedAusfuehrungen =
            await db.Ausfuehrungen.NotDeleted().Where(a => a.Followers.Any(f => buergerIds.Contains(f.Id)))
                .Include(ausfuehrung => ausfuehrung.Followers)
                .ToLookupAsync(a => a.Followers.First(f => buergerIds.Contains(f.Id)).Id, ct);

        return ownAusfuehrungen.Concat(followedAusfuehrungen)
            .SelectMany(lookup => lookup.Select(value => new { lookup.Key, value })).ToLookup(x => x.Key, x => x.value);
    }
}
