using FirebaseAdmin.Messaging;

namespace API.Features.PushNotifications;

/// <summary>Ersetzt FCM in der Umgebung <c>Testing</c> (kein FirebaseApp, keine Netzwerkaufrufe).</summary>
public sealed class NoOpFirebasePushMessagingService : IFirebasePushMessagingService {
    public Task SendAsync(Message message, CancellationToken cancellationToken = default) =>
        Task.CompletedTask;

    public Task<bool> TrySendAsync(Message message, string failureContext, CancellationToken cancellationToken = default) =>
        Task.FromResult(true);

    public Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) => Task.CompletedTask;

    public Task<bool> TrySubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        string failureContext, CancellationToken cancellationToken = default) => Task.FromResult(true);

    public Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) => Task.CompletedTask;
}
