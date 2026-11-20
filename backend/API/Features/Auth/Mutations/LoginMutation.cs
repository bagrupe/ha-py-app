using System.IdentityModel.Tokens.Jwt;
using System.Linq.Expressions;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using API.Infrastructure;
using API.Options;
using HotChocolate.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace API.Features.Auth.Mutations;

/// <summary>
/// Mutation für Login-Funktionen, einschließlich schwachem Login für Bürger und Standard-Login.
/// </summary>
[MutationType]
public class LoginMutation {
    /// <summary>
    /// Mögliche Ergebnisse eines Login-Versuchs.
    /// </summary>
    public enum LoginResult {
        Success,
        WrongLogin,
        NeedsConfirmation
    }

    /// <summary>
    /// Führt einen schwachen Login für Bürger durch, basierend auf der Bürger-ID und dem Passwort.
    /// </summary>
    /// <param name="buergerId">Die eindeutige ID des Bürgers.</param>
    /// <param name="password">Das Passwort des Bürgers.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf Benutzerdaten.</param>
    /// <param name="passwordHasher">Service zum Überprüfen und Hashen von Passwörtern.</param>
    /// <param name="options">JWT-Optionen für die Token-Generierung.</param>
    /// <param name="httpContextAccessor">Zugriff auf den aktuellen HTTP-Kontext.</param>
    /// <param name="httpClientFactory">Factory zur Erstellung von HTTP-Clients.</param>
    /// <param name="rateLimit">Service zur Begrenzung der Anfragen.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Ein LoginPayload mit dem Ergebnis und ggf. einem Token.</returns>
    [AllowAnonymous]
    public async Task<LoginPayload> LoginBuergerWeak(Guid buergerId, string password, DomainContext domainContext,
        [Service] IPasswordHasher<User> passwordHasher,
        [Service] JWTOptions options,
        [Service] IHttpContextAccessor httpContextAccessor,
        [Service] IHttpClientFactory httpClientFactory,
        [Service] RateLimit rateLimit,
        CancellationToken ct
    ) {
        await rateLimit.Limit(ct, new RateLimit.IpLimit("Login", 2, TimeSpan.FromSeconds(5)));

        var validatedUser = await ValidateCredentials<Buerger>(domainContext, u => u.Id == buergerId, passwordHasher, password, ct);
        if (validatedUser == null) {
            return new LoginPayload(LoginResult.WrongLogin);
        }

        var token = validatedUser.GetToken(options);

        return new LoginPayload(LoginResult.Success, new JwtSecurityTokenHandler().WriteToken(token));
    }

    /// <summary>
    /// Führt einen Standard-Login durch, basierend auf der E-Mail-Adresse und dem Passwort.
    /// </summary>
    /// <param name="email">Die E-Mail-Adresse des Benutzers.</param>
    /// <param name="password">Das Passwort des Benutzers.</param>
    /// <param name="domainContext">Datenbankkontext für den Zugriff auf Benutzerdaten.</param>
    /// <param name="passwordHasher">Service zum Überprüfen und Hashen von Passwörtern.</param>
    /// <param name="options">JWT-Optionen für die Token-Generierung.</param>
    /// <param name="httpContextAccessor">Zugriff auf den aktuellen HTTP-Kontext.</param>
    /// <param name="httpClientFactory">Factory zur Erstellung von HTTP-Clients.</param>
    /// <param name="rateLimit">Service zur Begrenzung der Anfragen.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Ein LoginPayload mit dem Ergebnis und ggf. einem Token.</returns>
    [AllowAnonymous]
    public async Task<LoginPayload> Login(string email, string password,
        DomainContext domainContext,
        [Service] IPasswordHasher<User> passwordHasher,
        [Service] JWTOptions options,
        [Service] IHttpContextAccessor httpContextAccessor,
        [Service] IHttpClientFactory httpClientFactory,
        [Service] RateLimit rateLimit,
        CancellationToken ct
    ) {
        await rateLimit.Limit(ct, new RateLimit.IpLimit("Login", 2, TimeSpan.FromSeconds(5)));

        var validatedUser = await ValidateCredentials<Mitarbeiter>(domainContext, u => u.EMail == email.ToLowerInvariant(), passwordHasher, password, ct);
        if (validatedUser == null) {
            return new LoginPayload(LoginResult.WrongLogin);
        }

        if (validatedUser.OrganisationPrivateKey is null) {
            return new LoginPayload(LoginResult.NeedsConfirmation);

        }

        var token = validatedUser.GetToken(options);
        if (validatedUser is BackofficeUser { Art: not BackofficeNutzerArt.Dienstleister } backofficeUser) {
            var client = httpClientFactory.CreateClient("BereichBInternal");
            var data = new {
                email = validatedUser.EMail,
                kommuneId = backofficeUser.KommuneId.ToString(),
                bereichAUserId = backofficeUser.Id
            };
            var jsonString = JsonSerializer.Serialize(data);
            var resp = await client.PostAsync("sso/login", new StringContent(jsonString, Encoding.UTF8, "application/json"), ct);
            if (resp.IsSuccessStatusCode) {
                var bereichBToken = await resp.Content.ReadAsStringAsync(ct);
                await domainContext.SaveChangesAsync(ct);
                var response = httpContextAccessor.HttpContext?.Response;
                response?.Cookies.Append("payload-token", bereichBToken, new CookieOptions { Path = "/", HttpOnly = true, SameSite = SameSiteMode.Lax, Secure = true });
            }
        }

        return new LoginPayload(LoginResult.Success, new JwtSecurityTokenHandler().WriteToken(token));
    }

