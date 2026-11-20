using API.Features.Auth;

namespace IntegrationTests;

public class RecordingSmsService : ISmsService {
    public List<Sms> SentSms = [];
    public Task SendSms(string telephoneNumber, string text) {
        SentSms.Add(new Sms(telephoneNumber, text));
        return Task.CompletedTask;
    }

    public record Sms(string telephoneNumber, string text);
}
