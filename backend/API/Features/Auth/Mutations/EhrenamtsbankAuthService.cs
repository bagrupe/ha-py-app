using System.Security.Claims;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using API.Features;
using API.Features.Auth.Mutations;
using API.Features.Auth.RefreshTokens;
using API.Infrastructure;
using API.Infrastructure.Exceptions;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using NodaTime;

namespace API.Features.Auth;

public enum ValidateCodeResult {
    Success,
    InvalidCode,
    CodeExpired,
    NoVerificationCodeRequested,
    ExistingAccountRequiresBundIdReverification,
    CodeLocked
}

public record ValidateSmsCodePayload(
    ValidateCodeResult Result,
    string? Token = null,
    bool IsNewRegistration = false,
    int? RemainingAttempts = null,
    int? RetryAfterSeconds = null,
    string? RefreshToken = null
);

public class EhrenamtsbankAuthService(
    ISmsService smsService,
    IClock clock,
    IOptions<EhrenamtsbankOptions> options,
    RateLimitOptions rateLimitOptions,
    BrevoOptions brevoOptions,
    RefreshTokenService refreshTokenService,
    ILogger<EhrenamtsbankAuthService> logger) {
    private int MaximumFailedAttempts => rateLimitOptions.SmsMaxFailedAttempts;
    private Duration ResendCooldown => Duration.FromSeconds(rateLimitOptions.SmsResendCooldownSeconds);
    private Duration VerificationLockDuration =>
        Duration.FromMinutes(rateLimitOptions.SmsVerificationLockMinutes);

    /// <summary>
    /// Moves the data from an existing User to a new one (upgrading an existing user (weak login) to
    /// an registered user)
    /// </summary>
    /// <param name="db"></param>
    /// <param name="sourceBuerger">The user with existing data</param>
    /// <param name="targetBuerger">The user which gets the data</param>
    /// <param name="ct"></param>
    /// <returns></returns>
    public async Task MoveDataToUser(
        DomainContext db,
        Buerger sourceBuerger,
        Buerger targetBuerger,
        CancellationToken ct = default) {
        await using var transaction = await db.Database.BeginTransactionAsync(ct);
        await MoveDataToUserWithinTransaction(db, sourceBuerger.Id, targetBuerger.Id, ct);
        await db.SaveChangesAsync(ct);
        await transaction.CommitAsync(ct);
    }

    private static async Task MoveDataToUserWithinTransaction(
        DomainContext db,
        Guid sourceId,
        Guid targetId,
        CancellationToken ct) {

        await db.Ausfuehrungen
            .Where(a => a.UserId == sourceId)
            .ExecuteUpdateAsync(s => s.SetProperty(a => a.UserId, targetId), ct);

        await db.Bearbeitungen
            .Where(b => b.UserId == sourceId)
            .ExecuteUpdateAsync(s => s.SetProperty(b => b.UserId, targetId), ct);

        await db.ExternalIdentities
            .Where(e => e.BuergerId == sourceId)
            .ExecuteUpdateAsync(s => s.SetProperty(e => e.BuergerId, targetId), ct);

        await db.BuergerKeyEscrows
            .Where(e => e.BuergerId == sourceId)
            .ExecuteDeleteAsync(ct);

        var trackedSource = await db.Buerger.AsTracking()
            .Include(b => b.GefolgteAusfuehrungen)
            .FirstAsync(b => b.Id == sourceId, ct);

        var trackedTarget = await db.Buerger.AsTracking()
            .Include(b => b.GefolgteAusfuehrungen)
            .FirstAsync(b => b.Id == targetId, ct);

        if (trackedSource.BundIdDatenSyncedAt is not null) {
            trackedTarget.Vorname = trackedSource.Vorname;
            trackedTarget.Nachname = trackedSource.Nachname;
            trackedTarget.EmailAddress = trackedSource.EmailAddress;
            trackedTarget.Street = trackedSource.Street;
            trackedTarget.PostalCode = trackedSource.PostalCode;
            trackedTarget.City = trackedSource.City;
            trackedTarget.Country = trackedSource.Country;
            trackedTarget.BundIdDatenSyncedAt = trackedSource.BundIdDatenSyncedAt;
        }

        var existingFollowIds = trackedTarget.GefolgteAusfuehrungen.Select(a => a.Id).ToHashSet();
        foreach (var ausfuehrung in trackedSource.GefolgteAusfuehrungen) {
            if (existingFollowIds.Add(ausfuehrung.Id)) {
                trackedTarget.GefolgteAusfuehrungen.Add(ausfuehrung);
            }
        }

        trackedSource.GefolgteAusfuehrungen.Clear();

        trackedTarget.PushNotificationTokens = trackedTarget.PushNotificationTokens
            .Union(trackedSource.PushNotificationTokens)
            .ToList();

        trackedTarget.OrganisationseinheitIdsForNewsNotifications = trackedTarget.OrganisationseinheitIdsForNewsNotifications
            .Union(trackedSource.OrganisationseinheitIdsForNewsNotifications)
            .ToList();

        trackedSource.IsDeleted = true;
        trackedSource.Phone = null;
        trackedSource.PhoneVerified = false;
    }

    /// <summary>
    /// Sends a verification SMS to the telephoneNumber and stores the code in the database
    /// </summary>
    /// <param name="domainContext"></param>
    /// <param name="userId"></param>
    /// <param name="telephoneNumber"></param>
    /// <returns></returns>
    /// <exception cref="InvalidOperationException"></exception>
    public async Task SendVerificationSms(DomainContext domainContext, Guid userId, string telephoneNumber) {
        var phoneHash = PhoneHashingService.ComputeHash(telephoneNumber)!;

        Buerger buerger;
        await using (var transaction = await domainContext.Database.BeginTransactionAsync()) {
            await domainContext.Database.ExecuteSqlAsync(
                $"SELECT pg_advisory_xact_lock(hashtextextended({phoneHash}, 0))");

            buerger = await domainContext.Users.AsTracking().FirstOrDefaultAsync(u => u.Id == userId) as Buerger
                ?? throw new InvalidOperationException();
            await domainContext.Entry(buerger).ReloadAsync();

            var now = clock.GetCurrentInstant();
            await EnsureCodeRequestAllowed(domainContext, buerger, phoneHash);

            var otherChallenges = await domainContext.Buerger.AsTracking()
                .Where(b => b.Id != buerger.Id && b.VerificationPhoneHash == phoneHash)
                .ToListAsync();
            foreach (var other in otherChallenges) {
                ClearVerificationChallenge(other);
            }

            // The candidate number is only tracked as a hash until the SMS code is validated.
            // Writing buerger.Phone here would publish an unverified number via the Ehrenamtsbank
            // owner projection; it is persisted in ValidateSmsCode once ownership is proven.
            buerger.VerificationCode = RandomNumberGenerator.GetInt32(100000, 1000000).ToString();
            buerger.VerificationCodeValidUntil = now.Plus(Duration.FromMinutes(10));
            buerger.VerificationPhoneHash = phoneHash;
            buerger.VerificationCodeRequestedAt = now;
            buerger.VerificationCodeFailedAttempts = 0;
            buerger.VerificationCodeLockedUntil = null;

            await domainContext.SaveChangesAsync();
            await transaction.CommitAsync();
        }

        var text = brevoOptions.MessageTemplate.Replace("{code}", buerger.VerificationCode);
        try {
            await smsService.SendSms(telephoneNumber, text);
        } catch {
            ClearVerificationChallenge(buerger);
            await domainContext.SaveChangesAsync();
            throw;
        }
    }

    public async Task EnsureCodeRequestAllowed(DomainContext domainContext, Buerger buerger, string phoneHash) {
        var now = clock.GetCurrentInstant();
        if (buerger.VerificationCodeLockedUntil is { } lockedUntil && now < lockedUntil) {
            throw new RateLimitException((lockedUntil - now).ToTimeSpan());
        }

        var cooldownStart = now.Minus(ResendCooldown);
        var latestRequest = buerger.VerificationCodeRequestedAt;
        var otherLatest = await domainContext.Buerger
            .Where(b => b.Id != buerger.Id
                        && b.VerificationPhoneHash == phoneHash
                        && b.VerificationCodeRequestedAt > cooldownStart)
            .MaxAsync(b => b.VerificationCodeRequestedAt);
        if (otherLatest is { } other && (latestRequest is null || other > latestRequest)) {
            latestRequest = other;
        }

        if (latestRequest is { } requestedAt && now < requestedAt.Plus(ResendCooldown)) {
            throw new RateLimitException((requestedAt.Plus(ResendCooldown) - now).ToTimeSpan());
        }
    }

    public async Task EnsureStrongSessionForPhoneChange(
        DomainContext domainContext, Buerger buerger, string telephoneNumber, ClaimsPrincipal principal,
        CancellationToken ct) {
        var isActiveSession = await RefreshTokenService.IsSessionActiveAsync(
            domainContext, buerger.Id, principal, clock.GetCurrentInstant(), ct);
        var hasBundId = await domainContext.ExternalIdentities
            .AnyAsync(e => e.BuergerId == buerger.Id && e.Provider == "bundid", ct);
        if (hasBundId) {
            if (!principal.IsBundIdSession() || !isActiveSession) throw new NotAllowedException();
            return;
        }

        if (isActiveSession) return;

        var changesVerifiedPhone = buerger.PhoneVerified
            && buerger.PhoneHash != PhoneHashingService.ComputeHash(telephoneNumber);
        if (changesVerifiedPhone) throw new NotAllowedException();
    }

    public ValidateSmsCodePayload? GetLockedPayload(Buerger buerger) {
        var now = clock.GetCurrentInstant();
        return buerger.VerificationCodeLockedUntil is { } lockedUntil && now < lockedUntil
            ? new ValidateSmsCodePayload(
                ValidateCodeResult.CodeLocked, RetryAfterSeconds: CeilSeconds(lockedUntil - now))
            : null;
    }

    public async Task<ValidateSmsCodePayload> ValidateSmsCode(
        DomainContext domainContext,
        Buerger buerger,
        string telephoneNumber,
        string validationCode,
        ClaimsPrincipal? session = null,
        CancellationToken ct = default) {
        var (provider, assuranceLevel) = session.IsBundIdSession()
            ? (RefreshTokenProvider.BundId, session!.FindFirstValue(StrongSessionClaims.AssuranceLevel))
            : (RefreshTokenProvider.Sms, null);

        if (GetLockedPayload(buerger) is { } locked) {
            return locked;
        }

        var now = clock.GetCurrentInstant();

        if (buerger.VerificationCode is null
            || buerger.VerificationCodeValidUntil is null
            || buerger.VerificationPhoneHash is null) {
            return new ValidateSmsCodePayload(ValidateCodeResult.NoVerificationCodeRequested);
        }

        if (now > buerger.VerificationCodeValidUntil) {
            ClearVerificationChallenge(buerger);
            await domainContext.SaveChangesAsync(ct);
            return new ValidateSmsCodePayload(ValidateCodeResult.CodeExpired);
        }

        if (await ReserveAttempt(domainContext, buerger, ct) is not { } attemptNumber) {
            await EnsureLocked(domainContext, buerger.Id, now, ct);
            return new ValidateSmsCodePayload(
                ValidateCodeResult.CodeLocked, RetryAfterSeconds: CeilSeconds(VerificationLockDuration));
        }

        var submittedPhoneHash = PhoneHashingService.ComputeHash(telephoneNumber);
        if (submittedPhoneHash != buerger.VerificationPhoneHash
            || !IsVerificationCodeValid(buerger.VerificationCode, validationCode, options.Value.ACCEPT_MASTER_CODE)) {
            return await RegisterFailedAttempt(domainContext, buerger, attemptNumber, now, ct);
        }

        await using var transaction = await domainContext.Database.BeginTransactionAsync(ct);
        var existingBuergerWithPhone = await domainContext.Buerger.AsTracking()
            .FirstOrDefaultAsync(b => b.PhoneHash == submittedPhoneHash && b.Id != buerger.Id && !b.IsDeleted, ct);

        if (existingBuergerWithPhone is not null) {
            var existingHasBundId = await domainContext.ExternalIdentities
                .AnyAsync(e => e.BuergerId == existingBuergerWithPhone.Id && e.Provider == "bundid", ct);
            if (existingHasBundId) {
                logger.LogWarning(
                    "SMS verification for buerger {BuergerId} matched a phone number already owned by " +
                    "BundID-linked buerger {ExistingBuergerId}; blocked, BundID reverification required.",
                    buerger.Id, existingBuergerWithPhone.Id);
                ClearVerificationChallenge(buerger);
                await domainContext.SaveChangesAsync(ct);
                await transaction.CommitAsync(ct);
                return new ValidateSmsCodePayload(ValidateCodeResult.ExistingAccountRequiresBundIdReverification);
            }

            ClearVerificationChallenge(buerger);
            existingBuergerWithPhone.PhoneVerified = true;
            if (existingBuergerWithPhone.RegisteredAt is null) {
                existingBuergerWithPhone.RegisteredAt = now;
            }
            existingBuergerWithPhone.IsRegistered = true;

            await MoveDataToUserWithinTransaction(
                domainContext, buerger.Id, existingBuergerWithPhone.Id, ct);
            await EndSmsSessionsOfBundIdAccountAsync(domainContext, existingBuergerWithPhone.Id, now, ct);
            var (token, refreshToken) = refreshTokenService.Issue(
                domainContext, existingBuergerWithPhone, provider, assuranceLevel, now);
            await domainContext.SaveChangesAsync(ct);
            await transaction.CommitAsync(ct);

            return new ValidateSmsCodePayload(
                ValidateCodeResult.Success,
                token,
                IsNewRegistration: false,
                RefreshToken: refreshToken);
        }

        var wasAlreadyRegistered = buerger.IsRegistered;
        if (buerger.PhoneVerified && buerger.PhoneHash != submittedPhoneHash) {
            await refreshTokenService.EndAllSessionsAsync(
                domainContext, buerger, RefreshTokenRevokedReason.LoggedOut, now, ct);
        } else {
            await EndSmsSessionsOfBundIdAccountAsync(domainContext, buerger.Id, now, ct);
        }

        ClearVerificationChallenge(buerger);
        buerger.Phone = telephoneNumber;
        buerger.IsRegistered = true;
        buerger.RegisteredAt ??= now;
        buerger.PhoneVerified = true;
        var (newUserToken, newUserRefreshToken) = refreshTokenService.Issue(
            domainContext, buerger, provider, assuranceLevel, now);
        await domainContext.SaveChangesAsync(ct);
        await transaction.CommitAsync(ct);

        return new ValidateSmsCodePayload(
            ValidateCodeResult.Success,
            newUserToken,
            IsNewRegistration: !wasAlreadyRegistered,
            RefreshToken: newUserRefreshToken);
    }

    private async Task EndSmsSessionsOfBundIdAccountAsync(
        DomainContext domainContext, Guid buergerId, Instant now, CancellationToken ct) {
        if (await domainContext.ExternalIdentities.AnyAsync(e => e.BuergerId == buergerId && e.Provider == "bundid", ct)) {
            await refreshTokenService.RevokeSessionsAsync(
                domainContext, buergerId, RefreshTokenProvider.Sms, RefreshTokenRevokedReason.AccountInvalid, now, ct);
        }
    }

    public static bool ValidatePhoneNumber(string rawPhoneNumber) {
        if (string.IsNullOrWhiteSpace(rawPhoneNumber)) {
            return false;
        }

        string sanitizedNumber = rawPhoneNumber
            .Replace(" ", "")
            .Replace("-", "")
            .Replace("/", "")
            .Replace("(", "")
            .Replace(")", "");


        var germanMobileFormatRegex = new Regex(@"^\+49\d{9,11}$", RegexOptions.Compiled);

        return germanMobileFormatRegex.IsMatch(sanitizedNumber);
    }

    private static bool IsVerificationCodeValid(
        string storedCode,
        string validationCode,
        bool acceptMasterCode) =>
        storedCode == validationCode
        || (acceptMasterCode && validationCode == "123456");

    private async Task<int?> ReserveAttempt(
        DomainContext domainContext, Buerger buerger, CancellationToken ct) {
        var reserved = await domainContext.Buerger
            .Where(b => b.Id == buerger.Id && b.VerificationCodeFailedAttempts < MaximumFailedAttempts)
            .ExecuteUpdateAsync(
                s => s.SetProperty(
                    b => b.VerificationCodeFailedAttempts,
                    b => b.VerificationCodeFailedAttempts + 1),
                ct);
        if (reserved == 0) {
            return null;
        }

        var attempts = await domainContext.Buerger
            .Where(b => b.Id == buerger.Id)
            .Select(b => b.VerificationCodeFailedAttempts)
            .SingleAsync(ct);
        var counter = domainContext.Entry(buerger).Property(b => b.VerificationCodeFailedAttempts);
        counter.OriginalValue = attempts;
        counter.CurrentValue = attempts;
        counter.IsModified = false;
        return attempts;
    }

    private async Task<ValidateSmsCodePayload> RegisterFailedAttempt(
        DomainContext domainContext,
        Buerger buerger,
        int attemptNumber,
        Instant now,
        CancellationToken ct) {
        ValidateSmsCodePayload payload;
        if (attemptNumber >= MaximumFailedAttempts) {
            buerger.VerificationCode = null;
            buerger.VerificationCodeValidUntil = null;
            buerger.VerificationPhoneHash = null;
            buerger.VerificationCodeRequestedAt = null;
            buerger.VerificationCodeLockedUntil = now.Plus(VerificationLockDuration);
            payload = new ValidateSmsCodePayload(
                ValidateCodeResult.CodeLocked, RetryAfterSeconds: CeilSeconds(VerificationLockDuration));
        } else {
            payload = new ValidateSmsCodePayload(
                ValidateCodeResult.InvalidCode, RemainingAttempts: MaximumFailedAttempts - attemptNumber);
        }

        await domainContext.SaveChangesAsync(ct);
        return payload;
    }

    private async Task EnsureLocked(DomainContext domainContext, Guid buergerId, Instant now, CancellationToken ct) {
        await domainContext.Buerger
            .Where(b => b.Id == buergerId && b.VerificationCodeLockedUntil == null)
            .ExecuteUpdateAsync(s => s
                .SetProperty(b => b.VerificationCode, (string?)null)
                .SetProperty(b => b.VerificationCodeValidUntil, (Instant?)null)
                .SetProperty(b => b.VerificationPhoneHash, (string?)null)
                .SetProperty(b => b.VerificationCodeRequestedAt, (Instant?)null)
                .SetProperty(b => b.VerificationCodeLockedUntil, (Instant?)now.Plus(VerificationLockDuration)), ct);
    }

    private static int CeilSeconds(Duration duration) => (int)Math.Ceiling(duration.TotalSeconds);

    private static void ClearVerificationChallenge(Buerger buerger) {
        buerger.VerificationCode = null;
        buerger.VerificationCodeValidUntil = null;
        buerger.VerificationPhoneHash = null;
        buerger.VerificationCodeRequestedAt = null;
        buerger.VerificationCodeFailedAttempts = 0;
        buerger.VerificationCodeLockedUntil = null;
    }

}
