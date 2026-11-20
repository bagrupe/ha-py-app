using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using API.Features.Dienstleistungen;
using API.Features.Funktionsberechtigungen;
using API.Features.Prozess;
using API.Features.Untereinheit;
using API.Infrastructure;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using NodaTime;

namespace API.Features.Auth;

/// <summary>
/// Repräsentiert einen allgemeinen Nutzer mit grundlegenden Eigenschaften.
/// </summary>
[InterfaceType]
public abstract class User {
    /// <summary>
    /// Eindeutige ID des Nutzers.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// Passwort des Nutzers.
    /// </summary>
    [GraphQLIgnore] public string Password { get; set; } = "";

    /// <summary>
    /// Öffentlicher Schlüssel des Nutzers.
    /// </summary>
    public string? PublicKey { get; set; }

    /// <summary>
    /// Verschlüsselter privater Schlüssel des Nutzers.
    /// </summary>
    [GraphQLIgnore] public EncryptedValue? PersonalPrivateKey { get; set; }

    /// <summary>
    /// Salt für den privaten Schlüssel des Nutzers.
    /// </summary>
    [GraphQLIgnore] public string? PersonalPrivateKeySalt { get; set; }

    /// <summary>
    /// Gibt an, ob der Nutzer gelöscht wurde.
    /// </summary>
    public bool IsDeleted { get; set; }

    /// <summary>
    /// Code zum Zurücksetzen des Passworts.
    /// </summary>
    [GraphQLIgnore] public Guid? PasswordResetCode { get; set; }

    /// <summary>
    /// Ablaufdatum für den Passwort-Zurücksetzungscode.
    /// </summary>
    [GraphQLIgnore] public Instant? PasswordResetValidUntil { get; set; }
}

/// <summary>
/// Konfiguration für die Datenbankentität "Mitarbeiter".
/// </summary>
public class UserEntityTypeConfiguration : IEntityTypeConfiguration<Mitarbeiter> {
    public void Configure(EntityTypeBuilder<Mitarbeiter> builder) {
        builder
            .Property(u => u.EMail)
            .HasConversion<LowerCaseValueConverter>();
        builder.HasIndex(u => u.EMail).IsUnique();
    }
}

/// <summary>
/// Repräsentiert einen Mitarbeiter mit zusätzlichen Eigenschaften.
/// </summary>
[InterfaceType]
public abstract class Mitarbeiter : User {
    /// <summary>
    /// E-Mail-Adresse des Mitarbeiters.
    /// </summary>
    public string EMail { get; init; } = "";

    /// <summary>
    /// Vorname des Mitarbeiters.
    /// </summary>
    public string Vorname { get; set; } = "";

    /// <summary>
    /// Nachname des Mitarbeiters.
    /// </summary>
    public string Nachname { get; set; } = "";

    /// <summary>
    /// Zugehörige Kommune des Mitarbeiters.
    /// </summary>
    public Kommune.Kommune Kommune { get; init; } = null!;

    /// <summary>
    /// ID der zugehörigen Kommune.
    /// </summary>
    public Guid KommuneId { get; init; }

    /// <summary>
    /// Gruppen, denen der Mitarbeiter angehört.
    /// </summary>
    public List<MitarbeiterGruppe> Gruppen { get; set; } = new();

    /// <summary>
    /// Privater Schlüssel der Organisation des Mitarbeiters.
    /// </summary>
    public string? OrganisationPrivateKey { get; set; }

    /// <summary>
    /// Grund für eine ausstehende Bestätigung.
    /// </summary>
    public PendingConfirmationReason? PendingConfirmation { get; set; }

    /// <summary>
    /// Einladungscode für den Mitarbeiter.
    /// </summary>
    [GraphQLIgnore] public Guid? InvitationCode { get; set; }

    /// <summary>
    /// Ablaufdatum des Einladungscodes.
    /// </summary>
    [GraphQLIgnore] public Instant? InvitationValidUntil { get; set; }
}

