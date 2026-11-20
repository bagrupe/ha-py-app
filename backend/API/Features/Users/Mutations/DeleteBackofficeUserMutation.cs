using API.Features.Auth;
using API.Features.BereichB;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Users.Mutations;

/// <summary>Mutation zum Löschen eines Backoffice-Nutzers.</summary>
[MutationType]
public class DeleteBackofficeUserMutation {

    /// <summary>Löscht einen Backoffice-Nutzer, sofern die Berechtigung vorliegt und der Nutzer existiert.</summary>
    /// <param name="domainContext">Datenbankkontext für die Persistenz.</param>
    /// <param name="userId">ID des zu löschenden Nutzers.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="synchronizer">Service zur Synchronisation der Nutzerdaten mit Bereich B.</param>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung asynchroner Operationen.</param>
    /// <returns>Den gelöschten Backoffice-Nutzer.</returns>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<BackofficeUser> BackofficeUserDelete(DomainContext domainContext, Guid userId,
            CurrentUserAccessor currentUserAccessor,
            [Service] BackofficeUserSynchronizer synchronizer,
            CancellationToken cancellationToken
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);

        var userToDelete = await domainContext.BackofficeUser.AsTracking()
            .Include(u => u.UntereinheitPermissions)
            .Where(u => u.Id == userId && !u.IsDeleted)
            .WhereSameOrganisationseinheit(actingUser)
            .FirstOrDefaultAsync(cancellationToken);

        if (userToDelete is null) throw new NotAllowedException("Nutzer konnte nicht gefunden werden.");

        berechtigungen.NutzerLoeschen(userToDelete).Fordern();

        userToDelete.IsDeleted = true;
        userToDelete.InvitationCode = null;
        userToDelete.InvitationValidUntil = null;
        userToDelete.PasswordResetCode = null;
        userToDelete.PasswordResetValidUntil = null;
        userToDelete.PendingConfirmation = null;

        await domainContext.SaveChangesAsync(cancellationToken);
        await synchronizer.Synchronize(userToDelete.Id);

        return userToDelete;
    }
}
