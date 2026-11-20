using System.Collections.Immutable;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit;
using API.Features.Untereinheit.Mutations;
using API.Infrastructure;
using API.Utils;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Dienstleistungen.Mutations;

/// <summary>
/// Stellt Mutationen für Dienstleister bereit.
/// </summary>
[MutationType]
public class DienstleisterMutations {
    /// <summary>
    /// Erstellt einen neuen Dienstleister mit den angegebenen Daten und Organisationseinheiten.
    /// </summary>
    /// <param name="domainContext">Datenbankkontext.</param>
    /// <param name="name">Name des Dienstleisters.</param>
    /// <param name="eMailAdressen">E-Mail-Adressen des Dienstleisters (mindestens eine).</param>
    /// <param name="organisationseinheitIds">IDs der zugeordneten Organisationseinheiten.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Den erstellten Dienstleister.</returns>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(InvalidEmailException))]
    [Authorize]
    public async Task<Dienstleister> DienstleisterCreate(
        DomainContext domainContext,
        string name,
        List<string> eMailAdressen,
        HashSet<Guid> organisationseinheitIds,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit
            .BackofficeDienstleisterverwaltung).Fordern();
        berechtigungen.InAllenOrganisationseinheiten(organisationseinheitIds, FunktionsberechtigungInOrganisationseinheit.BackofficeDienstleisterverwaltung).Fordern();

        var normalizedEMailAdressen = EmailValidation.NormalizeEmails(eMailAdressen);
        if (normalizedEMailAdressen.Count == 0) throw new InvalidEmailException();

        // In-memory overlap check (statt einer .Any(existing => ...Contains(existing))-Übersetzung in SQL), da für
        // primitive Collections kein verlässlicher Array-Overlap-Übersetzungspfad existiert; Anzahl Dienstleister ist klein.
        var normalizedEMailAdressenLower = normalizedEMailAdressen.Select(e => e.ToLowerInvariant()).ToHashSet();
        var existingDienstleisterEMails = await domainContext.Dienstleister.Select(d => d.EMailAdressen).ToListAsync();
        if (existingDienstleisterEMails.Any(emails => emails.Any(normalizedEMailAdressenLower.Contains))) {
            throw new NotAllowedException("Ein Dienstleister mit dieser E-Mail-Adresse existiert bereits.");
        }

        var requestedOrganisationseinheiten = await domainContext.Untereinheit
            .AsTracking()
            .WhereOwnMandant(actingUser)
            .Where(oe => organisationseinheitIds.Contains(oe.Id))
            .ToListAsync();

        var dienstleister = new Dienstleister { MandantId = actingUser.KommuneId, Name = name, EMailAdressen = normalizedEMailAdressen, Organisationseinheiten = requestedOrganisationseinheiten };
        domainContext.Dienstleister.Add(dienstleister);

        await domainContext.SaveChangesAsync();

