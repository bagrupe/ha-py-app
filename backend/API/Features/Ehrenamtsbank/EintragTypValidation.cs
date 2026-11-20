namespace API.Features.Ehrenamtsbank;

/// <summary>
/// Typ-Exklusivität der optionalen Felder: Gesuch-Felder dürfen nur bei Gesuchen,
/// Angebots-Felder nur bei Angeboten gesetzt sein. Kein Feld ist verpflichtend.
/// </summary>
public static class EintragTypValidation {
    /// <summary>Liefert null wenn gültig, sonst die Fehlermeldung.</summary>
    public static string? Validate(
        EhrenamtsbankEintragTyp typ,
        EhrenamtsbankDringlichkeit? urgency,
        int? estimatedDurationMinutes,
        string? availability) {
        return typ switch {
            EhrenamtsbankEintragTyp.Gesuch when availability is not null =>
                "Availability ist nur bei Angeboten erlaubt.",
            EhrenamtsbankEintragTyp.Angebot when urgency is not null =>
                "Urgency ist nur bei Gesuchen erlaubt.",
            EhrenamtsbankEintragTyp.Angebot when estimatedDurationMinutes is not null =>
                "EstimatedDurationMinutes ist nur bei Gesuchen erlaubt.",
            _ => null,
        };
    }
}
