using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ Kommune um Abfragen zu Prozessen und Service-Portal-Links.</summary>
[ExtendObjectType<Kommune.Kommune>]
public class ProzessQueries {
    [GraphQLDescription("Liefert alle Prozesse dieser Kommune. Optional filterbar nach Gruppe oder Suchbegriff.")]
    public async Task<IEnumerable<Prozess>> GetProzesse([Parent] Kommune.Kommune kommune, IProzesseByKommuneIdDataLoader dataLoader, Guid? groupId, String? search) {
        var foundProzesse = await dataLoader.LoadAsync(kommune.Id);
        if (groupId.HasValue) {
            foundProzesse = foundProzesse.Where(p => p.Group != null && p.Group.Id == groupId).ToArray();

        }
        if (!string.IsNullOrWhiteSpace(search)) {
            foundProzesse = foundProzesse.Where(p => p.Name.ToLower().Contains(search.ToLower())).ToArray();
        }
        return foundProzesse;
    }

    [GraphQLDescription("Liefert einen Prozess anhand eines Tags für diese Kommune.")]
    public async Task<Prozess> GetProzessByTag(string tag, [Parent] Kommune.Kommune kommune, IProzessByKommuneAndTagDataLoader loader) {
        return await loader.LoadAsync((kommune.Id, tag));
    }

    [GraphQLDescription("Liefert alle Prozesse und Service-Portal-Links dieser Kommune. Optional filterbar nach Gruppe oder Suchbegriff.")]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    public async Task<IEnumerable<UserFacingProzess>> GetProzesseUndLeistungen([Parent] Kommune.Kommune kommune, IProzesseByKommuneIdDataLoader prozesseLoader, IServicePortalLinksByKommuneIdDataLoader servicePortalLinksLoader, Guid? groupId, String? search) {
        // Using distinct loaders per type of UserFacingProzess allows us to change behaviour based on their type.
        //  (for example, Prozesse are filtered based on whether they are released or not)
        var prozesse = await prozesseLoader.LoadAsync(kommune.Id);
        var servicePortalLinks = await servicePortalLinksLoader.LoadAsync(kommune.Id);

        var userFacingProzesse = prozesse.Cast<UserFacingProzess>().Concat(servicePortalLinks);

        if (groupId.HasValue) {
            userFacingProzesse = userFacingProzesse.Where(p => p.GroupId == groupId).ToArray();
        }

        if (!string.IsNullOrWhiteSpace(search)) {
            userFacingProzesse = userFacingProzesse.Where(l => l.Name.ToLower().Contains(search.ToLower())).ToArray();
        }

        // Deterministische Reihenfolge nötig, damit [UseOffsetPaging] stabil paginiert (Name allein
        // ist nicht eindeutig) - die Middleware wendet Skip/Take/Count in-memory auf dieser IEnumerable an.
        return userFacingProzesse.OrderBy(p => p.Name).ThenBy(p => p.Id);
    }

    [GraphQLDescription("Liefert einen Prozess anhand seiner ID für diese Kommune.")]
    public async Task<Prozess> GetProzessById(Guid id, [Parent] Kommune.Kommune kommune, IProzessByIdAndKommuneIdDataLoader loader) {
        return await loader.LoadAsync((kommune.Id, id));
    }

    /// <summary>Lädt Prozesse anhand von Kommune- und Prozess-IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<(Guid kommuneId, Guid prozessId), Prozess>> GetProzessByIdAndKommuneId(IReadOnlyList<(Guid kommuneId, Guid prozessId)> keys, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        var stringifiedKeys = keys.Select(k => $"{k.kommuneId}_{k.prozessId}").ToList();

