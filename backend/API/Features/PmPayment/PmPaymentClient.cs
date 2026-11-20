using System.Collections.Specialized;
using System.Security.Cryptography;
using System.Text;
using API.Options;

namespace API.Features.PmPayment;

/// <summary>Ermöglicht das Erzeugen von Zahlungs-URLs für externe Zahlungsvorgänge.</summary>
public class PmPaymentClient {
    private readonly PmPaymentOptions _options;

    /// <summary>Initialisiert den Zahlungsclient mit den erforderlichen Optionen.</summary>
    /// <param name="options">Konfigurationseinstellungen für den Zahlungsdienst.</param>
    public PmPaymentClient(PmPaymentOptions options) {
        _options = options;
    }

    /// <summary>Generiert eine URL zur Einleitung eines Zahlungsvorgangs mit den angegebenen Parametern.</summary>
    /// <param name="amount">Der zu zahlende Betrag in Cent.</param>
    /// <param name="description">Beschreibung des Zahlungsvorgangs.</param>
    /// <param name="txId">Eindeutige Transaktions-ID der Zahlung.</param>
    /// <param name="ausfuehrungId">ID der zugehörigen Ausführung.</param>
    /// <returns>Die vollständige URL zur Zahlungsseite.</returns>
    public string GeneratePaymentUrl(int amount, string description, Guid txId, Guid ausfuehrungId) {
        NameValueCollection queryStringBuilder = System.Web.HttpUtility.ParseQueryString(string.Empty);

        queryStringBuilder.Add("ags", _options.AGS);
        queryStringBuilder.Add("amount", amount.ToString());
        queryStringBuilder.Add("procedure", _options.Procedure);
        queryStringBuilder.Add("desc", description);
        queryStringBuilder.Add("notifyURL", _options.NotificationUrl);
        queryStringBuilder.Add("redirectURL", $"https://{_options.RedirectHost}/deeplinks/ausfuehrungContinue/{ausfuehrungId}");

        queryStringBuilder.Add("txid", txId.ToString());

        var toHash = string.Join("|", queryStringBuilder.Keys
            .Cast<string>()
            .Select(k => queryStringBuilder[k]!));

        var hash = new HMACSHA256(Encoding.UTF8.GetBytes(_options.Salt));
        var hashBytes = hash.ComputeHash(Encoding.UTF8.GetBytes(toHash));
        var hashString = Convert.ToHexString(hashBytes).ToLower();

        queryStringBuilder.Add("hash", hashString);

        var url = $"{_options.Url}/payment/start?{queryStringBuilder}";

        return url;
    }
}
