using API.Features.Funktionsberechtigungen;
using API.Features.Untereinheit;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation zum Einladen eines Backoffice-Nutzers. 
/// Überprüft Berechtigungen, erstellt oder reaktiviert den Nutzer und generiert einen Einladungscode.
/// </summary>
[MutationType]
public class InviteMutation {
    /// <summary>
    /// Führt die Einladung eines Backoffice-Nutzers durch. 
    /// Überprüft die Berechtigungen des einladenden Nutzers, erstellt oder reaktiviert den eingeladenen Nutzer und weist ihm die entsprechenden Gruppen und Organisationseinheiten zu.
    /// </summary>
    /// <param name="currentUserAccessor">Service zum Abrufen des aktuellen Nutzers.</param>
    /// <param name="email">E-Mail-Adresse des einzuladenden Nutzers.</param>
    /// <param name="art">Art des Backoffice-Nutzers (z. B. Admin, Superadmin).</param>
    /// <param name="organisationseinheitIds">IDs der Organisationseinheiten, denen der Nutzer zugeordnet werden soll.</param>
    /// <param name="abteilungIds">IDs der Abteilungen, denen der Nutzer zugeordnet werden soll.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf die Nutzerdaten.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Gibt true zurück, wenn die Einladung erfolgreich war.</returns>
    [UseMutationConvention(PayloadFieldName = "success")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    public async Task<bool> InviteBackofficeUser(
        [Service] CurrentUserAccessor currentUserAccessor,
        string email,
        BackofficeNutzerArt art,
        HashSet<Guid> organisationseinheitIds,
        HashSet<Guid> abteilungIds,
        DomainContext domainContext,
        CancellationToken ct
    ) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);

        berechtigungen
            .InAllenOrganisationseinheiten(organisationseinheitIds, FunktionsberechtigungInOrganisationseinheit.BackofficeNutzendenverwaltung)
            .Fordern();

        if (actingUser.Art != BackofficeNutzerArt.Superadmin) {
            switch (art) {
                case BackofficeNutzerArt.Superadmin:
                    throw new NotAllowedException("Ein Superadmin kann nur von einem anderen Superadmin eingeladen werden.");
                case BackofficeNutzerArt.Admin:
                    throw new NotAllowedException("Ein Admin kann nur von einem Superadmin eingeladen werden.");
            }

            var actingUserOrganisationseinheitIds = actingUser.UntereinheitPermissions.Select(p => p.UntereinheitId).ToHashSet();

            if (!actingUserOrganisationseinheitIds.IsSupersetOf(organisationseinheitIds)) {
                throw new NotAllowedException("Sie sind nicht berechtigt, Nutzer in eine der ausgewählten Organisationseinheiten einzuladen.");
            }
        }

        var existing = await domainContext.Mitarbeiter
            .AsTracking()
            .Include(u => u.Gruppen)
            .AsSingleQuery()
            .FirstOrDefaultAsync(u => EF.Functions.ILike(u.EMail, email), ct);

        BackofficeUser invitee;

        if (existing is not null) {
            if (existing.InvitationCode is not null) {
                throw new NotAllowedException("Ein Nutzer mit dieser E-Mail-Adresse wurde bereits eingeladen.");
            }

            if (existing is not BackofficeUser existingBackofficeUser) {
                throw new NotAllowedException("Ein Nutzer ist bereits mit dieser E-Mail-Adresse registriert.");
            }

            switch (existing.IsDeleted) {
                case false:
                // Verhindere Reaktivierung des Nutzers für einen anderen Mandanten
                case true when existing.KommuneId != actingUser.KommuneId:
                    throw new NotAllowedException("Ein Nutzer ist bereits mit dieser E-Mail-Adresse registriert.");
                case true:
                    invitee = existingBackofficeUser;
                    invitee.IsDeleted = false;
                    break;
            }
        } else {
            invitee = new BackofficeUser {
                EMail = email,
                KommuneId = actingUser.KommuneId,
            };
            domainContext.BackofficeUser.Add(invitee);
        }

        var requestedGruppen = await domainContext.MitarbeiterGruppen
            .AsTracking()
            .Where(g => abteilungIds.Contains(g.Id))
            .ToListAsync(ct);

        invitee.OrganisationPrivateKey = null;
        invitee.IsSyncedToBereichB = false;
        invitee.Art = art;
        invitee.Vorname = "";
        invitee.Nachname = "";
        invitee.Gruppen = requestedGruppen;
        invitee.UntereinheitPermissions = organisationseinheitIds
            .Select(id => new UntereinheitPermissions { UntereinheitId = id }).ToList();
        invitee.InvitationCode = Guid.NewGuid();

        await domainContext.SaveChangesAsync(ct);

        return true;
    }
}
