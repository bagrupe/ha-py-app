using API.Features.Auth;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Prozess;

[GraphQLDescription("Stand einer Meldung, wie ihn die meldende Person sieht.")]
public enum MeldungStatus {
    [GraphQLDescription("Eingegangen, noch nicht von der Einsatzleitung übernommen.")]
    Eingegangen,

    [GraphQLDescription("Von der Einsatzleitung übernommen oder bereits bearbeitet.")]
    InBearbeitung,

    [GraphQLDescription("Die Einsatzleitung hat Hilfe eingeleitet.")]
    HilfeUnterwegs,

    [GraphQLDescription("Abgeschlossen, es folgen keine weiteren Änderungen.")]
    Abgeschlossen,
}

/// <summary>Derives <see cref="MeldungStatus"/> from engine state, so the app never has to read engine internals.</summary>
public static class MeldungStatusErmittlung {
    /// <summary>The Verbindung label that marks help as dispatched; the LageHelfer template uses it verbatim.</summary>
    public const string StatusTextHilfeUnterwegs = "Hilfe ist unterwegs";

    public static string Text(MeldungStatus status) => status switch {
        MeldungStatus.Eingegangen => "Meldung ist eingegangen",
        MeldungStatus.InBearbeitung => "Meldung wird bearbeitet",
        MeldungStatus.HilfeUnterwegs => StatusTextHilfeUnterwegs,
        MeldungStatus.Abgeschlossen => "Abgeschlossen",
        _ => throw new ArgumentOutOfRangeException(nameof(status), status, null),
    };

    public static async Task<Dictionary<Guid, MeldungStatus>> Ermittle(DomainContext db,
        IReadOnlyCollection<Guid> ausfuehrungIds, CancellationToken ct) {
        var ausfuehrungen = await db.Ausfuehrungen
            .Where(a => ausfuehrungIds.Contains(a.Id))
            .Select(a => new { a.Id, a.Status, Zugewiesen = a.IstZustaendigkeit.ZugewiesenePersonId != null })
            .ToListAsync(ct);
        // Steps done by staff, e.g. saving a priority; the submitter and automatic steps act as other users.
        var bearbeitetVonMitarbeitenden = (await db.Bearbeitungen
                .Where(b => ausfuehrungIds.Contains(b.AusfuehrungId) && b.User is Mitarbeiter)
                .Select(b => b.AusfuehrungId)
                .ToListAsync(ct))
            .ToHashSet();
        var hilfeUnterwegs = (await db.Bearbeitungen
                .Where(b => ausfuehrungIds.Contains(b.AusfuehrungId)
                    && b.NextVerbindung.StatusAenderung == StatusTextHilfeUnterwegs)
                .Select(b => b.AusfuehrungId)
                .ToListAsync(ct))
            .ToHashSet();
        var uebernommen = (await db.VerlaufsEintraege
                .Where(v => ausfuehrungIds.Contains(v.AusfuehrungId) && v.Art == VerlaufsEreignisArt.Uebernahme)
                .Select(v => v.AusfuehrungId)
                .ToListAsync(ct))
            .ToHashSet();

        return ausfuehrungen.ToDictionary(a => a.Id, a =>
            a.Status == AusfuehrungStatus.Abgeschlossen ? MeldungStatus.Abgeschlossen
            : hilfeUnterwegs.Contains(a.Id) ? MeldungStatus.HilfeUnterwegs
            : a.Zugewiesen || uebernommen.Contains(a.Id) || bearbeitetVonMitarbeitenden.Contains(a.Id)
                ? MeldungStatus.InBearbeitung
            : MeldungStatus.Eingegangen);
    }
}