/// <summary>
/// Gründe für eine ausstehende Bestätigung eines Mitarbeiters.
/// </summary>
public enum PendingConfirmationReason {
    Invited,
    PasswordReset
}

/// <summary>
/// Repräsentiert einen Backoffice-Nutzer mit spezifischen Eigenschaften.
/// </summary>
[ObjectType]
public class BackofficeUser : Mitarbeiter {
    /// <summary>
    /// Berechtigungen des Nutzers für Untereinheiten.
    /// </summary>
    [GraphQLIgnore] public List<UntereinheitPermissions> UntereinheitPermissions { get; set; } = null!;

    /// <summary>
    /// Art des Backoffice-Nutzers.
    /// </summary>
    public BackofficeNutzerArt Art { get; set; } = BackofficeNutzerArt.Nutzer;

    /// <summary>
    /// Gibt an, ob der Nutzer mit Bereich B synchronisiert ist.
    /// </summary>
    [GraphQLIgnore] public bool IsSyncedToBereichB { get; set; }

    /// <summary>
    /// Gibt an, ob der Nutzer ein Administrator der Kommune ist.
    /// </summary>
    [NotMapped]
    public bool IsKommuneAdmin {
        get { return Art is BackofficeNutzerArt.Superadmin or BackofficeNutzerArt.Admin; }
    }

    /// <summary>
    /// Globale Funktionsberechtigungen des Nutzers.
    /// </summary>
    [GraphQLIgnore] public List<GlobaleFunktionsberechtigung> Funktionsberechtigungen { get; set; } = [];

    /// <summary>
    /// ID des zugehörigen Dienstleisters.
    /// </summary>
    [GraphQLIgnore] public Guid? DienstleisterId { get; set; }

    /// <summary>
    /// Zugehöriger Dienstleister.
    /// </summary>
    [GraphQLIgnore] public Dienstleister? Dienstleister { get; set; }

    /// <summary>
    /// Status des Backoffice-Nutzers.
    /// </summary>
    public BackofficeNutzerStatus Status {
        get {
            if (InvitationCode is not null) {
                if (InvitationValidUntil is not null &&
                    SystemClock.Instance.GetCurrentInstant() > InvitationValidUntil.Value) {
                    return BackofficeNutzerStatus.InvitationExpired;
                }

                return BackofficeNutzerStatus.Invited;
            }

            return BackofficeNutzerStatus.Registered;
        }
    }
}

/// <summary>
/// Konfiguration für die Datenbankentität "BackofficeUser".
/// </summary>
public class BackofficeUserEntityTypeConfiguration : IEntityTypeConfiguration<BackofficeUser> {
    public void Configure(EntityTypeBuilder<BackofficeUser> builder) {
        builder.Navigation(user => user.UntereinheitPermissions).AutoInclude();
        builder
            .PrimitiveCollection(user => user.Funktionsberechtigungen)
            .HasDefaultValueSql("'{}'")
            .ElementType().HasConversion<string>();
    }
}

/// <summary>
/// Arten von Backoffice-Nutzern.
/// </summary>
public enum BackofficeNutzerArt {
    Nutzer,
    Admin,
    Superadmin,
    Dienstleister
}

/// <summary>
/// Erweiterungen für die Backoffice-Nutzerart.
/// </summary>
public static class BackofficeNutzerArtExtensions {
    /// <summary>
    /// Überprüft, ob eine Nutzerart durch eine andere erfüllt wird.
    /// </summary>
    public static bool ErfuelltDurch(this BackofficeNutzerArt art, BackofficeNutzerArt other) {
        if (other is BackofficeNutzerArt.Superadmin) {
            return true;
        }

        return art switch {
            BackofficeNutzerArt.Admin => other is BackofficeNutzerArt.Admin,
            BackofficeNutzerArt.Nutzer => other is BackofficeNutzerArt.Admin or BackofficeNutzerArt.Nutzer,
            BackofficeNutzerArt.Dienstleister => other is BackofficeNutzerArt.Admin or BackofficeNutzerArt.Nutzer
                or BackofficeNutzerArt.Dienstleister,
            _ => false,
        };
    }
}

