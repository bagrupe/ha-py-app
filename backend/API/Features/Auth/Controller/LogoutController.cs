using Microsoft.AspNetCore.Mvc;

namespace API.Features.Auth.Controller;

/// <summary>Controller für Logout-Operationen.</summary>
[ApiController]
[Route("api/[controller]")]
public class LogoutController : ControllerBase {

    /// <summary>
    /// Loggt den Nutzer aus, indem das Bereich B Cookie gelöscht wird.
    /// </summary>
    /// <returns>Status der Logout-Operation.</returns>
    [HttpPost]
    public IActionResult Index() {
        // Lösche das Bereich B Cookie, um den Nutzer auch dort auszuloggen
        Response.Cookies.Delete("payload-token", new CookieOptions {
            Path = "/",
            HttpOnly = true,
            SameSite = SameSiteMode.Lax,
            Secure = true
        });

        return Ok(new { success = true });
    }
}

