using API.Features.Auth;
using API.Features.Ehrenamtsbank.Mutations;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank.Queries;

/// <summary>
/// Queries für Anfragen (Ehrenamtsbank)
/// </summary>
[QueryType]
public class AnfrageQueries {

    /// <summary>
    /// Gibt die Anfragen des Users zurück. Dies beinhaltet Anfragen die er gestellt hat,
    /// und Anfragen auf von im erstellte Einträge
    /// </summary>
    [Authorize]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Error(typeof(NotAllowedException))]
    public async Task<IQueryable<EhrenamtsbankAnfrage>> GetMeineEhrenamtsbankAnfragen(
        CurrentUserAccessor currentUserAccessor,
        DomainContext domainContext
    ) {
        var user = await currentUserAccessor.EnsureRegisteredBuerger();

        return domainContext.EhrenamtsbankAnfragen
            .Where(a =>
                a.InteressentId == user.Id
                || (a.Eintrag.OwnerId == user.Id && !a.Eintrag.IsDeleted))
            .OrderByDescending(a => a.UpdatedAt)
            .ThenBy(a => a.Id);
    }

    /// <summary>
    /// Gibt die Anfragen für einen bestimmten EhrenamtsbankEintrag zurück.
    /// Der Owner sieht alle Anfragen; ein Interessent nur die eigene.
    /// </summary>
    [Authorize]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Error(typeof(EintragNotFoundException))]
    [Error(typeof(NotAllowedException))]
    public async Task<IQueryable<EhrenamtsbankAnfrage>> GetAnfragenFuerEhrenamtsbankEintrag(
        CurrentUserAccessor currentUserAccessor,
        DomainContext db,
        Guid id,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();

        var ownerId = await db.EhrenamtsbankEintraege
            .Where(e => e.Id == id && !e.IsDeleted)
            .Select(e => (Guid?)e.OwnerId)
            .FirstOrDefaultAsync(ct);
        if (ownerId is null) {
            throw new EintragNotFoundException();
        }

        var isOwner = ownerId == buerger.Id;
        return db.EhrenamtsbankAnfragen
            .Where(a => a.EintragId == id && (isOwner || a.InteressentId == buerger.Id))
            .OrderByDescending(a => a.UpdatedAt)
            .ThenBy(a => a.Id);
    }

    [Authorize]
    [Error(typeof(AnfrageNotFoundException))]
    [Error(typeof(NotAllowedException))]
    public async Task<EhrenamtsbankAnfrage> GetEhrenamtsbankAnfrage(
        Guid id,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();

        return await db.EhrenamtsbankAnfragen
            .Where(a => a.Id == id
                && (a.InteressentId == buerger.Id
                    || (a.Eintrag.OwnerId == buerger.Id && !a.Eintrag.IsDeleted)))
            .FirstOrDefaultAsync(ct)
            ?? throw new AnfrageNotFoundException();
    }

    [Authorize]
    [Error(typeof(NotAllowedException))]
    public async Task<EhrenamtsbankAnfrage?> GetMeineEhrenamtsbankAnfrageFuerEintrag(
        Guid eintragId,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();

        return await db.EhrenamtsbankAnfragen
            .Where(a => a.EintragId == eintragId && a.InteressentId == buerger.Id)
            .FirstOrDefaultAsync(ct);
    }
}

[ExtendObjectType<EhrenamtsbankAnfrage>]
public class AnfrageExtensions {
    public async Task<EhrenamtsbankEintrag?> Eintrag(
        [Parent] EhrenamtsbankAnfrage anfrage,
        IEhrenamtsbankEintragByIdDataLoader eintraege,
        CancellationToken ct) =>
        await eintraege.LoadAsync(anfrage.EintragId, ct);

    [GraphQLDescription("Buchung, die aus dem Abschluss dieser Anfrage entstanden ist")]
    public async Task<EhrenamtsbankTransaktion?> Transaktion(
        [Parent] EhrenamtsbankAnfrage anfrage,
        IEhrenamtsbankTransaktionByAnfrageIdDataLoader transaktionen,
        CancellationToken ct) =>
        await transaktionen.LoadAsync(anfrage.Id, ct);

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, EhrenamtsbankEintrag>> GetEhrenamtsbankEintragById(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> factory, CancellationToken ct) {
        await using var db = await factory.CreateDbContextAsync(ct);
        return await db.EhrenamtsbankEintraege
            .Where(e => ids.Contains(e.Id) && !e.IsDeleted)
            .ToDictionaryAsync(e => e.Id, ct);
    }

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, EhrenamtsbankTransaktion>>
        GetEhrenamtsbankTransaktionByAnfrageId(
            IReadOnlyList<Guid> anfrageIds, IDbContextFactory<DomainContext> factory, CancellationToken ct) {
        await using var db = await factory.CreateDbContextAsync(ct);
        return await db.EhrenamtsbankTransaktionen
            .Where(t => anfrageIds.Contains(t.AnfrageId))
            .ToDictionaryAsync(t => t.AnfrageId, ct);
    }
}

/// <summary>
/// Typ einer Anfrage: EmpfangeneAnfrage = Anfrage die auf ein Eintrag vom Benutzer gestellt wurde,
/// EigeneAnfrage: Anfrage die der Benutzer für einen anderen Eintrag gestellt hat.
/// </summary>
public enum EhrenamtsbankAnfrageTyp {
    EmpfangeneAnfrage,
    EigeneAnfrage
}

/// <summary>
/// Erweitert das GraphQL für eine EhrenamtsbankAnfrage um den typ (eigene oder empfangene Anfrage)
/// </summary>
[ExtendObjectType<EhrenamtsbankAnfrage>]
public class EhrenamtsbankAnfrageExtensions {
    public async Task<EhrenamtsbankAnfrageTyp> GetTypAsync(
        [Parent] EhrenamtsbankAnfrage anfrage,
        CurrentUserAccessor currentUserAccessor
    ) {
        var user = await currentUserAccessor.User();
        return anfrage.InteressentId == user.Id ? EhrenamtsbankAnfrageTyp.EigeneAnfrage : EhrenamtsbankAnfrageTyp.EmpfangeneAnfrage;
    }

    public async Task<EhrenamtsbankProfil?> Interessent(
    [Parent] EhrenamtsbankAnfrage anfrage,
    IUserByIdDataLoader users,
    CurrentUserAccessor currentUserAccessor,
    CancellationToken ct) {
        if (await users.LoadAsync(anfrage.InteressentId, ct) is not Buerger interessent) {
            return null;
        }
        var caller = await EhrenamtsbankCurrentUser.TryGetBuerger(currentUserAccessor);
        var callerIsRegistered = caller is { IsRegistered: true };
        return new EhrenamtsbankProfil(
            interessent.Id, interessent.Vorname, interessent.Nachname,
            interessent.PhoneVerified, interessent.RequiresClearanceVerified,
            callerIsRegistered && interessent.PhoneVerified ? interessent.Phone : null);
    }
}
