using API.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Lage;

[GraphQLDescription("Lage, zu der Bürger:innen gerade melden können. Enthält nur öffentliche Angaben.")]
public record PublicLage(
    Guid Id,
    string Title,
    string? WarningText,
    [property: GraphQLDescription("Gebiete der Lage, die gerade Meldungen annehmen.")]
    IReadOnlyList<PublicGebiet> Gebiete);

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
        db.LageGebiete.Where(lg => lg.Lage.Status != LageStatus.Closed && lg.Lage.DeletedAt == null);

    private static IQueryable<Pass> Project(IQueryable<LageGebiet> passes) =>
        passes.Select(lg => new Pass(lg.Id, lg.LageId, lg.Lage.Title, lg.Lage.WarningText, lg.GebietId,
            lg.Gebiet.Name, lg.Gebiet.Geometry, lg.Lage.Untereinheit.KommuneId, lg.Status));

    // AcceptsMeldungen is plain C#; filtering after loading keeps it the single source of truth.
    private static List<Pass> FilterLive(List<Pass> passes) =>
        passes.Where(p => LageGebietStateMachine.AcceptsMeldungen(p.Status)).ToList();
}
