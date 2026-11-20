using System.Text.Json;
using Microsoft.Extensions.Diagnostics.HealthChecks;

namespace API.Infrastructure;

/// <summary>Writes standardized JSON health responses for monitoring probes.</summary>
public static class HealthCheckResponseWriter {
    private static readonly JsonSerializerOptions JsonOptions = new() {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    };

    /// <summary>Serializes the health report as JSON with HTTP 200 or 503.</summary>
    public static Task WriteResponse(HttpContext context, HealthReport report) {
        var status = report.Status == HealthStatus.Healthy ? "Healthy" : "Unhealthy";
        var checks = report.Entries.ToDictionary(
            entry => entry.Key,
            entry => entry.Value.Status == HealthStatus.Healthy ? "Healthy" : "Unhealthy");

        context.Response.ContentType = "application/json";
        context.Response.StatusCode = report.Status == HealthStatus.Healthy
            ? StatusCodes.Status200OK
            : StatusCodes.Status503ServiceUnavailable;

        return context.Response.WriteAsync(JsonSerializer.Serialize(new { status, checks }, JsonOptions));
    }
}
