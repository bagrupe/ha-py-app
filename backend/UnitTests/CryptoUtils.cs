using System.Security.Cryptography;
using System.Text;
using API.Features.Auth;
using API.Infrastructure;
using Microsoft.AspNetCore.Identity;

public record TestEncryptedValue(string Cipher, string Tag, string Nonce);
public record EncryptionResult(TestEncryptedValue Encrypted, string Salt);

public static class TestUserCrypto {
    /// <summary>Same crypto bootstrap as <c>CryptoExtensions.SetOrganisationCryptoAndPassword</c> (internal to API).</summary>
    public static void InitializeMitarbeiterCrypto(Mitarbeiter user, string plainPassword,
        byte[] kommuneKeyEncryptionKey, IPasswordHasher<User> passwordHasher) {
        using var rsa = RSA.Create(4096);
        user.PublicKey = Convert.ToBase64String(rsa.ExportSubjectPublicKeyInfo());
        var derivedPassword =
            Convert.ToBase64String(Crypto.DeriveKey(plainPassword, Encoding.UTF8.GetBytes(user.EMail), 512));
        user.Password = passwordHasher.HashPassword(user, derivedPassword);
        var userPersonalPrivateKeySalt = RandomNumberGenerator.GetBytes(64);
        user.PersonalPrivateKeySalt = Convert.ToBase64String(userPersonalPrivateKeySalt);
        var privateKeyEncryptionKey = Crypto.DeriveKey(plainPassword, userPersonalPrivateKeySalt, 256);
        var privateKey = rsa.ExportPkcs8PrivateKey();
        user.PersonalPrivateKey = Crypto.Encrypt(privateKey, privateKeyEncryptionKey);
        user.OrganisationPrivateKey =
            Convert.ToBase64String(rsa.Encrypt(kommuneKeyEncryptionKey, RSAEncryptionPadding.OaepSHA512));
    }
}

/// <summary>
///  functions from the frontend for crypto
/// </summary>
public class CryptoService {
    private const int TagLengthInBytes = 16; // 128 bits, matching standard AES-GCM tags

    public async Task<RSA> GenerateKeyPair() {
        var rsa = RSA.Create(4096);
        return await Task.FromResult(rsa);
    }

    public async Task<EncryptionResult> EncryptPersonalKey(string password, string email, RSA personalPrivateKey) {
        byte[] salt = new byte[64];
        string saltBase64;

        // Salt generation loop
        do {
            RandomNumberGenerator.Fill(salt);
            saltBase64 = Convert.ToBase64String(salt);
        } while (saltBase64 == email);

        byte[] passwordBytes = Encoding.UTF8.GetBytes(password);
        byte[] derivedKeyBytes = Rfc2898DeriveBytes.Pbkdf2(
            passwordBytes,
            salt,
            iterations: 100_000,
            hashAlgorithm: HashAlgorithmName.SHA512,
            outputLength: 32 // 256 bits for AES
        );

        using var aesGcm = new AesGcm(derivedKeyBytes, TagLengthInBytes);

        byte[] iv = new byte[12]; // Nonce
        RandomNumberGenerator.Fill(iv);

        byte[] privateKeyBytes = personalPrivateKey.ExportPkcs8PrivateKey();

        byte[] ciphertext = new byte[privateKeyBytes.Length];
        byte[] tag = new byte[TagLengthInBytes];

        aesGcm.Encrypt(iv, privateKeyBytes, ciphertext, tag);

        return new EncryptionResult(
            new TestEncryptedValue(
                Convert.ToBase64String(ciphertext),
                Convert.ToBase64String(tag),
                Convert.ToBase64String(iv)
            ),
            saltBase64
        );
    }
    public string GetServerLoginPassword(string clientPassword, string email) {
        var saltBytes = Encoding.UTF8.GetBytes(email);

        using var pbkdf2 = new Rfc2898DeriveBytes(
            clientPassword,
            saltBytes,
            100_000,
            HashAlgorithmName.SHA512);

        var derivedBytes = pbkdf2.GetBytes(64);

        return Convert.ToBase64String(derivedBytes);
    }
    public async Task<string> ExportPublicKey(RSA publicKey) {
        // ExportSubjectPublicKeyInfo is the .NET equivalent of 'spki'
        byte[] exported = publicKey.ExportSubjectPublicKeyInfo();

        return await Task.FromResult(Convert.ToBase64String(exported));
    }
}
