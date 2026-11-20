using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Prozess.Queries;

/// <summary>Stellt Abfragen zu Prozessversionen bereit.</summary>
[ExtendObjectType<Prozess>]
public class ProzessVersionQueries {
    [GraphQLDescription("Liefert alle Versionen eines Prozesses. Für Bürger ist nur die aktuelle Version sichtbar, für Backoffice-Nutzer alle.")]
    public async Task<IEnumerable<ProzessVersion>> GetVersionen(CurrentUserAccessor userAccessor,
        ICurrentVersionByProzessIdDataLoader currentVersionByProzessIdDataLoader,
        IProzessVersionenByProzessIdDataLoader prozessVersionenByProzessIdDataLoader, [Parent] Prozess prozess) {
        var user = await userAccessor.User();

        return user switch {
            BackofficeUser => await prozessVersionenByProzessIdDataLoader.LoadAsync(prozess.Id),
            _ => [await currentVersionByProzessIdDataLoader.LoadAsync(prozess.Id)]
        };
    }

    [GraphQLDescription("Liefert die Anzahl der Versionen eines Prozesses. Für Bürger immer 1, für Backoffice-Nutzer alle.")]
    public async Task<int> GetVersionenCount(CurrentUserAccessor userAccessor,
        IProzessVersionenCountByProzessIdDataLoader dataLoader, [Parent] Prozess prozess) {
        var user = await userAccessor.User();
        return user switch {
            BackofficeUser => await dataLoader.LoadAsync(prozess.Id),
            _ => 1
        };
    }


    [GraphQLDescription("Liefert die neueste Version eines Prozesses (unabhängig vom Veröffentlichungsstatus).")]
    public async Task<ProzessVersion?> GetLatestVersion(ILatestVersionByProzessIdDataLoader dataLoader,
        [Parent] Prozess prozess) {
        return await dataLoader.LoadAsync(prozess.Id);
    }

    /// <summary>Lädt die neueste Version für mehrere Prozess-IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, ProzessVersion>> GetLatestVersionByProzessId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.Prozesse
            .AsSplitQuery()
            .Where(p => ids.Contains(p.Id))
            .Select(p => new {
                p.Id,
                Version = p.Versionen
                    .OrderByDescending(pv => pv.CreatedAt)
                    .First()
            })
            .ToDictionaryAsync(pv => pv.Id, pv => pv.Version, ct);
    }

    [GraphQLDescription("Liefert die aktuell veröffentlichte Version eines Prozesses. Für Bürger:innen null, wenn der Prozess deaktiviert ist.")]
    public async Task<ProzessVersion?> GetCurrentVersion(CurrentUserAccessor userAccessor,
        ICurrentVersionByProzessIdDataLoader dataLoader, [Parent] Prozess prozess) {
        var user = await userAccessor.User();
        if (user is not BackofficeUser && prozess.DeaktiviertAm != null) {
            return null;
        }

        return await dataLoader.LoadAsync(prozess.Id);
    }

    /// <summary>Lädt die aktuell veröffentlichte Version für mehrere Prozess-IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, ProzessVersion>> GetCurrentVersionByProzessId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.Prozesse.AsSplitQuery().Where(p => ids.Contains(p.Id))
            .Select(p => new {
                p.Id,
                Version = p.Versionen
                    .OrderByDescending(pv => pv.PublishedAt)
                    .First(pv => pv.PublishedAt != null)
            })
            .ToDictionaryAsync(pv => pv.Id, pv => pv.Version, ct);
    }

    /// <summary>Lädt Prozessversionen anhand ihrer IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, ProzessVersion>> GetProzessVersionById(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.ProzessVersionen
            .AsSplitQuery()
            .Where(pv => ids.Contains(pv.Id))
            .ToDictionaryAsync(pv => pv.Id, ct);
    }

    /// <summary>Lädt alle Versionen für mehrere Prozess-IDs.</summary>
    [DataLoader]
    internal static async Task<ILookup<Guid, ProzessVersion>> GetProzessVersionenByProzessId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.ProzessVersionen
            .AsSplitQuery()
            .Where(pv => ids.Contains(pv.ProzessId))
            .OrderBy(pv => pv.PublishedAt)
            .ToLookupAsync(pv => pv.ProzessId, ct);
    }

    /// <summary>Lädt die Anzahl der Versionen für mehrere Prozess-IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, int>> GetProzessVersionenCountByProzessId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.Prozesse.Where(p => ids.Contains(p.Id))
            .Select(p => new { count = p.Versionen.Count(), id = p.Id })
            .ToDictionaryAsync(pCountObj => pCountObj.id, pCountObj => pCountObj.count, ct);
    }
}

