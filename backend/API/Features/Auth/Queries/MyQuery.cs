using HotChocolate.Authorization;

namespace API.Features.Auth.Queries;

/// <summary>
/// Stellt Abfragen im Zusammenhang mit Authentifizierung und Nutzerdaten bereit.
/// </summary>
[QueryType]
public class MyQuery {
    /// <summary>
    /// Ruft den aktuellen authentifizierten Nutzer ab.
    /// </summary>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Nutzers.</param>
    /// <returns>Der aktuell authentifizierte Nutzer.</returns>
    [Authorize]
    public async Task<User> My([Service] CurrentUserAccessor currentUserAccessor) {
        return await currentUserAccessor.User();
    }
}