/// <summary>
/// Status eines Backoffice-Nutzers.
/// </summary>
public enum BackofficeNutzerStatus {
    Invited,
    InvitationExpired,
    Registered
}

/// <summary>
/// Repräsentiert einen Bürger mit spezifischen Eigenschaften.
/// </summary>
[ObjectType]
public class Buerger : User {
    private string? _phone;

    /// <summary>
    /// Ausführungen, denen der Bürger folgt.
    /// </summary>
    public List<Ausfuehrung> GefolgteAusfuehrungen { get; set; } = new();

    /// <summary>
    /// Push-Benachrichtigungstoken des Bürgers.
    /// </summary>
    public List<string> PushNotificationTokens { get; set; } = new();

    /// <summary>
    /// IDs der Organisationseinheiten für Benachrichtigungen.
    /// </summary>
    public List<Guid> OrganisationseinheitIdsForNewsNotifications { get; set; } = new();

    /// <summary>
    /// Verschlüsselter persönlicher Datenschlüssel des Bürgers.
    /// </summary>
    [GraphQLIgnore] public required string PersonalDataKeyEncryptedForBuerger { get; set; }

    /// <summary>
    /// Persönliche Daten des Bürgers.
    /// </summary>
    public List<BuergerPersonalData> PersonalData { get; set; } = new();

    /// <summary>
    /// Telefonnummer des registrierten Bürgers. Verschlüsselt (serverseitig lesbar für SMS-Verifizierung). Null solange anonym.
    /// </summary>
    [GraphQLIgnore]
    public string? Phone {
        get => _phone;
        set {
            _phone = value;
            PhoneHash = PhoneHashingService.ComputeHash(value);
        }
    }

