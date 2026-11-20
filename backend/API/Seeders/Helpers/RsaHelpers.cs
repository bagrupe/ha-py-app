using System.Security.Cryptography;

namespace API.Seeders.Helpers;

/// <summary>Stellt Hilfsmethoden für die Arbeit mit RSA-Schlüsseln bereit.</summary>
public static class RsaHelpers {
    /// <summary>Erzeugt ein RSA-Objekt aus einem XML-String mit einem 4096-Bit-Schlüssel.</summary>
    /// <param name="xml">Der XML-String, der den RSA-Schlüssel enthält.</param>
    /// <returns>Ein initialisiertes RSA-Objekt.</returns>
    public static RSA FromXmlString(string xml) {
        var rsa = RSA.Create(4096);
        rsa.FromXmlString(xml);
        return rsa;
    }
}
