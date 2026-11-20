using System.Linq.Expressions;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using API.Options;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace API.Features.Ehrenamtsbank.Queries;

[GraphQLDescription("Zeitkonto eines Bürgers. Alle Werte sind Minuten.")]
public record EhrenamtsbankZeitkonto(
    [property: GraphQLDescription("Startguthaben, das jedem Bürger gutgeschrieben wird.")]
    int StartCreditMinutes,
    [property: GraphQLDescription("Summe der geleisteten Minuten (Gutschrift).")]
    int CreditMinutes,
    [property: GraphQLDescription("Summe der erhaltenen Minuten (Belastung).")]
    int DebitMinutes
) {
    [GraphQLDescription("Startguthaben plus Gutschrift minus Belastung. Kann negativ sein.")]
    public int BalanceMinutes => StartCreditMinutes + CreditMinutes - DebitMinutes;
}

[GraphQLDescription("Rolle des Aufrufers in einer Buchung.")]
public enum EhrenamtsbankTransaktionRolle {
    Giver,
    Receiver
}

public record EhrenamtsbankTransaktionFilterInput(
    EhrenamtsbankTransaktionStatus? Status,
    [property: GraphQLDescription("Beschränkt auf Buchungen, in denen der Aufrufer diese Rolle hat.")]
    EhrenamtsbankTransaktionRolle? Role
);

[QueryType]
public class ZeitkontoQueries {
    public static readonly Expression<Func<EhrenamtsbankTransaktion, bool>> CountsTowardBalance =
        t => t.Status == EhrenamtsbankTransaktionStatus.Confirmed
             || t.Status == EhrenamtsbankTransaktionStatus.Adjusted;

    [Authorize]
    [GraphQLDescription("Zeitkonto des angemeldeten Bürgers.")]
    public async Task<EhrenamtsbankZeitkonto> GetMeinEhrenamtsbankZeitkonto(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        [Service] IOptions<EhrenamtsbankZeitkontoOptions> zeitkontoOptions,
        CancellationToken ct) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();
        return await ZeitkontoBalanceCalculator.GetZeitkontoAsync(
            db, buerger.Id, zeitkontoOptions.Value.StartCreditMinutes, ct);
    }

    [Authorize]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [GraphQLDescription("Eigene Buchungen des angemeldeten Bürgers, neueste zuerst.")]
    public async Task<IQueryable<EhrenamtsbankTransaktion>> GetMeineEhrenamtsbankTransaktionen(
        DomainContext db,
        CurrentUserAccessor currentUserAccessor,
        EhrenamtsbankTransaktionFilterInput? filter) {
        var buerger = await currentUserAccessor.EnsureRegisteredBuerger();

        var query = db.EhrenamtsbankTransaktionen
            .Where(t => t.GiverId == buerger.Id || t.ReceiverId == buerger.Id);

        if (filter?.Status is { } status) {
            query = query.Where(t => t.Status == status);
        }

        query = filter?.Role switch {
            EhrenamtsbankTransaktionRolle.Giver => query.Where(t => t.GiverId == buerger.Id),
            EhrenamtsbankTransaktionRolle.Receiver => query.Where(t => t.ReceiverId == buerger.Id),
            _ => query
        };

        return query.OrderByDescending(t => t.CreatedAt).ThenBy(t => t.Id);
    }

    [Authorize]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Error(typeof(NotAllowedException))]
    [GraphQLDescription(
        "Buchungen eines beliebigen Bürgers, neueste zuerst. "
        + "Nur mit globaler Funktionsberechtigung Ehrenamtsbank.")]
    public async Task<IQueryable<EhrenamtsbankTransaktion>> GetEhrenamtsbankTransaktionenNutzer(
        Guid userId,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Ehrenamtsbank).Fordern();

        return db.EhrenamtsbankTransaktionen
            .Where(t => t.GiverId == userId || t.ReceiverId == userId)
            .OrderByDescending(t => t.CreatedAt).ThenBy(t => t.Id);
    }
}
