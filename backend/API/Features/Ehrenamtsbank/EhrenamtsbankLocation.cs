using API.Features.Ehrenamtsbank.Mutations;

namespace API.Features.Ehrenamtsbank;

public record EhrenamtsbankLocationInput(string Address, double Latitude, double Longitude);

/// <summary>An <see cref="EhrenamtsbankLocationInput"/> that has passed validation.</summary>
public readonly record struct EhrenamtsbankLocation(string Address, double Latitude, double Longitude);

/// <summary>
/// The database enforces these same rules as check constraints. This runs first so bad input
/// comes back as a typed <see cref="EintragValidationException"/> instead of a database error.
/// </summary>
public static class EhrenamtsbankLocationValidation {
    public const int MaxAddressLength = 250;

    public static EhrenamtsbankLocation Normalize(EhrenamtsbankLocationInput input) {
        var address = input.Address.Trim();
        if (address.Length == 0) {
            throw new EintragValidationException("Die Adresse darf nicht leer sein.");
        }

        if (address.Length > MaxAddressLength) {
            throw new EintragValidationException(
                $"Die Adresse darf höchstens {MaxAddressLength} Zeichen lang sein.");
        }

        ValidateCoordinates(input.Latitude, input.Longitude);
        return new EhrenamtsbankLocation(address, input.Latitude, input.Longitude);
    }

    public static void ValidateCoordinates(double latitude, double longitude) {
        if (!double.IsFinite(latitude) || !double.IsFinite(longitude)) {
            throw new EintragValidationException("Die Koordinaten müssen endliche Zahlen sein.");
        }

        if (latitude is < -90 or > 90) {
            throw new EintragValidationException("Der Breitengrad muss zwischen -90 und 90 liegen.");
        }

        if (longitude is < -180 or > 180) {
            throw new EintragValidationException("Der Längengrad muss zwischen -180 und 180 liegen.");
        }
    }
}
