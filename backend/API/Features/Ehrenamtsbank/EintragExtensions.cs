using API.Features.Auth;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank;

[ExtendObjectType<EhrenamtsbankEintrag>]
public class EintragExtensions {
    /// <summary>Inhaber-Profil. Null, falls der Inhaber (unerwartet) kein Bürger ist.</summary>
    public async Task<EhrenamtsbankProfil?> Owner(
        [Parent] EhrenamtsbankEintrag eintrag, IUserByIdDataLoader users,
        CurrentUserAccessor currentUserAccessor, CancellationToken ct) {
        if (await users.LoadAsync(eintrag.OwnerId, ct) is not Buerger owner) {
            return null;
        }

        var caller = await EhrenamtsbankCurrentUser.TryGetBuerger(currentUserAccessor);
        var callerIsRegistered = caller is { IsRegistered: true };
        return new EhrenamtsbankProfil(
            owner.Id, owner.Vorname, owner.Nachname,
            owner.PhoneVerified, owner.RequiresClearanceVerified,
            callerIsRegistered && owner.PhoneVerified ? owner.Phone : null);
    }

    public async Task<EhrenamtsbankKategorie?> Kategorie(
        [Parent] EhrenamtsbankEintrag eintrag, IEhrenamtsbankKategorieByIdDataLoader kategorien,
        CancellationToken ct) =>
        await kategorien.LoadAsync(eintrag.KategorieId, ct);

    public async Task<Untereinheit.Untereinheit?> Untereinheit(
        [Parent] EhrenamtsbankEintrag eintrag, IUntereinheitByIdDataLoader untereinheiten,
        CancellationToken ct) =>
        await untereinheiten.LoadAsync(eintrag.UntereinheitId, ct);

    [GraphQLDescription(
        "Straight-line distance from the provided location in whole kilometres; null if coordinates are missing.")]
    public int? DistanceKm([Parent] EhrenamtsbankEintrag eintrag, GeoCoordinateInput? origin) {
        if (origin is null) {
            return null;
        }

        // Validate input first so invalid coordinates always fail, even if the entry has no coordinates.
        EhrenamtsbankLocationValidation.ValidateCoordinates(origin.Latitude, origin.Longitude);

        if (eintrag.Latitude is not { } latitude || eintrag.Longitude is not { } longitude) {
            return null;
        }

        return ToWholeKilometres(
            GeoDistance.CalculateKm(origin.Latitude, origin.Longitude, latitude, longitude));
    }

    /// <summary>Rounds the returned distance; filtering uses the unrounded value.</summary>
    internal static int ToWholeKilometres(double distanceKm) =>
        (int)Math.Round(distanceKm, MidpointRounding.AwayFromZero);

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, EhrenamtsbankKategorie>> GetEhrenamtsbankKategorieById(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> factory, CancellationToken ct) {
        await using var db = await factory.CreateDbContextAsync(ct);
        return await db.EhrenamtsbankKategorien.Where(k => ids.Contains(k.Id)).ToDictionaryAsync(k => k.Id, ct);
    }

    [DataLoader]
    internal static async Task<IReadOnlyDictionary<Guid, Untereinheit.Untereinheit>> GetUntereinheitById(
        IReadOnlyList<Guid> ids, IDbContextFactory<DomainContext> factory, CancellationToken ct) {
        await using var db = await factory.CreateDbContextAsync(ct);
        return await db.Untereinheit.Where(u => ids.Contains(u.Id)).ToDictionaryAsync(u => u.Id, ct);
    }
}
