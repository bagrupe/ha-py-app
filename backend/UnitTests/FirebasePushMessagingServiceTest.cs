using API.Features.PushNotifications;
using FirebaseAdmin.Messaging;
using IntegrationTests.TestDoubles;
using Microsoft.Extensions.Logging;

namespace IntegrationTests;

public class FirebasePushMessagingServiceTest {
    [Fact]
    public async Task TrySendAsync_ReturnsTrue_WhenFirebaseSendSucceeds() {
        var firebaseClient = new FakeFirebaseMessagingClient();
        var logger = new TestLogger<FirebasePushMessagingService>();
        var service = new FirebasePushMessagingService(firebaseClient, logger);
        var message = new Message { Topic = "test-topic" };

        var result = await service.TrySendAsync(message, "test push");

        Assert.True(result);
        Assert.Same(message, Assert.Single(firebaseClient.SentMessages));
        Assert.Empty(logger.Entries);
    }

    [Fact]
    public async Task TrySendAsync_ReturnsFalseAndLogsError_WhenFirebaseSendThrows() {
        var exception = new InvalidOperationException("firebase failed");
        var firebaseClient = new FakeFirebaseMessagingClient { SendException = exception };
        var logger = new TestLogger<FirebasePushMessagingService>();
        var service = new FirebasePushMessagingService(firebaseClient, logger);

        var result = await service.TrySendAsync(new Message { Topic = "test-topic" }, "Mangel abgeschlossen");

        Assert.False(result);
        var entry = Assert.Single(logger.Entries);
        Assert.Equal(LogLevel.Error, entry.Level);
        Assert.Same(exception, entry.Exception);
        Assert.Contains("Mangel abgeschlossen", entry.Message);
    }

    [Fact]
    public async Task SendAsync_StillPropagatesException_WhenFirebaseSendThrows() {
        var exception = new InvalidOperationException("firebase failed");
        var firebaseClient = new FakeFirebaseMessagingClient { SendException = exception };
        var logger = new TestLogger<FirebasePushMessagingService>();
        var service = new FirebasePushMessagingService(firebaseClient, logger);

        var thrown = await Assert.ThrowsAsync<InvalidOperationException>(() =>
            service.SendAsync(new Message { Topic = "test-topic" }));

        Assert.Same(exception, thrown);
        Assert.Empty(logger.Entries);
    }
}
