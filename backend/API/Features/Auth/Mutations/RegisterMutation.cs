using HotChocolate.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation zum Registrieren von Benutzern, einschließlich Bürger und Backoffice-Nutzer.
/// </summary>
[MutationType]
public class RegisterMutation {
    /// <summary>
    /// Registriert einen Bürger mit schwachem Login. Erstellt einen neuen Bürgerdatensatz und speichert ihn in der Datenbank.
    /// </summary>
    /// <param name="db">Datenbankkontext für den Zugriff auf Bürgerdaten.</param>
    /// <param name="passwordHasher">Service zum Hashen des abgeleiteten Passworts.</param>
    /// <param name="derivedPassword">Das abgeleitete Passwort des Bürgers.</param>
    /// <param name="publicKey">Der öffentliche Schlüssel des Bürgers.</param>
    /// <param name="encryptedPrivateKey">Der verschlüsselte private Schlüssel des Bürgers.</param>
    /// <param name="personalDataKeyForBuerger">Der persönliche Datenverschlüsselungsschlüssel des Bürgers.</param>
    /// <param name="salt">Das Salt für den privaten Schlüssel des Bürgers.</param>
    /// <returns>Die eindeutige ID des registrierten Bürgers.</returns>
    [UseMutationConvention(PayloadFieldName = "buergerId")]
    [AllowAnonymous]
    public async Task<Guid> RegisterBuergerWeak(DomainContext db,
        [Service] IPasswordHasher<User> passwordHasher,
        [Service] IClock clock,
        string derivedPassword,
        string publicKey,
        EncryptedValue encryptedPrivateKey,
        string personalDataKeyForBuerger,
        string salt
    ) {
        var buerger = WeakBuergerRegistration.Create(passwordHasher, clock, new WeakLoginCredentials(
            derivedPassword, publicKey, encryptedPrivateKey, personalDataKeyForBuerger, salt));

        db.Buerger.Add(buerger);
        await db.SaveChangesAsync();

        return buerger.Id;
    }

    /// <summary>
    /// Registriert einen Backoffice-Nutzer basierend auf einem Einladungscode. Aktualisiert die Benutzerdaten und setzt den Einladungscode zurück.
    /// </summary>
    /// <param name="db">Datenbankkontext für den Zugriff auf Mitarbeiterdaten.</param>
    /// <param name="passwordHasher">Service zum Hashen des abgeleiteten Passworts.</param>
    /// <param name="clock">Uhrzeit-Provider zur Validierung der Einladungsgültigkeit.</param>
    /// <param name="invitationCode">Der Einladungscode des Nutzers.</param>
    /// <param name="vorname">Der Vorname des Nutzers.</param>
    /// <param name="nachname">Der Nachname des Nutzers.</param>
    /// <param name="derivedPassword">Das abgeleitete Passwort des Nutzers.</param>
    /// <param name="publicKey">Der öffentliche Schlüssel des Nutzers.</param>
    /// <param name="salt">Das Salt für den privaten Schlüssel des Nutzers.</param>
    /// <param name="encryptedPrivateKey">Der verschlüsselte private Schlüssel des Nutzers.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Das Ergebnis der Registrierung als RegisterBackofficeUserResult.</returns>
    [UseMutationConvention(PayloadFieldName = "result")]
    [AllowAnonymous]
    public async Task<RegisterBackofficeUserResult> RegisterBackofficeUser(
        DomainContext db,
        [Service] IPasswordHasher<User> passwordHasher,
        [Service] IClock clock,
        Guid invitationCode,
        string vorname,
        string nachname,
        string derivedPassword,
        string publicKey,
        string salt,
        EncryptedValue encryptedPrivateKey,
        CancellationToken ct
    ) {
        var user = await db.Mitarbeiter.AsTracking().FirstOrDefaultAsync(user => user.InvitationCode == invitationCode, ct);
        if (user is null) {
            return RegisterBackofficeUserResult.InvalidCode;
        }
        var now = clock.GetCurrentInstant();
        if (now > user.InvitationValidUntil) {
            return RegisterBackofficeUserResult.CodeExpired;
        }

        user.Vorname = vorname;
        user.Nachname = nachname;
        user.InvitationCode = null;
        user.InvitationValidUntil = null;
        user.PublicKey = publicKey;
        user.PersonalPrivateKey = encryptedPrivateKey;
        user.PersonalPrivateKeySalt = salt;
        user.OrganisationPrivateKey = null;

        var hashedPassword = passwordHasher.HashPassword(user, derivedPassword);
        user.Password = hashedPassword;

        user.PendingConfirmation = PendingConfirmationReason.Invited;

        await db.SaveChangesAsync(ct);

        return RegisterBackofficeUserResult.Success;
    }

    /// <summary>
    /// Mögliche Ergebnisse der Registrierung eines Backoffice-Nutzers.
    /// </summary>
    public enum RegisterBackofficeUserResult {
        Success,
        InvalidCode,
        CodeExpired
    }
}
