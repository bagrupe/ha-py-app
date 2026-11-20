using System.Collections.Immutable;
using API.Features.Email;
using API.Features.Email.Templates;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using API.Options;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation zum Bestätigen eines Nutzers.
/// Überprüft Berechtigungen und aktualisiert den Status des Nutzers.
/// </summary>
[MutationType]
public class ConfirmUserMutation {
    /// <summary>
    /// Bestätigt einen Nutzer, indem die ausstehende Bestätigung entfernt und der Organisationsschlüssel gesetzt wird.
    /// </summary>
    /// <param name="input">Eingabedaten mit der Nutzer-ID und dem Organisationsschlüssel.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf Nutzerdaten.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Nutzers.</param>
    /// <param name="emailService">Service zum Versenden von E-Mails.</param>
    /// <param name="webOptions">Web-Optionen mit der Basis-URL für den Login-Link in der E-Mail.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Gibt true zurück, wenn die Bestätigung erfolgreich war, andernfalls false.</returns>
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> UserConfirm(
        UserConfirmInput input, DomainContext domainContext,
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] EmailService emailService,
        [Service] WebOptions webOptions,
        CancellationToken ct
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);

        var userToConfirm = await domainContext
            .Mitarbeiter
            .AsSingleQuery()
            .AsTracking()
            .FirstOrDefaultAsync(u => u.Id == input.UserId, ct);

        if (userToConfirm is null or { PendingConfirmation: null }) {
            return false;
        }

        if (userToConfirm is BackofficeUser backofficeUserToConfirm) {
            berechtigungen.InAllenOrganisationseinheiten(
                backofficeUserToConfirm.UntereinheitPermissions.Select(up => up.UntereinheitId),
                FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung).Fordern();
            if (actingUser.Art != BackofficeNutzerArt.Superadmin) {
                var actingUserOrganisationseinheitIds = actingUser.UntereinheitPermissions.Select(p => p.UntereinheitId).ToImmutableHashSet();
                var userToConfirmOrganisationseinheitIds = backofficeUserToConfirm.UntereinheitPermissions
                    .Select(p => p.UntereinheitId).ToImmutableHashSet();
                if (!actingUserOrganisationseinheitIds.Overlaps(userToConfirmOrganisationseinheitIds)) {
                    throw new NotAllowedException("Sie können den Nutzer nicht bestätigen, weil Sie keine gemeinsame Organisationseinheit haben.");
                }
            }
        }

        userToConfirm.OrganisationPrivateKey = input.OrganizationPrivateKey;
        userToConfirm.PendingConfirmation = null;

        await domainContext.SaveChangesAsync(ct);

        await emailService.AddMailToOutboxAsync<AccountConfirmedEmail, AccountConfirmedEmailText>(
            recipientEmail: userToConfirm.EMail, subject: "Zugang bestätigt",
            templateParams: new Dictionary<string, object> {
                { nameof(AccountConfirmedEmail.LoginUrl), $"{webOptions.BaseUrl}/auth/login" },
            },
            kommuneId: userToConfirm.KommuneId,
            ct: ct
        );

        return true;
    }

    /// <summary>
    /// Eingabedaten für die Nutzerbestätigung.
    /// Enthält die Nutzer-ID und den Organisationsschlüssel.
    /// </summary>
    /// <param name="UserId">Die eindeutige ID des Nutzers.</param>
    /// <param name="OrganizationPrivateKey">Der private Schlüssel der Organisation.</param>
    public record UserConfirmInput(Guid UserId, string OrganizationPrivateKey);
}
