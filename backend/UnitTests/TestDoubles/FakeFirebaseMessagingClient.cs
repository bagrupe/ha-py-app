using API.Features.PushNotifications;
using FirebaseAdmin.Messaging;

namespace IntegrationTests.TestDoubles;

public sealed class FakeFirebaseMessagingClient : IFirebaseMessagingClient {
    public List<Message> SentMessages { get; } = [];
    public List<(IReadOnlyList<string> RegistrationTokens, string Topic)> Subscriptions { get; } = [];
    public List<(IReadOnlyList<string> RegistrationTokens, string Topic)> Unsubscriptions { get; } = [];

    public Exception? SendException { get; set; }
    public Exception? SubscribeException { get; set; }
    public Exception? UnsubscribeException { get; set; }

    public Task SendAsync(Message message, CancellationToken cancellationToken = default) {
        if (SendException is not null) {
            throw SendException;
        }

        SentMessages.Add(message);
        return Task.CompletedTask;
    }

    public Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) {
        if (SubscribeException is not null) {
            throw SubscribeException;
        }

        Subscriptions.Add((registrationTokens, topic));
        return Task.CompletedTask;
    }

    public Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) {
        if (UnsubscribeException is not null) {
            throw UnsubscribeException;
        }

        Unsubscriptions.Add((registrationTokens, topic));
        return Task.CompletedTask;
    }
}
