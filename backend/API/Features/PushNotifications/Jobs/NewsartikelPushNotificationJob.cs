using System.Globalization;
using API.Clients.BereichBClient;
using API.Features.PushNotifications;
using API.Infrastructure;
using API.Options;
using FirebaseAdmin.Messaging;
using Microsoft.Extensions.Options;
using NodaTime;
using Quartz;

namespace API.Features.PushNotifications.Jobs;

/// <summary>
/// Job zum Versenden von Push-Benachrichtigungen für neue Newsartikel.
/// </summary>
public class NewsartikelPushNotificationJob(
    IBereichBClient bereichBClient,
    IClock clock,
    ILogger<NewsartikelPushNotificationJob> logger,
    IOptions<EnvironmentOptions> environmentOptions,
    IFirebasePushMessagingService firebasePush
) : IJob {
    /// <summary>
    /// Führt den Job aus und sendet Push-Benachrichtigungen für noch nicht benachrichtigte Newsartikel.
    /// </summary>
    /// <param name="context">Kontext des ausgeführten Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        logger.LogInformation("Running");
        DateTimeZone berlinZone = DateTimeZoneProviders.Tzdb["Europe/Berlin"];
        var now = clock.GetCurrentInstant();
        ZonedDateTime berlinTime = now.InZone(berlinZone);
        var from = berlinTime.Date.AtStartOfDayInZone(berlinZone).ToInstant();
        var news = await bereichBClient.PublishedNewsArtikel.ExecuteAsync(from.ToString(), now.ToString());

        List<string> notifiedNewsIds = [];

        foreach (var article in news.Data?.UnnotifiedNewsArtikel ?? []) {
            if (article is not { Id: { } articleId, Kommune: { } mandant }) continue;

            ITopic topic = article.Untereinheit is not null
                ? new PushTopic.PublicNewsForOrganisationseinheit(environmentOptions.Value.Name,
                    Guid.Parse(article.Untereinheit.Id))
                : new PushTopic.PublicNewsForMandant(environmentOptions.Value.Name, Guid.Parse(mandant.BereichAId));

            var title = article.Untereinheit is not null
                ? $"{article.Untereinheit.Name} - {article.Titel}"
                : article.Titel;

            try {
                await firebasePush.SendAsync(new Message {
                    Topic = topic.ToString(),
                    Data = new Dictionary<string, string> { { "type", "newsartikel" }, { "id", article.Id } },
                    Notification = new Notification {
                        Title = title,
                        Body = article.Teaser,
                        ImageUrl = article.Titelbilder is [var first] ? first.Bild?.SourceUrl : null
                    },
                });

                notifiedNewsIds.Add(articleId);
            } catch (Exception e) {
                failures.RecordFailure();
                logger.LogError(e, "Failed to send push notification for article: {}, will retry in next run",
                    article.Id);
            }
        }

        try {
            await bereichBClient.SetNewsArtikelNotified.ExecuteAsync(notifiedNewsIds);
        } catch (Exception e) {
            failures.RecordFailure();
            logger.LogError(e, "Failed to set news articles as notified, this may result in duplicate notifications!");
        }
    }
}

/// <summary>
/// Erweiterungsmethoden zur Registrierung des Newsartikel-Push-Notification-Jobs im DI-Container.
/// </summary>
public static class NewsartikelPushNotificationJobExtensions {
    /// <summary>
    /// Registriert den Newsartikel-Push-Notification-Job mit einem Intervall von 30 Sekunden und sofortigem Start.
    /// </summary>
    /// <param name="services">Die Service-Sammlung zur Registrierung.</param>
    /// <returns>Die erweiterte Service-Sammlung.</returns>
    public static IServiceCollection AddNewsArtikelPushNotificationJob(this IServiceCollection services) {
        const string everyThirtySeconds = "0/30 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz =>
                quartz.ScheduleJob<NewsartikelPushNotificationJob>(everyThirtySeconds, fireImmediate: true));

        return services;
    }
}