    /// <summary>
    /// Hash für die Telefonnummer die verschlüsselt gespeichert wird.
    /// </summary>
    [GraphQLIgnore] public string? PhoneHash { get; private set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.PhoneVerified"/> lesbar.</summary>
    [GraphQLIgnore]
    public bool PhoneVerified { get; set; }

    [NotMapped]
    public string? PhoneNumberMasked {
        get {
            if (Phone is null) return null;
            var digits = Phone.Where(char.IsDigit).ToArray();
            if (digits.Length <= 4) return new string('•', digits.Length);
            return $"•••• {new string(digits[^4..])}";
        }
    }

    /// <summary>
    /// Gibt an, ob der Bürger registriert ist (Ehrenamtsbank). Anonyme Bürger: false.
    /// </summary>
    [GraphQLIgnore] public bool IsRegistered { get; set; }

    [GraphQLIgnore] public int SessionStamp { get; set; }

    [GraphQLIgnore] public Instant? SessionsEndedAt { get; set; }

    /// <summary>
    /// Führungszeugnis-Status des Bürgers (Ehrenamtsbank). Anonyme Bürger: false.
    /// </summary>
    [GraphQLIgnore] public bool RequiresClearanceVerified { get; set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.Vorname"/> lesbar.</summary>
    [GraphQLIgnore]
    public string? Vorname { get; set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.Nachname"/> lesbar.</summary>
    [GraphQLIgnore]
    public string? Nachname { get; set; }

    /// <summary>
    /// Nicht "Email" genannt, das kollidiert in derselben TPH-Tabelle mit Mitarbeiter.EMail. Nur für den Bürger
    /// selbst über <see cref="Queries.BuergerQueryExtensions.EmailAddress"/> lesbar.
    /// </summary>
    [GraphQLIgnore]
    public string? EmailAddress { get; set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.Street"/> lesbar.</summary>
    [GraphQLIgnore]
    public string? Street { get; set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.PostalCode"/> lesbar.</summary>
    [GraphQLIgnore]
    public string? PostalCode { get; set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.City"/> lesbar.</summary>
    [GraphQLIgnore]
    public string? City { get; set; }

    /// <summary>Nur für den Bürger selbst über <see cref="Queries.BuergerQueryExtensions.Country"/> lesbar.</summary>
    [GraphQLIgnore]
    public string? Country { get; set; }

    /// <summary>
    /// Zeitpunkt der Erstellung des Bürgers. Null für Bürger, die vor Einführung dieses Feldes angelegt wurden.
    /// </summary>
    [GraphQLIgnore] public Instant? CreatedAt { get; set; }

    /// <summary>
    /// Zeitpunkt der Registrierung (Ehrenamtsbank). Null solange anonym.
    /// </summary>
    [GraphQLIgnore] public Instant? RegisteredAt { get; set; }

    [GraphQLIgnore] public Instant? BundIdDatenSyncedAt { get; set; }

    /// <summary>
    /// Verifikationscode (wird für die SMS-Verifizierung benutzt)
    /// </summary>
    [GraphQLIgnore] public string? VerificationCode { get; set; }

    /// <summary>
    /// Zeitpunkt bis der VerificationCode abgelaufen ist
    /// </summary>
    [GraphQLIgnore] public Instant? VerificationCodeValidUntil { get; set; }

    /// <summary>
    /// Hash der Telefonnummer, für die der aktuelle Verifikationscode ausgestellt wurde.
    /// </summary>
    [GraphQLIgnore] public string? VerificationPhoneHash { get; set; }

    /// <summary>
    /// Zeitpunkt der letzten SMS-Code-Anfrage. Wird für die erneute Anforderung verwendet.
    /// </summary>
    [GraphQLIgnore] public Instant? VerificationCodeRequestedAt { get; set; }

    /// <summary>
    /// Anzahl fehlgeschlagener Eingabeversuche für den aktuellen Verifikationscode.
    /// </summary>
    [GraphQLIgnore] public int VerificationCodeFailedAttempts { get; set; }

    /// <summary>
    /// Zeitpunkt, bis zu dem weitere SMS-Verifikationsversuche gesperrt sind.
    /// </summary>
    [GraphQLIgnore] public Instant? VerificationCodeLockedUntil { get; set; }
}


/// <summary>
/// Konfiguration für die Datenbankentität "Buerger". Speichert die Phone-Number
/// verschlüsselt und ohne white-space
/// </summary>
public class BuergerEntityTypeConfiguration : IEntityTypeConfiguration<Buerger> {
    private readonly IDataProtector _protector;

    public BuergerEntityTypeConfiguration(IDataProtectionProvider provider) {
        _protector = provider.CreateProtector("Buerger.Telefonnummer.Schutz.V1");
    }

    public void Configure(EntityTypeBuilder<Buerger> builder) {
        builder
            .Property(b => b.Phone)
            .HasConversion(
                v => v != null ? _protector.Protect(v) : null,
                v => v != null ? _protector.Unprotect(v) : null
            );

        builder
            .HasIndex(b => b.PhoneHash)
            .IsUnique();

        builder.HasIndex(b => b.VerificationPhoneHash);
    }
}

/// <summary>
/// Repräsentiert persönliche Daten eines Bürgers.
/// </summary>
public class BuergerPersonalData {
    /// <summary>
    /// ID des zugehörigen Bürgers.
    /// </summary>
    public Guid BuergerId { get; set; }

    /// <summary>
    /// Eindeutige ID der persönlichen Daten.
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Schlüssel der persönlichen Daten.
    /// </summary>
    public required string Key { get; set; }

    /// <summary>
    /// Verschlüsselter Wert der persönlichen Daten.
    /// </summary>
    public required EncryptedValue Value { get; set; }
}

/// <summary>
/// Repräsentiert einen Systemnutzer mit festen Eigenschaften.
/// </summary>
[ObjectType]
public class SystemUser : User {
    private SystemUser() { }

    /// <summary>
    /// Feste ID des Systemnutzers.
    /// </summary>
    public static readonly Guid UserId = Guid.Parse("725b3950-1fd0-435c-ade5-e5df1211f243");

    /// <summary>
    /// Stellt sicher, dass der Systemnutzer in der Datenbank existiert.
    /// </summary>
    public static async Task EnsureSystemUserExists(DomainContext db) {
        var existing = await db.SystemUsers.AnyAsync(u => u.Id == UserId);
        if (existing) return;

        var user = new SystemUser { Id = UserId };
        db.Users.Add(user);

        await db.SaveChangesAsync();
    }
}

/// <summary>
/// Repräsentiert eine Gruppe von Mitarbeitern: Abteilungen / Ämter / Fachbereiche
/// </summary>
public class MitarbeiterGruppe {
    /// <summary>
    /// Eindeutige ID der Gruppe.
    /// </summary>
    public Guid Id { get; init; }

    /// <summary>
    /// ID der zugehörigen Kommune.
    /// </summary>
    [GraphQLIgnore] public Guid KommuneId { get; init; }

    /// <summary>
    /// Ordinalwert der Gruppe.
    /// </summary>
    public int Ordinal { get; set; } = 0;

    /// <summary>
    /// Zugehörige Kommune.
    /// </summary>
    [GraphQLIgnore] public Kommune.Kommune Kommune { get; init; } = null!;

    /// <summary>
    /// Name der Gruppe.
    /// </summary>
    [GraphQLIgnore]
    public required String Name { get; set; }

    /// <summary>
    /// E-Mail-Adressen der Gruppe, die bei Formularschritt-Benachrichtigungen alle angeschrieben werden.
    /// </summary>
    public List<String> EMailAdressen { get; set; } = [];

    /// <summary>
    /// Mitarbeiter in der Gruppe.
    /// </summary>
    [GraphQLIgnore] public ICollection<Mitarbeiter> Mitarbeiter { get; init; } = null!;

    /// <summary>
    /// Gibt an, ob die Gruppe gelöscht wurde.
    /// </summary>
    public bool IsDeleted { get; set; }

    /// <summary>
    /// Liste der zugeordneten Organisationseinheiten.
    /// </summary>
    public List<Untereinheit.Untereinheit> Organisationseinheiten { get; set; } = [];
}

/// <summary>
/// Konfiguration für die Datenbankentität "MitarbeiterGruppe".
/// </summary>
public class MitarbeiterGruppeEntityTypeConfiguration : IEntityTypeConfiguration<MitarbeiterGruppe> {
    public void Configure(EntityTypeBuilder<MitarbeiterGruppe> builder) {
        builder
            .PrimitiveCollection(mg => mg.EMailAdressen)
            .HasDefaultValueSql("'{}'")
            .ElementType().HasConversion<LowerCaseValueConverter>();
    }
}

/// <summary>
/// Erweiterungen für Backoffice-Nutzer.
/// </summary>
public static class BackofficeUserExtension {
    /// <summary>
    /// Filtert Backoffice-Nutzer nach derselben Organisationseinheit.
    /// </summary>
    public static IQueryable<BackofficeUser> WhereSameOrganisationseinheit(this IQueryable<BackofficeUser> queryable,
        BackofficeUser user) {
        var result = queryable.Where(u => u.KommuneId == user.KommuneId);

        if (user.Art == BackofficeNutzerArt.Superadmin) {
            return result;
        }

        var organisationseinheitIds = user.UntereinheitPermissions.Select(p => p.UntereinheitId).ToList();

        result = result.Where(u =>
            u.UntereinheitPermissions.Any(p => organisationseinheitIds.Contains(p.UntereinheitId)));

        return result;
    }
}
