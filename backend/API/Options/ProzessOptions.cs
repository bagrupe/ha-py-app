using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration der Prozess-Ausführung.</summary>
public class ProzessOptions : IValidatable {
    /// <summary>Maximale Zeichenlänge der Freitextnachricht eines Nachricht-Schritts.</summary>
    [Range(1, 100_000)]
    public int NachrichtMaxLength { get; init; } = 2000;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
