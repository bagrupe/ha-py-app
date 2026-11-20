using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation zum Bestätigen eines Passwort-Reset-Vorgangs. 
/// Überprüft den Reset-Code, aktualisiert das Passwort und setzt die zugehörigen Felder zurück.
/// </summary>
[MutationType]
public class ForgotPasswordConfirmMutation {
    /// <summary>
    /// Führt die Bestätigung eines Passwort-Resets durch. 
    /// Überprüft die Gültigkeit des Reset-Codes und aktualisiert die Benutzerdaten.
    /// </summary>
    /// <param name="input">Eingabedaten mit Reset-Code, neuem Passwort und Schlüsselinformationen.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf Benutzerdaten.</param>
    /// <param name="clock">Uhrzeit-Provider zur Validierung der Ablaufzeit des Reset-Codes.</param>
    /// <param name="passwordHasher">Service zum Hashen des neuen Passworts.</param>
    /// <param name="rateLimit">Rate-Limiting-Service zur Begrenzung der Anfragen.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Ein Payload mit dem Ergebnis der Passwort-Reset-Bestätigung.</returns>
    [AllowAnonymous]
    public async Task<ForgotPasswordConfirmPayload> ForgotPasswordConfirm(
        ForgotPasswordConfirmInput input, DomainContext domainContext,
        [Service] IClock clock,
        [Service] IPasswordHasher<User> passwordHasher,
        [Service] RateLimit rateLimit,
        CancellationToken ct
    ) {
        await rateLimit.Limit(ct, new RateLimit.IpLimit("ForgotPasswordConfirm", 2, TimeSpan.FromSeconds(5)));

        var now = clock.GetCurrentInstant();
        var backofficeUser = await domainContext.BackofficeUser.AsTracking().FirstOrDefaultAsync(u =>
            u.PasswordResetCode == input.PasswordResetCode && u.PasswordResetValidUntil > now, ct);

        if (backofficeUser is null) {
            return new ForgotPasswordConfirmPayload(PasswordConfirmationResult.InvalidCode);
        }

        if (backofficeUser.PasswordResetValidUntil < now) {
            return new ForgotPasswordConfirmPayload(PasswordConfirmationResult.CodeExpired);
        }

        backofficeUser.Password = passwordHasher.HashPassword(backofficeUser, input.Password);
        backofficeUser.PublicKey = input.PersonalPublicKey;
        backofficeUser.PersonalPrivateKeySalt = input.PersonalPrivateKeySalt;
        backofficeUser.PersonalPrivateKey = input.PersonalPrivateKey;

        backofficeUser.OrganisationPrivateKey = null;
        backofficeUser.PendingConfirmation = PendingConfirmationReason.PasswordReset;

        backofficeUser.PasswordResetCode = null;
        backofficeUser.PasswordResetValidUntil = null;

        await domainContext.SaveChangesAsync(ct);

        return new ForgotPasswordConfirmPayload(PasswordConfirmationResult.Success);
    }

    /// <summary>
    /// Eingabedaten für die Passwort-Reset-Bestätigung. 
    /// Enthält den Reset-Code, das neue Passwort und Schlüsselinformationen.
    /// </summary>
    /// <param name="PasswordResetCode">Eindeutiger Code zum Zurücksetzen des Passworts.</param>
    /// <param name="Password">Neues Passwort des Benutzers.</param>
    /// <param name="PersonalPublicKey">Öffentlicher Schlüssel des Benutzers.</param>
    /// <param name="PersonalPrivateKeySalt">Salt für den privaten Schlüssel des Benutzers.</param>
    /// <param name="PersonalPrivateKey">Verschlüsselter privater Schlüssel des Benutzers.</param>
    public record ForgotPasswordConfirmInput(
        Guid PasswordResetCode,
        string Password,
        string PersonalPublicKey,
        string PersonalPrivateKeySalt,
        EncryptedValue PersonalPrivateKey
    );

    /// <summary>
    /// Mögliche Ergebnisse der Passwort-Reset-Bestätigung.
    /// </summary>
    public enum PasswordConfirmationResult {
        Success,
        InvalidCode,
        CodeExpired
    }

    /// <summary>
    /// Rückgabedaten der Passwort-Reset-Bestätigung. 
    /// Enthält das Ergebnis der Operation.
    /// </summary>
    /// <param name="Result">Ergebnis der Passwort-Reset-Bestätigung.</param>
    public record ForgotPasswordConfirmPayload(PasswordConfirmationResult Result);
}
