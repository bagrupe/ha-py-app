using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration des KawHameln-Dienstes.</summary>
public class KawHamelnOptions : IValidatable {
    /// <summary>Die Basis-URL der REST-Schnittstelle.</summary>
    [Required] public string RestUrl { get; set; } = null!;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
