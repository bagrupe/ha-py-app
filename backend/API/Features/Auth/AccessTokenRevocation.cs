using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth;

public static class AccessTokenRevocation {
    public const string SessionStampClaim = "session_stamp";

    public static async Task RejectRevokedAsync(TokenValidatedContext context) {
        if (!Guid.TryParse(context.Principal?.FindFirstValue(ClaimTypes.NameIdentifier), out var userId)) return;

        var ct = context.HttpContext.RequestAborted;
        int? currentStamp;
        try {
            var factory = context.HttpContext.RequestServices.GetRequiredService<IDbContextFactory<DomainContext>>();
            await using var db = await factory.CreateDbContextAsync(ct);
            currentStamp = await db.Buerger.Where(b => b.Id == userId)
                .Select(b => (int?)b.SessionStamp)
                .FirstOrDefaultAsync(ct);
        } catch (OperationCanceledException) when (ct.IsCancellationRequested) {
            context.Fail("Request aborted.");
            return;
        }
        if (currentStamp is null) return;

        var tokenStamp = int.TryParse(context.Principal!.FindFirstValue(SessionStampClaim), out var stamp) ? stamp : 0;
        if (tokenStamp != currentStamp) {
            context.Fail("Access token issued before the account logged out on all devices.");
        }
    }
}
