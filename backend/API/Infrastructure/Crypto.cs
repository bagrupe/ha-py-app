using System.Security.Cryptography;
using System.Text;
using API.Features;
using API.Features.Auth;
using Microsoft.AspNetCore.Identity;
using Org.BouncyCastle.Crypto.Digests;
using Org.BouncyCastle.Crypto.Generators;
using Org.BouncyCastle.Crypto.Parameters;

namespace API.Infrastructure;

/// <summary>Erweitert User-Objekte um Methoden zur Passwort- und Kryptografie-Initialisierung.</summary>
internal static class CryptoExtensions {
    /// <summary>Setzt das Passwort eines Users mit einem Passwort-Hasher.</summary>
    /// <param name="user">Der User, dessen Passwort gesetzt wird.</param>
    /// <param name="password">Das Klartext-Passwort.</param>
    /// <param name="passwordHasher">Der Passwort-Hasher zur Erzeugung des Hashes.</param>
    /// <returns>Den User mit gesetztem Passwort.</returns>
    internal static T SetPassword<T>(this T user, string password, IPasswordHasher<User> passwordHasher)
        where T : User {
        user.Password = passwordHasher.HashPassword(user, password);

        return user;
    }

    /// <summary>Initialisiert Kryptografie und Passwort für einen User mit Salt.</summary>
    /// <param name="user">Der User, der initialisiert wird.</param>
    /// <param name="password">Das Klartext-Passwort.</param>
    /// <param name="salt">Der Salt-Wert für die Schlüsselableitung.</param>
    /// <param name="passwordHasher">Der Passwort-Hasher zur Erzeugung des Passwort-Hashes.</param>
    /// <returns>Den User mit gesetztem Passwort und Kryptografie.</returns>
    internal static T SetCryptoAndPassword<T>(this T user, string password, string salt,
        IPasswordHasher<User> passwordHasher) where T : User {

        using var rsaCryptoServiceProvider = RSA.Create(4096);

        return user.SetCryptoAndPassword(password, salt, passwordHasher, rsaCryptoServiceProvider);
    }

    /// <summary>Initialisiert Kryptografie und Passwort für einen Mitarbeiter mit Organisationsschlüssel.</summary>
    /// <param name="user">Der Mitarbeiter, der initialisiert wird.</param>
    /// <param name="password">Das Klartext-Passwort.</param>
    /// <param name="organisationKey">Der Organisationsschlüssel als Byte-Array.</param>
    /// <param name="passwordHasher">Der Passwort-Hasher zur Erzeugung des Passwort-Hashes.</param>
    /// <returns>Den Mitarbeiter mit gesetztem Passwort, Kryptografie und verschlüsseltem Organisationsschlüssel.</returns>
    internal static T SetOrganisationCryptoAndPassword<T>(this T user, string password, byte[] organisationKey,
        IPasswordHasher<User> passwordHasher) where T : Mitarbeiter {

        using var rsaCryptoServiceProvider = RSA.Create(4096);

        user.SetCryptoAndPassword(password, user.EMail, passwordHasher, rsaCryptoServiceProvider);

        user.OrganisationPrivateKey =
            Convert.ToBase64String(rsaCryptoServiceProvider.Encrypt(organisationKey, RSAEncryptionPadding.OaepSHA512));

        return user;
    }

    /// <summary>Initialisiert Kryptografie und Passwort für einen User mit gegebenem RSA-Provider.</summary>
    /// <param name="user">Der User, der initialisiert wird.</param>
    /// <param name="password">Das Klartext-Passwort.</param>
    /// <param name="salt">Der Salt-Wert für die Schlüsselableitung.</param>
    /// <param name="passwordHasher">Der Passwort-Hasher zur Erzeugung des Passwort-Hashes.</param>
    /// <param name="rsaCryptoServiceProvider">Der RSA-Kryptografie-Provider.</param>
    /// <returns>Den User mit gesetztem Passwort, Kryptografie und verschlüsseltem privaten Schlüssel.</returns>
    public static T SetCryptoAndPassword<T>(this T user, string password, string salt,
        IPasswordHasher<User> passwordHasher, AsymmetricAlgorithm rsaCryptoServiceProvider) where T : User {

        user.PublicKey = rsaCryptoServiceProvider.ExportSubjectPublicKeyInfo().ToBase64();

        user.SetPassword(
            Convert.ToBase64String(Crypto.DeriveKey(password, Encoding.UTF8.GetBytes(salt), 512)),
            passwordHasher);

        var userPersonalPrivateKeySalt = RandomNumberGenerator.GetBytes(64);
        user.PersonalPrivateKeySalt = Convert.ToBase64String(userPersonalPrivateKeySalt);
        var privateKeyEncryptionKey = Crypto.DeriveKey(password, userPersonalPrivateKeySalt, 256);
        var privateKey = rsaCryptoServiceProvider.ExportPkcs8PrivateKey();

        if (user is Buerger buerger) {
            var userPersonalDataKey = RandomNumberGenerator.GetBytes(32);
            var encryptedUserKey = ((RSA)rsaCryptoServiceProvider).Encrypt(userPersonalDataKey, RSAEncryptionPadding.OaepSHA512); ;
            buerger.PersonalDataKeyEncryptedForBuerger = encryptedUserKey.ToBase64();
        }

        user.PersonalPrivateKey = Crypto.Encrypt(privateKey, privateKeyEncryptionKey);

        return user;
    }
}

