using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>
/// Zugangsdaten für den Versand von Verifizierungs-SMS über Brevo (siehe
/// <see cref="Features.Auth.SmsService"/>). Bewusst kein separates "Enabled"-Flag: ist
/// <see cref="ApiKey"/> leer, versendet der Dienst nicht wirklich, sondern loggt nur – so ist für
/// die lokale Entwicklung kein echter Brevo-Account nötig. In Staging/Produktion wird der Wert wie
/// die übrigen Secrets per Umgebungsvariable (<c>Brevo__ApiKey</c>) gesetzt, nicht im Repo.
///
/// Wichtig: dies ist der REST-API-Key aus dem Brevo-Dashboard (Tab "API Keys", Präfix
/// <c>xkeysib-</c>) – nicht der SMTP-Key für den E-Mail-Versand (Präfix <c>xsmtpsib-</c>,
/// <see cref="EMailOptions"/>). Beide gehören zwar zum selben Brevo-Account, sind aber getrennte
/// Credentials für unterschiedliche APIs.
/// </summary>
public class BrevoOptions : IValidatable {
    /// <summary>REST-API-Key aus dem Brevo-Dashboard. Leer = nur loggen, nicht wirklich versenden.</summary>
    public string ApiKey { get; init; } = "";

    /// <summary>
    /// Bei Brevo für Transaktions-SMS freigeschalteter Absendername (Sender-ID) – muss exakt dem
    /// Wert entsprechen, der im Brevo-Konfigurationsassistenten für Transaktions-SMS hinterlegt
    /// wurde, sonst weist Brevo den Versand ab. Brevo selbst erlaubt hier maximal 11 alphanumerische
    /// Zeichen (keine Sonderzeichen) – wird hier bewusst schon vorab geprüft, damit ein falsch
    /// gesetzter Wert beim Start auffällt statt erst beim ersten tatsächlichen Versand.
    /// </summary>
    [RegularExpression(
        "^[a-zA-Z0-9]*$",
        ErrorMessage = "Brevo:Sender darf nur alphanumerische Zeichen enthalten."
    )]
    [StringLength(11, ErrorMessage = "Brevo:Sender darf höchstens 11 Zeichen lang sein.")]
    public string Sender { get; init; } = "";

    /// <summary>
    /// Textvorlage für die Verifizierungs-SMS. Muss den Platzhalter <c>{code}</c> enthalten, der
    /// beim Versand durch den tatsächlichen Verifizierungscode ersetzt wird (siehe
    /// <see cref="Features.Auth.Mutations.EhrenamtsbankAuthService"/>).
    /// </summary>
    [Required]
    public string MessageTemplate { get; init; } =
        "Der Code für ihre Anmeldung lautet {code}";

    /// <inheritdoc />
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
        if (!MessageTemplate.Contains("{code}")) {
            throw new ValidationException("Brevo:MessageTemplate muss den Platzhalter {code} enthalten.");
        }
    }
}
