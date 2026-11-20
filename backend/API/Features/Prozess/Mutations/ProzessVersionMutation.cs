using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using Npgsql;

namespace API.Features.Prozess.Mutations;

[MutationType]
public class ProzessVersionMutation {
    [Error(typeof(NotAllowedException))]
    [Error(typeof(ProzessVersionHasAusfuehrungen))]
    [Error(typeof(ProzessVersionIsLastPublished))]
    [Error(typeof(ProzessVersionIsCurrentVersion))]
    [Error(typeof(ProzessVersionNotFound))]
    [Authorize]
    [GraphQLDescription("Löscht eine Prozessversion, sofern ihr keine Ausführungen zugeordnet sind, sie nicht die letzte veröffentlichte Version neben verbleibenden Entwürfen ist und nicht die für Bürger:innen aktuell aktive Version. Ist es die letzte verbleibende Version überhaupt, wird der dann leere Prozess mitgelöscht. Nur für berechtigte Backoffice-Nutzer.")]
    public async Task<ProzessVersion> DeleteProzessVersion(
        DeleteProzessVersionInput deleteProzessVersionInput,
        DomainContext db,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (backofficeUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        // Prozessversionen fremder Kommunen sind absichtlich ununterscheidbar von nicht vorhandenen.
        var prozessVersion = await db.ProzessVersionen.AsTracking()
            .FirstOrDefaultAsync(pv =>
                pv.Id == deleteProzessVersionInput.Id && pv.Prozess.KommuneId == backofficeUser.KommuneId) ??
            throw new ProzessVersionNotFound();

        var hatAusfuehrungen = await db.Ausfuehrungen.AnyAsync(a => a.ProzessVersionId == prozessVersion.Id);
        if (hatAusfuehrungen) {
            throw new ProzessVersionHasAusfuehrungen();
        }

        var istLetzteVerbleibendeVersion = !await db.ProzessVersionen.AnyAsync(pv =>
            pv.ProzessId == prozessVersion.ProzessId && pv.Id != prozessVersion.Id);

        if (istLetzteVerbleibendeVersion) {
            var prozess = await db.Prozesse.AsTracking().FirstAsync(p => p.Id == prozessVersion.ProzessId);
            db.Remove(prozess);
        } else if (prozessVersion.PublishedAt != null) {
            var gibtAndereVeroeffentlichteVersion = await db.ProzessVersionen.AnyAsync(pv =>
                pv.ProzessId == prozessVersion.ProzessId && pv.Id != prozessVersion.Id && pv.PublishedAt != null);
            if (!gibtAndereVeroeffentlichteVersion) {
                throw new ProzessVersionIsLastPublished();
            }

            var gibtNeuereVeroeffentlichteVersion = await db.ProzessVersionen.AnyAsync(pv =>
                pv.ProzessId == prozessVersion.ProzessId && pv.Id != prozessVersion.Id &&
                pv.PublishedAt != null && pv.PublishedAt > prozessVersion.PublishedAt);
            if (!gibtNeuereVeroeffentlichteVersion) {
                throw new ProzessVersionIsCurrentVersion();
            }
        }

        var rollen = prozessVersion.Rollen.ToList();

        await using var transaction = await db.Database.BeginTransactionAsync();

        db.Remove(prozessVersion);

        try {
            await db.SaveChangesAsync();
        } catch (DbUpdateException e) when (IsAusfuehrungenForeignKeyViolation(e)) {
            throw new ProzessVersionHasAusfuehrungen();
        }

        db.ZustaendigkeitRollen.RemoveRange(rollen);
        await db.SaveChangesAsync();

        await transaction.CommitAsync();

        return prozessVersion;
    }

    private static bool IsAusfuehrungenForeignKeyViolation(DbUpdateException e) =>
        e.InnerException is PostgresException { SqlState: PostgresErrorCodes.ForeignKeyViolation, TableName: "Ausfuehrungen" };
}

public record DeleteProzessVersionInput(Guid Id);

public class ProzessVersionHasAusfuehrungen : Exception;

public class ProzessVersionIsLastPublished : Exception;

public class ProzessVersionIsCurrentVersion : Exception;

public class ProzessVersionNotFound : Exception;
