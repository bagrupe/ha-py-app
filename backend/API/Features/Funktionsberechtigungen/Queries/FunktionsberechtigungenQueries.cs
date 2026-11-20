using API.Features.Auth;
using API.Features.Untereinheit;
using HotChocolate.Authorization;

namespace API.Features.Funktionsberechtigungen.Queries;

/// <summary>Stellt Root-Queries für Funktionsberechtigungen bereit.</summary>
[QueryType]
public static class RootQueries {
    /// <summary>Liefert Metadaten aller Funktionsberechtigungen.</summary>
    [AllowAnonymous]
    public static FunktionsberechtigungenMetadata GetFunktionsberechtigungen() {
        return new FunktionsberechtigungenMetadata(
            GetAllGlobaleFunktionsberechtigungen(),
            GetAllFunktionsberechtigungInOrganisationseinheit()
        );
    }

    /// <summary>Ermittelt alle globalen Funktionsberechtigungen ohne virtuelle.</summary>
    private static IEnumerable<FunktionsberechtigungMetadata<GlobaleFunktionsberechtigung>> GetAllGlobaleFunktionsberechtigungen() {
        var enumType = typeof(GlobaleFunktionsberechtigung);
        return Enum
            .GetValues<GlobaleFunktionsberechtigung>()
            .Select(b => b.GetMetadata())
            .Where(meta => !meta.Virtuell);
    }

    /// <summary>Ermittelt alle Funktionsberechtigungen in Organisationseinheiten ohne virtuelle.</summary>
    private static IEnumerable<FunktionsberechtigungMetadata<FunktionsberechtigungInOrganisationseinheit>> GetAllFunktionsberechtigungInOrganisationseinheit() {
        var enumType = typeof(FunktionsberechtigungInOrganisationseinheit);
        return Enum
            .GetValues<FunktionsberechtigungInOrganisationseinheit>()
            .Select(b => b.GetMetadata())
            .Where(meta => !meta.Virtuell);
    }

}

/// <summary>Erweitert Mitarbeiter um Abfragen zu Funktionsberechtigungen und Organisationseinheiten.</summary>
[ExtendObjectType<Mitarbeiter>]
public static class MitarbeiterQueries {
    /// <summary>Liefert globale Funktionsberechtigungen für den angegebenen Mitarbeiter.</summary>
    /// <param name="parent">Der Mitarbeiter, dessen Berechtigungen abgefragt werden.</param>
    /// <param name="funktionsberechtigungenService">Service zur Abfrage der Berechtigungen.</param>
    public static IEnumerable<GlobaleFunktionsberechtigung> GetFunktionsberechtigungen(
        [Parent] Mitarbeiter parent, [Service] FunktionsberechtigungenService funktionsberechtigungenService
    ) {
        if (parent is not BackofficeUser backofficeUser) {
            return Array.Empty<GlobaleFunktionsberechtigung>();
        }
        return funktionsberechtigungenService.GetGlobaleFunktionsberechtigungenForUser(backofficeUser);
    }

    /// <summary>Liefert Organisationseinheiten für den angegebenen Mitarbeiter.</summary>
    /// <param name="parent">Der Mitarbeiter, dessen Organisationseinheiten abgefragt werden.</param>
    /// <param name="funktionsberechtigungenService">Service zur Abfrage der Organisationseinheiten.</param>
    public static Task<IEnumerable<ResolvedBackofficeUserOrganisationseinheit>> GetOrganisationseinheiten(
        [Parent] Mitarbeiter parent,
        [Service] FunktionsberechtigungenService funktionsberechtigungenService
    ) {
        if (parent is not BackofficeUser backofficeUser) {
            return Task.FromResult<IEnumerable<ResolvedBackofficeUserOrganisationseinheit>>(Array.Empty<ResolvedBackofficeUserOrganisationseinheit>());
        }
        return funktionsberechtigungenService.GetOrganisationseinheitenForUser(backofficeUser);
    }
}

/// <summary>Erweitert BackofficeUserOrganisationseinheit um Abfragen zur Organisationseinheit.</summary>
[ExtendObjectType<BackofficeUserOrganisationseinheit>]
public class BackofficeUserOrganisationseinheitQueries {
    /// <summary>Lädt die zugehörige Organisationseinheit anhand der ID.</summary>
    /// <param name="parent">Die BackofficeUserOrganisationseinheit, deren Organisationseinheit geladen wird.</param>
    /// <param name="dataLoader">DataLoader zum Laden der Untereinheit.</param>
    public async Task<Untereinheit.Untereinheit> GetOrganisationseinheit([Parent] BackofficeUserOrganisationseinheit parent, IUntereinheitByUntereinheitIdDataLoader dataLoader) {
        return await dataLoader.LoadAsync(parent.OrganisationseinheitId);
    }
}

/// <summary>Repräsentiert Metadaten zu Funktionsberechtigungen, getrennt nach globalen und organisationseinheitsspezifischen Berechtigungen.</summary>
/// <param name="Global">Globale Funktionsberechtigungen.</param>
/// <param name="InOrganisationseinheit">Funktionsberechtigungen in Organisationseinheiten.</param>
public record FunktionsberechtigungenMetadata(
    IEnumerable<FunktionsberechtigungMetadata<GlobaleFunktionsberechtigung>> Global,
    IEnumerable<FunktionsberechtigungMetadata<FunktionsberechtigungInOrganisationseinheit>> InOrganisationseinheit
);
