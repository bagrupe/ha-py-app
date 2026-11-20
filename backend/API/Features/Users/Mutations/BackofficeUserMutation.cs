using System.Collections.Immutable;
using API.Features.Auth;
using API.Features.BereichB;
using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit.Mutations;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Users.Mutations;

/// <summary>
/// Mutation für Operationen an Backoffice-Nutzern.
/// </summary>
[MutationType]
public class BackofficeUserMutation {
    /// <summary>
    /// Aktualisiert einen Backoffice-Nutzer mit neuen Berechtigungen, Organisationseinheiten und Gruppen.
    /// </summary>
    /// <param name="domainContext">Datenbankkontext für Domänenoperationen.</param>
    /// <param name="backofficeUserId">ID des zu aktualisierenden Nutzers.</param>
    /// <param name="funktionsberechtigungen">Globale Funktionsberechtigungen des Nutzers.</param>
    /// <param name="organisationseinheiten">Liste der Organisationseinheiten mit zugehörigen Berechtigungen.</param>
    /// <param name="assignedGroups">Liste der zugewiesenen Gruppen-IDs.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="synchronizer">Service zur Synchronisation der Nutzerdaten.</param>
    /// <param name="funktionsberechtigungenService">Service zur Verwaltung der Funktionsberechtigungen.</param>
    /// <param name="cancellationToken">Token zur Abbruchsteuerung asynchroner Operationen.</param>
    /// <returns>Den aktuell handelnden Nutzer nach der Aktualisierung.</returns>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<BackofficeUser> BackofficeUserUpdate(
        DomainContext domainContext,
        Guid backofficeUserId,
        HashSet<GlobaleFunktionsberechtigung> funktionsberechtigungen,
        List<BackofficeUserOrganisationseinheit> organisationseinheiten,
        List<Guid> assignedGroups,
        CurrentUserAccessor currentUserAccessor,
        [Service] BackofficeUserSynchronizer synchronizer,
        [Service] FunktionsberechtigungenService funktionsberechtigungenService,
        CancellationToken cancellationToken
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);
        var userToUpdate =
            await domainContext.BackofficeUser.AsTracking()
                .Include(bo => bo.Gruppen)
                .Include(bo => bo.UntereinheitPermissions)
                .AsSingleQuery()
                .WhereSameOrganisationseinheit(actingUser)
                .FirstOrDefaultAsync(user =>
                    user.Id == backofficeUserId, cancellationToken: cancellationToken);

        if (userToUpdate is null) throw new UserNotFound();

        var isGroupInputValid = await domainContext.MitarbeiterGruppen
            .Where(mg => assignedGroups.Contains(mg.Id))
            .AllAsync(mg => mg.KommuneId == actingUser.KommuneId, cancellationToken: cancellationToken);

        if (!isGroupInputValid) throw new GroupInputInvalid();

        berechtigungen.NutzerBearbeiten(userToUpdate).Fordern();

        var requestedOrganisationseinheitIds = organisationseinheiten
            .Where(oe => oe.Zugehoerig)
            .Select(oe => oe.OrganisationseinheitId).ToHashSet();

        var ids = requestedOrganisationseinheitIds;

        requestedOrganisationseinheitIds = await domainContext.Untereinheit
            .WhereOwnMandant(actingUser)
            .Where(oe => ids.Contains(oe.Id))
            .Select(oe => oe.Id)
            .ToHashSetAsync(cancellationToken);

        var actingUserOrganisationseinheitIds = actingUser.UntereinheitPermissions
            .Where(p => p.Funktionsberechtigungen.Contains(FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung))
            .Select(p => p.UntereinheitId).ToImmutableHashSet();
        var currentOrganisationseinheitIds =
            userToUpdate.UntereinheitPermissions.Select(p => p.UntereinheitId).ToImmutableHashSet();
        var addedOrganisationseinheitIds = requestedOrganisationseinheitIds
            .Except(currentOrganisationseinheitIds).ToImmutableHashSet();
        var removedOrganisationseinheitIds =
            currentOrganisationseinheitIds.Except(requestedOrganisationseinheitIds).ToHashSet();
        var modifiedFunktionsberechtigungIds = organisationseinheiten
            .Where(p => !userToUpdate.UntereinheitPermissions.Any(p.Equals))
            .Select(p => p.OrganisationseinheitId)
            .ToImmutableHashSet();

        if (userToUpdate.Art == BackofficeNutzerArt.Dienstleister) {
            if (!funktionsberechtigungen.SetEquals(userToUpdate.Funktionsberechtigungen)) {
                throw new NotAllowedException(
                    "Ein Dienstleister kann keine globalen Funktionsberechtigungen haben.");
            }

            if (addedOrganisationseinheitIds.Any() || modifiedFunktionsberechtigungIds.Any() || removedOrganisationseinheitIds.Any()) {
                throw new NotAllowedException(
                    "Ein Dienstleister kann nicht manuell einer Organisationseinheit zugewiesen werden.");
            }
        }

        if (actingUser.Art != BackofficeNutzerArt.Superadmin) {
            if (!funktionsberechtigungen.SetEquals(userToUpdate.Funktionsberechtigungen)) {
                throw new NotAllowedException(
                    "Globale Funktionsberechtigungen können nur von einem Superadmin verändert werden.");
            }


            if (!actingUserOrganisationseinheitIds.IsSupersetOf(removedOrganisationseinheitIds)) {
                throw new NotAllowedException(
                    "Sie dürfen die Zuordnung zu einer Organisationseinheit nur entfernen, wenn Sie in dieser " +
                    "Organisationseinheit zur Nutzerverwaltung berechtigt sind.");
            }

            if (!actingUserOrganisationseinheitIds.IsSupersetOf(addedOrganisationseinheitIds)) {
                throw new NotAllowedException(
                    "Sie dürfen einem Nutzer nur dann eine Organisationseinheit zuweisen, wenn Sie in dieser " +
                    "Organisationseinheit zur Nutzerverwaltung berechtigt sind.");
            }

            if (!actingUserOrganisationseinheitIds.IsSupersetOf(modifiedFunktionsberechtigungIds)) {
                throw new NotAllowedException(
                    "Sie dürfen die Funktionsberechtigungen eines Nutzers nur verändern, wenn Sie in der " +
                    "entsprechenden Organisationseinheit zur Nutzerverwaltung berechtigt sind.");
            }
        }

        funktionsberechtigungenService.SetGlobaleFunktionsberechtigungenForUser(userToUpdate, funktionsberechtigungen);
        funktionsberechtigungenService.SetOrganisationseinheitenForUser(userToUpdate, organisationseinheiten);
        userToUpdate.Gruppen = await domainContext.MitarbeiterGruppen
            .AsTracking()
            .Where(g => assignedGroups.Contains(g.Id))
            .ToListAsync(cancellationToken: cancellationToken);

        await domainContext.SaveChangesAsync(cancellationToken);
        await synchronizer.Synchronize(userToUpdate.Id);
        return actingUser;
    }

    /// <summary>
    /// Ausnahme für ungültige Gruppeneingaben.
    /// </summary>
    private class GroupInputInvalid : Exception;

    /// <summary>
    /// Ausnahme, wenn ein Nutzer nicht gefunden wird.
    /// </summary>
    private class UserNotFound : Exception;
}
