using API.Features.Ehrenamtsbank.Queries;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank;

public static class ZeitkontoBalanceCalculator {
    public static async Task<EhrenamtsbankZeitkonto> GetZeitkontoAsync(
        DomainContext db,
        Guid buergerId,
        int startCreditMinutes,
        CancellationToken ct = default) {
        var counted = db.EhrenamtsbankTransaktionen.Where(ZeitkontoQueries.CountsTowardBalance);
        var creditMinutes = await counted.Where(t => t.GiverId == buergerId).SumAsync(t => t.Minutes, ct);
        var debitMinutes = await counted.Where(t => t.ReceiverId == buergerId).SumAsync(t => t.Minutes, ct);
        return new EhrenamtsbankZeitkonto(startCreditMinutes, creditMinutes, debitMinutes);
    }

    public static async Task<int> GetBalanceMinutesAsync(
        DomainContext db,
        Guid buergerId,
        int startCreditMinutes,
        CancellationToken ct = default) {
        var zeitkonto = await GetZeitkontoAsync(db, buergerId, startCreditMinutes, ct);
        return zeitkonto.BalanceMinutes;
    }
}
