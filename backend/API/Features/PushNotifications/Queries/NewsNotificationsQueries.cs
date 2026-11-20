using API.Features.Auth;
using Microsoft.EntityFrameworkCore;

namespace API.Features.PushNotifications.Queries;

/// <summary>Stellt Abfrageoperationen für News-Benachrichtigungen bereit.</summary>
[QueryType]
public class NewsNotificationsQueries {
}

/// <summary>Erweitert die Untereinheit um Abfragen zu News-Benachrichtigungen.</summary>
[ExtendObjectType<Untereinheit.Untereinheit>]
public class UntereinheitNewsNotificationsExtensions {
    /// <summary>Ermittelt, ob für die angegebene Untereinheit News-Benachrichtigungen für den aktuellen Benutzer aktiviert sind.</summary>
    /// <param name="untereinheit">Die Untereinheit, für die die Einstellung geprüft wird.</param>
    /// <param name="db">Datenbankkontext für Abfragen.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <returns>True, wenn News-Benachrichtigungen aktiviert sind, sonst false.</returns>
    public async Task<bool> NewsNotificationsEnabled([Parent] Untereinheit.Untereinheit untereinheit,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();
        return user is Buerger buerger && buerger.OrganisationseinheitIdsForNewsNotifications.Contains(untereinheit.Id);
    }
}
