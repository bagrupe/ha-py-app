using API.Features.Auth;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Users.Queries;

/// <summary>Stellt Abfragen für Mitarbeiter innerhalb einer Kommune bereit.</summary>
[ExtendObjectType<Kommune.Kommune>]
public class KommuneMitarbeiterQueries {
    /// <summary>Ermittelt Mitarbeiter einer Kommune mit optionaler Filterung nach Gruppe und Suchbegriff.</summary>
    /// <param name="kommune">Die Kommune, zu der die Mitarbeiter gehören.</param>
    /// <param name="userAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="domainContext">Datenbankkontext für Abfragen.</param>
    /// <param name="groupId">Optionale Gruppen-ID zur Filterung.</param>
    /// <param name="nurDienstleister">Gibt an, ob nur externe Dienstleister zurückgegeben werden sollen.</param>
    /// <param name="art">Optionale Nutzerart zur Filterung (Nutzer, Admin, Superadmin, Dienstleister).</param>
    /// <param name="search">Optionaler Suchbegriff für E-Mail, Nachname oder Vorname.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Eine Abfrage von Mitarbeitern, die den Kriterien entsprechen.</returns>
    [Authorize]
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    public async Task<IQueryable<Mitarbeiter>> GetMitarbeiter(
        [Parent] Kommune.Kommune kommune,
        CurrentUserAccessor userAccessor,
        DomainContext domainContext,
        Guid? groupId,
        bool nurDienstleister = false,
        BackofficeNutzerArt? art = null,
        string? search = null,
        CancellationToken ct = default
    ) {
        var (mitarbeiter, _) = await userAccessor.EnsureBackofficeUser();

        IQueryable<BackofficeUser> foundMitarbeiter = domainContext.BackofficeUser
            .WhereSameOrganisationseinheit(mitarbeiter)
            .Where(x => !x.IsDeleted)
            .OrderBy(m => m.EMail)
            .ThenBy(m => m.Id);

        if (mitarbeiter.Art != BackofficeNutzerArt.Superadmin) {
            var organisationseinheitIds = mitarbeiter.UntereinheitPermissions.Select(p => p.UntereinheitId).ToList();
            foundMitarbeiter = foundMitarbeiter.Where(x =>
                x.UntereinheitPermissions.Any(p => organisationseinheitIds.Contains(p.UntereinheitId)));
        }

        if (nurDienstleister) {
            foundMitarbeiter = foundMitarbeiter.Where(m => m.Art == BackofficeNutzerArt.Dienstleister);
        } else if (groupId.HasValue) {
            foundMitarbeiter = foundMitarbeiter.Where(m => m.Gruppen.Any(g => g.Id == groupId));
        }

        if (art.HasValue) {
            foundMitarbeiter = foundMitarbeiter.Where(m => m.Art == art);
        }

        if (!string.IsNullOrWhiteSpace(search)) {
            foundMitarbeiter = foundMitarbeiter.Where(m =>
                m.EMail.ToLower().Contains(search.ToLower()) || m.Nachname.ToLower().Contains(search.ToLower()) ||
                m.Vorname.ToLower().Contains(search.ToLower()));
        }

        return foundMitarbeiter;
    }

    /// <summary>Gibt Mitarbeiter zurück, die auf eine Bestätigung warten.</summary>
    /// <param name="userAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="kommune">Die Kommune, zu der die Mitarbeiter gehören.</param>
    /// <param name="domainContext">Datenbankkontext für Abfragen.</param>
    /// <returns>Eine Auflistung von Mitarbeitern mit ausstehender Bestätigung.</returns>
    [Authorize]
    public async Task<IEnumerable<Mitarbeiter>> GetMitarbeiterPendingConfirmation(
        CurrentUserAccessor userAccessor,
        [Parent] Kommune.Kommune kommune,
        DomainContext domainContext) {
        var (user, _) = await userAccessor.EnsureBackofficeUser();

        if (!BackofficeNutzerArt.Admin.ErfuelltDurch(user.Art)) return [];

        return domainContext.BackofficeUser
            .WhereSameOrganisationseinheit(user)
            .Where(x => !x.IsDeleted && x.PendingConfirmation != null);
    }

