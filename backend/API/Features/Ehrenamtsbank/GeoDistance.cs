namespace API.Features.Ehrenamtsbank;

/// <summary>A coordinate pair with no address, unlike <see cref="EhrenamtsbankLocationInput"/>.</summary>
public record GeoCoordinateInput(double Latitude, double Longitude);

/// <summary>
/// Straight-line (Haversine) distance between two coordinates. The result stays unrounded so the
/// search filter can compare the exact value; only the output is rounded.
/// </summary>
public static class GeoDistance {
    /// <summary>Mean earth radius in kilometres (IUGG).</summary>
    public const double EarthRadiusKm = 6371.0088;

    public static double CalculateKm(double lat1, double lon1, double lat2, double lon2) {
        var halbeBreitendifferenz = double.DegreesToRadians(lat2 - lat1) / 2;
        var halbeLaengendifferenz = double.DegreesToRadians(lon2 - lon1) / 2;
        var a = Math.Sin(halbeBreitendifferenz) * Math.Sin(halbeBreitendifferenz)
                + Math.Cos(double.DegreesToRadians(lat1)) * Math.Cos(double.DegreesToRadians(lat2))
                * Math.Sin(halbeLaengendifferenz) * Math.Sin(halbeLaengendifferenz);

        // Rounding error can push a just above 1, which would make Math.Asin return NaN.
        return 2 * EarthRadiusKm * Math.Asin(Math.Sqrt(Math.Clamp(a, 0, 1)));
    }
}
