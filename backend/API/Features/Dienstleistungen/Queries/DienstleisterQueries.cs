using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess.Queries;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Dienstleistungen.Queries;

/// <summary>
/// Stellt Abfragen für Dienstleister bereit.
/// </summary>
[QueryType]
public static class DienstleisterQueries {
    /// <summary>
    /// Liefert eine Abfrage für Dienstleister des aktuellen Mandanten, optional gefiltert nach Einladungsberechtigung.
    /// </summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <param name="domainContext">Datenbankkontext.</param>
    /// <param name="ichKannEinladen">Filtert Dienstleister, wenn der Benutzer Einladungsrechte besitzt.</param>
    /// <returns>Abfrage von Dienstleistern.</returns>
    [UseOffsetPaging(IncludeTotalCount = true)]
    [Authorize]
    public static async Task<IQueryable<Dienstleister>> GetDienstleister(
        CurrentUserAccessor currentUserAccessor,
        DomainContext domainContext,
        bool? ichKannEinladen
    ) {
        var (user, _) = await currentUserAccessor.EnsureBackofficeUser();

        var dienstleister = domainContext.Dienstleister.Where(d => d.MandantId == user.KommuneId);

        if (ichKannEinladen is true && user.Art != BackofficeNutzerArt.Superadmin) {
            var organisationseinheitIds = user.UntereinheitPermissions
                .Where(oe =>
                    oe.Funktionsberechtigungen.Contains(FunktionsberechtigungInOrganisationseinheit
                        .BackofficeDienstleisterverwaltung))
                .Select(oe => oe.UntereinheitId)
                .ToList();
            dienstleister = dienstleister.Where(d =>
                d.Organisationseinheiten.Any(oe => organisationseinheitIds.Contains(oe.Id)));
        }

        return dienstleister.OrderBy(d => d.Name);
    }
}

/// <summary>
/// Erweiterungen für den Dienstleister-Typ.
/// </summary>
[ExtendObjectType<Dienstleister>]
public static class DienstleisterExtensions {
    /// <summary>
    /// Liefert die Organisationseinheiten eines Dienstleisters.
    /// </summary>
    /// <param name="dienstleister">Der Dienstleister.</param>
    /// <param name="organisationseinheitenByDienstleisterId">DataLoader für Organisationseinheiten.</param>
    /// <returns>Liste der zugehörigen Organisationseinheiten.</returns>
    public static async Task<IEnumerable<Untereinheit.Untereinheit>> GetOrganisationseinheiten(
        [Parent] Dienstleister dienstleister, IOrganisationseinheitenByDienstleisterIdDataLoader organisationseinheitenByDienstleisterId) {
        return await organisationseinheitenByDienstleisterId.LoadAsync(dienstleister.Id);
    }

    /// <summary>
    /// Lädt Organisationseinheiten für mehrere Dienstleister anhand ihrer IDs.
    /// </summary>
    /// <param name="keys">Liste der Dienstleister-IDs.</param>
    /// <param name="dbContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Dienstleister-ID und zugehörigen Organisationseinheiten.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, List<Untereinheit.Untereinheit>>> GetOrganisationseinheitenByDienstleisterId(IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.Dienstleister.Include(d => d.Organisationseinheiten).Where(d => keys.Contains(d.Id)).ToDictionaryAsync(d => d.Id, d => d.Organisationseinheiten, ct);
    }
}

/// <summary>
/// Erweiterungen für den Backoffice-Benutzer-Typ.
/// </summary>
[ExtendObjectType<BackofficeUser>]
public static class BackofficeUserExtensions {
    /// <summary>
    /// Liefert den Dienstleister eines Backoffice-Benutzers, falls vorhanden.
    /// </summary>
    /// <param name="backofficeUser">Der Backoffice-Benutzer.</param>
    /// <param name="dienstleisterById">DataLoader für Dienstleister.</param>
    /// <returns>Der zugehörige Dienstleister oder null.</returns>
    public static async Task<Dienstleister?> GetDienstleister([Parent] BackofficeUser backofficeUser, IDienstleisterByIdDataLoader dienstleisterById) {
        if (backofficeUser.DienstleisterId is null) return null;
        return await dienstleisterById.LoadAsync(backofficeUser.DienstleisterId.Value);
    }

    /// <summary>
    /// Lädt mehrere Dienstleister anhand ihrer IDs.
    /// </summary>
    /// <param name="keys">Liste der Dienstleister-IDs.</param>
    /// <param name="dbContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary mit Dienstleister-ID und Dienstleister-Objekt.</returns>
    internal static async Task<IReadOnlyDictionary<Guid, Dienstleister>> GetDienstleisterById(IReadOnlyList<Guid> keys,
        IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.Dienstleister.Where(d => keys.Contains(d.Id)).ToDictionaryAsync(d => d.Id, d => d, ct);
    }
}
