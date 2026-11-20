using System.Security.Claims;

namespace API.Features.Auth.BundId;

/// <summary>
/// Liest das erreichte Vertrauensniveau einer BundID-Anmeldung aus dem validierten Keycloak-Token.
///
/// Zwei mögliche Quellen, in dieser Reihenfolge:
/// 1. Der Standard-OIDC-Claim <c>acr</c> (Keycloaks eigenes Level-of-Authentication-System,
///    <c>oidc-acr-mapper</c> im Realm) – aktuell leer, da im Realm keine Flow-Schritte mit einem
///    LoA-Level annotiert sind. Bleibt als Quelle bestehen, falls das später ergänzt wird.
/// 2. BundIDs Per-Attribut-Trust-Level (<c>akdb:TrustLevel</c>) am stets angeforderten
///    <c>bpk2</c>-Attribut, von der Keycloak-BundID-Extension automatisch als Session-Note
///    <c>ba.bundid_prop_bpk2-verified-level</c> gespeichert und über den bereits im Realm
///    registrierten <c>oidc-bundid-sessionnote-mapper</c> (siehe realm-kommunalapp.json, Client
///    <c>kommunalapp-mobile</c>) automatisch als Claim <c>bpk2-verified-level</c> ausgegeben, ohne
///    weitere Realm-Änderung nutzbar. Werte sind dieselbe <c>STORK-QAA-Level-1..4</c>-Skala wie in
///    der ausgehenden RequestedAuthnContext (siehe SamlAuthenticationPreprocessorImpl.AuthnLevel
///    der Keycloak-Extension).
///
/// Beide Quellen liefern für lokale, nicht über den echten BundID-SAML-Broker angelegte
/// Test-Accounts erwartungsgemäß <c>null</c>.
/// </summary>
public static class BundIdAssuranceLevel {
    public const string Bpk2VerifiedLevelClaim = "bpk2-verified-level";

    public static string? Extract(ClaimsPrincipal principal) =>
        principal.FindFirstValue("acr") ?? principal.FindFirstValue(Bpk2VerifiedLevelClaim);
}