        return await domainContext.Prozesse.Where(p => stringifiedKeys.Contains(p.KommuneId.ToString() + "_" + p.Id.ToString())).ToDictionaryAsync(p => (p.KommuneId, p.Id), ct);
    }

    [GraphQLDescription("Liefert einen Service-Portal-Link anhand seiner ID für diese Kommune.")]
    public async Task<ServicePortalLink> GetServicePortalLink(Guid id, [Parent] Kommune.Kommune kommune, IServicePortalLinkByIdDataLoader loader) {
        var link = await loader.LoadAsync(id);
        if (link.KommuneId != kommune.Id) throw new ProzessNotFound("Not found");

        return link;
    }

    /// <summary>Lädt Service-Portal-Links anhand ihrer IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, ServicePortalLink>> GetServicePortalLinkById(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.ServicePortalLink
            .Where(l => keys.Contains(l.Id))
            .ToDictionaryAsync(l => l.Id, ct);
    }

    [GraphQLDescription("Liefert alle Prozessgruppen dieser Kommune.")]
    public async Task<IEnumerable<ProzessGroup>> GetProzessGroups([Parent] Kommune.Kommune kommune, IProzessGroupsByKommuneIdDataLoader loader) {
        return await loader.LoadAsync(kommune.Id);
    }

    /// <summary>Lädt Prozessgruppen anhand von Kommune-IDs.</summary>
    [DataLoader]
    public static async Task<ILookup<Guid, ProzessGroup>> GetProzessGroupsByKommuneId(IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.ProzessGroups.Where(pg => keys.Contains(pg.KommuneId)).OrderBy(pg => pg.Name).ToLookupAsync(pg => pg.KommuneId, ct);
    }

    // ProzessTag hat keine KommuneId, daher ungefiltert - aber Prozesse anderer Kommunen bleiben unsichtbar.
    [Authorize]
    [GraphQLDescription("Liefert alle im System vorhandenen Prozess-Tags zur Auswahl bei der Tag-Zuweisung.")]
    public async Task<IEnumerable<ProzessTag>> GetProzessTags([Parent] Kommune.Kommune kommune, DomainContext db, CurrentUserAccessor currentUserAccessor) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        return await db.ProzessTags
            .Include(t => t.Prozesse.Where(p => p.KommuneId == kommune.Id))
            .OrderBy(t => t.Tag)
            .ToListAsync();
    }

    /// <summary>Lädt Prozesse anhand von Kommune-IDs unter Berücksichtigung des aktuellen Nutzers.</summary>
    [DataLoader]
    internal static async Task<ILookup<Guid, Prozess>> GetProzesseByKommuneId(IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct, CurrentUserAccessor userAccessor) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await userAccessor.User() switch {
            BackofficeUser backofficeUser => await domainContext.Prozesse
                .Where(p => p.Kommune.Id == backofficeUser.KommuneId && ids.Contains(p.KommuneId)).Include(p => p.Group)
                .ToLookupAsync(p => p.KommuneId, ct),
            _ => await domainContext.Prozesse
                .Where(p => ids.Contains(p.KommuneId) && p.DeaktiviertAm == null &&
                            p.Versionen.Any(pv => pv.PublishedAt != null)).Include(p => p.Group)
                .ToLookupAsync(p => p.KommuneId, ct)
        };
    }

    /// <summary>Lädt Prozesse anhand von Kommune-IDs und Tags.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<(Guid kommuneId, string tag), Prozess>> GetProzessByKommuneAndTag(
        IReadOnlyList<(Guid kommuneId, string tag)> keys,
        IDbContextFactory<DomainContext> domainContextFactory,
        CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        var kommuneIds = keys.Select(k => k.kommuneId);
        var tagNames = keys.Select(k => k.tag);
        var roughlyMatchingProzesse = await domainContext.Prozesse
            .Where(p => kommuneIds.Contains(p.KommuneId) && p.Tags.Any(t => tagNames.Contains(t.Tag)))
            .Include(prozess => prozess.Tags)
            .ToListAsync(ct);

        return keys.ToDictionary(
            k => k,
            k => roughlyMatchingProzesse
                .Single(p => p.KommuneId == k.kommuneId && p.Tags.Select(t => t.Tag).Contains(k.tag))
        );
    }

    /// <summary>Lädt Service-Portal-Links anhand von Kommune-IDs.</summary>
    [DataLoader]
    internal static async Task<ILookup<Guid, ServicePortalLink>> GetServicePortalLinksByKommuneId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.ServicePortalLink
            .Where(p => keys.Contains(p.KommuneId))
            .ToLookupAsync(l => l.KommuneId, ct);
    }
}

/// <summary>Erweitert den Typ Prozess um Abfragen zu Tags.</summary>
[ExtendObjectType<Prozess>]
public class ProzessExtension {
    [GraphQLDescription("Liefert alle Tags dieses Prozesses.")]
    public async Task<IEnumerable<ProzessTag>> GetTags([Parent] Prozess prozess, ITagsByProzessIdDataLoader loader) {
        return await loader.LoadAsync(prozess.Id);
    }

    /// <summary>Lädt Tags anhand von Prozess-IDs.</summary>
    [DataLoader]
    internal static async Task<ILookup<Guid, ProzessTag>> GetTagsByProzessId(IReadOnlyList<Guid> keys,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Prozesse
            .Where(p => keys.Contains(p.Id))
            .Include(p => p.Tags)
            .SelectMany(p => p.Tags.Select(t => new { Prozess = p, Tag = t }))
            .ToLookupAsync(record => record.Prozess.Id, record => record.Tag, ct);
    }

    [GraphQLDescription("Gibt an, ob der Prozess öffentlich ist (Mängelmelder, Ideenmelder). Bleibt wahr, wenn der Tag später umgehängt wurde.")]
    public async Task<bool> GetIstOeffentlich([Parent] Prozess prozess, IIstOeffentlichByProzessIdDataLoader loader) {
        return await loader.LoadAsync(prozess.Id);
    }

    /// <summary>Same rule as <c>OnlyPublic</c>, based on the Tag-Historie.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, bool>> GetIstOeffentlichByProzessId(IReadOnlyList<Guid> keys,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Prozesse
            .Where(p => keys.Contains(p.Id))
            .Select(p => new {
                p.Id,
                IstOeffentlich = p.TagHistorie.Any(h => AusfuehrungQueryableExtensions.PublicTags.Contains(h.Tag.Tag))
            })
            .ToDictionaryAsync(p => p.Id, p => p.IstOeffentlich, ct);
    }
}

/// <summary>Erweitert den Typ UserFacingProzess um Abfragen zur Gruppe.</summary>
[ExtendObjectType<UserFacingProzess>]
public class UserFacingProzessExtension {
    [GraphQLDescription("Liefert die Gruppe dieses Prozesses.")]
    public async Task<ProzessGroup?> GetGroup([Parent] UserFacingProzess userFacingProzess, IGroupByProzessIdDataLoader loader) {
        return await loader.LoadAsync(userFacingProzess.Id);
    }

    /// <summary>Lädt Gruppen anhand von UserFacingProzess-IDs.</summary>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, ProzessGroup>> GetGroupByProzessId(IReadOnlyList<Guid> keys,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.UserFacingProzesse
            .Where(p => keys.Contains(p.Id))
            .Include(p => p.Group)
            .ToDictionaryAsync(p => p.Id, p => p.Group!, ct);
    }
}

/// <summary>Ausnahme für den Fall, dass ein Prozess nicht gefunden wird.</summary>
public class ProzessNotFound(string message = "Prozess not found") : DomainException(message);