/// <summary>Erweitert den Typ ProzessVersion um zusätzliche Abfragen.</summary>
[ExtendObjectType<ProzessVersion>]
public class ProzessVersionExtensions {
    [GraphQLDescription("Liefert alle Schritte dieser Prozessversion.")]
    public async Task<IEnumerable<Schritt>> GetAlleSchritte(DomainContext domainContext,
        CurrentUserAccessor currentUserAccessor,
        [Parent] ProzessVersion prozessVersion) {
        var (backofficeUser, _) = await currentUserAccessor.EnsureBackofficeUser();

        var prozess = await domainContext.Prozesse.FirstOrDefaultAsync(p => p.Id == prozessVersion.ProzessId);
        if (prozess?.KommuneId != backofficeUser.KommuneId) {
            throw new NotAllowedException();
        }

        return await domainContext.Schritte.Where(s => s.ProzessVersionId == prozessVersion.Id).ToListAsync();
    }

    [GraphQLDescription("Gibt an, ob dieser Prozessversion bereits Ausführungen (Anträge) zugeordnet sind - auch abgeschlossene oder soft-gelöschte, da diese ein Hard-Delete der Version blockieren.")]
    public async Task<bool> GetHatAusfuehrungen(CurrentUserAccessor currentUserAccessor,
        IProzessByIdDataLoader prozessLoader, IHatAusfuehrungenByProzessVersionIdDataLoader dataLoader,
        [Parent] ProzessVersion prozessVersion) {
        var (backofficeUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozess = await prozessLoader.LoadAsync(prozessVersion.ProzessId);
        if (prozess.KommuneId != backofficeUser.KommuneId) {
            throw new NotAllowedException();
        }

        return await dataLoader.LoadAsync(prozessVersion.Id);
    }

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, bool>> GetHatAusfuehrungenByProzessVersionId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        var prozessVersionIdsMitAusfuehrungen = await domainContext.Ausfuehrungen
            .Where(a => ids.Contains(a.ProzessVersionId))
            .Select(a => a.ProzessVersionId)
            .Distinct()
            .ToHashSetAsync(ct);

        return ids.ToDictionary(id => id, id => prozessVersionIdsMitAusfuehrungen.Contains(id));
    }



    [GraphQLDescription("Liefert die ersten Schritte, die der Nutzer in diesem Prozess ausführen kann.")]
    public async Task<IEnumerable<Schritt>> ErsteSchritte(DomainContext context, [Parent] ProzessVersion prozessVersion,
        CurrentUserAccessor userAccessor, [Service] WalkerFactory walkerFactory) {
        var isBuerger = await userAccessor.User() is Buerger;

        if (prozessVersion.StartId is null) return Array.Empty<Schritt>();

        await using var walker = await walkerFactory.PreviewWalker(prozessVersion.Id,
            new Ausfuehrung {
                UserId = Guid.Empty,
                CreatedAt = Instant.MinValue,
                SharedKeyEncryptedForBuerger = "",
                SharedKeyEncryptedForKommune = "",
                SchrittId = prozessVersion.StartId.Value,
                Status = AusfuehrungStatus.BearbeitungDurchBuerger
            });

        if (walker.CurrentSchritt.ErledigungDurchBuerger != isBuerger) {
            return Array.Empty<Schritt>();
        }

        return walker.NextSchritteWithoutRequiredChoice().Prepend(walker.CurrentSchritt);
    }

    [GraphQLDescription("Liefert den Prozess, zu dem diese Prozessversion gehört.")]
    public async Task<Prozess> Prozess(IProzessByIdDataLoader dataLoader, [Parent] ProzessVersion prozessVersion) {
        return await dataLoader.LoadAsync(prozessVersion.ProzessId);
    }

    [GraphQLDescription("Liefert den Startschritt dieser Prozessversion.")]
    public async Task<Schritt?> GetStart([Parent] ProzessVersion prozessVersion,
        IStartByProzessVersionIdDataLoader loader) {
        return await loader.LoadAsync(prozessVersion.Id);
    }

    /// <summary>Lädt Prozesse anhand ihrer IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Prozess>> GetProzessById(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.Prozesse
            .Where(p => ids.Contains(p.Id))
            .ToDictionaryAsync(p => p.Id, ct);
    }

    /// <summary>Lädt Startschritte anhand von Prozessversions-IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Schritt>> GetStartByProzessVersionId(IReadOnlyList<Guid> keys,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.ProzessVersionen
            .AsSplitQuery()
            .Where(pv => keys.Contains(pv.Id))
            .Include(pv => pv.Start)
            .ToDictionaryAsync(pv => pv.Id, pv => pv.Start!, ct);
    }
}
