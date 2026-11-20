using API.Features.Auth;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Untereinheit.Queries;

/// <summary>Erweitert Organisationseinheiten (<see cref="Untereinheit"/>) um Mitarbeitergruppen.</summary>
[ExtendObjectType<Untereinheit>]
public static class UntereinheitQueries {
    /// <summary>
    /// Liefert Mitarbeitergruppen, die dieser Organisationseinheit zugeordnet sind (Many-to-many über <c>MitarbeiterGruppeUntereinheit</c>).
    /// </summary>
    /// <param name="untereinheit">Die Organisationseinheit.</param>
    /// <param name="userAccessor">Aktueller Nutzer.</param>
    /// <param name="dataLoader">Gebündeltes Laden nach Untereinheit-Id.</param>
    /// <param name="includeDeleted">Gelöschte Gruppen einschließen.</param>
    [Authorize]
    public static async Task<IEnumerable<MitarbeiterGruppe>> GetMitarbeiterGruppen(
        [Parent] Untereinheit untereinheit,
        CurrentUserAccessor userAccessor,
        IMitarbeiterGruppenByUntereinheitIdDataLoader dataLoader,
        bool includeDeleted = false) {
        var user = await userAccessor.User();
        if (user is not Mitarbeiter mitarbeiter) {
            throw new NotAllowedException("MitarbeiterGruppen can only be queried by Mitarbeiter");
        }

        if (mitarbeiter.KommuneId != untereinheit.KommuneId) {
            throw new NotAllowedException(
                "MitarbeiterGruppen can only be queried for Organisationseinheiten of the same Kommune");
        }

        var gruppen = await dataLoader.LoadAsync(untereinheit.Id);
        return gruppen
            .Where(g => includeDeleted || !g.IsDeleted)
            .OrderBy(g => g.Ordinal);
    }

    /// <summary>Lädt Mitarbeitergruppen gruppiert nach Organisationseinheit-Id.</summary>
    [DataLoader]
    internal static async Task<ILookup<Guid, MitarbeiterGruppe>> GetMitarbeiterGruppenByUntereinheitId(
        IReadOnlyList<Guid> untereinheitIds,
        IDbContextFactory<DomainContext> domainContextFactory,
        CancellationToken ct) {
        await using var db = await domainContextFactory.CreateDbContextAsync(ct);

        var gruppen = await db.MitarbeiterGruppen
            .Include(g => g.Organisationseinheiten)
            .Where(g => g.Organisationseinheiten.Any(oe => untereinheitIds.Contains(oe.Id)))
            .ToListAsync(ct);

        return gruppen
            .SelectMany(g => g.Organisationseinheiten
                .Where(oe => untereinheitIds.Contains(oe.Id))
                .Select(oe => (UntereinheitId: oe.Id, Gruppe: g)))
            .ToLookup(t => t.UntereinheitId, t => t.Gruppe);
    }
}
