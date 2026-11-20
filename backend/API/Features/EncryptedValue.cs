using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace API.Features;

/// <summary>Repräsentiert einen verschlüsselten Wert mit Nonce, Tag und Ciphertext.</summary>
public record EncryptedValue {
    /// <summary>Initialisiert eine neue Instanz von EncryptedValue mit den angegebenen Komponenten.</summary>
    /// <param name="Nonce">Der Nonce-Wert für die Verschlüsselung.</param>
    /// <param name="Tag">Der Authentifizierungs-Tag der Verschlüsselung.</param>
    /// <param name="Cipher">Der verschlüsselte Text (Ciphertext).</param>
    public EncryptedValue(string Nonce, string Tag, string Cipher) {
        this.Nonce = Nonce;
        this.Tag = Tag;
        this.Cipher = Cipher;
    }

    /// <summary>Initialisiert eine neue Instanz von EncryptedValue durch Kopieren eines bestehenden Werts.</summary>
    /// <param name="encryptedValue">Der zu kopierende verschlüsselte Wert.</param>
    public EncryptedValue(EncryptedValue encryptedValue) {
        Nonce = encryptedValue.Nonce;
        Tag = encryptedValue.Tag;
        Cipher = encryptedValue.Cipher;
    }

    public string Nonce { get; init; }
    public string Tag { get; init; }
    public string Cipher { get; init; }
}

/// <summary>Konvertiert EncryptedValue-Objekte in Strings und zurück für die Datenbankspeicherung.</summary>
public class EncryptedValueConverter : ValueConverter<EncryptedValue, string> {
    /// <summary>Initialisiert eine neue Instanz des Konverters mit den Umwandlungsfunktionen.</summary>
    public EncryptedValueConverter() : base(
        v => $"{v.Nonce.Replace(":", "")}:{v.Tag.Replace(":", "")}:{v.Cipher.Replace(":", "")}",
        v => Parse(v)) {
    }

    public override bool ConvertsNulls => false;

    private static EncryptedValue Parse(string joined) {
        var split = joined.Split(":");
        return new EncryptedValue(split[0], split[1], split[2]);
    }
}
