using API.Features.Auth;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ Buerger um Abfragen zu den von ihm gefolgten Ausführungen.</summary>
[ExtendObjectType<Buerger>]
public class GefolgteAusfuehrungenQueries {
    /// <summary>Liefert alle Ausführungen, denen der angegebene Bürger folgt.</summary>
    /// <param name="buerger">Der Bürger, dessen gefolgte Ausführungen abgefragt werden.</param>
    /// <param name="loader">DataLoader zum Laden der gefolgten Ausführungen.</param>
    /// <returns>Eine Auflistung der gefolgten Ausführungen.</returns>
    [GraphQLDescription("Liefert alle Anträge (Ausführungen), denen dieser Bürger aktuell folgt.")]
    public async Task<IEnumerable<Ausfuehrung>> GefolgteAusfuehrungen([Parent] Buerger buerger, IGefolgteAusfuehrungenByUserIdDataLoader loader) {
        return await loader.LoadAsync(buerger.Id);
    }

    /// <summary>Lädt gefolgte Ausführungen für mehrere Benutzer anhand ihrer Ids.</summary>
    /// <param name="userIds">Liste der Benutzer-Ids.</param>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Lookup mit Benutzer-Id als Schlüssel und den gefolgten Ausführungen als Werte.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Ausfuehrung>> GetGefolgteAusfuehrungenByUserId(IReadOnlyList<Guid> userIds,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Buerger
            .Where(b => userIds.Contains(b.Id))
            .Include(b => b.GefolgteAusfuehrungen)
            .SelectMany(b => b.GefolgteAusfuehrungen
                .Where(a => a.GeloeschtAm == null)
                .Select(a => new { b.Id, Ausfuehrung = a }))
            .ToLookupAsync(b => b.Id, b => b.Ausfuehrung, ct);
    }
}

/// <summary>Erweitert den Typ Ausfuehrung um Abfragen, ob der aktuelle Nutzer dieser Ausführung folgt.</summary>
[ExtendObjectType<Ausfuehrung>]
public class AusfuehrungGefolgtQueries {
    /// <summary>Ermittelt, ob der aktuell angemeldete Nutzer der angegebenen Ausführung folgt.</summary>
    /// <param name="ausfuehrung">Die Ausführung, für die die Folgebeziehung geprüft wird.</param>
    /// <param name="loader">DataLoader zum Laden der Folgeinformationen.</param>
    /// <returns>True, wenn der aktuelle Nutzer folgt, sonst false.</returns>
    [GraphQLDescription("Gibt zurück, ob der aktuelle Nutzer diesem Antrag folgt.")]
    public async Task<bool> AktuellerNutzerFolgt([Parent] Ausfuehrung ausfuehrung, ICurrentUserFolgtByAusfuehrungIdDataLoader loader) {
        return await loader.LoadAsync(ausfuehrung.Id);
    }

    /// <summary>Lädt für mehrere Ausführungen, ob der aktuelle Nutzer ihnen folgt.</summary>
    /// <param name="ausfuehrungIds">Liste der Ausführungs-Ids.</param>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Dictionary mit Ausführungs-Id als Schlüssel und boolscher Folgeinformation als Wert.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, bool>> GetCurrentUserFolgtByAusfuehrungId(
        IReadOnlyList<Guid> ausfuehrungIds,
        IDbContextFactory<DomainContext> dbContextFactory,
        CurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        var user = await currentUserAccessor.User();
        if (user is not Buerger) return new Dictionary<Guid, bool>();

        var buerger = await db.Buerger
            .Include(buerger => buerger.GefolgteAusfuehrungen)
            .FirstOrDefaultAsync(b => b.Id == user.Id, ct);

        var gefolgteIds = buerger?.GefolgteAusfuehrungen.Select(a => a.Id).ToHashSet() ?? [];

        return ausfuehrungIds.ToDictionary(id => id, id => gefolgteIds.Contains(id));
    }
}
