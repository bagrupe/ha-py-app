using API.Features;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

/// <summary>Enthält Mutationen zum Hinzufügen und Entfernen von Gruppen bei Mitarbeitern.</summary>
[MutationType]
public class UpdateDomainDataMutation {

    /// <summary>Fügt einem Mitarbeiter eine Gruppe hinzu.</summary>
    /// <param name="groupId">Die ID der hinzuzufügenden Gruppe.</param>
    /// <param name="mitarbeiterId">Die ID des Mitarbeiters.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <returns>Den aktualisierten Mitarbeiter mit der hinzugefügten Gruppe.</returns>
    [Authorize]
    public async Task<Mitarbeiter> AddGroupToMitarbeiter(Guid groupId, Guid mitarbeiterId, DomainContext db, CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);
        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung).Fordern();

        var mitarbeiter = await db.BackofficeUser.AsTracking().WhereSameOrganisationseinheit(user).FirstOrDefaultAsync(m => m.Id == mitarbeiterId);
        if (mitarbeiter == null) throw new Exception("Mitarbeiter not found");

        var gruppe = await db.MitarbeiterGruppen.AsTracking().FirstOrDefaultAsync(g => g.Id == groupId);
        if (gruppe == null) throw new Exception("Gruppe not found");

        mitarbeiter.Gruppen.Add(gruppe);

        await db.SaveChangesAsync();

        return mitarbeiter;
    }

    /// <summary>Entfernt eine Gruppe von einem Mitarbeiter.</summary>
    /// <param name="groupId">Die ID der zu entfernenden Gruppe.</param>
    /// <param name="mitarbeiterId">Die ID des Mitarbeiters.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <returns>Den aktualisierten Mitarbeiter ohne die entfernte Gruppe.</returns>
    [Authorize]
    public async Task<Mitarbeiter> RemoveGroupFromMitarbeiter(Guid groupId, Guid mitarbeiterId, DomainContext db, CurrentUserAccessor currentUserAccessor) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);
        var mitarbeiter = await db.BackofficeUser.WhereSameOrganisationseinheit(user).AsTracking().Include(u => u.Gruppen).FirstOrDefaultAsync(m => m.Id == mitarbeiterId);
        if (mitarbeiter == null) throw new Exception("Mitarbeiter not found!");

        var gruppe = await db.MitarbeiterGruppen.AsTracking().FirstOrDefaultAsync(g => g.Id == groupId);
        if (gruppe == null) throw new Exception("Gruppe not found");

        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung).Fordern();

        mitarbeiter.Gruppen.Remove(gruppe);
        await db.SaveChangesAsync();

        return mitarbeiter;

    }
}
