using API.Features.Auth;
using API.Features.PushNotifications;
using API.Infrastructure;
using API.Options;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace API.Features.PushNotifications.Mutations;

/// <summary>Mutation zum Aktualisieren der Benachrichtigungseinstellungen für News einer Organisationseinheit.</summary>
[MutationType]
public class NewsNotificationsMutation {
    /// <summary>Aktualisiert die Push-Benachrichtigungspräferenzen eines Bürgers für eine bestimmte Organisationseinheit.</summary>
    /// <param name="db">Datenbankkontext für Persistenzoperationen.</param>
    /// <param name="environmentOptions">Umgebungsoptionen mit Konfigurationsdaten.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="organisationseinheitId">ID der Organisationseinheit, für die die Benachrichtigungen geändert werden.</param>
    /// <param name="notificationsEnabled">Gibt an, ob Benachrichtigungen aktiviert oder deaktiviert werden sollen.</param>
    /// <returns>True, wenn die Einstellungen erfolgreich aktualisiert wurden, sonst false.</returns>
    [Error(typeof(OrganisationseinheitNotFoundException))]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> UpdateNewsNotificationsPreferences(
        DomainContext db,
        [Service] IOptions<EnvironmentOptions> environmentOptions,
        CurrentUserAccessor currentUserAccessor,
        [Service] IFirebasePushMessagingService firebasePush,
        Guid organisationseinheitId,
        bool notificationsEnabled
    ) {
        var user = await currentUserAccessor.User();

        if (user is not Buerger buerger) throw new NotAllowedException();

        var trackedBuerger = await db.Buerger
            .AsTracking()
            .FirstAsync(b => b.Id == currentUserAccessor.UserId());

        var organisationseinheit = await db.Untereinheit
            .Where(u => u.Id == organisationseinheitId)
            .FirstOrDefaultAsync() ?? throw new OrganisationseinheitNotFoundException();

        if (buerger.PushNotificationTokens.Count == 0) {
            return false;
        }

        if (!notificationsEnabled) {
            await firebasePush.UnsubscribeFromTopicAsync(buerger.PushNotificationTokens,
                new PushTopic.PublicNewsForOrganisationseinheit(environmentOptions.Value.Name, organisationseinheit.Id)
                    .ToString());
            trackedBuerger.OrganisationseinheitIdsForNewsNotifications.Remove(organisationseinheit.Id);
        } else {
            await firebasePush.SubscribeToTopicAsync(buerger.PushNotificationTokens,
                new PushTopic.PublicNewsForOrganisationseinheit(environmentOptions.Value.Name, organisationseinheit.Id)
                    .ToString());
            trackedBuerger.OrganisationseinheitIdsForNewsNotifications.Add(organisationseinheit.Id);
        }

        await db.SaveChangesAsync();

        return true;
    }

    private class OrganisationseinheitNotFoundException : Exception;
}
