using FirebaseAdmin.Messaging;

namespace API.Features.PushNotifications;

/// <summary>Abstraktion für Firebase Cloud Messaging (Themen und Nachrichten).</summary>
public interface IFirebasePushMessagingService {
    Task SendAsync(Message message, CancellationToken cancellationToken = default);

    Task<bool> TrySendAsync(Message message, string failureContext, CancellationToken cancellationToken = default);

    Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default);

    Task<bool> TrySubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        string failureContext, CancellationToken cancellationToken = default);

    Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default);
}
