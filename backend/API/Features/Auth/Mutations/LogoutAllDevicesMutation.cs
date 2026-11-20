using System.Security.Cryptography;
using API.Features.Auth.KeyEscrow;
using API.Features.Auth.RefreshTokens;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Auth.Mutations;

[MutationType]
public class LogoutAllDevicesMutation {
    public enum LogoutAllDevicesResult {
        LoggedOut,
        DeviceLoginKept
    }

    [Authorize]
    public async Task<LogoutAllDevicesResult> LogoutAllDevices(
        DomainContext domainContext,
        [Service] RefreshTokenService refreshTokenService,
        [Service] KeyEscrowService keyEscrowService,
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] IPasswordHasher<User> passwordHasher,
        [Service] IClock clock,
        [Service] ILogger<LogoutAllDevicesMutation> logger,
        CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger) throw new InvalidOperationException();
        var now = clock.GetCurrentInstant();
        if (!await RefreshTokenService.IsSessionActiveAsync(
                domainContext, user.Id, currentUserAccessor.ClaimsPrincipal, now, ct)) {
            throw new NotAllowedException();
        }

        await using var transaction = await domainContext.Database.BeginTransactionAsync(ct);
        var buerger = await domainContext.Buerger.AsTracking().SingleAsync(b => b.Id == user.Id, ct);
        var revoked = await refreshTokenService.EndAllSessionsAsync(
            domainContext, buerger, RefreshTokenRevokedReason.LoggedOut, now, ct);
        // Ohne entschlüsselbare Hinterlegung hat nur das Erstgerät den privaten Schlüssel, eine Sperre wäre Datenverlust.
        var keepsDeviceLogin = !await keyEscrowService.ExistsAsync(user.Id, ct);
        if (!keepsDeviceLogin) {
            buerger.Password = passwordHasher.HashPassword(
                buerger, Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)));
        }

        await domainContext.SaveChangesAsync(ct);
        await transaction.CommitAsync(ct);

        logger.LogInformation(
            "Logged out buerger {BuergerId} on all devices: {Count} refresh tokens revoked, device login kept: {Kept}.",
            user.Id, revoked, keepsDeviceLogin);
        return keepsDeviceLogin ? LogoutAllDevicesResult.DeviceLoginKept : LogoutAllDevicesResult.LoggedOut;
    }
}
