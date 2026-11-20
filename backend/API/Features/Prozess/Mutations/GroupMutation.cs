using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Mutations;

/// <summary>Ermöglicht das Zuordnen oder Entfernen einer Gruppe bei einem Prozess zur Steuerung der Sichtbarkeit in der App.</summary>
[MutationType]
public class UpdateGroupInProzessMutation {

    /// <summary>Setzt die Gruppenzuordnung eines Prozesses oder entfernt sie. Nur für berechtigte Backoffice-Nutzer.</summary>
    /// <param name="prozessId">Die Id des Prozesses, dessen Gruppenzuordnung geändert wird.</param>
    /// <param name="groupId">Die Id der Gruppe, die zugeordnet werden soll, oder null zum Entfernen.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <returns>Den aktualisierten Prozess mit der neuen Gruppenzuordnung.</returns>
    [Authorize]
    [GraphQLDescription("Ordnet einen Prozess einer Gruppe zu oder entfernt die Gruppenzuordnung. Steuert die Sichtbarkeit und Veröffentlichung des Prozesses in der App. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<UserFacingProzess> SetGroupToProzess(Guid prozessId, Guid? groupId, DomainContext db,
        CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozess = await db.UserFacingProzesse.AsTracking().FirstOrDefaultAsync(p => p.Id == prozessId);

        if (prozess == null) throw new Exception("Prozess not found!");

        if (user.KommuneId != prozess.KommuneId) throw new NotAllowedException();

        if (groupId == null) {
            prozess.GroupId = null;
        } else {
            var gruppe = await db.ProzessGroups.AsTracking()
                .FirstOrDefaultAsync(g => g.Id == groupId && g.KommuneId == prozess.KommuneId);
            if (gruppe == null) throw new Exception("Gruppe not found");
            prozess.Group = gruppe;
        }

        await db.SaveChangesAsync();
        return prozess;
    }
}
