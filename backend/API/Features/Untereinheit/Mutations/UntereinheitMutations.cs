using API.Features.Auth;
using API.Features.BereichB;
using API.Infrastructure;
using API.Utils;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Untereinheit.Mutations;

/// <summary>Enthält Mutationen zum Erstellen, Aktualisieren und Löschen von Untereinheiten.</summary>
[MutationType]
public class UntereinheitMutations {
    /// <summary>Erstellt eine neue Untereinheit mit E-Mail-Adressen.</summary>
    /// <param name="domainContext">Datenbankkontext für Persistenzoperationen.</param>
    /// <param name="name">Name der neuen Untereinheit.</param>
    /// <param name="eMailAdressen">E-Mail-Adressen der Untereinheit.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="synchronizer">Synchronisiert Änderungen der Untereinheit.</param>
    /// <returns>Die neu erstellte Untereinheit.</returns>
    [Error(typeof(InvalidEmailException))]
    [Authorize]
    public async Task<Untereinheit> UntereinheitCreate(DomainContext domainContext, string name, List<string> eMailAdressen,
        CurrentUserAccessor currentUserAccessor, [Service] UntereinheitenSynchronizer synchronizer) {
        var (backofficeUser, _) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Superadmin);

        var normalizedEMailAdressen = EmailValidation.NormalizeEmails(eMailAdressen);

        var nextUntereinheit =
            domainContext.Untereinheit.Add(new Untereinheit {
                Name = name,
                KommuneId = backofficeUser.KommuneId,
                EMailAdressen = normalizedEMailAdressen,
                IsGemeinde = false
            });

        await domainContext.SaveChangesAsync();
        await synchronizer.Synchronize(nextUntereinheit.Entity.Id);

        return nextUntereinheit.Entity;
    }

    /// <summary>Aktualisiert eine bestehende Untereinheit mit neuem Namen und E-Mail-Adressen.</summary>
    /// <param name="domainContext">Datenbankkontext für Persistenzoperationen.</param>
    /// <param name="untereinheitId">ID der zu aktualisierenden Untereinheit.</param>
    /// <param name="name">Neuer Name der Untereinheit.</param>
    /// <param name="eMailAdressen">Neue E-Mail-Adressen.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="synchronizer">Synchronisiert Änderungen der Untereinheit.</param>
    /// <returns>Die aktualisierte Untereinheit.</returns>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(UntereinheitNotFoundException))]
    [Error(typeof(UntereinheitIsGemeindeException))]
    [Error(typeof(InvalidEmailException))]
    [Authorize]
    public async Task<Untereinheit> UntereinheitUpdate(DomainContext domainContext, Guid untereinheitId, string name,
        List<string> eMailAdressen,
        CurrentUserAccessor currentUserAccessor, [Service] UntereinheitenSynchronizer synchronizer) {
        var (user, _) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Superadmin);

        var normalizedEMailAdressen = EmailValidation.NormalizeEmails(eMailAdressen);

        var untereinheit = await domainContext.Untereinheit
            .AsTracking()
            .WhereOwnMandant(user)
            .Where(u => u.Id == untereinheitId).FirstOrDefaultAsync();

        if (untereinheit is null) throw new UntereinheitNotFoundException();
        if (untereinheit.IsGemeinde) throw new UntereinheitIsGemeindeException();

        untereinheit.Name = name;
        untereinheit.EMailAdressen = normalizedEMailAdressen;
        await domainContext.SaveChangesAsync();
        await synchronizer.Synchronize(untereinheitId);

        return untereinheit;
    }

    /// <summary>Markiert eine Untereinheit zum Löschen, sofern keine Benutzer zugeordnet sind.</summary>
    /// <param name="domainContext">Datenbankkontext für Persistenzoperationen.</param>
    /// <param name="untereinheitId">ID der zu löschenden Untereinheit.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <param name="synchronizer">Synchronisiert Änderungen der Untereinheit.</param>
    /// <returns>Liste der verbleibenden Untereinheiten des Mandanten.</returns>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(UntereinheitNotFoundException))]
    [Error(typeof(UntereinheitAssignedToUser))]
    [Error(typeof(UntereinheitIsGemeindeException))]
    [Authorize]
    public async Task<IEnumerable<Untereinheit>> UntereinheitDelete(DomainContext domainContext, Guid untereinheitId,
        CurrentUserAccessor currentUserAccessor, [Service] UntereinheitenSynchronizer synchronizer) {
        var (backofficeUser, _) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Superadmin);
        var untereinheit = await domainContext.Untereinheit
            .AsTracking()
            .WhereOwnMandant(backofficeUser)
            .Where(u => u.Id == untereinheitId)
            .FirstOrDefaultAsync();

        if (untereinheit is null) throw new UntereinheitNotFoundException();
        if (untereinheit.IsGemeinde) throw new UntereinheitIsGemeindeException();

        var hasAssignedUser =
            await domainContext.UntereinheitPermissions.CountAsync(ue => ue.UntereinheitId == untereinheitId);
        if (hasAssignedUser != 0) throw new UntereinheitAssignedToUser();

        untereinheit.MarkedForDelete = true;
        await domainContext.SaveChangesAsync();
        await synchronizer.Synchronize(untereinheitId);

        return await domainContext.Untereinheit.WhereOwnMandant(backofficeUser).ToListAsync();
    }

    private class UntereinheitAssignedToUser()
        : DomainException("Die Organisationseinheit ist Nutzenden zugeordnet und kann deswegen nicht gelöscht werden.");

    private class UntereinheitNotFoundException()
        : DomainException("Die Organisationseinheit existiert nicht und konnte deshalb nicht gelöscht werden.");

    private class UntereinheitIsGemeindeException()
        : DomainException("Die Organisationseinheit ist eine Gemeinde und kann nicht bearbeitet oder gelöscht werden.");
}

/// <summary>Erweitert IQueryable von Untereinheiten um Filter für den eigenen Mandanten.</summary>
public static class UntereinheitExtension {
    /// <summary>Filtert Untereinheiten nach der Kommune des angegebenen Backoffice-Benutzers.</summary>
    /// <param name="queryable">Abfrage von Untereinheiten.</param>
    /// <param name="user">Backoffice-Benutzer zur Bestimmung der Kommune.</param>
    /// <returns>Gefilterte Abfrage mit Untereinheiten des eigenen Mandanten.</returns>
    public static IQueryable<Untereinheit>
        WhereOwnMandant(this IQueryable<Untereinheit> queryable, BackofficeUser user) {
        return queryable.Where(u => u.KommuneId == user.KommuneId);
    }
}
