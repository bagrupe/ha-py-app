using System.ComponentModel.DataAnnotations;
using NetEscapades.Configuration.Validation;

namespace API.Options;

/// <summary>Optionen zur Konfiguration des E-Mail-Versands.</summary>
public class EMailOptions : IValidatable {
    /// <summary>Hostname des SMTP-Servers.</summary>
    [Required]
    public string Host { get; init; } = null!;
    /// <summary>Portnummer des SMTP-Servers.</summary>
    [Required]
    public int Port { get; init; }
    /// <summary>Benutzername für die Authentifizierung am SMTP-Server.</summary>
    [Required]
    public string User { get; init; } = null!;
    /// <summary>Passwort für die Authentifizierung am SMTP-Server.</summary>
    [Required]
    public string Password { get; init; } = null!;
    /// <summary>Gibt an, ob SSL für die Verbindung aktiviert ist.</summary>
    [Required]
    public bool EnableSsl { get; init; }
    /// <summary>Absenderadresse für ausgehende E-Mails.</summary>
    [Required]
    public string From { get; init; } = null!;

    /// <summary>Anzeigename des Absenders, optional.</summary>
    public string FromDisplayName { get; init; } = "";

    /// <summary>Validiert die aktuellen Optionen anhand der definierten Regeln.</summary>
    public void Validate() {
        Validator.ValidateObject(this, new ValidationContext(this), true);
    }
}