    /// <summary>
    /// Validiert die Anmeldedaten eines Benutzers anhand eines Prädikats und überprüft das Passwort.
    /// </summary>
    /// <typeparam name="T">Der Benutzertyp, der validiert werden soll.</typeparam>
    /// <param name="db">Datenbankkontext für den Zugriff auf Benutzerdaten.</param>
    /// <param name="predicate">Prädikat zur Identifikation des Benutzers.</param>
    /// <param name="passwordHasher">Service zum Überprüfen und Hashen von Passwörtern.</param>
    /// <param name="password">Das Passwort des Benutzers.</param>
    /// <param name="ct">Abbruch-Token für asynchrone Operationen.</param>
    /// <returns>Der validierte Benutzer oder null, falls die Validierung fehlschlägt.</returns>
    private static async Task<T?> ValidateCredentials<T>(
        DbContext db,
        Expression<Func<T, bool>> predicate,
        IPasswordHasher<User> passwordHasher,
        string password,
        CancellationToken ct
    ) where T : User {
        var user = await db.Set<T>().AsTracking().FirstOrDefaultAsync(predicate, ct);

        if (user is null or { IsDeleted: true }) {
            return null;
        }

        var result = passwordHasher.VerifyHashedPassword(null!, user.Password, password);
        if (result == PasswordVerificationResult.Failed) {
            return null;
        }

        if (result == PasswordVerificationResult.SuccessRehashNeeded) {
            user.Password = passwordHasher.HashPassword(user, password);
            await db.SaveChangesAsync(ct);
        }

        return user;
    }

    /// <summary>
    /// Rückgabedaten eines Login-Versuchs, einschließlich Ergebnis und optionalem Token.
    /// </summary>
    /// <param name="Result">Das Ergebnis des Login-Versuchs.</param>
    /// <param name="Token">Das generierte JWT-Token, falls der Login erfolgreich war.</param>
    public record LoginPayload(LoginResult Result, string? Token = null);
}

/// <summary>
/// Erweiterungsmethoden für Benutzer, um JWT-Tokens zu generieren.
/// </summary>
public static class UserTokenExtensions {
    /// <summary>
    /// Generiert ein JWT-Token für einen Benutzer basierend auf den angegebenen Optionen.
    /// </summary>
    /// <param name="user">Der Benutzer, für den das Token generiert wird.</param>
    /// <param name="options">JWT-Optionen für die Token-Generierung.</param>
    /// <returns>Das generierte JWT-Token.</returns>
    public static JwtSecurityToken GetToken(this User user, JWTOptions options,
        IEnumerable<Claim>? extraClaims = null, TimeSpan? lifetime = null) {
        var claims = new List<Claim> {
            new(ClaimTypes.NameIdentifier, user.Id.ToString()),
            new("is_registered", user is Buerger { IsRegistered: true } ? "true" : "false")
        };
        if (user is Buerger buerger) {
            claims.Add(new Claim(AccessTokenRevocation.SessionStampClaim, buerger.SessionStamp.ToString(),
                ClaimValueTypes.Integer32));
        }
        if (extraClaims is not null) {
            claims.AddRange(extraClaims);
        }

        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(options.Key));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        return new JwtSecurityToken(options.Issuer,
            options.Issuer,
            claims,
            expires: DateTime.Now.Add(lifetime ?? TimeSpan.FromDays(1)),
            signingCredentials: credentials);
    }
}
