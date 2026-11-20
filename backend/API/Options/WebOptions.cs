using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration der Webschnittstelle.</summary>
public class WebOptions : IValidatable {
    /// <summary>Die Basis-URL der Webschnittstelle.</summary>
    public string BaseUrl { get; init; } = null!;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
