using FirebaseAdmin.Messaging;

namespace API.Features.PushNotifications;

/// <summary>FCM über Firebase Admin SDK; nutzt <see cref="FirebaseAppBootstrap"/>.</summary>
public sealed class FirebasePushMessagingService(
    IFirebaseMessagingClient firebaseMessagingClient,
    ILogger<FirebasePushMessagingService> logger
) : IFirebasePushMessagingService {
    public Task SendAsync(Message message, CancellationToken cancellationToken = default) {
        return firebaseMessagingClient.SendAsync(message, cancellationToken);
    }

    public async Task<bool> TrySendAsync(Message message, string failureContext,
        CancellationToken cancellationToken = default) {
        try {
            await SendAsync(message, cancellationToken);
            return true;
        } catch (Exception ex) {
            logger.LogError(ex, "Failed to send Firebase push notification ({FailureContext})", failureContext);
            return false;
        }
    }

    public Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) {
        return firebaseMessagingClient.SubscribeToTopicAsync(registrationTokens, topic, cancellationToken);
    }

    public async Task<bool> TrySubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        string failureContext, CancellationToken cancellationToken = default) {
        try {
            await SubscribeToTopicAsync(registrationTokens, topic, cancellationToken);
            return true;
        } catch (Exception ex) {
            logger.LogError(ex, "Failed to subscribe to Firebase push topic ({FailureContext})", failureContext);
            return false;
        }
    }

    public Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) {
        return firebaseMessagingClient.UnsubscribeFromTopicAsync(registrationTokens, topic, cancellationToken);
    }
}
