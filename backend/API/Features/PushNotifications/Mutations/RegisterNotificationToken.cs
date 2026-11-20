using API.Features.Auth;
using API.Features.PushNotifications;
using API.Infrastructure;
using API.Options;
using API.Utils;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace API.Features.PushNotifications.Mutations;

/// <summary>Mutation zum Registrieren eines Push-Benachrichtigungstokens für einen Bürger.</summary>
[MutationType]
public class RegisterNotificationToken {
    /// <summary>Registriert ein neues Push-Benachrichtigungstoken für den aktuell angemeldeten Bürger und verwaltet die Themenzuordnung.</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="db">Datenbankkontext für Persistenzoperationen.</param>
    /// <param name="environmentOptions">Umgebungsoptionen mit Konfigurationsdaten.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <param name="kommuneId">ID der Kommune, für die das Token registriert wird.</param>
    /// <param name="token">Das zu registrierende Push-Benachrichtigungstoken.</param>
    /// <returns>Den aktualisierten Bürger mit dem registrierten Token.</returns>
    [Error(typeof(KommuneNotFoundException))]
    [Authorize]
    public async Task<Buerger> NotificationTokenRegister(CurrentUserAccessor currentUserAccessor, DomainContext db,
        [Service] IOptions<EnvironmentOptions> environmentOptions,
        [Service] IFirebasePushMessagingService firebasePush,
        CancellationToken ct,
        Guid kommuneId,
        string token) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger) throw new NotAllowedException("Only a Buerger may register for push notifications");

        var buergerId = currentUserAccessor.UserId();
        var trackedBuerger = await db.Buerger.AsTracking().FirstAsync(b => b.Id == buergerId, ct);
        var kommune = await db.Kommunen.FirstOrDefaultAsync(k => k.Id == kommuneId, ct);

        if (kommune == null) {
            throw new KommuneNotFoundException();
        }

        var kommuneTopic = new PushTopic.PublicNewsForMandant(environmentOptions.Value.Name, kommune.Id).ToString();

        foreach (var oldToken in trackedBuerger.PushNotificationTokens) {
            await firebasePush.UnsubscribeFromTopicAsync([oldToken], kommuneTopic);
        }

        // For now a Buerger can only log in with one device (ever), so we replace the push token instead of adding it.
        // Uses a scoped ExecuteUpdateAsync (touches only this column in SQL) instead of loading the full entity into
        // this request's own DbContext and calling SaveChangesAsync on it — that pattern raced with concurrent
        // writes to the same Buerger row from other requests (e.g. BundIdAuthService syncing profile data on every
        // login), where this request's stale in-memory snapshot of unrelated fields got written back and clobbered
        // the other request's just-saved changes.
        var newTokens = new List<string> { token };
        await db.Buerger.Where(b => b.Id == buergerId)
            .ExecuteUpdateAsync(s => s.SetProperty(b => b.PushNotificationTokens, newTokens), ct);
        trackedBuerger.PushNotificationTokens = newTokens;

        await firebasePush.SubscribeToTopicAsync([token], kommuneTopic);

        return trackedBuerger;
    }
}
