using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Nodes;
using API.Features.Auth;
using API.Features.Email;
using API.Features.EmailForwarder;
using API.Features.Kommune;
using API.Features.PdfGenerator;
using API.Features.Prozess;
using API.Infrastructure;
using API.Options;
using Microsoft.EntityFrameworkCore;
using Quartz;
using Sentry;

namespace API.Features.GovManager;

/// <summary>Führt den Export von Daten an den GovManager über REST durch und steuert den Prozessfortschritt.</summary>
[DisallowConcurrentExecution]
public class GovManagerRestExportRunner(
    WalkerFactory walkerFactory,
    BlazorRenderer blazorRenderer,
    GovManagerOptions options,
    IHttpClientFactory httpClientFactory,
    PdfGenerator.PdfGenerator pdfGenerator,
    IDbContextFactory<DomainContext> dbContextFactory,
    KommuneDesignService kommuneDesignService,
    StaticMapService staticMapService,
    ILogger<GovManagerRestExportRunner> logger)
    : IJob {
    private const int MaxRetries = 10;
    private const string PermanentFailurePrefix = "[PERMANENT] ";

    /// <summary>Startet die Ausführung des Jobs und verarbeitet alle relevanten Prozessschritte.</summary>
    /// <param name="context">Kontext der Jobausführung.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        await foreach (var walker in walkerFactory.GetWalkerForCurrentStep<GovManagerRestExportSchritt>()) {
            try {
                await ContinueAusfuehrung(walker);
            } catch (Exception e) {
                failures.RecordFailure();
                logger.LogError(e, "GovManagerRestExportRunner Exception for '{schritt}' ({id})", walker.CurrentSchritt.Titel, walker.CurrentSchritt.Id);
                SentrySdk.CaptureException(e, scope => { scope.SetTag("GovManager", "GovManagerRestExportRunner Exception"); });
            }
        }
    }

    /// <summary>Setzt die Ausführung eines einzelnen Prozessschritts fort und sendet die Daten an den GovManager.</summary>
    /// <param name="walker">Der Prozess-Walker für die aktuelle Ausführung.</param>
    private async Task ContinueAusfuehrung(Walker walker) {
        if (walker.CurrentSchritt is not GovManagerRestExportSchritt exportSchritt) {
            return;
        }

        using var client = httpClientFactory.CreateClient("GovManager");
        var url = options.RestUrl
            .Replace("<vorgangs-typ>", exportSchritt.VorgangsTyp)
            .Replace("<mandanten-schluessel>", exportSchritt.MandantenSchluessel)
            .Replace("<vorgang-schluessel>", exportSchritt.VorgangsSchluessel);

        logger.LogInformation(
            "GovManager Export: AusfuehrungId={ausfuehrungId}, SchrittId={schrittId}, URL={url}",
            walker.Ausfuehrung.Id, walker.CurrentSchritt.Id, url);

        await using var db = await dbContextFactory.CreateDbContextAsync();

        var failedRequests = await db.GovManagerRequests
            .Where(r => r.AusfuehrungId == walker.Ausfuehrung.Id && r.Success != true)
            .Select(r => new { r.ResponseBody })
            .ToListAsync();

        if (failedRequests.Count >= MaxRetries) {
            logger.LogWarning(
                "GovManager Export skipped: AusfuehrungId={ausfuehrungId} exceeded {maxRetries} failed attempts",
                walker.Ausfuehrung.Id, MaxRetries);
            return;
        }

        if (failedRequests.Any(r => r.ResponseBody != null && r.ResponseBody.StartsWith(PermanentFailurePrefix))) {
            logger.LogWarning(
                "GovManager Export skipped: AusfuehrungId={ausfuehrungId} has a permanent failure (HTTP 4xx)",
                walker.Ausfuehrung.Id);
            return;
        }

        var slotValues = walker.CurrentSlotValues();
        var govManagerRequest = new GovManagerRequest {
            Id = Guid.NewGuid(),
            AusfuehrungId = walker.Ausfuehrung.Id,
            CreatedAt = DateTimeOffset.UtcNow,
            GovManagerSchrittId = walker.CurrentSchritt.Id
        };
        db.GovManagerRequests.Add(govManagerRequest);
        await db.SaveChangesAsync();

        var request = new HttpRequestMessage(HttpMethod.Post, url);

        var fileParts = exportSchritt.ExportParts.OfType<FilePart>();
        var jsonParts = exportSchritt.ExportParts.OfType<JsonPart>();

        var exportBuilder = new GovManagerMultipartFormDataBuilder();

        foreach (var filePart in fileParts) {
            if (!slotValues.TryGetValue(filePart.SlotName, out var slotValue) ||
                slotValue is not PlainSlotValue plainSlotValue) {
                continue;
            }

            if (plainSlotValue.Value.ValueKind == JsonValueKind.Array) {
                foreach (var jsonElement in plainSlotValue.Value.EnumerateArray()) {
                    if (jsonElement.ValueKind != JsonValueKind.String) {
                        continue;
                    }

                    var base64EncodedFile = jsonElement.GetString()!;
                    if (exportSchritt.ExportFilePartsAsPdf) {
                        var fileAsPdf = await pdfGenerator.ConvertToPdf(Convert.FromBase64String(base64EncodedFile),
                            $"{plainSlotValue.SlotName}_{exportBuilder.Files.Count}.pdf");
                        exportBuilder.AddFile(fileAsPdf.ToBase64());
                        continue;
                    }

                    exportBuilder.AddFile(jsonElement.GetString()!);
                }
            }
        }

        var bearbeitungen = await db.Bearbeitungen
            .AsSingleQuery()
            .Where(b => b.AusfuehrungId == walker.Ausfuehrung.Id)
            .OrderBy(b => b.CreatedAt)
            .Include(b => b.Schritt)
            .ThenInclude(s => ((FormularSchritt)s).Felder.OrderBy(f => f.Order))
            .Include(b => b.User)
            .Include(b => b.SlotValues)
            .ToListAsync();

        var (primaryColor, logoUrl) =
            await kommuneDesignService.GetKommuneDesign(walker.Prozess.KommuneId);

        var zustaendigkeit = await PdfZustaendigkeit.Load(db, walker.Ausfuehrung.IstZustaendigkeit);
        var ausfuehrungHtml = await AusfuehrungHtml.AusfuehrungToHtml(walker.Ausfuehrung.Id, walker.Prozess.Name,
            zustaendigkeit, bearbeitungen, blazorRenderer, staticMapService, primaryColor, logoUrl);

        var ausfuehrungPdf = await pdfGenerator.HtmlToPdf(ausfuehrungHtml, "antrag.pdf");

        var antragPdf = exportBuilder.Files.Count != 0
            ? await pdfGenerator.Merge([ausfuehrungPdf, .. exportBuilder.Files.Values], "antrag.pdf")
            : ausfuehrungPdf;

        exportBuilder.AddAntrag(antragPdf);

        var fileNames = exportBuilder.Files.Keys;
        var jsonPart = jsonParts.FirstOrDefault() ?? new JsonPart(new JsonObject([]));
        var json = ToJsonNode(jsonPart.Value, slotValues);
        json["_requestId"] = govManagerRequest.Id;
        json["_attachments"] = JsonSerializer.SerializeToNode(fileNames);
        exportBuilder.AddJson(JsonSerializer.Serialize(json));

        request.Content = exportBuilder.Build();
        request.Headers.Authorization = new AuthenticationHeaderValue("Basic",
            Convert.ToBase64String(Encoding.UTF8.GetBytes($"{options.Username}:{options.Password}")));

        HttpResponseMessage response;
        string responseBody;
        try {
            response = await client.SendAsync(request);
            responseBody = await response.Content.ReadAsStringAsync();
        } catch (Exception) {
            try {
                await CompleteGovManagerRequest(db, govManagerRequest, false, "Transport error");
            } catch (Exception dbEx) {
                logger.LogError(dbEx, "Failed to record transport error for GovManagerRequest {id}", govManagerRequest.Id);
            }
            throw;
        }

        var isPermanent = !response.IsSuccessStatusCode && (int)response.StatusCode is >= 400 and < 500;
        var storedBody = isPermanent ? $"{PermanentFailurePrefix}{responseBody}" : responseBody;
        await CompleteGovManagerRequest(db, govManagerRequest, response.IsSuccessStatusCode, storedBody);

        if (!response.IsSuccessStatusCode) {
            logger.LogError(
                "GovManager Export failed: AusfuehrungId={ausfuehrungId}, Status={statusCode}, Permanent={isPermanent}, Response={responseBody}",
                walker.Ausfuehrung.Id, response.StatusCode, isPermanent, responseBody);

            throw new Exception($"GovManager REST export failed with status code {response.StatusCode}.");
        }

        var content = JsonSerializer.Deserialize<GovManagerResponse>(responseBody);
        if (content == null) {
            logger.LogError(
                "GovManager Export failed: AusfuehrungId={ausfuehrungId}, could not deserialize response: {responseBody}",
                walker.Ausfuehrung.Id, responseBody);
            throw new Exception("GovManager REST export returned unparseable response.");
        }

        logger.LogInformation(
            "GovManager Export succeeded: AusfuehrungId={ausfuehrungId}, GovManagerId={govManagerId}, UploadStatus={uploadStatus}",
            walker.Ausfuehrung.Id, content.Id, content.UploadStatus);

        walker.Step(SystemUser.UserId, walker.CurrentVerbindungen[0].Id,
            new List<SlotValuesInput> {
                new("id", JsonValue.Create(content.Id)),
                new("requestId", JsonValue.Create(govManagerRequest.Id)),
                new("uploadStatus", JsonValue.Create(content.UploadStatus)),
            }, null);
        await walker.SaveChangesAsync();

    }

    /// <summary>Konvertiert ein JSON-Objekt mit Slots in ein JsonNode unter Verwendung der aktuellen Slotwerte.</summary>
    /// <param name="jsonPart">Das JSON-Objekt mit möglichen Slot-Platzhaltern.</param>
    /// <param name="slotValues">Die aktuellen Werte der Slots.</param>
    /// <returns>Das konvertierte JsonNode-Objekt.</returns>
    private JsonNode ToJsonNode(IJsonValueWithSlots jsonPart, IReadOnlyDictionary<string, SlotValue> slotValues) {
        return jsonPart switch {
            JsonObject jsonObject => new System.Text.Json.Nodes.JsonObject(
                jsonObject.Fields
                    .GroupBy(f => f.Name)
                    .Select(g => new KeyValuePair<string, JsonNode?>(g.Key, ToJsonNode(g.Last().Value, slotValues)))),
            JsonStringValue jsonStringValue => JsonValue.Create(jsonStringValue.Value),
            JsonSlotValue jsonSlotValue => slotValues.TryGetValue(jsonSlotValue.SlotName, out var slotValue) &&
                                           slotValue is PlainSlotValue plainSlotValue
                ? JsonNode.Parse(plainSlotValue.Value.GetRawText())!
                : JsonValue.Create((object?)null)!,
            _ => throw new ArgumentOutOfRangeException(nameof(jsonPart))
        };
    }

    private static async Task CompleteGovManagerRequest(DomainContext db, GovManagerRequest govManagerRequest, bool success, string responseBody) {
        govManagerRequest.Success = success;
        govManagerRequest.CompletedAt = DateTimeOffset.UtcNow;
        govManagerRequest.ResponseBody = responseBody;
        await db.SaveChangesAsync();
    }

    private record GovManagerResponse(string UploadStatus, int Id);
}

/// <summary>Ermöglicht die Registrierung des GovManagerRestExportRunner im DI-Container mit Zeitplan.</summary>
public static class GovManagerRestExportRunnerServiceExtensions {
    /// <summary>Registriert den Runner und plant die Ausführung alle zehn Sekunden.</summary>
    /// <param name="services">Die Service-Sammlung zur Erweiterung.</param>
    /// <returns>Die erweiterte Service-Sammlung.</returns>
    public static IServiceCollection AddGovManagerRestExportRunner(this IServiceCollection services) {
        const string everyTenSeconds = "0/10 * * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz => quartz.ScheduleJob<GovManagerRestExportRunner>(everyTenSeconds, fireImmediate: true));

        return services;
    }
}
