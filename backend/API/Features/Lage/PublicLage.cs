using System.Text.Json;
using API.Features.Prozess;
using API.Features.Prozess.ProgrammatischeSchritte;
using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage;

[GraphQLDescription("Lage, zu der Bürger:innen gerade melden können. Enthält nur öffentliche Angaben.")]
public record PublicLage(
    Guid Id,
    string Title,
    string? WarningText,
    [property: GraphQLDescription("Gebiete der Lage, die gerade Meldungen annehmen.")]
    IReadOnlyList<PublicGebiet> Gebiete,
    [property: GraphQLDescription("Noch nicht abgeschlossene Meldungen der Lage, neueste zuerst.")]
    IReadOnlyList<PublicMeldung> Meldungen);

[GraphQLDescription(
    "Noch nicht abgeschlossene Meldung einer Lage, etwa als Pin auf der Karte oder als Vorlage für eine eigene " +
    "Meldung. Enthält bewusst keine Kennung und keine persönlichen Angaben.")]
public record PublicMeldung(
    [property: GraphQLDescription("Öffentliche Kennung für meldungBestaetigen. Nicht die interne Antrags-Id.")]
    Guid Id,
    MeldungStatus Status,
    [property: GraphQLDescription("Anzeigetext zum Status, z. B. \"Hilfe ist unterwegs\".")]
    string StatusText,
    string? Description,
    string? Kategorie,
    double Longitude,
    double Latitude,
    [property: GraphQLDescription("Anzahl der Bestätigungen (\"+1 · Sehe ich auch\").")]
    int AnzahlBestaetigungen);

[GraphQLDescription("Gebiet (Region) einer Lage, das gerade Meldungen annimmt.")]
public record PublicGebiet(
    Guid Id,
    string Name,
    [property: GraphQLDescription("Fläche als GeoJSON (Polygon oder MultiPolygon).")]
    string? Geometry);

[GraphQLDescription("Vorschlag für Lage und Gebiet anhand von Koordinaten.")]
public record GebietSuggestion(Guid LageId, string LageTitle, Guid GebietId, string GebietName);

[GraphQLDescription("Von der meldenden Person gewählte Lage und Gebiet.")]
public record LageSelectionInput(Guid LageId, Guid GebietId);

public class LageGebietNotLiveException()
    : DomainException("In diesem Gebiet nimmt die gewählte Lage gerade keine Meldungen an.");

/// <summary>Lage passes that accept reports right now (<see cref="LageGebietStateMachine.AcceptsMeldungen"/>).</summary>
public static class LiveLageGebiete {
    public record Pass(
        Guid Id, Guid LageId, string LageTitle, string? WarningText, Guid GebietId, string GebietName,
        string? Geometry, Guid KommuneId, LageGebietStatus Status);

    public static async Task<List<Pass>> OfKommune(DomainContext db, Guid kommuneId, CancellationToken ct) =>
        FilterLive(await Project(OpenPasses(db).Where(lg => lg.Lage.Untereinheit.KommuneId == kommuneId))
            .ToListAsync(ct));

    public static async Task<Pass?> Find(DomainContext db, Guid lageId, Guid gebietId, CancellationToken ct) =>
        FilterLive(await Project(OpenPasses(db).Where(lg => lg.LageId == lageId && lg.GebietId == gebietId))
            .ToListAsync(ct)).SingleOrDefault();

    private static IQueryable<LageGebiet> OpenPasses(DomainContext db) =>
        db.LageGebiete.Where(lg => lg.Lage.Status != LageStatus.Closed && lg.Lage.DeletedAt == null
            && lg.Lage.MeldewegPausiertSeit == null);

    private static IQueryable<Pass> Project(IQueryable<LageGebiet> passes) =>
        passes.Select(lg => new Pass(lg.Id, lg.LageId, lg.Lage.Title, lg.Lage.WarningText, lg.GebietId,
            lg.Gebiet.Name, lg.Gebiet.Geometry, lg.Lage.Untereinheit.KommuneId, lg.Status));

    // AcceptsMeldungen is plain C#; filtering after loading keeps it the single source of truth.
    private static List<Pass> FilterLive(List<Pass> passes) =>
        passes.Where(p => LageGebietStateMachine.AcceptsMeldungen(p.Status)).ToList();
}

/// <summary>Open LageHelfer reports reduced to what may be shown publicly.</summary>
public static class OpenMeldungen {
    public const string StandortSlot = GebietEinsatzleitungZustaendigkeitSchritt.StandortSlotName;
    public const string BeschreibungSlot = "beschreibung";
    public const string KategorieSlot = "kategorie";

    public static async Task<ILookup<Guid, PublicMeldung>> OfLagen(DomainContext db, IReadOnlyCollection<Guid> lageIds,
        CancellationToken ct) {
        var meldungen = await db.Ausfuehrungen.NotDeleted()
            .Where(a => a.LageGebiet != null && lageIds.Contains(a.LageGebiet.LageId)
                && a.Status != AusfuehrungStatus.Abgeschlossen)
            .Where(a => a.PublicId != null)
            .Select(a => new { a.Id, PublicId = a.PublicId!.Value, a.LageGebiet!.LageId, a.CreatedAt })
            .ToListAsync(ct);
        var ids = meldungen.Select(m => m.Id).ToList();

        var slots = (await db.PlainSlotValues
                .Where(sv => ids.Contains(sv.Bearbeitung.AusfuehrungId)
                    && (sv.SlotName == StandortSlot || sv.SlotName == BeschreibungSlot || sv.SlotName == KategorieSlot))
                .Select(sv => new { sv.Bearbeitung.AusfuehrungId, sv.Bearbeitung.CreatedAt, sv.SlotName, sv.Value })
                .ToListAsync(ct))
            .GroupBy(sv => (sv.AusfuehrungId, sv.SlotName))
            .ToDictionary(g => g.Key, g => g.MaxBy(sv => sv.CreatedAt)!.Value);

        var status = await MeldungStatusErmittlung.Ermittle(db, ids, ct);
        var bestaetigungen = await db.MeldungBestaetigungen
            .Where(b => ids.Contains(b.AusfuehrungId))
            .GroupBy(b => b.AusfuehrungId)
            .Select(g => new { AusfuehrungId = g.Key, Anzahl = g.Count() })
            .ToDictionaryAsync(g => g.AusfuehrungId, g => g.Anzahl, ct);

        return meldungen
            .OrderByDescending(m => m.CreatedAt)
            .Select(m => (m.LageId, Meldung: ToPublic(m.Id, m.PublicId)))
            .Where(m => m.Meldung is not null)
            .ToLookup(m => m.LageId, m => m.Meldung!);

        PublicMeldung? ToPublic(Guid id, Guid publicId) {
            if (!slots.TryGetValue((id, StandortSlot), out var standort)
                || standort.ValueKind != JsonValueKind.Object
                || !standort.TryGetProperty("coordinates", out var coordinates)) {
                return null;
            }

            return new PublicMeldung(publicId, status[id], MeldungStatusErmittlung.Text(status[id]),
                Text(id, BeschreibungSlot), Text(id, KategorieSlot), coordinates[0].GetDouble(),
                coordinates[1].GetDouble(), bestaetigungen.GetValueOrDefault(id));
        }

        string? Text(Guid id, string slotName) =>
            slots.TryGetValue((id, slotName), out var value) && value.ValueKind == JsonValueKind.String
                ? value.GetString()
                : null;
    }
}
