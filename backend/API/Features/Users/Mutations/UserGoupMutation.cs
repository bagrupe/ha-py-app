using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit.Mutations;
using API.Infrastructure;
using API.Utils;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Users.Mutations;

/// <summary>Enthält Mutationen zur Verwaltung von Mitarbeitergruppen.</summary>
[MutationType]
public class UserGroupMutation {
    /// <summary>Aktualisiert eine bestehende Mitarbeitergruppe mit neuem Namen und E-Mail-Adressen.</summary>
    /// <param name="id">Die ID der zu aktualisierenden Mitarbeitergruppe.</param>
    /// <param name="name">Der neue Name der Mitarbeitergruppe.</param>
    /// <param name="eMailAdressen">Die E-Mail-Adressen der Mitarbeitergruppe, an die bei aktivierter Benachrichtigung versendet wird.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <returns>Die aktualisierte Mitarbeitergruppe.</returns>
    [Authorize]
    [Error(typeof(GroupNameInvalid))]
    [Error(typeof(InvalidEmailException))]
    public async Task<MitarbeiterGruppe> UpdateAbteilung(Guid id, string name, List<string> eMailAdressen, DomainContext db, HashSet<Guid> organisationseinheitIds,
        CurrentUserAccessor currentUserAccessor) {
        if (string.IsNullOrEmpty(name)) throw new GroupNameInvalid();

        var normalizedEMailAdressen = EmailValidation.NormalizeEmails(eMailAdressen);

        var mitarbeiterGruppe =
            await db.MitarbeiterGruppen.AsTracking()
                .Include(m => m.Organisationseinheiten)     // um die OEs auch zu löschen, siehe unten
                .FirstOrDefaultAsync(m => m.Id == id) ??
            throw new Exception("Mitarbeitergruppe not found");

        var (user, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen
            .InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung)
            .Fordern();

        if (user.KommuneId != mitarbeiterGruppe.KommuneId) throw new InvalidOperationException();

        var requestedOrganisationseinheiten = await db.Untereinheit
            .AsTracking()
            .WhereOwnMandant(user)
            .Where(oe => organisationseinheitIds.Contains(oe.Id))
            .ToListAsync();

        mitarbeiterGruppe.Name = name;
        mitarbeiterGruppe.EMailAdressen = normalizedEMailAdressen;
        mitarbeiterGruppe.Organisationseinheiten = requestedOrganisationseinheiten;
        await db.SaveChangesAsync();

        return mitarbeiterGruppe;
    }

    /// <summary>Löscht eine Mitarbeitergruppe, sofern keine abhängigen Prozesse existieren.</summary>
    /// <param name="id">Die ID der zu löschenden Mitarbeitergruppe.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <param name="ct">Token zur Abbruchsteuerung asynchroner Operationen.</param>
    /// <returns>Payload mit Erfolg und möglichen Prozessabhängigkeiten.</returns>
    [Authorize]
    public async Task<DeleteAbteilungPayload> DeleteAbteilung(Guid id, DomainContext db,
        CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Mitarbeiter currentMitarbeiter) throw new InvalidOperationException();

        var dependentProzesse = await db.Prozesse
            .AsSplitQuery()
            .Where(p => p.KommuneId == currentMitarbeiter.KommuneId)
            .Include(p => p.Versionen)
            .ThenInclude(v => v.Schritte)
            .Select(p => new {
                p.Id,
                p.Name,
                Version = p.Versionen.OrderByDescending(pv => pv.PublishedAt)
                        .FirstOrDefault(pv =>
                            pv.PublishedAt != null
                        )
            }
            )
            .Where(p => p.Version != null)
            .Where(p => p.Version!.Schritte.Any(s => s.SollZustaendigkeit.MitarbeiterGruppeId == id))
            .Where(p => p.Version != null)
            .ToListAsync(ct);

        if (dependentProzesse.Count != 0) {
            return new DeleteAbteilungPayload(false,
                null,
                dependentProzesse.Select(p => new DeleteAbteilungProzessDependency(
                    ProzessId: p.Id,
                    ProzessName: p.Name,
                    SchrittNamen: p.Version?.Schritte
                        .Where(s => s.SollZustaendigkeit.MitarbeiterGruppeId == id)
                        .Select(s => s.Titel ?? s.Id.ToString())
                        .ToList() ?? []
                )).ToArray()
            );
        }

        var mitarbeiterGruppe =
            await db.MitarbeiterGruppen.AsTracking()
                .FirstOrDefaultAsync(m => m.Id == id, ct) ?? throw new GroupNotFound();

        if (currentMitarbeiter.KommuneId != mitarbeiterGruppe.KommuneId) throw new InvalidOperationException();

        mitarbeiterGruppe.IsDeleted = true;

        await db.SaveChangesAsync(ct);
        return new DeleteAbteilungPayload(true, mitarbeiterGruppe, null);
    }

    /// <summary>Repräsentiert eine Abhängigkeit eines Prozesses von einer Mitarbeitergruppe.</summary>
    /// <param name="ProzessId">Die ID des Prozesses.</param>
    /// <param name="ProzessName">Der Name des Prozesses.</param>
    /// <param name="SchrittNamen">Liste der betroffenen Schritt-Namen.</param>
    public record DeleteAbteilungProzessDependency(Guid ProzessId, string ProzessName, List<String> SchrittNamen);

    /// <summary>Payload für das Ergebnis der Löschung einer Mitarbeitergruppe.</summary>
    /// <param name="Success">Gibt an, ob die Löschung erfolgreich war.</param>
    /// <param name="MitarbeiterGruppe">Die gelöschte Mitarbeitergruppe, falls erfolgreich.</param>
    /// <param name="ProzessDependencies">Liste der Prozessabhängigkeiten, falls vorhanden.</param>
    public record DeleteAbteilungPayload(
        bool Success,
        MitarbeiterGruppe? MitarbeiterGruppe,
        DeleteAbteilungProzessDependency[]? ProzessDependencies);

    /// <summary>Fügt eine neue Mitarbeitergruppe mit Name und E-Mail-Adressen hinzu.</summary>
    /// <param name="name">Der Name der neuen Mitarbeitergruppe.</param>
    /// <param name="eMailAdressen">Die E-Mail-Adressen der neuen Mitarbeitergruppe, an die bei aktivierter Benachrichtigung versendet wird.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuell angemeldeten Nutzer.</param>
    /// <returns>Die neu erstellte Mitarbeitergruppe.</returns>
    [Authorize]
    [Error(typeof(InvalidEmailException))]
    public async Task<MitarbeiterGruppe> AddAbteilung(string name, List<string> eMailAdressen, DomainContext db,
        CurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();
        if (user is not Mitarbeiter mitarbeiter) throw new InvalidOperationException();

        var normalizedEMailAdressen = EmailValidation.NormalizeEmails(eMailAdressen);

        var count = await db.MitarbeiterGruppen.CountAsync(mg => mg.KommuneId == mitarbeiter.KommuneId);

        var mitarbeiterGruppe = new MitarbeiterGruppe {
            Name = name,
            EMailAdressen = normalizedEMailAdressen,
            KommuneId = mitarbeiter.KommuneId,
            Ordinal = count,
        };
        db.MitarbeiterGruppen.Add(mitarbeiterGruppe);

        await db.SaveChangesAsync();
        return mitarbeiterGruppe;
    }

    private class GroupNotFound : Exception;

    private class GroupNameInvalid() : DomainException("Der Abteilungsname darf nicht leer sein.");
}
