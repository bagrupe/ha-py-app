using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Dienstleistungen.Queries;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Kommune.Queries;

/// <summary>Stellt Abfragen für Kommunen bereit.</summary>
[QueryType]
public class KommuneQueries {
    /// <summary>Gibt alle Kommunen als Abfrage zurück.</summary>
    [AllowAnonymous]
    public IQueryable<Kommune> Kommunen(DomainContext context) {
        return context.Kommunen.AsQueryable();
    }

    /// <summary>Lädt eine Kommune anhand der Id asynchron.</summary>
    /// <param name="kommuneByIdDataLoader">DataLoader für Kommunen.</param>
    /// <param name="kommuneId">Id der Kommune.</param>
    [AllowAnonymous]
    public async Task<Kommune> Kommune(IKommuneByIdDataLoader kommuneByIdDataLoader, Guid kommuneId) {
        return await kommuneByIdDataLoader.LoadAsync(kommuneId);
    }

    /// <summary>Lädt mehrere Kommunen anhand ihrer Ids als Dictionary.</summary>
    /// <param name="ids">Liste der Kommunen-Ids.</param>
    /// <param name="domainContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Kommune>> GetKommuneById(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.Kommunen.Where(k => ids.Contains(k.Id)).ToDictionaryAsync(k => k.Id, ct);
    }
}

/// <summary>Erweitert den Typ Kommune um zusätzliche Felder und Abfragen.</summary>
[ExtendObjectType<Kommune>]
public class KommuneExtensions {
    /// <summary>Gibt den privaten Schlüssel der Kommune zurück, wenn der Benutzer berechtigt ist.</summary>
    /// <param name="kommune">Die Kommune.</param>
    /// <param name="userAccessor">Zugriff auf den aktuellen Benutzer.</param>
    public async Task<EncryptedValue?> PrivateKey([Parent] Kommune kommune,
        [Service] CurrentUserAccessor userAccessor) {
        var user = await userAccessor.User();

        if (user is Mitarbeiter mitarbeiter &&
            mitarbeiter.KommuneId == kommune.Id) {
            return kommune.PrivateKey;
        }

        throw new NotAllowedException();
    }

    /// <summary>Prüft, ob der Abfallkalender für die Kommune aktiviert ist.</summary>
    /// <param name="kommune">Die Kommune.</param>
    public bool AbfallkalenderEnabled([Parent] Kommune kommune) =>
        kommune.Id.Equals(new Guid("5a1aefef-809f-403d-a14c-27051353c7d4"));

    /// <summary>Lädt die Dienstleister der Kommune asynchron.</summary>
    /// <param name="kommune">Die Kommune.</param>
    /// <param name="loader">DataLoader für Dienstleister.</param>
    public async Task<IEnumerable<Dienstleister>> GetDienstleister([Parent] Kommune kommune,
        IDienstleisterByKommuneIdDataLoader loader) {
        return await loader.LoadAsync(kommune.Id);
    }

    /// <summary>Lädt Dienstleister gruppiert nach Kommune-Id.</summary>
    /// <param name="keys">Liste der Kommune-Ids.</param>
    /// <param name="dbContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    [DataLoader]
    internal static async Task<ILookup<Guid, Dienstleister>> GetDienstleisterByKommuneId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Dienstleister
            .Where(d => keys.Contains(d.MandantId))
            .ToLookupAsync(mg => mg.MandantId, ct);
    }

    /// <summary>Lädt Mitarbeitergruppen gruppiert nach Kommune-Id.</summary>
    /// <param name="keys">Liste der Kommune-Ids.</param>
    /// <param name="dbContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    [DataLoader]
    internal static async Task<ILookup<Guid, MitarbeiterGruppe>> GetMitarbeiterGruppenByKommuneId(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.MitarbeiterGruppen
            .Where(mg => keys.Contains(mg.KommuneId))
            .ToLookupAsync(mg => mg.KommuneId, ct);
    }

    /// <summary>Lädt die Untereinheiten der Kommune und sortiert sie nach Name.</summary>
    /// <param name="kommune">Die Kommune.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <param name="loader">DataLoader für Untereinheiten.</param>
    [HotChocolate.Data.UseFiltering]
    public async Task<IEnumerable<Untereinheit.Untereinheit>> GetUntereinheiten([Parent] Kommune kommune,
        CurrentUserAccessor currentUserAccessor,
        IUntereinheitenByKommuneIdLoaderDataLoader loader) {
        var untereinheiten = await loader.LoadAsync(kommune.Id);

        return untereinheiten.OrderBy(u => u.Name);
    }

    /// <summary>Lädt Untereinheiten gruppiert nach Kommune-Id, die nicht gelöscht sind.</summary>
    /// <param name="keys">Liste der Kommune-Ids.</param>
    /// <param name="dbContextFactory">Fabrik für den Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    [DataLoader]
    internal static async Task<ILookup<Guid, Untereinheit.Untereinheit>> GetUntereinheitenByKommuneIdLoader(
        IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Untereinheit
            .Where(u => keys.Contains(u.KommuneId) && !u.MarkedForDelete)
            .ToLookupAsync(u => u.KommuneId, ct);
    }
}

/// <summary>Erweitert den Typ Prozess um Abfragen zur Kommune.</summary>
[ExtendObjectType<Prozess.Prozess>]
public class ProzessKommuneQueries {
    /// <summary>Lädt die Kommune eines Prozesses asynchron.</summary>
    /// <param name="dataLoader">DataLoader für Kommunen.</param>
    /// <param name="prozess">Der Prozess.</param>
    public async Task<Kommune> GetKommune(IKommuneByIdDataLoader dataLoader, [Parent] Prozess.Prozess prozess) {
        return await dataLoader.LoadAsync(prozess.KommuneId);
    }
}
