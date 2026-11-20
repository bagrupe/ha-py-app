using API.Infrastructure.Exceptions;
using API.Options;
using brevo_csharp.Client;
using Microsoft.Extensions.Hosting;
using Task = System.Threading.Tasks.Task;

namespace API.Features.Auth;

public interface ISmsService {
    Task SendSms(string telephoneNumber, string text);
}

/// <summary>
/// Versendet Verifizierungs-SMS über Brevo. Siehe <see cref="BrevoOptions"/>: ist kein API-Key
/// hinterlegt, wird in Development/Testing nur geloggt statt wirklich versendet (kein echter
/// Brevo-Account für die lokale Entwicklung nötig). In jeder anderen Umgebung ist das ein
/// Konfigurationsfehler statt eines stillen Fake-Erfolgs.
/// </summary>
public class SmsService(
    BrevoOptions options,
    IHostEnvironment hostEnvironment,
    ILogger<SmsService> logger
) : ISmsService {
    public async Task SendSms(string telephoneNumber, string text) {
        if (string.IsNullOrEmpty(options.ApiKey)) {
            if (!hostEnvironment.IsDevelopment() && !hostEnvironment.IsEnvironment("Testing")) {
                logger.LogWarning("Brevo:ApiKey is not configured, cannot send SMS");
                throw new SmsDeliveryFailedException();
            }

            var fallbackPhoneHash = PhoneHashingService.ComputeHash(telephoneNumber);
            logger.LogInformation("Send SMS to {phoneHash} with Text '{text}'", fallbackPhoneHash, text);
            return;
        }

        var configuration = new Configuration();
        configuration.ApiKey["api-key"] = options.ApiKey;

        var api = new brevo_csharp.Api.TransactionalSMSApi(configuration);
        var sendTransacSms = new brevo_csharp.Model.SendTransacSms(
            sender: options.Sender,
            recipient: telephoneNumber,
            content: text,
            type: brevo_csharp.Model.SendTransacSms.TypeEnum.Transactional);

        // Die Telefonnummer landet bewusst nie im Klartext im Log – nur ein Hash zur
        // Nachvollziehbarkeit (z.B. um wiederholte Fehlschläge für dieselbe Nummer zu erkennen),
        // siehe PhoneHashingService.
        var phoneHash = PhoneHashingService.ComputeHash(telephoneNumber);
        try {
            await api.SendTransacSmsAsync(sendTransacSms);
            logger.LogInformation("SMS sent successfully to {phoneHash}", phoneHash);
        } catch (ApiException ex) when (ex.ErrorCode is >= 400 and < 500) {
            // Brevo weist 4xx-Antworten typischerweise bei ungültigen/nicht erreichbaren
            // Empfängernummern aus (z.B. ungültiges Land, gesperrte Nummer) – ein 5xx/Netzwerkfehler
            // ist dagegen ein Problem auf Brevo-Seite, nicht an der Nummer selbst.
            logger.LogWarning(
                ex, "SMS to {phoneHash} rejected by Brevo (status {status})", phoneHash, ex.ErrorCode);
            throw new SmsInvalidPhoneNumberException();
        } catch (Exception ex) {
            logger.LogWarning(ex, "SMS to {phoneHash} could not be delivered", phoneHash);
            throw new SmsDeliveryFailedException();
        }
    }
}
