using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation zum Initiieren eines Passwort-Reset-Vorgangs. 
/// Überprüft die E-Mail-Adresse und generiert einen Reset-Code, falls der Benutzer existiert.
/// </summary>
[MutationType]
public class ForgotPasswordMutation {

    /// <summary>
    /// Startet den Prozess zum Zurücksetzen des Passworts. 
    /// Überprüft die E-Mail-Adresse und erstellt einen Reset-Code, wenn der Benutzer gültig ist.
    /// </summary>
    /// <param name="input">Eingabedaten mit der E-Mail-Adresse des Benutzers.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf Benutzerdaten.</param>
    /// <param name="rateLimit">Rate-Limiting-Service zur Begrenzung der Anfragen.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Gibt true zurück, wenn der Vorgang erfolgreich initiiert wurde.</returns>
    [AllowAnonymous]
    public async Task<bool> ForgotPassword(
        ForgotPasswordInput input, DomainContext domainContext,
        [Service] RateLimit rateLimit,
        CancellationToken ct
        ) {
        await rateLimit.Limit(ct, new RateLimit.IpLimit("ForgotPassword", 1, TimeSpan.FromSeconds(30)));
        var backofficeUser = await domainContext.BackofficeUser
            .AsTracking()
            .FirstOrDefaultAsync(u => EF.Functions.ILike(u.EMail, input.Email), cancellationToken: ct);

        if (backofficeUser is null or { IsDeleted: true } or { InvitationCode: not null }) {
            return true;
        }

        backofficeUser.PasswordResetCode = Guid.NewGuid();
        backofficeUser.PasswordResetValidUntil = null;

        await domainContext.SaveChangesAsync(ct);

        return true;
    }

    /// <summary>
    /// Eingabedaten für die Passwort-Reset-Mutation. 
    /// Enthält die E-Mail-Adresse des Benutzers.
    /// </summary>
    /// <param name="Email">E-Mail-Adresse des Benutzers.</param>
    public record ForgotPasswordInput(string Email);
}
