using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration des GovManager-Dienstes.</summary>
public class GovManagerOptions : IValidatable {
    /// <summary>Die Basis-URL der REST-Schnittstelle.</summary>
    [Required] public string RestUrl { get; set; } = null!;
    /// <summary>Benutzername für die Authentifizierung am GovManager.</summary>
    [Required] public string Username { get; set; } = null!;
    /// <summary>Passwort für die Authentifizierung am GovManager.</summary>
    [Required] public string Password { get; set; } = null!;
    /// <summary>Schlüssel zur Identifikation der Antwort im GovManager.</summary>
    [Required] public string ResponseKey { get; set; } = null!;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