    /// <summary>Ermittelt Mitarbeitergruppen einer Kommune mit optionaler Einbeziehung gelöschter Gruppen.</summary>
    /// <param name="dataLoader">Datenlader für Mitarbeitergruppen nach Kommune.</param>
    /// <param name="kommune">Die Kommune, zu der die Gruppen gehören.</param>
    /// <param name="userAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="includeDeleted">Gibt an, ob gelöschte Gruppen einbezogen werden sollen.</param>
    /// <returns>Eine Auflistung von Mitarbeitergruppen.</returns>
    [Authorize]
    public async Task<IEnumerable<MitarbeiterGruppe>> GetMitarbeiterGruppen(
        IMitarbeiterGruppenByKommuneIdDataLoader dataLoader, [Parent] Kommune.Kommune kommune,
        CurrentUserAccessor userAccessor,
        bool includeDeleted = false
        ) {
        var user = await userAccessor.User();
        if (user is not Mitarbeiter mitarbeiter) {
            throw new NotAllowedException("MitarbeiterGruppen can only be queried by Mitarbeiter");
        }

        if (mitarbeiter.KommuneId != kommune.Id) {
            throw new NotAllowedException("MitarbeiterGruppen can only be queried by Mitarbeiter of the same Kommune");
        }


        var gruppen = await dataLoader.LoadAsync(kommune.Id);

        return gruppen.Where(g => includeDeleted || !g.IsDeleted);
    }

    /// <summary>Lädt Mitarbeitergruppen für mehrere Kommunen als Lookup.</summary>
    /// <param name="ids">Liste der Kommune-IDs.</param>
    /// <param name="domainContextFactory">Fabrik zum Erzeugen des Datenbankkontexts.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Lookup von Kommune-ID zu Mitarbeitergruppen.</returns>
    [DataLoader]
    internal static async Task<ILookup<Guid, MitarbeiterGruppe>> GetMitarbeiterGruppenByKommuneId(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);

        return await domainContext.MitarbeiterGruppen
            .Include(m => m.Organisationseinheiten)
            .Where(m => ids.Contains(m.KommuneId))
            .OrderBy(m => m.Name)
            .ToLookupAsync(m => m.KommuneId, ct);
    }
}

/// <summary>Erweitert Abfragen für BackofficeUser mit Berechtigungsprüfungen.</summary>
[ExtendObjectType<BackofficeUser>]
public static class MitarbeiterQueries {
    /// <summary>Prüft, ob ein Nutzer gelöscht werden darf.</summary>
    /// <param name="parent">Der Nutzer, der geprüft wird.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="db">Datenbankkontext.</param>
    /// <param name="ct">Abbruch-Token.</param>
    /// <returns>True, wenn der Nutzer gelöscht werden darf.</returns>
    public static async Task<bool> GetCanBeDeleted([Parent] BackofficeUser parent, [Service] CurrentUserAccessor currentUserAccessor, DomainContext db, CancellationToken ct) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        return berechtigungen.NutzerLoeschen(parent);
    }

    /// <summary>Prüft, ob ein Nutzer aktualisiert werden darf.</summary>
    /// <param name="parent">Der Nutzer, der geprüft wird.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="db">Datenbankkontext.</param>
    /// <param name="ct">Abbruch-Token.</param>
    /// <returns>True, wenn der Nutzer aktualisiert werden darf.</returns>
    public static async Task<bool> GetCanBeUpdated([Parent] BackofficeUser parent, [Service] CurrentUserAccessor currentUserAccessor, DomainContext db, CancellationToken ct) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        return berechtigungen.NutzerBearbeiten(parent);
    }
}

/// <summary>Erweitert Mitarbeitergruppen um eine angepasste Namensdarstellung.</summary>
[ExtendObjectType<MitarbeiterGruppe>]
public static class MitarbeiterGruppeExtensions {
    /// <summary>Gibt den Namen der Gruppe zurück, ergänzt um "(gelöscht)" bei gelöschten Gruppen.</summary>
    /// <param name="parent">Die Mitarbeitergruppe.</param>
    /// <returns>Der angepasste Name der Gruppe.</returns>
    public static string GetName([Parent] MitarbeiterGruppe parent) {
        return parent.IsDeleted ? $"{parent.Name} (gelöscht)" : parent.Name;
    }
}
