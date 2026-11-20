using API.Features.Auth;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Mutations;

/// <summary>Ermöglicht das Hinzufügen oder Entfernen einer Ausführung aus der Beobachtungsliste eines Bürgers.</summary>
[MutationType]
public class AusfuehrungFolgenMutation {
    /// <summary>Fügt eine Ausführung der Beobachtungsliste des aktuellen Bürgers hinzu oder entfernt sie daraus.</summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="ausfuehrungId">Die Id der Ausführung, die beobachtet oder nicht mehr beobachtet werden soll.</param>
    /// <param name="newFolgen">Gibt an, ob die Ausführung hinzugefügt (true) oder entfernt (false) werden soll.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken für asynchrone Operationen.</param>
    /// <returns>Den aktualisierten Bürger mit der geänderten Beobachtungsliste.</returns>
    [Authorize]
    [GraphQLDescription("Fügt einen Antrag (Ausführung) der persönlichen Beobachtungsliste eines Bürgers hinzu oder entfernt ihn daraus. Ermöglicht z.B. Benachrichtigungen bei Statusänderungen.")]
    public async Task<Buerger> AusfuehrungFolgen(CurrentUserAccessor currentUserAccessor, Guid ausfuehrungId, bool newFolgen,
        DomainContext db, CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger) throw new InvalidOperationException();

        var ausfuehrung = await db.Ausfuehrungen
            .OnlyPublic()
            .AsTracking()
            .FirstOrDefaultAsync(a => a.Id == ausfuehrungId, ct);

        if (ausfuehrung == null) throw new NotAllowedException();

        var trackedBuerger = await db.Buerger
            .AsTracking()
            .Include(b => b.GefolgteAusfuehrungen)
            .FirstAsync(b => b.Id == currentUserAccessor.UserId(), ct);

        if (newFolgen) {
            trackedBuerger.GefolgteAusfuehrungen.Add(ausfuehrung);
        } else {
            trackedBuerger.GefolgteAusfuehrungen.RemoveAll(a => a.Id == ausfuehrungId);
        }

        await db.SaveChangesAsync(ct);

        return trackedBuerger;
    }
}
