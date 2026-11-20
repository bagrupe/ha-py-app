using API.Options;
using FirebaseAdmin.Messaging;
using Microsoft.Extensions.Options;

namespace API.Features.PushNotifications;

public sealed class FirebaseMessagingClient(IOptions<FirebaseOptions> options) : IFirebaseMessagingClient {
    public Task SendAsync(Message message, CancellationToken cancellationToken = default) {
        FirebaseAppBootstrap.EnsureCreated(options.Value.CredentialPath);
        return FirebaseMessaging.DefaultInstance.SendAsync(message, cancellationToken);
    }

    public Task SubscribeToTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) {
        FirebaseAppBootstrap.EnsureCreated(options.Value.CredentialPath);
        _ = cancellationToken;
        return FirebaseMessaging.DefaultInstance.SubscribeToTopicAsync(registrationTokens, topic);
    }

    public Task UnsubscribeFromTopicAsync(IReadOnlyList<string> registrationTokens, string topic,
        CancellationToken cancellationToken = default) {
        FirebaseAppBootstrap.EnsureCreated(options.Value.CredentialPath);
        _ = cancellationToken;
        return FirebaseMessaging.DefaultInstance.UnsubscribeFromTopicAsync(registrationTokens, topic);
    }
}
