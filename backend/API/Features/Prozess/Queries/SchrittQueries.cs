using API.Features.Auth;
using API.Features.Dienstleistungen;
using API.Features.Untereinheit;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ Schritt um Abfragen zu Verbindungen und Rollen.</summary>
[ExtendObjectType<Schritt>]
public class SchrittQueries {
    /// <summary>Liefert alle ausgehenden Verbindungen des angegebenen Schritts.</summary>
    /// <param name="schritt">Der Schritt, dessen Verbindungen abgefragt werden.</param>
    /// <param name="dataLoader">DataLoader zum Laden der Verbindungen.</param>
    /// <returns>Eine Auflistung der ausgehenden Verbindungen.</returns>
    [GraphQLDescription("Liefert alle ausgehenden Verbindungen dieses Schritts im Prozess.")]
    public async Task<IEnumerable<Verbindung>> GetVerbindungen([Parent] Schritt schritt, IVerbindungenBySchrittIdDataLoader dataLoader) {
        var verbindungen = await dataLoader.LoadAsync(schritt.Id);
        return verbindungen;
    }

    /// <summary>Lädt Verbindungen für mehrere Schritt-IDs.</summary>
    /// <param name="ids">Liste der Schritt-IDs.</param>
    /// <param name="domainContextFactory">Factory zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Lookup von Schritt-ID zu Verbindungen.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Verbindung>> GetVerbindungenBySchrittId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var db = await domainContextFactory.CreateDbContextAsync(ct);

        return await db.Verbindungen
            .Where(x => ids.Contains(x.VonId))
            .ToLookupAsync(v => v.VonId, ct);
    }

    /// <summary>Lädt Schritte anhand ihrer IDs.</summary>
    /// <param name="ids">Liste der Schritt-IDs.</param>
    /// <param name="domainContextFactory">Factory zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary von Schritt-ID zu Schritt.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Schritt>> GetSchrittBySchrittId(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var db = await domainContextFactory.CreateDbContextAsync(ct);

        return await db.Schritte
            .Where(schritt => ids.Contains(schritt.Id))
            .ToDictionaryAsync(s => s.Id, ct);
    }

    /// <summary>Lädt Mitarbeitergruppen anhand ihrer IDs.</summary>
    /// <param name="ids">Liste der Mitarbeitergruppen-IDs.</param>
    /// <param name="domainContextFactory">Factory zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary von Mitarbeitergruppen-ID zu Mitarbeitergruppe.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, MitarbeiterGruppe>> GetMitarbeiterGruppeById(IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var db = await domainContextFactory.CreateDbContextAsync(ct);

        return await db.MitarbeiterGruppen
            .Where(mg => ids.Contains(mg.Id))
            .ToDictionaryAsync(mg => mg.Id, ct);

    }

    /// <summary>Liefert die Rolle, die nach Bearbeitung des Schritts gesetzt wird.</summary>
    /// <param name="schritt">Der Schritt, dessen SchreibtRolle abgefragt wird.</param>
    /// <param name="loader">DataLoader zum Laden der Rolle.</param>
    /// <returns>Die SchreibtRolle oder null, falls nicht gesetzt.</returns>
    [GraphQLDescription("Liefert die Rolle, die nach Bearbeitung dieses Schritts gesetzt wird (SchreibtRolle).")]
    public async Task<ZustaendigkeitRolle?> GetSchreibtRolle([Parent] Schritt schritt,
        IZustaendigkeitRolleByIdDataLoader loader) {
        if (schritt.SchreibtRolleId == null)
            return null;
        return await loader.LoadAsync(schritt.SchreibtRolleId.Value);
    }
}

/// <summary>Erweitert den Typ Zustaendigkeit um Abfragen zu zugehörigen Entitäten.</summary>
[ExtendObjectType<Zustaendigkeit>]
public class ZustaendigkeitExtensions {
    /// <summary>Liefert den zuständigen Dienstleister.</summary>
    /// <param name="zustaendigkeit">Die Zuständigkeit.</param>
    /// <param name="dataLoader">DataLoader zum Laden des Dienstleisters.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Der Dienstleister oder null, falls nicht gesetzt.</returns>
    [GraphQLDescription("Liefert den zuständigen Dienstleister.")]
    public async Task<Dienstleister?> GetDienstleister([Parent] Zustaendigkeit zustaendigkeit, IDienstleisterByIdDataLoader dataLoader, CancellationToken ct) {
        if (zustaendigkeit.DienstleisterId is null) return null;
        return await dataLoader.LoadAsync(zustaendigkeit.DienstleisterId.Value, ct);
    }
    /// <summary>Liefert die zuständige Organisationseinheit.</summary>
    /// <param name="zustaendigkeit">Die Zuständigkeit.</param>
    /// <param name="dataLoader">DataLoader zum Laden der Organisationseinheit.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Die Organisationseinheit oder null, falls nicht gesetzt.</returns>
    [GraphQLDescription("Liefert die zuständige Organisationseinheit.")]
    public async Task<Untereinheit.Untereinheit?> GetOrganisationseinheit([Parent] Zustaendigkeit zustaendigkeit, IUntereinheitByUntereinheitIdDataLoader dataLoader, CancellationToken ct) {
        if (zustaendigkeit.OrganisationseinheitId is null) return null;
        return await dataLoader.LoadAsync(zustaendigkeit.OrganisationseinheitId.Value, ct);
    }

