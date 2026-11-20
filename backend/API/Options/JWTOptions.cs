using System.ComponentModel.DataAnnotations;
using System.Text;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration von JWT-Token.</summary>
public class JWTOptions : IValidatable {
    /// <summary>Geheimer Schlüssel zur Signierung des Tokens.</summary>
    [Required]
    public string Key { get; init; } = null!;

    /// <summary>Aussteller des Tokens.</summary>
    [Required]
    public string Issuer { get; init; } = null!;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
        if (Encoding.UTF8.GetByteCount(Key) < 32) {
            throw new ValidationException(
                "JWT:Key must contain at least 32 UTF-8 bytes for HS256.");
        }
    }
}
