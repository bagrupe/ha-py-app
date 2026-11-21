using API.Features.Expressions;
using API.Features.Geo;
using HotChocolate.Authorization;

namespace API.Features.Lage.Queries;

[QueryType]
public static class PublicLageQueries {
    [AllowAnonymous]
    [GraphQLDescription(
        "Lagen der Kommune, zu denen gerade gemeldet werden kann, mit ihren Gebieten. Ohne Anmeldung abrufbar.")]
    public static async Task<IReadOnlyList<PublicLage>> GetActiveLagen(Guid kommuneId, DomainContext db,
        CancellationToken ct) =>
        (await LiveLageGebiete.OfKommune(db, kommuneId, ct))
        .GroupBy(p => (p.LageId, p.LageTitle, p.WarningText))
        .OrderBy(g => g.Key.LageTitle)
        .Select(g => new PublicLage(g.Key.LageId, g.Key.LageTitle, g.Key.WarningText,
            g.OrderBy(p => p.GebietName).Select(p => new PublicGebiet(p.GebietId, p.GebietName, p.Geometry)).ToList()))
        .ToList();

    [AllowAnonymous]
    [GraphQLDescription(
        "Schlägt Lage und Gebiet für Koordinaten vor, etwa den aktuellen Standort des Geräts. Leer, wenn dort " +
        "keine Lage Meldungen annimmt. Ohne Anmeldung abrufbar.")]
    public static async Task<IReadOnlyList<GebietSuggestion>> GetSuggestedGebiete(Guid kommuneId, double longitude,
        double latitude, DomainContext db, CancellationToken ct) {
        var point = new EvaluatingVisitor.ParsedLocation(longitude, latitude);
        return (await LiveLageGebiete.OfKommune(db, kommuneId, ct))
            .Where(p => p.Geometry is not null && GeoJsonGeometry.Contains(p.Geometry, point))
            .OrderBy(p => p.LageTitle).ThenBy(p => p.GebietName)
            .Select(p => new GebietSuggestion(p.LageId, p.LageTitle, p.GebietId, p.GebietName))
            .ToList();
    }
}
