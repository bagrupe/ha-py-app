using API.Infrastructure.Exceptions;
using HotChocolate.Authorization;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Speichert Namens- und Adressfelder des aktuell eingeloggten Bürgers – für Bürger ohne
/// BundID-Verknüpfung jederzeit über "Mein Konto" frei editierbar. Für BundID-verknüpfte Bürger
/// sind diese Felder schreibgeschützt (siehe <see cref="ProfileManagedByBundIdException"/>): sie
/// werden ausschließlich bei der BundID-Anmeldung aus dem BundID-Konto übernommen (siehe
/// <see cref="BundId.BundIdAuthService"/>), Änderungen müssen dort erfolgen. Die Telefonnummer
/// läuft bewusst nicht über diese Mutation, sondern ausschließlich über die bestehenden
/// requestSmsCode/validateSmsCode-Mutations (siehe <see cref="EhrenamtsbankAuthMutation"/>), damit
/// die Verifizierung nicht umgangen werden kann.
/// </summary>
[MutationType]
public class UpdateMyProfileMutation {
    // Bewusst kein [Error(typeof(...))]: das würde HotChocolates Mutation-Conventions-Payload
    // aktivieren (Fehler nur noch über ein "errors"-Feld am Payload statt am Top-Level), was den
    // bestehenden Query-Vertrag ({ boolean }) brechen würde. DomainException-Subklassen bekommen
    // bereits über den globalen GraphQLErrorFilter einen spezifischen Code (siehe dort) — dafür
    // reicht es, wie bei ProfileManagedByBundIdException und ProfileRequiresRegistrationException,
    // eine eigene DomainException-Subklasse zu werfen statt der generischen InvalidOperationException.
    [Authorize]
    public async Task<bool> UpdateMyProfile(
        string? vorname,
        string? nachname,
        string? email,
        string? street,
        string? postalCode,
        string? city,
        string? country,
        DomainContext domainContext,
        [Service] ICurrentUserAccessor currentUserAccessor,
        CancellationToken ct) {
        var user = await currentUserAccessor.User();
        if (user is not Buerger) throw new InvalidOperationException();

        var buerger = await domainContext.Users.AsTracking()
            .FirstOrDefaultAsync(u => u.Id == user.Id, ct) as Buerger
            ?? throw new InvalidOperationException();

        var hasAnyFieldChange = vorname is not null || nachname is not null || email is not null
            || street is not null || postalCode is not null || city is not null || country is not null;
        if (hasAnyFieldChange) {
            if (!buerger.IsRegistered) throw new ProfileRequiresRegistrationException();

            var hasBundId = await domainContext.ExternalIdentities
                .AnyAsync(e => e.BuergerId == buerger.Id && e.Provider == "bundid", ct);
            if (hasBundId) {
                throw new ProfileManagedByBundIdException();
            }
        }

        if (vorname is not null) buerger.Vorname = vorname;
        if (nachname is not null) buerger.Nachname = nachname;
        if (email is not null) buerger.EmailAddress = email;
        if (street is not null) buerger.Street = street;
        if (postalCode is not null) buerger.PostalCode = postalCode;
        if (city is not null) buerger.City = city;
        if (country is not null) buerger.Country = country;

        await domainContext.SaveChangesAsync(ct);
        return true;
    }
}
