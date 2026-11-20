using System.Reflection;
using API.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace API.Features.MobileApp;

/// <summary>Liefert Versionsinformationen zur Kompatibilität mit der mobilen App.</summary>
[ApiController]
[Route("api/app-version-compatibility")]
public class AppVersionCompatibilityController(IOptions<MobileAppOptions> mobileAppOptions) : ControllerBase {

    /// <summary>
    /// Gibt die Backend-Version und die mindestens erforderliche App-Version zurück.
    /// </summary>
    [HttpGet]
    public ActionResult<AppVersionCompatibilityResponse> Get() {
        var backendVersion = typeof(AppVersionCompatibilityController).Assembly
            .GetCustomAttributes<AssemblyInformationalVersionAttribute>()
            .Select(a => a.InformationalVersion)
            .FirstOrDefault() ?? "unknown";

        return Ok(new AppVersionCompatibilityResponse(
            BackendVersion: backendVersion,
            MinimumCompatibleAppVersion: mobileAppOptions.Value.MinimumCompatibleAppVersion.Trim()));
    }
}

/// <summary>Antwort für die App-Versionskompatibilität.</summary>
public sealed record AppVersionCompatibilityResponse(
    string BackendVersion,
    string MinimumCompatibleAppVersion);
