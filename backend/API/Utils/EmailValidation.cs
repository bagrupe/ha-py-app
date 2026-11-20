namespace API.Utils;
using System.Net.Mail;

/// <summary>Stellt Methoden zur Validierung von E-Mail-Adressen bereit.</summary>
public class EmailValidation {

    /// <summary>Prüft, ob eine gegebene Zeichenkette eine gültige E-Mail-Adresse ist.</summary>
    /// <param name="email">Die zu prüfende E-Mail-Adresse als Zeichenkette.</param>
    /// <returns>True, wenn die E-Mail-Adresse gültig ist, sonst false.</returns>
    public static bool IsValidEmail(string email) {
        try {
            var mailAddress = new MailAddress(email);
            return true;
        } catch (FormatException) {
            return false;
        }
    }

    /// <summary>Prüft, ob jede der gegebenen Zeichenketten eine gültige E-Mail-Adresse ist.</summary>
    /// <param name="emails">Die zu prüfenden E-Mail-Adressen.</param>
    /// <returns>True, wenn alle E-Mail-Adressen gültig sind, sonst false.</returns>
    public static bool AreValidEmails(IEnumerable<string> emails) => emails.All(IsValidEmail);

    /// <summary>
    /// Trimmt, entfernt leere Einträge und Duplikate (case-insensitive) und validiert jede der übrigen
    /// E-Mail-Adressen einer Liste.
    /// </summary>
    /// <param name="emails">Die rohen, vom Client übermittelten E-Mail-Adressen.</param>
    /// <returns>Die bereinigte Liste gültiger E-Mail-Adressen.</returns>
    /// <exception cref="InvalidEmailException">Wenn eine der übrigen Adressen ungültig ist.</exception>
    public static List<string> NormalizeEmails(IEnumerable<string> emails) {
        var normalized = emails
            .Select(e => e.Trim())
            .Where(e => !string.IsNullOrEmpty(e))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();

        if (!AreValidEmails(normalized)) throw new InvalidEmailException();

        return normalized;
    }
}
