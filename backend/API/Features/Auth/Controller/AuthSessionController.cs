using API.Features.Auth.RefreshTokens;
using API.Infrastructure.Exceptions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Features.Auth.Controller;

[ApiController]
[Route("api/auth/session")]
public class AuthSessionController(RefreshTokenService refreshTokenService) : ControllerBase {
    private const string LegacyRoute = "~/api/auth/bundid/";

    public record RefreshTokenRequest(string RefreshToken);

    [HttpPost("refresh")]
    [HttpPost(LegacyRoute + "refresh")]
    [AllowAnonymous]
    [RequestSizeLimit(1024)]
    public async Task<IActionResult> Refresh([FromBody] RefreshTokenRequest request, CancellationToken ct) {
        // 401 wie bei unbekanntem Token, nur darauf beendet die App die Sitzung.
        if (!IsPlausible(request.RefreshToken)) {
            return Unauthorized();
        }

        RefreshTokenPayload payload;
        try {
            payload = await refreshTokenService.RefreshAsync(request.RefreshToken, ct);
        } catch (RateLimitException e) {
            if (e.RetryAfter is { } retryAfter) {
                Response.Headers.RetryAfter = ((int)Math.Ceiling(retryAfter.TotalSeconds)).ToString();
            }
            return StatusCode(StatusCodes.Status429TooManyRequests);
        }

        return payload.Result switch {
            RefreshTokenResult.Success => Ok(new { token = payload.Token, refreshToken = payload.RefreshToken }),
            RefreshTokenResult.InvalidOrExpired => Unauthorized(),
            _ => Problem()
        };
    }

    /// <summary>Antwortet immer mit 204, damit nicht erkennbar ist, ob ein Token existiert.</summary>
    [HttpPost("revoke")]
    [HttpPost(LegacyRoute + "revoke")]
    [AllowAnonymous]
    [RequestSizeLimit(1024)]
    public async Task<IActionResult> Revoke([FromBody] RefreshTokenRequest request, CancellationToken ct) {
        if (!IsPlausible(request.RefreshToken)) {
            return BadRequest();
        }

        await refreshTokenService.RevokeAsync(request.RefreshToken, ct);
        return NoContent();
    }

    private static bool IsPlausible(string? refreshToken) =>
        !string.IsNullOrWhiteSpace(refreshToken) && refreshToken.Length <= RefreshTokenService.MaxRawTokenLength;
}
