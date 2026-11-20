using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration der PmPayment-Schnittstelle.</summary>
public class PmPaymentOptions : IValidatable {
    /// <summary>Die Basis-URL des Zahlungsdienstes.</summary>
    [Required] public string Url { get; set; } = null!;
    /// <summary>Der Amtliche Gemeindeschlüssel (AGS) für die Zahlung.</summary>
    [Required] public string AGS { get; set; } = null!;
    /// <summary>Das verwendete Verfahren für die Zahlung.</summary>
    [Required] public string Procedure { get; set; } = null!;
    /// <summary>Der Salt-Wert zur Sicherung der Zahlung.</summary>
    [Required] public string Salt { get; set; } = null!;
    /// <summary>URL für Benachrichtigungen über Zahlungsstatus.</summary>
    [Required] public string NotificationUrl { get; set; } = null!;
    /// <summary>Host-Adresse für Weiterleitungen nach der Zahlung.</summary>
    [Required] public string RedirectHost { get; set; } = null!;

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
