using API.Features.Aufbewahrung;
using API.Features.Auth;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using API.Utils;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;
using NodaTime;

namespace API.Features.Prozess.Mutations;

/// <summary>
/// Mutationen zum Soft-Löschen und Wiederherstellen von Anträgen (Ausführungen).
/// Nur für Backoffice-Nutzer mit der Funktionsberechtigung 'Anträge löschen' (Superadmins
/// bestehen diese Prüfung automatisch). Die endgültige Löschung erfolgt zeitversetzt per Job.
/// </summary>
[MutationType]
public class AusfuehrungLoeschenMutation {
    /// <summary>
    /// Soft-Löscht einen Antrag. Setzt <c>GeloeschtAm</c>, blendet ihn damit aus allen
    /// Ansichten aus und schreibt einen revisionssicheren Protokolleintrag.
    /// </summary>
    [UseMutationConvention(PayloadFieldName = "ausfuehrung")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(AusfuehrungNotFoundException))]
    [Authorize]
    [GraphQLDescription(
        "Soft-Löscht einen Antrag (nur mit Funktionsberechtigung 'Anträge löschen'). Der Antrag " +
        "verschwindet aus allen Ansichten und wird nach Ablauf der konfigurierten Karenzzeit per Job " +
        "endgültig gelöscht.")]
    public async Task<Ausfuehrung> AntragSoftLoeschen(
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService zustaendigkeitService,
        IClock clock,
        Guid ausfuehrungId,
        string grund,
        DomainContext db) {
        var actingUser = await EnsureBerechtigt(currentUserAccessor);

        if (string.IsNullOrWhiteSpace(grund)) {
            throw new NotAllowedException("Ein Löschgrund ist erforderlich.");
        }

        var ausfuehrung = await LoadAndAuthorize(db, ausfuehrungId, actingUser, zustaendigkeitService);

        if (ausfuehrung.GeloeschtAm != null) {
            return ausfuehrung; // bereits gelöscht – idempotent
        }

        var now = clock.GetCurrentInstant();
        ausfuehrung.GeloeschtAm = now;
        ausfuehrung.GeloeschtVonId = actingUser.Id;
        ausfuehrung.Loeschgrund = grund;

        db.AntragLoeschProtokolle.Add(new AntragLoeschProtokoll {
            AusfuehrungId = ausfuehrung.Id,
            KommuneId = ausfuehrung.ProzessVersion.Prozess.KommuneId,
            Ereignis = AntragLoeschEreignis.SoftGeloescht,
            AusgefuehrtVonId = actingUser.Id,
            AusgefuehrtVonEmail = actingUser.EMail,
            Grund = grund,
            Zeitpunkt = now,
        });

        await db.SaveChangesAsync();
        return ausfuehrung;
    }

    /// <summary>
    /// Macht eine Soft-Löschung rückgängig, solange der Antrag noch nicht endgültig gelöscht wurde.
    /// </summary>
    [UseMutationConvention(PayloadFieldName = "ausfuehrung")]
    [Error(typeof(NotAllowedException))]
    [Error(typeof(AusfuehrungNotFoundException))]
    [Authorize]
    [GraphQLDescription("Macht eine Soft-Löschung rückgängig (nur mit Funktionsberechtigung 'Anträge löschen'), solange der Antrag noch nicht endgültig gelöscht wurde.")]
    public async Task<Ausfuehrung> AntragWiederherstellen(
        [Service] CurrentUserAccessor currentUserAccessor,
        [Service] AusfuehrungZustaendigkeitService zustaendigkeitService,
        IClock clock,
        Guid ausfuehrungId,
        DomainContext db) {
        var actingUser = await EnsureBerechtigt(currentUserAccessor);

        var ausfuehrung = await LoadAndAuthorize(db, ausfuehrungId, actingUser, zustaendigkeitService);

        if (ausfuehrung.GeloeschtAm == null) {
            return ausfuehrung; // nicht gelöscht – idempotent
        }

        var now = clock.GetCurrentInstant();
        ausfuehrung.GeloeschtAm = null;
        ausfuehrung.GeloeschtVonId = null;
        ausfuehrung.Loeschgrund = null;

        db.AntragLoeschProtokolle.Add(new AntragLoeschProtokoll {
            AusfuehrungId = ausfuehrung.Id,
            KommuneId = ausfuehrung.ProzessVersion.Prozess.KommuneId,
            Ereignis = AntragLoeschEreignis.Wiederhergestellt,
            AusgefuehrtVonId = actingUser.Id,
            AusgefuehrtVonEmail = actingUser.EMail,
            Zeitpunkt = now,
        });

        await db.SaveChangesAsync();
        return ausfuehrung;
    }

    private static async Task<BackofficeUser> EnsureBerechtigt(CurrentUserAccessor currentUserAccessor) {
        var (actingUser, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
        // Steuerbar pro Nutzer über die Funktionsberechtigung 'Anträge löschen'.
        // Superadmins bestehen diese Prüfung automatisch.
        berechtigungen.Global(GlobaleFunktionsberechtigung.AntragLoeschung).Fordern();
        // Wie in der Live-Antragsliste: wer keine Anträge sehen darf, darf auch keine löschen/wiederherstellen.
        berechtigungen.InBeliebigerOrganisationseinheit(FunktionsberechtigungInOrganisationseinheit.BackofficeAntraege)
            .Fordern();
        return actingUser;
    }

    private static async Task<Ausfuehrung> LoadAndAuthorize(DomainContext db, Guid ausfuehrungId,
        BackofficeUser actingUser, AusfuehrungZustaendigkeitService zustaendigkeitService) {
        var ausfuehrung = await db.Ausfuehrungen.AsTracking()
            .Include(a => a.ProzessVersion).ThenInclude(pv => pv.Prozess)
            .FirstOrDefaultAsync(a => a.Id == ausfuehrungId)
            ?? throw new AusfuehrungNotFoundException();

        // Mandantentrennung: nur Anträge der eigenen Kommune
        if (ausfuehrung.ProzessVersion.Prozess.KommuneId != actingUser.KommuneId) {
            throw new NotAllowedException("Der Antrag gehört nicht zu Ihrer Kommune.");
        }

        // Wie in der Live-Antragsliste: nur zuständige Nutzer dürfen löschen/wiederherstellen
        // (Superadmins bestehen IstZustaendigFuerAusfuehrung immer).
        if (!await zustaendigkeitService.IstZustaendigFuerAusfuehrung(actingUser, ausfuehrung)) {
            throw new NotAllowedException("Sie sind für diesen Antrag nicht zuständig.");
        }

        return ausfuehrung;
    }
}