/// <summary>Bietet kryptografische Hilfsmethoden für Schlüsselableitung und symmetrische Verschlüsselung.</summary>
public static class Crypto {
    /// <summary>Leitet einen Schlüssel aus Passwort und Salt mit PBKDF2 und SHA-512 ab.</summary>
    /// <param name="password">Das Klartext-Passwort.</param>
    /// <param name="salt">Der Salt-Wert als Byte-Array.</param>
    /// <param name="keySize">Die gewünschte Schlüssellänge in Bits.</param>
    /// <returns>Das abgeleitete Schlüssel-Byte-Array.</returns>
    public static byte[] DeriveKey(string password, byte[] salt, int keySize) {
        var generator = new Pkcs5S2ParametersGenerator(new Sha512Digest());
        generator.Init(Encoding.UTF8.GetBytes(password), salt, 100_000);
        return ((KeyParameter)generator.GenerateDerivedMacParameters(keySize)).GetKey();
    }

    /// <summary>Verschlüsselt einen UTF-8-kodierten Klartext mit einem Schlüssel.</summary>
    /// <param name="plain">Der Klartext als String.</param>
    /// <param name="key">Der symmetrische Schlüssel als Byte-Array.</param>
    /// <returns>Den verschlüsselten Wert mit Nonce, Tag und Ciphertext.</returns>
    public static EncryptedValue Encrypt(string plain, byte[] key) {
        return Encrypt(Encoding.UTF8.GetBytes(plain), key);
    }

    /// <summary>Verschlüsselt ein Byte-Array mit einem symmetrischen Schlüssel mittels AES-GCM.</summary>
    /// <param name="plain">Die Klartext-Bytes.</param>
    /// <param name="key">Der symmetrische Schlüssel als Byte-Array.</param>
    /// <returns>Den verschlüsselten Wert mit Nonce, Tag und Ciphertext.</returns>
    public static EncryptedValue Encrypt(byte[] plain, byte[] key) {
        var nonce = new byte[AesGcm.NonceByteSizes.MaxSize];
        var tag = new byte[AesGcm.TagByteSizes.MaxSize];
        var cipherBytes = new byte[plain.Length];

        RandomNumberGenerator.Fill(nonce);

        using var aes = new AesGcm(key, 16);
        aes.Encrypt(nonce, plain, cipherBytes, tag);

        return new EncryptedValue(Convert.ToBase64String(nonce), Convert.ToBase64String(tag),
            Convert.ToBase64String(cipherBytes));
    }

    /// <summary>Entschlüsselt einen verschlüsselten Wert mit einem symmetrischen Schlüssel.</summary>
    /// <param name="encryptedValue">Der verschlüsselte Wert mit Nonce, Tag und Ciphertext.</param>
    /// <param name="key">Der symmetrische Schlüssel als Byte-Array.</param>
    /// <returns>Die entschlüsselten Klartext-Bytes.</returns>
    public static byte[] Decrypt(EncryptedValue encryptedValue, byte[] key) {
        var plainBytes = new byte[encryptedValue.Cipher.Length];
        var nonce = Convert.FromBase64String(encryptedValue.Nonce);
        var tag = Convert.FromBase64String(encryptedValue.Tag);
        var cipherBytes = Convert.FromBase64String(encryptedValue.Cipher);

        using var aes = new AesGcm(key, 16);
        aes.Decrypt(nonce, cipherBytes, tag, plainBytes);

        return plainBytes;
    }

    /// <summary>Konvertiert ein Byte-Array in einen Base64-kodierten String.</summary>
    /// <param name="bytes">Das Byte-Array.</param>
    /// <returns>Der Base64-kodierte String.</returns>
    public static string ToBase64(this byte[] bytes) {
        return Convert.ToBase64String(bytes);
    }
}
