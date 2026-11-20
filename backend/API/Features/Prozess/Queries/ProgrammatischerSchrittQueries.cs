using System.Reflection;
using API.Features.Auth;
using API.Infrastructure;
using HotChocolate.Authorization;

namespace API.Features.Prozess.Queries;

/// <summary>Repräsentiert die Definition eines programmatischen Schritts mit Name und technischer Implementierung.</summary>
/// <param name="Name">Anzeigename des Schritttyps.</param>
/// <param name="ImplementationAssemblyQualifiedName">Technischer Name der Implementierungsklasse.</param>
/// <param name="LiefertZustaendigkeit">
/// Ob dieser Schritttyp eine tatsächliche Zuständigkeit ermittelt und damit als Vorgänger eines Schritts
/// mit dynamischer Soll-Zuständigkeit geeignet ist.
/// </param>
public record ProgrammatischerSchrittDefinition(String Name, String ImplementationAssemblyQualifiedName, bool LiefertZustaendigkeit);

/// <summary>Stellt Abfragen zu programmatischen Schritten bereit, die im Prozesseditor auswählbar sind.</summary>
[QueryType]
public class ProgrammatischerSchrittQueries {

    /// <summary>Liefert alle verfügbaren programmatischen Schritt-Typen für berechtigte Backoffice-Nutzer.</summary>
    /// <returns>Auflistung der Schritt-Definitionen mit Name und Implementierung.</returns>
    [Authorize]
    [GraphQLDescription("Liefert alle verfügbaren programmatischen Schritt-Typen (z.B. Automatisierungen, Weichen), die im Prozesseditor ausgewählt werden können. Nur für berechtigte Backoffice-Nutzer sichtbar.")]
    public IEnumerable<ProgrammatischerSchrittDefinition> GetProgrammatischeSchritte() {
        var interfaceType = typeof(ProgrammatischerSchrittExecutable);
        var assembly = Assembly.GetExecutingAssembly();

        return assembly.GetTypes().Where(t => t is { IsClass: true, IsAbstract: false } && interfaceType.IsAssignableFrom(t)).Select(t => {
            var attr = t.GetCustomAttribute<SchrittNameAttribute>();
            var name = attr?.Name ?? t.Name;
            return new ProgrammatischerSchrittDefinition(name, t.AssemblyQualifiedName!, attr?.LiefertZustaendigkeit ?? false);
        });
    }
}

/// <summary>Erweitert den Typ ProgrammatischerSchritt um zusätzliche Abfragen.</summary>
[ExtendObjectType<ProgrammatischerSchritt>]
public class ProgrammatischerSchrittExtensions {
    /// <summary>Gibt den technischen Namen der Implementierungsklasse für den angegebenen programmatischen Schritt zurück.</summary>
    /// <param name="programmatischerSchritt">Der programmatische Schritt, dessen Implementierung abgefragt wird.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer zur Berechtigungsprüfung.</param>
    /// <returns>Technischer Name der Implementierungsklasse.</returns>
    /// <exception cref="NotAllowedException">Wird geworfen, wenn der Nutzer ein Bürger ist.</exception>
    [GraphQLDescription("Gibt den technischen Namen der Implementierungsklasse für diesen programmatischen Schritt zurück. Nur für berechtigte Backoffice-Nutzer sichtbar.")]
    public async Task<string> GetImplementationAssemblyQualifiedName([Parent] ProgrammatischerSchritt programmatischerSchritt, CurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();
        if (user is Buerger) throw new NotAllowedException();

        return programmatischerSchritt.ImplementationAssemblyQualifiedName;
    }
}
