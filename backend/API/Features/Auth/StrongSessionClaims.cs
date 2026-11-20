using System.Security.Claims;

namespace API.Features.Auth;

public static class StrongSessionClaims {
    public const string AuthProvider = "auth_provider";
    public const string AuthTime = "auth_time";
    public const string AssuranceLevel = "auth_level";
    public const string Session = "auth_session";

    public static bool IsStrongSession(this ClaimsPrincipal principal) => principal.FindFirst(AuthProvider) is not null;

    public static bool IsBundIdSession(this ClaimsPrincipal? principal) =>
        principal?.FindFirstValue(AuthProvider) == RefreshTokens.RefreshTokenProvider.BundId;
}
