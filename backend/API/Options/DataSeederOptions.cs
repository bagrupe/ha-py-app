using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Steuerung des Daten-Seeders.</summary>
public class DataSeederOptions : IValidatable {
    /// <summary>Gibt an, ob der Daten-Seeder aktiviert ist.</summary>
    public bool Enabled { get; init; } = false;

    /// <summary>
    /// Gibt an, ob die Demo-Daten des LageHelfer-Mandanten (KRL Weserbergland) gesät werden.
    /// Unabhängig von <see cref="Enabled"/>, damit z.B. Staging nur diesen Mandanten erhält.
    /// </summary>
    public bool LageHelferEnabled { get; init; } = false;

    /// <summary>Verzeichnis mit <c>seed.json</c> und <c>flaechen.geojson</c>.</summary>
    public string? LageHelferSeedPath { get; init; }

    /// <summary>Base64-Schlüssel zum Verschlüsseln des privaten Kommunen-Schlüssels (AES).</summary>
    public string? LageHelferKeyEncryptionKey { get; init; }

    /// <summary>Gibt an, ob vorhandene Daten vor dem Seed neu erstellt werden sollen.</summary>
    public bool Recreate { get; init; } = false;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
        if (LageHelferEnabled) {
            if (string.IsNullOrWhiteSpace(LageHelferSeedPath)) {
                throw new ValidationException(
                    "DataSeeder:LageHelferSeedPath muss gesetzt sein, wenn DataSeeder:LageHelferEnabled aktiv ist.");
            }

            if (string.IsNullOrWhiteSpace(LageHelferKeyEncryptionKey)) {
                throw new ValidationException(
                    "DataSeeder:LageHelferKeyEncryptionKey muss gesetzt sein, wenn DataSeeder:LageHelferEnabled aktiv ist.");
            }

            try {
                _ = Convert.FromBase64String(LageHelferKeyEncryptionKey);
            } catch (FormatException) {
                throw new ValidationException(
                    "DataSeeder:LageHelferKeyEncryptionKey muss ein gültiger Base64-String sein.");
            }
        }
    }
}
