using System.Security.Claims;
using API.Features.Auth.RefreshTokens;
using API.Options;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Auth.BundId;

public enum BundIdLoginResult {
    Success,
    RegistrationRequired,
    AccountUnavailable,
    AuthenticationOutdated
}

public record BundIdLoginPayload(BundIdLoginResult Result, string? Token = null, string? RefreshToken = null);

public enum BundIdExchangeResult {
    Success,
    AlreadyLinkedToAnotherAccount,
    AccountAlreadyHasDifferentBundId,
    AccountAlreadyVerified,
    AccountUnavailable,
    AuthenticationOutdated
}

public record BundIdExchangePayload(
    BundIdExchangeResult Result,
    string? Token = null,
    string? RefreshToken = null,
    bool IsNewRegistration = false,
    BundIdProfileSuggestion? ProfileSuggestion = null,
    bool PhoneNumberCollision = false);

/// <summary>
/// <see cref="TelephoneNumber"/> ist unbestätigt und darf erst nach SMS-Bestätigung zum Abgleich von
/// Konten dienen.
/// </summary>
public record BundIdProfileSuggestion(
    string? Vorname,
    string? Nachname,
    string? Email,
    string? Street,
    string? PostalCode,
    string? City,
    string? Country,
    string? TelephoneNumber);

