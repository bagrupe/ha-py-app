using API.Features;
using API.Features.Auth;
using API.Features.Auth.RefreshTokens;
using API.Infrastructure;
using API.Infrastructure.Exceptions;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

[MutationType]
public class EhrenamtsbankAuthMutation {
    public enum RequestSmsResult {
        Success,
        InvalidFormat,
        SameAsCurrentPhoneNumber,
        SmsDeliveryFailed,
        InvalidPhone,
        BundIdLoginRequired
    }

    [Authorize]
    public async Task<RequestSmsResult> RequestSmsCode(
        string telephoneNumber,
        DomainContext domainContext,
        [Service] EhrenamtsbankAuthService ehrenamtsbankAuthService,
        [Service] RateLimit rateLimit,
        [Service] RateLimitOptions rateLimitOptions,
        [Service] ICurrentUserAccessor currentUserAccessor,
        [Service] IClock clock,
        CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger buerger) throw new InvalidOperationException();

        if (!EhrenamtsbankAuthService.ValidatePhoneNumber(telephoneNumber)) {
            return RequestSmsResult.InvalidFormat;
        }

        var phoneHash = PhoneHashingService.ComputeHash(telephoneNumber)!;

        var principal = currentUserAccessor.ClaimsPrincipal;
        var isStrongSession = principal.IsStrongSession();
        if (await domainContext.ExternalIdentities.AnyAsync(e => e.BuergerId == buerger.Id && e.Provider == "bundid", ct)
            && !(principal.IsBundIdSession() && await RefreshTokenService.IsSessionActiveAsync(
                domainContext, buerger.Id, principal, clock.GetCurrentInstant(), ct))) {
            return RequestSmsResult.BundIdLoginRequired;
        }

        if (isStrongSession && buerger.PhoneVerified && buerger.PhoneHash == phoneHash) {
            return RequestSmsResult.SameAsCurrentPhoneNumber;
        }

        await ehrenamtsbankAuthService.EnsureCodeRequestAllowed(domainContext, buerger, phoneHash);

        var maxRequests = rateLimitOptions.SmsMaxRequestsPerWindow;
        var tokenRefill = rateLimitOptions.SmsRequestTokenRefill;
        await rateLimit.Limit(ct,
            new RateLimit.UserLimit("SMS Verification Request", maxRequests, tokenRefill),
            new RateLimit.KeyLimit("SMS Verification Request", phoneHash, maxRequests, tokenRefill));

        try {
            await ehrenamtsbankAuthService.SendVerificationSms(domainContext, user.Id, telephoneNumber);
        } catch (SmsInvalidPhoneNumberException) {
            return RequestSmsResult.InvalidPhone;
        } catch (SmsDeliveryFailedException) {
            return RequestSmsResult.SmsDeliveryFailed;
        }
        return RequestSmsResult.Success;
    }

    [Authorize]
    public async Task<ValidateSmsCodePayload> ValidateSmsCode(
        string telephoneNumber,
        string validationCode,
        DomainContext domainContext,
        [Service] EhrenamtsbankAuthService ehrenamtsbankAuthService,
        [Service] RateLimit rateLimit,
        [Service] RateLimitOptions rateLimitOptions,
        [Service] ICurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {

        var user = await currentUserAccessor.User();
        if (user is null || user is not Buerger) throw new InvalidOperationException();

        var buerger = await domainContext.Users.AsTracking()
            .FirstOrDefaultAsync(u => u.Id == user.Id) as Buerger ?? throw new InvalidOperationException();

        if (ehrenamtsbankAuthService.GetLockedPayload(buerger) is { } locked) {
            return locked;
        }

        await ehrenamtsbankAuthService.EnsureStrongSessionForPhoneChange(
            domainContext, buerger, telephoneNumber, currentUserAccessor.ClaimsPrincipal, ct);

        await rateLimit.Limit(ct,
            new RateLimit.UserLimit(
                "SMS Verification Validate",
                rateLimitOptions.SmsValidationMaxCalls,
                rateLimitOptions.SmsValidationTokenRefill));

        return await ehrenamtsbankAuthService.ValidateSmsCode(
            domainContext, buerger, telephoneNumber, validationCode, currentUserAccessor.ClaimsPrincipal, ct);
    }

}
