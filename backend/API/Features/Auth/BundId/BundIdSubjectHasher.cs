using System.Security.Cryptography;
using System.Text;
using API.Options;

namespace API.Features.Auth.BundId;

/// <summary>Berechnet den Speicher-Hash für ein externes BundID-Subject (Issuer + bPK2).</summary>
public interface IBundIdSubjectHasher {
    string ComputeHash(string issuer, string subject);
}

/// <summary>
/// Deterministischer, domänenseparierter HMAC-SHA-256-Hash aus Issuer und externem OIDC-Subject
/// (bPK2), damit das Klartext-Subject nicht in der fachlichen Datenbank gespeichert werden muss
/// (siehe <see cref="ExternalIdentity.SubjectHash"/>). Der verwendete Schlüssel wird aus dem
/// JWT-Signing-Secret abgeleitet, aber domänensepariert: eine Kompromittierung des
/// Subject-Hash-Schlüssels erlaubt keinen Rückschluss auf den JWT-Signing-Schlüssel und
/// umgekehrt.
/// </summary>
public class BundIdSubjectHasher : IBundIdSubjectHasher {
    private const string DomainSeparationLabel = "bundid-subject-hash-v1";

    private readonly byte[] _derivedKey;

    public BundIdSubjectHasher(JWTOptions jwtOptions) {
        using var deriveHmac = new HMACSHA256(Encoding.UTF8.GetBytes(jwtOptions.Key));
        _derivedKey = deriveHmac.ComputeHash(Encoding.UTF8.GetBytes(DomainSeparationLabel));
    }

    public string ComputeHash(string issuer, string subject) {
        ArgumentException.ThrowIfNullOrEmpty(issuer);
        ArgumentException.ThrowIfNullOrEmpty(subject);

        using var hmac = new HMACSHA256(_derivedKey);
        var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes($"{issuer}|{subject}"));
        return Convert.ToHexString(hash).ToLowerInvariant();
    }
}