        return dienstleister;
    }

    /// <summary>
    /// Aktualisiert einen bestehenden Dienstleister mit neuen Daten und Organisationseinheiten.
    /// </summary>
    /// <param name="domainContext">Datenbankkontext.</param>
    /// <param name="dienstleisterId">ID des zu aktualisierenden Dienstleisters.</param>
    /// <param name="name">Neuer Name des Dienstleisters.</param>
    /// <param name="eMailAdressen">Neue E-Mail-Adressen des Dienstleisters (mindestens eine).</param>
    /// <param name="organisationseinheitIds">Neue IDs der zugeordneten Organisationseinheiten.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Den aktualisierten Dienstleister.</returns>
    [Error(typeof(NotAllowedException))]
    [Error(typeof(InvalidEmailException))]
    [Authorize]
    public async Task<Dienstleister> DienstleisterUpdate(
        DomainContext domainContext,
        Guid dienstleisterId, string name,
        List<string> eMailAdressen,
        HashSet<Guid> organisationseinheitIds,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit
            .BackofficeDienstleisterverwaltung).Fordern();

        var normalizedEMailAdressen = EmailValidation.NormalizeEmails(eMailAdressen);
        if (normalizedEMailAdressen.Count == 0) throw new InvalidEmailException();

        var dienstleister = await domainContext.Dienstleister
            .AsTracking()
            .AsSplitQuery()
            .Where(d => d.MandantId == actingUser.KommuneId && d.Id == dienstleisterId)
            .Include(dienstleister => dienstleister.Organisationseinheiten)
            .Include(dienstleister => dienstleister.Mitarbeiter)
            .FirstOrDefaultAsync();

        if (dienstleister is null) {
            throw new NotAllowedException();
        }

        var requestedOrganisationseinheiten = await domainContext.Untereinheit
            .AsTracking()
            .WhereOwnMandant(actingUser)
            .Where(oe => organisationseinheitIds.Contains(oe.Id))
            .ToListAsync();

        var requestedOrganisationseinheitIds = requestedOrganisationseinheiten.Select(oe => oe.Id).ToList();

        if (actingUser.Art != BackofficeNutzerArt.Superadmin) {
            var actingUserOrganisationseinheitIds = actingUser.UntereinheitPermissions
                .Where(p => p.Funktionsberechtigungen.Contains(FunktionsberechtigungInOrganisationseinheit.BackofficeDienstleisterverwaltung))
                .Select(p => p.UntereinheitId).ToImmutableHashSet();

            var currentOrganisationseinheitIds =
                dienstleister.Organisationseinheiten.Select(oe => oe.Id).ToImmutableHashSet();
            var addedOrganisationseinheitIds = requestedOrganisationseinheitIds
                .Except(currentOrganisationseinheitIds);
            var removedOrganisationseinheitIds =
                currentOrganisationseinheitIds.Except(requestedOrganisationseinheitIds).ToHashSet();

            if (!actingUserOrganisationseinheitIds.IsSupersetOf(addedOrganisationseinheitIds)) {
                throw new NotAllowedException(
                    "Sie dürfen einem Dienstleister nur dann eine Organisationseinheit zuweisen, wenn Sie in dieser " +
                    "Organisationseinheit zur Dienstleisterverwaltung berechtigt sind.");
            }

            if (!actingUserOrganisationseinheitIds.IsSupersetOf(removedOrganisationseinheitIds)) {
                throw new NotAllowedException(
                    "Sie dürfen die Zuordnung eines Dienstleisters zu einer Organisationseinheit nur entfernen, wenn Sie in dieser " +
                    "Organisationseinheit zur Dienstleisterverwaltung berechtigt sind.");
            }
        }

        dienstleister.Name = name;
        dienstleister.EMailAdressen = normalizedEMailAdressen;
        dienstleister.Organisationseinheiten = requestedOrganisationseinheiten;

        foreach (var mitarbeiter in dienstleister.Mitarbeiter) {
            mitarbeiter.UntereinheitPermissions = requestedOrganisationseinheiten.Select(oe =>
                new UntereinheitPermissions {
                    UntereinheitId = oe.Id,
                    Funktionsberechtigungen = [
                    FunktionsberechtigungInOrganisationseinheit.Backoffice,
                        FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege]
                }).ToList();
        }

        await domainContext.SaveChangesAsync();

        return dienstleister;
    }

    /// <summary>
    /// Löscht einen Dienstleister anhand seiner ID.
    /// </summary>
    /// <param name="domainContext">Datenbankkontext.</param>
    /// <param name="dienstleisterId">ID des zu löschenden Dienstleisters.</param>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <returns>Gibt zurück, ob die Löschung erfolgreich war.</returns>
    [UseMutationConvention(PayloadFieldName = "success")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> DienstleisterDelete(
        DomainContext domainContext,
        Guid dienstleisterId,
        CurrentUserAccessor currentUserAccessor
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Superadmin);

        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit
            .BackofficeDienstleisterverwaltung).Fordern();

        var dienstleister = await domainContext.Dienstleister
            .AsTracking()
            .AsSplitQuery()
            .Where(d => d.MandantId == actingUser.KommuneId && d.Id == dienstleisterId)
            .Include(dienstleister => dienstleister.Organisationseinheiten)
            .FirstOrDefaultAsync();

        if (dienstleister is null) {
            throw new NotAllowedException();
        }

        berechtigungen.InAllenOrganisationseinheiten(
            dienstleister.Organisationseinheiten.Select(oe => oe.Id),
            FunktionsberechtigungInOrganisationseinheit.BackofficeDienstleisterverwaltung
        ).Fordern();

        // TODO: prüfe, ob es Ausführungen gibt, die diesem Dienstleister zugewiesen sind.

        domainContext.Dienstleister.Remove(dienstleister);
        await domainContext.SaveChangesAsync();

        return true;
    }

    /// <summary>
    /// Lädt einen neuen Mitarbeiter für einen Dienstleister per Einladung ein.
    /// </summary>
    /// <param name="currentUserAccessor">Zugriff auf den aktuellen Benutzer.</param>
    /// <param name="email">E-Mail-Adresse des einzuladenden Mitarbeiters.</param>
    /// <param name="dienstleisterId">ID des Dienstleisters.</param>
    /// <param name="domainContext">Datenbankkontext.</param>
    /// <param name="ct">Abbruchtoken.</param>
    /// <returns>Gibt zurück, ob die Einladung erfolgreich war.</returns>
    [UseMutationConvention(PayloadFieldName = "success")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> DienstleisterMitarbeiterInvite(
        [Service] CurrentUserAccessor currentUserAccessor,
        string email,
        Guid dienstleisterId,
        DomainContext domainContext,
        CancellationToken ct
    ) {
        var dienstleister = await domainContext
            .Dienstleister
            .Include(d => d.Organisationseinheiten)
            .AsTracking()
            .FirstOrDefaultAsync(x => x.Id == dienstleisterId, ct);

        if (dienstleister == null) {
            throw new NotAllowedException();
        }

        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();

        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit
            .BackofficeDienstleisterverwaltung).Fordern();

        berechtigungen.InAllenOrganisationseinheiten(dienstleister.Organisationseinheiten.Select(oe => oe.Id),
            FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung).Fordern();

        BackofficeUser invitee;

        var existing = await domainContext.BackofficeUser
            .AsTracking()
            .Include(u => u.Gruppen)
            .AsSingleQuery()
            .FirstOrDefaultAsync(u => EF.Functions.ILike(u.EMail, email), cancellationToken: ct);

        if (existing is not null) {
            if (!existing.IsDeleted || existing.KommuneId != actingUser.KommuneId) {
                throw new NotAllowedException("Ein Nutzer mit dieser E-Mail-Adresse wurde bereits eingeladen.");
            }
            invitee = existing;
            invitee.IsDeleted = false;
        } else {
            invitee = new BackofficeUser {
                EMail = email,
                KommuneId = actingUser.KommuneId,
            };
        }

        invitee.Art = BackofficeNutzerArt.Dienstleister;
        invitee.UntereinheitPermissions = dienstleister.Organisationseinheiten.Select(oe => new UntereinheitPermissions {
            Funktionsberechtigungen = [
                FunktionsberechtigungInOrganisationseinheit.Backoffice,
                FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege],
            UntereinheitId = oe.Id,
        }).ToList();

        dienstleister.Mitarbeiter.Add(invitee);

        invitee.InvitationCode = Guid.NewGuid();

        await domainContext.SaveChangesAsync(ct);

        return true;
    }
}
