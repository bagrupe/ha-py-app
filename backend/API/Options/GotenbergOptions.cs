using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration des Gotenberg-Dienstes.</summary>
public class GotenbergOptions : IValidatable {
    /// <summary>Die URL des Gotenberg-Dienstes.</summary>
    [Required] public string Url { get; set; } = "";

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
