using System.Security.Claims;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth;

public interface ICurrentUserAccessor {
    ClaimsPrincipal ClaimsPrincipal { get; }

    Task<(BackofficeUser User, BackofficeUserFunktionsberechtigungenHelpers Berechtigungen)> EnsureBackofficeUser(BackofficeNutzerArt art = BackofficeNutzerArt.Dienstleister);
    Task<User> User();
    Guid UserId();
    Guid? TryUserId();
}

/// <summary>
/// Bietet Zugriff auf den aktuell authentifizierten Nutzer und dessen Berechtigungen.
/// </summary>
public class CurrentUserAccessor(IHttpContextAccessor httpContextAccessor, IUserByIdDataLoader userLoader, FunktionsberechtigungenService funktionsberechtigungen) : ICurrentUserAccessor {
    /// <summary>
    /// Ruft den ClaimsPrincipal des aktuellen HTTP-Kontexts ab.
    /// </summary>
    public ClaimsPrincipal ClaimsPrincipal => httpContextAccessor.HttpContext!.User;

    /// <summary>
    /// Ermittelt die Benutzer-ID aus den Claims des aktuellen Nutzers.
    /// </summary>
    /// <returns>Die Benutzer-ID als Guid.</returns>
    /// <exception cref="Unauthenticated">Wird ausgelöst, wenn der Nutzer nicht authentifiziert ist.</exception>
    public Guid UserId() {
        return TryUserId() ?? throw new Unauthenticated();
    }

    /// <summary>Reads the user ID from the current user's claims.</summary>
    /// <returns>The user ID, or <c>null</c> when the user is not authenticated.</returns>
    public Guid? TryUserId() {
        var claim = ClaimsPrincipal.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier);
        return Guid.TryParse(claim?.Value, out var guid) ? guid : null;
    }

    /// <summary>
    /// Lädt den aktuellen Nutzer basierend auf der Benutzer-ID.
    /// </summary>
    /// <returns>Der aktuelle Nutzer als User-Objekt.</returns>
    /// <exception cref="Unauthenticated">Wird ausgelöst, wenn der Nutzer nicht authentifiziert ist oder keine gültigen Daten vorliegen.</exception>
    public async Task<User> User() {
        var userId = UserId();
        var user = await userLoader.LoadAsync(userId, CancellationToken.None);

        return user switch {
            null or { IsDeleted: true } => throw new Unauthenticated(),
            Mitarbeiter { OrganisationPrivateKey: null } => throw new Unauthenticated(),
            _ => user
        };
    }

    /// <summary>
    /// Stellt sicher, dass der aktuelle Nutzer ein Backoffice-Nutzer mit den erforderlichen Berechtigungen ist.
    /// </summary>
    /// <param name="art">Die erforderliche Art des Backoffice-Nutzers.</param>
    /// <returns>Ein Tupel aus dem Backoffice-Nutzer und dessen Berechtigungs-Helper.</returns>
    /// <exception cref="NotAllowedException">Wird ausgelöst, wenn der Nutzer nicht die erforderlichen Berechtigungen hat.</exception>
    public async Task<(BackofficeUser User, BackofficeUserFunktionsberechtigungenHelpers Berechtigungen)> EnsureBackofficeUser(BackofficeNutzerArt art = BackofficeNutzerArt.Dienstleister) {
        var user = await User();

        if (user is not BackofficeUser backofficeUser || !art.ErfuelltDurch(backofficeUser.Art)) {
            throw new NotAllowedException($"Dieser Vorgang ist nur als Backoffice-{art} möglich.");
        }

        return (backofficeUser, await funktionsberechtigungen.GetHelpers(backofficeUser.Id));
    }

    /// <summary>
    /// Stellt sicher, das der angemeldete User ein registrierter Bürger ist.
    /// </summary>
    /// <returns>Buerger Objekt des gerade angemeldeten Benutzers</returns>
    /// <exception cref="NotAllowedException">Wird ausgelöst, wenn der angemeldete User kein registrierter Buerger ist</exception>
    public async Task<Buerger> EnsureRegisteredBuerger() {
        var user = await User();
        if (user is not Buerger { IsRegistered: true } buerger) {
            throw new NotAllowedException("Nur registrierte Nutzer können diese Aktion ausführen.");
        }

        return buerger;
    }

    /// <summary>
    /// Ausnahme, die ausgelöst wird, wenn der Nutzer nicht authentifiziert ist.
    /// </summary>
    public class Unauthenticated : DomainException {
        public Unauthenticated() : base("Unauthenticated") { }
    }

    /// <summary>
    /// Lädt Benutzer basierend auf einer Liste von Benutzer-IDs aus der Datenbank.
    /// </summary>
    /// <param name="ids">Die Liste der Benutzer-IDs.</param>
    /// <param name="domainContextFactory">Die Factory für den Datenbankkontext.</param>
    /// <param name="ct">Das Abbruch-Token.</param>
    /// <returns>Ein Wörterbuch mit Benutzer-IDs und den zugehörigen Benutzerobjekten.</returns>
    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, User>> GetUserById(IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> domainContextFactory, CancellationToken ct) {
        await using var domainContext = await domainContextFactory.CreateDbContextAsync(ct);
        return await domainContext.Users
            .Include(u => ((BackofficeUser)u).UntereinheitPermissions)
            .Include(u => ((BackofficeUser)u).Gruppen)
            .Include(u => ((BackofficeUser)u).Dienstleister)
            .AsSingleQuery()
            .Where(a => ids.Contains(a.Id)).ToDictionaryAsync(a => a.Id, ct);
    }
}
