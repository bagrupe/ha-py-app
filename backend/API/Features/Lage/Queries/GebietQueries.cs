using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage.Queries;

[QueryType]
public static class GebietQueries {
    /// <summary>Liefert die Gebiete der Kommune des aufrufenden Nutzers.</summary>
    /// <param name="withoutEinsatzleitung">Nur Gebiete ohne wirksame Einsatzleitung liefern.</param>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    public static async Task<IEnumerable<Gebiet>> GetGebiete(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        CancellationToken ct,
        bool? withoutEinsatzleitung = null) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var query = db.Gebiete.Where(g => g.Untereinheit.KommuneId == user.KommuneId);
        if (withoutEinsatzleitung == true) {
            query = query.Where(g => !db.GebietEinsatzleitungen
                .Where(GebietEinsatzleitung.IsEffective)
                .Any(ge => ge.GebietId == g.Id));
        }

        return await query.OrderBy(g => g.Name).ThenBy(g => g.Id).ToListAsync(ct);
    }
}

[ExtendObjectType<Gebiet>]
public static class GebietExtensions {
    /// <summary>Liefert die nicht gelöschten Mitarbeitergruppen, die als Einsatzleitung dieses Gebiets eingetragen sind und dessen Untereinheit noch angehören.</summary>
    public static async Task<IEnumerable<MitarbeiterGruppe>> GetEinsatzleitungen(
        [Parent] Gebiet gebiet,
        IEinsatzleitungenByGebietIdDataLoader dataLoader) {
        var gruppen = await dataLoader.LoadAsync(gebiet.Id);
        return gruppen.OrderBy(g => g.Ordinal);
    }

    [DataLoader]
    internal static async Task<ILookup<Guid, MitarbeiterGruppe>> GetEinsatzleitungenByGebietId(
        IReadOnlyList<Guid> gebietIds,
        IDbContextFactory<DomainContext> domainContextFactory,
        CancellationToken ct) {
        await using var db = await domainContextFactory.CreateDbContextAsync(ct);

        var links = await db.GebietEinsatzleitungen
            .Where(GebietEinsatzleitung.IsEffective)
            .Where(ge => gebietIds.Contains(ge.GebietId))
            .Select(ge => new { ge.GebietId, ge.MitarbeiterGruppe })
            .ToListAsync(ct);

        return links.ToLookup(l => l.GebietId, l => l.MitarbeiterGruppe);
    }
}
