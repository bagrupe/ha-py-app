using System.Security.Claims;
using API.Features.Auth.BundId;

namespace IntegrationTests;

/// <summary>
/// Ersetzt <see cref="KeycloakTokenValidator"/> in Tests (siehe <see cref="BackendApiFactory"/>) -
/// statt echter Signaturprüfung/OIDC-Discovery gegen Keycloak wird ein für den jeweiligen Test
/// zuvor per <see cref="Register"/> hinterlegter <see cref="ClaimsPrincipal"/> zurückgegeben.
/// </summary>
public class FakeKeycloakTokenValidator : IKeycloakTokenValidator {
    private readonly Dictionary<string, ClaimsPrincipal> _principals = new();

    public string Register(ClaimsPrincipal principal) {
        var accessToken = Guid.NewGuid().ToString();
        _principals[accessToken] = principal;
        return accessToken;
    }

    public Task<ClaimsPrincipal> ValidateAsync(string accessToken, CancellationToken ct = default) {
        if (!_principals.TryGetValue(accessToken, out var principal)) {
            throw new InvalidBundIdTokenException("Unbekanntes/ungültiges Test-Access-Token.");
        }
        return Task.FromResult(principal);
    }
}

/// <summary>Baut Test-<see cref="ClaimsPrincipal"/>s, wie sie ein echtes BundID-Keycloak-Access-Token nach der Validierung liefert.</summary>
public static class BundIdTestPrincipal {
    public static ClaimsPrincipal Create(
        string subject,
        string? vorname = "Max",
        string? nachname = "Mustermann",
        string? email = "max@example.com",
        string? telephoneNumber = null,
        string? acr = null) {
        var claims = new List<Claim> {
            new("preferred_username", subject)
        };
        if (vorname is not null) claims.Add(new Claim(ClaimTypes.GivenName, vorname));
        if (nachname is not null) claims.Add(new Claim(ClaimTypes.Surname, nachname));
        if (email is not null) claims.Add(new Claim(ClaimTypes.Email, email));
        if (telephoneNumber is not null) claims.Add(new Claim("telephoneNumber", telephoneNumber));
        if (acr is not null) claims.Add(new Claim("acr", acr));

        return new ClaimsPrincipal(new ClaimsIdentity(claims, "test"));
    }
}
