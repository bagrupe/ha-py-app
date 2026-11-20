using API.Features.Auth;
using API.Features.Ehrenamtsbank.Mutations;
using API.Features.Funktionsberechtigungen;
using API.Infrastructure;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank.Queries;

/// <summary>Filter der öffentlichen Suche. Kategorien werden als exakte Id-Liste erwartet;
/// der Client expandiert den Baum selbst (siehe ehrenamtsbankKategorien).</summary>
public record EhrenamtsbankEintragFilterInput(
    EhrenamtsbankEintragTyp? Typ,
    List<Guid>? KategorieIds,
    List<Guid>? UntereinheitIds,
    string? SearchText,
    [property: GraphQLDescription(
        "Nur mit globaler Funktionsberechtigung Ehrenamtsbank auf etwas anderem als Active setzbar.")]
    EhrenamtsbankEintragStatus? Status,
    [property: GraphQLDescription(
        "Standort des Suchenden; filtert nur zusammen mit maxDistanceKm (für die Anzeige denselben "
        + "Wert an distanceKm übergeben).")]
    GeoCoordinateInput? Origin,
    [property: GraphQLDescription(
        "Maximale Luftlinie in Kilometern (> 0, nur mit origin); Einträge ohne Koordinaten entfallen.")]
    double? MaxDistanceKm
);

public class EintragNotFoundException : DomainException {
    public EintragNotFoundException() : base("Eintrag nicht gefunden.") { }
}

[QueryType]
public class EintragQueries {
    /// <summary>Öffentliche Suche über Ehrenamtsbank-Einträge. Liefert ohne Status-Filter
    /// ausschließlich aktive, nicht gelöschte Einträge, neueste zuerst.</summary>
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [AllowAnonymous]
    public async Task<IQueryable<EhrenamtsbankEintrag>> GetEhrenamtsbankEintraege(
        EhrenamtsbankEintragFilterInput? filter, DomainContext db, CurrentUserAccessor currentUserAccessor) {
        var status = filter?.Status ?? EhrenamtsbankEintragStatus.Active;
        if (status != EhrenamtsbankEintragStatus.Active) {
            var (_, berechtigungen) = await currentUserAccessor.EnsureBackofficeUser();
            berechtigungen.Global(GlobaleFunktionsberechtigung.Ehrenamtsbank).Fordern();
        }

        var query = db.EhrenamtsbankEintraege.Where(e => !e.IsDeleted && e.Status == status);
        if (filter?.Typ is { } typ) {
            query = query.Where(e => e.Typ == typ);
        }

        if (filter?.KategorieIds is { Count: > 0 } kategorieIds) {
            query = query.Where(e => kategorieIds.Contains(e.KategorieId));
        }

        if (filter?.UntereinheitIds is { Count: > 0 } untereinheitIds) {
            query = query.Where(e => untereinheitIds.Contains(e.UntereinheitId));
        }

        if (!string.IsNullOrWhiteSpace(filter?.SearchText)) {
            var pattern = $"%{filter.SearchText}%";
            query = query.Where(e =>
                EF.Functions.ILike(e.Title, pattern) || EF.Functions.ILike(e.Description, pattern));
        }

        if (filter?.Origin is { } origin) {
            EhrenamtsbankLocationValidation.ValidateCoordinates(origin.Latitude, origin.Longitude);
        }

        if (filter?.MaxDistanceKm is { } maxDistanceKm) {
            if (filter.Origin is not { } filterOrigin) {
                throw new EintragValidationException(
                    "Eine Maximalentfernung ist nur zusammen mit einem Standort auswertbar.");
            }

            if (!double.IsFinite(maxDistanceKm) || maxDistanceKm <= 0) {
                throw new EintragValidationException(
                    "Die Maximalentfernung muss eine endliche Zahl größer als 0 sein.");
            }

            // Same Haversine as GeoDistance.CalculateKm, inlined: Npgsql cannot translate
            // double.DegreesToRadians or Math.Clamp, and calling the method would load every row.
            const double bogenmass = Math.PI / 180;
            var originBreiteRad = filterOrigin.Latitude * bogenmass;
            var originLaengeRad = filterOrigin.Longitude * bogenmass;
            var cosOriginBreite = Math.Cos(originBreiteRad);

            query = query.Where(e =>
                e.Latitude != null && e.Longitude != null
                && 2 * GeoDistance.EarthRadiusKm * Math.Asin(Math.Sqrt(Math.Min(1d, Math.Max(0d,
                    Math.Sin((e.Latitude.Value * bogenmass - originBreiteRad) / 2)
                    * Math.Sin((e.Latitude.Value * bogenmass - originBreiteRad) / 2)
                    + cosOriginBreite * Math.Cos(e.Latitude.Value * bogenmass)
                    * Math.Sin((e.Longitude.Value * bogenmass - originLaengeRad) / 2)
                    * Math.Sin((e.Longitude.Value * bogenmass - originLaengeRad) / 2)))))
                <= maxDistanceKm);
        }

        return query.OrderByDescending(e => e.CreatedAt).ThenBy(e => e.Id);
    }

    /// <summary>Alle eigenen Einträge des angemeldeten Bürgers, in jedem Status.</summary>
    [UseOffsetPaging(IncludeTotalCount = true, MaxPageSize = 100)]
    [Authorize]
    public async Task<IQueryable<EhrenamtsbankEintrag>> GetMeineEhrenamtsbankEintraege(
        DomainContext db, CurrentUserAccessor currentUserAccessor) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger buerger) {
            throw new NotAllowedException("Nur App-Nutzer haben eigene Einträge.");
        }

        return db.EhrenamtsbankEintraege
            .Where(e => !e.IsDeleted && e.OwnerId == buerger.Id)
            .OrderByDescending(e => e.CreatedAt).ThenBy(e => e.Id);
    }

    /// <summary>Active entries are public; other statuses are visible only to the owner, to
    /// anyone who has made an Anfrage on them, and to moderators. Missing, deleted and other
    /// people's non-active entries all throw the same error on purpose, so existence never leaks.</summary>
    [AllowAnonymous]
    public async Task<EhrenamtsbankEintrag> GetEhrenamtsbankEintrag(
        Guid id, DomainContext db, CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        var eintrag = await db.EhrenamtsbankEintraege
            .FirstOrDefaultAsync(e => e.Id == id && !e.IsDeleted, ct);
        if (eintrag is not null && await EintragVisibility.CanViewAsync(db, eintrag, currentUserAccessor.TryUserId(), ct)) {
            return eintrag;
        }

        throw new EintragNotFoundException();
    }
}
