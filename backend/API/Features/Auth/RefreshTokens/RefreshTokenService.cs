using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using API.Features.Auth.Mutations;
using API.Infrastructure;
using API.Options;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Auth.RefreshTokens;

public enum RefreshTokenResult {
    Success,
    InvalidOrExpired
}

public record RefreshTokenPayload(RefreshTokenResult Result, string? Token = null, string? RefreshToken = null);

public class RefreshTokenService(
    DomainContext domainContext,
    IClock clock,
    JWTOptions jwtOptions,
    AuthSessionOptions sessionOptions,
    RateLimit rateLimit,
    ILogger<RefreshTokenService> logger) {
    public const int MaxRawTokenLength = 64;
    private const int RefreshesPerAccount = 20;
    private static readonly TimeSpan RefreshRefillPeriod = TimeSpan.FromMinutes(3);
    private static readonly Duration RotationGracePeriod = Duration.FromMinutes(15);

    /// <summary>Speichert nicht, die Aufrufer speichern gemeinsam mit ihren eigenen Änderungen.</summary>
    public (string Token, string RefreshToken) Issue(
        DomainContext db, Buerger buerger, string provider, string? assuranceLevel, Instant now,
        Guid? refreshTokenId = null) {
        var (entity, rawRefreshToken) = RefreshToken.Create(
            buerger.Id, provider, assuranceLevel, now, sessionOptions.RefreshTokenLifetimeDays, refreshTokenId);
        db.RefreshTokens.Add(entity);

        var claims = new List<Claim> {
            new(StrongSessionClaims.AuthProvider, provider),
            new(StrongSessionClaims.Session, entity.Id.ToString())
        };
        if (provider == RefreshTokenProvider.BundId) {
            claims.Add(new Claim(StrongSessionClaims.AuthTime, now.ToUnixTimeSeconds().ToString()));
            if (assuranceLevel is not null) {
                claims.Add(new Claim(StrongSessionClaims.AssuranceLevel, assuranceLevel));
            }
        }

        var token = new JwtSecurityTokenHandler().WriteToken(buerger.GetToken(
            jwtOptions, claims, TimeSpan.FromMinutes(sessionOptions.StrongTokenLifetimeMinutes)));
        return (token, rawRefreshToken);
    }

    /// <summary>Zugangs-Tokens überleben Abmelden bis zu ihrem Ablauf, ihre Refresh-Kette nicht.</summary>
    public static async Task<bool> IsSessionActiveAsync(
        DomainContext db, Guid buergerId, ClaimsPrincipal principal, Instant now, CancellationToken ct) {
        if (!principal.IsStrongSession()
            || !Guid.TryParse(principal.FindFirstValue(StrongSessionClaims.Session), out var tokenId)) {
            return false;
        }

        return await db.Database.SqlQuery<bool>($"""
            WITH RECURSIVE chain AS (
                SELECT "Id", "ReplacedById", "RevokedAt", "ExpiresAt", "BuergerId" FROM "RefreshTokens"
                WHERE "Id" = {tokenId}
                UNION
                SELECT t."Id", t."ReplacedById", t."RevokedAt", t."ExpiresAt", t."BuergerId"
                FROM "RefreshTokens" t JOIN chain c ON t."Id" = c."ReplacedById"
            )
            SELECT EXISTS (
                SELECT 1 FROM chain WHERE "RevokedAt" IS NULL AND "ExpiresAt" > {now} AND "BuergerId" = {buergerId}
            ) AS "Value"
            """).SingleAsync(ct);
    }

    public async Task<RefreshTokenPayload> RefreshAsync(string rawRefreshToken, CancellationToken ct = default) {
        var now = clock.GetCurrentInstant();
        var stored = await FindAsync(rawRefreshToken, ct);
        if (stored is null || stored.ExpiresAt <= now) {
            logger.LogInformation("Refresh rejected: token {Reason}.", stored is null ? "unknown" : "expired");
            return new RefreshTokenPayload(RefreshTokenResult.InvalidOrExpired);
        }

        if (stored.RevokedAt is not null && stored.RevokedReason is not (RefreshTokenRevokedReason.Rotated
                or RefreshTokenRevokedReason.SupersededByRetry)) {
            logger.LogInformation("Refresh rejected: token already revoked ({Reason}).", stored.RevokedReason);
            return new RefreshTokenPayload(RefreshTokenResult.InvalidOrExpired);
        }

        await rateLimit.Limit(ct, new RateLimit.KeyLimit(
            "Refresh token", stored.BuergerId.ToString(), RefreshesPerAccount, RefreshRefillPeriod));

        await using var transaction = await domainContext.Database.BeginTransactionAsync(ct);
        await LockAccountAsync(domainContext, stored.BuergerId, ct);
        var buerger = await domainContext.Buerger.AsTracking().FirstOrDefaultAsync(b => b.Id == stored.BuergerId, ct);
        if (buerger is null || buerger.IsDeleted
            || (stored.Provider == RefreshTokenProvider.Sms
                && (!buerger.PhoneVerified || await domainContext.ExternalIdentities.AnyAsync(
                    e => e.BuergerId == buerger.Id && e.Provider == "bundid", ct)))) {
            // Auch ein schon rotiertes Token, sonst belastet es bei jedem Vorlegen das Kontingent des Kontos.
            await domainContext.RefreshTokens
                .Where(t => t.Id == stored.Id)
                .ExecuteUpdateAsync(s => s
                    .SetProperty(t => t.RevokedAt, t => t.RevokedAt ?? now)
                    .SetProperty(t => t.RevokedReason,
                        (RefreshTokenRevokedReason?)RefreshTokenRevokedReason.AccountInvalid), ct);
            await transaction.CommitAsync(ct);
            logger.LogWarning("Refresh rejected: buerger {BuergerId} is deleted, no longer verified or needs BundID.",
                stored.BuergerId);
            return new RefreshTokenPayload(RefreshTokenResult.InvalidOrExpired);
        }

        var successorId = Guid.NewGuid();
        var claimed = await domainContext.RefreshTokens
            .Where(t => t.Id == stored.Id && t.RevokedAt == null)
            .ExecuteUpdateAsync(s => s
                .SetProperty(t => t.RevokedAt, (Instant?)now)
                .SetProperty(t => t.RevokedReason, (RefreshTokenRevokedReason?)RefreshTokenRevokedReason.Rotated)
                .SetProperty(t => t.ReplacedById, (Guid?)successorId), ct);
        if (claimed == 0 && !await TryReplaceUnusedSuccessorAsync(buerger, stored.Id, successorId, now, ct)) {
            await domainContext.SaveChangesAsync(ct);
            await transaction.CommitAsync(ct);
            return new RefreshTokenPayload(RefreshTokenResult.InvalidOrExpired);
        }

        var (token, refreshToken) = Issue(
            domainContext, buerger, stored.Provider, stored.AssuranceLevel, now, successorId);
        await domainContext.SaveChangesAsync(ct);
        await transaction.CommitAsync(ct);

        logger.LogInformation("Session token refreshed for buerger {BuergerId} ({Provider}).", buerger.Id,
            stored.Provider);
        return new RefreshTokenPayload(RefreshTokenResult.Success, token, refreshToken);
    }

    /// <summary>Kulanz nach einer verlorenen Antwort, solange der Nachfolger unbenutzt ist.</summary>
    private async Task<bool> TryReplaceUnusedSuccessorAsync(
        Buerger buerger, Guid usedTokenId, Guid newSuccessorId, Instant now, CancellationToken ct) {
        var used = await domainContext.RefreshTokens.AsNoTracking().FirstOrDefaultAsync(t => t.Id == usedTokenId, ct);
        if (used?.ReplacedById is not { } successorId
            || used.RevokedReason is not (RefreshTokenRevokedReason.Rotated
                or RefreshTokenRevokedReason.SupersededByRetry)) {
            logger.LogWarning("Refresh rejected: token already revoked ({Reason}).", used?.RevokedReason);
            return false;
        }

        if (used.RevokedReason == RefreshTokenRevokedReason.Rotated
            && now - used.RevokedAt!.Value <= RotationGracePeriod
            && await domainContext.RefreshTokens
                .Where(t => t.Id == successorId && t.RevokedAt == null)
                .ExecuteUpdateAsync(s => s
                    .SetProperty(t => t.RevokedAt, (Instant?)now)
                    .SetProperty(t => t.RevokedReason,
                        (RefreshTokenRevokedReason?)RefreshTokenRevokedReason.SupersededByRetry)
                    .SetProperty(t => t.ReplacedById, (Guid?)newSuccessorId), ct) == 1) {
            await domainContext.RefreshTokens
                .Where(t => t.Id == usedTokenId)
                .ExecuteUpdateAsync(s => s.SetProperty(t => t.ReplacedById, (Guid?)newSuccessorId), ct);
            return true;
        }

        var theft = used.RevokedReason == RefreshTokenRevokedReason.SupersededByRetry
            || await domainContext.RefreshTokens.AnyAsync(
                t => t.Id == successorId && t.RevokedReason == RefreshTokenRevokedReason.Rotated, ct);
        if (theft) {
            await EndAllSessionsAsync(domainContext, buerger, RefreshTokenRevokedReason.ReuseDetected, now, ct);
            await domainContext.RefreshTokens
                .Where(t => t.BuergerId == used.BuergerId && (t.RevokedReason == RefreshTokenRevokedReason.Rotated
                    || t.RevokedReason == RefreshTokenRevokedReason.SupersededByRetry))
                .ExecuteUpdateAsync(s => s.SetProperty(t => t.RevokedReason,
                    (RefreshTokenRevokedReason?)RefreshTokenRevokedReason.ReuseDetected), ct);
            logger.LogWarning("Refresh token of buerger {BuergerId} was reused ({Reason}), all sessions are revoked.",
                used.BuergerId, used.RevokedReason);
        } else {
            await RevokeChainAsync(usedTokenId, RefreshTokenRevokedReason.ReuseDetected, now, ct);
            await domainContext.RefreshTokens
                .Where(t => t.Id == usedTokenId)
                .ExecuteUpdateAsync(s => s.SetProperty(t => t.RevokedReason,
                    (RefreshTokenRevokedReason?)RefreshTokenRevokedReason.ReuseDetected), ct);
            logger.LogWarning("Late retry of a rotated refresh token of buerger {BuergerId}, this session is revoked.",
                used.BuergerId);
        }

        return false;
    }

    /// <summary>Auch alle Nachfolger, damit keine verwaiste oder über das Kulanzfenster erschlichene Sitzung bleibt.</summary>
    public async Task RevokeAsync(string rawRefreshToken, CancellationToken ct = default) {
        var stored = await FindAsync(rawRefreshToken, ct);
        if (stored is null) return;

        await using var transaction = await domainContext.Database.BeginTransactionAsync(ct);
        await LockAccountAsync(domainContext, stored.BuergerId, ct);
        var revoked = await RevokeChainAsync(
            stored.Id, RefreshTokenRevokedReason.LoggedOut, clock.GetCurrentInstant(), ct);
        await transaction.CommitAsync(ct);

        if (revoked > 0) {
            logger.LogInformation("{Count} refresh tokens revoked for buerger {BuergerId}.", revoked, stored.BuergerId);
        }
    }

    public async Task<int> RevokeSessionsAsync(DomainContext db, Guid buergerId, string? provider,
        RefreshTokenRevokedReason reason, Instant now, CancellationToken ct) {
        await LockAccountAsync(db, buergerId, ct);
        return await db.RefreshTokens
            .Where(t => t.BuergerId == buergerId && t.RevokedAt == null && (provider == null || t.Provider == provider))
            .ExecuteUpdateAsync(s => s
                .SetProperty(t => t.RevokedAt, (Instant?)now)
                .SetProperty(t => t.RevokedReason, (RefreshTokenRevokedReason?)reason), ct);
    }

    /// <summary>Widerruft sofort, Zählerstand und Zeitpunkt am Konto speichert erst der Aufrufer.</summary>
    public async Task<int> EndAllSessionsAsync(
        DomainContext db, Buerger buerger, RefreshTokenRevokedReason reason, Instant now, CancellationToken ct) {
        var revoked = await RevokeSessionsAsync(db, buerger.Id, null, reason, now, ct);
        // Erst unter der Sperre gelesen, sonst geht ein gleichzeitiges Beenden verloren.
        buerger.SessionStamp = await db.Buerger.Where(b => b.Id == buerger.Id)
            .Select(b => b.SessionStamp).SingleAsync(ct) + 1;
        buerger.SessionsEndedAt = now;
        return revoked;
    }

    private async Task<int> RevokeChainAsync(
        Guid fromTokenId, RefreshTokenRevokedReason reason, Instant now, CancellationToken ct) {
        var reasonText = reason.ToString();
        return await domainContext.Database.ExecuteSqlInterpolatedAsync($"""
            WITH RECURSIVE chain AS (
                SELECT "Id", "ReplacedById" FROM "RefreshTokens" WHERE "Id" = {fromTokenId}
                UNION ALL
                SELECT t."Id", t."ReplacedById" FROM "RefreshTokens" t JOIN chain c ON t."Id" = c."ReplacedById"
            )
            UPDATE "RefreshTokens" SET "RevokedAt" = {now}, "RevokedReason" = {reasonText}
            WHERE "Id" IN (SELECT "Id" FROM chain) AND "RevokedAt" IS NULL
            """, ct);
    }

    private async Task<RefreshToken?> FindAsync(string rawRefreshToken, CancellationToken ct) {
        if (rawRefreshToken.Length > MaxRawTokenLength) return null;

        var tokenHash = RefreshToken.HashRawToken(rawRefreshToken);
        return await domainContext.RefreshTokens.AsNoTracking().FirstOrDefaultAsync(t => t.TokenHash == tokenHash, ct);
    }

    /// <summary>Serialisiert Erneuern und Widerrufen eines Kontos, damit eine Sperre keinen gleichzeitig angelegten Nachfolger übersieht.</summary>
    private static async Task LockAccountAsync(DomainContext db, Guid buergerId, CancellationToken ct) =>
        await db.Database.ExecuteSqlAsync(
            $"SELECT pg_advisory_xact_lock(hashtextextended({"refresh-token:" + buergerId}, 0))", ct);
}
