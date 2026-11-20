using API.Features.PushNotifications;
using FirebaseAdmin.Messaging;

namespace IntegrationTests;

public sealed class RecordingFirebasePushMessagingService : IFirebasePushMessagingService {
    public List<Message> Messages = [];
    public Dictionary<string, HashSet<string>> Subscriptions = [];

    public Task SendAsync(Message message, CancellationToken cancellationToken = default) {
        Messages.Add(message);
        return Task.CompletedTask;
    }

    public Task<bool> TrySendAsync(Message message, string failureContext, CancellationToken cancellationToken = default) {
        Messages.Add(message);
        return Task.FromResult(true);
    }

    public Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic, CancellationToken cancellationToken = default) {
        if (!Subscriptions.TryGetValue(topic, out var tokens)) {
            tokens = [];
            Subscriptions[topic] = tokens;
        }

        tokens.UnionWith(registrationTokens);

        return Task.CompletedTask;
    }

    public async Task<bool> TrySubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        string failureContext, CancellationToken cancellationToken = default) {
        await SubscribeToTopicAsync(registrationTokens, topic, cancellationToken);
        return true;
    }

    public Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic, CancellationToken cancellationToken = default) {
        if (Subscriptions.TryGetValue(topic, out var tokens)) {
            tokens.RemoveWhere(a => registrationTokens.Contains(a));
        }

        return Task.CompletedTask;
    }

    public void Reset() {
        Messages = [];
        Subscriptions = [];
    }
}
