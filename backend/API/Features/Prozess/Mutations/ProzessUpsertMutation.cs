using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess.Queries;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Prozess.Mutations;

/// <summary>Stellt eine Mutation zum Erstellen oder Aktualisieren eines Prozesses bereit.</summary>
[MutationType]
public class ProzessUpsertMutation {
    /// <summary>Erstellt einen neuen Prozess oder aktualisiert einen bestehenden anhand des Namens und optionaler Id.</summary>
    /// <param name="name">Der Name des Prozesses.</param>
    /// <param name="id">Die optionale Id des bestehenden Prozesses.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="userAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Den erstellten oder aktualisierten Prozess.</returns>
    [Authorize]
    [GraphQLDescription("Erstellt einen neuen Prozess oder aktualisiert einen bestehenden.")]
    public async Task<Prozess>
        ProzessUpsert(string name, Guid? id, DomainContext db, CurrentUserAccessor userAccessor) {
        var (backofficeUser, berechtigungen) = await userAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozess = id.HasValue switch {
            true => await db.Prozesse.AsTracking()
                .FirstOrDefaultAsync(l => l.KommuneId == backofficeUser.KommuneId && l.Id == id.Value),
            false => new Prozess { Name = name, KommuneId = backofficeUser.KommuneId }
        };

        if (prozess is null) throw new ProzessNotFound();

        prozess.Name = name;

        if (!id.HasValue) db.Prozesse.Add(prozess);

        await db.SaveChangesAsync();

        return prozess;
    }

    [Error(typeof(NotAllowedException))]
    [Error(typeof(ProzessHasVersionen))]
    [Error(typeof(ProzessNotFound))]
    [Authorize]
    [GraphQLDescription("Löscht einen Prozess ohne jede Version. Prozesse mit mindestens einer Version müssen über das Löschen einzelner Versionen entfernt werden. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<Prozess> DeleteProzess(
        DeleteProzessInput deleteProzessInput, DomainContext db, CurrentUserAccessor userAccessor
    ) {
        var (backofficeUser, berechtigungen) = await userAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        // Prozesse fremder Kommunen sind absichtlich ununterscheidbar von nicht vorhandenen.
        var prozess = await db.Prozesse.AsTracking()
            .FirstOrDefaultAsync(p => p.Id == deleteProzessInput.Id && p.KommuneId == backofficeUser.KommuneId) ??
            throw new ProzessNotFound();

        var hatVersionen = await db.ProzessVersionen.AnyAsync(pv => pv.ProzessId == prozess.Id);
        if (hatVersionen) {
            throw new ProzessHasVersionen();
        }

        db.Remove(prozess);
        await db.SaveChangesAsync();

        return prozess;
    }

    [Error(typeof(NotAllowedException))]
    [Error(typeof(ProzessNotFound))]
    [Authorize]
    [GraphQLDescription("Deaktiviert einen Prozess: Bürger:innen können danach keine neuen Anträge mehr für diesen Prozess starten und er verschwindet aus der App. Bestehende Anträge sind davon nicht betroffen. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<Prozess> ProzessDeaktivieren(
        ProzessDeaktivierenInput input, DomainContext db, CurrentUserAccessor userAccessor, IClock clock
    ) {
        var (backofficeUser, berechtigungen) = await userAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozess = await db.Prozesse.AsTracking()
            .FirstOrDefaultAsync(p => p.Id == input.Id && p.KommuneId == backofficeUser.KommuneId) ??
            throw new ProzessNotFound();

        prozess.DeaktiviertAm ??= clock.GetCurrentInstant();
        await db.SaveChangesAsync();

        return prozess;
    }

    [Error(typeof(NotAllowedException))]
    [Error(typeof(ProzessNotFound))]
    [Authorize]
    [GraphQLDescription("Aktiviert einen zuvor deaktivierten Prozess wieder. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<Prozess> ProzessAktivieren(
        ProzessAktivierenInput input, DomainContext db, CurrentUserAccessor userAccessor
    ) {
        var (backofficeUser, berechtigungen) = await userAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var prozess = await db.Prozesse.AsTracking()
            .FirstOrDefaultAsync(p => p.Id == input.Id && p.KommuneId == backofficeUser.KommuneId) ??
            throw new ProzessNotFound();

        prozess.DeaktiviertAm = null;
        await db.SaveChangesAsync();

        return prozess;
    }
}

public record DeleteProzessInput(Guid Id);
public record ProzessDeaktivierenInput(Guid Id);
public record ProzessAktivierenInput(Guid Id);

public class ProzessHasVersionen : Exception;
