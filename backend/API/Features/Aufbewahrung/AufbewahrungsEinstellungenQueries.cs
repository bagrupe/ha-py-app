using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Aufbewahrung;

/// <summary>Liefert die globalen Aufbewahrungs-/Lösch-Einstellungen. Berechtigung 'Aufbewahrung verwalten' erforderlich.</summary>
[QueryType]
public class AufbewahrungsEinstellungenQueries {
    [Error(typeof(NotAllowedException))]
    [Authorize]
    [GraphQLDescription("Liefert die globalen Aufbewahrungs-/Lösch-Einstellungen. Berechtigung 'Aufbewahrung verwalten' erforderlich.")]
    public async Task<AufbewahrungsEinstellungen> GetAufbewahrungsEinstellungen(
        [Service] CurrentUserAccessor currentUserAccessor,
        DomainContext db) {
        var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        // Steuerbar pro Nutzer über die Funktionsberechtigung 'Aufbewahrung verwalten'.
        berechtigungen.Global(GlobaleFunktionsberechtigung.AufbewahrungVerwaltung).Fordern();

        return await db.AufbewahrungsEinstellungen
                   .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId)
               ?? new AufbewahrungsEinstellungen();
    }
}
