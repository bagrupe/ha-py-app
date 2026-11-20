using API.Features.Auth;

namespace API.Features.Ehrenamtsbank;

/// <summary>
/// Öffentliche Ehrenamtsbank-Identität des Eintrag-Inhabers. Vor- und Nachname werden
/// vollständig geliefert (Abkürzung ist Sache des Clients). <c>Phone</c> ist nur für
/// registrierte Aufrufer und nur bei verifizierter Nummer gefüllt — das ist die
/// Kontaktdaten-Schranke des Tickets.
/// </summary>
public record EhrenamtsbankProfil(
    Guid Id,
    string? Vorname,
    string? Nachname,
    bool PhoneVerified,
    [property: GraphQLDescription("Führungszeugnis-Status des Inhabers.")] bool ClearanceVerified,
    string? Phone
);

public static class EhrenamtsbankCurrentUser {
    /// <summary>Aktueller Aufrufer als Bürger, oder null wenn nicht authentifiziert / kein Bürger.</summary>
    public static async Task<Buerger?> TryGetBuerger(CurrentUserAccessor currentUserAccessor) {
        try {
            return await currentUserAccessor.User() as Buerger;
        } catch (CurrentUserAccessor.Unauthenticated) {
            return null;
        }
    }
}
