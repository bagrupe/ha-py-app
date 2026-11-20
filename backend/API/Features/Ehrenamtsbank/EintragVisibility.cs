using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank;

/// <summary>Who may see an Ehrenamtsbank-Eintrag, resolved from the user id alone.</summary>
/// <remarks>Reads <see cref="DomainContext"/> directly instead of <see cref="CurrentUserAccessor"/> so it also works
/// outside GraphQL, e.g. in <see cref="EhrenamtsbankEintragImageStorageConsumer"/>.</remarks>
public static class EintragVisibility {
    /// <summary>Active entries are public; other statuses are visible only to the owner, to anyone who has made an
    /// Anfrage on them, and to moderators. Deleted entries are never visible.</summary>
    public static async Task<bool> CanViewAsync(
        DomainContext db, EhrenamtsbankEintrag eintrag, Guid? userId, CancellationToken ct) {
        if (eintrag.IsDeleted) {
            return false;
        }

        if (eintrag.Status == EhrenamtsbankEintragStatus.Active) {
            return true;
        }

        if (userId is not { } id) {
            return false;
        }

        return eintrag.OwnerId == id
            || await db.EhrenamtsbankAnfragen.AnyAsync(a => a.EintragId == eintrag.Id && a.InteressentId == id, ct)
            || await IsModeratorAsync(db, id, ct);
    }

    /// <summary>Whether the user is a backoffice user with the global Funktionsberechtigung Ehrenamtsbank.</summary>
    public static async Task<bool> IsModeratorAsync(DomainContext db, Guid userId, CancellationToken ct) {
        var user = await db.BackofficeUser
            .FirstOrDefaultAsync(u => u.Id == userId && !u.IsDeleted && u.OrganisationPrivateKey != null, ct);
        return user is not null
            && BackofficeNutzerArt.Dienstleister.ErfuelltDurch(user.Art)
            && new BackofficeUserFunktionsberechtigungenHelpers(user, []).Global(GlobaleFunktionsberechtigung.Ehrenamtsbank);
    }

    /// <summary>Whether the user is a registered Bürger, the precondition for creating Einträge.</summary>
    public static Task<bool> IsRegisteredBuergerAsync(DomainContext db, Guid userId, CancellationToken ct) =>
        db.Buerger.AnyAsync(b => b.Id == userId && b.IsRegistered, ct);
}
