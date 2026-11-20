using API.Features.Kommune.Queries;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.Queries;

/// <summary>
/// Erweiterungsmethoden für die Benutzerklasse, um zusätzliche Funktionalitäten bereitzustellen.
/// </summary>
static class UserExtensions {
    /// <summary>
    /// Überprüft, ob der aktuelle Benutzer mit dem angegebenen Benutzer übereinstimmt. 
    /// Wirft eine Ausnahme, wenn dies nicht der Fall ist.
    /// </summary>
    /// <param name="userWithCrypto">Der Benutzer, der überprüft werden soll.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Benutzers.</param>
    public static async Task CheckIsSelf(this User userWithCrypto, CurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();

        if (userWithCrypto.Id != user.Id) {
            throw new NotAllowedException();
        }
    }
}

/// <summary>
/// Erweiterung von Abfragen für die Benutzerklasse.
/// </summary>
[ExtendObjectType<User>]
public class UserQueryExtensions {
    /// <summary>
    /// Ruft den persönlichen privaten Schlüssel des Benutzers ab, wenn der Benutzer mit dem aktuellen Benutzer übereinstimmt.
    /// </summary>
    /// <param name="user">Der Benutzer, dessen Schlüssel abgerufen werden soll.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Benutzers.</param>
    /// <returns>Der persönliche private Schlüssel oder null.</returns>
    public async Task<EncryptedValue?> PersonalPrivateKey(
        [Parent] User user,
        [Service] CurrentUserAccessor currentUserAccessor) {
        await user.CheckIsSelf(currentUserAccessor);

        return user.PersonalPrivateKey;
    }

    /// <summary>
    /// Ruft das Salt des persönlichen privaten Schlüssels des Benutzers ab, wenn der Benutzer mit dem aktuellen Benutzer übereinstimmt.
    /// </summary>
    /// <param name="user">Der Benutzer, dessen Salt abgerufen werden soll.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Benutzers.</param>
    /// <returns>Das Salt des persönlichen privaten Schlüssels oder null.</returns>
    public async Task<string?> PersonalPrivateKeySalt(
        [Parent] User user,
        [Service] CurrentUserAccessor currentUserAccessor) {
        await user.CheckIsSelf(currentUserAccessor);

        return user.PersonalPrivateKeySalt;
    }
}

/// <summary>
/// Erweiterung von Abfragen für die Bürgerklasse.
/// </summary>
[ExtendObjectType<Buerger>]
public class BuergerQueryExtensions {
    /// <summary>
    /// Ruft den verschlüsselten persönlichen Datenschlüssel des Bürgers ab, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt.
    /// </summary>
    /// <param name="buerger">Der Bürger, dessen Schlüssel abgerufen werden soll.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Benutzers.</param>
    /// <returns>Der verschlüsselte persönliche Datenschlüssel oder null.</returns>
    public async Task<string?> PersonalDataKey([Parent] Buerger buerger,
        [Service] CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.PersonalDataKeyEncryptedForBuerger;
    }

    /// <summary>
    /// Ruft die persönlichen Daten des Bürgers ab.
    /// </summary>
    /// <param name="buerger">Der Bürger, dessen Daten abgerufen werden sollen.</param>
    /// <param name="loader">Datenlader für persönliche Daten.</param>
    /// <returns>Eine Liste persönlicher Daten.</returns>
    public async Task<IEnumerable<BuergerPersonalData>> PersonalData([Parent] Buerger buerger, IPersonalDataByBuergerIdDataLoader loader) {
        return await loader.LoadAsync(buerger.Id);
    }

    /// <summary>
    /// Vorname des Bürgers, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt. Die
    /// zugrunde liegende Property ist bewusst <c>[GraphQLIgnore]</c>: ohne diesen Self-Check
    /// wäre das Feld über jedes andere Vorkommen von <see cref="User"/> im Schema erreichbar
    /// (z.B. <c>Ausfuehrung.User</c>) und damit für jeden Sachbearbeiter mit Zugriff auf die
    /// jeweilige Ausführung sichtbar, nicht nur für den Bürger selbst.
    /// </summary>
    public async Task<string?> Vorname([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.Vorname;
    }

    /// <summary>
    /// Nachname des Bürgers, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt.
    /// Begründung für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<string?> Nachname([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.Nachname;
    }

    /// <summary>
    /// E-Mail-Adresse des Bürgers, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt.
    /// Begründung für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<string?> EmailAddress([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.EmailAddress;
    }

    /// <summary>
    /// Straße und Hausnummer des Bürgers, wenn der Bürger mit dem aktuellen Benutzer
    /// übereinstimmt. Begründung für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<string?> Street([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.Street;
    }

    /// <summary>
    /// Postleitzahl des Bürgers, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt.
    /// Begründung für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<string?> PostalCode([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.PostalCode;
    }

    /// <summary>
    /// Wohnort des Bürgers, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt.
    /// Begründung für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<string?> City([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.City;
    }

    /// <summary>
    /// Land des Bürgers, wenn der Bürger mit dem aktuellen Benutzer übereinstimmt. Begründung
    /// für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<string?> Country([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.Country;
    }

    /// <summary>
    /// Gibt an, ob die Telefonnummer des Bürgers verifiziert wurde, wenn der Bürger mit dem
    /// aktuellen Benutzer übereinstimmt. Begründung für den Self-Check wie bei <see cref="Vorname"/>.
    /// </summary>
    public async Task<bool> PhoneVerified([Parent] Buerger buerger, CurrentUserAccessor currentUserAccessor) {
        await buerger.CheckIsSelf(currentUserAccessor);

        return buerger.PhoneVerified;
    }

    /// <summary>
    /// Lädt persönliche Daten für eine Liste von Bürger-IDs.
    /// </summary>
    /// <param name="buergerIds">Die IDs der Bürger.</param>
    /// <param name="dbContextFactory">Factory für den Datenbankkontext.</param>
    /// <param name="ct">Abbruch-Token.</param>
    /// <returns>Ein Lookup mit Bürger-IDs und deren persönlichen Daten.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, BuergerPersonalData>> GetPersonalDataByBuergerId(
        IReadOnlyList<Guid> buergerIds, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken ct) {
        await using var db = await dbContextFactory.CreateDbContextAsync(ct);

        return await db.Buerger
            .Where(b => buergerIds.Contains(b.Id))
            .Include(b => b.PersonalData)
            .SelectMany(b => b.PersonalData.Select(data => new { b.Id, Data = data }))
            .ToLookupAsync(b => b.Id, b => b.Data, ct);
    }
}

