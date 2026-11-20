using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation zum Zurücksetzen des Passworts eines Backoffice-Nutzers. 
/// Überprüft die aktuellen Anmeldedaten und aktualisiert das Passwort sowie zugehörige Schlüssel.
/// </summary>
[MutationType]
public class ResetPasswordMutation {
    /// <summary>
    /// Setzt das Passwort eines Backoffice-Nutzers zurück, nachdem die aktuellen Anmeldedaten überprüft wurden.
    /// </summary>
    /// <param name="input">Eingabedaten mit aktuellem und neuem Passwort sowie Schlüsselinformationen.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf Benutzerdaten.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Nutzers.</param>
    /// <param name="passwordHasher">Service zum Überprüfen und Hashen von Passwörtern.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Gibt true zurück, wenn das Zurücksetzen erfolgreich war, andernfalls false.</returns>
    [Authorize]
    public async Task<bool> ResetPassword(
        ResetPasswordInput input, DomainContext domainContext,
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] IPasswordHasher<User> passwordHasher,
        CancellationToken ct
    ) {
        var user = await currentUserAccessor.User();

        var backofficeUser = await domainContext.BackofficeUser.AsTracking().FirstOrDefaultAsync(u =>
            u.Id == user.Id, ct);

        if (backofficeUser is null) {
            return false;
        }

        if (backofficeUser.PendingConfirmation is not null) {
            return false;
        }

        var result = passwordHasher.VerifyHashedPassword(null!, backofficeUser.Password, input.CurrentPassword);
        if (result == PasswordVerificationResult.Failed) {
            return false;
        }

        backofficeUser.Password = passwordHasher.HashPassword(backofficeUser, input.NewPassword);
        backofficeUser.PublicKey = input.PersonalPublicKey;
        backofficeUser.PersonalPrivateKeySalt = input.PersonalPrivateKeySalt;
        backofficeUser.PersonalPrivateKey = input.PersonalPrivateKey;
        backofficeUser.OrganisationPrivateKey = input.OrganizationPrivateKey;

        backofficeUser.PasswordResetCode = null;
        backofficeUser.PasswordResetValidUntil = null;

        await domainContext.SaveChangesAsync(ct);

        return true;
    }

    /// <summary>
    /// Eingabedaten für die Passwort-Zurücksetzung. 
    /// Enthält das aktuelle Passwort, das neue Passwort und Schlüsselinformationen.
    /// </summary>
    /// <param name="CurrentPassword">Das aktuelle Passwort des Nutzers.</param>
    /// <param name="NewPassword">Das neue Passwort des Nutzers.</param>
    /// <param name="PersonalPublicKey">Der persönliche öffentliche Schlüssel des Nutzers.</param>
    /// <param name="PersonalPrivateKeySalt">Das Salt für den persönlichen privaten Schlüssel des Nutzers.</param>
    /// <param name="PersonalPrivateKey">Der verschlüsselte persönliche private Schlüssel des Nutzers.</param>
    /// <param name="OrganizationPrivateKey">Der verschlüsselte Organisationsschlüssel des Nutzers.</param>
    public record ResetPasswordInput(
        string CurrentPassword,
        string NewPassword,
        string PersonalPublicKey,
        string PersonalPrivateKeySalt,
        EncryptedValue PersonalPrivateKey,
        string OrganizationPrivateKey
    );
}
