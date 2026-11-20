using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Net.Sockets;
using System.Security.Claims;
using API.Infrastructure;
using API.Options;
using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;

namespace API.Features.Auth.BundId;

/// <summary>Validiert ein von Keycloak ausgestelltes OIDC-Access-Token eines BundID-Brokerlogins.</summary>
public interface IKeycloakTokenValidator {
    Task<ClaimsPrincipal> ValidateAsync(string accessToken, CancellationToken ct = default);
}

/// <summary>
/// Prüft Signatur (via OIDC Discovery/JWKS), Issuer, Audience, Laufzeit und optional den Claim
/// <c>identity_provider</c> eines Keycloak-Access-Tokens. Das Access Token wird nicht als
/// fachliches App-Token weiterverwendet, sondern nur zur Ausstellung eines eigenen
/// KommunalApp-JWT geprüft.
/// </summary>
public class KeycloakTokenValidator : IKeycloakTokenValidator {
    private readonly BundIdOptions _options;
    private readonly ConfigurationManager<OpenIdConnectConfiguration> _configurationManager;

    public KeycloakTokenValidator(BundIdOptions options) {
        _options = options;
        // RequireHttps folgt der konfigurierten Authority: gegen die öffentliche BundID-Umgebung
        // ist die Authority immer https, lokal (reiner Backend-Test ohne Caddy-Tunnel) läuft
        // Keycloak dagegen unter http://localhost:8081.
        var authorityUri = new Uri(options.KeycloakAuthority);
        var httpClient = new HttpClient(CreateHandler(authorityUri));
        var documentRetriever = new HttpDocumentRetriever(httpClient) {
            RequireHttps = authorityUri.Scheme == Uri.UriSchemeHttps
        };
        _configurationManager = new ConfigurationManager<OpenIdConnectConfiguration>(
            $"{options.KeycloakAuthority.TrimEnd('/')}/.well-known/openid-configuration",
            new OpenIdConnectConfigurationRetriever(),
            documentRetriever);
    }

    /// <summary>
    /// Lokal läuft Keycloak unter <c>http://localhost:8081</c>, meldet sich aber (wegen
    /// <c>KC_HOSTNAME</c>, das für den SAML-Broker-Login mit BundID die öffentliche Domain
    /// braucht) im OIDC-Discovery-Dokument selbst mit der öffentlichen Domain
    /// (<c>jwks_uri</c> etc.). Diese Domain ist vom Entwicklerrechner aus nicht erreichbar
    /// (kein Hairpin-NAT/Portforward auf den rohen Keycloak-Port). Statt eine
    /// Systemkonfiguration (z.B. <c>/etc/hosts</c>) vorauszusetzen, leitet dieser HttpClient
    /// – nur wenn die konfigurierte Authority selbst schon localhost/loopback ist, also nur im
    /// lokalen Dev-Setup – jede ausgehende Verbindung auf denselben Host wie die Authority um,
    /// unabhängig vom angefragten Hostnamen. In Produktion ist die Authority niemals loopback,
    /// dort greift dieser Umweg also nie.
    /// </summary>
    private static HttpMessageHandler CreateHandler(Uri authorityUri) {
        if (!IPAddress.TryParse(authorityUri.Host, out var authorityIp)) {
            authorityIp = null;
        }
        var isLocalAuthority = authorityUri.IsLoopback
            || string.Equals(authorityUri.Host, "localhost", StringComparison.OrdinalIgnoreCase)
            || (authorityIp is not null && IPAddress.IsLoopback(authorityIp));

        if (!isLocalAuthority) {
            return new HttpClientHandler();
        }

        return new SocketsHttpHandler {
            ConnectCallback = async (context, ct) => {
                var socket = new Socket(SocketType.Stream, ProtocolType.Tcp) { NoDelay = true };
                try {
                    await socket.ConnectAsync(IPAddress.Loopback, context.DnsEndPoint.Port, ct);
                    return new NetworkStream(socket, ownsSocket: true);
                } catch {
                    socket.Dispose();
                    throw;
                }
            }
        };
    }

    /// <summary>
    /// Leitet aus einem Issuer, wie er beim direkten (lokalen) Abruf des Discovery-Dokuments
    /// erscheint, die Variante ab, die echte Tokens tragen, wenn sie über den öffentlichen
    /// Caddy-Tunnel ausgestellt wurden: https statt http, ohne expliziten Port.
    /// </summary>
    private static string DerivePublicIssuerVariant(string issuer) {
        var uri = new UriBuilder(issuer) { Scheme = Uri.UriSchemeHttps, Port = -1 };
        return uri.Uri.ToString().TrimEnd('/');
    }

    public async Task<ClaimsPrincipal> ValidateAsync(string accessToken, CancellationToken ct = default) {
        OpenIdConnectConfiguration configuration;
        try {
            configuration = await _configurationManager.GetConfigurationAsync(ct);
        } catch (Exception ex) when (ex is not OperationCanceledException) {
            throw new InvalidBundIdTokenException("Keycloak-OIDC-Konfiguration konnte nicht geladen werden.");
        }

        var validationParameters = new TokenValidationParameters {
            ValidateIssuer = true,
            // Keycloak meldet sich als Issuer je nachdem, über welchen Weg es angesprochen wurde:
            // direkt (lokal, http://…:8081, wie beim Abruf des Discovery-Dokuments oben) oder über
            // den öffentlichen Caddy-Tunnel (https://…, ohne Port), über den echte BundID-Logins
            // laufen. Beide Varianten bezeichnen dieselbe Instanz, deshalb werden beide akzeptiert
            // statt nur die gerade abgerufene.
            ValidIssuers = [configuration.Issuer, DerivePublicIssuerVariant(configuration.Issuer)],
            ValidateAudience = true,
            ValidAudience = _options.Audience,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKeys = configuration.SigningKeys,
            ValidAlgorithms = [SecurityAlgorithms.RsaSha256, SecurityAlgorithms.RsaSsaPssSha256],
            ClockSkew = TimeSpan.FromSeconds(60)
        };

        ClaimsPrincipal principal;
        try {
            principal = new JwtSecurityTokenHandler().ValidateToken(accessToken, validationParameters, out _);
        } catch (Exception ex) when (ex is SecurityTokenException or ArgumentException) {
            // ArgumentException (z.B. IDX12741 "must have three segments") deckt strukturell
            // ungültige/nicht-parsebare Tokens ab, SecurityTokenException die eigentliche
            // Signatur-/Issuer-/Audience-/Laufzeit-Validierung.
            throw new InvalidBundIdTokenException("Keycloak-Token ist ungültig oder abgelaufen: " + ex.Message);
        }

        if (_options.RequireBundIdIdentityProviderClaim) {
            var identityProvider = principal.FindFirstValue("identity_provider");
            if (!string.Equals(identityProvider, _options.IdentityProviderAlias, StringComparison.Ordinal)) {
                throw new InvalidBundIdTokenException(
                    "Token stammt nicht aus einem BundID-Brokerlogin.");
            }
        }

        return principal;
    }
}

/// <summary>Wird ausgelöst, wenn ein Keycloak-Token nicht als gültiger BundID-Login akzeptiert werden kann.</summary>
public class InvalidBundIdTokenException(string message) : DomainException(message);
