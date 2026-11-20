using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Prozess.Mutations;

/// <summary>Stellt eine Mutation zum Veröffentlichen einer Prozessversion bereit.</summary>
[MutationType]
public class ProzessVersionVeroeffentlichenMutation {

    /// <summary>Veröffentlicht eine Prozessversion, sodass sie für Anträge verwendet werden kann.</summary>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="prozessVersionId">Die Id der zu veröffentlichenden Prozessversion.</param>
    /// <param name="clock">Die Systemuhr zur Ermittlung des aktuellen Zeitpunkts.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Die veröffentlichte Prozessversion.</returns>
    [Authorize]
    [GraphQLDescription("Veröffentlicht eine erstellte Prozessversion. Erst nach Veröffentlichung ist die Version für Anträge nutzbar.")]
    public async Task<ProzessVersion> ProzessVersionVeroeffentlichen(DomainContext db,
        Guid prozessVersionId,
        [Service] IClock clock,
        [Service] CurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var (backofficeUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        // Versionen fremder Kommunen sind absichtlich ununterscheidbar von nicht vorhandenen.
        var prozessVersion = await db.ProzessVersionen.AsTracking()
            .Where(pv => pv.Id == prozessVersionId && pv.PublishedAt == null
                         && pv.Prozess.KommuneId == backofficeUser.KommuneId)
            .FirstOrDefaultAsync(ct);

        if (prozessVersion is null) {
            throw new ArgumentException(nameof(prozessVersionId));
        }

        prozessVersion.PublishedAt = clock.GetCurrentInstant();
        await db.SaveChangesAsync(ct);

        return prozessVersion;
    }
}