public class BundIdAuthService(
    DomainContext domainContext,
    IKeycloakTokenValidator tokenValidator,
    IBundIdSubjectHasher subjectHasher,
    IClock clock,
    BundIdOptions bundIdOptions,
    RefreshTokenService refreshTokenService,
    ILogger<BundIdAuthService> logger) {
    private const string Provider = "bundid";

    public async Task<BundIdLoginPayload> LoginAsync(string keycloakAccessToken, CancellationToken ct = default) {
        var (issuer, subjectHash, acr, principal) = await ValidateAndHash(keycloakAccessToken, ct);

        var externalIdentity = await domainContext.ExternalIdentities.AsTracking()
            .FirstOrDefaultAsync(e => e.Provider == Provider && e.Issuer == issuer && e.SubjectHash == subjectHash, ct);

        if (externalIdentity is null) {
            logger.LogInformation("BundID direct login: subject not linked to any account, registration required.");
            return new BundIdLoginPayload(BundIdLoginResult.RegistrationRequired);
        }

        var buerger = await domainContext.Buerger.AsTracking()
            .FirstOrDefaultAsync(b => b.Id == externalIdentity.BuergerId, ct);
        if (buerger is null || buerger.IsDeleted) {
            logger.LogWarning("BundID direct login rejected: buerger {BuergerId} is deleted.", externalIdentity.BuergerId);
            return new BundIdLoginPayload(BundIdLoginResult.AccountUnavailable);
        }

        if (AuthenticatedBefore(principal, buerger.SessionsEndedAt)) {
            logger.LogWarning("BundID direct login rejected: authentication of buerger {BuergerId} predates the end " +
                "of all sessions.", buerger.Id);
            return new BundIdLoginPayload(BundIdLoginResult.AuthenticationOutdated);
        }

        var now = clock.GetCurrentInstant();
        externalIdentity.AssuranceLevel = acr;
        externalIdentity.LastAuthenticatedAt = now;

        await SyncProfileFromBundId(buerger, ExtractProfileSuggestion(principal), now, ct);
        var (token, refreshToken) = refreshTokenService.Issue(
            domainContext, buerger, RefreshTokenProvider.BundId, acr, now);
        await domainContext.SaveChangesAsync(ct);

        logger.LogInformation(
            "BundID direct login succeeded for buerger {BuergerId}.", buerger.Id);
        return new BundIdLoginPayload(BundIdLoginResult.Success, token, refreshToken);
    }

    public async Task<BundIdExchangePayload> ExchangeAsync(Guid currentBuergerId, string keycloakAccessToken,
        CancellationToken ct = default) {
        var (issuer, subjectHash, acr, principal) = await ValidateAndHash(keycloakAccessToken, ct);

        await using var transaction = await domainContext.Database.BeginTransactionAsync(ct);
        var buerger = await domainContext.Buerger.AsTracking().FirstOrDefaultAsync(b => b.Id == currentBuergerId, ct);
        if (buerger is null || buerger.IsDeleted) {
            logger.LogWarning("BundID exchange rejected: buerger {BuergerId} is deleted.", currentBuergerId);
            return new BundIdExchangePayload(BundIdExchangeResult.AccountUnavailable);
        }

        if (AuthenticatedBefore(principal, buerger.SessionsEndedAt)) {
            logger.LogWarning("BundID exchange rejected: authentication of buerger {BuergerId} predates the end of " +
                "all sessions.", currentBuergerId);
            return new BundIdExchangePayload(BundIdExchangeResult.AuthenticationOutdated);
        }

        var existingForSubject = await domainContext.ExternalIdentities.AsNoTracking()
            .FirstOrDefaultAsync(e => e.Provider == Provider && e.Issuer == issuer && e.SubjectHash == subjectHash, ct);
        if (existingForSubject is not null && existingForSubject.BuergerId != currentBuergerId) {
            logger.LogWarning(
                "BundID exchange rejected: subject already linked to a different buerger than the current session.");
            return new BundIdExchangePayload(BundIdExchangeResult.AlreadyLinkedToAnotherAccount);
        }

        var existingForBuerger = await domainContext.ExternalIdentities.AsTracking()
            .FirstOrDefaultAsync(e => e.Provider == Provider && e.BuergerId == currentBuergerId, ct);
        if (existingForBuerger is not null && existingForBuerger.SubjectHash != subjectHash) {
            logger.LogWarning(
                "BundID exchange rejected: buerger {BuergerId} already linked to a different BundID subject.",
                currentBuergerId);
            return new BundIdExchangePayload(BundIdExchangeResult.AccountAlreadyHasDifferentBundId);
        }

        // Sonst könnte jeder mit dem Gerätelogin eines bestätigten Kontos seine eigene BundID daran hängen.
        if (existingForBuerger is null && (buerger.PhoneVerified || buerger.IsRegistered)) {
            logger.LogWarning("BundID exchange rejected: buerger {BuergerId} is already verified.", currentBuergerId);
            return new BundIdExchangePayload(BundIdExchangeResult.AccountAlreadyVerified);
        }

        var isNewRegistration = existingForBuerger is null;
        var now = clock.GetCurrentInstant();

        if (existingForBuerger is null) {
            domainContext.ExternalIdentities.Add(new ExternalIdentity {
                Id = Guid.NewGuid(),
                BuergerId = currentBuergerId,
                Provider = Provider,
                Issuer = issuer,
                SubjectHash = subjectHash,
                AssuranceLevel = acr,
                LinkedAt = now,
                LastAuthenticatedAt = now
            });
            await refreshTokenService.RevokeSessionsAsync(domainContext, currentBuergerId, RefreshTokenProvider.Sms,
                RefreshTokenRevokedReason.AccountInvalid, now, ct);
        } else {
            existingForBuerger.AssuranceLevel = acr;
            existingForBuerger.LastAuthenticatedAt = now;
        }

        var profileSuggestion = ExtractProfileSuggestion(principal);
        var phoneNumberCollision = await SyncProfileFromBundId(buerger, profileSuggestion, now, ct);
        if (phoneNumberCollision) {
            logger.LogWarning(
                "BundID exchange: suggested phone number for buerger {BuergerId} already belongs to a different " +
                "account, not taken over.", buerger.Id);
        }

        if (isNewRegistration) {
            buerger.IsRegistered = true;
            buerger.RegisteredAt ??= now;
        }

        var (token, refreshToken) = refreshTokenService.Issue(
            domainContext, buerger, RefreshTokenProvider.BundId, acr, now);
        await domainContext.SaveChangesAsync(ct);
        await transaction.CommitAsync(ct);

        logger.LogInformation(
            "BundID exchange succeeded for buerger {BuergerId} (newRegistration={IsNewRegistration}).",
            buerger.Id, isNewRegistration);
        return new BundIdExchangePayload(BundIdExchangeResult.Success, token, refreshToken,
            isNewRegistration, profileSuggestion, phoneNumberCollision);
    }

    /// <summary>Gibt zurück, ob die vorgeschlagene Nummer schon einem anderen Konto gehört.</summary>
    private async Task<bool> SyncProfileFromBundId(
        Buerger buerger, BundIdProfileSuggestion suggestion, Instant now, CancellationToken ct) {
        if (suggestion.Vorname is not null) buerger.Vorname = suggestion.Vorname;
        if (suggestion.Nachname is not null) buerger.Nachname = suggestion.Nachname;
        if (suggestion.Email is not null) buerger.EmailAddress = suggestion.Email;
        if (suggestion.Street is not null) buerger.Street = suggestion.Street;
        if (suggestion.PostalCode is not null) buerger.PostalCode = suggestion.PostalCode;
        if (suggestion.City is not null) buerger.City = suggestion.City;
        if (suggestion.Country is not null) buerger.Country = suggestion.Country;

        var phoneNumberCollision = false;
        if (suggestion.TelephoneNumber is { } telephoneNumber && !buerger.PhoneVerified) {
            var phoneHash = PhoneHashingService.ComputeHash(telephoneNumber);
            phoneNumberCollision = await domainContext.Buerger.AnyAsync(
                b => b.PhoneHash == phoneHash && b.Id != buerger.Id, ct);
            if (!phoneNumberCollision) {
                buerger.Phone = telephoneNumber;
            }
        }

        buerger.BundIdDatenSyncedAt = now;
        return phoneNumberCollision;
    }

    /// <summary>auth_time vor iat, damit auch eine ältere Keycloak-Sitzung mit frischem Token nicht reicht.</summary>
    private static bool AuthenticatedBefore(ClaimsPrincipal principal, Instant? sessionsEndedAt) {
        if (sessionsEndedAt is not { } endedAt) return false;

        var authenticatedAt = UnixSeconds(principal, "auth_time") ?? UnixSeconds(principal, "iat");
        return authenticatedAt is not { } seconds || seconds <= endedAt.ToUnixTimeSeconds();
    }

    private static long? UnixSeconds(ClaimsPrincipal principal, string claimType) =>
        long.TryParse(principal.FindFirstValue(claimType), out var seconds) && seconds > 0 ? seconds : null;

    private async Task<(string Issuer, string SubjectHash, string? Acr, ClaimsPrincipal Principal)> ValidateAndHash(
        string keycloakAccessToken, CancellationToken ct) {
        ClaimsPrincipal principal;
        try {
            principal = await tokenValidator.ValidateAsync(keycloakAccessToken, ct);
        } catch (InvalidBundIdTokenException) {
            logger.LogWarning("BundID login rejected: invalid or expired Keycloak token.");
            throw;
        }
        // BundID-Broker-Logins liefern kein "sub", preferred_username ist das stabile Pseudonym aus bpk2.
        var subject = principal.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? principal.FindFirstValue("sub")
            ?? principal.FindFirstValue("preferred_username")
            ?? throw new InvalidBundIdTokenException("Token enthält kein Subject.");
        var acr = BundIdAssuranceLevel.Extract(principal);

        // Konfigurierte Authority statt Issuer-Claim, weil dieser lokal abweichen kann.
        var issuer = bundIdOptions.KeycloakAuthority;
        var subjectHash = subjectHasher.ComputeHash(issuer, subject);

        return (issuer, subjectHash, acr, principal);
    }

    private static BundIdProfileSuggestion ExtractProfileSuggestion(ClaimsPrincipal principal) =>
        new(
            // given_name/family_name/email werden beim Validieren auf die langen ClaimTypes abgebildet.
            Vorname: principal.FindFirstValue(ClaimTypes.GivenName) ?? principal.FindFirstValue("vorname"),
            Nachname: principal.FindFirstValue(ClaimTypes.Surname) ?? principal.FindFirstValue("nachname"),
            Email: principal.FindFirstValue(ClaimTypes.Email) ?? principal.FindFirstValue("email"),
            Street: principal.FindFirstValue("street"),
            PostalCode: principal.FindFirstValue("postalCode"),
            City: principal.FindFirstValue("city"),
            Country: principal.FindFirstValue("country"),
            TelephoneNumber: principal.FindFirstValue("telephoneNumber"));
}
