using API.Features.Auth;
using API.Features.Prozess;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage;

[GraphQLDescription("Stand einer LageHelfer-Meldung, wie ihn Leitstelle und Einsatzleitung sehen.")]
public enum EreignisStatus {
    [GraphQLDescription("Eingegangen, noch keiner Einheit zugewiesen.")]
    Eingegangen,

    [GraphQLDescription("Einer Einheit zugewiesen, Hilfe noch nicht eingeleitet.")]
    Zugewiesen,

    [GraphQLDescription("Hilfe eingeleitet (Bürger:innen sehen \"Hilfe ist unterwegs\").")]
    InBearbeitung,

    [GraphQLDescription("Von der Einsatzleitung an die Leitstelle abgegeben.")]
    InKlaerung,

    [GraphQLDescription("Einsatz abgeschlossen.")]
    Erledigt,

    [GraphQLDescription("Von der Leitstelle mit Begründung verworfen.")]
    Verworfen,
}

public class MeldungNotFoundException()
    : DomainException("Die Meldung existiert nicht oder gehört zu keiner Lage.");

public class MeldungAbgeschlossenException()
    : DomainException("Die Meldung ist bereits abgeschlossen.");

public class BegruendungErforderlichException()
    : DomainException("Bitte eine Begründung angeben.");

public static class LageMeldungen {
    public const string MeldungsnummerSequence = "Meldungsnummern";

    public static Task<int> NextMeldungsnummer(DomainContext db, CancellationToken ct) =>
        db.Database.SqlQueryRaw<int>($"SELECT nextval('\"{MeldungsnummerSequence}\"')::int AS \"Value\"")
            .SingleAsync(ct);

    /// <summary>Admins and Superadmins act as Leitstelle and see every report of their Kommune.</summary>
    public static bool IstLeitstelle(BackofficeUser user) =>
        user.Art is BackofficeNutzerArt.Admin or BackofficeNutzerArt.Superadmin;

    public static IQueryable<Ausfuehrung> OfKommune(DomainContext db, Guid kommuneId) =>
        db.Ausfuehrungen.NotDeleted()
            .Where(a => a.LageGebiet != null && a.LageGebiet.Lage.Untereinheit.KommuneId == kommuneId);

    /// <summary>Reports the caller may see: all for the Leitstelle, otherwise those of the caller's groups.</summary>
    public static IQueryable<Ausfuehrung> SichtbarFuer(DomainContext db, BackofficeUser user) {
        var query = OfKommune(db, user.KommuneId);
        if (IstLeitstelle(user)) {
            return query;
        }

        var gruppenIds = user.Gruppen.Select(g => g.Id).ToList();
        return query.Where(a => a.IstZustaendigkeit.MitarbeiterGruppeId != null
            && gruppenIds.Contains(a.IstZustaendigkeit.MitarbeiterGruppeId.Value));
    }

    public static async Task<Ausfuehrung> TrackedOffeneMeldung(DomainContext db, BackofficeUser user,
        Guid ausfuehrungId, bool nurLeitstelle, CancellationToken ct) {
        if (nurLeitstelle && !IstLeitstelle(user)) {
            throw new NotAllowedException("Nur die Leitstelle kann diese Aktion ausführen.");
        }

        var meldung = await SichtbarFuer(db, user).AsTracking()
            .SingleOrDefaultAsync(a => a.Id == ausfuehrungId, ct) ?? throw new MeldungNotFoundException();
        if (meldung.Status == AusfuehrungStatus.Abgeschlossen) {
            throw new MeldungAbgeschlossenException();
        }

        return meldung;
    }

    public static string PflichtText(string? text) =>
        string.IsNullOrWhiteSpace(text) ? throw new BegruendungErforderlichException() : text.Trim();

    public static async Task<Dictionary<Guid, EreignisStatus>> ErmittleStatus(DomainContext db,
        IReadOnlyCollection<Guid> ausfuehrungIds, CancellationToken ct) {
        var meldungen = await db.Ausfuehrungen
            .Where(a => ausfuehrungIds.Contains(a.Id))
            .Select(a => new { a.Id, a.Status, a.VerwerfenGrund, a.KlaerungSeit, a.EinheitId })
            .ToListAsync(ct);
        var hilfeUnterwegs = (await db.Bearbeitungen
                .Where(b => ausfuehrungIds.Contains(b.AusfuehrungId)
                    && b.NextVerbindung.StatusAenderung == MeldungStatusErmittlung.StatusTextHilfeUnterwegs)
                .Select(b => b.AusfuehrungId)
                .ToListAsync(ct))
            .ToHashSet();

        return meldungen.ToDictionary(m => m.Id, m =>
            m.VerwerfenGrund is not null ? EreignisStatus.Verworfen
            : m.Status == AusfuehrungStatus.Abgeschlossen ? EreignisStatus.Erledigt
            : m.KlaerungSeit is not null ? EreignisStatus.InKlaerung
            : hilfeUnterwegs.Contains(m.Id) ? EreignisStatus.InBearbeitung
            : m.EinheitId is not null ? EreignisStatus.Zugewiesen
            : EreignisStatus.Eingegangen);
    }
}
