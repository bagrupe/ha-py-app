using API.Features.Auth.BundId;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace API.Features.Auth.Controller;

[ApiController]
[Route("api/auth/bundid")]
public class BundIdController(
    BundIdAuthService bundIdAuthService,
    ICurrentUserAccessor currentUserAccessor)
    : ControllerBase {
    public record AccessTokenRequest(string AccessToken);

    [HttpPost("login")]
    [AllowAnonymous]
    public async Task<IActionResult> Login([FromBody] AccessTokenRequest request, CancellationToken ct) {
        if (string.IsNullOrWhiteSpace(request.AccessToken)) {
            return BadRequest();
        }

        try {
            var payload = await bundIdAuthService.LoginAsync(request.AccessToken, ct);
            return payload.Result switch {
                BundIdLoginResult.Success => Ok(new { token = payload.Token, refreshToken = payload.RefreshToken }),
                BundIdLoginResult.RegistrationRequired =>
                    Conflict(new { error = "BUNDID_REGISTRATION_REQUIRED" }),
                BundIdLoginResult.AccountUnavailable or BundIdLoginResult.AuthenticationOutdated => Unauthorized(),
                _ => Problem()
            };
        } catch (InvalidBundIdTokenException) {
            return Unauthorized();
        }
    }

    /// <summary>Verknüpft die BundID einmalig mit dem angemeldeten Konto.</summary>
    [HttpPost("exchange")]
    [Authorize]
    public async Task<IActionResult> Exchange([FromBody] AccessTokenRequest request, CancellationToken ct) {
        if (string.IsNullOrWhiteSpace(request.AccessToken)) {
            return BadRequest();
        }

        if (currentUserAccessor.TryUserId() is not { } currentBuergerId) {
            return Unauthorized();
        }

        try {
            var payload = await bundIdAuthService.ExchangeAsync(currentBuergerId, request.AccessToken, ct);
            return payload.Result switch {
                BundIdExchangeResult.Success => Ok(new {
                    token = payload.Token,
                    refreshToken = payload.RefreshToken,
                    isNewRegistration = payload.IsNewRegistration,
                    profileSuggestion = payload.ProfileSuggestion,
                    phoneNumberCollision = payload.PhoneNumberCollision
                }),
                BundIdExchangeResult.AlreadyLinkedToAnotherAccount =>
                    Conflict(new { error = "BUNDID_ALREADY_LINKED_TO_ANOTHER_ACCOUNT" }),
                BundIdExchangeResult.AccountAlreadyHasDifferentBundId =>
                    Conflict(new { error = "BUNDID_ACCOUNT_ALREADY_HAS_DIFFERENT_BUNDID" }),
                BundIdExchangeResult.AccountAlreadyVerified =>
                    Conflict(new { error = "BUNDID_ACCOUNT_ALREADY_VERIFIED" }),
                BundIdExchangeResult.AccountUnavailable or BundIdExchangeResult.AuthenticationOutdated =>
                    Unauthorized(),
                _ => Problem()
            };
        } catch (InvalidBundIdTokenException) {
            return Unauthorized();
        }
    }
}