    /// <summary>Liefert die zuständige Mitarbeitergruppe.</summary>
    /// <param name="zustaendigkeit">Die Zuständigkeit.</param>
    /// <param name="dataLoader">DataLoader zum Laden der Mitarbeitergruppe.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Die Mitarbeitergruppe oder null, falls nicht gesetzt.</returns>
    [GraphQLDescription("Liefert die zuständige Mitarbeitergruppe.")]
    public async Task<MitarbeiterGruppe?> GetMitarbeiterGruppe([Parent] Zustaendigkeit zustaendigkeit, IMitarbeiterGruppeByIdDataLoader dataLoader, CancellationToken ct) {
        if (zustaendigkeit.MitarbeiterGruppeId is null) return null;
        return await dataLoader.LoadAsync(zustaendigkeit.MitarbeiterGruppeId.Value, ct);
    }

    /// <summary>Liefert die zugewiesene Person.</summary>
    /// <param name="zustaendigkeit">Die Zuständigkeit.</param>
    /// <param name="mitarbeiterByIdDataLoader">DataLoader zum Laden der Person.</param>
    /// <returns>Die zugewiesene Person oder null, falls nicht gesetzt.</returns>
    [GraphQLDescription("Liefert die zuständige (zugewiesene) Person.")]
    public async Task<Mitarbeiter?> GetZugewiesenePerson([Parent] Zustaendigkeit zustaendigkeit,
        IMitarbeiterByIdDataLoader mitarbeiterByIdDataLoader) {
        if (zustaendigkeit.ZugewiesenePersonId == null)
            return null;
        return await mitarbeiterByIdDataLoader.LoadAsync(zustaendigkeit.ZugewiesenePersonId.Value);
    }

    /// <summary>Liefert die Rolle, die im Falle einer Soll-Zuständigkeit gelesen wird.</summary>
    /// <param name="zustaendigkeit">Die Zuständigkeit.</param>
    /// <param name="loader">DataLoader zum Laden der Rolle.</param>
    /// <returns>Die liestRolle oder null, falls nicht gesetzt.</returns>
    [GraphQLDescription("Liefert die Rolle, die im Falle einer Soll-Zuständigkeit gelesen wird.")]
    public async Task<ZustaendigkeitRolle?> GetLiestRolle([Parent] Zustaendigkeit zustaendigkeit,
        IZustaendigkeitRolleByIdDataLoader loader) {
        if (zustaendigkeit.LiestRolleId == null)
            return null;
        return await loader.LoadAsync(zustaendigkeit.LiestRolleId.Value);
    }

    /// <summary>Lädt Zuständigkeitsrollen anhand ihrer IDs.</summary>
    /// <param name="keys">Liste der Rollen-IDs.</param>
    /// <param name="dbContextFactory">Factory zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary von Rollen-ID zu Rolle.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, ZustaendigkeitRolle>> ZustaendigkeitRolleById(IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.ZustaendigkeitRollen.Where(r => keys.Contains(r.Id)).ToDictionaryAsync(r => r.Id, d => d, ct);
    }

    /// <summary>Lädt Dienstleister anhand ihrer IDs.</summary>
    /// <param name="keys">Liste der Dienstleister-IDs.</param>
    /// <param name="dbContextFactory">Factory zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary von Dienstleister-ID zu Dienstleister.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Dienstleister>> DienstleisterById(IReadOnlyList<Guid> keys, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);
        return await db.Dienstleister.Where(d => keys.Contains(d.Id)).ToDictionaryAsync(d => d.Id, d => d, ct);
    }

    /// <summary>Lädt Mitarbeiter anhand ihrer IDs.</summary>
    /// <param name="ids">Liste der Mitarbeiter-IDs.</param>
    /// <param name="domainContextFactory">Factory zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Dictionary von Mitarbeiter-ID zu Mitarbeiter.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Mitarbeiter>> GetMitarbeiterById(
        IReadOnlyList<Guid> ids,
        IDbContextFactory<DomainContext> domainContextFactory,
        CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.Mitarbeiter
            .Where(m => ids.Contains(m.Id))
            .ToDictionaryAsync(m => m.Id, ct);
    }

}
