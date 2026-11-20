using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage.Queries;

[QueryType]
public static class LageQueries {
    /// <summary>Get Lagen from the calling user's Kommune</summary>
    /// <param name="status">Only Lagen with this status</param>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    public static async Task<IEnumerable<Lage>> GetLagen(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        CancellationToken ct,
        LageStatus? status = null) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        var query = LagenOfKommune(db, user.KommuneId);
        if (status is not null) {
            query = query.Where(l => l.Status == status);
        }

        return await query.OrderByDescending(l => l.CreatedAt).ThenBy(l => l.Id).ToListAsync(ct);
    }

    /// <summary>Get a specific Lage by ID</summary>
    /// <param name="id">Lage ID</param>
    [Authorize]
    [Error(typeof(NotAllowedException))]
    public static async Task<Lage?> GetLage(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        Guid id,
        CancellationToken ct) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.LageHelfer).Fordern();

        return await LagenOfKommune(db, user.KommuneId).FirstOrDefaultAsync(l => l.Id == id, ct);
    }

    private static IQueryable<Lage> LagenOfKommune(DomainContext db, Guid kommuneId) =>
        db.Lagen
            .Include(l => l.LageGebiete).ThenInclude(lg => lg.Gebiet)
            .Where(l => l.DeletedAt == null && l.Untereinheit.KommuneId == kommuneId);
}