/// <summary>
/// Erweiterung von Abfragen für die Mitarbeiterklasse.
/// </summary>
[ExtendObjectType<Mitarbeiter>]
public class MitarbeiterQueryExtensions {
    /// <summary>
    /// Ruft den Organisationsschlüssel des Mitarbeiters ab, wenn der Mitarbeiter mit dem aktuellen Benutzer übereinstimmt.
    /// </summary>
    /// <param name="mitarbeiter">Der Mitarbeiter, dessen Schlüssel abgerufen werden soll.</param>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Benutzers.</param>
    /// <returns>Der Organisationsschlüssel oder null.</returns>
    public async Task<string?> OrganisationPrivateKey(
        [Parent] Mitarbeiter mitarbeiter,
        CurrentUserAccessor currentUserAccessor) {
        await mitarbeiter.CheckIsSelf(currentUserAccessor);

        return mitarbeiter.OrganisationPrivateKey;
    }

    /// <summary>
    /// Ruft die Kommune des Mitarbeiters ab.
    /// </summary>
    /// <param name="mitarbeiter">Der Mitarbeiter, dessen Kommune abgerufen werden soll.</param>
    /// <param name="dataLoader">Datenlader für Kommunen.</param>
    /// <returns>Die Kommune des Mitarbeiters.</returns>
    public async Task<Kommune.Kommune> GetKommune([Parent] Mitarbeiter mitarbeiter, IKommuneByIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(mitarbeiter.KommuneId);
    }

    /// <summary>
    /// Ruft die Gruppen des Mitarbeiters ab.
    /// </summary>
    /// <param name="mitarbeiter">Der Mitarbeiter, dessen Gruppen abgerufen werden sollen.</param>
    /// <param name="dataLoader">Datenlader für Gruppen.</param>
    /// <returns>Eine geordnete Liste der Gruppen.</returns>
    public async Task<IEnumerable<MitarbeiterGruppe>> GetGruppen([Parent] Mitarbeiter mitarbeiter, IGruppenByMitarbeiterIdDataLoader dataLoader) {
        return (await dataLoader.LoadAsync(mitarbeiter.Id)).OrderBy(mg => mg.Ordinal);
    }

    /// <summary>
    /// Lädt Gruppen für eine Liste von Mitarbeiter-IDs.
    /// </summary>
    /// <param name="ids">Die IDs der Mitarbeiter.</param>
    /// <param name="dbContextFactory">Factory für den Datenbankkontext.</param>
    /// <param name="cancellationToken">Abbruch-Token.</param>
    /// <returns>Ein Lookup mit Mitarbeiter-IDs und deren Gruppen.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, MitarbeiterGruppe>> GetGruppenByMitarbeiterId(IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken cancellationToken) {
        await using var db = await dbContextFactory.CreateDbContextAsync(cancellationToken);
        return await db.Mitarbeiter
            .Include(ma => ma.Gruppen)
            .ThenInclude(g => g.Organisationseinheiten)
            .SelectMany(ma => ma.Gruppen.Select(g => new { ma.Id, Gruppe = g }))
            .ToLookupAsync(record => record.Id, record => record.Gruppe, cancellationToken);
    }

    /// <summary>
    /// Ruft die Berechtigungen des Mitarbeiters in Untereinheiten ab.
    /// </summary>
    /// <param name="backofficeUser">Der Mitarbeiter, dessen Berechtigungen abgerufen werden sollen.</param>
    /// <param name="dataLoader">Datenlader für Untereinheitenberechtigungen.</param>
    /// <returns>Eine Liste der Berechtigungen.</returns>
    public async Task<IEnumerable<Untereinheit.UntereinheitPermissions>> GetUntereinheitPermissions([Parent] Mitarbeiter backofficeUser, IUntereinheitenPermissionsByUserIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(backofficeUser.Id);
    }

    /// <summary>
    /// Lädt Untereinheitenberechtigungen für eine Liste von Mitarbeiter-IDs.
    /// </summary>
    /// <param name="ids">Die IDs der Mitarbeiter.</param>
    /// <param name="dbContextFactory">Factory für den Datenbankkontext.</param>
    /// <param name="cancellationToken">Abbruch-Token.</param>
    /// <returns>Ein Lookup mit Mitarbeiter-IDs und deren Untereinheitenberechtigungen.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, Untereinheit.UntereinheitPermissions>> GetUntereinheitenPermissionsByUserId(IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> dbContextFactory, CancellationToken cancellationToken) {
        await using var db = await dbContextFactory.CreateDbContextAsync(cancellationToken);
        return await db.UntereinheitPermissions
            .Where(permissions => ids.Contains(permissions.BackofficeUserId))
            .OrderBy(permissions => permissions.Untereinheit.Name)
            .ToLookupAsync(permissions => permissions.BackofficeUserId, cancellationToken);
    }
}
