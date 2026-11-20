using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Beschreibung einer Umgebung mit einem Namen.</summary>
public class EnvironmentOptions : IValidatable {
    /// <summary>Der Name der Umgebung.</summary>
    [Required]
    public string Name { get; init; } = null!;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
