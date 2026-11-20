using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Mutations;

/// <summary>Stellt Mutationen zur Verwaltung von Prozessgruppen bereit.</summary>
[MutationType]
public class ProzessGroupMutation {
    /// <summary>Aktualisiert den Namen einer bestehenden Prozessgruppe. Erfordert Backoffice-Berechtigung.</summary>
    /// <param name="updateProzessGroupInput">Eingabedaten mit Id und neuem Namen der Prozessgruppe.</param>
    /// <param name="db">Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Die aktualisierte Prozessgruppe.</returns>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    [GraphQLDescription("Aktualisiert den Namen einer bestehenden Prozessgruppe. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<ProzessGroup> UpdateProzessGroup(
        UpdateProzessGroupInput updateProzessGroupInput,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozessGroup =
            await db.ProzessGroups.AsTracking().FirstOrDefaultAsync(pg => pg.Id == updateProzessGroupInput.Id) ??
            throw new Exception("Prozess Group not found");

        if (user.KommuneId != prozessGroup.KommuneId) throw new InvalidOperationException();

        prozessGroup.Name = updateProzessGroupInput.Name;
        await db.SaveChangesAsync();

        return prozessGroup;
    }

    /// <summary>Löscht eine Prozessgruppe, wenn sie nicht von einem Prozess verwendet wird. Erfordert Backoffice-Berechtigung.</summary>
    /// <param name="deleteProzessGroupInput">Eingabedaten mit Id der zu löschenden Prozessgruppe.</param>
    /// <param name="db">Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Die gelöschte Prozessgruppe.</returns>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(ProzessGroupAssignedToProzess))]
    [Error(typeof(ProzessGroupNotFound))]
    [Authorize]
    [GraphQLDescription("Löscht eine Prozessgruppe, sofern sie nicht mehr von einem Prozess verwendet wird. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<ProzessGroup> DeleteProzessGroup(
        DeleteProzessGroupInput deleteProzessGroupInput,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozessGroupIsAssignedToProzess = await db.Prozesse.AnyAsync(prozess =>
            prozess.Group != null && prozess.Group.Id == deleteProzessGroupInput.Id);
        if (prozessGroupIsAssignedToProzess) {
            throw new ProzessGroupAssignedToProzess();
        }

        var prozessGroup =
            await db.ProzessGroups.AsTracking().FirstOrDefaultAsync(pg => pg.Id == deleteProzessGroupInput.Id) ??
            throw new ProzessGroupNotFound();

        if (user.KommuneId != prozessGroup.KommuneId) throw new InvalidOperationException();

        db.Remove(prozessGroup);
        await db.SaveChangesAsync();

        return prozessGroup;
    }

    /// <summary>Legt eine neue Prozessgruppe an. Erfordert Backoffice-Berechtigung.</summary>
    /// <param name="addProzessGroupInput">Eingabedaten mit Namen der neuen Prozessgruppe.</param>
    /// <param name="db">Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Die neu angelegte Prozessgruppe.</returns>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    [GraphQLDescription("Legt eine neue Prozessgruppe an.")]
    public async Task<ProzessGroup> AddProzessGroup(
        AddProzessGroupInput addProzessGroupInput,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozessGroup = new ProzessGroup { Name = addProzessGroupInput.Name, KommuneId = user.KommuneId, };

        db.ProzessGroups.Add(prozessGroup);

        await db.SaveChangesAsync();

        return prozessGroup;
    }
}

/// <summary>Eingabedaten zum Aktualisieren einer Prozessgruppe.</summary>
/// <param name="Id">Id der Prozessgruppe.</param>
/// <param name="Name">Neuer Name der Prozessgruppe.</param>
public record UpdateProzessGroupInput(Guid Id, String Name);

/// <summary>Eingabedaten zum Anlegen einer neuen Prozessgruppe.</summary>
/// <param name="Name">Name der neuen Prozessgruppe.</param>
public record AddProzessGroupInput(String Name);

/// <summary>Eingabedaten zum Löschen einer Prozessgruppe.</summary>
/// <param name="Id">Id der zu löschenden Prozessgruppe.</param>
public record DeleteProzessGroupInput(Guid Id);

/// <summary>Fehler, wenn eine Prozessgruppe noch von einem Prozess verwendet wird.</summary>
public class ProzessGroupAssignedToProzess : Exception;

/// <summary>Fehler, wenn eine Prozessgruppe nicht gefunden wurde.</summary>
public class ProzessGroupNotFound : Exception;
