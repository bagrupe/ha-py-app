using System.Security.Claims;
using System.Security.Cryptography;
using API.Features.Auth.RefreshTokens;
using API.Infrastructure.Exceptions;
using API.Options;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Auth.KeyEscrow;

public class KeyEscrowService(
    DomainContext db,
    KeyEscrowOptions options,
    IClock clock,
    ILogger<KeyEscrowService> logger) {
    private const int NonceLength = 12;
    private const int TagLength = 16;
    private const int MaxPrivateKeyBase64Length = 16 * 1024;
    private static readonly Duration RetrievalWindow = Duration.FromHours(1);
    private static readonly Duration MinStoreInterval = Duration.FromMinutes(1);


    public async Task StoreAsync(Guid buergerId, string privateKeyBase64, CancellationToken ct) {
        var buerger = await db.Buerger.AsTracking().FirstOrDefaultAsync(b => b.Id == buergerId, ct)
            ?? throw new InvalidOperationException();

        if (!await IsVerifiedAsync(buerger, ct)) throw new KeyEscrowAccountNotVerifiedException();

        var privateKeyBytes = DecodePrivateKey(privateKeyBase64);
        if (buerger.PublicKey is null || !KeyMatches(privateKeyBytes, buerger.PublicKey)) {
            throw new KeyEscrowKeyMismatchException();
        }

        var now = clock.GetCurrentInstant();
        var existing = await db.BuergerKeyEscrows.AsTracking().FirstOrDefaultAsync(e => e.BuergerId == buergerId, ct);

        if (existing is not null
            && options.Keys.ContainsKey(existing.KeyVersion)
            && now - existing.UpdatedAt < MinStoreInterval) {
            throw new RateLimitException((existing.UpdatedAt + MinStoreInterval - now).ToTimeSpan());
        }

        var encrypted = Encrypt(privateKeyBytes, buergerId);
        if (existing is null) {
            db.BuergerKeyEscrows.Add(new BuergerKeyEscrow {
                BuergerId = buergerId,
                EncryptedPrivateKey = encrypted,
                KeyVersion = options.CurrentVersion,
                CreatedAt = now,
                UpdatedAt = now
            });
        } else {
            existing.EncryptedPrivateKey = encrypted;
            existing.KeyVersion = options.CurrentVersion;
            existing.UpdatedAt = now;
        }

        try {
            await db.SaveChangesAsync(ct);
        } catch (DbUpdateException) when (existing is null) {
            // Eine parallele Anfrage war schneller. Ihr Schlüssel passt ebenfalls zum Konto, ist also gleichwertig.
            db.ChangeTracker.Clear();
            if (!await db.BuergerKeyEscrows.AnyAsync(e => e.BuergerId == buergerId, ct)) throw;
        }

        logger.LogInformation("Key escrow stored for buerger {BuergerId}", buergerId);
    }

    private static byte[] DecodePrivateKey(string privateKeyBase64) {
        if (privateKeyBase64.Length > MaxPrivateKeyBase64Length) throw new KeyEscrowKeyMismatchException();

        try {
            return Convert.FromBase64String(privateKeyBase64);
        } catch (FormatException) {
            throw new KeyEscrowKeyMismatchException();
        }
    }

    public async Task<string?> RetrieveAsync(Guid buergerId, ClaimsPrincipal principal, CancellationToken ct) {
        var now = clock.GetCurrentInstant();
        if (!await RefreshTokenService.IsSessionActiveAsync(db, buergerId, principal, now, ct)) {
            throw new KeyEscrowRequiresStrongSessionException();
        }
        if (!principal.IsBundIdSession()
            && await db.ExternalIdentities.AnyAsync(e => e.BuergerId == buergerId && e.Provider == "bundid", ct)) {
            throw new KeyEscrowRequiresStrongSessionException();
        }

        var escrow = await db.BuergerKeyEscrows.AsTracking().FirstOrDefaultAsync(e => e.BuergerId == buergerId, ct);
        if (escrow is null) return null;

        if (escrow.RetrievalWindowStart is null || now - escrow.RetrievalWindowStart.Value >= RetrievalWindow) {
            escrow.RetrievalWindowStart = now;
            escrow.RetrievalCount = 0;
        }

        if (escrow.RetrievalCount >= options.MaxRetrievalsPerHour) {
            var retryAfter = (escrow.RetrievalWindowStart.Value + RetrievalWindow - now).ToTimeSpan();
            throw new RateLimitException(retryAfter);
        }

        escrow.RetrievalCount++;
        await db.SaveChangesAsync(ct);

        logger.LogInformation("Key escrow retrieved for buerger {BuergerId}", buergerId);
        return Convert.ToBase64String(Decrypt(escrow.EncryptedPrivateKey, escrow.KeyVersion, buergerId));
    }

    public async Task<bool> ExistsAsync(Guid buergerId, CancellationToken ct) {
        var keyVersion = await db.BuergerKeyEscrows
            .Where(e => e.BuergerId == buergerId)
            .Select(e => (int?)e.KeyVersion)
            .FirstOrDefaultAsync(ct);

        return keyVersion is not null && options.Keys.ContainsKey(keyVersion.Value);
    }

    public async Task<IReadOnlyList<int>> GetMissingKeyVersionsAsync(CancellationToken ct) {
        var versionsInUse = await db.BuergerKeyEscrows.Select(e => e.KeyVersion).Distinct().ToListAsync(ct);
        return versionsInUse.Where(v => !options.Keys.ContainsKey(v)).Order().ToList();
    }

    public async Task<(int Reencrypted, int Failed)> ReencryptToCurrentVersionAsync(CancellationToken ct) {
        const int batchSize = 100;
        var failedIds = new List<Guid>();
        var reencrypted = 0;

        while (true) {
            var batch = await db.BuergerKeyEscrows.AsTracking()
                .Where(e => e.KeyVersion != options.CurrentVersion && !failedIds.Contains(e.BuergerId))
                .OrderBy(e => e.BuergerId)
                .Take(batchSize)
                .ToListAsync(ct);
            if (batch.Count == 0) break;

            foreach (var escrow in batch) {
                try {
                    var plaintext = Decrypt(escrow.EncryptedPrivateKey, escrow.KeyVersion, escrow.BuergerId);
                    escrow.EncryptedPrivateKey = Encrypt(plaintext, escrow.BuergerId);
                    escrow.KeyVersion = options.CurrentVersion;
                    escrow.UpdatedAt = clock.GetCurrentInstant();
                    reencrypted++;
                } catch (Exception e) when (e is CryptographicException or KeyNotFoundException or ArgumentException) {
                    failedIds.Add(escrow.BuergerId);
                    logger.LogError("Key escrow of buerger {BuergerId} could not be re-encrypted from version {KeyVersion}",
                        escrow.BuergerId, escrow.KeyVersion);
                }
            }

            await db.SaveChangesAsync(ct);
            db.ChangeTracker.Clear();
        }

        return (reencrypted, failedIds.Count);
    }

    private async Task<bool> IsVerifiedAsync(Buerger buerger, CancellationToken ct) =>
        buerger.PhoneVerified
        || await db.ExternalIdentities.AnyAsync(e => e.BuergerId == buerger.Id && e.Provider == "bundid", ct);

    private byte[] Encrypt(byte[] plaintext, Guid buergerId) {
        var nonce = RandomNumberGenerator.GetBytes(NonceLength);
        var tag = new byte[TagLength];
        var cipher = new byte[plaintext.Length];
        using var aes = new AesGcm(options.GetKey(options.CurrentVersion), TagLength);
        aes.Encrypt(nonce, plaintext, cipher, tag, buergerId.ToByteArray());
        return [.. nonce, .. tag, .. cipher];
    }

    private byte[] Decrypt(byte[] stored, int keyVersion, Guid buergerId) {
        var nonce = stored.AsSpan(0, NonceLength);
        var tag = stored.AsSpan(NonceLength, TagLength);
        var cipher = stored.AsSpan(NonceLength + TagLength);
        var plaintext = new byte[cipher.Length];
        using var aes = new AesGcm(options.GetKey(keyVersion), TagLength);
        aes.Decrypt(nonce, cipher, tag, plaintext, buergerId.ToByteArray());
        return plaintext;
    }

    private static bool KeyMatches(byte[] privateKeyDer, string publicKeyBase64) {
        try {
            using var privateRsa = ImportPrivate(privateKeyDer);
            using var publicRsa = ImportPublic(Convert.FromBase64String(publicKeyBase64));
            var challenge = RandomNumberGenerator.GetBytes(32);
            var signature = privateRsa.SignData(challenge, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            return publicRsa.VerifyData(challenge, signature, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
        } catch (CryptographicException) {
            return false;
        }
    }

    private static RSA ImportPrivate(byte[] der) {
        var rsa = RSA.Create();
        try {
            rsa.ImportRSAPrivateKey(der, out _);
        } catch (CryptographicException) {
            rsa.ImportPkcs8PrivateKey(der, out _);
        }

        return rsa;
    }

    private static RSA ImportPublic(byte[] der) {
        var rsa = RSA.Create();
        try {
            rsa.ImportSubjectPublicKeyInfo(der, out _);
        } catch (CryptographicException) {
            rsa.ImportRSAPublicKey(der, out _);
        }

        return rsa;
    }
}
