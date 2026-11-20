using System.Net.Http.Headers;
using System.Text.Json;
using System.Text.Json.Nodes;
using API.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace API.Features.GovManager.Controller;

/// <summary>Controller zur Verarbeitung von Antworten des GovManagers.</summary>
public class GovManagerResponseController : ControllerBase {
    private readonly IDbContextFactory<DomainContext> _dbContextFactory;
    private readonly GovManagerOptions _options;

    /// <summary>Initialisiert den Controller mit Datenbankkontext und Konfigurationsoptionen.</summary>
    /// <param name="dbContextFactory">Fabrik zum Erzeugen von Datenbankkontexten.</param>
    /// <param name="options">Konfigurationseinstellungen für den GovManager.</param>
    public GovManagerResponseController(IDbContextFactory<DomainContext> dbContextFactory, GovManagerOptions options) {
        _dbContextFactory = dbContextFactory;
        _options = options;
    }

    /// <summary>Verarbeitet eingehende Antworten und aktualisiert den zugehörigen Request-Status.</summary>
    /// <param name="body">Der JSON-Körper der Anfrage.</param>
    /// <param name="authorization">Der Autorisierungsheader mit Bearer-Token.</param>
    /// <returns>Ergebnis der Verarbeitung als HTTP-Antwort.</returns>
    [Route("api/[controller]")]
    [HttpGet]
    [HttpPost]
    public async Task<IActionResult> Index([FromBody] JsonNode body, [FromHeader(Name = "Authorization")] string authorization) {
        if (!AuthenticationHeaderValue.TryParse(authorization, out var auth)
            || auth.Scheme != "Bearer"
            || auth.Parameter != _options.ResponseKey) {
            return Unauthorized();
        }

        var maybeRequestId = body["requestId"];

        if (maybeRequestId?.GetValue<string>() is not { } requestIdString || !Guid.TryParse(requestIdString, out var requestId)) {
            return BadRequest("Invalid requestId");
        }

        await using var db = await _dbContextFactory.CreateDbContextAsync();
        var request = await db.GovManagerRequests
            .AsTracking()
            .FirstOrDefaultAsync(r => r.Id == requestId);

        if (request is null) {
            return BadRequest("Invalid requestId");
        }

        request.Success = true;
        request.CompletedAt = DateTimeOffset.UtcNow;
        request.ResponseBody = JsonSerializer.Serialize(body["data"]);

        await db.SaveChangesAsync();

        return Ok();
    }
}
