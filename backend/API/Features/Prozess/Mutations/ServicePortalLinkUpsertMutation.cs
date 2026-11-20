using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess.Mutations;

/// <summary>Stellt eine Mutation zum Erstellen oder Aktualisieren eines Links zu einem externen Service-Portal bereit.</summary>
[MutationType]
public class ServicePortalLinkUpsertMutation {
    /// <summary>Erstellt einen neuen oder aktualisiert einen bestehenden ServicePortalLink anhand der URL, des Namens und optionaler Id.</summary>
    /// <param name="url">Die URL des Service-Portals.</param>
    /// <param name="name">Der Name des Links.</param>
    /// <param name="id">Die optionale Id des bestehenden Links.</param>
    /// <param name="db">Der Datenbankkontext.</param>
    /// <param name="userAccessor">Zugriff auf den aktuell angemeldeten Benutzer.</param>
    /// <returns>Den erstellten oder aktualisierten ServicePortalLink.</returns>
    [Authorize]
    [GraphQLDescription("Erstellt oder aktualisiert einen Link auf ein externes Service-Portal.")]
    public async Task<ServicePortalLink> ServicePortalLinkUpsert(string url, string name, Guid? id, DomainContext db, CurrentUserAccessor userAccessor) {
        var (backofficeUser, berechtigungen) = await userAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var link = new ServicePortalLink { Name = name, KommuneId = backofficeUser.KommuneId };

        if (id.HasValue) {
            link =
                await db.ServicePortalLink.AsTracking().FirstOrDefaultAsync(l =>
                    l.KommuneId == backofficeUser.KommuneId && l.Id == id.Value);
            if (link is null) throw new ServicePortalLinkNotFoundException();
        }

        link.Url = url;
        link.Name = name;

        if (!id.HasValue) {
            db.ServicePortalLink.Add(link);
        }

        await db.SaveChangesAsync();

        return link;
    }

    [Error(typeof(NotAllowedException))]
    [Error(typeof(ServicePortalLinkNotFoundException))]
    [Authorize]
    [GraphQLDescription("Löscht einen Link auf ein externes Service-Portal.")]
    public async Task<ServicePortalLink> DeleteServicePortalLink(
        DeleteServicePortalLinkInput deleteServicePortalLinkInput, DomainContext db, CurrentUserAccessor userAccessor
    ) {
        var (backofficeUser, berechtigungen) = await userAccessor.EnsureBackofficeUser(BackofficeNutzerArt.Admin);
        berechtigungen.Global(GlobaleFunktionsberechtigung.Prozessverwaltung).Fordern();

        var link = await db.ServicePortalLink.AsTracking().FirstOrDefaultAsync(l =>
            l.KommuneId == backofficeUser.KommuneId && l.Id == deleteServicePortalLinkInput.Id) ??
            throw new ServicePortalLinkNotFoundException();

        db.Remove(link);
        await db.SaveChangesAsync();

        return link;
    }
}

public record DeleteServicePortalLinkInput(Guid Id);

/// <summary>Wird ausgelöst, wenn ein ServicePortalLink nicht gefunden wird.</summary>
public class ServicePortalLinkNotFoundException(string message = "ServicePortalLink not found") : DomainException(message);
