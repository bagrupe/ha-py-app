using API.Features.Auth.Queries;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.BundId;

/// <summary>
/// GraphQL-Erweiterungen für <see cref="Buerger"/> rund um die BundID-Verknüpfung.
/// </summary>
[ExtendObjectType<Buerger>]
public class BuergerExtensions {
    /// <summary>
    /// Ob der Bürger dauerhaft mit einer BundID verknüpft ist, wenn der Bürger mit dem aktuellen
    /// Benutzer übereinstimmt. Wenn ja, sind Vorname/Nachname/EmailAddress/Street/PostalCode/
    /// City/Country schreibgeschützt (siehe <c>UpdateMyProfileMutation</c>) — sie werden
    /// ausschließlich bei der BundID-Anmeldung synchronisiert (siehe
    /// <see cref="BundIdAuthService"/>), Änderungen müssen direkt im BundID-Konto erfolgen.
    /// Self-Check aus demselben Grund wie bei <see cref="Queries.BuergerQueryExtensions.Vorname"/>:
    /// ohne ihn wäre das Feld über jedes andere Vorkommen von <see cref="User"/> im Schema
    /// erreichbar (z.B. <c>Ausfuehrung.User</c>) und würde damit jedem Sachbearbeiter mit Zugriff
    /// auf die jeweilige Ausführung verraten, ob das SMS-Kollisions-Gate für diesen Bürger greift.
    /// </summary>
    public async Task<bool> HasBundId(
        [Parent] Buerger buerger, DomainContext domainContext, CurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return await domainContext.ExternalIdentities
            .AnyAsync(e => e.BuergerId == buerger.Id && e.Provider == "bundid", ct);
    }

    public async Task<bool> HasKeyEscrow(
        [Parent] Buerger buerger, [Service] KeyEscrow.KeyEscrowService keyEscrowService,
        CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return await keyEscrowService.ExistsAsync(buerger.Id, ct);
    }
}
