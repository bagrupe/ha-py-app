using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Aufbewahrung.Mutations;

/// <summary>Mutation zum Ändern der globalen Aufbewahrungs-/Lösch-Einstellungen. Berechtigung 'Aufbewahrung verwalten' erforderlich.</summary>
[MutationType]
public class AufbewahrungsEinstellungenMutation {
    [UseMutationConvention(PayloadFieldName = "einstellungen")]
    [Error(typeof(NotAllowedException))]
    [Authorize]
    [GraphQLDescription(
        "Aktualisiert die globalen Aufbewahrungs-/Lösch-Einstellungen (Berechtigung 'Aufbewahrung verwalten' erforderlich). " +
        "Fristen in Minuten – die UI rechnet Stunden/Tage um.")]
    public async Task<AufbewahrungsEinstellungen> AufbewahrungsEinstellungenAktualisieren(
        [Service] CurrentUserAccessor currentUserAccessor,
        IClock clock,
        int hardDeleteVerzoegerungMinuten,
        int archivVerzoegerungMinuten,
        bool hardDeleteAktiv,
        bool archivierungAktiv,
        DomainContext db) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        // Steuerbar pro Nutzer über die Funktionsberechtigung 'Aufbewahrung verwalten'.
        berechtigungen.Global(GlobaleFunktionsberechtigung.AufbewahrungVerwaltung).Fordern();

        if (hardDeleteVerzoegerungMinuten < 0 || archivVerzoegerungMinuten < 0) {
            throw new NotAllowedException("Fristen dürfen nicht negativ sein.");
        }

        var einstellungen = await db.AufbewahrungsEinstellungen.AsTracking()
            .FirstOrDefaultAsync(e => e.Id == AufbewahrungsEinstellungen.SingletonId);
        if (einstellungen is null) {
            einstellungen = new AufbewahrungsEinstellungen { Id = AufbewahrungsEinstellungen.SingletonId };
            db.AufbewahrungsEinstellungen.Add(einstellungen);
        }

        einstellungen.HardDeleteVerzoegerungMinuten = hardDeleteVerzoegerungMinuten;
        einstellungen.ArchivVerzoegerungMinuten = archivVerzoegerungMinuten;
        einstellungen.HardDeleteAktiv = hardDeleteAktiv;
        einstellungen.ArchivierungAktiv = archivierungAktiv;
        einstellungen.AktualisiertVonId = actingUser.Id;
        einstellungen.AktualisiertAm = clock.GetCurrentInstant();

        await db.SaveChangesAsync();
        return einstellungen;
    }
}
