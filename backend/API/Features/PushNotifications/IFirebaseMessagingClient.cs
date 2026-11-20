using FirebaseAdmin.Messaging;

namespace API.Features.PushNotifications;

public interface IFirebaseMessagingClient {
    Task SendAsync(Message message, CancellationToken cancellationToken = default);

    Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default);

    Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default);
}
